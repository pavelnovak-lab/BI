SELECT	  p."Registrační číslo projektu" as "Registrační číslo projektu",
	  p.id,
	  sum(pl.VyuctSkut) as "CZV na vyplacených ŽoP",
	  sum(rf.castkaschvalena) as "Proplacená dotace"
	  

FROM		isum.v_bi_UMZProjekt p
INNER JOIN 	isum.v_bi_UMPPLatba pl ON pl.id_nositelplatby=p.id
INNER JOIN 	isum.v_bi_umprozpisfinprj rf ON rf.id_platba=pl.id 
INNER JOIN 	isum.v_bi_umsciszakladni cis ON rf.id_ukazatel=cis.id

WHERE	 p."Registrační číslo projektu" is not null      -- 'CZ.01.3.10/0.0/0.0/15_010/0001560'
AND	 cis."Kód" in ('10a')

GROUP BY p."Registrační číslo projektu", p.id 
