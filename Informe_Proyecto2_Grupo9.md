# Informe Proyecto N.º 2 – Grupo 9

## Fundamentos de Inteligencia Artificial

### Dominio: Pinturas y Recubrimientos

## 1. Dominio seleccionado
El dominio seleccionado corresponde a pinturas y recubrimientos utilizados en superficies de construcción, decoración y mantenimiento.

## 2. Justificación
Este dominio permite representar conocimiento mediante hechos y reglas claras. Las recomendaciones dependen de variables como superficie, ubicación, humedad, corrosión y tipo de protección requerida.

## 3. Objetivo
Desarrollar un chatbot capaz de orientar al usuario en la selección básica de pinturas y recubrimientos según superficie, ubicación y condiciones de uso.

## 4. Modelamiento del conocimiento
Superficies: madera, metal, hormigón, yeso y ladrillo.

Ubicaciones: interior y exterior.

Pinturas: látex, esmalte al agua, esmalte sintético, acrílica, anticorrosivo y barniz.

Condiciones: humedad, corrosión y exposición exterior.

## 5. Predicados principales
- `es_superficie(X)`
- `es_pintura(X)`
- `apto_para(Pintura, Superficie)`
- `apto_ubicacion(Pintura, Ubicacion)`
- `protege_de(Pintura, Condicion)`
- `requiere_preparacion(Superficie, Paso)`
- `recomendar(Pintura, Superficie, Ubicacion)`
- `recomendar_proteccion(Pintura, Superficie, Condicion)`

## 6. Implementación Prolog
La versión Prolog se encuentra en `chatbot_pinturas.pl`. Contiene hechos, reglas de inferencia y un ciclo conversacional simple.

## 7. Implementación LLM + Python
La versión LLM se encuentra en `chatbot_llm.py` y utiliza como contexto la misma base de conocimiento del dominio.

## 8. Interfaz web
La interfaz se ejecuta desde `app.py` y permite elegir entre modo Prolog y modo LLM.

## 9. Evaluación con 20 preguntas
El archivo `preguntas_20.csv` contiene las 20 preguntas del dominio. El script `evaluar_20_preguntas.py` ejecuta ambas versiones y genera `resultados_20_preguntas.csv`.

## 10. Fortalezas y debilidades

### Prolog
**Fortalezas**
- Respuestas deterministas.
- Fácil trazabilidad de las reglas.
- Permite modificar hechos y reglas de manera directa.

**Debilidades**
- Comprensión limitada del lenguaje natural.
- Requiere que el conocimiento esté definido previamente.
- Menor flexibilidad ante preguntas fuera del patrón esperado.

### LLM
**Fortalezas**
- Mayor flexibilidad lingüística.
- Comprende diferentes formas de expresar una misma consulta.
- Entrega respuestas más naturales.

**Debilidades**
- Puede generar respuestas no respaldadas si no se controla el contexto.
- Depende de una API externa.
- Sus respuestas pueden variar entre ejecuciones.

## 11. Propuestas de mejora
- Ampliar la base de conocimiento.
- Incorporar más superficies y tipos de pintura.
- Mejorar el reconocimiento de preguntas en Prolog.
- Agregar validación estructurada de respuestas del LLM.
- Registrar métricas de exactitud sobre las 20 preguntas.
- Mejorar la interfaz web y manejo de errores.

## 12. Conclusión
El proyecto permite comparar un sistema basado en lógica explícita con un sistema basado en un modelo de lenguaje. Prolog ofrece mayor control y explicabilidad, mientras que el LLM entrega mayor flexibilidad para interpretar lenguaje natural. La comparación de ambos enfoques se completará con los resultados reales de las 20 preguntas.
