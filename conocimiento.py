CONOCIMIENTO = '''
DOMINIO: Pinturas y recubrimientos.

Pinturas registradas:
- esmalte_sintetico
- esmalte_al_agua
- latex_interior
- latex_exterior
- oleo_opaco
- anticorrosivo
- barniz_marino
- laca_nitro
- spray_acrilico
- spray_alta_temperatura
- primer_automotriz
- impermeabilizante
- pintura_piso
- pintura_piscina
- pintura_tizada

Marcas registradas:
sipa, ceresita, tricolor, chilcorrofin, mtn, molotow, tekbond, toro_negro.

Superficies:
madera, metal, muro, hormigon, yeso, auto, piscina, piso, graffiti.

Tipos/base:
agua, solvente, aerosol.

Acabados:
mate, brillante, semibrillo.

Relaciones principales:
- es_marca(Pintura, Marca)
- tipo(Pintura, Tipo)
- acabado(Pintura, Acabado)
- sirve_para(Pintura, Superficie)
- uso(Pintura, interior/exterior)
- caracteristica(Pintura, Caracteristica)

Características registradas:
- anticorrosivo: protege_oxido
- barniz_marino: resistente_humedad
- latex_exterior: resistente_clima
- impermeabilizante: repele_agua
- spray_alta_temperatura: resistente_calor
- primer_automotriz: mejora_adherencia
- pintura_piscina: resistente_agua
- pintura_piso: alto_transito
- spray_acrilico: secado_rapido
- pintura_tizada: alta_cobertura

REGLA PRINCIPAL:
Responder solamente con información respaldada por la base Prolog del proyecto.
No inventar productos, marcas, compatibilidades, acabados ni características.
Si la base no contiene la respuesta, indicarlo claramente.
'''.strip()
