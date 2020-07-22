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

prohibido(lugar(bosque), 50).
prohibido(lugar(biblioteca), 10).
prohibido(lugar(tercerPiso), 75).
prohibido(fueraDeCama, 50).
