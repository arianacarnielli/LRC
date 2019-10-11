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

/*
Tests du predicat concatene(X,Y,Z) : 
  
?- concatene([1,2,3], [a,b], R).
R = [1, 2, 3, a, b].

?- concatene([1,2,3], [], R).
R = [1, 2, 3].

?- concatene([1,2,3], Y, [1,2,3,4]).
Y = [4].

?- concatene([1,2,3], Y, R).
R = [1, 2, 3|Y].

?- concatene(X, Y,[1,2,3]).
X = [],
Y = [1, 2, 3] ;
X = [1],
Y = [2, 3] ;
X = [1, 2],
Y = [3] ;
X = [1, 2, 3],
Y = [] ;
false.
*/

inverse([],[]).
inverse([H|T], L):- inverse(T, R), concatene(R, [H], L).

/*
Tests du predicat inverse(S, T) : 

?- inverse([], []).
true.

?- inverse([1, 2, 3], [3, 2, 1]).
true.

?- inverse([1, 2, 3], [3, 2]).
false.

?- inverse([], X).
X = [].

?- inverse([1, 2, 3], X).
X = [3, 2, 1].

?- inverse([1], [1]).
true.

?- inverse(X, [1, 2, 3]).
X = [3, 2, 1] ;
^CAction (h for help) ? break

On remarque que ce prédicat inverse marche bien lorsque les deux termes sont des listes ou lorsque le deuxième terme est une variable, mas pas quand c'est le premier terme qui est une variable, auquel cas on obtient la bonne réponse mais aussi une boucle infinie. Cette construction, en particulier, n'est pas symétrique.

Si on note C1 et C2 les clauses ci-dessus, respectivement, le prédicat inverse(X, [1, 2, 3]) sera forcément unifié avec C2 avec X = [H|T] et L = [1, 2, 3]. Pour cela, prolog essaiera de prouver inverse(T, R) et concatenate(R, [H], [1, 2, 3]). Pour prouver inverse(T, R), comme T et R sont deux variables quelconques, inverse(T, R) peut être unifiée avec C1 et C2. En unifiant avec C1, il arrive à la bonne réponse. En unifiant avec C2, prolog arrivera à une unification possible qui lui demande de prouver une clause contenant inverse(T', R') pour des nouvelles variables T', R'. Il arrive ainsi à une boucle infinie.

Une tentative de solution est de changer la clause C2 en
inverse([H|T], L):- concatene(R, [H], L), inverse(T, R).
L'appel à inverse(X, [1, 2, 3]) ne boucle plus car, en faisant l'unification avec C2, prolog résoudra d'abord concatene(R, [H], [1, 2, 3]), ce qui donne R = [1, 2] et H = 3 comme solution, et il sera ensuite amené à résoudre inverse(T, [1, 2]) : on a réduit la taille de la deuxième liste d'un élément, et il arrivera finalement à terminer.

Mais l'appel inverse([1, 2, 3], X) ne marche plus dans ce cas : en faisant l'unification avec C2, il prend H = 1, T = [2, 3] et L = X, ce qui lui demandra de résoudre concatene(R, [1], X). Or, il existe une infinité de listes R et X qui satisfont ce prédicat, ce qui veut dire que cette solution ne s'arrête pas.

En cherchant des réponses sur stackoverflow, on a trouvé l'implémentation suivante :
*/

rev(S, T):- rev(S,T,S,T,[],[]).
rev(S,T,[],[],T,S).
rev(S,T,[Sh|St],[Th|Tt],Sc,Tc):- rev(S,T,St,Tt,[Sh|Sc],[Th|Tc]).

/*
Elle utilise des accumulateurs pour S et T pour éviter d'avoir des variables qui ont une infinité de valeurs possibles. En plus, on remarque que ce prédicat est symétrique entre S et T. Voici quelques tests :

?- rev([], []).
true ;
false.

?- rev([1, 2, 3], [3, 2, 1]).
true ;
false.

?- rev([1, 2, 3], [3, 2]).
false.

?- rev([], X).
X = [] ;
false.

?- rev([1, 2, 3], X).
X = [3, 2, 1] ;
false.

?- rev([1], [1]).
true ;
false.

?- rev(X, [1, 2, 3]).
X = [3, 2, 1] ;
false.

?- rev([1, 2, X], [3, Y, 1]).
X = 3,
Y = 2 ;
false.

On remarqueque le predicat reverse natif de Prolog ne boucle pas non plus mais n'est pas symétrique :

?- reverse(X, [1, 2, 3]).
X = [3, 2, 1] ;
false.

?- reverse([1, 2, 3], X).
X = [3, 2, 1].

*/

supprime([], _, []).
supprime([H|T], Y, Z):- H\==Y, supprime(T, Y, Z2), concatene([H], Z2, Z). 
supprime([H|T], H, Z):- supprime(T, H, Z). 

/*
Tests du predicat supprime(X, Y, Z) : 

?- supprime([a, b, a, c], a, L).
L = [b, c] ;
false.

?- supprime([a, b, a, c], d, L).
L = [a, b, a, c] ;
false.

?- supprime([a, b, a, c], a, [b, c]).
true ;
false.

?- supprime(X, a, [b, c]).
X = [b, c] ;
^CAction (h for help) ? break
% Break level 1

Il y a une infinité de listes X qui satisfont le prédicat ci-dessus, ce qui explique la boucle infinie.

[1]  ?- supprime([a, b, a, c], Y, [b, c]).
Y = a ;
false.

[1]  ?- supprime([a, b, a, c], Y, [b, c, d]).
false.

[1]  ?- supprime([a, b, a, c], [a, b], X).
X = [a, b, a, c] ;
false.

*/

