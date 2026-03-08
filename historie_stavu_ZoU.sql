SELECT p."Registrační číslo projektu" ,
	-- p.zadatel,
	zi."Pořadové číslo ZoR/IoP" "Číslo ZoU",
	p."Počet ZoU" "Počet ZoU (z Detailu projektu)",
	zi.kodwfstav "Stav ZoU",
	p.kodwfstav "Stav projektu",
	min(hs.stavdo) "Počet průchodů stavem P1"
	
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
LEFT JOIN isum.v_bi_UMZZIProjekt zi ON zi.id_zad = p.id 
LEFT JOIN isum.v_bi_UMZCisTypZI ct ON ct.id = zi.id_CisTypZI AND ct."Poznámka" = 'ZOU' 
LEFT JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = zi.id AND hs.stavdo ='P1' 
-- INNER JOIN isum.v_bi_UMSCisStavWF sw ON sw.id = zi.id_wfstav

WHERE  -- p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000565'
p."Registrační číslo projektu" is not null 
AND p.kodwfstav not like 'PN%'
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
-- and 


-- AND v."Číslo výzvy" IN ('31_22_014','31_22_015')

GROUP BY SUBSTR(p.kompetencniutvar, 6) ,
        v."Číslo výzvy",
	p."Registrační číslo projektu" ,
	p.zadatel,
	zi."Pořadové číslo ZoR/IoP",
	zi.kodwfstav,
	p.kodwfstav ,
	p."Počet ZoU"

ORDER BY substr(p."Registrační číslo projektu",-5,5) ASC , zi."Pořadové číslo ZoR/IoP"



----------------------------------------
SELECT
    p."Registrační číslo projektu" AS "Registrační číslo",
    p."Název projektu CZ" AS "Název projektu",

z."Sledované období od" AS "Období od",
z."Sledované období do" AS "Období do",

z."Datum předložení" AS "Plánované předložení",
z."WFSTAV" as "Stav",

-- o."NAZEV" as "PM",

-- c."Název typu ZI" as "ZI" ,

hs.mindatum "První podání ZoU",
z."Pořadové číslo ZoR/IoP",
c.hop,
hs.id_objekt

FROM
    "ISUM"."V_BI_UMZPROJEKT" p
JOIN    "ISUM"."V_BI_UMZVYZVA" v ON p."ID_VYZVA" = v."ID"
JOIN
    "ISUM"."V_BI_UMZZIPROJEKT" z ON p."ID" = z."ID_ZAD"
join "ISUM"."V_BI_UMZCISTYPZI" c on z."ID_CISTYPZI" = c."ID"
join "ISUM"."V_BI_UMZPROJODPOVEDN" o on p."ID" = o."IDPROJEKT"
LEFT JOIN (SELECT min(datumod) mindatum,
     	  	  NositelID, id_objekt
   	   FROM isum.v_bi_UmsWFHistorieStavu hs 
	   WHERE stavdo = 'P1' -- Podaná na ŘO/ZS
	   GROUP BY NositelId, id_objekt) hs ON hs.NositelId = z.id 

WHERE
    v."Číslo výzvy" IN ('31_22_001', '31_22_005') and
o."ROLE" ='MAN_PRJ' and
o."DATUMDO" is null  
and   p."Registrační číslo projektu" = 'CZ.31.3.0/0.0/0.0/22_001/0000970' --zkouším projekt kde je víc verzí

order by
 p."Registrační číslo projektu", z."Sledované období do", c.hop, z."Pořadové číslo ZoR/IoP",
c.hop

