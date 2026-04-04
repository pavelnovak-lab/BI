SELECT	p."Registrační číslo projektu",
	LISTAGG(cis."Název",'; ')

FROM   isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UMZPrjGGTag tag ON tag.id_prjgg = p.id
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = tag.id_tag 

WHERE p."Registrační číslo projektu" in ('CZ.01.2.06/0.0/0.0/18_039/0000077')

GROUP BY p."Registrační číslo projektu" 


-- Dobrý den, nad rámec TS potvrzuji, že jdou štítky vytěžovat BI Publisherem. S těmito vazbami:

-- SELECT	p."Registrační číslo projektu", cis."Název"
-- FROM   isum.v_bi_UmzProjekt p 
-- INNER JOIN isum.v_bi_UMZPrjGGTag tag ON tag.id_prjgg = p.id
-- INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = tag.id_tag 

-- WHERE p."Registrační číslo projektu" in ('CZ.01.2.06/0.0/0.0/18_039/0000077')
