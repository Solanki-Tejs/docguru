import mysql.connector

def database():
    return mysql.connector.connect(
        host="localhost",
        username="root",
        password="root@1023",
        database="docguru"
    )
    pass
