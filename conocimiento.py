import re
from pathlib import Path

ARCHIVO = Path(__file__).with_name('chatbot_pinturas.pl')
PREDICADOS = ('pintura', 'marca', 'superficie', 'es_marca', 'tipo', 'acabado', 'sirve_para', 'uso', 'caracteristica')
PATRON = re.compile(r'^([a-z_]+)\(([a-z0-9_, ]+)\)\.$')


def leer_hechos():
    hechos = {nombre: [] for nombre in PREDICADOS}
    for linea in ARCHIVO.read_text(encoding='utf-8').splitlines():
        coincidencia = PATRON.fullmatch(linea.strip())
        if coincidencia:
            nombre, valores = coincidencia.groups()
            argumentos = tuple(valor.strip() for valor in valores.split(','))
            if nombre in hechos and len(argumentos) == (1 if nombre in PREDICADOS[:3] else 2):
                hechos[nombre].append(argumentos)
    return hechos


def construir_contexto():
    hechos = leer_hechos()
    lineas = [f"{nombre}({', '.join(argumentos)})." for nombre, datos in hechos.items() for argumentos in datos]
    lineas += [
        'Reglas:',
        'recomendable(P,S) si sirve_para(P,S).',
        'recomendable_uso(P,S,U) si sirve_para(P,S) y uso(P,U).',
        'protege_metal(P) si sirve_para(P,metal) y caracteristica(P,protege_oxido).',
    ]
    return '\n'.join(lineas)
