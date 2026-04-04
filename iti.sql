SELECT	v."Číslo výzvy",
	st.id_strategie,
	v."Název výzvy",
	v."Datum zahájení příjmu žádosti",
	Floor((v."Datum ukončení příjmu žádosti" - v."Datum zahájení příjmu žádosti")/30) AS "Otevřeno měsíců",
	v.uzemi As "Aglomerace",
	kom."Název" AS "Program podpory",
	v."Finanční alokace Celk" AS "Alokace výzvy",

	predPA."Celk dot pred PA",
	predPA."Počet v PP před PA",
      	pPA."Počet v PP po PA",
      	pPA."Celková dotace po PA",

	nvl(predPA."Celk dot pred PA",0) + nvl(pPA."Celková dotace po PA",0) AS "Celková dotace v PP",
	(nvl(predPA."Celk dot pred PA",0)+nvl(pPA."Celková dotace po PA",0))/ v."Finanční alokace Celk" AS "Procent v PP",
	nvl(pPA."Celková dotace po PA",0) / v."Finanční alokace Celk" AS "Procent alokace pod PA",
	neg."Počet v PN",

	count (p.id) AS "Zaregistrovaných žádostí", 
	sum(p.eu)/count(p.id) AS "Průměrná požadovaná dotace"


FROM		isum.v_bi_UmzVyzva v
INNER JOIN	isum.v_bi_UmzVyzvaStrategie st ON v.id=st.id_strategie
INNER JOIN	isum.v_bi_UmzVyzvaKategorie kat ON kat.id_vyzva=v.id
INNER JOIN 	isum.V_BI_UMZVYZVAUTVAR	utvar ON utvar.id_vyzva=v.id
INNER JOIN 	isum.V_BI_UMSHIUtvarKomp kom ON kom.id=utvar.id_utvarkomp
LEFT JOIN	isum.v_bi_UmzPrjGG p ON  v.id=p.id_vyzva AND p."Registrační číslo projektu" is not null

LEFT JOIN
      (SELECT count(prPA.id) AS "Počet v PP před PA",
      sum (prPA.eu) AS "Celk dot pred PA",
      prPA.id_vyzva
      FROM isum.v_bi_UmzPrjGG prPA
      WHERE  prPA.kodwfstav in ('PP20','PU21','PP21','PP22','PP23a','PP23b','V5','PP27a','PP27b','PP29') GROUP BY prPA.id_vyzva ) predPA ON v.id=predPA.id_vyzva

LEFT JOIN 
      (SELECT count(poPA.id) AS "Počet v PP po PA",
      sum (poPA.eu) AS "Celková dotace po PA",
      poPA.id_vyzva
      FROM isum.v_bi_UmzPrjGG poPA
      WHERE  poPA.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42') GROUP BY poPA.id_vyzva ) pPA ON v.id=pPA.id_vyzva

LEFT JOIN
	(SELECT count(pcel.id) AS "Počet v PN",
	pcel.id_vyzva
	FROM isum.v_bi_UmzPrjGGII pcel
	WHERE  pcel.kodwfstav in ('PN20a','PN20b','PN21','PN22','PN23a','PN23b','PN27','PN29') GROUP BY pcel.id_vyzva) neg ON neg.id_vyzva=v.id

WHERE 	kat.integrovany='Ano' 
-- AND	v.id=704433334
-- AND p.id=669485156

GROUP BY "Číslo výzvy", "Název výzvy", "Datum zahájení příjmu žádosti",
      Floor((v."Datum ukončení příjmu žádosti" -v."Datum zahájení příjmu žádosti")/30),
      v.uzemi, kom."Název", v."Finanční alokace Celk", kom."Název", 
      predPA."Celk dot pred PA",
      predPA."Počet v PP před PA",
      pPA."Počet v PP po PA",
      pPA."Celková dotace po PA",
      predPA."Celk dot pred PA" + pPA."Celková dotace po PA" ,
      (predPA."Celk dot pred PA" + pPA."Celková dotace po PA") / v."Finanční alokace Celk" ,
      pPA."Celková dotace po PA" / v."Finanční alokace Celk" ,
      neg."Počet v PN",
      st.id_strategie
