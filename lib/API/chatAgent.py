from langchain_core.prompts import ChatPromptTemplate
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_ollama import OllamaLLM
# from langchain.output_parsers import StrOutputParser

llm=OllamaLLM(model="llama3",streaming=True)

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

def chatAgent(db, message):
    retriever = db.as_retriever()
    # print(retriever)
    
    document_chain=create_stuff_documents_chain(llm,prompt)
    # print(document_chain)
    
    retrieval_chain=create_retrieval_chain(retriever,document_chain)
    # print(retrieval_chain)

    retrieved_docs = retriever.invoke(message)
    print(retrieved_docs)
    save_chunks_to_txt(retrieved_docs, "./retrived_docs/retrive.txt")
    # print("\nRetrieved Chunks:")
    # for doc in retrieved_docs:
    #     print(doc.page_content)

    for chunk in retrieval_chain.stream({"input": message}):
        if isinstance(chunk, dict):  
            # parsed_output = output_parser.parse(chunk.get("answer", ""))
            # print("hello")
            yield str(chunk.get("answer",""))
            # print("hello")  
            # yield parsed_output
        else:
            yield chunk
            # print("hello")


# from langchain_core.prompts import ChatPromptTemplate
# from langchain.chains import create_retrieval_chain
# from langchain.chains.combine_documents import create_stuff_documents_chain
# from langchain_ollama import OllamaLLM
# import time
# llm = OllamaLLM(model="llama3", streaming=True)

# prompt = ChatPromptTemplate.from_template("""
# Answer the following question based only on the provided context. 
# Think step by step before providing a detailed answer. 
# <context>
# {context}
# </context>
# Question: {input}
# """)

# async def chatAgent(db, message):
#     start_time = time.time()
#     retriever = db.as_retriever()
#     print(f"Retrieval took: {time.time() - start_time:.2f} seconds")

#     document_chain = create_stuff_documents_chain(llm, prompt)
#     retrieval_chain = create_retrieval_chain(retriever, document_chain)
#     print(f"retrieval_chain took: {time.time() - start_time:.2f} seconds") 
#     # **Stream retrieved and processed response**
#     async for chunk in retrieval_chain.astream({"input": message}):
#         if isinstance(chunk, dict):
#             yield chunk.get("answer", "")
#         else:
#             yield chunk
#     print(f"LLM Processing took: {time.time() - start_time:.2f} seconds") 


# from langchain_core.prompts import ChatPromptTemplate
# from langchain_ollama import OllamaLLM
# import time

# llm = OllamaLLM(model="llama3", streaming=True)

# prompt = ChatPromptTemplate.from_template("""
# Answer the following question based only on the provided context. 
# Think step by step before providing a detailed answer. 
# <context>
# {context}
# </context>
# Question: {input}
# """)

# async def chatAgent(db, message):
#     """Bypass LangChain's extra processing and stream directly from Ollama"""
    
#     # 1️⃣ **Start timer**
#     total_start_time = time.time()

#     # 2️⃣ **Retrieve documents (Fast)**
#     start_time = time.time()
#     retriever = db.as_retriever(search_kwargs={"k": 3})  # Fetch only top 3 docs
#     retrieved_docs = retriever.invoke(message)
#     print(f"Retrieval took: {time.time() - start_time:.2f} seconds")

#     # 3️⃣ **Prepare context from retrieved docs**
#     context = "\n".join([doc.page_content for doc in retrieved_docs])

#     # 4️⃣ **Stream directly from Ollama (No LangChain overhead)**
#     start_time = time.time()
#     async for chunk in llm.astream(f"{context}\n\nQuestion: {message}"):
#         yield chunk  # Stream response as it comes
#     print(f"LLM Processing took: {time.time() - start_time:.2f} seconds")

#     print(f"Total processing time: {time.time() - total_start_time:.2f} seconds")
