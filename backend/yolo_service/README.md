# SnapLingua YOLO Service

Python backend service sử dụng YOLOv10 để nhận diện đối tượng trong ảnh và trả về từ vựng.

## Cài đặt

```bash
# Tạo virtual environment
python3 -m venv venv
source venv/bin/activate  # macOS/Linux
# venv\Scripts\activate  # Windows

# Cài dependencies
pip install -r requirements.txt
```

## Chạy service

```bash
python main.py
```

Service sẽ chạy tại `http://localhost:8001`

## API Endpoints

### POST /predict
Upload ảnh và nhận kết quả detection

**Request:**
- Form data với file ảnh (key: `file`)

**Response:**
```json
{
  "detections": [
    {"class": "person", "confidence": 0.95},
    {"class": "car", "confidence": 0.87}
  ],
  "processed_image_url": "http://10.0.2.2:8001/static/detected_image.jpg"
}
```

### GET /static/{filename}
Lấy ảnh đã được vẽ bounding boxes
