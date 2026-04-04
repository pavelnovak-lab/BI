SELECT	 p."Registrační číslo projektu",
	 p."Název projektu CZ",
	 p."ZADATEL",
	 p."IČ",
	 p."KODWFSTAV",
	 fp."Celkové způsobilé výdaje",
	 fp."Národní veřejné zdroje",
	 fp."Příspěvek Unie"

FROM	isum.v_bi_umzprojekt p 
INNER JOIN isum.v_bi_umfpfcelkem fp ON fp.id_projekt=p.id

WHERE p."Registrační číslo projektu" is not null
 and	fp."ID_FAZE" ='99991000000000005'
 and 	fp."Národní veřejné zdroje">0
 and 	p."KODWFSTAV" like 'PP%'
