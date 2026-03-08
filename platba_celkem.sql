SELECT p."Registraèní èíslo projektu" ,
       faze.nazev "Sloupec PZF",
       pzf."Celkové zpùsobilé výdaje",
       pzf.id_platba

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id
INNER JOIN isum.V_BI_UMFPFFaze faze ON faze.id =  pzf.id_faze

WHERE p."Registraèní èíslo projektu" = 'CZ.01.4.04/0.0/0.0/18_237/0015869'SELECT p."Registraèní èíslo projektu" ,
       faze.nazev "Sloupec PZF",
       pzf."Celkové zpùsobilé výdaje",
       pzf.id_platba

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id
INNER JOIN isum.V_BI_UMFPFFaze faze ON faze.id =  pzf.id_faze

WHERE p."Registraèní èíslo projektu" = 'CZ.01.4.04/0.0/0.0/18_237/0015869'


SELECT pzf.*

FROM isum.v_bi_UmpPlatbaPrj platba 
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_platba = platba.id 

WHERE platba."Èíslo ¾ádosti o platbu" = 'CZ.01.4.04/0.0/0.0/18_237/0015869/2021/001/POST'

---------------------------------

SELECT	 p."Registraèní èíslo projektu" ,
	 v."Èíslo výzvy",
	 v."Název výzvy",
     	 p.kodwfstav ,
	 SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       	 cis."Název" AS "Právní forma ¾adatele" ,
	 pf."Národní veøejné zdroje",
	 
	 -- listagg(DISTINCT ci."Kód", '; ') as "Zdroje fin. na výzvì"

FROM  isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjggvs vs ON p.id_zadatel = vs.id AND vs.id_typsubjektu = 300784 -- ¾adatel pøíjemce
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_hosppravforma
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMFPFCelkem pf ON pf.id_projekt = p.id AND pf.id_faze=99991000000000005
-- INNER JOIN isum.v_bi_UMZRadekSabDP sabdp ON sabdp.id_nositelsablony = v.id
-- INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = sabdp.id_zdrojfin 

WHERE p."Registraèní èíslo projektu" is not null 
-- AND cis."Název" in ('Nadace','Nadaèní fond','Státní podnik','Národní podnik','Èeská národní banka','Organizaèní slo¾ka státu','Stálý rozhodèí soud','Pøíspìvková organizace zøízená územním samosprávným celkem','Státní pøíspìvková organizace ze zákona','Státní pøíspìvková organizace ostatní','Správa ¾eleznic, státní organizace','Rada pro veøejný dohled nad auditem','Veøejnoprávní instituce','Èeská tisková kanceláø','Státní fond ze zákona','Státní fond ze zákona nezapisující se do obchodního rejstøíku','Zdravotní poji¹»ovna (mimo VZP)','V¹eobecná zdravotní poji¹»ovna','Vysoká ¹kola (veøejná, státní)','©kolská právnická osoba','Veøejná výzkumná instituce','Obec','Kraj','Regionální rada regionu soudr¾nosti','Mìstská èást hlavního mìsta Prahy')

AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP20','PP21','PP22','PP23a','PP23b','V5','PP27a','PP27b','PP29')  

AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')

AND pf."Národní veøejné zdroje" > 0

-- AND pf."Národní veøejné zdroje" > 0

-- GROUP BY p."Registraèní èíslo projektu" ,
-- 	 v."Název výzvy",
--      	 p.kodwfstav ,
--        	 cis."Název"  ,
-- 	 pf."Národní veøejné zdroje"


-- ORDER BY cis."Název"
