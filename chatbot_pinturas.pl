% -- PROYECTO 2 - PROLOG --
% -- SISTEMA EXPERTO / CHATBOT DE PINTURAS --
% Base principal alineada con Pinturas_Motta.pl

:- encoding(utf8).

% =============================
% HECHOS
% =============================

% PRODUCTOS pintura(X).
pintura(esmalte_sintetico).
pintura(esmalte_al_agua).
pintura(latex_interior).
pintura(latex_exterior).
pintura(oleo_opaco).
pintura(anticorrosivo).
pintura(barniz_marino).
pintura(laca_nitro).
pintura(spray_acrilico).
pintura(spray_alta_temperatura).
pintura(primer_automotriz).
pintura(impermeabilizante).
pintura(pintura_piso).
pintura(pintura_piscina).
pintura(pintura_tizada).

% MARCAS
marca(sipa).
marca(ceresita).
marca(tricolor).
marca(chilcorrofin).
marca(mtn).
marca(molotow).
marca(tekbond).
marca(toro_negro).

% MARCA DEL PRODUCTO
es_marca(esmalte_sintetico, sipa).
es_marca(esmalte_al_agua, ceresita).
es_marca(latex_interior, sipa).
es_marca(latex_exterior, tricolor).
es_marca(oleo_opaco, chilcorrofin).
es_marca(anticorrosivo, chilcorrofin).
es_marca(barniz_marino, sipa).
es_marca(laca_nitro, sipa).
es_marca(spray_acrilico, mtn).
es_marca(spray_alta_temperatura, tekbond).
es_marca(primer_automotriz, tekbond).
es_marca(impermeabilizante, ceresita).
es_marca(pintura_piso, tricolor).
es_marca(pintura_piscina, chilcorrofin).
es_marca(pintura_tizada, toro_negro).

% TIPO / BASE
tipo(esmalte_sintetico, solvente).
tipo(esmalte_al_agua, agua).
tipo(latex_interior, agua).
tipo(latex_exterior, agua).
tipo(oleo_opaco, solvente).
tipo(anticorrosivo, solvente).
tipo(barniz_marino, solvente).
tipo(laca_nitro, solvente).
tipo(spray_acrilico, aerosol).
tipo(spray_alta_temperatura, aerosol).
tipo(primer_automotriz, aerosol).
tipo(impermeabilizante, agua).
tipo(pintura_piso, agua).
tipo(pintura_piscina, solvente).
tipo(pintura_tizada, aerosol).

% ACABADOS
acabado(esmalte_sintetico, brillante).
acabado(esmalte_al_agua, semibrillo).
acabado(latex_interior, mate).
acabado(latex_exterior, mate).
acabado(oleo_opaco, mate).
acabado(anticorrosivo, mate).
acabado(barniz_marino, brillante).
acabado(laca_nitro, brillante).
acabado(spray_acrilico, mate).
acabado(spray_acrilico, brillante).
acabado(spray_alta_temperatura, mate).
acabado(primer_automotriz, mate).
acabado(impermeabilizante, mate).
acabado(pintura_piso, semibrillo).
acabado(pintura_piscina, semibrillo).
acabado(pintura_tizada, mate).

% SUPERFICIES
superficie(madera).
superficie(metal).
superficie(muro).
superficie(hormigon).
superficie(yeso).
superficie(auto).
superficie(piscina).
superficie(piso).
superficie(graffiti).

% PRODUCTO APTO PARA SUPERFICIE
sirve_para(esmalte_sintetico, madera).
sirve_para(esmalte_sintetico, metal).
sirve_para(esmalte_al_agua, madera).
sirve_para(esmalte_al_agua, metal).
sirve_para(latex_interior, muro).
sirve_para(latex_interior, yeso).
sirve_para(latex_exterior, muro).
sirve_para(latex_exterior, hormigon).
sirve_para(oleo_opaco, madera).
sirve_para(oleo_opaco, metal).
sirve_para(anticorrosivo, metal).
sirve_para(barniz_marino, madera).
sirve_para(laca_nitro, madera).
sirve_para(spray_acrilico, metal).
sirve_para(spray_acrilico, madera).
sirve_para(spray_acrilico, graffiti).
sirve_para(spray_alta_temperatura, metal).
sirve_para(primer_automotriz, auto).
sirve_para(primer_automotriz, metal).
sirve_para(impermeabilizante, muro).
sirve_para(impermeabilizante, hormigon).
sirve_para(pintura_piso, piso).
sirve_para(pintura_piso, hormigon).
sirve_para(pintura_piscina, piscina).
sirve_para(pintura_tizada, graffiti).

