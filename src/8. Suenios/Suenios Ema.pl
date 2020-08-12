/*
PUNTO 1
*/
cree(gabriel, campanita).
cree(gabriel, magoDeOz).
cree(gabriel, cavenaghi).
cree(juan, conejoDePascua).
cree(macarena, reyesMagos).
cree(macarena, magoCapria).
cree(macarena, campanita).
%% diego no cree en nadie, por tanto no figura en el universo cerrado

% suenia(gabriel, ganarLoteria(apostarAl(9), apostarAl(5))).
suenia(gabriel, ganarLoteriaApostandoAl([9,5])).
suenia(gabriel, futbolista(arsenal)).
suenia(juan, cantante(100000) ).
suenia(macarena, cantanteEstilo(erucaSativa)).
suenia(macarena, cantante(10000)).

% extra
persona(Persona):- cree(Persona, _).
personaje(Personaje):- cree(_, Personaje).

equipoChico(arsenal).
equipoChico(aldosivi).

equipo(Equipo):- equipoChico(Equipo).

suenio(Suenio):-
    suenia(_, Suenio).

/*
PUNTO 2
*/

ambiciosa(Persona):-
    dificultadTotalDeLosSuenios(Persona, DificultadTotal),
    DificultadTotal > 20.

dificultadTotalDeLosSuenios(Persona, DificultadTotal):-
    suenia(Persona, _),
    findall(
        Dificultad,
        dificultadDeLosSuenios(Persona, Dificultad),
        Dificultades
    ), sumlist(Dificultades, DificultadTotal).

dificultadDeLosSuenios(Persona, 3):-
    sueniaEquipoChico(Persona).

dificultadDeLosSuenios(Persona, 16):-
    % suenia(Persona, _),
    suenia(Persona, futbolista(_)),
    not(sueniaEquipoChico(Persona)).

dificultadDeLosSuenios(Persona, Dificultad):-
    suenia(Persona, ganarLoteriaApostandoAl(Numeros)),
    length(Numeros, CantidadNumeros),
    Dificultad is CantidadNumeros*10.

dificultadDeLosSuenios(Persona, 6):- 
    vendeMuchosDiscos(Persona).

dificultadDeLosSuenios(Persona, 4):- 
    %suenia(Persona, _),
    suenia(Persona, cantante(_)),
    not(vendeMuchosDiscos(Persona)).

vendeMuchosDiscos(Persona):-
    suenia(Persona, cantante(DiscosVendidos)),
    DiscosVendidos > 500000.


sueniaEquipoChico(Persona):-
    suenia(Persona, futbolista(Equipo)),
    equipoChico(Equipo).

/*
PUNTO 3
*/
% tieneQuimica(campanita, gabriel).
% dificultadTotalDeLosSuenios(gabriel, Dificultad).
% distinct(tieneQuimica(Personaje, macarena)).
%    
% tieneSueniosPuros(macarena).
% ambiciosa(macarena).

tieneQuimica(campanita, Persona):-
    cree(Persona, campanita),
    dificultadDeLosSuenios(Persona, Dificultad),
    Dificultad < 5.

tieneQuimica(Personaje, Persona):-
    personaje(Personaje), persona(Persona),
    tieneSueniosPuros(Persona),
    not(ambiciosa(Persona)).

tieneSueniosPuros(Persona):-
    persona(Persona), suenio(Suenio),
    not((suenia(Persona, Suenio), not(suenioPuro(Suenio)))).

suenioPuro(futbolista(_)).
%% suenioPuro(futbolista(Equipo)):- equipo(Equipo).

% suenioPuro(cantante(200)).
suenioPuro(Suenio):-
    % suenio(Suenio),
    discosVendidos(Suenio, CantidadDiscos),
    CantidadDiscos < 200000.

discosVendidos(cantante(DiscosVendidos), DiscosVendidos).
%% suenioPuro(cantante(DiscosVendidos)):- DiscosVendidos < 200000.

/*
PUNTO 4
*/

amigo(campanita, reyesMagos).
amigo(campanita, conejoDePascua).
amigo(conejoDePascua, cavenaghi).

amistad(Personaje, Amigo):-
    amigo(Personaje, Amigo).

amistad(Personaje, Amigo):-
    amigo(Personaje, OtroAmigo),
    amistad(OtroAmigo, Amigo).

puedeAlegrar(Personaje, Persona):-
    personaje(Personaje),
    suenia(Persona, _).

puedeAlegrar(Personaje, Persona):-
    tieneQuimica(Personaje, Persona),
    not(estaEnfermoEloAlgunConocido(Personaje)).

estaEnfermoEloAlgunConocido(Personaje):-
    personaje(Personaje),
    estaEnfermo(Personaje).

estaEnfermoEloAlgunConocido(Personaje):-
    amistad(Personaje, Amigo),
    estaEnfermo(Amigo).

/*
puedeAlegrar(Personaje, Persona):-
    tieneQuimica(Personaje, Persona),
    not(estaEnfermo(Personaje)).

puedeAlegrar(Personaje, Persona):-
    tieneQuimica(Personaje, Persona),
    personajeDeBackup(Personaje, Principal),
    not(estaEnfermo(Personaje)).
*/

estaEnfermo(campanita).
estaEnfermo(reyesMagos).
estaEnfermo(conejoDePascua).
estaEnfermo(pepito).