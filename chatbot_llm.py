import os
from dotenv import load_dotenv
from openai import OpenAI
from conocimiento import CONOCIMIENTO

load_dotenv()

MODELO = os.getenv("OPENAI_MODEL", "gpt-4.1-mini")

INSTRUCCION = f"""
Eres un chatbot educativo experto en el dominio acotado de pinturas y recubrimientos.
Debes responder SOLO usando el conocimiento proporcionado abajo.
No inventes productos, compatibilidades ni propiedades que no aparezcan en la base.
Si la pregunta no puede responderse con la base, dilo claramente.
Responde en español, de forma breve y clara.

BASE DE CONOCIMIENTO:
{CONOCIMIENTO}
""".strip()

def responder_llm(pregunta: str) -> str:
    if not pregunta or not pregunta.strip():
        return "La pregunta está vacía."
    if not os.getenv("OPENAI_API_KEY"):
        return (
            "Falta configurar OPENAI_API_KEY. Crea un archivo .env o define la variable "
            "de entorno antes de ejecutar la versión LLM."
        )

    client = OpenAI()
    prompt = f"{INSTRUCCION}\n\nPREGUNTA DEL USUARIO:\n{pregunta.strip()}"
    respuesta = client.responses.create(
        model=MODELO,
        input=prompt,
    )
    return respuesta.output_text.strip()

if __name__ == "__main__":
    print("Chatbot LLM de Pinturas. Escribe 'salir' para terminar.")
    while True:
        pregunta = input("Tú: ").strip()
        if pregunta.lower() == "salir":
            break
        print("LLM:", responder_llm(pregunta))
