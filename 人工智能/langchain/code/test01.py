from langchain_coummunity llms import Ollama

llm = Ollmama(model="qwen:4B")

llm.invoke("how to make a potato?")