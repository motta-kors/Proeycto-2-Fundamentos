import csv
from pathlib import Path
from chatbot_llm import responder_llm
from prolog_bridge import responder_prolog

BASE = Path(__file__).parent
ENTRADA = BASE / "preguntas_20.csv"
SALIDA = BASE / "resultados_20_preguntas.csv"

filas = []
with ENTRADA.open(encoding="utf-8-sig", newline="") as f:
    for row in csv.DictReader(f):
        numero = row["numero"]
        pregunta = row["pregunta"]
        print(f"[{numero}/20] {pregunta}")
        r_prolog = responder_prolog(pregunta)
        r_llm = responder_llm(pregunta)
        filas.append({
            "numero": numero,
            "pregunta": pregunta,
            "respuesta_prolog": r_prolog,
            "respuesta_llm": r_llm,
            "observaciones": "",
        })

with SALIDA.open("w", encoding="utf-8-sig", newline="") as f:
    w = csv.DictWriter(f, fieldnames=filas[0].keys())
    w.writeheader()
    w.writerows(filas)

print(f"\nResultados guardados en: {SALIDA}")
