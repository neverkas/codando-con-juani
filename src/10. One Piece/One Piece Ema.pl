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

pirata(Pirata):-
    tripulante(Pirata, _).

tripulacion(Tripulacion):- 
    tripulante(_, Tripulacion).

% Relaciona Pirata, Evento y Monto
impactoEnRecompensa(luffy,  arlongPark, 30000000).
impactoEnRecompensa(luffy, baroqueWorks, 70000000).
impactoEnRecompensa(luffy, eniesLobby, 200000000).
impactoEnRecompensa(luffy,  marineford, 100000000).
impactoEnRecompensa(luffy,  dressrosa, 100000000).

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
impactoEnRecompensa(law, descorazonamientoMasivo,
     240000000).
impactoEnRecompensa(law, dressrosa, 60000000).

impactoEnRecompensa(bepo,sabaody,500).

impactoEnRecompensa(arlong, llegadaAEastBlue, 20000000).
impactoEnRecompensa(hatchan, llegadaAEastBlue, 3000).

/*
PUNTO 1

Relacionar a dos tripulaciones y un evento si ambas participaron del mismo, 
lo cual sucede si dicho evento impactó en la recompensa de al menos un pirata de cada tripulación. Por ejemplo:
- Debería cumplirse para las tripulaciones heart y sombreroDePaja 
    siendo dressrosa el evento del cual participaron ambas tripulaciones.
- No deberían haber dos tripulaciones que participen de llegadaAEastBlue, 
    sólo los piratasDeArlong participaron de ese evento.
% tripulante(Pirata, Tripulacion)
tripulante(luffy, sombreroDePaja).

% impactoEnRecompensa(Pirata, Evento,      Monto)
impactoEnRecompensa(luffy,  arlongPark, 30000000).

% ?- participaronDe(llegadaAEastBlue, heart, sombreroDePaja).

*/
% ?- participaronDe(Evento, heart, sombreroDePaja).
participaronDe(Evento, TripulacionA, TripulacionB):-
    participoDe(TripulacionA, Evento),
    participoDe(TripulacionB, Evento),
    % OBS: porque una tripulación puede tener varios piratas 
    TripulacionA \= TripulacionB. %Me falto colocar que son distintos

/*
% ?- participaronDe(llegadaAEastBlue, X, Y). ???????????????????
participaronDe(llegadaAEastBlue, piratasDeArlong, _).
participaronDe(llegadaAEastBlue, _, piratasDeArlong).
*/
% ?- participoDe(heart, Evento).
% ?- participoDe(sombreroDePaja, Evento).
participoDe(Tripulacion, Evento):-
    tripulante(Pirata, Tripulacion),
    impactoEnRecompensa(Pirata,  Evento, _).
/*
*/

/*
PUNTO 2

Saber quién fue el pirata que más se destacó en un evento, en base al impacto que haya tenido su recompensa.

% tripulante(Pirata, Tripulacion).
tripulante(chopper, sombreroDePaja).

% impactoEnRecompensa(Pirata, Evento,      Monto)
impactoEnRecompensa(luffy,  arlongPark, 30000000).
impactoEnRecompensa(luffy, baroqueWorks, 70000000).

En el caso del evento de dressrosa sería Zoro, porque su recompensa subió en $200.000.000.

*/


%

% ?- destacado(zoro, dressrosa).
destacado(PirataA, Evento):-
    impactoEnRecompensa(PirataA, Evento, MontoA),
    forall(
        (impactoEnRecompensa(PirataB, Evento, MontoB), PirataA \= PirataB),
        MontoA > MontoB
    ).

/*
PUNTO 3

Saber si un pirata pasó desapercibido en un evento, que se cumple 
- si su recompensa no se vio impactada por dicho evento a pesar de que su tripulación participó del mismo.
Por ejemplo esto sería cierto para Bepo para el evento dressrosa, pero no para el evento sabaody 
por el cual su recompensa aumentó, ni para eniesLobby porque su tripulación no participó.

% tripulante(Pirata, Tripulacion).
tripulante(chopper, sombreroDePaja).
% impactoEnRecompensa(Pirata, Evento,      Monto)

% participoDe(Tripulacion, Evento):-
*/

% ?- desapercibido(bepo, dressrosa).  TRUE
% ?- desapercibido(bepo, sabaody).    FALSE
% ?- desapercibido(bepo, eniesLobby). FALSE
desapercibido(Pirata, Evento):-
    suTripulacionParticipoDe(Pirata, Evento),
    not(suRecompensaFueAfectadaEn(Pirata, Evento)).

suTripulacionParticipoDe(Pirata, Evento):-
    tripulante(Pirata, Tripulacion),
    participoDe(Tripulacion, Evento).

suRecompensaFueAfectadaEn(Pirata, Evento):-
    impactoEnRecompensa(Pirata, Evento, _).

