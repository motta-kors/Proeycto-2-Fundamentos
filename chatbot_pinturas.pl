:- encoding(utf8).

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

marca(sipa).
marca(ceresita).
marca(tricolor).
marca(chilcorrofin).
marca(mtn).
marca(molotow).
marca(tekbond).
marca(toro_negro).

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

superficie(madera).
superficie(metal).
superficie(muro).
superficie(hormigon).
superficie(yeso).
superficie(auto).
superficie(piscina).
superficie(piso).
superficie(graffiti).

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

iniciar_chat :-
    nl,
    writeln('Chatbot de pinturas y recubrimientos'),
    writeln('Pregunta por marcas, superficies, tipos, acabados y usos.'),
    writeln('Escribe salir para terminar.'),
    bucle_chat.

iniciar :- iniciar_chat.

bucle_chat :-
    nl, write('Usuario > '), flush_output(current_output),
    read_line_to_string(user_input, Entrada),
    (   Entrada == end_of_file
    ->  true
    ;   normalizar_tokens(Entrada, Tokens),
        (   Tokens == [salir]
        ->  writeln('Bot > Hasta pronto!')
        ;   interpretar(Tokens, Respuesta),
            format('Bot > ~s~n', [Respuesta]),
            bucle_chat
        )
    ).

procesar_consulta(Frase, Respuesta) :-
    normalizar_tokens(Frase, Tokens),
    interpretar(Tokens, Respuesta).

sin_tilde('á', a) :- !.
sin_tilde('é', e) :- !.
sin_tilde('í', i) :- !.
sin_tilde('ó', o) :- !.
sin_tilde('ú', u) :- !.
sin_tilde('ü', u) :- !.
sin_tilde('ñ', n) :- !.
sin_tilde(C, C).

caracter_normalizado(Entrada, Salida) :-
    sin_tilde(Entrada, SinTilde),
    ( char_type(SinTilde, alnum) -> Salida = SinTilde ; Salida = ' ' ).

normalizar_tokens(Frase, Tokens) :-
    string_lower(Frase, Minusculas),
    string_chars(Minusculas, Caracteres),
    maplist(caracter_normalizado, Caracteres, Limpios),
    string_chars(Texto, Limpios),
    split_string(Texto, ' ', ' ', Palabras),
    maplist(atom_string, Tokens, Palabras).

quitar_secuencia(Lista, Buscada, Resto) :-
    append(Prefijo, Sufijo, Lista),
    append(Buscada, Cola, Sufijo),
    append(Prefijo, Cola, Resto), !.

identificar(Predicado, Tokens, Valor, Resto) :-
    call(Predicado, Valor),
    atomic_list_concat(Palabras, '_', Valor),
    quitar_secuencia(Tokens, Palabras, Resto), !.

alguna_palabra(Tokens, Opciones) :-
    member(Palabra, Opciones), member(Palabra, Tokens), !.

interpretar(Tokens, "Hola! Puedes preguntar por pinturas, marcas, superficies, tipos, acabados y usos.") :-
    alguna_palabra(Tokens, [hola, buenas]), !.

interpretar(Tokens, Respuesta) :-
    identificar(pintura, Tokens, Pintura, Resto),
    alguna_palabra(Resto, [marca, fabricante]), !,
    findall(M, es_marca(Pintura, M), Marcas),
    format(string(Respuesta), 'La marca de ~w es: ~w', [Pintura, Marcas]).

interpretar(Tokens, Respuesta) :-
    identificar(marca, Tokens, Marca, _), !,
    findall(P, producto_de_marca(P, Marca), Productos),
    format(string(Respuesta), 'Los productos de ~w son: ~w', [Marca, Productos]).

interpretar(Tokens, Respuesta) :-
    identificar(pintura, Tokens, Pintura, Resto),
    alguna_palabra(Resto, [tipo, base]), !,
    findall(T, tipo(Pintura, T), Tipos),
    format(string(Respuesta), 'La pintura ~w es de tipo/base: ~w', [Pintura, Tipos]).

interpretar(Tokens, Respuesta) :-
    identificar(pintura, Tokens, Pintura, Resto),
    member(acabado, Resto), !,
    findall(A, acabado(Pintura, A), Acabados),
    format(string(Respuesta), 'El acabado de ~w es: ~w', [Pintura, Acabados]).

