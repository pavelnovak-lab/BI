SELECT p."Registraèní èíslo projektu" ,
       zoz."Poøadové èíslo ®oZ",
       zoz."Datum úèinnosti", 
       zoz.kodwfstav,
       zoz.last_modif_cas "Ve stavu R od",
       -- sysdate - zoz.last_modif_cas "Dní v R",
       ROUND((SYSDATE - zoz.last_modif_cas), 1) || ' dní, ' ||
       ROUND(MOD((SYSDATE - zoz.last_modif_cas) * 24, 24), 1) || ' hodin' as "Dní a hodin v R",
       -- TRUNC(EXTRACT(DAY FROM (SYSDATE - zoz.last_modif_cas))) || ' dní, ' ||
       -- TRUNC(EXTRACT(HOUR FROM (SYSDATE - zoz.last_modif_cas))) || ' hodin' as CASOVY_ROZDIL,
       zoz.last_modif_uzivatel 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMZZOZProjekt zoz ON zoz.id_zad = p.id
-- INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = zoz.id

WHERE p."Registraèní èíslo projektu" like 'CZ.31%'
-- AND hs.stavdo = 'R'
AND zoz.kodwfstav = 'R'

ORDER BY "Dní a hodin v R"