/*
PUNTO 4

Saber cuál es la recompensa total de una tripulación, que es la suma de las recompensas actuales de sus miembros.

% tripulante(Pirata, Tripulacion).
tripulante(chopper, sombreroDePaja).
% impactoEnRecompensa(Pirata, Evento,      Monto)

*/

% ?- recompensaTotalDe(Tripulacion, RecompensaTotal).
% ?- recompensaTotalDe(sombreroDePaja, RecompensaTotal).
% ?- recompensaTotalDe(heart, RecompensaTotal).
% 

%% OBSERVACION: Es recompensa actual, quizas deberias mejorar expresividad, y revisar predicados
recompensaTotalDe(Tripulacion, RecompensaTotal):-
    tripulacion(Tripulacion),
    findall(
        Recompensa,
        recompensasDeLosMiembrosDe(Tripulacion, Recompensa),
        Recompensas
    ), sumlist(Recompensas, RecompensaTotal).

recompensasDeLosMiembrosDe(Tripulacion, Recompensa):-
    tripulante(Pirata, Tripulacion),
    impactoEnRecompensa(Pirata, _, Recompensa).

/*
PUNTO 6

Saber si una tripulación es temible. Lo es si todos sus integrantes son peligrosos 
 o si la "recompensa total" de la tripulación supera los $500.000.000.
 
 Consideramos peligrosos a piratas cuya "recompensa actual" supere los $100.000.000.

% tripulante(Pirata, Tripulacion).
tripulante(chopper, sombreroDePaja).
% impactoEnRecompensa(Pirata, Evento,      Monto)

*/

temible(Tripulacion):-
    recompensaTotalDe(Tripulacion, RecompensaTotal),
    RecompensaTotal > 500000000.
temible(Tripulacion):-
    tieneIntegrantesPeligrosos(Tripulacion).

tieneIntegrantesPeligrosos(Tripulacion):-
    tripulacion(Tripulacion),
    %not((tripulante(Pirata, Tripulacion), not(peligroso(Pirata))))
    forall(
        tripulante(Pirata, Tripulacion),
        peligroso(Pirata)
    ).

% OBS: Comentado porque el punto 6 lo pide.. ----------------------------------------------------------------------------
% peligroso(Pirata):-
%    recompensaActual(Pirata, RecompensaActual),
%    RecompensaActual > 100000000.

% 
% ?- recompensaActual(bepo, RecompensaActual).
% ?- recompensaActual(chopper, RecompensaActual).
% recompensaActual(Pirata, RecompensaActual)
recompensaActual(Pirata, RecompensaActual):-
    pirata(Pirata),
    findall(
        Monto,
        impactoEnRecompensa(Pirata, _, Monto),
        Recompensa
    ), sumlist(Recompensa, RecompensaActual).
    
/*

- Las frutas del diablo se categorizan en tres tipos: 
    paramecia,
    zoan 
    y logia.
- Cada fruta a su vez tiene un nombre asociado, como se muestra en los datos que necesitamos 
representar más adelante, pero más allá de eso son muy distintas entre ellas. A continuación se detallan sus particularidades:

<Luffy comió la fruta gomugomu de tipo paramecia, que no se considera peligrosa.
<Buggy comió la fruta barabara de tipo paramecia, que no se considera peligrosa.
<Law comió la fruta opeope de tipo paramecia, que se considera peligrosa.
<Chopper comió una fruta hitohito de tipo zoan que lo convierte en humano.
<Nami, Zoro, Ussop, Sanji, Bepo, Arlong y Hatchan no comieron frutas del diablo.
Lucci comió una fruta nekoneko de tipo zoan que lo convierte en leopardo.
Smoker comió la fruta mokumoku de tipo logia que le permite transformarse en humo.

% Relaciona Pirata con Tripulacion
tripulante(luffy, sombreroDePaja).
tripulante(zoro, sombreroDePaja).


Las frutas del diablo se categorizan en tres tipos: paramecia, zoan y logia. 
*/

% OBS: Revisar si es necesario
% frutaDelDiablo(fruta(Nombre, Tipo)):-
%   comio(_, fruta(Nombre, Tipo)).

% OBS: Revisar si es necesario
% frutaDelDiablo(paramecia).
% frutaDelDiablo(zoan).
% frutaDelDiablo(logia).

% comio(Persona, fruta(Nombre, Tipo)).

% OBS: Revisar si es necesario agregar el tercer parametro en zoan, y logia -----------------------------------------
% comio(Persona, fruta(Nombre, Tipo, Efecto)). --- para la zoan y logia

