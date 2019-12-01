# -*- coding: utf-8 -*-
"""
Created on Sat Nov 30 23:37:04 2019

@author: arian
"""

import itertools

possibilites = ["AA", "A8", "88"]
donne = itertools.product(possibilites, repeat = 3)
donnePossible = set()
for d1, d2, d3 in donne:
    if (d1+d2+d3).count("A") <= 4 and (d1+d2+d3).count("8") <= 4:
        donnePossible.add((d1, d2, d3))
        
#rela = []
#for i1 in range(len(donnePossible)):
#    d1 = donnePossible[i1]
#    rela.append([d1])
#    for i2 in range(i1+1, len(donnePossible)):
#        d2 = donnePossible[i2]
#        if d1[1]==d2[1] and d1[2]==d2[2]:
#            rela.append([d1, d2])
#            
#relb = []
#for i1 in range(len(donnePossible)):
#    d1 = donnePossible[i1]
#    relb.append([d1])
#    for i2 in range(i1+1, len(donnePossible)):
#        d2 = donnePossible[i2]
#        if d1[0]==d2[0] and d1[2]==d2[2]:
#            relb.append([d1, d2])
#            
#relc = []
#for i1 in range(len(donnePossible)):
#    d1 = donnePossible[i1]
#    relc.append([d1])
#    for i2 in range(i1+1, len(donnePossible)):
#        d2 = donnePossible[i2]
#        if d1[0]==d2[0] and d1[1]==d2[1]:
#            relc.append([d1, d2])

rela = []
for d1 in possibilites:
    for d2 in possibilites:
        rela.append([])
        for d0 in possibilites:
            if (d0, d1, d2) in donnePossible:
                rela[-1].append((d0, d1, d2))

relb = []
for d0 in possibilites:
    for d2 in possibilites:
        relb.append([])
        for d1 in possibilites:
            if (d0, d1, d2) in donnePossible:
                relb[-1].append((d0, d1, d2))
                
relc = []
for d0 in possibilites:
    for d1 in possibilites:
        relc.append([])
        for d2 in possibilites:
            if (d0, d1, d2) in donnePossible:
                relc[-1].append((d0, d1, d2))
        
print("rela = (a, [",end="")
for r in rela:
    print("[", end="")
    for d0, d1, d2 in r:
        print('("{}", "{}", "{}"), '.format(d0, d1, d2), end="")
    print("\b\b], ", end="")
print("\b\b])")
    
print("relb = (b, [",end="")
for r in relb:
    print("[", end="")
    for d0, d1, d2 in r:
        print('("{}", "{}", "{}"), '.format(d0, d1, d2), end="")
    print("\b\b], ", end="")
print("\b\b])")
    
print("relc = (c, [",end="")
for r in relc:
    print("[", end="")
    for d0, d1, d2 in r:
        print('("{}", "{}", "{}"), '.format(d0, d1, d2), end="")
    print("\b\b], ", end="")
print("\b\b])")
        
holds = dict()
for i, j in enumerate(['a', 'b', 'c']):
    holds[j] = dict()
    for c in possibilites:
        holds[j][c] = []
        for d in donnePossible:
            if d[i]==c:
                holds[j][c].append(d)
                
for j in holds:
    for c in holds[j]:
        print("holds_{}_{} = Disj [".format(j, c), end="")
        for i in range(len(holds[j][c])):
            d = holds[j][c][i]
            if i==0:
                print("Info(\"{}\",\"{}\",\"{}\")".format(d[0], d[1], d[2]), end="")
            else:
                print(", Info(\"{}\",\"{}\",\"{}\")".format(d[0], d[1], d[2]), end="")
        print("]")
        