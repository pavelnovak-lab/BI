SELECT cis."Platný",
       cis."Název" ,
       cis."Kód",
       cis."Popis CZ",
       szn.gestor,
       szn."Název" AS "Název číselníku"

FROM isum.v_bi_UmsCisZakladni cis
INNER JOIN isum.v_bi_UmsCisSeznam szn ON cis.id_cisseznam=szn.id

WHERE cis.id > 0
AND szn."Název" like :Nazev

-- AND cis.ID_CisSeznam = 198381



