SELECT	 p."KODINVESTPRIORITA" as "Kód investicni priorita",
	 REPLACE(p.KodPrioritniOsa,'01.','') AS "Prioriní osa",  
	 p."KODSPECIFCIL" as "Kód specifického cíle",
	 v."Číslo výzvy" as "Číslo výzvy",
	 v."Název výzvy" as "Název výzvy",
	 p."Registrační číslo projektu" as "Registrační číslo projektu",
	 p."ZADATEL" as "Žadatel",
	 p."ZADATELPFORMA" as "Právní forma",
	 p."IČ" as "IČ",
	 p."WFSTAV" as "WFSTAV",
	 p."KODWFSTAV" as "KODWFSTAV",
	 pfc."Příspěvek Unie" as "Příspěvek Unie",
	 pfc."Evropský fond pro regionální r" as "ERDF",
	 pfc."Celkové způsobilé výdaje" as "Celkové způsobilé výdaje",
	 pfc."PROC_EU" as "Procento EU",
	 p."KOMPETENCNIUTVAR" as "Kompetenční útvar",
	 p."WFSTAVDATUM" as "WFSTAVDATUM",
	 p."Datum prvního podání" as "Datum prvního podání",
	 p."VELIKOSTPODNIKU" as "Velikost podniku",
	 findata."CZV na vyplacených ŽoP",
	 findata."Proplacená dotace"
	   
FROM		isum.v_bi_UMZProjekt p
INNER JOIN	isum.v_bi_UmfPfCelkem pfc ON pfc.ID_PROJEKT=p.ID
INNER JOIN	isum.v_bi_UmzVyzva v ON p.ID_VYZVA=v.ID
INNER JOIN	isum.v_bi_UmfPfFaze umfpffaze ON pfc.ID_FAZE=umfpffaze.ID
INNER JOIN      (SELECT	  p.id,
	  		  sum(pl.VyuctSkut) as "CZV na vyplacených ŽoP",
	  		  sum(rf.castkaschvalena) as "Proplacená dotace"

			  FROM		isum.v_bi_UMZProjekt p
			  INNER JOIN 	isum.v_bi_UMPPLatba pl ON pl.id_nositelplatby=p.id
			  INNER JOIN 	isum.v_bi_umprozpisfinprj rf ON rf.id_platba=pl.id 
			  INNER JOIN 	isum.v_bi_umsciszakladni cis ON rf.id_ukazatel=cis.id AND cis."Kód" = '10a'

			  WHERE	 p."Registrační číslo projektu" is not null
			   AND 	 pl.WFStav in ('Proplacena příjemci/Vypořádána','Proplacena příjemci s krácením/Vypořádána s krácením')
			  GROUP BY p.id) findata  ON findata.id=p.id

WHERE UmfPfFaze."KOD" ='AKT'
