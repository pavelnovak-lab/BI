SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory", 
       p."Registraèní èíslo projektu",
       pol."Kód",
       pol."Název" "Název polo¾ky",
       pol."Èástka celkem" "Èástka na rozpoètu",
       p.kodwfstav wfstav,
       -- pol.id_hlavicka,
       sum(s.VYDAJESCHVAL) "Èástka na ®oP celkem",
       -- count(platba.id) "Poèet ®oP"
       listagg(DISTINCT platba."PORADI#Poøadí finanèního plánu", '; ') WITHIN GROUP (ORDER BY platba."PORADI#Poøadí finanèního plánu" ASC) "Èísla ®oP",
       count(s.id) "Poèet dokladù"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMFROZHlavickaPrj hl ON p.id = hl.id_nrozpocet AND hl."Aktuální" = 'A'
INNER JOIN isum.V_BI_UMFROZPOLOZKYPRJ pol ON pol.id_hlavicka = hl.id 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby 
INNER JOIN isum.V_BI_UMFSOUPISKADOKLADPRJ s ON platba.ID=s.ID_PLATBA --  AND pol.id = s.id_polozka
INNER JOIN isum.V_BI_UMFROZPolozky polsou ON s.id_polozka = polsou.id

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND platba.kodwfstav in ('P5','P5T','P6','P6T','P7','P8','P8T','P9T','P9','P10','P11') 
AND (pol.LISTOVA = 'A' and ( (pol."Èástka celkem" is null) or pol."Èástka celkem" = 0 ) )
-- AND platba.id = 200957835
-- AND p."Registraèní èíslo projektu" = 'CZ.01.3.10/0.0/0.0/15_010/0000145'
AND p."Registraèní èíslo projektu" = 'CZ.01.3.10/0.0/0.0/18_183/0016514'
-- AND pol."Kód" = '1.2.1.2'
-- AND pol."Aktuální rozpoèet" = 'A'
AND s.vydajeschval > 0
AND polsou."Kód" = pol."Kód"
AND p.kodwfstav in ('PP30','PP36','PP37','PU30') 

GROUP BY p."Registraèní èíslo projektu",
       pol."Kód",
       pol."Název",
       pol."Èástka celkem" ,
       SUBSTR(p.kompetencniutvar, 6),
       p.kodwfstav 

HAVING sum(s.VYDAJESCHVAL) > 0



ORDER BY substr(p."Registraèní èíslo projektu",-5,5) asc, pol."Kód", pol."Kód"


--------------------------------------------

SELECT platba."Èíslo ¾ádosti o platbu" ,
       platba."PORADI_Poøadí_finanèního_plánu" ,
       s."Celková èástka \nuvedená na do" "Èástka celkem"
       s.id_polozka
       

FROM
-- isum.v_bi_UmzProjekt p 
INNER JOIN
isum.v_bi_UmpPlatbaPrj platba
-- ON p.id=platba.id_NositelPlatby
INNER JOIN isum.V_BI_UMFSOUPISKADOKLADPRJ s ON platba.ID=s.ID_PLATBA

WHERE platba.id = 24842282


---------------------------------
SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory", 
       p."Registraèní èíslo projektu",
       pol."Kód",
       pol."Název" "Název polo¾ky",
       pol."Èástka celkem" "Èástka na rozpoètu",
       sum(s.VYDAJESCHVAL) "Èástka na ®oP celkem",
       -- count(platba.id) "Poèet ®oP"
       -- listagg(DISTINCT platba."PORADI#Poøadí finanèního plánu", '; ') WITHIN GROUP (ORDER BY platba."PORADI#Poøadí finanèního plánu" ASC) "Èísla ®oP",
       count(s.id) "Poèet dokladù"
       
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMFROZHlavickaPrj hl ON p.id = hl.id_nrozpocet AND hl."Aktuální" = 'A'
INNER JOIN isum.V_BI_UMFROZPOLOZKYPRJ pol ON pol.id_hlavicka = hl.id 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id = platba.id_NositelPlatby AND platba.id = 692422841
LEFT JOIN isum.V_BI_UMFSOUPISKADOKLADPRJ s ON platba.ID=s.ID_PLATBA AND pol.id = s.id_polozka

WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
-- AND platba.kodwfstav in ('P5','P5T','P6','P6T','P7','P8','P8T','P9T','P9','P10','P11') 
AND (pol.LISTOVA = 'A')
-- and ( (pol."Èástka celkem" is null) or pol."Èástka celkem" = 0 ) )
AND p."Registraèní èíslo projektu" = 'CZ.01.3.10/0.0/0.0/18_183/0016514'

GROUP BY p."Registraèní èíslo projektu",
       pol."Kód",
       pol."Název",
       pol."Èástka celkem" ,
       SUBSTR(p.kompetencniutvar, 6)

-- HAVING sum(VYDAJESCHVAL) > 0


ORDER BY substr(p."Registraèní èíslo projektu",-5,5) asc, pol."Kód"


---------------------------------
SELECT rozpol."Èástka celkem", -- èástka za 10 let na roèním rozpoètu
       platba.CISLOPLATBYZKR "Zkrácené èíslo ®oP",
       s.vydajeschval

FROM isum.v_bi_UmpPlatbaPrj platba 
INNER JOIN isum.V_BI_UMFSoupiskaDokladPRJ s ON platba.ID=s.ID_PLATBA
INNER JOIN isum.V_BI_UMFROZPolozky rozpol ON s.id_polozka = rozpol.id


WHERE  platba.id = 692422841
AND rozpol."Kód" = '1.2.1.7'
---------------------------------
SELECT pol.*

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMFROZHlavickaPrj hl ON p.id = hl.id_nrozpocet AND hl."Aktuální" = 'A'
INNER JOIN isum.V_BI_UMFROZPOLOZKYPRJ pol ON pol.id_hlavicka = hl.id 

WHERE p."Registraèní èíslo projektu" = 'CZ.01.3.10/0.0/0.0/18_183/0016514'
