mensaje(['hola', ',', 'qué', 'onda', '?'], nico).
mensaje(['todo', 'bien', 'dsp', 'hablamos'], nico).
mensaje(['q', 'parcial', 'vamos', 'a', 'tomar', '?'], [nico, lucas, maiu]).
mensaje(['todo', 'bn', 'dsp', 'hablamos'], [nico, lucas, maiu]).
mensaje(['todo', 'bien', 'después', 'hablamos'], mama).
mensaje(['¿','y','q', 'onda', 'el','parcial', '?'], nico).
mensaje(['¿','y','qué', 'onda', 'el','parcial', '?'], lucas).


mensaje(['hola', '?', 'hola', '?', 'hola', '?', 'hola', '?','hola', '?', 'hola', '?', 'hola', '?', 'hola', '?', 'hola', '?','hola', '?','hola', '?','hola', '?'], nico).
mensaje(['todo', 'bien', 'hablamos', 'todo', 'bien', 'hablamos', 'todo', 'bien', 'hablamos', 'todo', 'bien', 'hablamos', 'todo', 'bien', 'hablamos', 'todo', 'bien', 'hablamos'], nico).

/*
PUNTO 1

recibioMensaje/2: 
relaciona una persona con un mensaje si recibió dicho mensaje del usuario ya sea de forma individual o grupal.
Deberían ser posibles respuestas nico, lucas, maiu y mama, y no [nico, lucas, maiu].
*/
% persona(Persona):-
%    mensaje(_, Grupohalt),
%    member(Persona, Grupo).

%% aca falla..
% persona(Persona):-
%    mensaje(_, Persona).

% persona([Persona|RestoPersonas]):-
%     mensaje(_, Persona),
%     persona(RestoPersonas).

/*
recibioMensaje(Persona, Mensaje):-
   mensaje(Mensaje, Persona).

recibioMensaje(Persona, Mensaje):-
    mensaje(Mensaje, GrupoDePersonas),
    member(Persona, GrupoDePersonas).
*/


% abreviatura(Abreviatura, PalabraCompleta) relaciona una abreviatura con su significado.
abreviatura('dsp', 'después').
abreviatura('q', 'que').
abreviatura('q', 'qué').
abreviatura('bn', 'bien').

% signo(UnaPalabra) indica si una palabra es un signo.
signo('¿').
signo('?').
signo('.').
signo(','). 

/*
PUNTO 3
*/

demasiadoFormal(Mensaje):-
    mensaje(Mensaje, _),
    tieneMuchasPalabras(Mensaje),
    tieneSignos(Mensaje),
    comienzaConSignoInterrogacion(Mensaje),
    not(tieneAbreviaturas(Mensaje)).

comienzaConSignoInterrogacion(Mensaje):-
    mensaje(Mensaje, _), nth1(1, Mensaje, '¿').

tieneMuchasPalabras(Mensaje):-
    mensaje(Mensaje, _),
    length(Mensaje, CantidadDePalabras),   
    CantidadDePalabras > 20.

tieneSignos(Mensaje):-
    mensaje(Mensaje, _),
    member(Signo, Mensaje), signo(Signo).

tieneAbreviaturas(Mensaje):-
    mensaje(Mensaje, _),
    member(Abreviatura, Mensaje), abreviatura(Abreviatura, _).


/******************************************************************************************************************************/
% filtro(Contacto, Filtro) define un criterio a aplicar para las predicciones para un contacto
filtro(nico, masDe(0.5)).
filtro(nico, ignorar(['interestelar'])).
filtro(lucas, masDe(0.7)).
filtro(lucas, soloFormal).
filtro(mama, ignorar(['dsp','paja'])).

/*
PUNTO 3

esAceptable/2: 
saber si una palabra dada es aceptable para una persona. 
O sea, si pasa todos los filtros configurados para dicho usuario:
Actualmente existen 3 tipos de filtros, con posibilidad de agregarse más en un futuro cercano:
    -ignorar(ListaDePalabras): Las palabras de la lista no son aceptadas.
    -soloFormal: Solamente es aceptable si la palabra se encuentra en algún mensaje demasiado  formal.
    No se espera que sea inversible.
*/

% esAceptable(Palabra, Persona):-
%    palabra(Palabra), persona(Persona),
%    forall(
%        filtro(Persona, Filtro), aceptada(Palabra, Filtro)
%    ).
/*
    -masDe(N): La palabra es aceptada si su tasa de uso con esa persona es mayor a N.
        La tasa de uso de una palabra se calcula como 
            1. la cantidad de apariciones de esa palabra en mensajes enviados  a esa persona 
            2. dividido por la cantidad de apariciones de esa palabra en mensajes enviados a  cualquier persona o grupo.

filtro(nico, masDe(0.5)).
filtro(lucas, masDe(0.7)).
filtro(nico, ignorar(['interestelar'])).
*/

% masDe(Cantidad):-
%    seRepite(Palabra, CantidadRepeticiones),

