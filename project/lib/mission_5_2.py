from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from typing import List, Dict
from uuid import uuid4

app = FastAPI()

# 데이터 저장소
db = {
    "topics": {}
}

# 데이터 모델
class Option(BaseModel):
    id: str
    name: str
    votes: int = 0

class Topic(BaseModel):
    id: str
    title: str
    options: List[Option] = []

class CreateTopic(BaseModel):
    title: str

class AddOption(BaseModel):
    name: str

class Vote(BaseModel):
    option_id: str

# 주제 생성
@app.post("/topics", response_model=Topic)
def create_topic(topic: CreateTopic):
    topic_id = str(uuid4())
    new_topic = Topic(id=topic_id, title=topic.title)
    db["topics"][topic_id] = new_topic
    return new_topic

# 옵션 추가
@app.post("/topics/{topic_id}/options", response_model=Option)
def add_option(topic_id: str, option: AddOption):
    if topic_id not in db["topics"]:
        raise HTTPException(status_code=404, detail="Topic not found")
    option_id = str(uuid4())
    new_option = Option(id=option_id, name=option.name)
    db["topics"][topic_id].options.append(new_option)
    return new_option

# 투표
@app.post("/topics/{topic_id}/vote", response_model=Option)
def vote(topic_id: str, vote: Vote):
    if topic_id not in db["topics"]:
        raise HTTPException(status_code=404, detail="Topic not found")
    topic = db["topics"][topic_id]
    for option in topic.options:
        if option.id == vote.option_id:
            option.votes += 1
            return option
    raise HTTPException(status_code=404, detail="Option not found")

# 결과 조회
@app.get("/topics/{topic_id}/results", response_model=Dict[str, int])
def get_results(topic_id: str):
    if topic_id not in db["topics"]:
