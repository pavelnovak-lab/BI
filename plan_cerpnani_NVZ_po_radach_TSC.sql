SELECT  substr(p."Registraèní èíslo projektu",4,4) "Kod PO",
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	platba."Datum pøedlo¾ení" as "Datum pøedlo¾ení",
	v."Název výzvy" as "Název výzvy",
	p."Registraèní èíslo projektu" as "Registraèní èíslo projektu",
	p."ZADATEL" as "ZADATEL",
	platba."PORADI#Poøadí finanèního plánu" as "PORADI#Poøadí finanèního plánu",
	platba."WFSTAV" as "Stav ®opl",
	p."KODWFSTAV" as "KODWFSTAV",
	platba.kurz,
	p."WFSTAV" as "Stav projektu",
	platba."Èíslo ¾ádosti o platbu",
        fp."Celkové zpùsobilé výdaje" "CZV" ,
        fp."Pøíspìvek Unie" "Dotace",
	platba."Závìreèná platba" as "Závìreèná platba",
	platba.id,
	platba."Datum navrácení",
	prvni."datum prvního stavu P4",
	platba.DATUMVYTVORENI "Datum vytvoøení"


FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmfPFCelkem fp ON fp.id_projekt = p.ID
LEFT JOIN
(select hi.nositelid,
	min(hi.datumod) as "datum prvního stavu P4"
from isum.v_bi_umswfhistoriestavu hi
where hi.stavdo = 'P4'
group by hi.nositelid) prvni on prvni.nositelid= platba.id -- platba.id



WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND p."Registraèní èíslo projektu" is not null 
AND fp.ID_FAZE=99991000000000005 -- sloupec aktuální stav 
AND platba.SOUCTOVYRADEK IS NULL

--------------------------------------------

SELECT rf.id_platba,
       sum(case when rf.id_ukazatel = 361347 then rf.castkaschvalena end) as "CZV Schválené",
       sum(case when rf.id_ukazatel = 361356 then rf.castkaschvalena end) as "Dotace schválená",
       sum(case when rf.id_ukazatel in ('361360','361362','361364','361366','361368') then rf.castkaschvalena end) as "NVZ"
       -- nvl(platba.kurz, 0) "Kurz",
       -- nvl(platba.kurz * sum(case when rf.id_ukazatel = 361347 then rf.castkaschvalena end), 0) AS "CZV scvhálené EUR",
       -- nvl(platba.kurz * sum(case when rf.id_ukazatel = 361356 then rf.castkaschvalena end), 0) AS "Dotace scvhálené EUR"


FROM isum.v_bi_UmpPlatbaPrj platba 
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id 
-- LEFT JOIN
-- (select hi.nositelid,
-- 	min(hi.datumod) as "datum prvního stavu P4"
-- from isum.v_bi_umswfhistoriestavu hi
-- where hi.stavdo = 'P4'
-- group by hi.nositelid) prvni on prvni.nositelid= rf.id_platba -- platba.id

-- WHERE rf.id_platba = 1115368349    

GROUP BY rf.id_platba
--------------------------------------------

kurz * "CZV Schválené"

