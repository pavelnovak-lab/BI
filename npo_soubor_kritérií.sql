SELECT p."Registraèní èíslo projektu" ,
       p.id,
       p.zadatel ,
       p."Název projektu CZ",
       hod.*

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmvHodnoceni hod ON hod.id_noshodnoceni = p.id

WHERE p.id = 1900478012

-- id_vyzva = 1919468296
--  AND hod.id_krokvechodn = 171213
