-- CREATE or REPLACE view "04_KnM_Financni_etapy_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Kontroly/Vzorkovani_pro_kontroly_na_miste' AS 

SELECT 	p."Registraèní èíslo projektu" ,
	pl."Datum pøedlo¾ení",
	pl."Poøadí finanèního plánu" "Poøadí ®oP" ,
 	w."Název" "Název stavu" ,
	w."Kód" "Stav ®oP"

FROM projekt p
INNER JOIN platba pl ON pl.id_nositelplatby = p.id 
INNER JOIN ciselnik_stav_workflow w ON pl.id_wfstav = w.id  
INNER JOIN ciselnik_stav_workflow wp ON p.id_wfstav = wp.id  

WHERE p."Registraèní èíslo projektu" is not null
AND wp."Kód" in ('PP30','PP31','PU30')

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , 
"Poøadí ®oP" ASC
