SELECT	 p."Registrační číslo projektu" ,
	 v."Název výzvy",
     	 p.kodwfstav ,
       	 cis."Název" AS "Právní forma žadatele" ,
	 pf."Národní veřejné zdroje",
	 listagg(DISTINCT ci."Kód", '; ') as "Zdroje fin. na výzvě"

FROM  isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_umzprjggvs vs ON p.id_zadatel = vs.id AND vs.id_typsubjektu = 300784 -- žadatel příjemce
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_hosppravforma
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMFPFCelkem pf ON pf.id_projekt = p.id AND pf.id_faze=99991000000000011
INNER JOIN isum.v_bi_UMZRadekSabDP sabdp ON sabdp.id_nositelsablony = v.id
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = sabdp.id_zdrojfin 

WHERE p."Registrační číslo projektu" is not null 
-- AND p."Registrační číslo projektu" not like ('CZ.01.5%')
AND pf."Národní veřejné zdroje" > 0

ORDER BY v."Název výzvy" 

GROUP BY p."Registrační číslo projektu" ,
	 v."Název výzvy",
     	 p.kodwfstav ,
       	 cis."Název"  ,
	 pf."Národní veřejné zdroje"
