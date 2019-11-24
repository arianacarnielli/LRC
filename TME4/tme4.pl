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
subs(some(aMaitre), all(aMaitre, humain)).
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

/*
	4. Voici les résultats des tests :
	
	?- subsS(canari, animal).
	true ;
	false.

	?- subsS(chat, etreVivant).
	true ;
	false.

	?- subsS(chien, canide).
	true ;
	false.

	?- subsS(chien, chien).
	true ;
	true ;
	false.
	
	Comme attendu, tous les tests reussissent. Quand il y a plusieurs chemins donnant la subsomption structurelle Prolog parcourt tous ces chemins et renvoie autant de true que de chemins qui reussissent. Par exemple pour subsS(chien, chien) il y a le chemin trivial mais il y a aussi le chemin chien -> canide -> chien, ce pourquoi on observe deux fois true.
	
	5. subsS a été codé de façon à fonctionner correctement avec des concepts atomiques mais rien ne l'empêche a priori de fonctionner aussi avec d'autres concepts. C'est le cas de some(mange). En effet, pour l'instant Prolog ne sait pas ce que "some", "all", "and", "equiv", "inst" et "instR" veulent dire ni comment les manipuler, c'est-à-dire, il ne connait pas leur sématique. Il arrive cependant à reconnaître leur égalité syntaxique, et c'est juste l'égalité syntaxique qui joue un rôle dans le test subsS(souris, some(mange)).
	
	De même, le test
	?- subsS(chihuahua, and(pet, chien)).
	marche bien, car il n'a besoin que de la syntaxe de and(pet, chien), mais
	?- subsS(chihuahua, and(chien, pet)).
	ne réussit pas car il dépend de la sémantique de and.
	
	6. Voici les résultats des tests :
	
	?- subsS(chat, humain).
	false.

	?- subsS(chien, souris).
	false.
	
	Comme attendu les deux tests échouent. En plus, l'appel avec (chien, souris) ne tombe pas dans une boucle infinie comme a la question 3 grace à liste des concepts déjà utilisés dans une branche. 

	7. Pour la subsomption structurelle subsS(chat, X), on s'attend aux réponses suivantes :

	- X = chat
	car tout concept est subsumé structurellement à soi même.
	- X = felin
	par la subsomption factuelle.
	- X = mammifere
	à cause de la subsomption précédente et de la subsomption factuelle entre felin et mammifere.
	- X = animal
	à cause de la subsomption précédente et de la subsomption factuelle entre mammifere et animal.
	- X = etreVivant
	à cause de la subsomption précédente et de la subsomption factuelle entre animal et etreVivant.
	- X = some(mange)
	à cause de la subsomption structurelle entre chat et animal et de la subsomption factuelle entre animal et some(mange).
	
	Le résultat du test est donnée ci-dessous et est conforme l'attendu.
	
	?- subsS(chat, X).
	X = chat ;
	X = felin ;
	X = mammifere ;
	X = animal ;
	X = etreVivant ;
	X = some(mange) ;
	false.
	
	Pour la subsomption structurelle subsS(X, mammifere), on s'attend aux réponses suivantes :
	
	- X = mammifere
	car tout concept est subsumé structurellement à soi même.
	- X = souris
	par la subsomption factuelle entre souris et mammifere.
	- X = felin
	par la subsomption factuelle entre felin et mammifere.
	- X = chat
	à cause de la subsomption précédente et de la subsomption factuelle entre chat et felin.
	- X = lion
	à cause de la subsomption entre felin et mammifere et de la subsomption factuelle
	entre lion et felin.
	- X = canide
	par la subsomption factuelle entre canide et mammifere.
	- X = chien
	à cause de la subsomption précédente et de la subsomption factuelle entre chien et canide.

	Le résultat du test est donnée ci-dessous et est conforme l'attendu.
	
	?- subsS(X, mammifere).
	X = mammifere ;
	X = souris ;
	X = felin ;
	X = canide ;
	X = chat ;
	X = lion ;
	X = chien ;
	false.
	
	8. 
	Voici des règles permettant d'obtenir les deux subsomptions à partir d'une équivalence.
*/

