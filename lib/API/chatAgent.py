from langchain_core.prompts import ChatPromptTemplate
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_ollama import OllamaLLM
# from langchain.output_parsers import StrOutputParser
import time
import asyncio
llm=OllamaLLM(model="llama3",streaming=True)

stop_event = asyncio.Event()

prompt = ChatPromptTemplate.from_template("""
Answer the following question based only on the provided context. 
Think step by step before providing a detailed answer. 
<context>
{context}
</context>
Question: {input}""")

def save_chunks_to_txt(chunked_docs, filename):
    with open(filename, "w", encoding="utf-8") as f:
        for chunk in chunked_docs:
            f.write(f"--- Metadata ---\n")
            for key, value in chunk.metadata.items():
                f.write(f"{key}: {value}\n")
            f.write("\n--- Content ---\n")
            f.write(chunk.page_content + "\n")
            f.write("=" * 50 + "\n\n")

# def chatAgent(db, message):
#     start_time = time.time()
#     retriever = db.as_retriever()
    
#     document_chain=create_stuff_documents_chain(llm,prompt)

#     retrieval_chain=create_retrieval_chain(retriever,document_chain)

#     retrieved_docs = retriever.invoke(message)
#     print(retrieved_docs)

#     for chunk in retrieval_chain.stream({"input": message}):
#         if isinstance(chunk, dict):  
#             yield str(chunk.get("answer",""))
#             # print("hello")  
#             # yield parsed_output
#         else:
#             yield chunk
#             # print("hello")
   



def stop_generation():
    stop_event.set()

async def chatAgent(db, message):
    stop_event.clear()
    retriever = db.as_retriever(search_kwargs={"k": 5})
    document_chain = create_stuff_documents_chain(llm, prompt)
    retrieval_chain = create_retrieval_chain(retriever, document_chain)

    async for chunk in retrieval_chain.astream({"input": message}):
        if stop_event.is_set():
            break
        if isinstance(chunk, dict):
            yield str(chunk.get("answer", ""))
        else:
            yield chunk
