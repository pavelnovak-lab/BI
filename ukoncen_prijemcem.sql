SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       p."Registraèní èíslo projektu",
       p."Název projektu CZ" ,
       p.zadatel,
       vr."Datum a èas provedení akce" "Datum odstoupeni v ISKP",
       pzf."Pøíspìvek Unie" ,
       v."Název výzvy" ,
       platba."PORADI#Poøadí finanèního plánu" ,
       platba."VYUCTPLAN#Vyúètování plán" "Plánované vyúètování",
       platba.VYUCTSKUT "Skuteènì vyúètováno",
       platba."Datum pøedlo¾ení" "Plánované pøedlo¾ení",
       schvalena."Schválena" "Schválena v P6T",
       schvalena.datumod "Datum P6T",
       platba.wfstav ,
       platba."Èíslo ¾ádosti o platbu",
       platba.kodwfstav "Souèasný stav ®oP",
       p.kodwfstav "Stav projektu"
       
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby
-- LEFT JOIN
--      (SELECT min(hs.datumod) "datum",
--      	     hs.nositelid
--       FROM isum.v_bi_UmsWFHistorieStavu hs
--       WHERE hs.stavdo = 'P4'				
--       GROUP BY hs.nositelid ) prvnipredlozeni ON prvnipredlozeni.NositelId = platba.id 
LEFT JOIN
     (SELECT 'Ano' AS  "Schválena" ,
     	     hs.datumod,
     	     hs.nositelid
      FROM isum.v_bi_UmsWFHistorieStavu hs
      WHERE hs.stavdo = 'P6T') schvalena ON schvalena.NositelId = platba.id 
LEFT JOIN isum.v_bi_umzprjggvraceni vr ON vr.id_nositelvraceni = p.id AND vr."Správce projektu, který proved" is not null 

INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 

WHERE p."Registraèní èíslo projektu" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4')
-- AND platba."Závìreèná platba" = 'A'
-- AND SUBSTR(p.kompetencniutvar, 6) = 'Aplikace'
-- AND p."Registraèní èíslo projektu" = 'CZ.01.3.10/0.0/0.0/18_183/0017459'
-- AND (platba."VYUCTPLAN#Vyúètování plán" = 0 OR platba.VYUCTSKUT = 0)
AND p."Projekt ukonèen pøíjemcem" = 'A'
AND platba."PORADI#Poøadí finanèního plánu" is not null 
AND (p.kodwfstav like ('PN4%') OR p.kodwfstav like ('PP3%') OR p.kodwfstav like ('PP4%'))
AND platba.SOUCTOVYRADEK is null 

ORDER BY
-- vr."Datum a èas provedení akce" DESC,
p."Registraèní èíslo projektu", platba."PORADI#Poøadí finanèního plánu" 

----------------------------------------

SELECT *

FROM isum.v_bi_umzprjggvraceni


----------------------------------------
SELECT platba."Èíslo ¾ádosti o platbu",
       REPLACE(REPLACE(platba."Úprava/zamítnutí ¾ádosti o pla",CHR(10),' $ '),CHR(13),' $ ') "·Úprava/zamítnutí",
       -- platba."Úprava/zamítnutí ®oP z dùvodù",
       REPLACE(REPLACE(platba.Zduvodneniplatby,CHR(10),' $ '),CHR(13),' $ ')ZDUVODNENIPLATBY 
       
FROM isum.v_bi_UmpPlatbaPrj platba

WHERE platba."Èíslo ¾ádosti o platbu" like 'CZ.01.%'
-- AND platba."Èíslo ¾ádosti o platbu" like 'CZ.01.1.02/0.0/0.0/19_262/0020236%'
AND platba.ZDUVODNENIPLATBY is not null 

----------------------------------------

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
(UPPER(platba."Úprava/zamítnutí ¾ádosti o pla") like '%Z®OP%' OR UPPER(platba."Úprava/zamítnutí ¾ádosti o pla") like '%ZZOP%')
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
-- AND platba."Èíslo ¾ádosti o platbu" = 'CZ.01.2.06/0.0/0.0/16_005/0000003/2017/009/POST'
AND schvalena."datum" >= (:P5T_DatumOD)