% USO: interior / exterior
uso(esmalte_sintetico, interior).
uso(esmalte_sintetico, exterior).
uso(esmalte_al_agua, interior).
uso(esmalte_al_agua, exterior).
uso(latex_interior, interior).
uso(latex_exterior, exterior).
uso(oleo_opaco, interior).
uso(anticorrosivo, exterior).
uso(barniz_marino, exterior).
uso(laca_nitro, interior).
uso(spray_acrilico, interior).
uso(spray_acrilico, exterior).
uso(spray_alta_temperatura, exterior).
uso(primer_automotriz, exterior).
uso(impermeabilizante, exterior).
uso(pintura_piso, interior).
uso(pintura_piso, exterior).
uso(pintura_piscina, exterior).
uso(pintura_tizada, exterior).

% CARACTERISTICAS
caracteristica(anticorrosivo, protege_oxido).
caracteristica(barniz_marino, resistente_humedad).
caracteristica(latex_exterior, resistente_clima).
caracteristica(impermeabilizante, repele_agua).
caracteristica(spray_alta_temperatura, resistente_calor).
caracteristica(primer_automotriz, mejora_adherencia).
caracteristica(pintura_piscina, resistente_agua).
caracteristica(pintura_piso, alto_transito).
caracteristica(spray_acrilico, secado_rapido).
caracteristica(pintura_tizada, alta_cobertura).

% =============================
% REGLAS
% =============================

recomendable(Pintura, Superficie) :-
    pintura(Pintura),
    superficie(Superficie),
    sirve_para(Pintura, Superficie).

recomendable_uso(Pintura, Superficie, Uso) :-
    pintura(Pintura),
    superficie(Superficie),
    member(Uso, [interior, exterior]),
    sirve_para(Pintura, Superficie),
    uso(Pintura, Uso).

para_exterior(Pintura) :-
    pintura(Pintura),
    uso(Pintura, exterior).

para_interior(Pintura) :-
    pintura(Pintura),
    uso(Pintura, interior).

al_agua(Pintura) :-
    tipo(Pintura, agua).

en_aerosol(Pintura) :-
    tipo(Pintura, aerosol).

es_mate(Pintura) :-
    acabado(Pintura, mate).

metal_exterior(Pintura) :-
    sirve_para(Pintura, metal),
    uso(Pintura, exterior).

protege_metal(Pintura) :-
    sirve_para(Pintura, metal),
    caracteristica(Pintura, protege_oxido).

producto_de_marca(Pintura, Marca) :-
    pintura(Pintura),
    marca(Marca),
    es_marca(Pintura, Marca).

comparten_superficie(P1, P2, Superficie) :-
    sirve_para(P1, Superficie),
    sirve_para(P2, Superficie),
    P1 \= P2.

producto_con_caracteristica(Pintura, Caracteristica) :-
    pintura(Pintura),
    caracteristica(Pintura, Caracteristica).

% =============================
% CONSULTAS DE EJEMPLO
% =============================

% ?- pintura(latex_interior).
% ?- tipo(latex_interior, Tipo).
% ?- sirve_para(Pintura, metal).
% ?- para_exterior(Pintura).
% ?- producto_de_marca(Pintura, tekbond).
% ?- es_mate(Pintura).
% ?- al_agua(Pintura).
% ?- en_aerosol(Pintura).
% ?- protege_metal(Pintura).
% ?- recomendable(anticorrosivo, metal).
% ?- recomendable_uso(Pintura, metal, exterior).
% ?- sirve_para(Pintura, piscina).
% ?- sirve_para(Pintura, graffiti).
% ?- comparten_superficie(spray_acrilico, Otro, Superficie).

% =============================
% CHATBOT DE TERMINAL
% =============================
% Para iniciarlo manualmente:
% ?- iniciar_chat.
%
% No se usa initialization/1 porque este archivo también es consultado
% desde Python y una inicialización automática bloquearía la API web.

iniciar_chat :-
    nl,
    write('---------------------------------------------'), nl,
    write('Bienvenido al chatbot de Pinturas Motta!'), nl,
    write('Puedes preguntar por pinturas, marcas, tipos,'), nl,
    write('superficies, acabados y usos.'), nl,
    write('Escribe "salir" para terminar.'), nl,
    write('---------------------------------------------'), nl,
    bucle_chat.

