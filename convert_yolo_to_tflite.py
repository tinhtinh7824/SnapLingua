#!/usr/bin/env python3
"""
Convert YOLOv10 to TensorFlow Lite using Ultralytics built-in export
This approach is much simpler and more reliable than manual conversion
"""

import os
import sys

def convert_using_ultralytics():
    """Convert YOLOv10 to TFLite using Ultralytics built-in export"""
    try:
        print("🚀 Installing/checking ultralytics package...")
        os.system("pip install ultralytics --quiet")

        # Import after installation
        from ultralytics import YOLO

        print("✅ Ultralytics imported successfully")

        # Check if we have the original PyTorch model
        pt_model_path = "/Users/admin/Desktop/vocab-snap/yolov10n.pt"
        if not os.path.exists(pt_model_path):
            print(f"❌ PyTorch model not found: {pt_model_path}")
            # Try to download YOLOv10n
            print("🔄 Downloading YOLOv10n model...")
            model = YOLO("yolov10n.pt")
        else:
            print(f"📁 Loading existing model: {pt_model_path}")
            model = YOLO(pt_model_path)

        print("🔄 Converting to TensorFlow Lite...")

        # Export to TFLite with optimization
        tflite_path = model.export(
            format='tflite',
            imgsz=640,  # Input size 640x640
            int8=False,  # Use float16 instead of int8 to avoid quantization issues
            optimize=True,
        )

        print(f"✅ Model exported successfully!")
        print(f"📁 TFLite model location: {tflite_path}")

        # Copy to our assets folder
        target_path = "/Users/admin/Desktop/snaplingua/assets/ml_models/model.tflite"
        os.system(f"cp '{tflite_path}' '{target_path}'")

        print(f"📋 Copied to: {target_path}")

        # Check file size
        file_size = os.path.getsize(target_path)
        print(f"📏 Model size: {file_size / (1024*1024):.2f} MB")

        return True

    except ImportError as e:
        print(f"❌ Failed to import ultralytics: {e}")
        return False
    except Exception as e:
        print(f"❌ Conversion failed: {e}")
        return False

def main():
    print("🎯 Converting YOLOv10 to TensorFlow Lite using Ultralytics")
    print("=" * 60)

    success = convert_using_ultralytics()

    if success:
        print("\n🎉 SUCCESS! TensorFlow Lite model ready for use.")
        print("\n📱 Next steps:")
        print("   1. Restart the Flutter app")
        print("   2. Test camera detection")
        print("   3. Should see real object detection instead of demo mode")
    else:
        print("\n❌ Conversion failed. Alternative options:")
        print("   1. Online converter: https://convertmodel.com/")
        print("   2. Google Colab with clean environment")
        print("   3. Contact support for pre-converted model")

if __name__ == "__main__":
    main()