:- discontiguous subs/2.
subs(A, B) :- equiv(A, B).
subs(B, A) :- equiv(A, B).

/*
	La ligne
	:- discontiguous subs/2.
	évite le déclenchement d'un warning à cause du fait que ces clauses sur subs ne soient pas regroupées avec les autres.
	Une solution alternative est de faire
	subsS(A, B, _) :- equiv(A, B).
	subsS(B, A, _) :- equiv(A, B).
	La première correspond à regarder une équivalence comme deux subsomptions factuelles alors que la deuxième ne regarde l'équivalence que comme deux subsomptions structurelles. La différence entre les deux sera expliquée à la question 10. 
	
	9. Voici le test avant l'ajout des règles :
	?- subsS(lion, all(mange, animal)).
	false.
	
	Et ci-dessous le même test après l'ajout :
	?- subsS(lion, all(mange, animal)).
	true ;
	false.
	
	On a bien le comportement attendu.
	
	10. On a plus intérêt à dériver la subsomption factuelle, comme on l'a fait à la question 8, plutôt que la structurelle donnée en commentaire de cette question. En effet, la subsomption factuelle est le cas de base de subsS. Si on crée une subsomption factuelle entre deux concepts dans une équivalence, on est sûr d'y arriver, alors que cela n'est pas le cas si on crée une subsomption structurelle. Par exemple, supposons que l'on a, dans la T-Box:
	equiv(x, y).
	subs(y, z).
	Un appel à subsS(x, z), qui devrait réussir, fait d'abord un appel à subsS(x, z, [x]). L'unification avec la première règle de subsS/3 n'est pas possible, l'unification avec la deuxième échoue car subs(x, z) est faux, et il reste ainsi l'unification avec la dernière règle de subsS/3. Le premier littéral de cette clause est subs(x, E).
	
	Si on a crée des subsomptions factuelles à partir de l'équivalence, alors subs(x, E) peut être unifié avec la clause subs(A, B) :- equiv(A, B) avec A = x et B = E, et ensuite il trouvera B = y. Cette partie de l'appel réussit et il est facile à voir que le reste de l'appel réussit également.
	
	Si on a crée des subsomptions structurelles à partir de l'équivalence, subs(x, E) ne pourra être unifié avec aucune clause, et l'appel échoue.
	
	Les règles de subsS, avec les règles de subs rajoutées à la question 8, permettent de répondre à toute requête atomique si l'on suppose que la T-Box ne contient que des subsomptions ou équivalences entre concepts atomiques. En effet, dans ce cas, A est subsumé structurellement à B si et seulement si il existe une suite de concepts atomiques A0, A1, ..., An avec A0 = A, An = B et, pour tout i, Ai est subsumé factuellement ou équivalent à Ai+1. Comme les nouvelles règles de subs dans la question 8 transforment les équivalences en subsomptions factuelles et subsS teste l'existence d'un chemin de subsomptions factuelles entre A et B, subsS renverra le bon résultat.
	
	Cela n'est cependant pas le cas si la T-Box contient des subsomptions ou équivalences entre concepts non-atomiques. Par exemple, si on a dans la T-Box
	subs(x, and(y, z)).
	subs(and(z, y), w).
	l'appel à subsS(x, w) échoue, même si x et w sont des concepts atomiques, car, pour qu'il réussisse comme attendu, il faut trouver un moyen de dire à Prolog que and(y, z) et and(z, y) sont la même chose (ce qui est l'objet du prochain exercice).
	
Exercice 3
*/

