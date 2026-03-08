SELECT	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	p."Registraèní èíslo projektu" ,
       p.zadatel "®adatel",
       tel."Kód" ,
       h.typhodnotitele,
       h.DATUMHODN "Datum zalo¾ení posudku",
       h.DATUM_FINALIZACE

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmvHodnoceni h ON h.id_noshodnoceni = p.id
INNER JOIN isum.v_bi_UmvHodnotitel tel ON tel.id = h.id_hodnotitel

WHERE h.finalizovano = 'A'
AND h.platnost = 'A'
AND (
    (tel."Kód" = '2207' AND trunc(h.datumhodn) >= to_date('2015-12-01','yyyy-mm-dd') AND trunc(h.datumhodn) <= to_date('2016-11-29','yyyy-mm-dd') )
    OR
    (tel."Kód" = '2207' AND trunc(h.datumhodn) >= to_date('2015-12-31','yyyy-mm-dd') AND trunc(h.datumhodn) <= to_date('2016-12-13','yyyy-mm-dd') )
    )
