
% Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).
tripulante(nami, sombreroDePaja).
tripulante(ussop, sombreroDePaja).
tripulante(sanji, sombreroDePaja).
tripulante(chopper, sombreroDePaja).

tripulante(law, heart).
tripulante(bepo, heart).

tripulante(arlong, piratasDeArlong).
tripulante(hatchan, piratasDeArlong).

% Relaciona Pirata, Evento y Monto
impactoEnRecompensa(luffy, arlongPark, 30000000).
impactoEnRecompensa(luffy, baroqueWorks, 70000000).
impactoEnRecompensa(luffy, eniesLobby, 200000000).
impactoEnRecompensa(luffy, marineford, 100000000).
impactoEnRecompensa(luffy, dressrosa, 100000000).

impactoEnRecompensa(zoro, baroqueWorks, 60000000).
impactoEnRecompensa(zoro, eniesLobby, 60000000).
impactoEnRecompensa(zoro, dressrosa, 200000000).

impactoEnRecompensa(nami, eniesLobby, 16000000).
impactoEnRecompensa(nami, dressrosa, 50000000).

impactoEnRecompensa(ussop, eniesLobby, 30000000).
impactoEnRecompensa(ussop, dressrosa, 170000000).

impactoEnRecompensa(sanji, eniesLobby, 77000000).
impactoEnRecompensa(sanji, dressrosa, 100000000).

impactoEnRecompensa(chopper, eniesLobby, 50).
impactoEnRecompensa(chopper, dressrosa, 100).

impactoEnRecompensa(law, sabaody, 200000000).
impactoEnRecompensa(law, descorazonamientoMasivo, 240000000).
impactoEnRecompensa(law, dressrosa, 60000000).

impactoEnRecompensa(bepo,sabaody,500).

impactoEnRecompensa(arlong, llegadaAEastBlue, 20000000).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).


% -- Punto 1 --
participaronDelMismoEvento(Tripulacion1, Tripulacion2, Evento):-
    participoTripulacion(Tripulacion1, Evento),
    participoTripulacion(Tripulacion2, Evento),
    Tripulacion1 \= Tripulacion2.

participoTripulacion(Tripulacion, Evento):-
    tripulante(Tripulante, Tripulacion),
    impactoEnRecompensa(Tripulante, Evento, _).

% -- Punto 2 --
masDestacado(Pirata, Evento):-
    impactoEnRecompensa(Pirata, Evento, Recompensa),
    not((impactoEnRecompensa(OtroPirata, Evento, OtraRecompensa), OtraRecompensa > Recompensa, Pirata \= OtroPirata)).

% -- Punto 3 --
pasoDesapercibido(Pirata, Evento):-
    tripulante(Pirata, Tripulacion),
    participoTripulacion(Tripulacion, Evento),
    not(impactoEnRecompensa(Pirata, Evento, _)).

esTripulante(Tripulante):-
    tripulante(Tripulante, _).

% -- Punto 4 --
recompensaTotalTripulacion(Tripulacion, RecompensaTotal):-
    tripulante(_, Tripulacion),
    findall(Recompensa, recompensaTotalPorPirata(Tripulacion, Recompensa), ListaDeRecompensas),
    sum_list(ListaDeRecompensas, RecompensaTotal).

recompensaTotalPorPirata(Tripulacion, RecompensaTotal):-
    tripulante(Pirata, Tripulacion),
    findall(Recompensa, impactoEnRecompensa(Pirata, _, Recompensa), ListaDeRecompensas),
    sum_list(ListaDeRecompensas, RecompensaTotal).

% -- Punto 5 --
esTemible(Tripulacion):-
    tripulante(Tripulante, Tripulacion),
    forall(esTripulante(Tripulante), esPeligroso(Tripulante)).
esTemible(Tripulacion):-
    recompensaTotalTripulacion(Tripulacion, RecompensaTotal),
    RecompensaTotal > 500000000.

esPeligroso(Pirata):-
    recompensaActual(Pirata, RecompensaActual),
    RecompensaActual > 100000000.

recompensaActual(Pirata, RecompensaActual):-
    esTripulante(Pirata),
    impactoEnRecompensa(Pirata, _, RecompensaActual),
    not((impactoEnRecompensa(Pirata, _, OtraRecompensa), OtraRecompensa > RecompensaActual)).

comioFruta(luffy, gomugomu, paramecia).
comioFruta(buggy, barabara, paramecia).
comioFruta(law, opeope, paramecia).    
comioFruta(chopper, hitohito, zoan(humano)). 
comioFruta(lucci, nekoneko, zoan(leopardo)). 
comioFruta(smoker, mokumoku, logia).

esFeroz(leopardo).
esFeroz(lobo).
esFeroz(anaconda).

frutaPeligrosa(Fruta):-
    comioFruta(_, Fruta, logia).
frutaPeligrosa(opeope).
frutaPeligrosa(Fruta):-
    comioFruta(_, Fruta, zoan(Animal)),
    esFeroz(Animal).

% -- Punto 6)a) --

esPeligroso(Pirata):-
    comioFruta(Pirata, Fruta, _),
    frutaPeligrosa(Fruta).

% -- Punto 7 --

esDePiratasDeAsfalto(Tripulacion):-
    tripulante(_, Tripulacion),
    forall(esTripulante(Tripulante), not(puedeNadar(Tripulante))).

puedeNadar(Tripulante):-
    esTripulante(Tripulante),
    not(comioFruta(Tripulante, _, _)).