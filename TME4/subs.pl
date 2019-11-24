/*
  Atomic Concepts/Roles :  c
  Conjunction and(C1,C2)
  Existential some(R)
  Universal all(R,C)
 */


% subs( and( all(child, adult), some(child)), all(child, adult)). OK
% subs( and( all(child, adult), some(child)), all(child, man)). Fail

/* subs(C,D) 
   True if C subs D
*/

subs(C,D):- once(lsubs(C,D)).
lsubs(C,D):-normalize(C,C1),normalize(D,D1),r_subs(C1,D1).

/* normalize(C,Cn)
   Builds the normalized version of C
   - Replace aliases,
   - Flattens the and,
   - Factorizes the Universals
*/   


% normalize(and( all(child, man), and(some(child),all(child,adult))) , C). % ex. w/o aliases
% define(men,and(human,male)),normalize(and( all(child, men), and(some(child),all(child,adult))) , C). % ex. w 'men'

normalize(C,Cn):-remove_aliases(C,C1),flatten(C1,C2),mklist(C2,C3),factorize(C3,Cn).



% flatten/2
%
% flatten( and( all(child, adult), some(child)), X).
% flatten(and(all(child,and(adult, man)),some(child)), X).
% flatten( and( and(man, adult), some(child)), X).

flatten(all(R,Cx),C):- flatten(Cx,X1),C=all(R,X1).  
flatten(and(C1,C2),C):- flatten(C1,X1),flatten(C2,X2),concat([X1],[X2],C).
flatten(some(R),some(R)):-atom(R).
flatten(C,[C]):- atom(C).

% factorize/2
%
% factorize([all(r,c1),all(r,c2)],X).
% factorize([all(r,all(r2,c2)),all(r,all(r2,c))],N).

factorize(IN,OUT):-sort_concept(IN,T),factorize_(T,OUT).


factorize_([],[]).
factorize_([X],[X]).
factorize_([C1,C2|Xs],New):-factorize_terms(C1,C2,X3),factorize([X3|Xs],New).
factorize_([C1,C2|Xs],[C1|Out]):- not(factorize_terms(C1,C2,_)), factorize([C2|Xs],Out).
factorize_terms(all(R,C1),all(R,C2),all(R,Out)):- concat([C1],[C2],C3),factorize(C3,Out).


r_subs(_,[]).
r_subs(C,[Di|Ds]):-r_subs_i(C,Di),r_subs(C,Ds).

% Given C=[...] and Di a concept

%Case 1: Di=a or Di= E.R
r_subs_i(C,Di):-atom(Di),find(Di,C). 
r_subs_i(C,Di):-C=some(_),find(Di,C). 
%Case 2: 
r_subs_i(C,all(R,Di)):-get_role_concept(C,R,Cj),mklist(Cj,Cj_),mklist(Di,Di_),r_subs(Cj_,Di_).

% get_role_concept(C,R,Cj): returns Cj being the concept of all(R,Cj) if all(R,Cj) is in C.
% get_role_concept([a,all(r1,c1)],r1,Cj).

get_role_concept([all(R,COut)|_],R,COut).
get_role_concept([_|Xs],R,COut):-get_role_concept(Xs,R,COut).

% define/2 
% define(ComplexConcept, ComplexExpression)
:-dynamic alias/2.
define(CC,CE):-atom(CC), concept(CE), assert(alias(CC,CE)).

listdefine:-listing(alias).

% Example define
% define(men,and(human,male)).
% define(parent,some(child)).
% define(father,and(parent,men)).
%

% remove_aliases/2
% substituite aliases in the formula and all subformulas

remove_aliases(all(R,C),W):-remove_aliases(C,C1),W=all(R,C1).
remove_aliases(and(A,B),W):-remove_aliases(A,A1),remove_aliases(B,B1),W=and(A1,B1).
remove_aliases(some(R),some(R)).
remove_aliases(X,W):-alias(X,Y),remove_aliases(Y,W), !. %cut-brrr
remove_aliases(X,W):-alias(X,W).
remove_aliases(X,X):-atom(X),not(alias(X,_)).


% concept(X) Specifies the valid concepts in FL-

concept(X):- atom(X).
concept(some(_)).
concept(all(_,_)).
concept(and(_,_)).

% Helper functions

% mklist(+Term,-List) Return [Term] if Term is not already a list

