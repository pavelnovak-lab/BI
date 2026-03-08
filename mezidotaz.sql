SELECT	p."Registraèní èíslo projektu",
	problem."Název Dodavatele" "Dodavatel s Tesla v názvu"


FROM isum.v_bi_UmzPrjGGII p 
-- INNER JOIN isum.v_bi_UMZPrjGGSdileni sd ON sd.id_nositelsdil = p.id
-- INNER JOIN isum.v_bi_CUzivatel u ON u.id = sd.id_uzivatel
LEFT JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektu = 300786
LEFT JOIN 
( SELECT  vs.id_prjgg,
	s."Název Dodavatele"
FROM isum.v_bi_UmzPrjGGvs vs 
inner join isum.V_BI_UMFSOUPISKADOKLADPRJ s on s.ID_SUBJEKT=vs.ID
-- inner join isum.V_BI_UMPPLATBAPRJ pl on pl.ID=s.ID_PLATBA
WHERE vs.ID_TYPSUBJEKTU = 300784
AND s."Èástka bez DPH pøipadající na" >0
-- AND p."Registraèní èíslo projektu" = 'CZ.01.3.14/0.0/0.0/19_252/0019769'
AND LOWER(s."Název Dodavatele") like '%tesla%' 
) problem ON problem.id_prjgg = p.id


WHERE p."Registraèní èíslo projektu" = 'CZ.01.3.14/0.0/0.0/19_252/0019769'
