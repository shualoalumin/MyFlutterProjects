import tensorflow as tf
from tensorflow.keras.applications.vgg16 import VGG16, preprocess_input, decode_predictions
from tensorflow.keras.preprocessing.image import img_to_array
from PIL import Image
import numpy as np
import io

# VGG 모델 로드
model = VGG16(weights='imagenet')

def evaluate_image(image_bytes):
    # 이미지 로드 및 전처리
    image = Image.open(io.BytesIO(image_bytes))
    image = image.resize((224, 224))
    np_img = img_to_array(image)
    img_batch = np.expand_dims(np_img, axis=0)
    pre_processed = preprocess_input(img_batch)
    
    # 예측
    y_preds = model.predict(pre_processed)
    np.set_printoptions(suppress=True, precision=5)
    result = decode_predictions(y_preds, top=1)
    result = {"predicted_label": str(result[0][0][1]), "prediction_score": float(result[0][0][2])}
    return result