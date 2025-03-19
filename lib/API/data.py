import datetime
from fastapi import FastAPI, Response, status,File, UploadFile,Form
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import StreamingResponse
from init import load_document, chunks_embedding, retriving, vector_init, split_docs_into_chunks
from chatAgent import chatAgent,stop_generation
from pydantic import BaseModel
from database import database
from typing import List,Optional,Dict
from dotenv import load_dotenv
from email.message import EmailMessage
import jwt,os,random,smtplib,shutil,requests,json,time,re

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
    updatedName:Optional[str]=None
    email:Optional[str]=None
    password:Optional[str]=None
    token:Optional[str]=None 
    message: Optional[str]=None
    collactionName: Optional[str]=None
    star:Optional[str]=None
    feedbackMSG:Optional[str]=None
    que:Optional[str]=None
    ans:Optional[str]=None
    start: Optional[str] = None
    end: Optional[str] = None
    finish:Optional[str]=None
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

def fatch_email(id):
    db=database()
    try:
        con=db.cursor()
        query=f"select * from user_detail where uid='{id}'"
        con.execute(query)
        row=con.fetchone()
        print(row)
        return row[2]
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
                return {"msg":"Successful","token":token,"name":row["name"],"email":row["email"]}
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

@app.post("/feedback")
async def feedback(response: Response,data:details):
    db=database()
    try:
        email=decode_jwt(data.token)
        uid=fatch_id(email)
        con=db.cursor()
        query=f"insert into feedback_detail(uid,msg,star,time) values('{uid}','{data.feedbackMSG}','{float(data.star)}','{datetime.datetime.now()}');"
        con.execute(query)
        db.commit()
        return {"message": "feedback was successfully submited"}
    except Exception as e:
        print(e) 
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR  
        # return {"status":"500","msg":"Internal Server Error"}
    finally:
        con.close()
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
async def chat(response: Response,request: details):

    print("chat")
    print(request.collactionName)
    if not request.message:
        response.status_code = status.HTTP_400_BAD_REQUEST

    
    collectionName = request.collactionName
    print(collectionName)
    message = request.message
    email=decode_jwt(request.token)
    uid=fatch_id(email)
    start_time = time.time()
    db = vector_init(request.collactionName, f"{uid}")
    print(f"Vector DB initialized in: {time.time() - start_time:.2f} seconds")
    return StreamingResponse(chatAgent(db, request.message), media_type="text/plain")


@app.post("/addToJson")
async def addToJson(data:details):
    try:    
        print(data.collactionName)
        numbers = re.findall(r'\d+', data.collactionName)  # Find all groups of digits
        pid=numbers[0]
        uid=numbers[-1]
        print(numbers)
        new_data = {
            "uid": uid, 
            "pid": pid,
            "question": data.que,
            "answer":data.ans,
            "datetime":f"{datetime.datetime.now()}",
            "startResponseTime":data.start,
            "endResponseTime":data.end,
            "finish":data.finish}
        try:
            with open("log.json", "r") as file:
                data = json.load(file)  # Load existing data
        except (json.JSONDecodeError, FileNotFoundError):
            # print(e)
            data = []

        if isinstance(data, dict):  
            data = [data]

        data.append(new_data)
        
        with open("log.json", "w") as file:
            json.dump(data, file, indent=4)
    except Exception as e:
        print(e)
    pass

@app.post("/updateUserName")
async def getdata(response: Response,data:details):
    db=database()
    try:
        print("token")
        print(data.token)
        print(data.updatedName)
        email=decode_jwt(data.token)
        print(email)
        con=db.cursor()
        query=f"UPDATE user_detail SET name = '{data.updatedName}' WHERE email = '{email}'"
        con.execute(query)
        db.commit()
        return {"message": "Successfully Updated UserName"}
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
    finally:
        con.close()
    pass


@app.post("/getdata")
async def getdata(response: Response,data:details):
    db=database()
    try:
        print("token")
        print(data.token)
        email=decode_jwt(data.token)
        con=db.cursor()
        query=f"select * from user_detail where email='{email}'"
        con.execute(query)
        row=con.fetchone()
        print(row)
        if row == None:
            response.status_code = status.HTTP_404_NOT_FOUND
            # return {"status":"404","msg":"user not found"}
        else:
            row={"id":row[0],"name":row[1],"email":row[2],"password":row[3]}
            print(row)
            return {"message": "Successfully","name":row["name"],"email":row["email"],"pass":row["password"]}
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
    finally:
        con.close()
    pass


@app.get("/getfaq")
async def showfb(response: Response):
    db = database()
    try:
        con = db.cursor()
        query = "SELECT * FROM faq;"
        con.execute(query)
        rows = con.fetchall()  # Fetch all rows
        
        if not rows:
            response.status_code = status.HTTP_404_NOT_FOUND
            return {"status": "404", "msg": "No feedback found"}
        
        faq_list = []
        for row in rows:
            faq_list.append({
                "que": row[1],
                "ans": row[2],
                "isExpanded": False,
            })
        
        return {"message": "Successfully retrieved", "faqs": faq_list}
    
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return {"status": "500", "msg": "Internal Server Error"}
    
    finally:
        con.close()  # Close the connection after fetching all results

# @app.get("/showfb")
# async def showfb():
#     db=database()
#     try:
#         con=db.cursor()
#         query=f"select * from feedback_detail;"
#         con.execute(query)
#         row=con.fetchone()
#         print(row)
#         if row == None:
#             response.status_code = status.HTTP_404_NOT_FOUND
#             # return {"status":"404","msg":"user not found"}
#         else:
#             print(len(row))
#             row={"email":fatch_email(row[1]),"feedback":row[2],"star":row[3],"datetime":row[4]}
#             print(row)
#             # return {"message": "Successfully","name":row["name"],"email":row["email"],"pass":row["password"]}
#     except Exception as e:
#         print(e)
#         # response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
#     finally:
#         con.close()
#     pass

@app.get("/showfb")
async def showfb(response: Response):
    db = database()
    try:
        con = db.cursor()
        query = "SELECT * FROM feedback_detail;"
        con.execute(query)
        rows = con.fetchall()  # Fetch all rows
        
        if not rows:  # Check if the list is empty
            response.status_code = status.HTTP_404_NOT_FOUND
            return {"status": "404", "msg": "No feedback found"}
        
        feedback_list = []
        for row in rows:
            feedback_list.append({
                "email": fatch_email(row[1]),
                "feedback": row[2],
                "star": row[3],
                "datetime": row[4]
            })
        
        return {"message": "Successfully retrieved", "feedbacks": feedback_list}
    
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return {"status": "500", "msg": "Internal Server Error"}
    
    finally:
        con.close()  # Close the connection after fetching all results
  # Now close the connection




@app.get("/endChat")
async def stop():
    stop_generation()
    print("top_generation")

@app.get("/")
def main():
    return {"msg":"hello world!"}
    pass

