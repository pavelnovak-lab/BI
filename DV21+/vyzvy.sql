CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 
select 	v."Èíslo výzvy",
	v."Název výzvy",
        sc."Název specifického cíle",
        sc."Èíslo SC/opatøení ØO formát",
        v."Datum zpøístupnìní ¾ádostí o podporu",
        v."Datum zahájení pøíjmu ¾ádostí o podporu",
        v."Datum ukonèení pøíjmu ¾ádostí o podporu",
        v."Datum vyhlá¹ení výzvy",
	w."Kód",
	v."Název"
from vyzva v
inner join vyzva_hierarchie h on h.id_vyzva = v.id
inner join specificky_cil sc on h.id_speccil = sc.id
INNER JOIN ciselnik_stav_workflow w ON w.id = v.id_wfstav

WHERE v."Èíslo výzvy" not like 'CLLD%'
AND v."Èíslo výzvy" = '01_22_003'
