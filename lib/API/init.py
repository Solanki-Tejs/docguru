from langchain_community.document_loaders import PyPDFLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_ollama import OllamaEmbeddings
from langchain_chroma import Chroma

def load_document(doc_path):
    loader = PyPDFLoader(doc_path)
    docs = loader.load()
    return docs

def split_docs_into_chunks(docs):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=2000, chunk_overlap=600)
    chunks=text_splitter.split_documents(docs)
    return chunks

def vector_init(collection_name, save_loc):
    embeddings = OllamaEmbeddings(model='nomic-embed-text')
    db = Chroma(
            collection_name=collection_name,
            persist_directory=("./vectorDB/"+save_loc),
            embedding_function=embeddings
    )
    return db

def chunks_embedding(chunks, db):
    db.add_documents(chunks)


def retriving(db, message):
    retriver = db.as_retriever()
    response = retriver.invoke(message)
    return response
    