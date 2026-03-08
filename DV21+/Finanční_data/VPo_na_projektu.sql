SELECT  op.nazev as "Opatření" ,
	p."Registrační číslo projektu" ,
	w."Kód" "Kód stavu" ,
	v."Název výzvy" ,
	vp."Počet nenulových VPo",
	subjekt."Počet subjektů",
	vp.rezim,
	vp.clanek
	
FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN (SELECT count(vpo.id) "Počet nenulových VPo",
      	   	   count(distinct vpo.id_rezimpodpory) rezim,
		   count(distinct vpo.id_podkategorie) clanek,
      	   	   vpo.id_projekt
 	    FROM verejna_podpora vpo
	    WHERE vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč" > 0
	    GROUP BY vpo.id_projekt ) vp ON vp.id_projekt = p.id 
INNER JOIN (SELECT count(s.id) "Počet subjektů",
      	   	   s.id_prjgg
      	    FROM subjekt s
	    WHERE subjekt."Neplatný od" is null
	    AND subjekt.id_typsubjektuedit IN (413462, 413467) -- žadatel, partner s FP
	    GROUP BY s.id_prjgg) subjekt ON subjekt.id_prjgg = p.id 
-- INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 


WHERE v."Číslo výzvy" IN ('01_22_002','01_24_062','01_23_036','01_25_071','01_24_063','01_24_056','01_25_079','01_25_078','01_25_072','01_23_027')
-- AND op.nazev <> 'Aplikace'
AND w."Kód" not like 'PN%'
AND p."Registrační číslo projektu" is not null 
AND vp."Počet nenulových VPo" = subjektů."Počet subjektů"






-- ORDER BY "Počet nenulových VPo"