bucle_chat :-
    nl,
    write('Usuario > '),
    flush_output(current_output),
    read_line_to_string(user_input, Frase),
    (   Frase == "salir"
    ->  write('Bot > Hasta pronto!'), nl
    ;   procesar_consulta(Frase, Respuesta),
        format('Bot > ~w~n', [Respuesta]),
        bucle_chat
    ).

procesar_consulta(Frase, Respuesta) :-
    string_lower(Frase, FraseMinus),
    split_string(FraseMinus, " ", " ,.?¿¡!", TokenStr),
    maplist(atom_string, Tokens, TokenStr),
    interpretar(Tokens, Respuesta).

interpretar(Tokens, Respuesta) :-
    (member(hola, Tokens) ; member(buenas, Tokens)),
    !,
    Respuesta = 'Hola! Preguntame por pinturas, marcas, superficies, tipos o acabados.'.

interpretar(Tokens, Respuesta) :-
    member(marca, Tokens),
    member(Pintura, Tokens),
    pintura(Pintura),
    !,
    findall(M, es_marca(Pintura, M), Marcas),
    format(string(Respuesta), 'La pintura ~w es de la marca: ~w', [Pintura, Marcas]).

interpretar(Tokens, Respuesta) :-
    member(Marca, Tokens),
    marca(Marca),
    !,
    findall(P, es_marca(P, Marca), Productos),
    format(string(Respuesta), 'Los productos de la marca ~w son: ~w', [Marca, Productos]).

interpretar(Tokens, Respuesta) :-
    (member(sirve, Tokens) ; member(superficie, Tokens)),
    member(Pintura, Tokens),
    pintura(Pintura),
    !,
    findall(S, sirve_para(Pintura, S), Superficies),
    format(string(Respuesta), '~w sirve para las siguientes superficies: ~w', [Pintura, Superficies]).

interpretar(Tokens, Respuesta) :-
    member(Superficie, Tokens),
    superficie(Superficie),
    !,
    findall(P, sirve_para(P, Superficie), Pinturas),
    format(string(Respuesta), 'Las pinturas recomendadas para ~w son: ~w', [Superficie, Pinturas]).

interpretar(Tokens, Respuesta) :-
    member(tipo, Tokens),
    member(Pintura, Tokens),
    pintura(Pintura),
    !,
    findall(T, tipo(Pintura, T), Tipos),
    format(string(Respuesta), 'La pintura ~w es de tipo/base: ~w', [Pintura, Tipos]).

interpretar(Tokens, Respuesta) :-
    member(acabado, Tokens),
    member(Pintura, Tokens),
    pintura(Pintura),
    !,
    findall(A, acabado(Pintura, A), Acabados),
    format(string(Respuesta), 'La pintura ~w tiene acabado: ~w', [Pintura, Acabados]).

interpretar(Tokens, Respuesta) :-
    member(Acabado, Tokens),
    member(Acabado, [mate, brillante, semibrillo]),
    !,
    findall(P, acabado(P, Acabado), Pinturas),
    format(string(Respuesta), 'Las pinturas con acabado ~w son: ~w', [Acabado, Pinturas]).

interpretar(Tokens, Respuesta) :-
    member(Uso, Tokens),
    member(Uso, [interior, exterior]),
    !,
    findall(P, uso(P, Uso), Pinturas),
    format(string(Respuesta), 'Las pinturas para ~w son: ~w', [Uso, Pinturas]).

interpretar(Tokens, Respuesta) :-
    member(Pintura, Tokens), pintura(Pintura),
    member(Superficie, Tokens), superficie(Superficie),
    !,
    (   recomendable(Pintura, Superficie)
    ->  format(string(Respuesta), 'Si, ~w es recomendable para ~w.', [Pintura, Superficie])
    ;   format(string(Respuesta), 'No, ~w no esta registrada como recomendable para ~w.', [Pintura, Superficie])
    ).

interpretar(Tokens, Respuesta) :-
    (member(caracteristica, Tokens) ; member(caracteristicas, Tokens)),
    member(Pintura, Tokens),
    pintura(Pintura),
    !,
    findall(C, caracteristica(Pintura, C), Caracteristicas),
    (   Caracteristicas \= []
    ->  format(string(Respuesta), '~w tiene estas caracteristicas: ~w', [Pintura, Caracteristicas])
    ;   format(string(Respuesta), 'No hay caracteristicas especiales registradas para ~w.', [Pintura])
    ).

interpretar(_, 'No logro entender tu pregunta. Prueba preguntando por una pintura, marca, superficie, tipo, acabado o uso.').
