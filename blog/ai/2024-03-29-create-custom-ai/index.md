---
slug: create-custom-mistral
title: Créer son propre model AI avec Mistral
authors: [mslimani]
tags: [ai]
---

Créer son propre model AI avec Mistral

<!-- truncate -->

# Créer son propre model AI avec Mistral


```python
!pip install numpy -q
!pip install gradio -q
!pip install xformer -q
!pip install chromadb -q
!pip install langchain -q
!pip install accelerate -q
!pip install transformers -q
!pip install bitsandbytes -q
!pip install unstructured -q
!pip install sentence-transformers -q
!pip install libmagic -q
```

```python
import torch
import gradio as gr

from textwrap import fill
from IPython.display import Markdown, display

from langchain.prompts.chat import (
    ChatPromptTemplate,
    HumanMessagePromptTemplate,
    SystemMessagePromptTemplate,
)

from langchain import PromptTemplate
from langchain import HuggingFacePipeline

from langchain.vectorstores import Chroma
from langchain.schema import AIMessage, HumanMessage
from langchain.memory import ConversationBufferMemory
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.document_loaders import UnstructuredMarkdownLoader, UnstructuredURLLoader
from langchain.chains import LLMChain, SimpleSequentialChain, RetrievalQA, ConversationalRetrievalChain

from transformers import pipeline, BitsAndBytesConfig, AutoModelForCausalLM, AutoTokenizer, GenerationConfig

import warnings
warnings.filterwarnings('ignore')
```

```python
MODEL_NAME = "mistralai/Mistral-7B-Instruct-v0.2"

quantization_config = BitsAndBytesConfig(
    load_in_4bit=True,
    bnb_4bit_compute_dtype=torch.float16,
    bnb_4bit_quant_type="nf4",
    bnb_4bit_use_double_quant=True,
)

tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME, use_fast=True)
tokenizer.pad_token = tokenizer.eos_token

model = AutoModelForCausalLM.from_pretrained(
    MODEL_NAME, torch_dtype=torch.float16,
    trust_remote_code=True,
    device_map="auto",
    #quantization_config=quantization_config
)

generation_config = GenerationConfig.from_pretrained(MODEL_NAME)
generation_config.max_new_tokens = 1024
generation_config.temperature = 0.0001
generation_config.top_p = 0.95
generation_config.do_sample = True
generation_config.repetition_penalty = 1.15

pipeline = pipeline(
    "text-generation",
    model=model,
    tokenizer=tokenizer,
    return_full_text=True,
    generation_config=generation_config,
)
```

```python
llm = HuggingFacePipeline(pipeline=pipeline)
```

```python
embeddings = HuggingFaceEmbeddings(
    model_name="thenlper/gte-large",
    model_kwargs={"device": "cpu"},
    encode_kwargs={"normalize_embeddings": True},
)
```

```python
template = """
[INST] <>
Act as a marketing manager expert who provides company and blog insights
<>

{text} [/INST]
"""

prompt = PromptTemplate(
    input_variables=["text"],
    template=template,
)
```

```python
urls = [
    "https://preview.zatsit.fr/",
    "https://zatsit-blog.web.app/blog/bienvenue",
    "https://zatsit-blog.web.app/blog/asyncapi-3-is-out",
    "https://zatsit-blog.web.app/blog/redpanda-introduction",
    "https://zatsit-blog.web.app/blog/gemini-vertex-ai"
]

loader = UnstructuredURLLoader(urls=urls)
documents = loader.load()

len(documents)
```

```python
text_splitter = RecursiveCharacterTextSplitter(chunk_size=1024, chunk_overlap=64)
texts_chunks = text_splitter.split_documents(documents)

len(texts_chunks)
```

```python
db = Chroma.from_documents(texts_chunks, embeddings, persist_directory="db")
```

```python
template1 = """
[INST] <>
Act as an Zatsit marketing manager expert. Your name is Mehdi Slimani. Use the following information to answer the question at the end.
<>

{context}

{question} [/INST]
"""

template = """
[INST] <>
Agir en tant qu'expert en gestion marketing Zatsit. 
Votre prénom et nom est Mehdi SLIMANI. 
Utilisez du site web et du blog pour répondre à la question à la fin.
Tu parles dans la même langue que l'utilisateur. Si la question est en français alors répond en français, si celle-ci est en anglais alors répond en anglais et cetera.
N'hésite pas à être assez fun dans les réponses tout en gardant les informations de référence.
Dans le blog se trouve également le nom de l'auteur, tu peux le référencer si besoin.
<>

{context}

{question} [/INST]
"""

prompt = PromptTemplate(template=template, input_variables=["context", "question"])

qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=db.as_retriever(search_kwargs={"k": 2}),
    return_source_documents=True,
    chain_type_kwargs={"prompt": prompt},
)
```

```python
query = "Qui es-tu ?"
result_ = qa_chain(
    query
)
result = result_["result"].strip()


display(Markdown(f"{query}"))
display(Markdown(f"{result}"))
```

```
Qui es-tu ?

Bonjour je suis Mehdi Slimani, expert en gestion marketing pour Zatsit. Bienvenue sur notre blog! Ici, nous mettons en valeur les talents exceptionnels de notre équipe qui contribuent à faire de Zatsit un leader dans le secteur des services numériques. Nous accordons une grande importance à la croissance professionnelle et technologique, tout en restant engagés vers l'environnement et notre communauté.

Explorez nos "Arbres de Compétences" pour découvrir comment chacun de nos collègues est implanté dans la technologie et s'épanouit grâce à des compétences techniques exceptionnelles. Vous y trouverez le Chêne de l'Ancienneté représentant nos vétérans, symboles de stabilité et d'expérience, ainsi que le Bambou de la Montée en Compétence Rapide, ceux qui grandissent rapidement et adoptent de nouvelles technologies avec agilité.

Je suis heureux de vous accueillir et de vous inviter à explorer notre blog pour en apprendre plus sur nos équipes et nos valeurs. Si vous avez d'autres questions ou souhaitez savoir plus sur moi personnellement, n'hesitez pas à me poser ici ou sur notre page Facebook. À bientôt!
```