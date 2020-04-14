/* ['d:/programming/prolog/familie.pl'].*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vrouw(marry). % Generatie Grootouders
vrouw(eve). % Generatie Grootouders
vrouw(kaat). % Generatie Ouders
vrouw(lena). % Generatie Ouders
vrouw(els). % Generatie Kinderen
man(adam). % Generatie Grootouders
man(tom). % Generatie Ouders
man(paul). % Generatie Ouders
man(kurt). % Generatie Kinderen
man(peter). % Generatie Kinderen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kinderen Marry en Adam
ouder(marry,tom).
ouder(adam,tom).
ouder(marry,kaat).
ouder(adam,kaat).
ouder(marry,paul).
ouder(adam,paul).

% Kinderen Adam en Eve
ouder(adam,peter).
ouder(eve,peter).

% Kinderen Paul en Lena
ouder(paul,kurt).
ouder(lena,kurt).
ouder(paul,els).
ouder(lena,els).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vader en Moeder
vader(F,C):-man(F),ouder(F,C).
moeder(M,C):-vrouw(M),ouder(M,C).

% Zoon en Dochter
zoon(S,P):-man(S),ouder(P,S).
dochter(D,P):-vrouw(D),ouder(P,D).

% Broer en Zus
broer(B,S):-man(B),ouder(P,B),ouder(P,S),dif(B,S).
zus(S,B):-vrouw(S),ouder(P,S),ouder(P,B),dif(S,B).

% Nonkel en Tante
nonkel(U,C):-ouder(P,C),broer(U,P).
tante(A,C):-ouder(P,C),zus(A,P).

% Grootouder
grootouder(G,C):-ouder(A,C),ouder(G,A).
grootmoeder(M,C):-vrouw(M),grootouder(M,C).
grootvader(F,C):-man(F),grootouder(F,C).
