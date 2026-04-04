SELECT LISTAGG(distinct c."Název",'; ' ) WITHIN GROUP (ORDER BY c."Název")  AS "Typ vrácených kritérií"       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON h.id_noshodnoceni = p.id
INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = h.id AND h.TYPHODNOTITELE IN ('Opravný hodnotitel') AND krit.needitovatelne = 'N'
INNER JOIN isum.v_bi_UmsCisZakladni c ON c.id = krit.id_typkriteria

WHERE p.KodPrioritniOsa in ('01.1','01.2', '01.3', '01.4','01.5') 
AND p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/21_373/0026703')


