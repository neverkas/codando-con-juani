%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parte 2 - La copa de las casas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

mago(Mago):-
    esDe(Mago, _).

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
