SELECT	op.nazev as "Opatření" ,
	v."Název výzvy" ,
	v."Číslo výzvy" ,
	count(p.id) "Počet projektů",
       	a."Počet s arbitrem"

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id 
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN
(SELECT v."Číslo výzvy" ,
	count(a."Registrační číslo projektu") AS "Počet s arbitrem"
 FROM "Arbitr" a
 INNER JOIN vyzva v ON v."Číslo výzvy" = a."Číslo výzvy"  
 GROUP BY v."Číslo výzvy" 
) a ON a."Číslo výzvy" = v."Číslo výzvy"  

WHERE p."Registrační číslo projektu" like ('CZ.01.01%')
AND w."Kód" IN ('PP23a', 'PP23b', 'PN23', 'PP25a', 'PP25b', 'PU25', 'PN25', 'PU26', 'PP26', 'PN26', 'PP30', 'PP31', 'PP40', 'PP41', 'PP42', 'PP43', 'PU30', 'PN40a', 'PN40b')


GROUP BY op.nazev ,
	 v."Název výzvy",
         v."Číslo výzvy" ,
      	 a."Počet s arbitrem"

