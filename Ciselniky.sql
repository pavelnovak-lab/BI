SELECT p."Registrační číslo projektu",
       ci."Kód" "Kód ZED",
       ci."Název" "Název ZED",
       cis."Kód",
       cis."Název" "Název typu platby"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  p.id_agrakcezed
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = p.id_typplatby



SELECT DISTINCT zc.id_cisseznam,
       seznam."Název" 
from  isum.v_bi_UmsCisZakladni zc
INNER JOIN isum.V_BI_UMSCisSeznam seznam ON seznam.id = zc.id_cisseznam 
