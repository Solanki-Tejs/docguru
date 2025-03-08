from fastapi import FastAPI, Response, status,File, UploadFile,Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from init import load_document, chunks_embedding, retriving, vector_init, split_docs_into_chunks
from chatAgent import chatAgent
from pydantic import BaseModel
from database import database
from typing import List,Optional,Dict
from dotenv import load_dotenv
from email.message import EmailMessage
import jwt,os,random,smtplib,shutil,requests,json,time

app=FastAPI()
load_dotenv()

key=os.getenv("key")
algorithm=os.getenv("algorithm")
from_email=os.getenv("EMAIL")
UploadDirectory = os.getenv("uploads")
URL=os.getenv("URL")


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class details(BaseModel):
    name:Optional[str]=None
    email:Optional[str]=None
    password:Optional[str]=None
    token:Optional[str]=None 
    message: Optional[str]=None
    collactionName: Optional[str]=None
    pass

if not os.path.exists(UploadDirectory):
    os.makedirs(UploadDirectory)


def create_jwt(email):
    playlod={
        "email":email
    }
    token=jwt.encode(playlod,key,algorithm=algorithm)
    return token
    pass


def decode_jwt(token):
    token_data=jwt.decode(token,key,algorithms=algorithm)
    print(token_data)
    return token_data["email"]
    pass

def fatch_id(email):
    db=database()
    try:
        con=db.cursor()
        query=f"select * from user_detail where email='{email}'"
        con.execute(query)
        row=con.fetchone()
        print(row)
        return row[0]
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        # return {"status":"500","msg":"Internal Server Error"}
    finally:
        con.close()
    pass

def send_email(to_mail):
    otp=""
    for i in range(6):
        otp+=str(random.randint(0,9))
    print(otp)
    try:
        server =smtplib.SMTP("smtp.gmail.com",587)
        server.starttls()

        server.login(from_email,'lawu kajy csyi hszy')

        msg=EmailMessage()
        msg["subject"]="opt verification"
        msg["from"]=from_email
        msg["to"]=to_mail
        msg.set_content("opt :"+otp)
        server.send_message(msg)
        return otp
    except Exception as e:
        print(e)
        return None
    pass



@app.post("/SignIn")
async def SignIn(response: Response, data:details):
    db=database()
    
    try:
        con=db.cursor()
        query=f"select * from user_detail where email='{data.email}'"
        con.execute(query)
        row=con.fetchone()
        print(row)
        if row == None:
            response.status_code = status.HTTP_404_NOT_FOUND
            # return {"status":"404","msg":"user not found"}
        else:
            row={"id":row[0],"name":row[1],"email":row[2],"password":row[3]}
            token=create_jwt(data.email)
            if(data.password==row["password"]):
                return {"msg":"Successful","token":token}
            else:
                print("hello")
                response.status_code = status.HTTP_401_UNAUTHORIZED
                # return {"status":"403","msg":"Password dont match"}
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        # return {"status":"500","msg":"Internal Server Error"}
    finally:
        con.close()
    pass

@app.post("/EmailVeri")
async def EmailVeri(response: Response, data:details):
    otp=send_email(data.email)
    if(otp!=None):
        return {"msg":"Successful","otp":otp}
    else:
        response.status_code = status.HTTP_403_FORBIDDEN
        # return {"status":"403","msg":"Unsuccessful"}
    pass

@app.post("/SignUp")
async def SignUp(response: Response ,data:details):
    db=database()
    try:
        con=db.cursor()
        query=f"select * from user_detail where email='{data.email}'"
        con.execute(query)
        row=con.fetchone()
        print(row)
        query=f"insert into user_detail(name,email,password) values('{data.name}','{data.email}','{data.password}');"
        con.execute(query)
        db.commit()
        token=create_jwt(data.email)
        return {"msg":"Successful","token":token}
    except Exception as e:
        print(e) 
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR  
        # return {"status":"500","msg":"Internal Server Error"}
    finally:
        con.close()
    pass

@app.post("/EmailCheck")
async def EmailCheck(response: Response,data:details):
    db=database()
    try:
        con=db.cursor()
        query=f"select * from user_detail where email='{data.email}'"
        con.execute(query)
        row=con.fetchone()
        print(row)
        if row is not None:
            response.status_code = status.HTTP_403_FORBIDDEN
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        # return {"status":"500","msg":"Internal Server Error"}
    finally:
        con.close()
    pass

