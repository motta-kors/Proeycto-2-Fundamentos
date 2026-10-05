# Proyecto 2 - Fundamentos de Inteligencia Artificial

Sistema experto y chatbot sobre **pinturas y recubrimientos**, implementado principalmente en **Prolog** y conectado a una interfaz web en **Flask/Python**.

## Código fuente principal

El archivo principal es:

- `chatbot_pinturas.pl`

La base de conocimiento contiene:

- pinturas;
- marcas;
- tipos o bases;
- acabados;
- superficies;
- usos interior/exterior;
- características;
- reglas de recomendación.

## Archivos principales

- `chatbot_pinturas.pl`: base de conocimiento y reglas en Prolog.
- `prolog_bridge.py`: conecta Python con SWI-Prolog.
- `app.py`: servidor Flask.
- `templates/index.html`: interfaz del chatbot.
- `conocimiento.py`: contexto utilizado por el modo LLM.
- `chatbot_llm.py`: modo alternativo con LLM.
- `preguntas_20.csv`: preguntas de evaluación.
- `evaluar_20_preguntas.py`: ejecuta las 20 preguntas en ambos modos.

## Requisitos

1. Python 3.
2. SWI-Prolog instalado y disponible mediante el comando `swipl`.
3. Dependencias Python:

```bash
pip install -r requirements.txt
```

## Ejecutar la aplicación web

```bash
python app.py
```

Luego abrir la dirección local que muestra Flask.

## Ejecutar Prolog directamente

```bash
swipl -s chatbot_pinturas.pl
```

Dentro de SWI-Prolog:

```prolog
?- iniciar_chat.
```

También se pueden realizar consultas directas:

```prolog
?- sirve_para(Pintura, metal).
?- producto_de_marca(Pintura, tekbond).
?- es_mate(Pintura).
?- al_agua(Pintura).
?- en_aerosol(Pintura).
?- protege_metal(Pintura).
?- recomendable(anticorrosivo, metal).
?- recomendable_uso(Pintura, metal, exterior).
```

## Ejemplos de preguntas para el chatbot web

- ¿Qué pinturas sirven para metal?
- ¿Qué pinturas sirven para metal exterior?
- ¿Qué productos son de la marca Tekbond?
- ¿Qué tipo tiene spray acrílico?
- ¿Qué acabado tiene spray acrílico?
- ¿Qué pinturas tienen acabado mate?
- ¿Qué pinturas son al agua?
- ¿Qué pinturas vienen en aerosol?
- ¿Qué producto protege el metal del óxido?
- ¿Qué características tiene primer automotriz?

## Nota

La aplicación web utiliza la misma base de conocimiento definida en Prolog. El puente Python no mantiene una segunda base independiente para las respuestas Prolog; detecta los conceptos de la pregunta y ejecuta consultas sobre `chatbot_pinturas.pl`.
