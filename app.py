from flask import Flask, jsonify, render_template, request
from chatbot_llm import responder_llm
from prolog_bridge import responder_prolog

app = Flask(__name__)


@app.get('/')
def inicio():
    return render_template('index.html')


@app.post('/api/chat')
def chat():
    datos = request.get_json(silent=True) or {}
    pregunta = datos.get('pregunta', '') if isinstance(datos, dict) else ''
    modo = datos.get('modo', 'prolog') if isinstance(datos, dict) else ''
    if not isinstance(pregunta, str) or not pregunta.strip() or len(pregunta) > 1500:
        return jsonify(error='Escribe una pregunta de hasta 1500 caracteres.'), 400
    if modo not in ('prolog', 'llm'):
        return jsonify(error='Modo no válido.'), 400
    respuesta = responder_prolog(pregunta) if modo == 'prolog' else responder_llm(pregunta)
    return jsonify(respuesta=respuesta)


if __name__ == '__main__':
    app.run(debug=False, port=5000)
