SELECT  count(p."Registrační číslo projektu"),
	 p.kodprioritniosa


FROM		isum.v_bi_umzprojekt p

WHERE 	p.kodwfstav in ('PP23a', 'PN23a', 'PP23b', 'PP27a', 'PP27b', 'PU27', 'PN27', 'PP29', 'PN29', 'PP30', 'PP36', 'PP37', 'PP40', 'PP41', 'PP42')

GROUP BY p.kodprioritniosa
