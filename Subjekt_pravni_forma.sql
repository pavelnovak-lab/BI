SELECT	 count(p."Registraèní èíslo projektu") ,
	 -- p.zadatel ,
	 v."Èíslo výzvy",
	 v."Název výzvy",
	 max(CASE WHEN  polozka."Investice" = 0 THEN 1
	 END ) AS neinv,
 	 max(CASE WHEN  polozka."Investice" = 1 THEN 1
	 END ) AS inv,


     	 -- p.kodwfstav ,
       	 cis."Název" AS "Právní forma ¾adatele" 
	 -- sum(pzf."Národní veøejné zdroje")
	 -- listagg(DISTINCT ci."Kód", '; ') as "Zdroje fin. na výzvì"
	 -- pf.*
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_umzprjggvs vs ON p.id_zadatel = vs.id AND vs.id_typsubjektu = 300784 -- ¾adatel pøíjemce
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_hosppravforma
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMZVyzvaMD md ON md.id_vyzva= v.id  AND md."Platnost" = 'A' -- AND md.id_cisseznam = 198427 -- skupina rozpoètu
INNER JOIN isum.v_bi_UMFROZSkupina sr ON sr.id = md.id_ciszakladni
INNER JOIN isum.v_bi_UMFROZSkupinaPol polozka ON polozka.id_predpis = sr.id  

-- INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 
-- INNER JOIN isum.v_bi_UMFPFCelkem pf ON pf.id_projekt = p.id AND pf.id_faze=99991000000000005
-- INNER JOIN isum.v_bi_UMZRadekSabDP sabdp ON sabdp.id_nositelsablony = v.id
-- INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = sabdp.id_zdrojfin 

WHERE p."Registraèní èíslo projektu" is not null 
-- AND cis."Název" in ('Nadace','Nadaèní fond','Státní podnik','Národní podnik','Èeská národní banka','Organizaèní slo¾ka státu','Stálý rozhodèí soud','Pøíspìvková organizace zøízená územním samosprávným celkem','Státní pøíspìvková organizace ze zákona','Státní pøíspìvková organizace ostatní','Správa ¾eleznic, státní organizace','Rada pro veøejný dohled nad auditem','Veøejnoprávní instituce','Èeská tisková kanceláø','Státní fond ze zákona','Státní fond ze zákona nezapisující se do obchodního rejstøíku','Zdravotní poji¹»ovna (mimo VZP)','V¹eobecná zdravotní poji¹»ovna','Vysoká ¹kola (veøejná, státní)','©kolská právnická osoba','Veøejná výzkumná instituce','Obec','Kraj','Regionální rada regionu soudr¾nosti','Mìstská èást hlavního mìsta Prahy')
-- AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP2O','PP21','PP22','PP23a','PP23b','V5','PP27a','PP27b','PP29')  
-- AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/19_299/0023798'
-- AND pzf."Národní veøejné zdroje" > 0
AND p.kodwfstav not like 'PN%'
-- and p.id_vyzva = 1607294465
AND v."Èíslo výzvy" IN ('31_24_152','31_23_100','31_23_098','31_23_080','31_23_079','31_23_117','31_23_085','31_23_082','31_23_078')

GROUP BY v."Èíslo výzvy",
	 v."Název výzvy",
     	 -- p.kodwfstav ,
       	 cis."Název"

ORDER BY v."Èíslo výzvy"






----------------------------------------


SELECT p."Registraèní èíslo projektu",
       SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
       substr(p."Registraèní èíslo projektu",-5,5) "Projekt" ,
       p.zadatel,
       p."Název projektu CZ",
       v."Èíslo výzvy",
       -- v."Název výzvy" ,
       platba."Datum proplacení pøíjemci",
       platba."Èíslo ¾ádosti o platbu" ,
       -- ci."Název" ,
       sr."Kód" "Kód SR",
       eds."Identifikaèní èíslo akce" 
       -- pol.*


FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id = p.id_vyzva 
INNER JOIN isum.v_bi_UMZVyzvaMD md ON md.id_vyzva= v.id  AND md."Platnost" = 'A' -- AND md.id_cisseznam = 198427 -- skupina rozpoètu
INNER JOIN isum.v_bi_UMFROZSkupina sr ON sr.id = md.id_ciszakladni
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby 
INNER JOIN (
      SELECT max("Identifikaèní èíslo akce") "Identifikaèní èíslo akce",
      	     id_nositelispeproj
      FROM isum.v_bi_UMZISPeProjekt
      -- WHERE id_nositelispeproj = 1210316800
      GROUP BY id_nositelispeproj ) eds ON eds.id_nositelispeproj = p.id
      


WHERE  p.kodwfstav in ('PP37','PP40','PP41','PP42','PP43','PU30')
   AND v."Èíslo výzvy" = '01_20_370'
AND EXISTS
(SELECT 1
 FROM isum.v_bi_UMFROZSkupinaPol polozka
 WHERE polozka."Investice" = 0
 AND polozka.id_predpis = sr.id)
AND to_date('2021-12-31','yyyy-mm-dd') < platba."Datum proplacení pøíjemci"
AND platba."Datum proplacení pøíjemci" < to_date('2023-01-01','yyyy-mm-dd')  
AND platba.kodwfstav in ('P10','P11')
