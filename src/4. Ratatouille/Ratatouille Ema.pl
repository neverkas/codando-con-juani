/*
1. inspeccionSatisfactoria/1 se cumple para un restaurante cuando no viven ratas allí.
*/
% rata(Rata, Lugar)
rata(remy, gusteaus).
rata(emile, bar).
rata(django, pizzeria).

% trabajaEn(Restaurante, Empleado)
trabajaEn(gusteaus, linguini).
trabajaEn(gusteaus, colette).
trabajaEn(gusteaus, skinner).
trabajaEn(gusteaus, horst).
trabajaEn(cafeDes2Moulins, amelie).

inspeccionSatisfactoria(Restaurante):-
    restaurante(Restaurante),
    not(rata(_, Restaurante)).

restaurante(Restaurante):-
    trabajaEn(Restaurante, _).


/*
2. chef/2: relaciona un empleado con un restaurante si el empleado trabaja allí 
y sabe cocinar algún plato.
*/
% cocina(Empleado, Plato, Experiencia)
cocina(linguini, ratatouille, 3).
cocina(linguini, sopa, 5). 
cocina(colette, salmonAsado, 9).
cocina(horst, ensaladaRusa, 8).

chef(Empleado, Restaurante):-
    trabajaEn(Restaurante, Empleado),
    cocina(Empleado, _, _).

/*
3. chefcito/1: se cumple para una rata si vive en el mismo restaurante donde trabaja linguini.
*/
chefcito(Rata):-
    rata(Rata, Lugar), 
    trabajaEn(Lugar, linguini).

/*
4. cocinaBien/2 es verdadero para una persona si su experiencia preparando ese plato es mayor a 7.
Además, remy cocina bien cualquier plato que exista.
*/
cocinaBien(Empleado, Plato):-
    plato(Plato),
    cocina(Empleado, Plato, Experiencia),
    Experiencia > 7.
cocinaBien(remy, Plato):-
    plato(Plato).

plato(Plato):-
    cocina(_, Plato, _).

/*
5. encargadoDe/3:
nos dice el encargado de cocinar un plato en un restaurante, 
que es quien más experiencia tiene preparándolo en ese lugar.
*//*
encargadoDe(Plato, Restaurante, Quien):-
    forall(

    ).
*/
