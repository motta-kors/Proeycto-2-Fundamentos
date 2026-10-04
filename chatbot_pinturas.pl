% ============================================================
% PROYECTO N°2 - FUNDAMENTOS DE INTELIGENCIA ARTIFICIAL
% Chatbot experto en pinturas y recubrimientos
% Implementación en Prolog
%
% Recomendado: SWI-Prolog
% Abrir este archivo en Visual Studio Code y ejecutar:
%   swipl -s chatbot_pinturas.pl
% Luego:
%   ?- iniciar.
% ============================================================

:- encoding(utf8).

% ------------------------------------------------------------
% 1. BASE DE CONOCIMIENTO
% ------------------------------------------------------------

% Superficies conocidas
es_superficie(madera).
es_superficie(metal).
es_superficie(hormigon).
es_superficie(yeso).
es_superficie(ladrillo).

% Ubicaciones
es_ubicacion(interior).
es_ubicacion(exterior).

% Tipos de pintura / recubrimiento
es_pintura(latex).
es_pintura(esmalte_agua).
es_pintura(esmalte_sintetico).
es_pintura(acrilica).
es_pintura(anticorrosivo).
es_pintura(barniz).

% Compatibilidad pintura - superficie
apto_para(latex, yeso).
apto_para(latex, hormigon).
apto_para(latex, ladrillo).

apto_para(esmalte_agua, madera).
apto_para(esmalte_agua, metal).

apto_para(esmalte_sintetico, madera).
apto_para(esmalte_sintetico, metal).

apto_para(acrilica, hormigon).
apto_para(acrilica, ladrillo).

apto_para(anticorrosivo, metal).
apto_para(barniz, madera).

% Compatibilidad pintura - ubicación
apto_ubicacion(latex, interior).
apto_ubicacion(esmalte_agua, interior).
apto_ubicacion(esmalte_agua, exterior).
apto_ubicacion(esmalte_sintetico, interior).
apto_ubicacion(esmalte_sintetico, exterior).
apto_ubicacion(acrilica, interior).
apto_ubicacion(acrilica, exterior).
apto_ubicacion(anticorrosivo, interior).
apto_ubicacion(anticorrosivo, exterior).
apto_ubicacion(barniz, interior).
apto_ubicacion(barniz, exterior).

% Protección entregada por algunos productos
protege_de(anticorrosivo, corrosion).
protege_de(esmalte_sintetico, humedad).
protege_de(acrilica, exposicion_exterior).
protege_de(barniz, humedad).

% Preparación básica sugerida según superficie
requiere_preparacion(madera, lijar).
requiere_preparacion(madera, limpiar_polvo).
requiere_preparacion(metal, eliminar_oxido).
requiere_preparacion(metal, desengrasar).
requiere_preparacion(hormigon, limpiar).
requiere_preparacion(hormigon, secar).
requiere_preparacion(yeso, limpiar).
requiere_preparacion(yeso, sellar_si_es_necesario).
requiere_preparacion(ladrillo, limpiar).
requiere_preparacion(ladrillo, secar).

% ------------------------------------------------------------
% 2. REGLAS DE INFERENCIA
% ------------------------------------------------------------

recomendar(Pintura, Superficie, Ubicacion) :-
    es_superficie(Superficie),
    es_ubicacion(Ubicacion),
    apto_para(Pintura, Superficie),
    apto_ubicacion(Pintura, Ubicacion).

recomendar_proteccion(Pintura, Superficie, Condicion) :-
    es_superficie(Superficie),
    apto_para(Pintura, Superficie),
    protege_de(Pintura, Condicion).

preparacion(Superficie, Paso) :-
    es_superficie(Superficie),
    requiere_preparacion(Superficie, Paso).

% ------------------------------------------------------------
% 3. RESPUESTAS DEL CHATBOT
% ------------------------------------------------------------

mostrar_lista([]) :-
    writeln('  - No se encontraron resultados con el conocimiento actual.').

mostrar_lista(Lista) :-
    Lista \= [],
    forall(member(Elemento, Lista),
           format('  - ~w~n', [Elemento])).

responder_recomendacion(Superficie, Ubicacion) :-
    findall(Pintura,
            recomendar(Pintura, Superficie, Ubicacion),
            Pinturas0),
    sort(Pinturas0, Pinturas),
    format('Para ~w en ~w, las opciones registradas son:~n',
           [Superficie, Ubicacion]),
    mostrar_lista(Pinturas).

responder_proteccion(Superficie, Condicion) :-
    findall(Pintura,
            recomendar_proteccion(Pintura, Superficie, Condicion),
            Pinturas0),
    sort(Pinturas0, Pinturas),
    format('Para una superficie de ~w con condición ~w:~n',
           [Superficie, Condicion]),
    mostrar_lista(Pinturas).

