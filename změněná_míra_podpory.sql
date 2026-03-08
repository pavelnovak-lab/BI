SELECT p."Registraèní èíslo projektu" ,
       p.kodwfstav,
       pzf.PROC_EU "Míra podpory aktuální stav" ,
       pzf."Pøíspìvek Unie" "Dotace aktuíální stav" ,
       pzf."Celkové zpùsobilé výdaje" "CZV aktuální",
       zoz.CZV "CZV RoPD",
       zoz."Zmìnìné procento" "Míra podpory, RoPD",
       zoz."Zmìnìný pøíspìvek EU" "Dotace RoPD",
       sum(rf.CASTKASCHVALENA) "Proplacená dotace" 

 
       -- pp."Zmìnìné procento" "Míra podpory pøi podání ®oPo",
       -- pp."Zmìnìný pøíspìvek EU" "EU podíl pøi podání ®oPo"
       

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav
INNER JOIN (
 SELECT pzf.id_projekt,
 	pzf.PROC_EU "Zmìnìné procento",
	pzf."Pøíspìvek Unie" "Zmìnìný pøíspìvek EU",
	pzf."Celkové zpùsobilé výdaje" "CZV"
 FROM isum.v_bi_UMFPFCelkem pzf
 WHERE pzf.id_faze = 99991000000000011 -- právní akt
) zoz ON zoz.id_projekt = p.id 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
LEFT JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id  AND rf.id_ukazatel in (361356 ) -- øádky cis. vý¾



WHERE
--p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/17_109/0012057'
-- AND
pzf.PROC_EU <> zoz."Zmìnìné procento"
    
GROUP BY p."Registraèní èíslo projektu" ,
       p.kodwfstav,
       pzf.PROC_EU ,
       pzf."Pøíspìvek Unie"  ,
       zoz."Zmìnìné procento" ,
       zoz."Zmìnìný pøíspìvek EU" ,
pzf."Celkové zpùsobilé výdaje",
zoz.CZV
