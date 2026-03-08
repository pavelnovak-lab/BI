SELECT zprava.*

FROM isum.v_bi_UMSAdresatZpravy adresat
INNER JOIN isum.V_BI_UMSZprava zprava ON adresat.id_zprava = zprava.id


WHERE adresat.id = 1688547120


----------------------------------------

SELECT p."Registrační číslo projektu",
       p.kodwfstav ,
       zprava."Předmět",
       zprava."Text",
       zprava.priloha,
       pril.NAZEVPRIL,
       pril."Link_DMS"
FROM isum.v_bi_UMSAdresatZpravy adresat
INNER JOIN isum.V_BI_UMSZpravaPRJ zprava ON adresat.id_zprava = zprava.id
INNER JOIN isum.v_bi_UmzProjekt p ON zprava.id_nositelzpravy = p.id
INNER JOIN isum.v_bi_UMSPrilohyDEP pril ON pril.id_nositelpril = zprava.id


WHERE -- adresat.id = 1688547120
zprava.id = 2045506530



