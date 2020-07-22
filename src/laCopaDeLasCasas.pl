%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 2 - La copa de las casas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

casa(gryffindor).
casa(slytherin).
casa(ravenclaw).
casa(hufflepuff).

mago(Mago):-
    esDe(Mago, _).
/*
accion(fueraDeCama, mala).
accion(bosque, mala).
accion(tercerPiso, mala).
accion(biblioteca, mala).

accion(ajedrez, buena).
accion(salvarAmigo, buena).
accion(ganarleVoldemort, buena).
*/
bosque(50).
biblioteca(10).
tercerPiso(75).
fueraDeCama(50).

ajedrez(50).
salvarAmigo(50).
ganarleVoldemort(60).


accionBuena(ron, ajedrez).
accionBuena(hermione, salvarAmigo).
accionBuena(harry, ganarleVoldemort).
%accionBuena(draco, ajedrez). #Test en accionRecurente

/*acciones(harry, accion(fueraDeCama, 50)).
acciones(harry, accion(bosque, 50)).
acciones(harry, accion(tercerPiso, 75)).
acciones(harry, accion(ganarleVoldemort, 50)).
acciones(hermione, accion(salvarAmigo, 50)).
*/
acciones(Mago, accion(Puntos), Puntos).



accionMala(harry, fueraDeCama).
accionMala(harry, bosque).
accionMala(harry, tercerPiso).
accionMala(hermione, tercerPiso).
accionMala(hermione, biblioteca).
%accionMala(draco, bosque). #Test en accionRecurente

acciones(Mago, Accion):-
    accionBuena(Mago, Accion).
acciones(Mago, Accion):-
    accionMala(Mago, Accion).

buenAlumno(Mago):-
    mago(Mago),
    not(accionMala(Mago, _)).

accionRecurente(Accion):-
    mago(Mago), mago(OtroMago), Mago \= OtroMago,
    acciones(Mago, Accion),
    acciones(OtroMago, Accion).

%puntajeCasa(Casa, PuntajeTotal):-
%    casa(Casa).

puntoEstudiante(Mago, Puntaje):-
    mago(Mago),
    findall(AccionesMalas, accionMala(Mago, AccionesMalas), ListaAcciones),
    sum_list(ListaAcciones, Puntaje).
    