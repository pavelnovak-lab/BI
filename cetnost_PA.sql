SELECT
	-- count(sml.id) "Poèet",
      	sml.typ,
	p."Registraèní èíslo projektu",
	p.kodwfstav 

FROM isum.v_bi_umfsmlouva sml
INNER JOIN isum.v_bi_UmzPrjGGII p ON sml.idprojekt = p.id

WHERE (sml.typ = 'Rozhodnutí o odnìtí dotace') 

ORDER BY sml.typ