@app.post("/ResetPass")
async def Reset_pass(response: Response ,data:details):
    db=database()
    try:
        con=db.cursor()
        query=f"UPDATE user_detail SET password='{data.password}' WHERE email='{data.email}'"
        con.execute(query)
        db.commit()
        return {"msg":"Successfully reset your password"}
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        # return {"status":"500","msg":"Internal Server Error"}
    finally:
        con.close()
    pass

async def InsertPdf(response: Response,uid,name):
    db=database()
    try:
        con=db.cursor()
        query=f"INSERT INTO pdf_detail (ui, name) VALUES ({uid}, '{name}');"
        con.execute(query)
        db.commit()
        query="SELECT (pdf_id) FROM pdf_detail ORDER BY pdf_id DESC LIMIT 1;"
        con.execute(query)
        row=con.fetchone()
        return row[0]
    except Exception as e:
        print(e) 
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR  
        # return {"status":"500","msg":"Internal Server Error"}
    finally:
        con.close()
    pass


async def insert_embedding_details(collection_name,uid,pdfid):
    db=database()
    try:
        con=db.cursor()
        query=f"insert into vectordb_detail(collection_name,uid,pdf_id) values('{collection_name}',{uid},{pdfid});"
        con.execute(query)
        db.commit()
    except Exception as e:
        print(e) 
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR  
        # return {"status":"500","msg":"Internal Server Error"}
    finally:
        con.close()
    pass



@app.post("/UploadPdf")
async def UploadPdf(response: Response,token: str = Form(...),file: UploadFile = File(...)):
    print("upload")
    try:
        email=decode_jwt(token)
        uid=fatch_id(email)
        pdfid=await InsertPdf(response,uid=uid,name=file.filename)
        file_location = os.path.join(UploadDirectory, (f"pdf{pdfid}_"+f"ui{uid}"+".pdf"))
        with open(file_location, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
            
        print("uploading ended")
            
        # LLM
        docs = load_document(file_location)
        chunks = split_docs_into_chunks(docs)
        collection_name = (f"pdf{pdfid}_"+f"ui{uid}")
        vectorDB_loc = f"{uid}"
        db = vector_init(collection_name, vectorDB_loc)
        chunks_embedding(chunks, db)
        await insert_embedding_details(collection_name,uid,pdfid)
        return {"message": "File uploaded successfully","collactionName":collection_name}
    except Exception as e:
        # Handle any errors
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return {"message": "File uploaded was not successfully"}
    pass 

async def stream_answer(message: str):
    print("msg")
    db = vector_init(collection_name, uid)
    response = retriving(db)
    
    
    data = {
        'model': 'llama3',
        'prompt': message,
        'stream': True  # Important: Ensure the API streams the response
    }

    with requests.post(URL, json=data, stream=True) as r:
        for line in r.iter_lines():
            if line:
                try:
                    response_json = json.loads(line)
                    yield response_json.get("response", "")  # Send each chunk as received
                    time.sleep(0.05)  # Optional delay for better UX
                except json.JSONDecodeError:
                    continue


def returnChunks(collection_name, message,uid):
    # collection_name = (f"pdf{pdfid}_"+f"ui{uid}")
    vectorDB_loc = f"{uid}"
    db = vector_init(collection_name, "2")
    response = retriving(db, message)
    return response, db

@app.post("/chat")
async def chat(request: details):
    
    # chat -> message -> collection_nmae, uid -> db -> docs -> llm -> 
    # token ,pdf,msg -> 
    
    print("chat")
    print(request.collactionName)
    if not request.message:
        response.status_code = status.HTTP_400_BAD_REQUEST
    
    # return StreamingResponse(stream_answer(request.message), media_type="text/plain")
    # return "hello"
    
    collectionName = request.collactionName
    print(collectionName)
    message = request.message
    email=decode_jwt(request.token)
    uid=fatch_id(email)
    # response, db = returnChunks(collectionName, message)
    # print('response_chunks = ', response)
    start_time = time.time()
    db = vector_init(request.collactionName, f"{uid}")
    print(f"Vector DB initialized in: {time.time() - start_time:.2f} seconds")
    # print(StreamingResponse(chatAgent(db, message), media_type="text/plain"))
    return StreamingResponse(chatAgent(db, message), media_type="application/json; charset=utf-8")

    # return chatAgent(db, message)
    # return StreamingResponse(stream_answer(response), media_type="text/plain")


@app.get("/")
def main():
    return {"msg":"hello world!"}
    pass