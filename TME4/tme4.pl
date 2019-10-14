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


subs(lion,carnivoreExc).
subs(carnivoreExc,predateur).
equiv(carnivoreExc,all(mange,animal)).
equiv(carnivoreExc,all(mange,plante)).

subs(chihuahua,pet).
subs(chihuahua,chien).

inst(felix,chat).
inst(pierre,humain).
instR(felix,aMaitre,pierre).
inst(princesse,chihuahua).
inst(marie,humain).
instR(princesse,aMaitre,marie).
inst(jerry,souris).
inst(titi,canari).
instR(felix,mange,jerry).
instR(felix,mange,titi).

subsS1(C,C).
subsS1(C,D):-subs(C,D),C\==D.
subsS1(C,D):-subs(C,E),subsS1(E,D).

subsS(C,D):-subsS(C,D,[C]).
subsS(C,C,_).
subsS(C,D,_):-subs(C,D),C\==D.
subsS(C,D,L):-subs(C,E),not(member(E,L)),subsS(E,D,[E|L]),E\==D.


