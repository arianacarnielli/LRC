module TME7ashuits

where
import Data.List
import DEMO_S5

-- Toutes les donnes possibles
allHands = [("AA", "AA", "88"), ("AA", "A8", "A8"), ("AA", "A8", "88"), ("AA", "88", "AA"), ("AA", "88", "A8"), ("AA", "88", "88"), ("A8", "AA", "A8"), ("A8", "AA", "88"), ("A8", "A8", "AA"), ("A8", "A8", "A8"), ("A8", "A8", "88"), ("A8", "88", "AA"), ("A8", "88", "A8"), ("88", "AA", "AA"), ("88", "AA", "A8"), ("88", "AA", "88"), ("88", "A8", "AA"), ("88", "A8", "A8"), ("88", "88", "AA")]

-- Relations des trois agents
rela = (a, [[("88", "AA", "AA")], [("A8", "AA", "A8"), ("88", "AA", "A8")], [("AA", "AA", "88"), ("A8", "AA", "88"), ("88", "AA", "88")], [("A8", "A8", "AA"), ("88", "A8", "AA")], [("AA", "A8", "A8"), ("A8", "A8", "A8"), ("88", "A8", "A8")], [("AA", "A8", "88"), ("A8", "A8", "88")], [("AA", "88", "AA"), ("A8", "88", "AA"), ("88", "88", "AA")], [("AA", "88", "A8"), ("A8", "88", "A8")], [("AA", "88", "88")]])

relb = (b, [[("AA", "88", "AA")], [("AA", "A8", "A8"), ("AA", "88", "A8")], [("AA", "AA", "88"), ("AA", "A8", "88"), ("AA", "88", "88")], [("A8", "A8", "AA"), ("A8", "88", "AA")], [("A8", "AA", "A8"), ("A8", "A8", "A8"), ("A8", "88", "A8")], [("A8", "AA", "88"), ("A8", "A8", "88")], [("88", "AA", "AA"), ("88", "A8", "AA"), ("88", "88", "AA")], [("88", "AA", "A8"), ("88", "A8", "A8")], [("88", "AA", "88")]])

relc = (c, [[("AA", "AA", "88")], [("AA", "A8", "A8"), ("AA", "A8", "88")], [("AA", "88", "AA"), ("AA", "88", "A8"), ("AA", "88", "88")], [("A8", "AA", "A8"), ("A8", "AA", "88")], [("A8", "A8", "AA"), ("A8", "A8", "A8"), ("A8", "A8", "88")], [("A8", "88", "AA"), ("A8", "88", "A8")], [("88", "AA", "AA"), ("88", "AA", "A8"), ("88", "AA", "88")], [("88", "A8", "AA"), ("88", "A8", "A8")], [("88", "88", "AA")]])

rels = [rela,relb,relc]

-- Construction du modèle
model0 :: EpistM (String,String,String)
model0 = Mo allHands [a,b,c] [] rels []

-- Relations d'avoir une paire de cartes donnée pour chaque agent
holds_a_AA = Disj [Info("AA","AA","88"), Info("AA","A8","A8"), Info("AA","A8","88"), Info("AA","88","AA"), Info("AA","88","A8"), Info("AA","88","88")]
holds_a_A8 = Disj [Info("A8","AA","A8"), Info("A8","AA","88"), Info("A8","A8","AA"), Info("A8","A8","A8"), Info("A8","A8","88"), Info("A8","88","AA"), Info("A8","88","A8")]
holds_a_88 = Disj [Info("88","AA","AA"), Info("88","AA","A8"), Info("88","AA","88"), Info("88","A8","AA"), Info("88","A8","A8"), Info("88","88","AA")]
holds_b_AA = Disj [Info("AA","AA","88"), Info("A8","AA","A8"), Info("A8","AA","88"), Info("88","AA","AA"), Info("88","AA","A8"), Info("88","AA","88")]
holds_b_A8 = Disj [Info("AA","A8","A8"), Info("AA","A8","88"), Info("A8","A8","AA"), Info("A8","A8","A8"), Info("A8","A8","88"), Info("88","A8","AA"), Info("88","A8","A8")]
holds_b_88 = Disj [Info("AA","88","AA"), Info("AA","88","A8"), Info("AA","88","88"), Info("A8","88","AA"), Info("A8","88","A8"), Info("88","88","AA")]
holds_c_AA = Disj [Info("AA","88","AA"), Info("A8","A8","AA"), Info("A8","88","AA"), Info("88","AA","AA"), Info("88","A8","AA"), Info("88","88","AA")]
holds_c_A8 = Disj [Info("AA","A8","A8"), Info("AA","88","A8"), Info("A8","AA","A8"), Info("A8","A8","A8"), Info("A8","88","A8"), Info("88","AA","A8"), Info("88","A8","A8")]
holds_c_88 = Disj [Info("AA","AA","88"), Info("AA","A8","88"), Info("AA","88","88"), Info("A8","AA","88"), Info("A8","A8","88"), Info("88","AA","88")]

