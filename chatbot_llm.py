import os
from dotenv import load_dotenv
from conocimiento import construir_contexto

load_dotenv()


def responder_llm(pregunta):
    if not isinstance(pregunta, str) or not pregunta.strip():
        return 'Escribe una pregunta.'
    if not os.getenv('GROQ_API_KEY'):
        return 'Falta GROQ_API_KEY. Configura tu clave en el archivo .env.'

    try:
        from groq import Groq, GroqError
        cliente = Groq(api_key=os.getenv('GROQ_API_KEY'), timeout=30)
        respuesta = cliente.chat.completions.create(
            model=os.getenv('GROQ_MODEL', 'llama-3.1-8b-instant'),
            messages=[
                {
                    'role': 'system',
                    'content': (
                        'Eres un asistente de pinturas. Responde en español usando solo '
                        'los hechos y reglas que siguen. No inventes datos. Si falta '
                        'información, indícalo. Un hecho no registrado no significa '
                        'que sea físicamente imposible.\n\n' + construir_contexto()
                    ),
                },
                {'role': 'user', 'content': pregunta.strip()},
            ],
        )
        return respuesta.choices[0].message.content or 'El modelo no devolvió una respuesta.'
    except ImportError:
        return 'Instala las dependencias con: pip install -r requirements.txt'
    except GroqError as error:
        return f'Error de Groq ({type(error).__name__}). Revisa tu clave, conexión, modelo y límites de uso.'
    except (OSError, TimeoutError):
        return 'No se pudo conectar con Groq.'


if __name__ == '__main__':
    while True:
        try:
            pregunta = input('Pregunta (salir para terminar): ')
        except (EOFError, KeyboardInterrupt):
            break
        if pregunta.strip().lower() == 'salir':
            break
        print(responder_llm(pregunta))
