SELECT p."Registrační číslo projektu",
       p.zadatel,
       p.kodwfstav,
       p."Anotace projektu",
       v."Název výzvy",
       v."Číslo výzvy",
       -- ci."Kód" AS "Kód CZ NACE",
       -- ci."Název" AS "Název CZ NACE",
       p."Název projektu CZ",
       gg."EU" AS "Požadovaná dotace",
       gg."CZV" AS "Celkové způsobilé výdaje",

       kom."Název" AS "Program podpory"
       -- cis_2."Kód",
       -- cis_2."Název"
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel
INNER JOIN isum.v_bi_umsciszakladni ci ON ci.id=n.id_cznace
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id
INNER JOIN isum.V_BI_UmzVyzvaUtvar utvar ON utvar.id_vyzva=v.id
INNER JOIN isum.V_BI_UMSHIUtvarKomp kom ON kom.id=utvar.id_utvarkomp

-- INNER JOIN isum.V_BI_UMZPRJKI ki ON ki.id_projekt=p.id
-- INNER JOIN isum.v_bi_UmsCisZakladni cis_2 ON ki.id_ki=cis_2.id

WHERE p."Registrační číslo projektu" is not null
AND   ci."Kód" like '30.3%'
-- AND   ci."Kód" like '11.02.0'
-- AND   cis_2."Kód" = '32.20.0'
AND   p.kodwfstav in ('PP30', 'PP36','PP37', 'PP40','PP41','PP42')
AND   (p."Anotace projektu" like ('%vesm%') OR p."Anotace projektu" like ('%kosm%'))


ORDER BY gg."EU" DESC