-- Analyse des parties jouées
-- Partie 1
partie1m1 = upd_pa model0 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
partie1m2 = upd_pa partie1m1 (Ng (Disj [(Kn b holds_b_AA), (Kn b holds_b_A8), (Kn b holds_b_88)]))
partie1m3 = upd_pa partie1m2 (Ng (Disj [(Kn c holds_c_AA), (Kn c holds_c_A8), (Kn c holds_c_88)]))
partie1m4 = upd_pa partie1m3 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
-- Le joueur 2 sait désormais qu'il a A8

-- Partie 2
partie2m1 = upd_pa model0 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
partie2m2 = upd_pa partie2m1 (Ng (Disj [(Kn b holds_b_AA), (Kn b holds_b_A8), (Kn b holds_b_88)]))
partie2m3 = upd_pa partie2m2 (Ng (Disj [(Kn c holds_c_AA), (Kn c holds_c_A8), (Kn c holds_c_88)]))
partie2m4 = upd_pa partie2m3 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
-- Le joueur 2 sait désormais qu'il a A8

-- Partie 3
-- Le joueur 1 sait dès le début qu'il a 88

-- Partie 4
partie4m1 = upd_pa model0 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
partie4m2 = upd_pa partie4m1 (Ng (Disj [(Kn b holds_b_AA), (Kn b holds_b_A8), (Kn b holds_b_88)]))
partie4m3 = upd_pa partie4m2 (Ng (Disj [(Kn c holds_c_AA), (Kn c holds_c_A8), (Kn c holds_c_88)]))
partie4m4 = upd_pa partie4m3 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
-- Le joueur 2 sait désormais qu'il a A8

-- Partie 5
partie5m1 = upd_pa model0 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
partie5m2 = upd_pa partie5m1 (Ng (Disj [(Kn b holds_b_AA), (Kn b holds_b_A8), (Kn b holds_b_88)]))
partie5m3 = upd_pa partie5m2 (Ng (Disj [(Kn c holds_c_AA), (Kn c holds_c_A8), (Kn c holds_c_88)]))
-- Le joueur 1 sait désormais qu'il a A8

-- Partie 6
partie6m1 = upd_pa model0 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
partie6m2 = upd_pa partie6m1 (Ng (Disj [(Kn b holds_b_AA), (Kn b holds_b_A8), (Kn b holds_b_88)]))
-- Le joueur 3 sait désormais qu'il a A8

-- Partie 7
partie7m1 = upd_pa model0 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
partie7m2 = upd_pa partie7m1 (Ng (Disj [(Kn b holds_b_AA), (Kn b holds_b_A8), (Kn b holds_b_88)]))
partie7m3 = upd_pa partie7m2 (Ng (Disj [(Kn c holds_c_AA), (Kn c holds_c_A8), (Kn c holds_c_88)]))
-- Le joueur 1 sait désormais qu'il a A8

-- Partie 8
partie8m1 = upd_pa model0 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
-- Le joueur 2 sait désormais qu'il a AA

-- Partie 9
partie9m1 = upd_pa model0 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
partie9m2 = upd_pa partie9m1 (Ng (Disj [(Kn b holds_b_AA), (Kn b holds_b_A8), (Kn b holds_b_88)]))
partie9m3 = upd_pa partie9m2 (Ng (Disj [(Kn c holds_c_AA), (Kn c holds_c_A8), (Kn c holds_c_88)]))
-- Le joueur 1 sait désormais qu'il a A8

-- Partie 10
partie10m1 = upd_pa model0 (Ng (Disj [(Kn a holds_a_AA), (Kn a holds_a_A8), (Kn a holds_a_88)]))
partie10m2 = upd_pa partie10m1 (Ng (Disj [(Kn b holds_b_AA), (Kn b holds_b_A8), (Kn b holds_b_88)]))
-- Le joueur 3 sait désormais qu'il a A8