# Proyecto 2: chatbot de pinturas con Prolog y Groq

Este proyecto contiene dos versiones de un chatbot de pinturas y recubrimientos: una consulta hechos y reglas de SWI-Prolog; la otra usa un modelo de lenguaje mediante Groq. Las dos usan los datos de `chatbot_pinturas.pl` y se pueden probar desde la misma interfaz web.

## Instalación en Windows (PowerShell)

Necesitas Python 3.10 o superior y SWI-Prolog instalado.

```powershell
py -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
Copy-Item .env.example .env
notepad .env
```

Genera una clave en https://console.groq.com/keys y escribe en `.env`:

```dotenv
GROQ_API_KEY=tu_clave_de_groq
GROQ_MODEL=llama-3.1-8b-instant
SWIPL_PATH=swipl
```

`SWIPL_PATH=swipl` funciona si SWI-Prolog está en el PATH. Si no, coloca la ruta completa, por ejemplo `SWIPL_PATH=C:/Program Files/swipl/bin/swipl.exe`.

El modo Prolog funciona sin una clave de API. El modo Groq necesita conexión a Internet y está sujeto a los límites de la cuenta. Puedes cambiar el modelo editando solamente `GROQ_MODEL`.

## Ejecución

```powershell
python verificar_instalacion.py
python -m unittest discover -s tests -v
python app.py
```

Visita http://127.0.0.1:5000 y selecciona **Prolog** o **Groq + Python**. Prueba preguntas como `¿Qué pinturas sirven para metal exterior?`, `¿Qué productos son de la marca Tekbond?` o `¿Qué acabado tiene spray acrílico?`.

Para iniciar el chatbot Prolog directamente:

```powershell
swipl -s chatbot_pinturas.pl
```

Dentro de SWI-Prolog ejecuta `iniciar_chat.` y escribe `salir` para terminar. También puedes consultar hechos, por ejemplo `recomendable_uso(P,metal,exterior).`.

Para probar las veinte preguntas en ambas versiones:

```powershell
python evaluar_20_preguntas.py
```

Esto genera `resultados_20_preguntas.csv` para preparar el informe. Las preguntas de Groq consumen cuota de API. Las pruebas automáticas de Python usan un simulador del motor Prolog; no sustituyen la comprobación real en Windows.

## Archivos

- `chatbot_pinturas.pl`: base de conocimiento, reglas y diálogo Prolog.
- `conocimiento.py`: lee los hechos de Prolog para el chatbot Groq.
- `prolog_bridge.py`: convierte preguntas simples en consultas Prolog.
- `chatbot_llm.py`: realiza las consultas a Groq.
- `app.py`, `templates/` y `static/`: interfaz web con ambos modos.
- `preguntas_20.csv`, `evaluar_20_preguntas.py`: comparación de veinte preguntas.
- `Informe_Final_Plantilla.md`: estructura del informe de entrega.

## Entrega y evaluación

El enunciado exige, además del programa, explicar el dominio y su modelamiento, presentar las respuestas reales a veinte preguntas para ambas versiones, comparar resultados y escribir conclusiones, fortalezas, debilidades y propuestas de mejora. La plantilla incluida sirve para completar esa parte después de ejecutar el programa. No se incluyen respuestas de API inventadas.

Al modificar los hechos de `chatbot_pinturas.pl`, las consultas nuevas de ambos modos usan la base actualizada. Para agregar una superficie es conveniente declarar también `superficie(nueva_superficie).` y relacionarla con `sirve_para/2`.

El parser Prolog utiliza palabras clave y reconoce nombres de pinturas compuestos, pero no interpreta cualquier formulación posible en lenguaje natural.

No subas `.env` al repositorio: la clave personal está excluida mediante `.gitignore`.
