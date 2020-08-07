/*
Declará en este archivo tus predicados y dejá comentarios multilínea
con los ejemplos de uso luego de cada punto y justificaciones que correspondan.
*/

%tripulante(Nombre, Rol, Pais).
tripulante(robert, capitan, inglaterra).
tripulante(martin, asistenteCapitan, inglaterra).
tripulante(lewis, maestre, francia).
tripulante(robin, maestre, canada).
tripulante(richard, asistenteMaestre, inglaterra).
tripulante(john, asistenteMaestre, inglaterra).
tripulante(oliver, marinero([vigilar, timonear]), inglaterra).
tripulante(george, marinero([izarVelas, vigilar]), inglaterra).
tripulante(charles, marinero([limpiar, izarVelas]), inglaterra).
tripulante(beng, pasajero, chino).
tripulante(lim, pasajero, chino).
tripulante(thomas, cocinero, inglaterra).

%asesinato(Asesino, Victima).
asesinato(george, richard).
asesinato(george, martin).
asesinato(george, oliver).
asesinato(lewis, beng).
asesinato(charles, lewis).
asesinato(lewis, robin).
asesinato(john, george).
asesinato(richard, charles).
asesinato(richard, lim).


/*
1. Cuántos tripulantes asesinados hubieron en la catástrofe de cada país.

Justificación:
*/

asesinatosPais(Pais, Cantidad):-
    tripulante(_, _, Pais),
    findall(Victima, (asesinato(_, Victima), tripulante(Victima, _, Pais)), Victimas),
    length(Victimas, Cantidad).

/*
2. Qué países tuvieron un fin sangriento, que son aquellos para los cuales todos los tripulantes de ese país fueron asesinados.

Justificación:
*/

paisSangriento(Pais):-
    tripulante(_, _, Pais),
    forall(tripulante(Victima, _, Pais), asesinato(_, Victima)).


/*
3. Si dos tripulantes son cercanos, lo cual depende exclusivamente de sus roles, por las interacciones que se daban en el barco. 
Sabemos que los asistentes interactúan con los que deben asistir, también se dan interacciones al desempeñar un mismo rol, y los cocineros interactúan con todos. 
En el caso de los marineros, interactúan si realizan al menos una tarea en común.

Justificación:
*/

sonCercanos(Tripulante, OtroTripulante):-
        tripulante(Tripulante,Rol,_),
        tripulante(OtroTripulante,OtroRol,_),
        Tripulante \= OtroTripulante,
        interactuan(Rol, OtroRol).

interactuan(capitan, asistenteCapitan).
interactuan(asistenteCapitan, capitan).
interactuan(maestre, asistenteMaestre).
interactuan(asistenteMaestre, maestre).
interactuan(Rol, Rol):-
    Rol \= marinero(_).
interactuan(cocinero, _).
interactuan(_, cocinero).
interactuan(marinero(Lista1),marinero(Lista2)):-
    member(Tarea, Lista1),
    member(Tarea, Lista2).


/*
4. Qué tripulantes son inocentes; esto significa que no mataron a nadie que no fuese un traidor. Un traidor es alguien que mató a un tripulante cercano a sí mismo.

Justificación:
*/

esInocente(Tripulante):-
    tripulante(Tripulante,_,_),
    forall(asesinato(Tripulante, Traidor), esTraidor(Traidor)).

esTraidor(Traidor):-
    tripulante(Traidor,_,_),
    asesinato(Traidor, Cercano),
    sonCercanos(Traidor, Cercano).
/*
5. Para desentramar el misterio, tenemos que considerar las muertes que fueron por venganza. 
En una venganza intervienen 3 tripulantes: un vengador, un vengado y el blanco de la venganza (o sea, a quién mató el vengador). 
Para que se considere venganza, el blanco de la venganza debe haber matado al vengado y el vengador al blanco de la venganza. Además el vengado y el vengador deben ser cercanos.

Justificación:
*/

muerteVenganza(Vengador, Vengado, Asesinado):-
    asesinato(Asesinado, Vengado),
    asesinato(Vengador, Asesinado),
    sonCercanos(Vengador, Vengado).

/*
6. Nuestro informe va a llegar a las autoridades de los países involucrados, por lo que nos pidieron que reportemos si un país fue honorable,
que se cumple si no hubo ningún traidor de ese país. Inglaterra aparezca como un país honorable

Justificación:
*/

paisHonorable(inglaterra).
paisHonorable(Pais):-
    tripulante(_,_,Pais),
    forall(tripulante(Tripulante,_,Pais), not(esTraidor(Tripulante))).

/*
7. Motín! Motín! El último acto que supimos del barco fue un motín. 
Nos gustaría saber si un tripulante formó parte del motín: esto se cumple cuando el tripulante mató o es cercano a alguien que haya matado a alguien que esté al mando. 
Un tripulante está al mando si desempeña el rol de capitán o de asistente de capitán.

Justificación:
*/

parteMotin(Tripulante):-
    tripulante(Tripulante,_,_),
    estaAlMando(Mando),
    mataronAlMando(Tripulante, Mando).

estaAlMando(Tripulante):-
    tripulante(Tripulante,capitan,_).
estaAlMando(Tripulante):-
    tripulante(Tripulante,asistenteCapitan,_).

mataronAlMando(Tripulante, Mando):-
    asesinato(Tripulante, Mando).
mataronAlMando(Tripulante, Mando):-
    sonCercanos(Tripulante, OtroTripulante),
    asesinato(OtroTripulante, Mando).

/*
8. Desarrollar un predicado transitivo que relacione a un vengador con cada uno de sus causales de venganza, 
es decir, con aquellos que directa o indirectamente lo convirtieron en un vengador. 
Dado un vengador, el causal de venganza directo es el blanco de su venganza, y si ese blanco a su vez era un vengador, los causales de venganza de su blanco son causales 
indirectos del vengador en cuestión. Por ejemplo, si ocurrió lo siguiente: 
Richard se vengó de Charles por haber matado a Lewis.
George se vengó de Richard por haber matado a Charles.
John se vengó de George por haber matado a Richard.

Justificación:
*/

causalVeganza(Vengador, Vengados):-
    muerteVenganza(Vengador, Vengado, Asesinado),
    findall(Tripulante, recu(Asesinado, Vengado, Tripulante), Vengados).



recu(Vengador, Asesinado, Tripulante):-
    muerteVenganza(Vengador, Tripulante, Asesinado),
    recu(Asesinado, Tripulante, OtroTripulante).
recu(Vengador, Asesinado, _):-
    asesinato(Vengador, Asesinado),
    muerteVenganza(_,Asesinado, Vengador).


/*
9. En caso de haber predicados auxiliares no inversibles, indicar para cada uno de ellos cuál es la causa de no inversibilidad y por qué se elige no hacerlo inversible.
Explicar las decisiones tomadas relativas al modelado de información.

Justificación:
*/