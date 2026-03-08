SELECT	 p."Registraèní èíslo projektu" ,
	 v."Èíslo výzvy",
	 v."Název výzvy",
     	 p.kodwfstav ,
	 p.zadatel,
       	 cis."Název" AS "Právní forma ¾adatele" ,
	 pf."Národní veøejné zdroje",
	 pf."Finanèní prostø z rozp kraje",
	 pf."Finanèní prostø z rozp obce",
	 pf."Finanèní prostøedky ze státníc",
 	 pf."Finanèní prostøedky ze státníh"
	 -- platba.wfstav "Stav platby",
	 -- platba.kodwfstav "WFSTAV stav platby"
	 -- -- listagg(DISTINCT ci."Kód", '; ') as "Zdroje fin. na výzvì"

FROM  isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjggvs vs ON p.id_zadatel = vs.id AND vs.id_typsubjektu = 300784 -- ¾adatel pøíjemce
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_hosppravforma
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
-- INNER JOIN isum.v_bi_UMFPFCelkem pf ON pf.id_projekt = p.id AND pf.id_faze=99991000000000005
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby

-- INNER JOIN isum.v_bi_UMZRadekSabDP sabdp ON sabdp.id_nositelsablony = v.id
-- INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = sabdp.id_zdrojfin 

WHERE cis."Název" in ('Nadace','Nadaèní fond','Státní podnik','Národní podnik','Èeská národní banka','Organizaèní slo¾ka státu','Stálý rozhodèí soud','Pøíspìvková organizace zøízená územním samosprávným celkem','Státní pøíspìvková organizace ze zákona','Státní pøíspìvková organizace ostatní','Správa ¾eleznic, státní organizace','Rada pro veøejný dohled nad auditem','Veøejnoprávní instituce','Èeská tisková kanceláø','Státní fond ze zákona','Státní fond ze zákona nezapisující se do obchodního rejstøíku','Zdravotní poji¹»ovna (mimo VZP)','V¹eobecná zdravotní poji¹»ovna','Vysoká ¹kola (veøejná, státní)','©kolská právnická osoba','Veøejná výzkumná instituce','Obec','Kraj','Regionální rada regionu soudr¾nosti','Mìstská èást hlavního mìsta Prahy')

AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42') 

-- AND p.kodwfstav in ('PP20','PP21','PP22','PP23a','PP23b','V5','PP27a','PP27b','PP29')  

-- AND p."Registraèní èíslo projektu" = 'CZ.01.4.03/0.0/0.0/19_259/0025435'
AND p."Registraèní èíslo projektu" not like ('CZ.01.5%')
-- AND pf."Národní veøejné zdroje" > 0

-- GROUP BY p."Registraèní èíslo projektu" ,
-- 	 v."Název výzvy",
--      	 p.kodwfstav ,
--        	 cis."Název"  ,
-- 	 pf."Národní veøejné zdroje"
-- AND NOT EXISTS
-- (SELECT 0
-- FROM isum.v_bi_UmpPlatbaPrj pltb
-- WHERE pltb.kodwfstav in ('P5','P5T','P6','P6T','P7','P8','P8T','P9','P9T','P10','P11')
-- AND pltb.id_NositelPlatby = p.id)





ORDER BY p."Registraèní èíslo projektu" 