:- discontiguous subsS/3.
subsS(C, and(D1, D2), L) :- D1 \= D2, subsS(C, D1, L), subsS(C, D2, L).
subsS(C, D, L) :- subs(and(D1, D2), D), E=and(D1, D2), not(member(E, L)), subsS(C, E, [E|L]), E\==C.
subsS(and(C, C), D, L) :- nonvar(C), subsS(C, D, [C|L]).
subsS(and(C1, C2), D, L) :- C1 \= C2, subsS(C1, D, [C1|L]).
subsS(and(C1, C2), D, L) :- C1 \= C2, subsS(C2, D, [C2|L]).
subsS(and(C1, C2), D, L) :- subs(C1, E1), E = and(E1, C2), not(member(E, L)), subsS(E, D, [E|L]), E\==D.
subsS(and(C1, C2), D, L) :- Cinv=and(C2, C1), not(member(Cinv, L)), subsS(Cinv, D, [Cinv|L]).

/*
	1. Voici les résultats des tests :
	
	?- subsS(chihuahua, and(mammifere, some(aMaitre))).
	true .

	?- subsS(and(chien, some(aMaitre)), pet).
	true .

	?- subsS(chihuahua, and(pet, chien)).
	true .

	?- subsS(chihuahua, and(chien, pet)).
	true .

	On remarque ainsi que ces modifications permettent d'obtenir les subsomptions structurelles données dans l'énoncé. Cependant, comme maintenant on a 10 lignes définissant le prédicat subsS/3, une requête peut avoir plusieurs façons différentes d'aboutir. Comme Prolog est exhaustif, si on appuye sur ; après une requête, on peut observer une quantité assez importante de true dans la réponse car il peut y avoir un grand nombre de possibilités d'applications des règles pour y arriver. Par exemple, pour la requête subsS(chihuahua, mammifere), Prolog retourne 50 true. Pour la requête subsS(chihuahua, and(mammifere, some(aMaitre))), Prolog retourne plus de 9000 true avant de terminer. Ainsi, dans les résultats du test ci-dessus, ainsi que dans tous les résultats données dans la suite, on arrêtera la requête dès le premier true obtenue, sans laisser Prolog tester toutes les possibilités exhaustivement.
	
	2.	
	(a) subsS(C, and(D1, D2), L) :- D1 \= D2, subsS(C, D1, L), subsS(C, D2, L).
	Cette règle est importante pour déduire, à partir de:
		a est subsumé structurellement par b
	et
		a est subsumé structurellement par c
	que
		a est subsumé structurellement par (b et c).
	Par exemple, sans cette règle, on a :
	
	?- subsS(lion, and(mammifere, predateur)).
	false.
	
	et, avec la règle,
	
	?- subsS(lion, and(mammifere, predateur)).
	true.
	
	(b) subsS(C, D, L) :- subs(and(D1, D2), D), E=and(D1, D2), not(member(E, L)), subsS(C, E, [E|L]), E\==C.
	Cette règle est importante pour déduire, à partir de :
		(a et b) est subsumé factuellement par c
	et
		y est subsumé structurellement par (a et b)
	que
		y est subsumé structurellement par c.
	Pour tester cette règle, on crée un exemple :
	
	subs(and(a, b), c).
	subs(y, a).
	subs(y, b).

	Sans la règle :
	?- subsS(y, c).
	false.
	
	Avec la règle :
	?- subsS(y, c).
	true .
	
	(c) subsS(and(C, C), D, L) :- nonvar(C), subsS(C, D, [C|L]).
	Cette règle implémente l'identité and(C, C) = C dans le membre de gauche d'une sumbsomption. Elle sert donc à montrer que
		(a et a) est subsumé par b
	à partir de
		a est subsumé par b.
		
	Sans la règle :
	?- subsS(and(predateur, predateur), predateur).
	false.
	
	Avec la règle :
	?- subsS(and(predateur, predateur), predateur).
	true ;
	false.
	
	On remarque que cette règle peut souvent être obtenue à partir des règles (d) et (f) ci-dessous : par exemple, même sans la règle (c), la requête subsS(and(chat, chat), felin) réussit, car elle peut s'unifier avec (f) avec C1 = chat, C2 = chat, D = felin, et la résolution du sécond membre est possible avec E1 = felin, car cela conduira à la requête subsS(and(felin, chat), felin, [...]), qui peut être résolue à l'aide de (d) ou (e).
	
	(d) subsS(and(C1, C2), D, L) :- C1 \= C2, subsS(C1, D, [C1|L]).
	(e) subsS(and(C1, C2), D, L) :- C1 \= C2, subsS(C2, D, [C2|L]).
	
	Cette paire de règles est importante pour déduire, à partir de
		a est subsumé structurellement par b
	que
		(a et c) est subsumé structurellement par b
	et
		(c et a) est subsumé structurellement par b
	pour tout c différent de a.
	Remarquons qu'il suffit d'avoir une seule de ces règles, car l'autre peut en être déduite grâce à (g) ci-dessous, qui implémente la symétrie du and à gauche d'une sumbsomption.
	
	Sans ces deux règles :
	?- subsS(and(animal, predateur), etreVivant).
	false.
	
	Avec une seule des deux règles (mode exhaustif) :
	?- subsS(and(animal, predateur), etreVivant).
	true ;
	true ;
	false.
	
	Avec les deux règles (mode exhaustif) :
	?- subsS(and(animal, predateur), etreVivant).
	true ;
	true ;
	true ;
	true ;
	false.
		
	(f) subsS(and(C1, C2), D, L) :- subs(C1, E1), E = and(E1, C2), not(member(E, L)), subsS(E, D, [E|L]), E\==D.
	Cette règle permet d'obtenir, à partir de
		(e1 et c2) est subsumé structurellement par d
	et
		c1 est subsumé factuellement par e1
	que
		(c1 et c2) est subsumé structurellement par d.
		
	Par exemple, sans la règle :
	?- subsS(and(X, some(aMaitre)), pet).
	X = animal ;
	false.
	
	Avec la règle (les nombreuses réponses identiques sont représentées une seule fois) :
	?- subsS(and(X, some(aMaitre)), pet).
	X = animal ;
	X = chat ;
	X = lion ;
	X = chien ;
	X = canide ;
	X = souris ;
	X = felin ;
	X = mammifere ;
	X = canari ;
	X = and(animal, some(aMaitre)) ;
	X = chihuahua ;
	
	(g) subsS(and(C1, C2), D, L) :- Cinv=and(C2, C1), not(member(Cinv, L)), subsS(Cinv, D, [Cinv|L]).
	Cette règle implémente la symétrie de and dans le membre de gauche de la subsomption. Pour tester cette règle, on crée un exemple :
	subs(and(a, b), c).
	subs(c, d).
	
	Sans la règle :
	?- subsS(and(b, a), d).
	false.
	
	Avec la règle :
	?- subsS(and(b, a), d).
	true ;
	false.
	
	Remarquons que, même sans la règle, subsS(and(b, a), c) marche à cause des autres règles : une unification avec (b) avec C = and(b, a) et D = c peut être traitée avec D1 = a, D2 = b, auquel cas subs(and(a, b), c) est vraie et subs(and(b, a), and(a, b), [...]) peut être montrée par application des règles (a), (d) et (e).
	
	3. Ces règles ne sont pas suffisantes pour gérer toute requête ne contenant que des concepts atomiques ou avec intersections vis-à-vis d'une T-Box ne contenant que des subsomptions entre concepts atomiques ou avec intersections. Par exemple, la requête ci-dessous devrait réussir mais en effet retourne false :
	
	?- subsS(chat, and(felin, felin)).
	false.
	
	En effet, la règle (a) ne prend pas en compte le cas où les deux éléments du and du membre de droite sont égaux.
	
Exercice 4
	1. Voici la règle écrite :
*/

