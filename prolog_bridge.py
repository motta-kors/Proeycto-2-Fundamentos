import re
import shutil
import subprocess
import unicodedata
from pathlib import Path

PL_FILE = Path(__file__).with_name("chatbot_pinturas.pl")

PINTURAS = [
    "esmalte_sintetico", "esmalte_al_agua", "latex_interior", "latex_exterior",
    "oleo_opaco", "anticorrosivo", "barniz_marino", "laca_nitro",
    "spray_acrilico", "spray_alta_temperatura", "primer_automotriz",
    "impermeabilizante", "pintura_piso", "pintura_piscina", "pintura_tizada",
]

MARCAS = [
    "sipa", "ceresita", "tricolor", "chilcorrofin",
    "mtn", "molotow", "tekbond", "toro_negro",
]

SUPERFICIES = [
    "madera", "metal", "muro", "hormigon", "yeso",
    "auto", "piscina", "piso", "graffiti",
]

USOS = ["interior", "exterior"]
TIPOS = ["agua", "solvente", "aerosol"]
ACABADOS = ["mate", "brillante", "semibrillo"]

CARACTERISTICAS = [
    "protege_oxido", "resistente_humedad", "resistente_clima",
    "repele_agua", "resistente_calor", "mejora_adherencia",
    "resistente_agua", "alto_transito", "secado_rapido", "alta_cobertura",
]


def normalizar(texto: str) -> str:
    texto = texto.lower().strip()
    texto = "".join(
        c for c in unicodedata.normalize("NFD", texto)
        if unicodedata.category(c) != "Mn"
    )
    texto = re.sub(r"[^a-z0-9_ ]+", " ", texto)
    return re.sub(r"\s+", " ", texto).strip()


def contiene_termino(texto: str, termino: str) -> bool:
    return termino in texto or termino.replace("_", " ") in texto


def detectar(texto: str, opciones: list[str]):
    for opcion in sorted(opciones, key=len, reverse=True):
        if contiene_termino(texto, opcion):
            return opcion
    return None


def ejecutar_goal(goal: str) -> list[str]:
    swipl = shutil.which("swipl")
    if not swipl:
        raise RuntimeError(
            "SWI-Prolog no está instalado o el comando 'swipl' no está disponible en PATH."
        )

    cmd = [swipl, "-q", "-s", str(PL_FILE), "-g", goal, "-t", "halt"]
    proceso = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
        encoding="utf-8",
        timeout=10,
    )

    if proceso.returncode != 0:
        raise RuntimeError(proceso.stderr.strip() or "Error ejecutando Prolog.")

    return [linea.strip() for linea in proceso.stdout.splitlines() if linea.strip()]


def consultar_variable(predicado: str, *args: str, variable: str = "X") -> list[str]:
    argumentos = ",".join(variable if a == "_VAR_" else a for a in args)
    goal = f"forall({predicado}({argumentos}),(write({variable}),nl))"
    return ejecutar_goal(goal)


def lista_texto(datos: list[str]) -> str:
    if not datos:
        return "sin resultados registrados."
    return ", ".join(dict.fromkeys(datos))


