SELECT	op.nazev as "Opatøení" ,
	v."Èíslo výzvy" ,
       v."Název výzvy",
       k."Kód" ,
       k."Název" ,
       k."Max. bodù"
FROM vyzva v
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN soubor_kriterii_vyzvy sk ON sk.id_vyzva = v.id
INNER JOIN soubor_kriterii soubor ON soubor.id = sk.id_souborkrit
INNER JOIN hodnotici_kriterium k ON k.id_souborkrit = soubor.id AND k.id_typkriteria = 488949

WHERE v."Výzva zamìøená na RIS3 strategie" = 'A'
AND sk."Poèet hodnotitelù" = 2
AND k."Název" like '%RIS%'

ORDER BY v."Èíslo výzvy" 



