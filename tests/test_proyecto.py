import csv
import importlib.util
import os
import re
import subprocess
import shutil
import sys
import unittest
from pathlib import Path
from types import ModuleType, SimpleNamespace
from unittest.mock import patch

import conocimiento
import prolog_bridge
from chatbot_llm import responder_llm


class MotorSimulado:
    def __init__(self):
        self.hechos = conocimiento.leer_hechos()
        self.pinturas = [p for p, in self.hechos['pintura']]

    def cumple(self, predicado, args):
        valores = tuple(args)
        if predicado in self.hechos:
            return valores in self.hechos[predicado]
        if predicado == 'producto_de_marca':
            return self.cumple('es_marca', valores)
        if predicado == 'recomendable':
            return self.cumple('sirve_para', valores)
        if predicado == 'recomendable_uso':
            p, s, u = valores
            return self.cumple('sirve_para', (p, s)) and self.cumple('uso', (p, u))
        if predicado == 'protege_metal':
            return self.cumple('sirve_para', (valores[0], 'metal')) and self.cumple('caracteristica', (valores[0], 'protege_oxido'))
        raise AssertionError(predicado)

    def ejecutar(self, goal):
        verificacion = re.fullmatch(r'\((\w+)\(([a-z0-9_,]+)\)->write\(si\);write\(no\)\)', goal)
        if verificacion:
            p, argumentos = verificacion.groups()
            return ['si' if self.cumple(p, argumentos.split(',')) else 'no']
        consulta = re.fullmatch(r'forall\((.*),\(write\(X\),nl\)\)', goal)
        if not consulta:
            raise AssertionError(goal)
        condiciones = re.findall(r'(\w+)\(([a-z0-9_,X]+)\)', consulta.group(1))
        if len(condiciones) == 1:
            predicado, args = condiciones[0]
            argumentos = args.split(',')
            if argumentos[-1] == 'X' and argumentos[0] != 'X':
                return [v[1] for v in self.hechos[predicado] if v[0] == argumentos[0]]
        resultados = []
        for pintura in self.pinturas:
            if all(self.cumple(p, [pintura if a == 'X' else a for a in args.split(',')]) for p, args in condiciones):
                resultados.append(pintura)
        return resultados


class TestProyecto(unittest.TestCase):
    def test_conocimiento(self):
        hechos = conocimiento.leer_hechos()
        self.assertEqual(len(hechos['pintura']), 15)
        self.assertIn('sirve_para(anticorrosivo, metal)', conocimiento.construir_contexto())

    def test_veinte_preguntas(self):
        with patch.object(prolog_bridge, 'ejecutar', side_effect=MotorSimulado().ejecutar):
            with Path(__file__).resolve().parents[1].joinpath('preguntas_20.csv').open(encoding='utf-8-sig') as archivo:
                filas = list(csv.DictReader(archivo))
            self.assertEqual(len(filas), 20)
            for fila in filas:
                respuesta = prolog_bridge.responder_prolog(fila['pregunta'])
                with self.subTest(pregunta=fila['pregunta']):
                    self.assertNotIn('No entendí', respuesta)
                    self.assertNotIn('sin resultados', respuesta)
                    self.assertNotIn('Error Prolog', respuesta)

    def test_consultas_compuestas(self):
        with patch.object(prolog_bridge, 'ejecutar', side_effect=MotorSimulado().ejecutar):
            r1 = prolog_bridge.responder_prolog('¿El látex interior sirve para yeso exterior?')
            r2 = prolog_bridge.responder_prolog('¿Qué pinturas al agua sirven para metal exterior?')
            self.assertIn('No consta', r1)
            self.assertIn('esmalte_al_agua', r2)
            self.assertNotIn('anticorrosivo', r2)

    def test_groq_sin_clave(self):
        with patch.dict(os.environ, {}, clear=True):
            self.assertIn('GROQ_API_KEY', responder_llm('Hola'))

    def test_groq_con_clave(self):
        registro = {}
        modulo = ModuleType('groq')
        modulo.GroqError = type('GroqError', (Exception,), {})

        class Cliente:
            def __init__(self, **kwargs):
                registro['cliente'] = kwargs
                self.chat = SimpleNamespace(completions=SimpleNamespace(create=self.create))

            def create(self, **kwargs):
                registro['llamada'] = kwargs
                return SimpleNamespace(choices=[SimpleNamespace(message=SimpleNamespace(content='Groq OK'))])

        modulo.Groq = Cliente
        with patch.dict(sys.modules, {'groq': modulo}):
            with patch.dict(os.environ, {'GROQ_API_KEY': 'clave_prueba', 'GROQ_MODEL': 'modelo_prueba'}):
                self.assertEqual(responder_llm('¿Qué pintura sirve para metal?'), 'Groq OK')
        self.assertEqual(registro['cliente']['api_key'], 'clave_prueba')
        self.assertEqual(registro['llamada']['model'], 'modelo_prueba')
        self.assertIn('sirve_para(anticorrosivo, metal)', registro['llamada']['messages'][0]['content'])


@unittest.skipUnless(importlib.util.find_spec('flask'), 'Flask no está instalado')
class TestWeb(unittest.TestCase):
    def test_interfaz_y_consulta(self):
        from app import app
        cliente = app.test_client()
        self.assertEqual(cliente.get('/').status_code, 200)
        self.assertEqual(cliente.post('/api/chat', json={}).status_code, 400)
        with patch('app.responder_prolog', return_value='Respuesta de prueba'):
            r = cliente.post('/api/chat', json={'pregunta': 'Metal', 'modo': 'prolog'})
        self.assertEqual(r.get_json()['respuesta'], 'Respuesta de prueba')


@unittest.skipUnless(shutil.which(os.getenv('SWIPL_PATH', 'swipl')), 'SWI-Prolog no está instalado')
class TestPrologReal(unittest.TestCase):
    def test_regla(self):
        respuesta = prolog_bridge.ejecutar('(recomendable(anticorrosivo,metal)->write(si);write(no))')
        self.assertEqual(respuesta, ['si'])


if __name__ == '__main__':
    unittest.main()
