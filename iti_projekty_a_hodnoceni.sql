SELECT v."Název výzvy",
       v."Číslo výzvy" ,
       p."Registrační číslo projektu",
       p.zadatel,
       p."Datum registrace žádosti",
       p.VelikostPodniku,
       p.kodwfstav,
       gg.eu,
       gg.czv ,
       -- status.pocetbodu as "Bodů VH" ,
       -- skv.LimitVyhovelBodu,

       -- listagg (uj."Kód", '; ') as kod,
       listagg (DISTINCT uj."Název", '; ' ) as "Místo realizace"
       -- listagg (DISTINCT uj.urovennazev, '; ' ) as "Úroveň UJ"
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva AND v."OP kod" = '01'
INNER JOIN isum.v_bi_UmzVyzvaKategorie kat ON kat.id_vyzva = v.id AND kat.integrovany = 'Ano'
INNER JOIN isum.v_bi_umzprjumisteni um ON um.id_projekt = p.id
LEFT JOIN  isum.v_bi_umscisuzemnijednotky uj ON um.id_uzemnijednotky = uj.id AND uj.urovennazev <> 'Kraj' AND uj."Název" not like '%-město'
-- LEFT JOIN 
--  (SELECT p.id,
-- 	status.pocetbodu as "Bodů VH" 
-- --       	skv.LimitVyhovelBodu
--   FROM isum.v_bi_UmzPrjGGII p
--   LEFT JOIN isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni = p.id AND status.id_krokvechodn = 171214) body ON body.id = p.id


-- INNER JOIN isum.v_bi_UMVHodnSoubKritVyz skv ON skv.id_vyzva = v.id AND skv.id_krokvechodn = 171214 AND skv.PLATNOSTDO is null

WHERE p."Registrační číslo projektu" is not null
AND NOT REGEXP_LIKE(uj."Název", '[0-9]$')
-- AND p.kodwfstav in ('PN23a','PN23b')

GROUP BY v."Číslo výzvy",
       v."Název výzvy" ,
       p."Registrační číslo projektu",
       p.zadatel,
       p."Datum registrace žádosti",
       p.VelikostPodniku,
       p.kodwfstav,
       gg.eu,
       gg.czv 
--       status.pocetbodu ,
--       skv.LimitVyhovelBodu
-- body."Bodů VH"	 
