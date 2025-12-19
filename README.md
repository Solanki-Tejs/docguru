# 📚 DocGuru – AI PDF Question Answering System

DocGuru is a **Local AI-powered RAG (Retrieval Augmented Generation) PDF Assistant**.  
It allows users to:

✓ Upload PDF documents  
✓ Ask questions related to the PDF  
✓ Get accurate answers using ONLY the PDF content  
✓ Run everything locally with full privacy

Unlike typical AI chatbots, DocGuru does NOT hallucinate or pull answers from the internet.  
It reads your PDF, understands it, builds knowledge from it, and answers **only from it**.

This project was built as a **college academic project**, which is why it includes modules like FAQ and Feedback for demonstration and completeness.

---

##  Features

-  Upload and manage PDF files
-  Extract and understand PDF content
-  Generate embeddings and store them in Vector DB
-  Ask natural language questions
-  Get contextual answers from PDF
-  Works offline and completely local
-  Fast, accurate, privacy safe
-  Designed for real-world + academic purposes

---

##  Technology Stack

Backend Framework  
➤ FastAPI

Artificial Intelligence  
➤ LangChain  
➤ Ollama (LLM3 Model) — Runs locally  
➤ Retrieval Augmented Generation (RAG)

Vector Database  
➤ ChromaDB

Relational Database  
➤ MySQL

PDF Processing  
➤ pdfminer.six  
➤ pdfplumber  
➤ PyMuPDF  
➤ pypdf

Utilities  
➤ numpy, pandas  
➤ SQLAlchemy  
➤ Authentication utilities  
➤ Logging tools  

Everything runs locally. No cloud dependency.

---

##  System Workflow

User Uploads PDF
->
PDF Text Extracted
->
Content Chunked & Processed
->
Embeddings Generated
->
Embeddings Stored in Chroma Vector DB
->
User Asks Question
->
Relevant PDF Content Retrieved
->
LLM Generates Answer Based on PDF Onl



---

##  Database Design

###  user_detail  
Stores user accounts
- uid (Primary Key)
- name
- email
- password

###  faq  
Stores FAQ content (academic purpose)
- id (Primary Key)
- question
- answer

###  feedback_detail  
Stores user feedback
- fid (Primary Key)
- uid (Foreign Key → user_detail.uid)
- msg
- star
- time

###  pdf_detail  
Stores uploaded PDF records
- pdf_id (Primary Key)
- uid (Foreign Key → user_detail.uid)
- name
- timedate

###  pdf_meta  
Stores PDF metadata
- metaid (Primary Key)
- pdf_id (Foreign Key → pdf_detail.pdf_id)
- file size
- page count
- word count

###  vectordb_detail  
Stores vector DB metadata
- vector_id (Primary Key)
- collection_name
- uid
- pdf_id

---

##  Local AI and RAG

DocGuru uses:
- Ollama LLM (LLM3)
- LangChain RAG Pipeline
- ChromaDB Vector Store

Advantages:
- No internet required
- Private and secure
- Faster responses
- Suitable for sensitive documents

---

##  How to Run (Concept Guide)

 -Install dependencies  
 -Setup database  
 -Start Ollama  
 -Run FastAPI backend  
 -Open frontend / API client  
 -Upload PDF  
 -Ask questions 🎉

---

## Practical Use Cases

Students  
✓ Ask questions from study material  
✓ Understand notes easily  

Research  
✓ Query research papers  
✓ Understand sections without manually reading everything  

Legal & Business  
✓ Ask questions about contracts  
✓ Extract insights from business reports  

Privacy Focused Users  
✓ Local system  
✓ No data leaves your machine  

---

##  Architecture (Simple View)

User
->
Frontend / API
->
FastAPI Backend
->
PDF Processing Engine
->
Vector Database (Chroma)
->
LLM (Ollama)
->
Answer Returned



---

##  Project Purpose

This project was developed as a **college capstone / academic project** to demonstrate:

✓ Modern AI application development  
✓ Real-world RAG implementation  
✓ Backend system architecture  
✓ Practical document intelligence  

It shows how AI can make document reading smarter, faster, and easier.

---

##  Feedback / Contributions

Suggestions, feedback, and contributions are always welcome!

---

##  Summary

DocGuru = PDF + Local AI + Smart Question Answering  
Simple. Private. Powerful. Useful.

---


