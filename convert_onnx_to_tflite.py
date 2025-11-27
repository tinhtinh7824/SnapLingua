#!/usr/bin/env python3
"""
Convert YOLOv10 ONNX model to TensorFlow Lite using tf2onnx approach
"""

import os
import sys
import tensorflow as tf
import onnx
from onnx_tf.backend import prepare

def convert_onnx_to_tflite(onnx_path, tflite_path):
    """Convert ONNX model to TensorFlow Lite"""
    try:
        print(f"🔄 Loading ONNX model from {onnx_path}")

        # Load ONNX model
        onnx_model = onnx.load(onnx_path)

        print("✅ ONNX model loaded successfully")
        print(f"📊 Model input shape: {onnx_model.graph.input[0].type.tensor_type.shape}")

        # Convert to TensorFlow
        print("🔄 Converting ONNX to TensorFlow...")
        tf_rep = prepare(onnx_model)

        # Export to SavedModel format first
        saved_model_path = tflite_path.replace('.tflite', '_saved_model')
        print(f"💾 Exporting to SavedModel format: {saved_model_path}")
        tf_rep.export_graph(saved_model_path)

        # Convert to TensorFlow Lite
        print("🔄 Converting to TensorFlow Lite...")
        converter = tf.lite.TFLiteConverter.from_saved_model(saved_model_path)

        # Optimization settings for mobile deployment
        converter.optimizations = [tf.lite.Optimize.DEFAULT]
        converter.target_spec.supported_types = [tf.float16]

        # Convert
        tflite_model = converter.convert()

        # Save TFLite model
        print(f"💾 Saving TFLite model to {tflite_path}")
        with open(tflite_path, 'wb') as f:
            f.write(tflite_model)

        print("✅ Conversion completed successfully!")

        # Model info
        file_size = os.path.getsize(tflite_path)
        print(f"📏 TFLite model size: {file_size / (1024*1024):.2f} MB")

        return True

    except Exception as e:
        print(f"❌ Conversion failed: {e}")
        return False

def main():
    # File paths
    onnx_path = "/Users/admin/Desktop/snaplingua/assets/models/yolov10n.onnx"
    tflite_path = "/Users/admin/Desktop/snaplingua/assets/ml_models/model.tflite"

    if not os.path.exists(onnx_path):
        print(f"❌ ONNX model not found: {onnx_path}")
        sys.exit(1)

    print("🚀 Starting YOLOv10 ONNX → TensorFlow Lite conversion")
    print(f"📥 Input:  {onnx_path}")
    print(f"📤 Output: {tflite_path}")
    print("-" * 50)

    success = convert_onnx_to_tflite(onnx_path, tflite_path)

    if success:
        print("\n🎉 Conversion completed! You can now test the camera detection.")
    else:
        print("\n💡 If this conversion fails, try the online converter:")
        print("   1. Go to https://convertmodel.com/")
        print("   2. Upload yolov10n.onnx")
        print("   3. Convert ONNX → TensorFlow Lite")
        print("   4. Download and place in assets/ml_models/model.tflite")

if __name__ == "__main__":
    main()