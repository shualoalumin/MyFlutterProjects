from fastapi import FastAPI, File, UploadFile, Form
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from vgg16_prediction_model import evaluate_image
import requests

app = FastAPI()

# CORS 설정
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],  
    allow_headers=["*"],  
)

@app.post("/upload/")
async def upload_image(file: UploadFile = File(None), url: str = Form(None)):
    if file:
        contents = await file.read()
    elif url:
        response = requests.get(url)
        contents = response.content
    else:
        return JSONResponse(content={"error": "No file or URL provided"}, status_code=400)
    
    result = evaluate_image(contents)
    return JSONResponse(content={"result": result})

if __name__ == "__main__":
    uvicorn.run("server_fastapi_vgg16:app", host="127.0.0.1", port=8000, reload=True)
