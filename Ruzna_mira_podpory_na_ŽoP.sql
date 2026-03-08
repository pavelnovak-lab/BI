SELECT	p."Registraèní èíslo projektu", 
	p.kodwfstav AS "Stav projektu",
	rf.castkaaktual AS "Procent podpory aktual",  
	rf.castkapravniakt AS "Procent podpory RoPD",
--	max(pl."PORADI#Poøadí finanèního plánu") AS "Maximální Poøadí ®oP"
	pl."PORADI#Poøadí finanèního plánu" "Poøadí ®oP",
	pl.kodwfstav "Stav ®oP",
	pl.wfstav
	
FROM	isum.v_bi_UmzProjekt p
-- INNER JOIN isum.v_bi_UmzVyzva v ON p.id_vyzva=v.id
INNER JOIN isum.v_bi_UmpPlatbaPrj pl ON pl.id_nositelplatby = p.id
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = pl.id
-- INNER JOIN isum.v_bi_UmpCastky castky ON castky.id=pl.id_schvalenecastky
-- INNER JOIN isum.v_bi_UmsCisZakladni c ON rf.id_ukazatel=c.id

WHERE p."Registraèní èíslo projektu" in ('CZ.01.4.04/0.0/0.0/16_076/0009475', 'CZ.01.4.04/0.0/0.0/15_005/0003124', 'CZ.01.4.04/0.0/0.0/15_005/0001454', 'CZ.01.1.02/0.0/0.0/16_084/0009890', 'CZ.01.1.02/0.0/0.0/16_079/0008827', 'CZ.01.1.02/0.0/0.0/15_019/0004892', 'CZ.01.1.02/0.0/0.0/15_019/0004727', 'CZ.01.1.02/0.0/0.0/15_018/0004830', 'CZ.01.1.02/0.0/0.0/15_018/0004827')

-- in ('CZ.01.4.04/0.0/0.0/15_005/0001454', 'CZ.01.4.04/0.0/0.0/15_005/0000091')
AND   p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42')
AND   rf.id_ukazatel = 361357 /* Vybre øádek 10b */
AND   pl.kodwfstav in ('P4','P5','P5T','P6','P6T','P7','P8','P8T','P9','P9T','P10','P11')

-- GROUP BY p."Registraèní èíslo projektu" , rf.castkaaktual

ORDER BY p."Registraèní èíslo projektu", pl."PORADI#Poøadí finanèního plánu"