responder_preparacion(Superficie) :-
    findall(Paso,
            preparacion(Superficie, Paso),
            Pasos0),
    sort(Pasos0, Pasos),
    format('Preparación básica sugerida para ~w:~n', [Superficie]),
    mostrar_lista(Pasos).

% ------------------------------------------------------------
% 4. DETECCIÓN SIMPLE DE PALABRAS EN UNA PREGUNTA
% ------------------------------------------------------------

contiene(Texto, Palabra) :-
    sub_string(Texto, _, _, _, Palabra).

detectar_superficie(Texto, madera) :- contiene(Texto, "madera"), !.
detectar_superficie(Texto, metal) :- contiene(Texto, "metal"), !.
detectar_superficie(Texto, hormigon) :- contiene(Texto, "hormigon"), !.
detectar_superficie(Texto, hormigon) :- contiene(Texto, "hormigón"), !.
detectar_superficie(Texto, yeso) :- contiene(Texto, "yeso"), !.
detectar_superficie(Texto, ladrillo) :- contiene(Texto, "ladrillo"), !.

detectar_ubicacion(Texto, exterior) :- contiene(Texto, "exterior"), !.
detectar_ubicacion(Texto, interior) :- contiene(Texto, "interior"), !.

detectar_condicion(Texto, corrosion) :- contiene(Texto, "corrosion"), !.
detectar_condicion(Texto, corrosion) :- contiene(Texto, "corrosión"), !.
detectar_condicion(Texto, corrosion) :- contiene(Texto, "oxido"), !.
detectar_condicion(Texto, corrosion) :- contiene(Texto, "óxido"), !.
detectar_condicion(Texto, humedad) :- contiene(Texto, "humedad"), !.
detectar_condicion(Texto, exposicion_exterior) :-
    contiene(Texto, "exposicion"), !.
detectar_condicion(Texto, exposicion_exterior) :-
    contiene(Texto, "exposición"), !.

es_pregunta_preparacion(Texto) :-
    ( contiene(Texto, "prepar")
    ; contiene(Texto, "antes")
    ; contiene(Texto, "limpiar")
    ; contiene(Texto, "lijar")
    ).

% ------------------------------------------------------------
% 5. INTERPRETACIÓN DE LA PREGUNTA
% ------------------------------------------------------------

procesar_pregunta(TextoOriginal) :-
    string_lower(TextoOriginal, Texto),
    (
        Texto = "salir"
        -> writeln('Hasta luego.')
    ;
        es_pregunta_preparacion(Texto),
        detectar_superficie(Texto, Superficie)
        -> responder_preparacion(Superficie),
           continuar
    ;
        detectar_superficie(Texto, Superficie),
        detectar_condicion(Texto, Condicion)
        -> responder_proteccion(Superficie, Condicion),
           continuar
    ;
        detectar_superficie(Texto, Superficie),
        detectar_ubicacion(Texto, Ubicacion)
        -> responder_recomendacion(Superficie, Ubicacion),
           continuar
    ;
        detectar_superficie(Texto, Superficie)
        -> format('Entendí la superficie: ~w.~n', [Superficie]),
           writeln('Indica también si es interior o exterior.'),
           continuar
    ;
        writeln('No pude interpretar la pregunta con el conocimiento actual.'),
        writeln('Ejemplos:'),
        writeln('  - Que pintura sirve para madera exterior?'),
        writeln('  - Que pintura sirve para metal con corrosion?'),
        writeln('  - Como preparo una superficie de madera?'),
        continuar
    ).

continuar :-
    nl,
    writeln('Escribe otra pregunta o escribe "salir":'),
    read_line_to_string(user_input, Entrada),
    procesar_pregunta(Entrada).

% ------------------------------------------------------------
% 6. INICIO DEL CHATBOT
% ------------------------------------------------------------

iniciar :-
    nl,
    writeln('====================================================='),
    writeln('   CHATBOT EXPERTO EN PINTURAS Y RECUBRIMIENTOS'),
    writeln('====================================================='),
    writeln('Puedes preguntar, por ejemplo:'),
    writeln('  - Que pintura sirve para madera exterior?'),
    writeln('  - Que pintura sirve para metal interior?'),
    writeln('  - Que pintura sirve para metal con corrosion?'),
    writeln('  - Como preparo una superficie de hormigon?'),
    writeln('Escribe "salir" para terminar.'),
    nl,
    read_line_to_string(user_input, Entrada),
    procesar_pregunta(Entrada).

% ------------------------------------------------------------
% 7. CONSULTAS DIRECTAS DE PRUEBA
% ------------------------------------------------------------
%
% ?- recomendar(P, madera, exterior).
% ?- recomendar(P, metal, interior).
% ?- recomendar_proteccion(P, metal, corrosion).
% ?- preparacion(madera, Paso).
% ?- iniciar.
%
