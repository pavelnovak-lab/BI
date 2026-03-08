SELECT 	count(p.id) ,
	uz.uzivatel

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmvHodnoceniPrj h ON p.id=h.id_noshodnoceni
INNER JOIN isum.V_BI_CUzivatel uz ON uz.username = h.CREATE_UZIVATEL


WHERE
p."Registraèní èíslo projektu" is not null
-- ('CZ.01.3.14/0.0/0.0/19_253/0020892','CZ.01.1.02/0.0/0.0/19_262/0020241','CZ.01.1.02/0.0/0.0/15_031/0007136','CZ.01.1.02/0.0/0.0/19_262/00202
AND p."Registraèní èíslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0000005'
AND h.FINALIZOVANO = 'A'
AND h.SCHVALENOSCHVAL = 'A'
AND p.id_vyzva IN (1482646063, 1535151127) -- Výzvy 31_22_001, 31_22_005


GROUP BY uz.uzivatel
