import mysql.connector

def database():
    return mysql.connector.connect(
        host="localhost",
        username="root",
        password="Solanki",
        database="docguru"
    )
    pass
