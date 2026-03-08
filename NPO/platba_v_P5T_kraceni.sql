select	platba."Èíslo ¾ádosti o platbu",
       sum(kor.vyse) "Celkovì kráceno",
       LISTAGG(DISTINCT ci.nazev, '; ') "Typ korekce"
	
FROM isum.v_bi_UmpPlatbaPrj platba
INNER JOIN  isum.v_bi_UMPKorekce kor  ON kor.id_platba = platba.id
INNER JOIN  isum.v_bi_UMSCisTypKorekce ci ON ci.id =  kor.id_typkorekce


WHERE platba."Èíslo ¾ádosti o platbu" = 'CZ.31.3.0/0.0/0.0/22_001/0005146/2024/001/POST'

GROUP BY platba."Èíslo ¾ádosti o platbu" 

----------------------------------------

SELECT kor.id_platba ,
       sum(kor.vyse) "Celkovì kráceno",
       LISTAGG(DISTINCT ci.nazev, '; ') "Typ korekce"

FROM isum.v_bi_UMPKorekce kor  
LEFT JOIN isum.v_bi_UMSCisTypKorekce ci ON ci.id =  kor.id_typkorekce

WHERE kor.souctovyradek is null 

GROUP BY kor.id_platba


----------------------------------------

SELECT DECODE (SUBSTR(p.KodPrioritniOsa, 4), 1, '1.3', 
                             2, '1.5', 
                             3, '2.3', 
                             5, '2.7',
                             
                                '¾ádná')  "Komponenta NPO",
       v."Èíslo výzvy",
       v."Název výzvy",
       p.id "id_projekt",
       p."Registraèní èíslo projektu" "Èíslo projektu",
       vs."IÈ",
       vs."Název subjektu" "Pøíjemce",
       ci."Název" "Právní forma",
       cis."Název" "Velikost podniku" ,
       platba."Úprava/zamítnutí ¾ádosti o pla",
       platba."Èíslo ¾ádosti o platbu",       
       platba.id "id_platba",
       platba.id_NositelPlatby,
       platba."Závìreèná platba",
       platba."PORADI#Poøadí finanèního plánu" "Poøadí ®oP",
       platba."Zálohová platba",
       platba.kodwfstav ,
       platba."Datum zmìny stavu" "Datum souèasného stavu ®oP" ,
       max(hs.datumod) "Datum posledního P5T" ,
       count(hs.datumod),
       sum(kor.vyse) "Celkovì kráceno",
       LISTAGG(DISTINCT ci.nazev, '; ') "Typ korekce"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_hosppravforma
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_velikostpodniku
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.Nositelid = platba.id
LEFT JOIN isum.v_bi_UMPKorekce kor ON kor.id_platba = platba.id
INNER JOIN isum.v_bi_UMSCisTypKorekce ci ON ci.id =  kor.id_typkorekce

WHERE
p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43')
AND p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.5','31.26') 
AND hs.stavdo = 'P5T'
AND platba."Datum zmìny stavu" >= (:P5T_DatumOD)
AND platba.kodwfstav in ('P5T','P8T')
-- AND platba."Èíslo ¾ádosti o platbu" = 'CZ.31.3.0/0.0/0.0/22_001/0005146/2024/001/POST'


GROUP BY platba."Èíslo ¾ádosti o platbu",       
       platba.id,
       platba.id_NositelPlatby,
       platba."Závìreèná platba",
       platba."PORADI#Poøadí finanèního plánu",
       platba."Zálohová platba",
       platba.kodwfstav ,
       platba."Datum zmìny stavu",
      SUBSTR(p.KodPrioritniOsa, 4),
       v."Èíslo výzvy",
       v."Název výzvy",
       p.id,
       p."Registraèní èíslo projektu",
       vs."IÈ",
       vs."Název subjektu",
       ci."Název",
       cis."Název",
       platba."Úprava/zamítnutí ¾ádosti o pla"
