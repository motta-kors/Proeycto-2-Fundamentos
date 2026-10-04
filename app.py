from flask import Flask, jsonify, render_template, request
from chatbot_llm import responder_llm
from prolog_bridge import responder_prolog

app = Flask(__name__)

@app.get("/")
def index():
    return render_template("index.html")

@app.post("/api/chat")
def chat():
    data = request.get_json(silent=True) or {}
    pregunta = str(data.get("pregunta", "")).strip()
    modo = str(data.get("modo", "prolog")).lower()

    if not pregunta:
        return jsonify({"ok": False, "error": "La pregunta está vacía."}), 400

    if modo == "llm":
        respuesta = responder_llm(pregunta)
    elif modo == "prolog":
        respuesta = responder_prolog(pregunta)
    else:
        return jsonify({"ok": False, "error": "Modo no válido."}), 400

    return jsonify({"ok": True, "modo": modo, "respuesta": respuesta})

if __name__ == "__main__":
    app.run(debug=True)
