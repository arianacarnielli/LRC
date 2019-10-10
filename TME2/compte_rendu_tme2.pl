[/*Compte rendu TME2

CARNIELLI Ariana 3525837
QUABOUL Dorian 3872944

Exercice 1 :
*/

/*
r(a,b).
r(f(X),Y):- p(X,Y).
p(f(X),Y):- r(X,Y).
*/

/*
1.
[trace]  ?- r(f(f(a)),b).
   Call: (7) r(f(f(a)), b) ? creep
   Call: (8) p(f(a), b) ? creep
   Call: (9) r(a, b) ? creep
   Exit: (9) r(a, b) ? creep
   Exit: (8) p(f(a), b) ? creep
   Exit: (7) r(f(f(a)), b) ? creep


Analyse de la trace : 
On cherche à prouver r(f(f(a)),b). La première étape consiste à trouver une unification avec une des clauses définies. Prolog trouve qu'il peut faire une unification avec la 2ème clause avec X=f(a) et Y=b. La deuxième étape consiste à prouver la 2ème partie de la clause qui a déjà été unifiée, c'est à dire p(f(a),b). Ensuite, il trouve une unification avec la 3ème clause avec X=a et Y=b. Cela rend r(a,b) ce qui correspond à la 1ère clause donc la requête est vérifiée ce qui vérifie les clauses précédentes.

    
 [trace]  ?- p(f(a),b).
 Call: (7) p(f(a), b) ? creep
 Call: (8) r(a, b) ? creep
 Exit: (8) r(a, b) ? creep
 Exit: (7) p(f(a), b) ? creep


Analyse de la trace :
on cherche à prouver p(f(a),b). Prolog fait avec une unification avec la 3ème clause avec X=a et Y=b. Puis il cherche à prouver la 2ème partie de la clause r(a,b) qui est vérifiée par la première clause. Donc la requête est prouvée.

Exercice 2 :
*/


r(a,b).
q(X,X).
q(X,Z):- r(X,Y),q(Y,Z).


/*
Pour simplifier les analyses des traces on renome les variables dans les clauses de la façon suivante :

r(a,b).
q(T,T).
q(W,Z):- r(W,Y), q(Y,Z).

Première trace:

[trace]  ?- q(X,b).
   Call: (7) q(_G1353, b) ? creep
   Exit: (7) q(b, b) ? creep
X = b ;
   Redo: (7) q(_G1353, b) ? creep
   Call: (8) r(_G1353, _G1430) ? creep
   Exit: (8) r(a, b) ? creep
   Call: (8) q(b, b) ? creep
   Exit: (8) q(b, b) ? creep
   Exit: (7) q(a, b) ? creep
X = a ;
   Redo: (8) q(b, b) ? creep
   Call: (9) r(b, _G1430) ? creep
   Fail: (9) r(b, _G1430) ? creep
   Fail: (8) q(b, b) ? creep
   Fail: (7) q(_G1353, b) ? creep
false.

Analyse de la trace :

On cherche à prouver q(X,b). Prolog trouve 2 possibles unifications :

- La 1ère se fait avec la 2eme clause avec X=b et T=b. Il trouve comme solution X=b.
 
- La 2ème se fait avec la 3ème clause avec Z=b et W=X. Il reste à prouver la 2ème partie de la clause non(r(X,Y)) ou non(q(Y,b)). Il unifie avec la 1ère clause X=a et Y=b ce qui donne q(b,b). Maintenant Prolog peut choisir entre : 

-- Conclure avec la 2ème clause avec T = b, donnant comme solution X=a

-- Essayer d'unifier avec la 3ème clause avec W=b et Z=b. À partir de ce point il lui faut traiter non(r(b,Y)) ou non(q(Y,b)) et il n'arrive pas à conclure car il est impossible de unifier non(r(b,Y)) avec les clauses existantes.
 
Deuxième trace:

[trace]  ?- q(b,X).
   Call: (7) q(b, _G1354) ? creep
   Exit: (7) q(b, b) ? creep
X = b ;
   Redo: (7) q(b, _G1354) ? creep
   Call: (8) r(b, _G1430) ? creep
   Fail: (8) r(b, _G1430) ? creep
   Fail: (7) q(b, _G1354) ? creep
false.

Analyse de la trace :

On cherche à prouver q(b,X). Prolog trouve 2 possibles unifications :
- La 1ère se fait avec la 2ème clause avec X=b et T=b. Il trouve comme solution X=b.
- La 2ème se fait avec la 3ème clause avec W=b et Z=X. À partir de ce point il lui faut traiter non(r(b,Y)) ou non(q(Y,X)) il n'arrive pas à conclure car il est impossible de unifier non(r(b,Y)) avec les clauses existantes.


Exercice 4 :

*/

pere(pepin,charlemagne).
pere(pepin,gisele).
pere(charles,pepin).
pere(bertrand,dorian).
pere(bertrand,alex).

mere(berthe,charlemagne).
mere(berthe,gisele).
mere(gisele,bertrand).
mere(ruth,pepin).
mere(cisca,dorian).
mere(cisca,alex).

parent(X,Y):- pere(X,Y).
parent(X,Y):- mere(X,Y).

parents(X,Y,Z):-pere(X,Z),mere(Y,Z).

grandpere(X,Y):-pere(X,Z),parent(Z,Y).

grandmere(X,Y):-mere(X,Z),parent(Z,Y).

frereousoeur(X,Y):-pere(Z,X),pere(Z,Y).
frereousoeur(X,Y):-mere(Z,X),mere(Z,Y).

ancetre(X,Y):-parent(X,Y).
ancetre(X,Y):-parent(X,Z), ancetre(Z,Y).

/*
Les rélations definies sont représentées par l'arbre généalogique suivant :

charles  ruth
  │p      │m
pepin    berthe
  │ └────┐│   └─┐
  │   ┌──┼┘     │
  │p  │m └───┐p │m
charlemagne  gisele
               │m
             bertrand   cisca
              │ └────┐  │   │
              │   ┌──┼──┘   │
              │p  │m └───┐p │m
             dorian      alex

p : père
m : mère 
	
Les tests realisés ont été les suivants :
	
?- pere(pepin, gisele).
true.

?- parent(berthe, gisele).
true.

?- mere(X, bertrand).
X = gisele.

?- parents(X,Y,dorian).
X = bertrand,
Y = cisca.

?- parents(X,Y,dorian).
X = bertrand,
Y = cisca.

?- ancetre(X, gisele).
X = pepin ;
X = berthe ;
X = charles ;
X = ruth ;
false.

?- frereousoeur(X, alex).
X = dorian ;
X = alex ;
X = dorian ;
X = alex.

Ici on voit deux choses : 

- Alex est consideré comme son propre frère car il a le même père et mère que lui même.
- Les résultats apparaissent répetés car le test est fait une fois avec le père et une fois avec la mère. Si quelqu'un a un seul parent en commun avec quelqu'un d'autre (demi-frère ou demi-soeur) alors ce résultat n'apparait qu'une fois. On pourrait modifier la relation en utilisant parents(X,Y,Z) pour ne pas prend en considération les demi-frères ou soeurs et alors le résultat ne serait pas repeté. 

?- grandpere(pepin,Y).
Y = bertrand.

?- grandmere(ruth,Y).
Y = charlemagne ;
Y = gisele ;
false.

?- frereousoeur(X, Y).
X = Y, Y = charlemagne ;
X = charlemagne,
Y = gisele ;
X = gisele,
Y = charlemagne ;
X = Y, Y = gisele ;
X = Y, Y = pepin ;
X = Y, Y = dorian ;
X = dorian,
Y = alex ;
X = alex,
Y = dorian ;
X = Y, Y = alex ;
X = Y, Y = charlemagne ;
X = charlemagne,
Y = gisele ;
X = gisele,
Y = charlemagne ;
X = Y, Y = gisele ;
X = Y, Y = bertrand ;
X = Y, Y = pepin ;
X = Y, Y = dorian ;
X = dorian,
Y = alex ;
X = alex,
Y = dorian ;
X = Y, Y = alex.

On remarque que non seulement on a beaucoup de repétition mais chaque personne qui a un père ou une mère apparait aussi dans la liste car ils sont frère ou soeur d'eux mêmes. Pour corriger cela on peut modifier la relation frereousoeur(X,Y) comme : 

frereousoeur(X,Y):-pere(Z,X),pere(Z,Y), X\==Y.
frereousoeur(X,Y):-mere(Z,X),mere(Z,Y), X\==Y.

Le résultat avec cette nouvelle version est donné ci-dessous :

?- frereousoeur(X, Y).
X = charlemagne,
Y = gisele ;
X = gisele,
Y = charlemagne ;
X = dorian,
Y = alex ;
X = alex,
Y = dorian ;
X = charlemagne,
Y = gisele ;
X = gisele,
Y = charlemagne ;
X = dorian,
Y = alex ;
X = alex,
Y = dorian ;
false.

Exercice 5		
*/

et(0,0,0).
et(0,1,0).
et(1,0,0).
et(1,1,1).

ou(0,0,0).
ou(0,1,1).
ou(1,0,1).
ou(1,1,1).

non(0,1).
non(1,0).

nand(X,Y,R):- et(X,Y,Z), non(Z,R).

xor(X,Y,R):- ou(X,Y,Z), nand(X,Y,T), et(Z,T,R). 

circuit(X,Y,R):- nand(X,Y,A), non(X,B), xor(A,B,C), non(C,R).

/*
On a cree les relations nand(X,Y,R) et xor(X,Y,R) pour implementer le circuit sans faire directement sa table de verité.

Table de verité du circuit :

?- circuit(X,Y,R).
X = Y, Y = 0,
R = 1 ;
X = 0,
Y = R, R = 1 ;
X = 1,
Y = R, R = 0 ;
X = Y, Y = R, R = 1 ;
false.

On verifie que c'est bien la table de verité de l'implication.

D'autres tests:

?- circuit(X,Y,0).
X = 1,
Y = 0 ;
false.

?- circuit(X,Y,1).
X = Y, Y = 0 ;
X = 0,
Y = 1 ;
X = Y, Y = 1 ;
false.

?- circuit(X,0,R).
X = 0,
R = 1 ;
X = 1,
R = 0 ;
false.

?- circuit(0,0,0).
false.

?- xor(X,Y,R).
X = Y, Y = R, R = 0 ;
X = 0,
Y = R, R = 1 ;
X = R, R = 1,
Y = 0 ;
X = Y, Y = 1,
R = 0 ;
false.

?- nand(X,Y,R).
X = Y, Y = 0,
R = 1 ;
X = 0,
Y = R, R = 1 ;
X = R, R = 1,
Y = 0 ;
X = Y, Y = 1,
R = 0.

Exercice 3
*/

revise(X):- serieux(X).
faitdevoir(X):- consciencieux(X).
reussit(X):- revise(X).
serieux(X):- faitdevoir(X).
consciencieux(pascal).
consciencieux(zoe).

/*
La requête qui permet de répondre à la question "qui va reussir ?" est : reussit(X).
Le résultat attendu est Pascal et Zoe. Prolog donne :

?- reussit(X).
X = pascal ;
X = zoe.

*/
