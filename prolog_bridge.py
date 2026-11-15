import os
import re
import shutil
import subprocess
import unicodedata
from pathlib import Path
from dotenv import load_dotenv
from conocimiento import leer_hechos

load_dotenv()
ARCHIVO = Path(__file__).with_name('chatbot_pinturas.pl')


def normalizar(texto):
    texto = unicodedata.normalize('NFD', texto.lower())
    texto = ''.join(c for c in texto if unicodedata.category(c) != 'Mn')
    return re.sub(r'\s+', ' ', re.sub(r'[^a-z0-9_ ]', ' ', texto)).strip()


def identificar(texto, opciones, exclusiones=()):
    encontrados = []
    for opcion in opciones:
        for variante in (opcion, opcion.replace('_', ' ')):
            for coincidencia in re.finditer(rf'(?<![a-z0-9_]){re.escape(variante)}(?![a-z0-9_])', texto):
                inicio, fin = coincidencia.span()
                if not any(inicio < b and fin > a for a, b in exclusiones):
                    encontrados.append((fin - inicio, opcion, (inicio, fin)))
    if not encontrados:
        return None, None
    _, nombre, tramo = max(encontrados)
    return nombre, tramo


def ejecutar(consulta):
    programa = shutil.which(os.getenv('SWIPL_PATH', 'swipl'))
    if not programa:
        raise RuntimeError('SWI-Prolog no está instalado o falta configurar SWIPL_PATH.')
    resultado = subprocess.run(
        [programa, '-q', '-s', str(ARCHIVO), '-g', consulta, '-t', 'halt'],
        capture_output=True, text=True, encoding='utf-8', timeout=15,
    )
    if resultado.returncode:
        raise RuntimeError(resultado.stderr.strip() or 'Error al ejecutar SWI-Prolog.')
    return [linea.strip() for linea in resultado.stdout.splitlines() if linea.strip()]


def consultar(predicado, *argumentos):
    expresion = ','.join(argumentos)
    return ejecutar(f'forall({predicado}({expresion}),(write(X),nl))')


def filtrar(filtros):
    condiciones = ','.join(f'{nombre}(X,{valor})' for nombre, valor in filtros)
    return ejecutar(f'forall(({condiciones}),(write(X),nl))')


def comprobar(predicado, *argumentos):
    return ejecutar(f"({predicado}({','.join(argumentos)})->write(si);write(no))") == ['si']


def mostrar(datos):
    return ', '.join(dict.fromkeys(datos)) if datos else 'sin resultados registrados'


def responder_prolog(pregunta):
    texto = normalizar(pregunta or '')
    if not texto:
        return 'Escribe una pregunta.'
    try:
        hechos = leer_hechos()
        pintura, tramo = identificar(texto, [x[0] for x in hechos['pintura']])
        excluir = [tramo] if tramo else []
        marca, _ = identificar(texto, [x[0] for x in hechos['marca']], excluir)
        superficie, _ = identificar(texto, [x[0] for x in hechos['superficie']], excluir)
        uso, _ = identificar(texto, ['interior', 'exterior'], excluir)
        tipo, _ = identificar(texto, ['agua', 'solvente', 'aerosol'], excluir)
        acabado, _ = identificar(texto, ['mate', 'brillante', 'semibrillo'], excluir)
        caracteristica, _ = identificar(texto, [x[1] for x in hechos['caracteristica']], excluir)

        if pintura:
            if 'marca' in texto or 'fabricante' in texto:
                return f'Marca de {pintura}: {mostrar(consultar("es_marca", pintura, "X"))}.'
            if 'tipo' in texto or 'base' in texto:
                return f'Tipo de {pintura}: {mostrar(consultar("tipo", pintura, "X"))}.'
            if 'acabado' in texto:
                return f'Acabado de {pintura}: {mostrar(consultar("acabado", pintura, "X"))}.'
            if 'caracteristica' in texto or 'propiedad' in texto:
                return f'Características de {pintura}: {mostrar(consultar("caracteristica", pintura, "X"))}.'
            if superficie and uso:
                valido = comprobar('recomendable_uso', pintura, superficie, uso)
                return (f"Sí, {pintura} está registrado para {superficie} en {uso}." if valido
                        else f"No consta que {pintura} sirva para {superficie} en {uso}.")
            if superficie:
                valido = comprobar('recomendable', pintura, superficie)
                return (f"Sí, {pintura} sirve para {superficie}." if valido
                        else f"No consta que {pintura} sirva para {superficie}.")
            if uso:
                valido = comprobar('uso', pintura, uso)
                return (f"Sí, {pintura} está registrado para {uso}." if valido
                        else f"No consta que {pintura} sea para {uso}.")
            return f'{pintura} sirve para: {mostrar(consultar("sirve_para", pintura, "X"))}.'

        if superficie == 'metal' and ('oxido' in texto or 'corrosion' in texto):
            return f'Para proteger metal del óxido: {mostrar(consultar("protege_metal", "X"))}.'

        filtros = []
        for predicado, valor in [('es_marca', marca), ('sirve_para', superficie), ('uso', uso), ('tipo', tipo), ('acabado', acabado), ('caracteristica', caracteristica)]:
            if valor:
                filtros.append((predicado, valor))
        if len(filtros) > 1:
            return f'Pinturas que cumplen los criterios: {mostrar(filtrar(filtros))}.'
        if marca:
            return f'Productos de {marca}: {mostrar(consultar("producto_de_marca", "X", marca))}.'
        if superficie:
            return f'Pinturas para {superficie}: {mostrar(consultar("sirve_para", "X", superficie))}.'
        if uso:
            return f'Pinturas para {uso}: {mostrar(consultar("uso", "X", uso))}.'
        if acabado:
            return f'Pinturas con acabado {acabado}: {mostrar(consultar("acabado", "X", acabado))}.'
        if tipo:
            return f'Pinturas tipo {tipo}: {mostrar(consultar("tipo", "X", tipo))}.'
        if caracteristica:
            return f'Pinturas con {caracteristica}: {mostrar(consultar("caracteristica", "X", caracteristica))}.'
        return 'No entendí la pregunta. Consulta por marca, superficie, tipo, acabado, uso o características.'
    except (OSError, RuntimeError, subprocess.TimeoutExpired) as error:
        return f'Error Prolog: {error}'
