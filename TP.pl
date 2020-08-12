/* --- Punto 9 ---
 Decidi modelar la informacion de los tripulantes con predicados formados por el nombre, 
 el pais y el puesto que ocupaban en el barco ya que me parecio que ese era un factor
 en comun que tenian todos los tripulantes. Tambien decidi modelar las tareas con 
 listas para facilitar la posterior solucion del punto 3. */      

tripulante(robert, inglaterra, capitan).
tripulante(martin, inglaterra, asistenteDe(capitan)).
tripulante(lewis, francia, maestre).
tripulante(robin, canada, maestre).
tripulante(richard, inglaterra, asistenteDe(maestre)).
tripulante(john, inglaterra, asistenteDe(maestre)).
tripulante(oliver, inglaterra, marinero).
tripulante(george, inglaterra, marinero).
tripulante(charles, inglaterra, marinero).
tripulante(beng, china, pasajero).
tripulante(lim, china, pasajero).
tripulante(thomas, inglaterra, cocinero).

tarea(oliver, [vigilancia, timonear]).
tarea(george, [timonear, izarLasVelas, vigilancia]).
tarea(charles, [limpieza, izarLasVelas]).

matoA(george, richard).
matoA(george, martin).
matoA(george, oliver).
matoA(lewis, beng).
matoA(charles, lewis).
matoA(lewis, robin).
matoA(john, george).
matoA(richard, charles).
matoA(richard, lim).

% --- Punto 1 ---

pais(Pais):-
    tripulante(_, Pais, _).

tripulantesAsesinadosPorPais(Pais, CantTripulantesAsesinados):-
    pais(Pais),
    findall(Tripulante, (matoA(_, Tripulante), tripulante(Tripulante, Pais, _)), ListaAsesinados),
    length(ListaAsesinados, CantTripulantesAsesinados).

/*Pruebas: 

Pais(P).
P = inglaterra ;
P = francia ;
P = canada ;
P = china.

tripulantesAsesinadosPorPais(Pais, CantTripulantesAsesinados).
Pais = inglaterra,
CantTripulantesAsesinados = 5 ;
Pais = francia,
CantTripulantesAsesinados = 1 ;
Pais = canada,
CantTripulantesAsesinados = 1 ;
Pais = china,
CantTripulantesAsesinados = 2 ;
*/ 

% --- Punto 2 ---

tuvoUnFinalSangriento(Pais):-
    pais(Pais),
    forall(tripulante(Tripulante, Pais, _), matoA(_, Tripulante)).

paisesConFinSangriento(ListaPaisesConFinalSangriento):-
    findall(Pais, tuvoUnFinalSangriento(Pais), ListaPaisesConFinalSangriento).    

/*Pruebas: 

tuvoUnFinalSangriento(Pais).

Pais = francia ;
Pais = canada ;
Pais = china.

paisesConFinSangriento(ListaPaisesConFinalSangriento).

ListaPaisesConFinalSangriento = [francia, canada, china, china].
*/ 

% --- Punto 3 ---
/*
Si dos tripulantes son cercanos, lo cual depende exclusivamente de sus roles, por las interacciones que se daban en el barco. 
Sabemos que los asistentes interactúan con los que deben asistir, también se dan interacciones al desempeñar un mismo rol, y los cocineros interactúan con todos. 
En el caso de los marineros, interactúan si realizan al menos una tarea en común.
*/
sonCercanos(Tripulante, OtroTripulante):-
    tripulante(Tripulante,_, Rol),
    tripulante(OtroTripulante, _, OtroRol),
    Tripulante \= OtroTripulante,
    rolesCercanos(Rol, OtroRol).

sonCercanos(Tripulante, OtroTripulante):-
    tarea(Tripulante, Tarea),
    tarea(OtroTripulante, OtraTarea),
    tienenElementoComun(Tarea, OtraTarea),
    OtroTripulante \= Tripulante.

tienenElementoComun(Lista, OtraLista):-
    member(Elemento, Lista), 
    member(Elemento, OtraLista).

