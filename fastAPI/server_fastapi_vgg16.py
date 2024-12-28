from fastapi import FastAPI, File, UploadFile
from fastapi.responses import JSONResponse
import uvicorn
from vgg16_prediction_model import evaluate_image

app = FastAPI()

@app.post("/upload/")
async def upload_image(file: UploadFile = File(...)):
    contents = await file.read()
    result = evaluate_image(contents)
    return JSONResponse(content={"result": result})

if __name__ == "__main__":
    uvicorn.run("server_fastapi_vgg16:app", host="0.0.0.0", port=8000, reload=True)


# uvicorn server_fastapi_vgg16:app --reload --host 0.0.0.0 --port 8000