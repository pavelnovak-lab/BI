SELECT	p."Registraèní èíslo projektu",
	ct."Poznámka" "Typ zprávy",
	ind."Název indikátoru",
	ihd."Cílová hodnota",
	ihd."Datum cílové hodnoty",
	ihd."Dosa¾ená hodnota",
	ihd."Datum dosa¾ené hodnoty",
	zi."Poøadové èíslo ZoR/IoP" 

FROM isum.v_bi_UmzPrjGGII p 
INNER JOIN isum.v_bi_UMZZIProjekt zi ON zi.id_zad = p.id
INNER JOIN isum.v_bi_UMZCisTypZI ct ON ct.id = zi.id_CisTypZI 
INNER JOIN isum.v_bi_UMVIndiHodnotaDetail ihd ON ihd.id_nositelindi = zi.id
INNER JOIN isum.v_bi_UmvIndikator ind ON ind.id = ihd.id_indikator


WHERE p."Registraèní èíslo projektu" = 'CZ.01.3.10/0.0/0.0/15_010/0001834'
AND ct."Poznámka" = 'ZOR'
