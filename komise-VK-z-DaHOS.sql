SELECT count(p.id),
       v."Název výzvy",
       hk."Název komise",
       v."Èíslo výzvy",
       hk."Platnost od",
       tk.nazev,
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" 

FROM INNER JOIN isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UMVHodnKomNos k p.id = k.id_noshodnoceni
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMVHodnKomise hk ON hk.id = k.id_hodnkomise
INNER JOIN isum.v_bi_UMVHodnTypKomise tk ON tk.id = hk.id_typkomise

WHERE 
-- k.id = 59672186
AND tk.nazev = 'Výbìrová'
AND SUBSTR(p.kompetencniutvar, 6 ) in ('Slu¾by infrastruktury','Inovace', 'Aplikace', 'Potenciál', 'Spolupráce')
GROUP BY v."Název výzvy",
       hk."Název komise",
       v."Èíslo výzvy",
       hk."Platnost od",
       tk.nazev,
       SUBSTR(p.kompetencniutvar, 6 )


----------------------
SELECT SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       count(p.id)

FROM isum.v_bi_UmzProjekt p 

WHERE p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PN40a','PN40b','PP27a','PP27b','PU27','PN27','PP29','PN29') 
AND SUBSTR(p.kompetencniutvar, 6 ) in ('Slu¾by infrastruktury','Inovace', 'Aplikace', 'Potenciál', 'Spolupráce')

GROUP BY  SUBSTR(p.kompetencniutvar, 6 )

------------------------------
SELECT p."Registraèní èíslo projektu",
       p.zadatel,
       gg.eu,
       gg.czv,
       clld."Název CZ",
       clld."Kód",
       clld.typ

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.V_BI_UMSCisIntegNastr clld ON clld.id=p.id_strategie

WHERE p."Registraèní èíslo projektu" not like 'CZ.01%'
AND p."Registraèní èíslo projektu" is not null 
