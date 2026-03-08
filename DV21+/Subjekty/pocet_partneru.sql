SELECT op."Název specifického cíle/opatření" as "Opatření" ,
       v."Číslo výzvy" ,
       v."Název výzvy",
       p."Registrační číslo projektu" ,
       w."Kód" "Kód stavu" ,
       part.pocetp "Počet partnerů"
       
FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN (SELECT count(s.id) pocetp,
      	   	   s.id_prjgg
	    FROM subjekt s
	    WHERE s."Neplatný od" is null
	    AND s.id_typsubjektuedit IN (413467) -- partner s FP
	    GROUP BY s.id_prjgg ) part ON part.id_prjgg = p.id

WHERE p."Registrační číslo projektu" is not null
-- AND v."Číslo výzvy" = '01_22_002'
AND op."Název specifického cíle/opatření" = 'Aplikace'
