CREATE or REPLACE view  FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/' AS 
SELECT  op.nazev as "Opatøení" ,
	v."Èíslo výzvy" ,
        v."Název výzvy" ,
        sk."Èíslo kontrolního listu",
	sk."Název souboru kritérií" "Název KL",
	skv."Platnost od" "Platnost na výzvì od",
	skv."Platnost do" "Platnost na výzvì do",
	skv."Platný"
	-- sk."Naposledy zmìnil"

FROM vyzva v
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
LEFT JOIN soubor_kriterii_vyzvy skv ON skv.id_vyzva = v.id 
LEFT JOIN soubor_kriterii sk ON sk.id = skv.id_souborkrit AND sk.id_vardruhhodn = 283103

WHERE sk."Èíslo kontrolního listu" is not null 

ORDER BY v."Èíslo výzvy" 
