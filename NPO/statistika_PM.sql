SELECT	ak.nazev "Manažer projektu" ,
	count(CASE WHEN p.kodwfstav in ('PP20','PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','PU21','PU27','V2','V5','Z1','Z3') then p.id ELSE null END) "Před RoPD, PP",
       count(CASE WHEN p.kodwfstav in ('PN20a','PN20b','PN21','PN22','PN29') then p.id ELSE null END) "Před RoPD, PN",
       count(CASE WHEN p.kodwfstav in ('PP30') then p.id ELSE null END) "V PP30",
       count(CASE WHEN p.kodwfstav in ('PN40a','PN40b') then p.id ELSE null END) "Po RoPD, PN",
       count(CASE WHEN p.kodwfstav in ('PP36','PP37','PP40','PP41','PP42','PP43','PU30') then p.id ELSE null END) "Po PP36 včetně",
       count(zop.id) "Neadministrovaných ŽoP",

       avg (trunc(sysdate) -  trunc(CASE WHEN zop.id = platba.id then platba."Datum změny stavu" END) ) "Průměnrně dní ŽoP P4",
       max (trunc(sysdate) -  trunc(CASE WHEN zop.id = platba.id then platba."Datum změny stavu" END) ) "Nejdelší doba ŽoP P4",
       count ( CASE WHEN platba.kodwfstav IN ('P5T','P6','P6T','P10','P11','P7','P7T','P8','P8T','P9','P9T') THEN platba.id END ) "Počet scvhálených ŽoP" ,

       count (zoz.id)  "Neadministrovaných ŽoZ",
       avg (trunc(sysdate) - trunc( CASE WHEN zoz.id = zozky.id THEN zozky.wfstavdatum END ) )  "Průměnrně dní ŽoZ P1",

       count(p.id) "Celkem projektů"
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMZProjOdpovedn ak ON ak.ID_PRJGG = p.id AND ak.PLATNYUZIVATEL = 'A' AND ak.DATUMDO is null 
LEFT JOIN (
     SELECT
     platba.id_nositelplatby,
     platba.id,
     count(hs.id) 
     FROM isum.v_bi_UmpPlatbaPrj platba 
     INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.nositelid = platba.id 
     WHERE hs.stavdo = 'P4'
     AND platba.kodwfstav = 'P4'
     AND platba."Číslo žádosti o platbu" like 'CZ.31.3.0/0.0/0.0/22_00%'
     HAVING count(hs.id) = 1
     GROUP BY platba.id_nositelplatby,
     	      platba.id
	) zop ON  zop.id_nositelplatby = p.id
LEFT JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_nositelplatby AND platba."Číslo žádosti o platbu" like 'CZ.31.3.0/0.0/0.0/22_00%'

LEFT JOIN (
     SELECT zoz.id,
     	    zoz.id_zad,
     	    count(hs.id) 
     FROM isum.v_bi_UmzZoZProjekt zoz -- ON zoz.id_zad = p.id
     INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.nositelid = zoz.id 
     WHERE hs.stavdo = 'P1'
     AND zoz.kodwfstav = 'P1'
     AND zoz.id_vyzva in (1482646063, 1535151127) -- 31_22_001, 31_22_005
     HAVING count(hs.id) = 1
     GROUP BY  zoz.id, zoz.id_zad
     ) zoz ON  zoz.id_zad = p.id
LEFT JOIN isum.v_bi_UmzZoZProjekt zozky ON zoz.id = zozky.id AND zozky.id_vyzva in (1482646063, 1535151127) -- 31_22_001, 31_22_005

WHERE p.id_vyzva in (1482646063, 1535151127) -- 31_22_001, 31_22_005
-- AND ak.nazev = 'Hála Zdeněk, Ing.'

GROUP BY ak.nazev

ORDER BY count(p.id) DESC 
