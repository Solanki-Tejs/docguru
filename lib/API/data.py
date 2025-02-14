from fastapi import FastAPI, Response, status,File, UploadFile,Form
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from database import database
from typing import List,Optional
from dotenv import load_dotenv
from email.message import EmailMessage
import jwt,os,random,smtplib,shutil

app=FastAPI()
load_dotenv()

key=os.getenv("key")
algorithm=os.getenv("algorithm")
from_email=os.getenv("EMAIL")
UploadDirectory = os.getenv("uploads")


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
    return token_data["email"]
    pass

def fatch_id(email):
    db=database()
    print(email)
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

@app.post("/UploadPdf")
async def UploadPdf(response: Response,token: str = Form(...),file: UploadFile = File(...)):
    try:
        email=decode_jwt(token)
        uid=fatch_id(email)
        pdfid=await InsertPdf(response,uid=uid,name=file.filename)
        file_location = os.path.join(UploadDirectory, (f"pdf{pdfid}_"+f"ui{uid}"+".pdf"))
        with open(file_location, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        return {"message": "File uploaded successfully"}
    except Exception as e:
        # Handle any errors
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return {"message": "File uploaded was not successfully"}
    pass 

@app.get("/")
def main():
    return {"msg":"hello world!"}
    pass