# Proyecto 2 - Grupo 9
## Chatbot experto en Pinturas y Recubrimientos

Este repositorio contiene dos implementaciones del mismo dominio de conocimiento:

1. **Prolog**: base de hechos y reglas en `chatbot_pinturas.pl`.
2. **LLM + Python**: chatbot en `chatbot_llm.py` que recibe como contexto la misma base de conocimiento.
3. **Interfaz web**: `app.py` permite probar ambos modos desde el navegador.
4. **Evaluación**: `evaluar_20_preguntas.py` ejecuta el set de 20 preguntas y genera un CSV comparativo.

## Requisitos

- Python 3.11 o superior.
- SWI-Prolog instalado y disponible como `swipl`.
- Una clave de API para ejecutar la versión LLM.

## Instalación

```bash
python -m venv .venv
```

En Windows:

```bash
.venv\Scripts\activate
```

Instalar dependencias:

```bash
pip install -r requirements.txt
```

Copia `.env.example` como `.env` y agrega tu clave.

## Probar Prolog

```bash
swipl -s chatbot_pinturas.pl
```

Luego:

```prolog
?- iniciar.
```

## Probar LLM

```bash
python chatbot_llm.py
```

## Ejecutar interfaz web

```bash
python app.py
```

Abrir: `http://127.0.0.1:5000`

## Ejecutar las 20 preguntas

```bash
python evaluar_20_preguntas.py
```

Se genera `resultados_20_preguntas.csv`.

## Importante

Nunca suban el archivo `.env` ni la clave de API a GitHub.
