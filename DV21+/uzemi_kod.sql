SELECT p."Registraèní èíslo projektu" ,
       va."Název kraj" "Název územní jednotky"

FROM projekt p
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit IN (413462) -- , 413467) -- omezit na ¾adatele nebo i patrnera s FP? 
INNER JOIN ciselnik_typ_subjektu cts ON s.id_typsubjektuedit = cts.id 
INNER JOIN verze_adresy va ON va.id = s.id_oficialniadresa

WHERE p."Registraèní èíslo projektu" is not null 
