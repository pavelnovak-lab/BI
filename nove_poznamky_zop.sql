SELECT p."Registraèní èíslo projektu" ,
       p.kodwfstav "Stav projektu" ,
       platba."Èíslo ¾ádosti o platbu" ,
       platba."Úprava/zamítnutí ¾ádosti o pla",
       platba."Závìreèná platba" ,
       platba.kodwfstav,
       platba.VYUCTSKUT "Vyúètováno",
       schvalena."datum" 
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
LEFT JOIN
     (SELECT max(hs.datumod) "datum",
     	     hs.nositelid
	     
      FROM isum.v_bi_UmsWFHistorieStavu hs
      WHERE hs.stavdo = 'P5T'				
      GROUP BY hs.nositelid ) schvalena ON schvalena.NositelId = platba.id 

WHERE 
-- platba."Úprava/zamítnutí ¾ádosti o pla" is not null
(UPPER(platba."Úprava/zamítnutí ¾ádosti o pla") like '%Z®OP%' OR UPPER(platba."Úprava/zamítnutí ¾ádosti o pla") like '%ZZOP%') AND 

p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
-- AND platba."Èíslo ¾ádosti o platbu" = 'CZ.01.2.06/0.0/0.0/16_005/0000003/2017/009/POST'
AND schvalena."datum" >= (:P5T_DatumOD)


----------------------------------------

SELECT
SUBSTR(p.KodPrioritniOsa, 4) "Prioritní osa",
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
       count(hs.datumod)
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_hosppravforma
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_velikostpodniku
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.Nositelid = platba.id

WHERE
p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43')
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND hs.stavdo = 'P5T'
AND platba."Datum zmìny stavu" >= (:P5T_DatumOD)
AND platba.kodwfstav in ('P5T','P8T')
AND platba."Úprava/zamítnutí ¾ádosti o pla" is not null 


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
       
