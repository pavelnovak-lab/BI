SELECT
h.create_cas as "Posudek vytvoøen",
-- h.CREATE_UZIVATEL as "Posudek vytvoøil",
-- h.datum_finalizace "Datum finalizace posudku",
-- h.datumhodn "Datum hodnocení",
-- h.datumhodnoceni  "Datum hodnocení 2",
h.platnost,
h.poradi,
sch.datumschval,
sch.datumvrackpreprac,
sch.finschval,
p."Registraèní èíslo projektu" 
	
FROM isum.v_bi_UmvHodnoceni h
INNER JOIN isum.v_bi_UMVHodnSchvaleni sch ON sch.id = h.id_schvaleni
INNER JOIN isum.v_bi_UmzPrjGGII p ON p.id = h.noshodnoceni

WHERE p."Registraèní èíslo projektu" is not null 
-- h.id in (986843371)
AND sch.DATUMVRACKPREPRAC > h.create_cas
AND h.platnost = 'A'





