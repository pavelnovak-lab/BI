SELECT p."Registraèní èíslo projektu" ,
       platba."Èíslo ¾ádosti o platbu" ,
       platba."Závìreèná platba",
       posledni.datum "Datum proplaceí závìreèné ®oP"  ,
       hs.datumod "Datum proplaceí poslední ®oP",
       posledni.czop "Èíslo poslední ®oP",
       posledni.kodwfstav "WFSTAV závìreèné ®oP",
       platba.kodwfstav 
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = platba.id 
INNER JOIN
( SELECT platba."Datum zmìny stavu" datum,
  	 platba.id_NositelPlatby,
	 platba."Èíslo ¾ádosti o platbu" czop,
	 platba.kodwfstav 
  FROM isum.v_bi_UmpPlatbaPrj platba
  WHERE platba.kodwfstav IN ('P10','P11')
  -- AND platba.id_NositelPlatby = 611966416
  AND platba."Závìreèná platba" = 'A' ) posledni ON posledni.id_NositelPlatby = p.id

WHERE p."Registraèní èíslo projektu" is not null
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND platba."Závìreèná platba" = 'N'
AND hs.stavdo IN ('P10','P11')
AND platba.kodwfstav like 'P1%'
AND posledni.datum < hs.datumod
-- AND platba.id_NositelPlatby = 611966416


Kod IN ['CZ.01.1.02/0.0/0.0/19_297/0019593','CZ.01.1.02/0.0/0.0/17_170/0015246','CZ.01.2.111/0.0/0.0/16_047/0007731']



