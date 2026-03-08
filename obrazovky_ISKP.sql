-- SELECT DISTINCT frm.Nazev,
--        frm.MENUNODE,
--        frm.id "ID Formuláø"

SELECT *


FROM isum.v_bi_UMSFormular frm
INNER JOIN isum.v_bi_UMZVyzvaForm vf ON vf.id_formular = frm.id
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=vf.id_vyzva 

WHERE v."Èíslo výzvy" is not null
AND vf."Poøadí obrazovky v rámci úlohy" is not null






-------------------------------------------------------
SELECT	v."Èíslo výzvy" ,
	v."Název výzvy",
	-- f.nazev,
	form."1 kolo",
	form."2 kolo",
	form."Pøed PA",
	form."Poøadí obrazovky v rámci úlohy"
--	cf.*

FROM isum.v_bi_UmzVyzva v 
INNER JOIN isum.v_bi_UMZVyzvaForm form ON form.id_vyzva = v.id
INNER JOIN isum.v_bi_UMSFormular f ON form.id_formular = f.id 
-- INNER JOIN isum.v_bi_CFormular cf ON f.id_formular = cf.id
-- isum.v_bi_UmsCisSeznam

WHERE v."Èíslo výzvy" = '31_22_017'
-- "Název" like '%ISKP%'


select "V_BI_UMSCISZAKLADNI_6"."Název" as "Typ_kontroly",
"V_BI_UMVKONTROLANAMISTE"."CELKEMZOP" as "CELKEM ®oP",
	 "V_BI_UMVKONTROLANAMISTE"."KOD#Èíslo kontroly" as "Èíslo kontroly",
	 "V_BI_UMPPLATBA"."Èíslo ¾ádosti o platbu" as "Èíslo ¾ádosti o platbu",
	 "V_BI_UMVKONTROLANAMISTE"."ID_NOSITELKONTROLY" as "ID_NOSITELKONTROLY",
	 "V_BI_UMZPROJEKT"."Registraèní èíslo projektu" as "Registraèní èíslo projektu",
         "V_BI_UMZVYZVA"."Èíslo výzvy" as "Èíslo výzvy",
	 "V_BI_UMZVYZVA"."ID" as "ID",
	 "V_BI_UMPCASTKY"."VYUCTCZVCELK" as "Po¾adováno",
	 "V_BI_UMPPLATBA"."ID_POZADOVANECASTKY" as "ID_POZADOVANECASTKY",
	 "V_BI_UMPCASTKY_1"."VYUCTCZVCELK" as "Schváleno",
	 "V_BI_UMPCASTKY_1"."ID" as "ID_1",
	 "V_BI_UMPCASTKY_3"."ID" as "ID_1_1",
	 "V_BI_UMPCASTKY_3"."VYUCTCZVCELK" as "Rozdíl",
	 "V_BI_UMPPLATBA"."ID_ROZDILKOREKCE" as "ID_ROZDILKOREKCE",
	 "V_BI_UMZVYZVA"."OP kod" as "OP kod",
	 "V_BI_UMZVYZVA"."OP název" as "OP název",
	 "V_BI_UMVKONTROLANAMISTE"."ID_KONTRORGAN" as "ID_KONTRORGAN",
	 "V_BI_UMSCISKONTRORGAN"."ID" as "ID_2",
	 "V_BI_UMSCISKONTRORGAN"."Název CZ" as "Název orgánu kontroly",
	 "V_BI_UMSCISKONTRORGAN"."Nadøízená organizaèní jednotka" as "Nadøízená organizaèní jednotka",
	 "V_BI_UMSCISKONTRORGAN"."Organizaèní jednotka" as "Kontrolní orgán",
	 "V_BI_UMVKONTROLANAMISTE"."ID_WFSTAV" as "ID_WFSTAV",
	 "V_BI_UMVKONTROLANAMISTE"."Název kontroly" as "Název kontroly",
	 "V_BI_UMSCISSTAVWF"."ID" as "ID_3",
	 "V_BI_UMSCISSTAVWF"."Název stavu" as "Stav kontroly",


