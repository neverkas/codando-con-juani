/*
Sabemos cuáles son las herramientas requeridas para realizar una tarea de limpieza. 
Además, para las aspiradoras se indica cuál es la potencia mínima requerida para la tarea en cuestión.
*/
herramientasRequeridas(ordenarCuarto, [aspiradora(100), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradpesora, cera, aspiradora(300)]).

%% Punto 1
tiene(egon, aspiradora(200)).
tiene(egon, trapeador).
tiene(peter, trapeador).
tiene(winston, varitaNeutrones).

persona(Persona):- tiene(Persona, _).
tarea(Tarea):- herramientasRequeridas(Tarea, _).

/*
2. Definir un predicado que determine si un integrante "satisface la necesidad de una herramienta requerida".
Esto será cierto 
- si tiene dicha herramienta,
- teniendo en cuenta que si la herramienta requerida es una aspiradora,
    - el integrante debe tener una con potencia igual o superior a la requerida.
Nota: No se pretende que sea inversible respecto a la herramienta requerida.
*/
% potenciaDe(aspiradora(Potencia), Potencia).

satisface(Persona, Herramienta):-
    tiene(Persona, Herramienta).

satisface(Persona, aspiradora(PotenciaRequerida)):-
    tiene(Persona, aspiradora(Potencia)),
    Potencia >= PotenciaRequerida.

/*
Queremos saber si una persona puede realizar una tarea, que dependerá de las
herramientas que tenga. Sabemos que:
- Quien tenga una varita de neutrones puede hacer cualquier tarea, independientemente de qué herramientas requiera dicha tarea.
- Alternativamente alguien puede hacer una tarea si puede satisfacer la necesidad de 
todas las herramientas requeridas para dicha tarea.
*/

puedeRealizar(Persona, Tarea):-
    tiene(Persona, Herramienta),
    tareaSegun(Herramienta, Tarea).

puedeRealizar(Persona, Tarea):-
    persona(Persona),
    herramientasRequeridas(Tarea, Herramientas),
    forall(
        member(Herramienta, Herramientas),
        satisface(Persona, Herramienta)
    ).

tareaSegun(varitaNeutrones, Tarea):-
    tarea(Tarea).

/*
4. Nos interesa saber de antemano "cuanto se le debería cobrar a un cliente por un pedido" (que son las tareas que pide).
Para ellos disponemos de la siguiente información en la base de conocimientos:
- tareaPedida/3: relaciona al cliente, con la tarea pedida y la cantidad de metros
cuadrados sobre los cuales hay que realizar esa tarea.
- precio/2: relaciona una tarea con el precio por metro cuadrado que se cobraría al
cliente.

Entonces lo que se le cobraría al cliente sería la suma del valor a cobrar por cada tarea,
multiplicando el precio por los metros cuadrados de la tarea.
*/
cobrar(Cliente, CuantoCobrar):-
    cliente(Cliente),
    findall(
        Precio,
        precioPorTarea(Cliente, Precio),
        %(tareaPedida(Cliente, Tarea, Metros), precioPorMetro(Tarea, Metros, Precio)),
        Precios
    ), sumlist(Precios, CuantoCobrar).

precioPorTarea(Cliente, Precio):-
    tareaPedida(Cliente, Tarea, Metros), 
    precioPorMetro(Tarea, Metros, Precio).

precioPorMetro(Tarea, Metros, PrecioTotal):-
    precio(Tarea, Precio),
    PrecioTotal is Precio*Metros.

% precio(Tarea, Precio)
precio(ordenarCuarto, 100).
precio(limpiarTecho, 200).
precio(cortarPasto, 200).
precio(limpiarBanio, 900).
precio(encerarPisos, 300).

% tareaPedida(Cliente, Tarea, Metros)
tareaPedida(pedro, ordenarCuarto, 100).
tareaPedida(pedro, limpiarBanio, 100).
tareaPedida(pedro, encerarPisos, 300).
tareaPedida(fede, limpiarTecho, 500).
tareaPedida(fede, cortarPasto, 900).
tareaPedida(pepe, cortarPasto, 100).

cliente(Cliente):- tareaPedida(Cliente, _, _).

/*
Finalmente necesitamos saber "quiénes aceptarían el pedido de un cliente".
- Un integrante acepta el pedido cuando 
    - puede realizar todas las tareas del pedido 
    - y además está dispuesto a aceptarlo.
- Sabemos que Ray sólo acepta pedidos que no incluyan limpiar techos,
- Winston sólo acepta pedidos que paguen más de $500,
- Egon está dispuesto a aceptar pedidos que no tengan tareas complejas
- y Peter está dispuesto a aceptar cualquier pedido.

Decimos que una tarea es compleja si requiere más de dos herramientas.
Además la limpieza de techos siempre es compleja.
*/

aceptariaPedido(Integrante, Cliente):-
    puedeRealizarTareasDe(Integrante, Cliente),
    acepta(Integrante, Pedido).

% tareaPedida(fede, limpiarTecho, 500).
% tarea(Tarea):- 

acepta(ray, Pedido):-
    tareasDe(Pedido, Tareas),
    not(member(limpiarTecho, Tareas)).

acepta(winston, Pedido):-
    tareasDe(Pedido, Tareas),
    
