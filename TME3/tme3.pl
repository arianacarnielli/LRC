/*Compte rendu TME3

CARNIELLI Ariana 3525837
QUABOUL Dorian 3872944

Exercice 1 :

?- [a, [b, c], d] = [X].
false.

?- [a, [b, c], d] = [X, Y, Z].
X = a,
Y = [b, c],
Z = d.

?- [a, [b, c], d] = [a|L].
L = [[b, c], d].

?- [a, [b, c], d] = [X, Y].
false.

?- [a, [b, c], d] = [X| Y].
X = a,
Y = [[b, c], d].

?- [a, [b, c], d] = [a, b| L].
false.

?- [a, b, [c, d]] = [a, b| L].
L = [[c, d]].

?- [a, b, c, d | L1] = [a, b| L2].
L2 = [c, d|L1].

Exercice 2 :


*/

concatene([], Y, Y).
concatene([H|T], Y, [H|R]):- concatene(T, Y, R).

inverse([X],[X]).
inverse([H1|T1], L2):- inverse(T1, C), concatene(C,[H1],L2).

supprime([], Y, []).
supprime([H|T], Y, Z):- H\==Y, supprime(T, Y, Z2), concatene([H], Z2, Z). 
supprime([H|T], H, Z):- supprime(T, H, Z). 
