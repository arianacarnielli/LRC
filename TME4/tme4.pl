/*
Compte rendu TME4

CARNIELLI Ariana 3525837
QUABOUL Dorian 3872944

Exercice 1 :

	On présente ci-dessous en Prolog les connaissances de l'exercice de TD sur les animaux qui seront utilisés pour les tests.

*/


/*
	T-Box :
*/

subs(chat,felin).
subs(lion,felin).
subs(chien,canide).
subs(canide,chien).
subs(souris,mammifere).
subs(felin,mammifere).
subs(canide,mammifere).
subs(mammifere,animal).
subs(canari,animal).
subs(animal,etreVivant).
subs(and(animal,plante),nothing).
subs(and(animal, some(aMaitre)),pet).
subs(pet, some(aMaitre)).
subs(chihuahua,and(pet, chien)).

subs(lion,carnivoreExc).
subs(carnivoreExc,predateur).
subs(animal, some(mange)).
subs(and(all(mange, nothing), some(mange)), nothing).
all(aMaitre, humain).
equiv(carnivoreExc,all(mange,animal)).
equiv(herbivoreExc,all(mange,plante)).

/*
	A-Box :
*/

inst(felix,chat).
inst(pierre,humain).
inst(princesse,chihuahua).
inst(marie,humain).
inst(jerry,souris).
inst(titi,canari).

instR(princesse,aMaitre,marie).
instR(felix,aMaitre,pierre).
instR(felix,mange,jerry).
instR(felix,mange,titi).

/*
Exercice 2

	Voici l'implementation fournie par l'enoncé :
*/

subsS1(C,C).
subsS1(C,D):-subs(C,D),C\==D.
subsS1(C,D):-subs(C,E),subsS1(E,D).

/*
	1. Ces règles traduisent la transitivité de la subsomption structurelle. 
	La première règle dit que tout concept (atomique dans le cadre de cet exercice) est subsumé par soi-même.
	La deuxième règle dit que si C est subsumé par D alors il l'est aussi de façon structurelle.
	La dernière règle dit que si C est subsumé par E et si E est subsumé structurellement par D, alors C est subsumé structurellement par D.

	2. Voici les résultats des tests :
	
	?- subsS1(canari, animal).
	true ;
	true ;
	false.

	?- subsS1(chat, etreVivant).
	true ;
	true ;
	false.
	
	On remarque que la transitivité a bien fonctionnée, les deux test ayant des résultats True comme atendu. Comme Prolog est exhaustif il teste toutes les possibilités, ce pourquoi on a plus d'un True et un False. 
	Ainsi pour le premier on a un premier True à cause de subs(canari, animal) en utilisant la deuxième clause et un autre True à cause de subs(canari, animal) et subsS1(animal, animal) en utilisant d'abord la troisième clause et après la première. Il trouve aussi un False en essayant d'appliquer la troisième clause à subsS1(animal, animal).  
	Une analyse similaire peut être faite pour le deuxième test.
	
	3. Voici la trace correspondante :
	
	[trace]  ?- subsS1(chien, souris).
	Call: (8) subsS1(chien, souris) ? creep
	Call: (9) subs(chien, souris) ? creep
	Fail: (9) subs(chien, souris) ? creep
	Redo: (8) subsS1(chien, souris) ? creep
	Call: (9) subs(chien, _7328) ? creep
	Exit: (9) subs(chien, canide) ? creep
	Call: (9) subsS1(canide, souris) ? creep
	Call: (10) subs(canide, souris) ? creep
	Fail: (10) subs(canide, souris) ? creep
	Redo: (9) subsS1(canide, souris) ? creep
	Call: (10) subs(canide, _7328) ? creep
	Exit: (10) subs(canide, chien) ? creep
	Call: (10) subsS1(chien, souris) ? creep
	Call: (11) subs(chien, souris) ?
	...
	
	Comme on peut voir, on a une boucle infinie car en testant subsS1(chien, souris) il arrive au bout de quelques étapes à tester à nouveaux subsS1(chien, souris). Cela se produit à cause du fait que on a à la fois subs(chien, canide) et subs(canide, chien). Si on considère le graphe orienté dont les sommets sont les concepts atomiques et deux concepts sont reliés par un arc si le premier est subsumé par le deuxième alors la notion de subsomption structurelle revient à trouver un chemin entre deux concepts. Or, le graphe contient un cycle et Prolog y tombe sans réussir à s'en sortir car le prédicat subsS1 ne contient aucun mécanisme de détection de cycle.  

*/

subsS(C,D):-subsS(C,D,[C]).
subsS(C,C,_).
subsS(C,D,_):-subs(C,D),C\==D.
subsS(C,D,L):-subs(C,E),not(member(E,L)),subsS(E,D,[E|L]),E\==D.


