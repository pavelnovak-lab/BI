SELECT p."Registrační číslo projektu" ,
       p."Název projektu CZ",
       p.zadatel,
       p.kodwfstav ,
       cis."Název" 
       -- vs.id_hosppravforma,
       -- cis.id

FROM isum.v_bi_umzprjggvs vs
INNER JOIN isum.v_bi_UmzProjekt p ON p.id_zadatel = vs.id
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_hosppravforma

WHERE p."Registrační číslo projektu" is not null 
-- WHERE vs.id = 327423399

-- 298335


WHERE cis.id in (298335, 298339, 298340) /*  Odštěpný závod zahraniční právnické osoby, Odštěpný závod zahraniční fyzické osoby, Odštěpný závod */
