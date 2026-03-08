SELECT	SUBSTR(p.kompetencniutvar, 10) AS "Komponenta NPO" ,
	p.zadatel,
	platba."Èíslo ¾ádosti o platbu" ,
	platba."Export do ÚIS",
	platba.kodwfstav ,
	platba."Datum zmìny stavu" ,
	LISTAGG( odp.nazev, ', ') "Mana¾er projektu"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN
     (SELECT hs.nositelid,
     	     max(hs.stavdo)
      FROM isum.v_bi_UmsWFHistorieStavu hs
      WHERE hs.stavdo in ('P10','P11','P5','P5T','P6','P6T') 
      GROUP BY hs.nositelid ) prvnipredlozeni ON prvnipredlozeni.NositelId = platba.id 
INNER JOIN isum.v_bi_UmzProjoDpovedn odp ON odp.id_prjgg = p.id

WHERE p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5')
AND ( platba."Export do ÚIS" = 'N' OR platba."Export do ÚIS" is null )
AND odp."DATUMDO" is null
-- AND p."Registraèní èíslo projektu" IN ('CZ.31.3.0/0.0/0.0/22_001/0001634')

GROUP BY  "Komponenta NPO" ,
	p.zadatel,
	platba."Èíslo ¾ádosti o platbu" ,
	platba."Export do ÚIS",
	platba.kodwfstav ,
	platba."Datum zmìny stavu" 
