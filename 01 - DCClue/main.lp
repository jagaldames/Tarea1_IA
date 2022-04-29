% tiempo(T)
% persona(P)
% personaEnLugar(P,L,T)
% afirmacionLugar(P1,P2,L,T)
% descubrimiento(L,T)

% lugar(L)
% camino(L1,L2)

%culpable(P)
%sospechoso(P)


camino(L,L):-lugar(L). % Si un lugar existe, entonces hay un camino a si mismo
camino(L1,L2):- camino(L2,L1). % Los caminos son no direccionales


1{personaEnLugar(P,L,T):lugar(L)}1:- persona(P), tiempo(T).  % Toda persona en todo tiempo tiene que estar en algún lugar.
:- personaEnLugar(P,L1,T), personaEnLugar(P,L2,T), L1 != L2. % Una persona no puede estar en dos lugares al mismo tiempo
:- personaEnLugar(P1,L,T), personaEnLugar(P2,L,T), P1 != P2. % No pueden haber dos personas en un mismo lugar
:- personaEnLugar(P,L2,T), personaEnLugar(P,L1,T+1), not camino(L1,L2). % Se eliminan los modelos donde se unen lugares sin camino que los conecte

% Un requisito para ser culpbale es haber pasado por el lugar del graffiti al menos una vez antes del descubrimiento
1{posible_culpable(P)}:-personaEnLugar(P,L,T1),descubrimiento(L,T2),T1<T2.
:- not posible_culpable(P):persona(P).

%Para que alguien sea sopechoso tiene que haber pasado al menos 3 veces por el lugar del graffiti antes del descubrimiento y no ser culpable
sospechoso(P):-personaEnLugar(P,L,T1),personaEnLugar(P,L,T2),personaEnLugar(P,L,T3),descubrimiento(L,T4),T1<T2,T2<T3,T3<T4, not culpable(P).

1{culpable(P):posible_culpable(P)}1. % Siempre habrá un culpable

% Se consideran ciertas todas las afirmaciones dichas por quienes NO son culpables
personaEnLugar(P2,L,T):- afirmacionLugar(P1,P2,L,T) ,not culpable(P1).

% De esta manera se asume que siempre hay un culpable y busca los modelos en que se cumpla lo que los demás digan. Recordar que buscamos una posible solución, no hay una única.




#minimize {1,P : sospechoso(P)}.

#show culpable/1.
#show sospechoso/1.
%#show personaEnLugar/3.




