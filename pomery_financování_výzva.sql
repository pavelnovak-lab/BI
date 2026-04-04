SELECT	op.nazev as "Opatření" ,
	v."Číslo výzvy",
	pfh."Název" "Název hlavičky PF",
	pf."Doporučený poměr financování (%)" ,
	z.*

FROM vyzva v
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN pomery_financovani_hlavicka pfh ON pfh.id_nositelpompf = v.id
INNER JOIN pomery_financovani pf ON pf.id_hlavicka = pfh.id
INNER JOIN ciselnik_kategorie_regionu kr ON kr.id = pf.id_kategorieregionu
INNER JOIN ciselnik_zdroj_financovani z ON z.id = pf.id_zdrojfin


WHERE v."Číslo výzvy" = '01_23_036'
AND kr."Kód" = '01'
AND z."Kód" = 'EU'
