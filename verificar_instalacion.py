import importlib.util
import os
import shutil
from conocimiento import leer_hechos

if importlib.util.find_spec('dotenv'):
    from dotenv import load_dotenv
    load_dotenv()

for nombre in ('flask', 'groq', 'dotenv'):
    print(nombre, 'OK' if importlib.util.find_spec(nombre) else 'FALTA')
print('SWI-Prolog', 'OK' if shutil.which(os.getenv('SWIPL_PATH', 'swipl')) else 'FALTA')
print('GROQ_API_KEY', 'OK' if os.getenv('GROQ_API_KEY') else 'FALTA')
print('GROQ_MODEL', os.getenv('GROQ_MODEL', 'llama-3.1-8b-instant'))
print('Pinturas cargadas:', len(leer_hechos()['pintura']))
