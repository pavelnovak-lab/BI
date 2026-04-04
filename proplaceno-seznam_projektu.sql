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
	 sum(pl.VyuctSkut) as "CZV na vyplacených ŽoP",
	 sum(rf.castkaschvalena) as "Proplacená dotace"	

FROM	isum.v_bi_UmzVyzva v,
	isum.v_bi_UmfPfFaze umfpffaze,
	isum.v_bi_UmfPfCelkem pfc,
	isum.v_bi_UMZProjekt p,
	isum.v_bi_UMPPLatba pl, 
	isum.v_bi_umprozpisfinprj rf,
	isum.v_bi_umsciszakladni cis

WHERE	 pfc.ID_PROJEKT=p.ID
 and	 pfc.ID_FAZE=umfpffaze.ID
 and	 p.ID_VYZVA=v.ID
 and	 pl.id_nositelplatby=p.id
 and 	 p."Registrační číslo projektu" in ('CZ.01.5.125/0.0/0.0/15_020/0015310','CZ.01.1.02/0.0/0.0/15_018/0004790')
 and	 umfpffaze."KOD" ='AKT'
 and 	 pl.WFStav in ('Proplacena příjemci/Vypořádána','Proplacena příjemci s krácením/Vypořádána s krácením')
 and	 cis."Kód" in ('10a')

GROUP BY p."Registrační číslo projektu",
      	 p."KODINVESTPRIORITA", 
	 p.KodPrioritniOsa, 
	 p."KODSPECIFCIL", 
	 v."Číslo výzvy", 
	 v."Název výzvy", 
	 p."ZADATEL", 
	 p."ZADATELPFORMA", 
	 p."IČ", 
	 p."WFSTAV", 
	 p."KODWFSTAV", 
	 pfc."Příspěvek Unie", 
	 pfc."Evropský fond pro regionální r", 
	 pfc."Celkové způsobilé výdaje", 
	 pfc."PROC_EU", 
	 p."KOMPETENCNIUTVAR", 
	 p."WFSTAVDATUM", 
	 p."Datum prvního podání", 
	 p."VELIKOSTPODNIKU" 