mklist(X,[X]):-concept(X).
mklist(X,X).

find(C,[C|_]).
find(C,[_|Xs]):-find(C,Xs).


/* 
 concat(+List1,+List2,-ListOut)
	Concatenates List1 and List2 by always mantaining only 
	 1 level of nesting of lists, ie [a,[b]] -> [a,b]
*/
flatlist([ ],[ ]).
flatlist([H|T],[H|U]) :- concept(H), flatlist(T,U).
flatlist([H|T],R) :- flatlist(H,A), flatlist(T,B),concat(A,B,R).

concat(A,B,ListOUT):-concat_(A,B,List_), flatlist(List_,ListOUT).
concat_([],List,List).
concat_([A|L1],L2,[A|L3]) :- concat_(L1,L2,L3).




/* 
  sort_concept(+ConceptList, -OrderedConceptList)
	Concepts are ordered by the rules defined in bigger/2
  
*/
sort_concept(IN,OUT):-insert_sort(IN,OUT).

insert_sort(IN,OUT):-i_sort(IN,[],OUT).
i_sort([],OUT,OUT).
i_sort([H|T],Acc,OUT):-insert(H,Acc,Temp),i_sort(T,Temp,OUT).


insert(X,[Y|T],[Y|NT]):-bigger(X,Y),insert(X,T,NT).
insert(X,[Y|T],[X,Y|T]):- not(bigger(X,Y)).
insert(X,[],[X]).

% bigger(+X,+Y) X>Y 

bigger(X,_):-atom(X).
bigger(some(_),all(_,_)).
bigger(all(R1,_),all(R2,_)):-R2 @< R1.


/*
  TestUnit
*/

:- begin_tests(subs).
test(bigger) :- bigger(b,a),bigger(a,some(c)),bigger(some(c),all(r,c)),bigger(all(r2,c),all(r1,c)).

test(sort_concept, [nondet] ):- sort_concept([a,some(r),all(r1,c),all(r2,c)],[all(r1, c), all(r2, c), some(r), a]),
				sort_concept([a,some(r),all(r1,c),all(r1,c)],[all(r1, c), all(r1, c), some(r), a]),
				sort_concept([a,some(r),all(r1,c),all(r1,c),b],[all(r1, c), all(r1, c), some(r), a, b]).				

test(concat, [nondet]):- 	concat([a],[b],[a,b]),
				concat([[a]],[b],[a,b]),
				concat([a],[[b]],[a,b]),
				concat([a,[b]],[],[a,b]).

test(concept):-	concept(c), concept(r),
		concept(some(r)), concept(all(r,c)),
		not(concept([c])).



test(flatten, [nondet]):- flatten( and( all(child, adult), some(child)), [all(child, [adult]), some(child)]),
			  flatten(and(all(child,and(adult, man)),some(child)), [all(child, [adult, man]), some(child)]),
			  flatten( and( and(man, adult), some(child)), [man, adult, some(child)]).


test(factorize, [nondet]):- factorize([all(r,c1),all(r,c2)],[all(r, [c2, c1])] ),
			    factorize([all(r,all(r2,c2)),all(r,all(r2,c))],[all(r, [all(r2, [c2, c])])]).

test(remove_aliases) :- define(parent,some(child)),
			define(father,and(parent,men)),
			define(men,and(human,male)),
			remove_aliases(father,and(some(child), and(human, male))).

test(normalize,[nondet]) :- 	define(men,and(human,male)),
			 	normalize(and( all(child, man), and(some(child),all(child,adult))) , [all(child, [adult, man]), some(child)]).

	
test(subs1):- 	subs( and( all(child, adult), some(child)), all(child, adult)).
test(subs2):-	subs( and( adult, male) , adult  ).
test(subs3):-	subs( and( adult, and(male, rich)), and( adult, male) ).
test(subs4):-	subs( all(child,and(adult, male)), all(child, adult) ).
test(subs5):-	\+ subs( all(child,adult) , some(child) ).
test(subs6):-	\+ subs( some(child), all(child, adult)).
test(subs7):-	\+ subs( and( all(child, adult), some(child)), all(child, man)).

:- end_tests(subs).


%:- use_module(library(test_cover)).
%:- show_coverage(run_tests). %Note: this is an experimental module. %Fail is a static analysis of failure of the tests
:-run_tests.