interpretar(Tokens, Respuesta) :-
    identificar(pintura, Tokens, Pintura, Resto),
    alguna_palabra(Resto, [caracteristica, caracteristicas, propiedad, propiedades]), !,
    findall(C, caracteristica(Pintura, C), Caracteristicas),
    format(string(Respuesta), 'Caracteristicas de ~w: ~w', [Pintura, Caracteristicas]).

interpretar(Tokens, Respuesta) :-
    identificar(pintura, Tokens, Pintura, Resto),
    identificar(superficie, Resto, Superficie, Resto2),
    member(Uso, [interior, exterior]), member(Uso, Resto2), !,
    ( recomendable_uso(Pintura, Superficie, Uso)
    -> format(string(Respuesta), 'Si, ~w esta registrada para ~w en ~w.', [Pintura, Superficie, Uso])
    ;  format(string(Respuesta), 'No consta uso de ~w para ~w en ~w.', [Pintura, Superficie, Uso]) ).

interpretar(Tokens, Respuesta) :-
    identificar(pintura, Tokens, Pintura, Resto),
    identificar(superficie, Resto, Superficie, _), !,
    ( recomendable(Pintura, Superficie)
    -> format(string(Respuesta), 'Si, ~w esta registrada para ~w.', [Pintura, Superficie])
    ;  format(string(Respuesta), 'No consta que ~w sirva para ~w.', [Pintura, Superficie]) ).

interpretar(Tokens, Respuesta) :-
    identificar(pintura, Tokens, Pintura, Resto),
    member(Uso, [interior, exterior]), member(Uso, Resto), !,
    ( uso(Pintura, Uso)
    -> format(string(Respuesta), 'Si, ~w esta registrada para ~w.', [Pintura, Uso])
    ;  format(string(Respuesta), 'No consta uso de ~w en ~w.', [Pintura, Uso]) ).

interpretar(Tokens, Respuesta) :-
    identificar(pintura, Tokens, Pintura, Resto),
    alguna_palabra(Resto, [sirve, superficies, superficie, usar, uso]), !,
    findall(S, sirve_para(Pintura, S), Superficies),
    format(string(Respuesta), '~w sirve para: ~w', [Pintura, Superficies]).

interpretar(Tokens, Respuesta) :-
    identificar(superficie, Tokens, metal, _),
    alguna_palabra(Tokens, [oxido, corrosion]), !,
    findall(P, protege_metal(P), Pinturas),
    format(string(Respuesta), 'Para proteger metal del oxido: ~w', [Pinturas]).

interpretar(Tokens, Respuesta) :-
    identificar(superficie, Tokens, Superficie, Resto),
    member(Uso, [interior, exterior]), member(Uso, Resto), !,
    findall(P, recomendable_uso(P, Superficie, Uso), Pinturas),
    format(string(Respuesta), 'Pinturas para ~w en ~w: ~w', [Superficie, Uso, Pinturas]).

interpretar(Tokens, Respuesta) :-
    identificar(superficie, Tokens, Superficie, _), !,
    findall(P, sirve_para(P, Superficie), Pinturas),
    format(string(Respuesta), 'Pinturas para ~w: ~w', [Superficie, Pinturas]).

interpretar(Tokens, Respuesta) :-
    member(Uso, [interior, exterior]), member(Uso, Tokens), !,
    findall(P, uso(P, Uso), Pinturas),
    format(string(Respuesta), 'Pinturas para ~w: ~w', [Uso, Pinturas]).

interpretar(Tokens, Respuesta) :-
    member(Acabado, [mate, brillante, semibrillo]), member(Acabado, Tokens), !,
    findall(P, acabado(P, Acabado), Pinturas),
    format(string(Respuesta), 'Pinturas con acabado ~w: ~w', [Acabado, Pinturas]).

interpretar(Tokens, Respuesta) :-
    member(agua, Tokens), !,
    findall(P, al_agua(P), Pinturas),
    format(string(Respuesta), 'Pinturas al agua: ~w', [Pinturas]).

interpretar(Tokens, Respuesta) :-
    alguna_palabra(Tokens, [aerosol, aerosoles]), !,
    findall(P, en_aerosol(P), Pinturas),
    format(string(Respuesta), 'Pinturas en aerosol: ~w', [Pinturas]).

interpretar(Tokens, Respuesta) :-
    member(solvente, Tokens), !,
    findall(P, tipo(P, solvente), Pinturas),
    format(string(Respuesta), 'Pinturas base solvente: ~w', [Pinturas]).

interpretar(_, "No pude interpretar la pregunta. Consulta por pinturas, marcas, superficies, usos, tipos o acabados.").
