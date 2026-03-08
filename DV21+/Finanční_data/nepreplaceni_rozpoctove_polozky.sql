-- CREATE OR REPLACE VIEW rozpracovane_iskp_rozpocet_vpo FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/projekty' AS
SELECT op."Název specifického cíle/opatření" as "Opatření" ,
    v."Číslo výzvy",
    p."Registrační číslo projektu" ,
    w."Kód",
    p."Datum změny stavu",
    pr."Kód" "Kód položky" ,
    pr."Název" "Název položky",
    pr."Částka celkem" "Částka na rozpočtu" 
    -- propl."Schváleno" "Částka na ŽoP"
    

FROM projekt AS p
INNER JOIN ciselnik_stav_workflow AS w ON p.id_wfstav = w.id
INNER JOIN vyzva AS v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 
INNER JOIN rozpocet_hlavicka AS hr ON hr.id_nrozpocet = p.id
INNER JOIN rozpocet_skupina AS sr ON hr.id_skupina = sr.id
INNER JOIN rozpocet_skupina_polozka rsp ON rsp.id_predpis = sr.id 
INNER JOIN rozpocet_polozka AS pr ON pr.id_hlavicka = hr.id
      -- soulad položky rozpočtu na SR = SD a na rozpočtu
      AND pr.id_rozpis = rsp.id 
INNER JOIN (SELECT sum(sd."Schválené způsobilé výdaje") "Schváleno",
      	   	   pl.id_nositelplatby,
		   sd.id_polozka
      	    FROM platba pl --  ON pl.id_nositelplatby = p.id
	    INNER JOIN soupiska_doklad sd ON sd.id_platba = pl.id
	    GROUP BY pl.id_nositelplatby, sd.id_polozka)
	    AS propl ON propl.id_polozka = rsp.id AND propl.id_nositelplatby = p.id 



WHERE hr."Aktuální" = 'A'
AND rsp."Listová" = 'A'

AND p."Registrační číslo projektu" IS NOT NULL
AND p."Registrační číslo projektu" = 'CZ.01.01.02/01/23_023/0001998'
AND pr."Kód" = '1.1.1.2'
-- AND rsp."Kód" = '1.1.1.2'




----------------------------------------

SELECT rp.* , sd.*, hr.*

FROM rozpocet_polozka rp
INNER JOIN rozpocet_hlavicka AS hr ON hr.id = rp.id_hlavicka
INNER JOIN soupiska_doklad sd ON sd.id_polozka = rp.id 

WHERE sd.id = 414308975
