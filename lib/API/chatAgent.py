from langchain_core.prompts import ChatPromptTemplate
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_ollama import OllamaLLM

llm=OllamaLLM(model="tinyllama",streaming=True)

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
    
            # print("hello")
            yield str(chunk.get("answer",""))
            # print("hello")  
        else:
            yield chunk
            # print("hello")