def responder_prolog(pregunta: str) -> str:
    t = normalizar(pregunta)

    if not t:
        return "La pregunta está vacía."

    pintura = detectar(t, PINTURAS)
    marca = detectar(t, MARCAS)
    superficie = detectar(t, SUPERFICIES)
    uso = detectar(t, USOS)
    tipo = detectar(t, TIPOS)
    acabado = detectar(t, ACABADOS)
    caracteristica = detectar(t, CARACTERISTICAS)

    try:
        # Marca de una pintura.
        if pintura and ("marca" in t or "fabricante" in t):
            datos = consultar_variable("es_marca", pintura, "_VAR_")
            return f"La marca de {pintura} es: {lista_texto(datos)}"

        # Productos de una marca.
        if marca:
            datos = consultar_variable("producto_de_marca", "_VAR_", marca)
            return f"Productos de {marca}: {lista_texto(datos)}"

        # Tipo/base de una pintura.
        if pintura and ("tipo" in t or "base" in t):
            datos = consultar_variable("tipo", pintura, "_VAR_")
            return f"{pintura} es de tipo/base: {lista_texto(datos)}"

        # Acabado de una pintura.
        if pintura and "acabado" in t:
            datos = consultar_variable("acabado", pintura, "_VAR_")
            return f"Acabado de {pintura}: {lista_texto(datos)}"

        # Características de una pintura.
        if pintura and ("caracteristica" in t or "caracteristicas" in t):
            datos = consultar_variable("caracteristica", pintura, "_VAR_")
            return f"Características de {pintura}: {lista_texto(datos)}"

        # Superficies compatibles de una pintura.
        if pintura and not superficie and (
            "sirve" in t or "superficie" in t or "usar" in t or "uso" in t
        ):
            datos = consultar_variable("sirve_para", pintura, "_VAR_")
            return f"{pintura} sirve para: {lista_texto(datos)}"

        # Validación pintura + superficie.
        if pintura and superficie:
            resultado = ejecutar_goal(
                f"(recomendable({pintura},{superficie})->write(si);write(no))"
            )
            valor = resultado[0] if resultado else "no"
            if valor == "si":
                return f"Sí, {pintura} es recomendable para {superficie}."
            return f"No, {pintura} no está registrada como recomendable para {superficie}."

        # Superficie + interior/exterior.
        if superficie and uso:
            datos = consultar_variable(
                "recomendable_uso", "_VAR_", superficie, uso
            )
            return (
                f"Pinturas recomendadas para {superficie} en {uso}: "
                f"{lista_texto(datos)}"
            )

        # Pinturas para una superficie.
        if superficie:
            datos = consultar_variable("sirve_para", "_VAR_", superficie)
            return f"Pinturas para {superficie}: {lista_texto(datos)}"

        # Pinturas para interior/exterior.
        if uso:
            predicado = "para_interior" if uso == "interior" else "para_exterior"
            datos = consultar_variable(predicado, "_VAR_")
            return f"Pinturas para {uso}: {lista_texto(datos)}"

        # Pinturas de un acabado.
        if acabado:
            datos = consultar_variable("acabado", "_VAR_", acabado)
            return f"Pinturas con acabado {acabado}: {lista_texto(datos)}"

        # Tipos generales.
        if tipo == "agua" or "al agua" in t:
            datos = consultar_variable("al_agua", "_VAR_")
            return f"Pinturas al agua: {lista_texto(datos)}"

        if tipo == "aerosol" or "aerosoles" in t:
            datos = consultar_variable("en_aerosol", "_VAR_")
            return f"Pinturas en aerosol: {lista_texto(datos)}"

        if tipo == "solvente":
            datos = consultar_variable("tipo", "_VAR_", "solvente")
            return f"Pinturas base solvente: {lista_texto(datos)}"

        # Consultas por característica.
        if caracteristica:
            datos = consultar_variable(
                "producto_con_caracteristica", "_VAR_", caracteristica
            )
            return f"Productos con {caracteristica}: {lista_texto(datos)}"

        # Caso natural: proteger metal del óxido.
        if ("oxido" in t or "corrosion" in t) and "metal" in t:
            datos = consultar_variable("protege_metal", "_VAR_")
            return f"Para proteger metal del óxido: {lista_texto(datos)}"

        if "mate" in t:
            datos = consultar_variable("es_mate", "_VAR_")
            return f"Pinturas con acabado mate: {lista_texto(datos)}"

        return (
            "No pude interpretar la pregunta con la base actual. "
            "Puedes preguntar por pintura, marca, superficie, tipo/base, "
            "acabado, uso interior/exterior o características."
        )

    except (RuntimeError, subprocess.TimeoutExpired) as e:
        return f"Error Prolog: {e}"
