SELECT
SUBSTR(p.KodPrioritniOsa, 4) "Prioritní osa",
       v."Číslo výzvy",
       v."Název výzvy",
       p.id "id_projekt",
       p."Registrační číslo projektu" "Číslo projektu",
       vs."IČ",
       vs."Název subjektu" "Příjemce",
       ci."Název" "Právní forma",
       cis."Název" "Velikost podniku" ,
       platba."Číslo žádosti o platbu",       
       platba.id "id_platba",
       platba.id_NositelPlatby,
       platba."Závěrečná platba",
       platba."PORADI#Pořadí finančního plánu" "Pořadí ŽoP",
       platba."Zálohová platba",
       platba.kodwfstav ,
       platba."Datum změny stavu" "Datum současného stavu ŽoP" ,
       max(hs.datumod) "Datum posledního P5T"
    
FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.neplatny is null AND vs.id_typsubjektu = 300784 AND vs.id_typsubjektuEdit = 300798 -- zadatel 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_hosppravforma
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vs.id_velikostpodniku
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.Nositelid = platba.id

WHERE p.kodwfstav in ('PP36','PP37','PP40','PP41','PP42','PP43')
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
-- AND p."Registrační číslo projektu" is not null
-- AND p."Registrační číslo projektu" = 'CZ.01.3.10/0.0/0.0/19_251/0021594'
-- AND p.id = 607618632
AND p."Registrační číslo projektu" in ('CZ.01.1.02/0.0/0.0/19_297/0019594','CZ.01.3.10/0.0/0.0/19_316/0023140', 'CZ.01.3.10/0.0/0.0/19_251/0022684')
AND hs.stavdo = 'P5T'
AND hs.datumod >= (:P5T_DatumOD)
AND platba.kodwfstav in ('P5T','P6','P6T','P7','P7T','P8','P8T','P9','P9T','P10','P11','P12','P13','P13T','P14','P14T')



GROUP BY platba."Číslo žádosti o platbu",       
       platba.id,
       platba.id_NositelPlatby,
       platba."Závěrečná platba",
       platba."PORADI#Pořadí finančního plánu",
       platba."Zálohová platba",
       platba.kodwfstav ,
       platba."Datum změny stavu",
      SUBSTR(p.KodPrioritniOsa, 4),
       v."Číslo výzvy",
       v."Název výzvy",
       p.id,
       p."Registrační číslo projektu",
       vs."IČ",
       vs."Název subjektu",
       ci."Název",
       cis."Název"

-------------------------------------------------------------------------------------------------------------------------------------------
SELECT platba."Číslo žádosti o platbu",       
       platba.id,
       platba.id_NositelPlatby,
       platba."Závěrečná platba",
       platba."PORADI#Pořadí finančního plánu" "Pořadí ŽoP",
       platba."Zálohová platba",
       platba.kodwfstav ,
       platba."Datum změny stavu" "Datum současného stavu ŽoP" ,
       max(hs.datumod) "Datum posledního P5T"
       

WHERE platba.kodwfstav in ('P5T','P6','P6T','P7','P7T','P8','P8T','P9','P9T','P10','P11','P12','P13','P13T','P14','P14T')

GROUP BY platba."Číslo žádosti o platbu",       
       platba.id,
       platba.id_NositelPlatby,
       platba."Závěrečná platba",
       platba."PORADI#Pořadí finančního plánu",
       platba."Zálohová platba",
       platba.kodwfstav ,
       platba."Datum změny stavu"


--------------------------------------------
SELECT


FROM 

WHERE hs.stavdo = 'P5T'
AND hs.datumod >= (:P5T_DatumOD)

GROUP BY hs.NositelId
