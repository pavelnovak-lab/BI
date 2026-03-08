SELECT	p."Registrační číslo projektu", 

fp."Podpora celkem",
fp.id_faze,
faze.nazev

FROM	isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmFPFCelkem fp ON p.id=fp.id_projekt
INNER JOIN isum.v_bi_V_BI_UMFPFFaze faze ON faze.id = fp.id_faze

WHERE p."Registrační číslo projektu" in ('CZ.31.3.0/0.0/0.0/22_001/0001996')