:-discontiguous subs/2.
subs(all(R, C), all(R, D)):-subs(C, D).

/*
	Comme pour la question 10 de l'exercice 2, on pourrait envisager ici de rajouter une règle à la subsomption structurelle subsS/3 à la place de la subsomption factuelle subs/2, par exemple :
	subsS(all(R, C), all(R, D), L):-subsS(C, D, L).
	Cependant, cette règle ne serait pas suffisante pour traiter tous les cas ; par exemple, la requête
	subsS(all(mange, canari), carnivoreExc)
	échouerait, alors qu'elle était censée réussir. Le problème est que, dans les 3 règles de base de subsS/3 définies dans l'exercice 2, la troisième, qui correspond à la transitivité, dit essentiellement que subsS(C, D) réussit lorsqu'on a subs(C, E) et subsS(E, D) ; le premier test est donc une subsomption factuelle. Or, il n'y a pas de subsomption factuelle entre all(mange, canari) et aucun autre concept, expliquant l'échec de la requête. Avec la règle qu'on a utilisée, la requête réussit car on introduit comme subsomption "factuelle" la subsomption subs(all(mange, canari), all(mange, animal)) à partir de la subsomption factuelle subs(canari, animal).
	
	2. Voici les résultats des tests :
	
	?- subsS(lion, all(mange, etreVivant)).
	true ;
	false.

	?- subsS(all(mange, canari), carnivoreExc).
	true ;
	false.
	
	3. Voici les résultats des tests sans rajout de nouvelles règles :
	
	?- subsS(and(carnivoreExc, herbivoreExc), all(mange, nothing)).
	false.

	?- subsS(and(and(carnivoreExc, herbivoreExc), animal), nothing).
	false.
	
	Il faut donc rajouter des règles pour qu'elles réussissent. Pour la première, il faut que Prolog soit capable de reconnaitre la subsomption
	subsS(all(mange, and(animal, plante)), all(mange, nothing))
	à partir de la subsomption
	subsS(and(animal, plante), nothing),
	ainsi que de reconnaitre la subsomption
	subsS(and(carnivoreExc, herbivoreExc), all(mange, and(animal, plante)))
	à partir des subsomptions (en effet, équivalences)
	subsS(carnivoreExc, all(mange, animal))
	et
	subsS(herbivoreExc, all(mange, plante))
	Cela peut être fait avec les règles ci-dessous, qui implémentent l'analogue des deux premières règles de l'exercice 3 pour le cas où l'on a un and à l'intérieur d'un all dans le second membre d'une subsomption.	
*/
subsS(C, all(R, and(D1, D2)), L) :- D1 \= D2, subsS(C, all(R, D1), L), subsS(C, all(R, D2), L).
subsS(C, all(R, D), L) :- subs(and(D1, D2), D), E = all(R, and(D1, D2)), not(member(E, L)), subsS(C, E, [E|L]), E\==C.
/*
	Ces deux règles permettent aussi de traiter la requête subsS(and(and(carnivoreExc, herbivoreExc), animal), nothing), qui désormais réussit, car carnivoreExc et herbivoreExc sont équivalents à des concepts contenant des all qui peuvent être traités par les règles ci-dessus.
	
	Ces règles permettent aussi de traiter la requête
	subsS(and(and(carnivoreExc, animal), herbivoreExc), nothing).
	qui réussit bien. La seule différence entre cette requête et celle précédente est l'ordre des concepts dans les and. Les deux devraient être équivalentes car le and est associatif, mais il est intéressant à noter que l'associativité du and n'a pas été explicitement implémentée par une règle.
	
	4. Cette règle peut être écrite de façon très similaire à celle de la première question :
*/
subs(all(R, I), all(R, C)):-inst(I, C).
/*
	Voici quelques tests :
	
	?- subsS(all(mange, titi), all(mange, canari)).
	true ;
	false.

	?- subsS(all(mange, titi), all(mange, etreVivant)).
	true ;
	false.

	?- subsS(all(aMaitre, pierre), all(aMaitre, humain)).
	true ;
	false.
	
	5. Dans la grammaire de FL-, some ne peut s'appliquer qu'à un rôle atomique, sans possibilité d'intersection de rôles ou d'application du type some(role atomique, concept). Ainsi, pour toute fin pratique, some(role) peut être assimilé à un concept "atomique".
	
	6. Pour subsS(lion, X), on s'attend à :
	- X = lion
	car c'est lui-même
	- X = felin
	- X = carnivoreExc
	car ce sont les deux subsomptions factuelles concernant lion.
	- X = mammifere
	par subsomption factuelle avec felin
	- X = animal
	par subsomption factuelle avec mammifere
	- X = etreVivant
	par subsomption factuelle avec animal
	- X = some(mange)
	par subsomption factuelle avec animal
	- X = predateur
	par subsomption factuelle avec carnivoreExc
	- X = all(mange, animal)
	par équivalence avec carnivoreExc
	- X = all(mange, etreVivant)
	par le fait que animal est subsumé par etreVivant
	- X = all(mange, some(mange))
	par le fait que animal est subsumé par some(mange)
	
	Le résultat du test donne, comme attendu :
	?- subsS(lion, X).
	X = lion ;
	X = felin ;
	X = carnivoreExc ;
	X = mammifere ;
	X = animal ;
	X = etreVivant ;
	X = some(mange) ;
	X = predateur ;
	X = all(mange, animal) ;
	X = all(mange, etreVivant) ;
	X = all(mange, some(mange)) ;
	false.
	
	Pour subsS(X, predateur), on s'attend à :
	- X = predateur
	car c'est lui-même
	- X = carnivoreExc
	par subsomption factuelle
	- X = lion
	par subsomption factuelle avec carnivoreExc
	- X = all(mange, animal)
	par équivalence avec carnivoreExc
	- X = all(mange, mammifere)
	par le fait que mammifere est subsumé factuellement par animal
	- X = all(mange, canari)
	par le fait que canari est subsumé factuellement par animal
	- X = all(mange, souris)
	par le fait que souris est subsumé factuellement par mammifere
	- X = all(mange, felin)
	par le fait que felin est subsumé factuellement par mammifere
	- X = all(mange, canide)
	par le fait que canide est subsumé factuellement par mammifere
	- X = all(mange, chat)
	par le fait que chat est subsumé factuellement par felin
	- X = all(mange, lion)
	par le fait que lion est subsumé factuellement par felin
	- X = all(mange, chien)
	par le fait que chien est subsumé factuellement par canide
	À cause des règles implémentées avec and dans l'Exercice 3, on s'attend à plusieurs autres réponses, comme X = and(lion, carnivoreExc), X = all(mange, and(chien, chat)), etc. Les résultats obtenus sont :
	?- subsS(X, predateur).
	X = predateur ;
	X = carnivoreExc ;
	X = lion ;
	X = all(mange, animal) ;
	X = all(mange, chat) ;
	X = all(mange, lion) ;
	X = all(mange, chien) ;
	X = all(mange, souris) ;
	X = all(mange, felin) ;
	X = all(mange, canide) ;
	X = all(mange, mammifere) ;
	X = all(mange, canari) ;
	et ensuite la requête boucle à cause de l'infinité d'autres résultats possibles.
	
Exercice 5 :
	Cet ensemble n'est pas encore complet pour FL-, car il y a des requêtes qui devraient réussir mais qui échouent, comme celle donnée en exemple à la fin de l'Exercice 3,
	subsS(chat, and(felin, felin)).
	Dans la recherche d'un ensemble de règles complet pour FL-, on a trouvé une implémentation en prolog à l'adresse https://marco.gario.org/work/FL-Subsumption.zip. Cette implémentation utilise une approche différente, basée sur l'idée de réduire d'abord chaque membre d'un test de subsomption structurelle à une forme normale et ensuite tester la subsomption structurelle de ces formes normales.
	
Exercice 6 :
	1. Voici l'implémentation de base du prédicat instS/2 :
*/
instS(I, C):-inst(I, D), subsS(D, C).
/*
	2. Voici les résultats des tests :
	?- instS(felix, mammifere).
	true ;
	false.

	?- instS(princesse, pet).
	true ;
	(plusieurs true avant la terminaison).
	
	On a donc le comportement attendu.
	
	3. On n'a pas encore pris en compte les instantiations de rôles, donc certaines requêtes de la forme instS(I, some(R)) peuvent ne pas marcher : c'est le cas si elles ne sont pas conséquence des instantiations de concepts et des subsomptions de concepts. Par exemple, instS(felix, some(mange)) marche déjà à cause de l'instantiation inst(felix, chat) et du fait que chat est subsumé par some(mange). Cependant, instS(felix, aMaitre) ne marche pas encore. On implémente ainsi la nouvelle règle :
*/
instS(I, some(R)):- instR(I, R, _).
/*
	Avec cette nouvelle règle, les trois requêtes demandées réussissent :
	?- instS(felix, some(mange)).
	true ;

	?- instS(princesse, some(aMaitre)).
	true ;

	?- instS(felix, some(aMaitre)).
	true.
	
	4. (a) Voici l'implémentation de contreExAll :
*/
contreExAll(I, R, C):- instR(I, R, I2), not(instS(I2, C)).
/*
	Quelques tests :
	?- contreExAll(felix, mange, animal).
	false.
	
	felix ne mange que des animaux, la requête échoue car il n'y a pas quelque chose que felix mange qui ne sont pas un animal.
	
	?- contreExAll(felix, mange, canari).
	true ;
	false.
	
	felix ne mange pas que de canari, il mange aussi jerry qui n'est pas un canari. La requête réussit comme attendu.
	
	(b) Voici l'implémentation de instS(I, all(R, C)) :
*/
:-discontiguous instS/2.
instS(I, all(R, C)) :- not(contreExAll(I, R, C)).
/*
	(c) Voici les résultats des tests, qui sont conformes à l'attendu :
	?- instS(felix, all(mange, animal)).
	true.

	?- instS(titi, all(mange, personne)).
	true.

	?- instS(felix, all(mange, mammifere)).
	false.
	
	5. On n'a pas besoin de le faire, les requêtes de la forme subsS(all(R, I), all(R, C)) réussissent déjà lorsque I est une instance structuelle de C. Par exemple,
	subsS(all(mange, felix), all(mange, animal)).
	réussit. En effet, Prolog applique à subsS(all(mange, felix), all(mange, animal)) la troisième règle de subsS/3 (définie après la question 3 de l'exercice 2) et essaie donc les requêtes subs(all(mange, felix), E) et subsS(E, all(mange, animal)). Grâce à notre implémentation de la question 4 de l'exercice 4, la requête subs(all(mange, felix), E) réussit avec E = all(mange, chat), et les autres règles de subsS permettent de conclure.
	
	6. Ces requêtes ne réussissent pas :
	?- instS(felix, pet).
	false.

	?- instS(felix, carnivoreExc).
	false.
	
	Or, les requêtes
	instS(felix, all(mange, animal))
	instS(felix, some(aMaitre))
	instS(felix, animal)
	réussissent, donc il manque à Prolog un moyen de les combiner avec les subsomptions structurelles
	subsS(all(mange, animal), carnivoreExc)
	et
	subsS(and(animal, some(aMaitre)), pet).
	Il faudrait donc implémenter une règle de transitivité similaire à la troisième règle de subsS/3, ainsi qu'une gestion du and.
*/