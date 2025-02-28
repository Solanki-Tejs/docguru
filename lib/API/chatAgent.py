from langchain_core.prompts import ChatPromptTemplate
from langchain.chains import create_retrieval_chain
from langchain.chains.combine_documents import create_stuff_documents_chain
from langchain_ollama import OllamaLLM

llm=OllamaLLM(model="llama3",streaming=True)

prompt = ChatPromptTemplate.from_template("""
Answer the following question based only on the provided context. 
Think step by step before providing a detailed answer. 
<context>
{context}
</context>
Question: {input}""")

def chatAgent(db, message):
    retriever = db.as_retriever()
    print(retriever)
    # print("land")
    document_chain=create_stuff_documents_chain(llm,prompt)
    print(document_chain)
    # print("lasan")
    retrieval_chain=create_retrieval_chain(retriever,document_chain)
    print(retrieval_chain)
    # print("pubg")
    # for chunk in retrieval_chain.stream({"input": message}):
    #     yield chunk

    for chunk in retrieval_chain.stream({"input": message}):
        if isinstance(chunk, dict):  
            # Convert to string safely
            print("hello")
            yield str(chunk.get("answer",""))
            print("hello")  
        else:
            yield chunk
            print("hello")


    # with requests.post(URL, json=data, stream=True) as r:
    #     for line in r.iter_lines():
    #         if line:
    #             try:
    #                 response_json = json.loads(line)
    #                 yield response_json.get("response", "")  # Send each chunk as received
    #                 time.sleep(0.05)  # Optional delay for better UX
    #             except json.JSONDecodeError:
    #                 continue


    # response=retrieval_chain.invoke({"input": message})
    # return response