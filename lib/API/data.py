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
import pandas as pd
from email.message import EmailMessage
import jwt,os,random,smtplib,shutil,requests,json,time,re,fitz,pdfplumber

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
    FAQque:Optional[str]=None
    FAQans:Optional[str]=None
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

        server.login(from_email,'ocaz gaao keto ustc')

        msg=EmailMessage()
        msg["subject"]="Secure Your Action – Your DocGuru OTP Code"
        msg["from"]=from_email
        msg["to"]=to_mail
        msg.set_content(f"""Dear {to_mail},\n\n\nTo ensure the security of your account, we have generated a One-Time Password (OTP) for your verification request.\n\n🔑 Your OTP: {otp}\n\nPlease do not share this code with anyone.\nIf you did not request this verification, please ignore this email.\nFor any assistance, feel free to contact our support team.\n\nBest regards,\nDocGuru Team""")
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


def extract_pdf_metadata(file_path: str, name: str):
    try:
        # Extract file size
        file_size = os.path.getsize(file_path) / (1024 * 1024)  # Convert to MB

        # Extract number of pages using PyMuPDF
        doc = fitz.open(file_path)
        num_pages = len(doc)

        # Extract text and word count using pdfplumber
        total_text = ""
        with pdfplumber.open(file_path) as pdf:
            for page in pdf.pages:
                total_text += page.extract_text() or ""  # Extract text safely

        word_count = len(total_text.split())

        print(file_size, num_pages, word_count, name)
        
        # Connect to the database
        db = database()  # Assuming 'database()' returns a valid DB connection object
        
        # Create cursor and execute query
        con = db.cursor()  # Remove the comma to fix the issue
        query = f"INSERT INTO pdf_meta (name, size, num_pages, word_count) VALUES ('{name}', {file_size}, {num_pages}, {word_count});"
        con.execute(query)
        db.commit()
        
    except Exception as e:
        print(f"Error extracting PDF metadata: {e}")
        return 0, 0, 0  # Return default values in case of an error



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
            
        extract_pdf_metadata(file_path=file_location,name=file.filename)
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
        query = "INSERT INTO feedback_detail(uid, msg, star, time) VALUES (%s, %s, %s, %s)"
        values = (uid, data.feedbackMSG, float(data.star), datetime.datetime.now())

        con.execute(query, values)
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
        'stream': True 
    }

    with requests.post(URL, json=data, stream=True) as r:
        for line in r.iter_lines():
            if line:
                try:
                    response_json = json.loads(line)
                    yield response_json.get("response", "") 
                    time.sleep(0.05) 
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
        numbers = re.findall(r'\d+', data.collactionName)  
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
                data = json.load(file) 
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


@app.post("/addFAQ")
async def addFAQ(data:details,response: Response):
    db=database()
    try:
        con=db.cursor()
        # query=f"insert into faq(question,answer) values('{data.FAQque}','{data.FAQans}');"
        query = "INSERT INTO faq (question, answer) VALUES (%s, %s);"
        con.execute(query, (data.FAQque, data.FAQans))
        # con.execute(query)
        db.commit()
    except Exception as e:
        print(e) 
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR  
        # return {"status":"500","msg":"Internal Server Error"}
    finally:
        con.close()
    pass

@app.post("/deleteFAQ")
async def delete_faq(data: details,response: Response):
    db = database()
    try:
        con = db.cursor()
        query = "DELETE FROM faq WHERE question = %s;"
        con.execute(query, (data.FAQque,))
        db.commit()

        if con.rowcount == 0:
            response.status_code = status.HTTP_404_NOT_FOUND

        return {"status": "200", "message": "FAQ deleted successfully"}
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
    finally:
        con.close()


@app.get("/get_pdf_metadata")
async def get_pdf_metadata():
    db = database()
    try:
        con = db.cursor()
        query = "SELECT * FROM pdf_meta"
        con.execute(query)
        rows = con.fetchall() 

        pdf_list = []
        print(rows)
        for row in rows:
            pdf_list.append({
                "name": row[1],
                "size": f"{row[2]} MB",
                "pagenum": row[3],
                "count": row[4] 
            })
        return {"pdflist":pdf_list} 

    except Exception as e:
        print(e)
        con.close()
        return {"error": "An error occurred while fetching the metadata."} 


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
        con.close()




@app.get("/getfaq")
async def showfb(response: Response):
    db = database()
    try:
        con = db.cursor()
        query = "SELECT * FROM faq;"
        con.execute(query)
        rows = con.fetchall() 

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
        con.close()  




