SELECT
	-- v."Číslo výzvy",
	-- v."Název výzvy",
--	v."Odesílat do DotInfo",
	kom."Název" AS "Program podpory",
	-- cis."Název" AS "Typ přílohy",
	-- ciselnik."Název" AS "Druh přílohy",
	count(p.id) AS "Nepřeneseno na DotInfo"

FROM		isum.v_bi_UmzVyzva v
INNER JOIN 	isum.V_BI_UMZVYZVAUTVAR	utvar ON utvar.id_vyzva=v.id
INNER JOIN 	isum.V_BI_UMSHIUtvarKomp kom ON kom.id=utvar.id_utvarkomp
INNER JOIN	isum.v_bi_UMZVyzvaTypPrilDI pril ON pril.id_vyzva=v.id
INNER JOIN 	isum.v_bi_UmsCisZakladni cis ON cis.id=id_typpril
INNER JOIN	isum.V_BI_UMZVYZVADRUHPRILDI druh ON druh.id_druhtypu=pril.id
INNER JOIN	isum.v_bi_UmsCisZakladni ciselnik ON ciselnik.id=druh.id_druhpril
INNER JOIN 	isum.v_bi_UmzProjekt p ON p.id_vyzva=v.id


WHERE 	kom.id <> 172095 /* předpokládám, že program podpory není OP PIK */
AND	cis."Název" <> 'Implementační / realizační 2'
AND	ciselnik."Název" <> 'Právní akt'	
AND	p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42') 
AND EXISTS
(SELECT p.id
 FROM	     isum.v_bi_UmzProjekt p
 INNER JOIN  isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
 WHERE p."Registrační číslo projektu" is not null
 AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42') )

GROUP BY kom."Název"
