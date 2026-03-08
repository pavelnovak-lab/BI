SELECT --p."Registraèní èíslo projektu"
       u.*

FROM
--isum.v_bi_UmzProjekt p 
-- INNER JOIN isum.v_bi_UMFCBA cba ON cba.id_prj = p.id
-- INNER JOIN
isum.v_bi_cuzivatel  u -- ON u.username = cba.LAST_MODIF_UZIVATEL

WHERE u.username IN ('SINPAV','SVOPET','MATJAR1','KALSTA')


