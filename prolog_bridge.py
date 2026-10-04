import shutil
import subprocess
from pathlib import Path

PL_FILE = Path(__file__).with_name("chatbot_pinturas.pl")

def normalizar(texto: str) -> str:
    reemplazos = str.maketrans("áéíóúüñ", "aeiouun")
    return texto.lower().translate(reemplazos)

def detectar_superficie(t):
    for s in ["madera", "metal", "hormigon", "yeso", "ladrillo"]:
        if s in t:
            return s
    return None

def detectar_ubicacion(t):
    for u in ["interior", "exterior"]:
        if u in t:
            return u
    return None

def detectar_condicion(t):
    if "corrosion" in t or "oxido" in t:
        return "corrosion"
    if "humedad" in t:
        return "humedad"
    if "exposicion" in t:
        return "exposicion_exterior"
    return None

def ejecutar_goal(goal: str) -> list[str]:
    swipl = shutil.which("swipl")
    if not swipl:
        raise RuntimeError("SWI-Prolog no está instalado o 'swipl' no está en PATH.")
    cmd = [swipl, "-q", "-s", str(PL_FILE), "-g", goal, "-t", "halt"]
    p = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8")
    if p.returncode != 0:
        raise RuntimeError(p.stderr.strip() or "Error ejecutando Prolog")
    return [x.strip() for x in p.stdout.splitlines() if x.strip()]

def responder_prolog(pregunta: str) -> str:
    t = normalizar(pregunta)
    superficie = detectar_superficie(t)
    ubicacion = detectar_ubicacion(t)
    condicion = detectar_condicion(t)
    preparacion = any(k in t for k in ["prepar", "antes", "limpiar", "lijar"])

    if not superficie:
        return "No pude identificar una superficie conocida en la pregunta."

    try:
        if preparacion:
            goal = f"forall(preparacion({superficie},X),(write(X),nl))"
            datos = ejecutar_goal(goal)
            return f"Preparación sugerida para {superficie}: " + (", ".join(datos) if datos else "sin resultados.")

        if condicion:
            goal = f"forall(recomendar_proteccion(P,{superficie},{condicion}),(write(P),nl))"
            datos = ejecutar_goal(goal)
            return f"Opciones para {superficie} con {condicion}: " + (", ".join(datos) if datos else "sin resultados en la base actual.")

        if ubicacion:
            goal = f"forall(recomendar(P,{superficie},{ubicacion}),(write(P),nl))"
            datos = ejecutar_goal(goal)
            return f"Opciones para {superficie} en {ubicacion}: " + (", ".join(datos) if datos else "sin resultados en la base actual.")

        return "Identifiqué la superficie, pero falta indicar interior/exterior o una condición como corrosión/humedad."
    except RuntimeError as e:
        return f"Error Prolog: {e}"