@app.get("/getpdfdetail")
async def getpdfdetail(response: Response):
    db = database()
    try:
        con = db.cursor()
        query = "SELECT * FROM pdf_detail;"
        con.execute(query)
        rows = con.fetchall() 
        totalpdf=len(rows)
        print(rows)
        pdf_detail=[]
        if not rows:
            response.status_code = status.HTTP_404_NOT_FOUND
            return {"msg": 'hello'}
        for row in rows:
            pdf_detail.append({
                "pdf_id":row[0],
                "uid":row[1],
                "pdf_name":row[2],
                "timedata":row[3], 
            })        
        
        print(pdf_detail)
        df = pd.DataFrame(pdf_detail)
        df["timedata"] = pd.to_datetime(df["timedata"])
        uploads_per_day = df.groupby(df["timedata"].dt.date).size()
        print("PDF uploads per day:\n", uploads_per_day)
        uploads_per_week = df.groupby(df["timedata"].dt.to_period("W")).size()
        print("\nPDF uploads per week:\n", uploads_per_week)
        print(uploads_per_week)

        print(totalpdf)
        query = "SELECT * FROM user_detail;"
        con.execute(query)
        rows = con.fetchall()
        totaluser=len(rows)
        print(totaluser)

        return {"msg": "hello","perday":uploads_per_day.tolist(),"perweek":uploads_per_week.tolist(),"totalpdf":totalpdf,"totaluser":totaluser}
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return {"status": "500", "msg": "Internal Server Error"}

    finally:
        con.close()
    pass

def load_log_data():
    with open("log.json", "r") as file:
        return json.load(file)

# @app.get("/stats")
# def get_stats():
#     log_data = load_log_data()

#     # If log_data is empty, return zero for all stats
#     if not log_data:
#         return {
#             "average_startResponseTime": 0,
#             "average_endResponseTime": 0,
#             "unique_users_online": 0
#         }

#     current_time = datetime.datetime.now()

#     # Initialize variables
#     total_start_time = 0
#     total_end_time = 0
#     valid_entries = 0  # To count valid entries for averaging
#     user_set = set()

#     # Define 5-minute window
#     five_minutes_ago = current_time - datetime.timedelta(minutes=5)

#     # Loop through the log data
#     for entry in log_data:
#         try:
#             # Parse the datetime string into a datetime object
#             log_time = datetime.datetime.strptime(entry["datetime"], "%Y-%m-%d %H:%M:%S.%f")

#             # Check if the log entry is within the last 5 minutes
#             if log_time >= five_minutes_ago:
#                 user_set.add(entry["uid"])

#             # Convert response times to integers, only if valid
#             if entry.get("startResponseTime").isdigit() and entry.get("endResponseTime").isdigit():
#                 total_start_time += int(entry["startResponseTime"])
#                 total_end_time += int(entry["endResponseTime"])
#                 valid_entries += 1
#         except ValueError as e:
#             # Handle cases where parsing or conversion fails
#             print(f"Skipping entry due to error: {e} in {entry}")

#     # Calculate averages based on valid entries
#     avg_start_time = total_start_time / valid_entries if valid_entries > 0 else 0
#     avg_end_time = total_end_time / valid_entries if valid_entries > 0 else 0
#     unique_users_online = len(user_set)

#     return {
#         "average_startResponseTime": avg_start_time,
#         "average_endResponseTime": avg_end_time,
#         "unique_users_online": unique_users_online
#         "total_quesion_ask"
#     }

@app.get("/stats")
def get_stats():
    log_data = load_log_data()

    # If log_data is empty, return zero for all stats
    if not log_data:
        return {
            "total_questions_asked_today": 0,
            "unique_users_online": 0
        }

    current_time = datetime.datetime.now()

    # Initialize variables
    total_questions_today = 0
    user_set = set()

    # Define start of the day
    start_of_day = current_time.replace(hour=0, minute=0, second=0, microsecond=0)

    # Loop through the log data
    for entry in log_data:
        try:
            # Parse the datetime string into a datetime object
            log_time = datetime.datetime.strptime(entry["datetime"], "%Y-%m-%d %H:%M:%S.%f")

            # Check if the log entry is today
            if log_time >= start_of_day:
                total_questions_today += 1
                user_set.add(entry["uid"])
        except ValueError as e:
            # Handle cases where parsing or conversion fails
            print(f"Skipping entry due to error: {e} in {entry}")

    unique_users_online = len(user_set)

    return {
        "total_questions_asked_today": total_questions_today,
        "unique_users_online": unique_users_online
    }


@app.get("/endChat")
async def stop():
    stop_generation()
    print("top_generation")

@app.get("/")
def main():
    return {"msg":"hello world!"}
    pass

