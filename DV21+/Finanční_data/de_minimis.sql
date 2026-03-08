CREATE or REPLACE view "VPo_de_minimis_proplaceno_vs_rozpocet" FOLDER= AS 
SELECT op.nazev as "Opatření" ,
       p."Registrační číslo projektu" ,
       w."Kód" "Kód stavu" ,
       dm_zv."Částka celkem" ,
       sum(sd."Schválené způsobilé výdaje") "Schválené způsobilé výdaje",
       dm_zv."Částka celkem" - sum(sd."Schválené způsobilé výdaje") "Rozdíl ZV"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN (SELECT sum(pr."Částka celkem") "Částka celkem",
      	   	   hr.id_nrozpocet
	    FROM rozpocet_hlavicka hr
	    INNER JOIN rozpocet_polozka pr ON pr.id_hlavicka = hr.id
	    WHERE hr."Aktuální" = 'A'
	    AND pr."Kód" IN ('1.2.1.4','1.2.2.1')
	    GROUP BY hr.id_nrozpocet ) dm_zv ON dm_zv.id_nrozpocet = p.id 
INNER JOIN platba pl ON pl.id_nositelplatby = p.id
INNER JOIN soupiska_doklad sd ON pl.id = sd.id_platba
INNER JOIN rozpocet_polozka polsd ON polsd.id = sd.id_polozka



WHERE p."Registrační číslo projektu" is not null
AND v."Číslo výzvy" = '01_22_006'
AND polsd."Kód" IN ('1.2.1.4','1.2.2.1')
AND w."Kód" like 'PP4%'
-- AND p."Registrační číslo projektu" = 'CZ.01.04.01/01/22_006/0002192'

GROUP BY op.nazev ,
       p."Registrační číslo projektu" ,
       dm_zv."Částka celkem" ,
       "Kód stavu"


ORDER BY "Rozdíl ZV" DESC 
