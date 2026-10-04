CONOCIMIENTO = '''
DOMINIO: Pinturas y recubrimientos.

Superficies conocidas: madera, metal, hormigon, yeso, ladrillo.
Ubicaciones: interior, exterior.
Pinturas: latex, esmalte_agua, esmalte_sintetico, acrilica, anticorrosivo, barniz.

Compatibilidad pintura-superficie:
- latex: yeso, hormigon, ladrillo.
- esmalte_agua: madera, metal.
- esmalte_sintetico: madera, metal.
- acrilica: hormigon, ladrillo.
- anticorrosivo: metal.
- barniz: madera.

Compatibilidad por ubicacion:
- latex: interior.
- esmalte_agua: interior y exterior.
- esmalte_sintetico: interior y exterior.
- acrilica: interior y exterior.
- anticorrosivo: interior y exterior.
- barniz: interior y exterior.

Protecciones registradas:
- anticorrosivo protege contra corrosion.
- esmalte_sintetico protege frente a humedad.
- acrilica es apta para exposicion exterior.
- barniz protege madera frente a humedad.

Preparacion basica:
- madera: lijar y limpiar polvo.
- metal: eliminar oxido y desengrasar.
- hormigon: limpiar y secar.
- yeso: limpiar y sellar si es necesario.
- ladrillo: limpiar y secar.

REGLA PRINCIPAL:
Recomendar solo productos que esten explicitamente respaldados por este conocimiento.
Si falta informacion, indicarlo en vez de inventar datos.
'''.strip()
