SELECT	p."Registraèní èíslo projektu",
	h."Poøadí",
	h."Datum vytvoøení"

from projekt p 
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id 

WHERE h.id_souborkrit = 397996887

ORDER BY h."Datum vytvoøení" DESC
