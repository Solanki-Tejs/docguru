from fastapi import FastAPI, Response, status
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
from database import database
from typing import List,Optional
from dotenv import load_dotenv
from email.message import EmailMessage
import jwt,os,random,smtplib

app=FastAPI()
load_dotenv()

key=os.getenv("key")
algorithm=os.getenv("algorithm")
from_email=os.getenv("EMAIL")


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # You can specify your Flutter app URL here
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Post_SignIn(BaseModel):
    # name: str | None
    email: str | None
    password: str | None
    pass

class Post_SignUp(BaseModel):
    name: str | None
    email: str | None
    password: str | None
    pass

class Post_EmailVeri(BaseModel):
    email: str | None
    pass

class Update_detail(BaseModel):
    name:Optional[str]=None
    email:Optional[str]=None
    password:Optional[str]=None 
    pass


def create_jwt(email):
    playlod={
        "email":email
    }
    token=jwt.encode(playlod,key,algorithm=algorithm)
    return token
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
async def SignIn(response: Response, data:Post_SignIn):
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
                response.status_code = status.HTTP_403_FORBIDDEN
                # return {"status":"403","msg":"Password dont match"}
    except Exception as e:
        print(e)
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        # return {"status":"500","msg":"Internal Server Error"}
    finally:
        con.close()
    pass

@app.post("/EmailVeri")
async def EmailVeri(response: Response, data:Post_EmailVeri):
    otp=send_email(data.email)
    if(otp!=None):
        return {"msg":"Successful","otp":otp}
    else:
        response.status_code = status.HTTP_403_FORBIDDEN
        # return {"status":"403","msg":"Unsuccessful"}
    pass

@app.post("/SignUp")
async def SignUp(response: Response ,data:Post_SignUp):
    db=database()
    try:
        con=db.cursor()
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



@app.post("/ResetPass")
async def Reset_pass(response: Response ,data:Update_detail):
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


@app.get("/")
def main():
    return {"msg":"hello world!"}
    pass