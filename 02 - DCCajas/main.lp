% MODIFICACIONES AL CODIGO "BODEGAS_RESUELTO.LP" VISTO EN CLASES


#const bound = 13.
time(1..bound).

% hay 5 acciones posibles
action(up).
action(down).
action(left).
action(right).
action(wait).
%action(tomar).

% suponga que exec(R,A,T) expresa que R \
% ejecuta la accion A en T

% on(R,X,Y,T) expresa que el robot R está en (X,T)
% el el tiempo T
on(R,X,Y+1,T+1) :- exec(R,up,T),on(R,X,Y,T),time(T+1).
on(R,X,Y-1,T+1) :- exec(R,down,T),on(R,X,Y,T),time(T+1).
on(R,X-1,Y,T+1) :- exec(R,left,T),on(R,X,Y,T),time(T+1).
on(R,X+1,Y,T+1) :- exec(R,right,T),on(R,X,Y,T),time(T+1).
on(R,X,Y,T+1) :- exec(R,wait,T),on(R,X,Y,T),time(T+1).


%Agregar las opciones de tomar caja en las 4 direcciones, cuidar que la caja esté en el suelo
2{on(R,X,Y,T+1); boxOn(B,X,Y,1,T+1)}2 :- exec(R,tomar,T),on(R,X,Y,T),time(T+1),boxOn(B,X+1,Y,0,T), not boxOn(B2,X,Y,1,T):box(B2).
2{on(R,X,Y,T+1); boxOn(B,X,Y,1,T+1)}2 :- exec(R,tomar,T),on(R,X,Y,T),time(T+1),boxOn(B,X-1,Y,0,T), not boxOn(B2,X,Y,1,T):box(B2).
2{on(R,X,Y,T+1); boxOn(B,X,Y,1,T+1)}2 :- exec(R,tomar,T),on(R,X,Y,T),time(T+1),boxOn(B,X,Y+1,0,T), not boxOn(B2,X,Y,1,T):box(B2).
2{on(R,X,Y,T+1); boxOn(B,X,Y,1,T+1)}2 :- exec(R,tomar,T),on(R,X,Y,T),time(T+1),boxOn(B,X,Y-1,0,T), not boxOn(B2,X,Y,1,T):box(B2).

%Agregar que la caja se mueva con el robot
boxOn(B,X,Y+1,T+1) :- on(R,X,Y+1,T+1), on(R,X,Y,T),time(T+1), boxOn(B,X,Y,1,T).
boxOn(B,X,Y-1,T+1) :- on(R,X,Y-1,T+1), on(R,X,Y,T),time(T+1), boxOn(B,X,Y,1,T).
boxOn(B,X-1,Y,T+1) :- on(R,X-1,Y,T+1), on(R,X,Y,T),time(T+1), boxOn(B,X,Y,1,T).
boxOn(B,X+1,Y,T+1) :- on(R,X+1,Y,T+1), on(R,X,Y,T),time(T+1), boxOn(B,X,Y,1,T).


% Escriba una restricción que exprese que cada robot
% puede ejecutar exactamente una acción en cada instante de tiempo

%1 { exec(R,up,T); exec(R,down,T) ; exec(R,right,T) ;
%    exec(R,left,T) ; exec(R,wait,T)}1 :- robot(R),time(T+1).

1 { exec(R,A,T) : action(A)} 1 :- robot(R),time(T+1).

% Escriba las restriciones que considere necesarias
% suponiendo que:
% rangeX(W): W está dentro del rango del eje X
% rangeY(W): W está dentro del rango del eje Y

:- on(R,X,Y,T),not rangeX(X).
:- on(R,X,Y,T),not rangeY(Y).
:- on(R,X,Y,T), obstacle(X,Y).
:- on(R1,X,Y,T), on(R2,X,Y,T), R1!=R2.
:- on(R1,X,Y,T),on(R2,X+1,Y,T),on(R2,X,Y,T+1),on(R1,X+1,Y,T+1).
:- on(R1,X,Y,T),on(R2,X,Y+1,T),on(R2,X,Y,T+1),on(R1,X,Y+1,T+1).

% Un robot no puede estar sobre una caja que está en el suelo
:- on(R,X,Y,T),boxOn(B,X,Y,0,T).

% Suponga que el usuario definirá goal(R,X,Y)
% que expresa que el objetivo de R es llegar a (X,Y)

% Escriba una regla el predicado at_goal(R,T), que expresa
% que el robot R está en su objetivo en el tiempo T
at_goal(R,T) :- on(R,X,Y,T),goal(X,Y).

% En términos de at_goal, defina una restricción
% expresando que todo robot debe llegar al objetivo
:- robot(R), not at_goal(R,bound).

#show on/4.
#show boxOn/5.
#show obstacle/2.
#show rangeX/1.
#show rangeY/1.
#show exec/3.
#show goal/2.

% Se agrega esto para optimizar que se ejecuten la menor cantidad de acciones, así no hay movimientos inecesarios
#minimize {1,exec(R,A,T):robot(R),action(A),time(T)}.
