# -*- coding: utf-8 -*-
"""

Dictionnaires décrivants les transposés et symétries de relations, 
ainsi que les listes de relations obtenues avec les compositions de base
dans le tableau donné en TD

"""

# transpose : dict[str:str]
transpose = {
    '<':'>',
    '>':'<',
    'e':'et',
    's':'st',
    'et':'e',
    'st':'s',
    'd':'dt',
    'm':'mt',
    'dt':'d',
    'mt':'m',
    'o':'ot',
    'ot':'o',
    '=':'='                 
    }

# symetrie : dict[str:str]
symetrie = {
    '<':'>',
    '>':'<',
    'e':'s',
    's':'e',
    'et':'st',
    'st':'et',
    'd':'d',
    'm':'mt',
    'dt':'dt',
    'mt':'m',
    'o':'ot',
    'ot':'o',
    '=':'='
    }            

# compositionBase : dict[tuple[str,str]:set[str]]             
compositionBase = {        
        ('<','<'):{'<'},
        ('<','m'):{'<'},
        ('<','o'):{'<'},
        ('<','et'):{'<'},
        ('<','s'):{'<'},
        ('<','d'):{'<','m','o','s','d'},
        ('<','dt'):{'<'},
        ('<','e'):{'<','m','o','s','d'},
        ('<','st'):{'<'},
        ('<','ot'):{'<','m','o','s','d'},
        ('<','mt'):{'<','m','o','s','d'},
        ('<','>'):{'<','>','m','mt','o','ot','e','et','s','st','d','dt','='},
        ('m','m'):{'<'},
        ('m','o'):{'<'},
        ('m','et'):{'<'},
        ('m','s'):{'m'},
        ('m','d'):{'o','s','d'},
        ('m','dt'):{'<'},
        ('m','e'):{'o','s','d'},
        ('m','st'):{'m'},
        ('m','ot'):{'o','s','d'},
        ('m','mt'):{'e','et','='},
        ('o','o'):{'<','m','o'},
        ('o','et'):{'<','m','o'},
        ('o','s'):{'o'},
        ('o','d'):{'o','s','d'},
        ('o','dt'):{'<','m','o','et','dt'},
        ('o','e'):{'o','s','d'},
        ('o','st'):{'o','et','dt'},
        ('o','ot'):{'o','ot','e','et','d','dt','st','s','='},
        ('s','et'):{'<','m','o'},
        ('s','s'):{'s'},
        ('s','d'):{'d'},
        ('s','dt'):{'<','m','o','et','dt'},
        ('s','e'):{'d'},
        ('s','st'):{'s','st','='},
        ('et','s'):{'o'},
        ('et','d'):{'o','s','d'},
        ('et','dt'):{'dt'},
        ('et','e'):{'e','et','='},
        ('d','d'):{'d'},
        ('d','dt'):{'<','>','m','mt','o','ot','e','et','s','st','d','dt','='},
        ('dt','d'):{'o','ot','e','et','d','dt','st','s','='}
                           
                   }


def transposeSet(S):
    res = set()
    for s in S:
        res.add(transpose[s])
    return res

def symetrieSet(S):
    res = set()
    for s in S:
        res.add(symetrie[s])
    return res

def compose(r1, r2):
    if r1 == '=' and r2 == '=' :
        return {'='}
    if r1 == '=' and r2 != '=' :
        return compose(r2,r2)
    if r1 != '=' and r2 == '=' :
        return compose(r1,r1)
    if (r1, r2) in compositionBase:
        return compositionBase[(r1, r2)]
    r2t = transpose[r2]
    r1t = transpose[r1]
    if (r2t,r1t) in compositionBase :
        return transposeSet(compositionBase[(r2t,r1t)])
    r1s = symetrie[r1]
    r2s = symetrie[r2]
    if (r1s, r2s) in compositionBase:
        return symetrieSet(compositionBase[(r1s, r2s)])
    r2st = transpose[r2s]
    r1st = transpose[r1s]
    if (r2st, r1st) in compositionBase:
        return symetrieSet(transposeSet(compositionBase[r2st,r1st]))
    
def compositionSet(S1, S2):
    res = set()
    for s1 in S1:
        for s2 in S2:
            res.update(compose(s1, s2))
    return res

class Graphe:
    
    def __init__(self, noeuds, rel):
        self.noeuds = noeuds
        self.rel = rel
        
    def getRelations(self, i, j):
        if (i, j) in self.rel:
            return self.rel[i, j]
        if (j, i) in self.rel:
            return transposeSet(self.rel[j, i])
        return set(transpose.keys)
    
    def propagation (self, n1, n2):
        pile = [{(n1, n2): self.getRelations(n1, n2)}]
        
        while pile != []:
            Rij = pile.pop
            i, j = list(Rij.keys())[0]
            for k in self.noeuds.difference({i, j}):
                
                ik = self.getRelations(i, k)
                Rik = (i, k, ik)
                
                
    
    
    
    
    
    
    
    
