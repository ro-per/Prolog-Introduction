% Maak lege stack
empty([]).

pop(X, [X|Stack],Stack).

push(Element, Stack, [Element|Stack]).
