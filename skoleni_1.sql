SELECT v."Èíslo výzvy",
       nvl(sc1."Èíslo", sc2."Èíslo") as CisloSC,
       nvl(sc1."Název", sc2."Název") as NazevSC



FROM isum.v_bi_UmzVyzva v
LEFT JOIN
(SELECT hier.id_vyzva ,
	LISTAGG(hisc."Èíslo specifického cíle / oper", '; ')  AS "Èíslo",
	LISTAGG(hisc."Název specifického cíle plný", '; ')  AS "Název"
 FROM isum.v_bi_UmzVyzvaHierarchie hier
 INNER JOIN isum.v_bi_UmsHiSC hisc ON hisc.id = hier.id_speccil

 GROUP BY hier.id_vyzva
 
) sc1 ON sc1.id_vyzva = v.id AND :rozpad = 0

LEFT JOIN
(SELECT hier.id_vyzva ,
	hisc."Èíslo specifického cíle / oper" AS "Èíslo",
	hisc."Název specifického cíle plný" AS "Název"
 FROM isum.v_bi_UmzVyzvaHierarchie hier
 INNER JOIN isum.v_bi_UmsHiSC hisc ON hisc.id = hier.id_speccil
) sc2 ON sc2.id_vyzva = v.id AND :rozpad = 1

WHERE v."Èíslo výzvy" in ('01_15_020','01_18_183')




-- over (ORDER BY hisc."Èíslo specifického cíle / oper")
-- over (ORDER BY hisc."Název specifického cíle plný")


--       count(hisc."Èíslo specifického cíle / oper") "Poèet SC"
--       LISTAGG(hisc."Èíslo specifického cíle / oper",'; ' on overflow truncate)  AS "Specifické_cíle",


-- INNER JOIN isum.v_bi_UmzVyzvaHierarchie hier ON hier.id_vyzva = v.id 
-- INNER JOIN isum.v_bi_UmsHiSC hisc ON hisc.id = hier.id_speccil



-- GROUP BY v."Èíslo výzvy"

-- HAVING count(hisc."Èíslo specifického cíle / oper") > 1





registraèní èíslo,
název subjektù



SELECT p."Registraèní èíslo projektu" ,
       p.kodwfstav ,
       zrizovatel."JMENOANAZEV" as "Zøizovatel",
       vs."JMENOANAZEV"  as "®adatel"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg = p.id

LEFT JOIN 
(SELECT vs.id_prjgg,
 	vs."JMENOANAZEV"
FROM isum.v_bi_UmzPrjGGvs vs
 
WHERE nvl(vs.neplatny,'N') <> 'A'
AND vs.id_typsubjektu = 798717) zrizovatel ON zrizovatel.id_prjgg = p.id

WHERE p."Registraèní èíslo projektu" in ('CZ.07.4.67/0.0/0.0/17_054/0001042','CZ.07.4.68/0.0/0.0/18_066/0001604','CZ.07.4.68/0.0/0.0/18_066/0001562')
AND  nvl(vs.neplatny,'N') <> 'A'
AND vs.id_typsubjektu = 300784


-- INNER JOIN isum.v_bi_UmsCisZakladni cis ON vs.id_typsubjektu=cis.id






SELECT	p."Registraèní èíslo projektu",
	p.kodwfstav ,  
	v."Èíslo výzvy",
	cis.nazev as "Název SC",
	ujed."Název"

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMZPrjGGSC sc ON sc.id_prjgg = p.id
INNER JOIN isum.v_bi_UMSHISC cis ON sc.id_sc = cis.id
INNER JOIN isum.v_bi_UmzPrjUmisteniGen gen ON gen.id_projekt = p.id
INNER JOIN isum.v_bi_UMSCisUzemniJednotky ujed ON gen.ID_UZEMNIJEDNOTKY = ujed.id

WHERE p."Registraèní èíslo projektu" = 'CZ.01.3.14/0.0/0.0/19_253/0022094'
AND   ujed."Název" not like ('Praha%')


-- AND gen.id_uzemnijednotky in (:uz) AND n.typ (:rd)




SELECT vs."IÈ",
       

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND id_typsubjektu = 300784
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UMFSOUPISKADOKLAD doklad ON doklad.id_subjekt = vs.id

WHERE p.id = 2014866
