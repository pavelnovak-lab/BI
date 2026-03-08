CREATE or REPLACE view "Insolvence_v_ISIR" FOLDER= AS 

SELECT distinct	op."Název specifického cíle/opatření" as "Opatření" , 
	p."Registrační číslo projektu" ,
	w."Kód" ,
	isir."Kdy byla osoba v ISIR zrušena?"
FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil
INNER JOIN insolvencni_rejstrik isir ON isir.id_projekt = p.id


WHERE p."Registrační číslo projektu" is not null
AND isir."Existuje záznam?" = 'A' 
