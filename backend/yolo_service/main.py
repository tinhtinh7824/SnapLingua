import os
import cv2
import numpy as np
from fastapi import FastAPI, UploadFile, File
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
from ultralytics import YOLO
import uvicorn

app = FastAPI(title="SnapLingua YOLO Service")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

STATIC_DIR = "static"
os.makedirs(STATIC_DIR, exist_ok=True)

# Load YOLO model once at startup
print("Loading YOLOv8 model...")
model = YOLO("yolov8m.pt")  # YOLOv8 medium model - sẽ tự động tải xuống lần đầu
print("Model loaded successfully!")

@app.get("/")
async def root():
    return {"message": "SnapLingua YOLO Service is running"}

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """
    Nhận ảnh upload, detect objects bằng YOLOv10,
    trả về danh sách từ vựng và URL ảnh đã được vẽ bounding boxes
    """
    try:
        # Read và decode ảnh
        contents = await file.read()
        np_img = np.frombuffer(contents, np.uint8)
        image = cv2.imdecode(np_img, cv2.IMREAD_COLOR)

        if image is None:
            return {"error": "Cannot decode image"}

        # Apply Gaussian Blur để giảm noise
        image = cv2.GaussianBlur(image, (3, 3), 0)

        # Run YOLO prediction
        results = model.predict(source=image, imgsz=640, conf=0.2)

        # Extract detections
        detections = []
        for result in results:
            for box in result.boxes:
                class_name = result.names[int(box.cls)]
                confidence = float(box.conf)
                detections.append({
                    "class": class_name,
                    "confidence": confidence
                })

        # Vẽ bounding boxes lên ảnh
        detected_image_filename = "detected_image.jpg"
        detected_image_path = os.path.join(STATIC_DIR, detected_image_filename)
        processed_image = results[0].plot()
        cv2.imwrite(detected_image_path, processed_image, [cv2.IMWRITE_JPEG_QUALITY, 95])

        # Trả về kết quả
        # Note: Sử dụng IP của máy thật thay vì 10.0.2.2 khi chạy trên máy thật
        return {
            "detections": detections,
            "processed_image_url": f"http://10.0.2.2:8001/static/{detected_image_filename}"
        }

    except Exception as e:
        return {"error": str(e)}

@app.get("/static/{filename}")
async def get_static_file(filename: str):
    """Serve static files (ảnh đã được detect)"""
    path = os.path.join(STATIC_DIR, filename)
    if os.path.exists(path):
        return FileResponse(path)
    return {"error": "File not found"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
