 SELECT p."Registraèní èíslo projektu" ,
       p."KODPRIORITNIOSA" ,
       p."KODINVESTPRIORITA" ,
       p."KODSPECIFCIL" ,
       SUBSTR(p.kompetencniutvar, 6) AS kompetencniutvar ,
       p.wfstav,
       p.kodwfstav ,
       p."WFSTAVDATUM",
       p.zadatel,
       p."ZADATELPFORMA" ,
       p."IÈ" ,
       p."VELIKOSTPODNIKU",
       v."Èíslo výzvy",
       druhy.bodykrit "Výrok analytika" ,
       p."Datum zahájení pøedp",
       p."Datum ukonèení pøedp",
       p."Doba trvání projektu (mìs)",
       vs."Poèet zamìstnancù",
       vs."Roèní obrat (EUR)",
       nvl(zo."Poèet ®oZ", 0) "Poèet ®oZ",
       LISTAGG(ci."Název", '; ') AS "Rizikový tag"	
              
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null  AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798  -- zadatel
LEFT JOIN (
     SELECT krit.pocetbodu bodykrit ,
     	    h.pocetbodu,
     	    h.id_noshodnoceni
     FROM  isum.v_bi_UmvHodnoceni h
     INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = h.id 
     WHERE h.id_kolohodnoceni=171212  /* hodnocení plné ¾ádosti */
     AND h.id_KrokVecHodn = 171213  /* 1. krok VH */
     AND h.platnost = 'A'
     AND h.OpravneHodnoceni = 'N'
     AND h.finalizovano = 'A'
     AND krit.Kod = '02'
     AND h.ID_SOUBORKRIT in (144202634, 166127531, 327137413, 503513958, 25794051, 167459019, 144365005, 1342551, 1026936198, 488253932, 503467634, 344009106, 488346771, 843495401) ) druhy ON druhy.id_noshodnoceni = p.id
LEFT JOIN isum.v_bi_UMZPrjGGTag tag ON p.id = tag.id_prjgg
LEFT JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = tag.id_tag AND ci."Název" in ('Odstoupeni od proj.','Pøedán k ukonèení ØO','Proj. nerealizovan','Nereaguje','Proj pozastaven','Odnìtí dotace','Riziko prj. obecne','©etøení PÈR','insolvence','Neplnìní INDI','nesrovnalost','Nález AO','Chyba udr¾itelnost')
LEFT JOIN 
(SELECT max(z."Poøadové èíslo ®oZ") AS "Poèet ®oZ",
	z.id_zad
        FROM isum.v_bi_UmzZoZProjekt z
	GROUP BY z.id_zad) zo ON zo.id_zad = p.id 


WHERE p."Registraèní èíslo projektu" is not null 
-- p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_037/0007170'
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4', '01.5')
AND p."IÈ" = vs."IÈ"


GROUP BY p."Registraèní èíslo projektu" ,
       p."KODPRIORITNIOSA" ,
       p."KODINVESTPRIORITA" ,
       p."KODSPECIFCIL" ,
       SUBSTR(p.kompetencniutvar, 6), -- p.kompetencniutvar, 	 
       p.wfstav,
       p.kodwfstav ,
       p."WFSTAVDATUM",
       p.zadatel,
       p."ZADATELPFORMA" ,
       p."IÈ" ,
       p."VELIKOSTPODNIKU",
       v."Èíslo výzvy",
       druhy.bodykrit  ,
       p."Datum zahájení pøedp",
       p."Datum ukonèení pøedp",
       p."Doba trvání projektu (mìs)",
       vs."Poèet zamìstnancù",
       vs."Roèní obrat (EUR)",
       zo."Poèet ®oZ"

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC

SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" 
