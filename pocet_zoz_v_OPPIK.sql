SELECT
	-- p."Registrační číslo projektu" 
       count(p.id)
--       zoz."Pořadové číslo ŽoZ",
       ci."Název"

FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmzZoZProjekt zoz ON zoz.id_zad = p.id
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = zoz.id_zavaznostzmeny


WHERE p."Registrační číslo projektu" is not null 
AND zoz.id_wfstav = 656429
-- AND ci."Název" is null


GROUP BY ci."Název"
