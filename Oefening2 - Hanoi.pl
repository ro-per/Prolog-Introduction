% Verplaatsen van 1 schijf van X naar Y
verplaats(1,X,_,Y):- schrijf(X,Y).

% Verplaatsen van N schijven van X naar Y met Hulp
verplaats(N,X,H,Y):-
  N>1,
  M is N-1,
  % Verplaatsen van N-1 schijven van X naar Hulp
  verplaats(M,X,Y,H),
  
  schrijf(X,Y),
  
  % Verplaatsen van N-1 schijven van Hulp naar Y
  verplaats(M,H,X,Y).
% Uitschrijven van verplaatsing
info(X,Y) :-write([verplaats,een,schijf,van,X,naar,Y]),nl.
schrijf(X,Y) :-write([X --> Y]) ,nl.

