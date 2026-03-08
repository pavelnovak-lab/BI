SELECT hod.CREATE_CAS,
       hod.CREATE_UZIVATEL,
       hod.DATUM_FINALIZACE,
       hod.DATUMHODN,
       hod.DATUMHODNOCENI,
       hod.FINALIZOVANO,
       hod.FINALIZOVANOAN,
       hod.LAST_MODIF_CAS,
       hod.LAST_MODIF_UZIVATEL,
       hod.LMT,
       hod.PLATNOST,
       hod.POCETBODU,
       hod.PORADI,
       hod.STAVPOSUDKU,
       hod.TERMINZADPOSUDKU,
       hod.VYHOVEL


FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmvHodnoceni hod ON hod.id_noshodnoceni = p.id
-- INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = hod.id

WHERE p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/20_321/0025149'
AND hod.id_krokVechodn = 171214

ORDER BY hod.poradi