comio(luffy, fruta(gomugomu, paramecia)).
comio(buggy, fruta(barabara, paramecia)).
comio(law, fruta(opeope, paramecia)).
comio(chopper, fruta(hitohito, zoan, humano)).
% Nami, Zoro, Ussop, Sanji, Bepo, Arlong y Hatchan no comieron frutas del diablo.
comio(lucci, fruta(nekoneko, zoan, leopardo)).
comio(smoker, fruta(mokumoku, logia, humo)).
% comio(lucci, fruta(nekoneko, zoan)).
% comio(smoker, fruta(mokumoku, logia)).

%% OBS: Pendiente en revisar si cambiar el predicado, o utilizar functores para modificar a la persona o no --------------

%  efectoEn(fruta(nekoneko, zoan), smoker).
%  efectoEn(Fruta, Persona, Transformacion):-
%    pirata(Persona),
%    efectoDe(Fruta, Transformacion).

% CORRECION: esto seria muy generico
% efectoDe(Fruta, Transformacion).
% efectoDe(fruta(nekoneko, zoan), leopardo).
% efectoDe(fruta(mokumoku, logia), humo).

/* 
Pueden haber varias frutas de este tipo con el mismo nombre, ya que se usa el mismo nombre para toda una familia
de especies, no para una especie concreta, con lo cual podría ser que una fruta zoan se considere peligrosa y 
otra no, a pesar de que se las llame de la misma forma.

*/

% OBS: Revisar repetición de lógica
%efecto(fruta(nekoneko, zoan), convertirEn(Persona, leopardo)):- pirata(Persona).
%efecto(fruta(mokumoku, logia), convertirEn(Persona, humo)):- pirata(Persona).

% peligrosa(opeope).
%% peligrosa(gomugomu). no es peligrosa, no deberia figurar

/*
% IMPOSIBLE de obtener los nombres de las frutas asi, carita enojada ._.
%comio(luffy, gomugomu(paramecia)).
%comio(buggy, barabara(paramecia)).
%comio(law, opeope(paramecia)).
%comio(law, opeope(paramecia)).
*/



/*

6. 
Necesitamos modificar la funcionalidad anterior, 
porque ahora hay otra forma en la cual una persona puede considerarse peligrosa: 
    - alguien que comió una fruta peligrosa se considera peligroso,
    independientemente de cuál sea el precio sobre su cabeza.

Justificar las decisiones de modelado tomadas para cumplir con lo pedido, 
tanto desde el punto de vista de la definición como del uso de los nuevos predicados.

% peligrosa(NombreFruta)
% comio(Persona, fruta(Nombre, Tipo)).
comio(luffy, fruta(gomugomu, paramecia)).
comio(buggy, fruta(barabara, paramecia)).
*/

peligroso(Persona):-
    comioFrutaPeligrosa(Persona).
    % No tiene nada que ver F %recompensaActual(Persona, _). %% porque no importa la recompensa 
peligroso(Persona):-
    %No hace falta %not(comioFrutaPeligrosa(Persona)), % entonces si evaluo la recompensa
    recompensaActual(Persona, RecompensaActual),
    RecompensaActual > 100000000.

% comio(Persona, fruta(Nombre, Tipo)).
%comioFrutaPeligrosa(Persona):- 
%    MAL, NO LO REPITAS PORFIS (?)
%    comio(Persona, fruta(NombreFruta, _)), %2 tipos de functores.
%    peligrosa(NombreFruta).

comioFrutaPeligrosa(Persona):-
    comio(Persona, Fruta),
    peligrosa(Fruta).

%% CORRECCIONES, DATOS FALTANTES 
peligrosa(fruta(opeope, paramecia)).
peligrosa(fruta(_, zoan, Animal)):-
    esFeroz(Animal).
peligrosa(fruta(_, logia, _).

esFeroz(lobo).
esFeroz(leopardo).
esFeroz(anaconda).

/*
A = luffy ;
A = zoro ;
A = ussop ;
A = sanji ;
A = law ;
A = law ;
A = lucci ;
A = smoker. */


/*
PUNTO 7

Saber si una tripulación es de piratas de asfalto, que se cumple si ninguno de sus miembros puede nadar.

" La desventaja que dan todas las frutas a quienes las consuman es que no podrán nadar nunca más, 
lo cual es bastante problemático si pasás tu vida luchando arriba de un barco.
"

pirata(Pirata):-
    tripulante(Pirata, _).

tripulacion(Tripulacion):- 
    tripulante(_, Tripulacion).

% comio(Persona, fruta(Nombre, Tipo)).
*/

piratasDelAsfalto(Tripulacion):-
    tripulacion(Tripulacion),
    %% otra manera
    %% not((tripulante(Pirata, Tripulacion), not(puedeNadar(Pirata)))).
    forall(
        tripulante(Pirata, Tripulacion),
        noPuedeNadar(Pirata)
        %not(puedeNadar(Pirata))
    ).
% puedeNadar(Persona):-     
% CARITA TRISTE (?)             
noPuedeNadar(Persona):- %No hacer predicados negativos de entrada.
 comio(Persona, _).