TO_CHAR("V_BI_UMVKONTROLANAMISTE"."Datum do",'dd.mm.yyyy') as "Kontrolované období do",
TO_CHAR( "V_BI_UMVKONTROLANAMISTE"."Datum od",'dd.mm.yyyy') as "Kontrolované období od",
TO_CHAR("V_BI_UMVKONTROLANAMISTE"."Datum ukonèení",'dd.mm.yyyy') as "Datum ukonèení",
TO_CHAR("V_BI_UMVKONTROLANAMISTE"."Datum zahájení",'dd.mm.yyyy') as "Datum zahájení",
decode("V_BI_UMVKONTROLANAMISTE"."TYPKONTROLYVYCET", '0','Kontrola na místì','1','Monitorovací náv¹tìva','2','Administrativní ovìøení') as "Druh kontroly"

 
 from	"ISUM"."V_BI_UMSCISZAKLADNI" "V_BI_UMSCISZAKLADNI_6",
"ISUM"."V_BI_UMSCISSTAVWF" "V_BI_UMSCISSTAVWF",
	"ISUM"."V_BI_UMSCISKONTRORGAN" "V_BI_UMSCISKONTRORGAN",
	"ISUM"."V_BI_UMPCASTKY" "V_BI_UMPCASTKY_3",
	"ISUM"."V_BI_UMPCASTKY" "V_BI_UMPCASTKY_1",
	"ISUM"."V_BI_UMPCASTKY" "V_BI_UMPCASTKY",
	"ISUM"."V_BI_UMZVYZVA" "V_BI_UMZVYZVA",
	"ISUM"."V_BI_UMZPROJEKT" "V_BI_UMZPROJEKT",
	"ISUM"."V_BI_UMPPLATBA" "V_BI_UMPPLATBA",
	"ISUM"."V_BI_UMVKONTROLANAMISTE" "V_BI_UMVKONTROLANAMISTE"


 where   "V_BI_UMSCISZAKLADNI_6"."ID"="V_BI_UMVKONTROLANAMISTE"."ID_TYPKONTROLY"
and
"V_BI_UMPPLATBA"."ID"="V_BI_UMVKONTROLANAMISTE"."ID_ZOP"
 and	 "V_BI_UMZPROJEKT"."ID"="V_BI_UMVKONTROLANAMISTE"."ID_NOSITELKONTROLY"
 and	 "V_BI_UMZVYZVA"."ID"="V_BI_UMVKONTROLANAMISTE"."ID_VYZVA"
 and	 "V_BI_UMPCASTKY"."ID"="V_BI_UMPPLATBA"."ID_POZADOVANECASTKY"
 and	 "V_BI_UMPCASTKY_1"."ID"="V_BI_UMPPLATBA"."ID_SCHVALENECASTKY"
 and	 "V_BI_UMPCASTKY_3"."ID"="V_BI_UMPPLATBA"."ID_ROZDILKOREKCE"
 and	 "V_BI_UMSCISKONTRORGAN"."ID"="V_BI_UMVKONTROLANAMISTE"."ID_KONTRORGAN"
 and	 "V_BI_UMSCISSTAVWF"."ID"="V_BI_UMVKONTROLANAMISTE"."ID_WFSTAV"

and ("V_BI_UMZVYZVA"."OP název" in (:OP)or least (:OP) is null)

and ("V_BI_UMVKONTROLANAMISTE"."Datum ukonèení" > (:Datum_ukonceni_od)
and "V_BI_UMVKONTROLANAMISTE"."Datum ukonèení" < (:Datum_ukonceni_do) 
or (:Datum_ukonceni_od) is null or (:Datum_ukonceni_do) is null)

order by "V_BI_UMZPROJEKT"."Registraèní èíslo projektu" ASC


-------------------------------------------------------
SELECT p."Registraèní èíslo projektu",
       knm.*

FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmvKontrolaNaMiste knm ON p.id = knm.id_nositelkontroly

WHERE knm."KOD#Èíslo kontroly" like '017571%'
