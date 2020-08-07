jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

%lugar(zona, personajes adentro, nivel oscuridad).
lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).


%Punto 1.a  - Emi
/*
% a. Relacionar un jugador con un ítem que posee. tieneItem/2
*/
tieneItem(Jugador, Item):-
    jugador(Jugador, Items, _),
    member(Item, Items).

%Punto 1.b  - Emi
/*
b. Saber si un jugador se preocupa por su salud, esto es si tiene entre sus ítems más de un tipo de comestible.
 (Tratar de resolver sin findall) sePreocupaPorSuSalud/1

 "pendiente"
*/
sePreocupaPorSuSalud(Jugador):-
    jugador(Jugador, Items, _),
    %comestibles(Items, Comestibles),    
    member(Item1, Items), member(Item2, Items),
    comestible(Item1), comestible(Item2).

%Punto 1.c  - Emi
/*
c. Relacionar un jugador con un ítem que existe (un ítem existe si lo tiene alguien), 
y la cantidad que tiene de ese ítem. Si no posee el ítem, la cantidad es 0. cantidadDeItem/3
*/
cantidadDeItem(_, Item, 0):-
    not(tieneItem(_, Item)).

cantidadDeItem(Jugador, Item, Cantidad):-
    tieneItem(_, Item),
    findall(Item, tieneItem(Jugador, Item), ListaItems),
    length(ListaItems, Cantidad).

items(Item):-
    jugador(_, Items, _),
    member(Item, Items).

%Punto 1.d  - Emi
/*
d. Relacionar un jugador con un ítem, si de entre todos los jugadores, 
es el que más cantidad tiene de ese ítem. tieneMasDe/2
*/
tieneMasDe(Jugador, Item):-
    cantidadDeItem(Jugador, Item, Cantidad1),
    forall((cantidadDeItem(Jugador2, Item, Cantidad2), Jugador \= Jugador2), Cantidad1 > Cantidad2).

%Punto 2.a  - Emi
/*
a. Obtener los lugares en los que hay monstruos. Se sabe que los monstruos aparecen en los 
lugares cuyo nivel de oscuridad es más de 6. hayMonstruos/1
*/
hayMonstruos(Lugar):-
    lugar(Lugar, _, Oscuridad),
    Oscuridad > 6.

%Punto 2.b  - Emi
/*
b. Saber si un jugador corre peligro. Un jugador corre peligro si se encuentra en un lugar 
donde hay monstruos; o si está hambriento (hambre < 4) y no cuenta con ítems comestibles. correPeligro/1
*/
correPeligro(Jugador):-
    esDe(Lugar, Jugador),
    hayMonstruos(Lugar).

correPeligro(Jugador):-
    hambriento(Jugador),
    not(sePreocupaPorSuSalud(Jugador)).

esDe(Lugar, Jugador):-
    lugar(Lugar, Personajes, _),
    member(Jugador, Personajes).

%Punto 2.c  - Emi
/*
c. Obtener el nivel de peligrosidad de un lugar, el cual es un número de 0 a 100 y se calcula:
- Si no hay monstruos, es el porcentaje de hambrientos sobre su población total.
- Si hay monstruos, es 100.
- Si el lugar no está poblado, sin importar la presencia de monstruos, es su nivel de oscuridad * 10. nivelPeligrosidad/2

jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).
lugar(playa, [stuart, tim], 2).

*/


nivelPeligrosidad(Lugar, 100):-
    hayMonstruos(Lugar). 

nivelPeligrosidad(Lugar, Nivel):-
    lugar(Lugar, _, Oscuridad),
    Nivel is Oscuridad*10,
    not(hayHabitantes(Lugar)).

/* - Si no hay monstruos, es el porcentaje de hambrientos sobre su población total. */
/*  TENGO DUDAS (?) */

nivelPeligrosidad(Lugar, Nivel):-
    poblacion(Lugar, Poblacion, CantidadPoblacion),
    hambrientos(Poblacion, _, CantidadHambrientos), 
    
    %PorcentajeHambrientos is (CantidadPoblacion/CantidadHambrientos)/100,
    Nivel is (CantidadHambrientos/CantidadPoblacion)*100,
    not(hayMonstruos(Lugar)).

hayHabitantes(Lugar):-
    poblacion(Lugar, _, CantidadPoblacion),
    CantidadPoblacion > 0.

hambrientos(Poblacion, Hambrientos, Cuantos):-
    findall( Jugador, (member(Jugador, Poblacion), hambriento(Jugador)), Hambrientos ),
    length(Hambrientos, Cuantos).

poblacion(Lugar, Poblacion, Cuantos):-
    findall( Jugador, (lugar(Lugar, Jugadores, _), member(Jugador, Jugadores)), Poblacion ),
    length(Poblacion, Cuantos).

hambriento(Jugador):-
    jugador(Jugador, _, Hambre),
    Hambre < 4.

%Punto 3  - Emi

puedeConstruir(Jugador, Item):-
    jugador(Jugador, _, _), item(Item, Componentes),
    member(Componente, Componentes),

    clasificarTipo(Componente, Componentes, Simple, CantidadRequerida),
    cantidadDeItem(Jugador, Simple, CantidadJugador),
    CantidadJugador >= CantidadRequerida.

clasificarTipo(itemSimple(Simple, CantidadRequerida), _, Simple, CantidadRequerida).

clasificarTipo(itemCompuesto(Compuesto), Componentes, Simple, CantidadRequerida):-
    member(itemCompuesto(Compuesto), Componentes),
    item(Compuesto, Simples),
    member(itemSimple(Simple, CantidadRequerida), Simples).

/*****************************************************************************/
/*
% este repite logica, no lo hagas again porfis (?)

puedeConstruir(Jugador, Item):-
    %jugador(Jugador, _, _), item(Item, Componentes),
    member(itemSimple(Simple, CantidadRequerida), Componentes),
    %cantidadDeItem(Jugador, Simple, CantidadJugador),
    %CantidadJugador >= CantidadRequerida.

puedeConstruir(Jugador, Item):-
    jugador(Jugador, _, _),  item(Item, Componentes),
    member(itemCompuesto(Compuesto), Componentes),
    item(Compuesto, Simples),
    member(itemSimple(Simple, CantidadRequerida), Simples),     
    cantidadDeItem(Jugador, Simple, CantidadJugador),
    CantidadJugador >= CantidadRequerida.
*/
/*
- Puede requerir una cierta cantidad de un ítem simple, que es aquel que el jugador tiene o puede recolectar. 
Por ejemplo, 8 unidades de piedra.
- Puede requerir un ítem compuesto, que se debe construir a partir de otros (una única unidad).
Con la siguiente información, se pide relacionar un jugador con un ítem que puede construir. puedeConstruir/2

Aclaración: Considerar a los componentes de los ítems compuestos y a los ítems simples como excluyentes,
 es decir no puede haber más de un ítem que requiera el mismo elemento.

?- puedeConstruir(stuart, horno).
true.
?- puedeConstruir(steve, antorcha).
true.
*/

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).





    

%Punto 4.a  - Emi

%Punto 4.b  - Emi



































