rolesCercanos(asistenteDe(Rol), Rol).
rolesCercanos(Rol, asistenteDe(Rol)).
rolesCercanos(Rol, Rol):-
    Rol \= marinero.
rolesCercanos(cocinero, _).
rolesCercanos(_, cocinero).

/*Pruebas: 

sonCercanos(Tripulante, OtroTripulante).    (Algunas pruebas, no todas por que son muchas...)

Tripulante = robert,
OtroTripulante = martin ;
Tripulante = robert,
OtroTripulante = thomas ;
Tripulante = martin,
OtroTripulante = robert .

*/

% --- Punto 4 ---

esTraidor(Persona):-
    matoA(Persona, OtraPersona),
    sonCercanos(Persona, OtraPersona).

esTripulante(Tripulante):-
    tripulante(Tripulante, _, _).

esInocente(Tripulante):-
    esTripulante(Tripulante),
    esTraidor(OtroTripulante),
    not(matoA(Tripulante, OtroTripulante)).

/*Pruebas:

esInocente(Tripulante).

Tripulante = robert ;
Tripulante = martin ;
Tripulante = lewis ;
Tripulante = robin ;
Tripulante = richard ;
Tripulante = john ;
Tripulante = oliver ;
Tripulante = george ;
Tripulante = charles ;
Tripulante = beng ;
Tripulante = lim ;
Tripulante = thomas .

*/

% --- Punto 5 ---

venganza(Vengador, Blanco, Vengado):-
    matoA(Blanco, Vengado),
    matoA(Vengador, Blanco),
    sonCercanos(Vengado, Vengador).

/*Pruebas:

venganza(Vengador, Blanco, Vengado).

Vengador = john,
Blanco = george,
Vengado = richard ;
Vengador = richard,
Blanco = charles,
Vengado = lewis ;
Vengador = george,
Blanco = richard,
Vengado = charles .

*/

% --- Punto 6 ---

fueHonorable(inglaterra).
fueHonorable(Pais):-
    pais(Pais),
    forall(tripulante(Persona, Pais, _), not(esTraidor(Persona))).

/*Pruebas:

fueHonorable(Pais).

Pais = inglaterra ;
Pais = canada ;
Pais = china .

*/

% --- Punto 7 ---

esCapitan(Tripulante):-
    tripulante(Tripulante, _, capitan).

estaAlMando(Tripulante):-
    esCapitan(Tripulante).
estaAlMando(Tripulante):-
    esAsistente(Tripulante).

formoParteDelMotin(Tripulante):-
    estaAlMando(AlMando),
    matoA(Tripulante, AlMando).
formoParteDelMotin(Tripulante):-
    estaAlMando(AlMando),
    sonCercanos(Tripulante, Asesino),
    matoA(Asesino, AlMando).

/*Pruebas:

formoParteDelMotin(Tripulante).

Tripulante = george ;
Tripulante = oliver ;
Tripulante = charles .

*/

% --- Punto 8 ---

causalDeVenganza(Vengador, Causal):-
    venganza(Vengador, Blanco, _),
    causalDeVenganza(Blanco, Causal).

causalDeVenganza(Vengador, Causal):-
    venganza(Vengador, Causal, Vengado),
    matoA(Causal, Vengado).
/*

Richard se vengó de Charles por haber matado a Lewis.
George se vengó de Richard por haber matado a Charles.
John se vengó de George por haber matado a Richard.
Los causales de venganza de John serían George, Richard y Charles. Los causales de venganza de George serían Richard y Charles, y el de Richard sería únicamente Charles. Charles no tiene ningún causal de venganza porque no se vengó de nadie.




matoA(george, richard).
matoA(george, martin).
matoA(george, oliver).
matoA(lewis, beng).
matoA(charles, lewis).
matoA(lewis, robin).
matoA(john, george).
matoA(richard, charles).
matoA(richard, lim).
*/


/*Pruebas:

causalesDeVenganza(Vengador, ListaCausales).

Vengador = john,
ListaCausales = [george, richard, charles] ;
Vengador = richard,
ListaCausales = [charles] ;
Vengador = george,
ListaCausales = [richard, charles] .

*/