filtre(L1, [], L1).
filtre(L1, [H|T], R) :- supprime(L1, H, Z), filtre(Z, T, R). 

/*
Tests du predicat filtre(X, Y, Z) :

?- filtre([a, b, c], [], Y).
Y = [a, b, c] ;
false.

?- filtre([a, b, c], [a], Y).
Y = [b, c] ;
false.

?- filtre([a, b, a, c], [a], Y).
Y = [b, c] ;
false.

?- filtre([a, b, a, c], [a, a], Y).
Y = [b, c] ;
false.

?- filtre([a, b, a, c], [a, b], Y).
Y = [c] ;
false.

?- filtre([1, 2, 3, 4, 2, 3, 4, 2, 4, 1], [2, 4], Y).
Y = [1, 3, 3, 1] ;
false.

?- filtre([a, a], [a], Y).
Y = [] ;
false.

?- filtre(X, [a], [b, c]).
X = [b, c] ;
^CAction (h for help) ? break
% Break level 1

?- filtre([a, b, c], Y, [b, c]).
^CAction (h for help) ? break
% Break level 1

Dans les deux derniers cas, on a une boucle infinie car il y a une infinité de listes qui les satisfont : X peut avoir une quantité arbitraire de "a" à des positions arbitraires et la liste Y, outre "a", peut contenir tout autre terme sauf "b" et "c".
*/

palindrome(L) :- inverse(L, L).

/*
Tests du predicat palindrome(L) :

?- palindrome([]).
true.

?- palindrome([n,o,n]).
true.

?- palindrome([l, a, v, a, l]).
true.

?- palindrome([n, a, v, a, l]).
false.

?- palindrome([e,s,o,p,e,r,e,s,t,e,i,c,i,e,t,s,e,r,e,p,o,s,e]).
true.

?- palindrome([s,o,c,o,r,r,a,m,m,e,s,u,b,i,n,o,o,n,i,b,u,s,e,m,m,a,r,r,o,c,o,s]).
true.

?- palindrome([a, b, c, X]).
false.

?- palindrome([a, b, b, X]).
X = a.

?- palindrome([a, b, c, X, Y, Z]).
X = c,
Y = b,
Z = a.

?- palindrome([X]).
true.

?- palindrome([X, Y, Z, Y, X]).
true.

?- palindrome([X, Y, Z, W]).
X = W,
Y = Z.

?- palindrome(X).
X = [] ;
X = [_7006] ;
X = [_7006, _7006] ;
X = [_7006, _7012, _7006] ;
X = [_7006, _7012, _7012, _7006] ;
X = [_7006, _7012, _7018, _7012, _7006] ;
X = [_7006, _7012, _7018, _7018, _7012, _7006] ;
X = [_7006, _7012, _7018, _7024, _7018, _7012, _7006] ;
X = [_7006, _7012, _7018, _7024, _7024, _7018, _7012, _7006] ;
X = [_7006, _7012, _7018, _7024, _7030, _7024, _7018, _7012, _7006] ;
X = [_7006, _7012, _7018, _7024, _7030, _7030, _7024, _7018, _7012|...] ;
X = [_7006, _7012, _7018, _7024, _7030, _7036, _7030, _7024, _7018|...] ;
X = [_7006, _7012, _7018, _7024, _7030, _7036, _7036, _7030, _7024|...] .
*/

palindrome2([]).
palindrome2([_]).
palindrome2([H|T]) :- concatene(Z, [H], T), palindrome2(Z).

/*
Tests du predicat palindrome2(L) :

?- palindrome2([]).
true.

?- palindrome2([n,o,n]).
true ;
false.

?- palindrome2([l, a, v, a, l]).
true ;
false.

?- palindrome2([n, a, v, a, l]).
false.

?- palindrome2([e,s,o,p,e,r,e,s,t,e,i,c,i,e,t,s,e,r,e,p,o,s,e]).
true ;
false.

?- palindrome2([s,o,c,o,r,r,a,m,m,e,s,u,b,i,n,o,o,n,i,b,u,s,e,m,m,a,r,r,o,c,o,s]).
true ;
false.

?- palindrome2([a, b, c, X]).
false.

?- palindrome2([a, b, b, X]).
X = a ;
false.

?- palindrome2([a, b, c, X, Y, Z]).
X = c,
Y = b,
Z = a ;
false.

?- palindrome2([X]).
true ;
false.

?- palindrome2([X, Y, Z, Y, X]).
true ;
false.

?- palindrome2([X, Y, Z, W]).
X = W,
Y = Z ;
false.

?- palindrome2(X).
X = [] ;
X = [_6846] ;
X = [_6846, _6846] ;
X = [_6846, _6858, _6846] ;
X = [_6846, _6858, _6858, _6846] ;
X = [_6846, _6858, _6870, _6858, _6846] ;
X = [_6846, _6858, _6870, _6870, _6858, _6846] ;
X = [_6846, _6858, _6870, _6882, _6870, _6858, _6846] ;
X = [_6846, _6858, _6870, _6882, _6882, _6870, _6858, _6846] ;
X = [_6846, _6858, _6870, _6882, _6894, _6882, _6870, _6858, _6846] ;
X = [_6846, _6858, _6870, _6882, _6894, _6894, _6882, _6870, _6858|...] ;
X = [_6846, _6858, _6870, _6882, _6894, _6906, _6894, _6882, _6870|...] ;
X = [_6846, _6858, _6870, _6882, _6894, _6906, _6906, _6894, _6882|...] .

*/
