boole_not(1,0).
boole_not(0,1).
boole_and(0,0,0).
boole_or(0,0,0).
boole_xor(0,0,0).
boole_and(0,1,0).
boole_or(0,1,1).
boole_xor(0,1,1).
boole_and(1,0,0).
boole_or(1,0,1).
boole_xor(1,0,1).
boole_and(1,1,1).
boole_or(1,1,1).
boole_xor(1,1,0).

initial_assign([],[]).
initial_assign([X|R],[0|S]) :- initial_assign(R,S).

successor(A,S) :- reverse(A,R),
                  next(R,N),
                  reverse(N,S).

next([0|R],[1|R]).
next([1|R],[0|S]) :- next(R,S).

truth_value(N,_,_,N) :- member(N,[0,1]).
truth_value(X,Vars,A,Val) :- atom(X),
                             lookup(X,Vars,A,Val).
truth_value(and(X,Y),Vars,A,Val) :- truth_value(X,Vars,A,VX),
                                   truth_value(Y,Vars,A,VY),
                                   boole_and(VX,VY,Val).
truth_value(or(X,Y),Vars,A,Val) :-  truth_value(X,Vars,A,VX),
                                   truth_value(Y,Vars,A,VY),
                                   boole_or(VX,VY,Val).
truth_value(xor(X,Y),Vars,A,Val) :-  truth_value(X,Vars,A,VX),
                                   truth_value(Y,Vars,A,VY),
                                   boole_xor(VX,VY,Val).
truth_value(not(X),Vars,A,Val) :-   truth_value(X,Vars,A,VX),
                                   boole_not(VX,Val).

lookup(X,[],[],0) :- \+ X.
lookup(X,[],[],1) :- X.
lookup(X,[X|_],[V|_],V).
lookup(X,[_|Vars],[_|A],V) :- lookup(X,Vars,A,V).

t_table(Vars,E,T) :- initial_assign(Vars,A), write_row(E,Vars,A,T).

write_row(E,Vars,A,[[A,V]|T]) :- truth_value(E,Vars,A,V), (successor(A,N) -> write_row(E,Vars,N,T) ; T=[]).