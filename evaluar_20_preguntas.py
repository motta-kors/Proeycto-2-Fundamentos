import csv
from pathlib import Path
from chatbot_llm import responder_llm
from prolog_bridge import responder_prolog

BASE = Path(__file__).parent


def evaluar():
    with (BASE / 'preguntas_20.csv').open(encoding='utf-8-sig', newline='') as archivo:
        preguntas = list(csv.DictReader(archivo))
    if len(preguntas) != 20:
        raise ValueError('El archivo debe contener exactamente 20 preguntas.')
    filas = []
    for fila in preguntas:
        print(f"Pregunta {fila['numero']}/20: {fila['pregunta']}")
        filas.append({
            'numero': fila['numero'],
            'pregunta': fila['pregunta'],
            'respuesta_prolog': responder_prolog(fila['pregunta']),
            'respuesta_groq': responder_llm(fila['pregunta']),
            'observaciones': '',
        })
    with (BASE / 'resultados_20_preguntas.csv').open('w', encoding='utf-8-sig', newline='') as archivo:
        escritor = csv.DictWriter(archivo, fieldnames=list(filas[0]))
        escritor.writeheader()
        escritor.writerows(filas)
    print('Archivo generado: resultados_20_preguntas.csv')


if __name__ == '__main__':
    evaluar()
