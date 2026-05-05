:- use_module(library(rbtrees)).

leer_items(Archivo, Items) :-
    open(Archivo, read, Flujo),
    read_term(Flujo, TerminoItems, []),
    close(Flujo),
    TerminoItems = (_ = Items).

crear_arbol_carnet(Arbol) :-
    leer_items('names2.txt', Items),
    rb_empty(ArbolVacio),
    agregar_estudiantes(Items, ArbolVacio, Arbol).

agregar_estudiantes([], Arbol, Arbol).
agregar_estudiantes([Entrada|Resto], Arbol0, Arbol) :-
    obtener_texto_estudiante(Entrada, TextoEstudiante),
    separar_estudiante(TextoEstudiante, Carnet, Nombre),
    rb_insert(Arbol0, Carnet, Nombre, Arbol1),
    agregar_estudiantes(Resto, Arbol1, Arbol).

obtener_texto_estudiante(TextoEstudiante-_, TextoEstudiante).
obtener_texto_estudiante(TextoEstudiante, TextoEstudiante).

separar_estudiante(TextoEstudiante, Carnet, Nombre) :-
    atom_string(TextoEstudiante, Texto),
    split_string(Texto, "-", " ", [TextoNombre, TextoCarnet]),
    number_string(Carnet, TextoCarnet),
    atom_string(Nombre, TextoNombre).

primeros_estudiantes(0, _, []).
primeros_estudiantes(_, [], []).
primeros_estudiantes(N, [Estudiante|Resto], [Estudiante|Primeros]) :-
    N > 0,
    SiguienteN is N - 1,
    primeros_estudiantes(SiguienteN, Resto, Primeros).

ejemplo :-
    crear_arbol_carnet(Arbol),
    rb_lookup(241018, Nombre, Arbol),
    format("El carnet 241018 pertenece a: ~w~n", [Nombre]),

    rb_visit(Arbol, EstudiantesPorCarnet),
    length(EstudiantesPorCarnet, Cantidad),
    primeros_estudiantes(10, EstudiantesPorCarnet, PrimerosDiez),
    format("Estudiantes cargados: ~w~n", [Cantidad]),
    format("Primeros 10 estudiantes por carnet: ~w~n", [PrimerosDiez]).
