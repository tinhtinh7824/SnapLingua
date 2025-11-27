#!/usr/bin/env python3
"""
Debug YOLOv8 TFLite model structure to understand input/output shapes
"""

import numpy as np

def analyze_tflite_model(model_path):
    """Analyze TFLite model structure"""
    try:
        import tensorflow as tf

        # Load TFLite model
        interpreter = tf.lite.Interpreter(model_path=model_path)
        interpreter.allocate_tensors()

        # Get input details
        input_details = interpreter.get_input_details()
        output_details = interpreter.get_output_details()

        print("🔍 TFLite Model Analysis")
        print("=" * 50)

        print(f"📁 Model: {model_path}")
        print(f"📊 TensorFlow version: {tf.__version__}")

        print("\n📥 INPUT TENSORS:")
        for i, input_detail in enumerate(input_details):
            print(f"  Input {i}:")
            print(f"    Name: {input_detail['name']}")
            print(f"    Shape: {input_detail['shape']}")
            print(f"    Dtype: {input_detail['dtype']}")
            print(f"    Quantization: {input_detail['quantization']}")

        print("\n📤 OUTPUT TENSORS:")
        for i, output_detail in enumerate(output_details):
            print(f"  Output {i}:")
            print(f"    Name: {output_detail['name']}")
            print(f"    Shape: {output_detail['shape']}")
            print(f"    Dtype: {output_detail['dtype']}")
            print(f"    Quantization: {output_detail['quantization']}")

        # Test with dummy input
        print("\n🧪 Testing with dummy input...")
        input_shape = input_details[0]['shape']
        if input_shape[0] == -1:  # Dynamic batch size
            input_shape[0] = 1

        dummy_input = np.random.rand(*input_shape).astype(input_details[0]['dtype'])
        interpreter.set_tensor(input_details[0]['index'], dummy_input)

        try:
            interpreter.invoke()
            output_data = interpreter.get_tensor(output_details[0]['index'])
            print(f"✅ Model inference successful!")
            print(f"📊 Output shape: {output_data.shape}")
            print(f"📊 Output min/max: {output_data.min():.4f} / {output_data.max():.4f}")
        except Exception as e:
            print(f"❌ Model inference failed: {e}")

        return input_details, output_details

    except ImportError:
        print("❌ TensorFlow not available. Install with: pip install tensorflow")
        return None, None
    except Exception as e:
        print(f"❌ Error analyzing model: {e}")
        return None, None

def suggest_flutter_preprocessing(input_details):
    """Suggest Flutter preprocessing based on model input"""
    if not input_details:
        return

    input_shape = input_details[0]['shape']
    dtype = input_details[0]['dtype']

    print("\n💡 Flutter Preprocessing Recommendations:")
    print("-" * 40)

    if len(input_shape) == 4:
        if input_shape[1] == 3:  # NCHW format
            print("🔧 Model expects NCHW format (batch, channels, height, width)")
            print("   Preprocessing: Transpose HWC → CHW after resize")
            print("   Input format: [1, 3, 640, 640]")
        elif input_shape[3] == 3:  # NHWC format
            print("🔧 Model expects NHWC format (batch, height, width, channels)")
            print("   Preprocessing: Standard HWC format")
            print("   Input format: [1, 640, 640, 3]")

    if str(dtype) == "<class 'numpy.float32'>":
        print("🔧 Model expects float32 input")
        print("   Normalization: pixel / 255.0")
    elif str(dtype) == "<class 'numpy.uint8'>":
        print("🔧 Model expects uint8 input")
        print("   Normalization: pixel values 0-255")

def main():
    model_path = "/Users/admin/Desktop/snaplingua/assets/ml_models/yolov8n_float16.tflite"
    input_details, output_details = analyze_tflite_model(model_path)
    suggest_flutter_preprocessing(input_details)

if __name__ == "__main__":
    main()