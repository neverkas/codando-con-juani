% jugador(Nombre, PuntosVida, PuntosMana,  CartasMazo, CartasMano, CartasCampo)
jugador(carlos, 500, 500, [fuego, curacion, zombies],  [fuego], [fuego, zombies]).
% jugador(jugador(fede, 300, 300, 50, 2, 3)).
% jugador(jugador(pepe, 10, 100, 50, 1, 0)).

% criatura(Nombre, PuntosDaño, PuntosVida, CostoMana)
carta(criatura(godzilla, 500, 500, 300)).
carta(criatura(dracula, 300, 800, 300)).
carta(criatura(momia, 10, 200, 100)).

% hechizo(Nombre, FunctorEfecto, CostoMana)
carta(hechizo(fuego, 10, danio(500), 100)).
carta(hechizo(mordedura, 10, danio(200), 100)).
carta(hechizo(zombies, 10, danio(100), 100)).

carta(hechizo(curacion, 10, curar(300), 300)).
carta(hechizo(meditacion, 10, curar(100), 100)).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

/**************************************************************************************************************/

nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

/*
1. Relacionar un jugador con una carta que tiene. La carta podría estar en su mano, en el campo o en el mazo.
*/

tieneCarta(QueJugador, Carta):-    
    jugador(jugador(QueJugador, _, _, _, CartasMano, _)),    
    member(Carta, CartasMano).

    nombre(Jugador, QueJugador).

    %jugador(jugador(QueJugador, _, _, Cartas, Cartas, Cartas)),    
    %cartasDe(QueJugador, Cartas),
    %member(Carta, Cartas).
    
cartasTotales(Jugador, Cartas):-   
    findall(
        Carta,
        member(Carta, cartasDe(Jugador, Cartas)),
        Cartas
    ).

cartasDe(Jugador, Cartas):- cartasMazo(Jugador, Cartas).
cartasDe(Jugador, Cartas):- cartasMano(Jugador, Cartas).
cartasDe(Jugador, Cartas):- cartasCampo(Jugador, Cartas).

/*******************************************************************************************/ 

/*
2. Saber si un jugador es un guerrero. Es guerrero cuando todas las cartas que tiene, 
ya sea en el mazo, la mano o el campo, son criaturas.
*/

