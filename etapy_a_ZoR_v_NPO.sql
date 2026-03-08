SELECT	v."Èíslo výzvy", v."Název výzvy" ,
	p."Registraèní èíslo projektu",
	p."Název projektu CZ",
	p.zadatel,
	zi."Poøadové èíslo ZoR/IoP",
	zi.kodwfstav,
	zi.wfstav,
	max(e."Poøadí etapy") "Poèet etap"
	
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMZZIProjekt zi ON zi.id_zad = p.id
INNER JOIN isum.v_bi_UMZCisTypZI ct ON ct.id = zi.id_CisTypZI 
-- INNER JOIN isum.v_bi_UMVIndiHodnotaDetail ihd ON ihd.id_nositelindi = zi.id
-- INNER JOIN isum.v_bi_UmvIndikator ind ON ind.id = ihd.id_indikator
LEFT JOIN isum.v_bi_UMVEtapa e ON e.id_nositeletapy = p.id

WHERE  -- p."Registraèní èíslo projektu" = 'CZ.31.2.0/0.0/0.0/22_014/0004906'
ct."Poznámka" = 'ZOR'
AND zi.kodwfstav <> 'P0'
AND v."Èíslo výzvy" IN ('31_22_014','31_22_015')


GROUP BY v."Èíslo výzvy",
      	 v."Název výzvy" ,
	p."Registraèní èíslo projektu",
	p."Název projektu CZ",
	p.zadatel,
	zi."Poøadové èíslo ZoR/IoP",
	zi.kodwfstav,
	zi.wfstav

ORDER BY v."Èíslo výzvy", p."Registraèní èíslo projektu" , zi."Poøadové èíslo ZoR/IoP"







----------------------------------------

SELECT max(e."Poøadí etapy") "Poèet etap",
       e.id_nositeletapy


FROM isum.v_bi_UMVEtapa e

GROUP BY e.id_nositeletapy
