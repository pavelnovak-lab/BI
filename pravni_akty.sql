CREATE or REPLACE view "Právní_akty" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Projekty/Reporting' AS 
SELECT p."Registraèní èíslo projektu" ,
       pa."Název" "Typ PA",
       null "Typ kod" ,
       pwf."Kód" "Kód WFSTAV stav" ,
       pwf."Název" "Název stavu",
       hs."Zmìnil/a",
       hs."Datum zmìny"
       
FROM projekt p 
INNER JOIN smlouva s ON s.id_nositelsml = p.id
INNER JOIN ciselnik_stav_workflow w ON s.id_wfstav = w.id
INNER JOIN historie_stavu hs ON hs.nositelid = s.id
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo 
INNER JOIN ciselnik_typ_pravniho_aktu pa ON pa.id = s.id_typ

WHERE w."Kód" = 'P4'
AND pwf."Kód" = 'P4'
-- AND p."Registraèní èíslo projektu" = 'CZ.01.02.01/04/23_017/0002587'

----------------------------------------
select	 "V_BI_UMZPROJEKT"."Registraèní èíslo projektu" as "Registraèní èíslo projektu",
	 "V_BI_UMFSMLOUVA"."TYP" as "TYP",
	 "V_BI_UMFSMLOUVA"."TYPKOD" as "TYPKOD",
	 "V_BI_UMFSMLOUVA"."KODWFSTAV" as "KODWFSTAV",
	 "V_BI_UMFSMLOUVA"."WFSTAV" as "WFSTAV",
	 "V_BI_UMFSMLOUVA"."LAST_MODIF_UZIVATEL" as "LAST_MODIF_UZIVATEL",
	 "V_BI_UMFSMLOUVA"."LAST_MODIF_CAS" as "LAST_MODIF_CAS" 
 from	"ISUM"."V_BI_UMZPROJEKT" "V_BI_UMZPROJEKT",
	"ISUM"."V_BI_UMFSMLOUVA" "V_BI_UMFSMLOUVA" 
 where   "V_BI_UMZPROJEKT"."ID"="V_BI_UMFSMLOUVA"."IDPROJEKT"
  and 	 "V_BI_UMZPROJEKT"."Registraèní èíslo projektu" like '%CZ.31%'
  and 	 "V_BI_UMFSMLOUVA"."TYP" is not null 
   and	 "V_BI_UMFSMLOUVA"."KODWFSTAV" ='P4'
