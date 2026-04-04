SELECT count(p."Registrační číslo projektu") ,
--       p."Název projektu CZ",
--       p.zadatel,
--       p.kodwfstav ,
       cis."Název" ,
--       vs.id_hosppravforma

FROM isum.v_bi_umzprjggvs vs
INNER JOIN isum.v_bi_UmzPrjGGII p ON p.id_zadatel = vs.id
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_hosppravforma
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

WHERE p."Registrační číslo projektu" is not null 
AND v."Číslo výzvy" = '01_18_213'
AND vs.id_typsubjektu = 300784 -- žadatel příjemce
AND p.kodwfstav like ('PP%')

-- AND cis.id in (298335, 298339, 298340) /*  Odštěpný závod zahraniční právnické osoby, Odštěpný závod zahraniční fyzické osoby, Odštěpný závod */

GROUP BY p."Registrační číslo projektu" 
