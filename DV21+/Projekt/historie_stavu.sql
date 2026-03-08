CREATE or REPLACE view "historie_stavu_projektu" FOLDER= AS 

SELECT op.nazev as "Opatøení" , v."Èíslo výzvy" , v."Název výzvy",
       p."Registraèní èíslo projektu", wf."Kód" "Aktuální stav WF",
       pp20.pocetprepnuti - 1 AS "Poèet vrácení v PP20",
       -- Konstrukce bere z historie_stavu takové pøedposlední poøadí pøed vrácením do PP20 (do stavu PP20 kliká u¾ivatel ISKP), do pøedchozího stavu PM, který vrátil do ISKP. Dalo by se jít jistì i elegantnìji pøes PU22, ale co u¾ :-)
       max(CASE WHEN hs.nositelid = p.id AND pp20.maxporadi - 1 = hs."Poøadí" THEN hs."Datum pøepnutí"
       	   ELSE null END) "Naposledy vráceno z PP20" ,
       max(CASE WHEN hs.nositelid = p.id AND pp20.maxporadi - 1 = hs."Poøadí" THEN hs."U¾ivatel, který provedl pøepnutí stavu"
       	   ELSE null END) "Naposledy v PP20 vrátil" ,

       max(CASE WHEN hs.nositelid = p.id AND p22.maxporadi  = hs."Poøadí" THEN hs."Datum pøepnutí"
       	   ELSE null END) "Naposledy pøepnuto do PP22/PN22" ,
       max(CASE WHEN hs.nositelid = p.id AND p22.maxporadi  = hs."Poøadí" THEN hs."U¾ivatel, který provedl pøepnutí stavu"
       	   ELSE null END) "Naposledy do PP22/PN22 pøepnul" ,
       p22.maxdatum - p."Datum registrace ¾ádosti" "Poèet dní ve FNaP",
       
       max(CASE WHEN hs.nositelid = p.id AND p23.maxporadi  = hs."Poøadí" THEN hs."Datum pøepnutí"
       	   ELSE null END) "Naposledy pøepnuto do PP23*/PN23" ,
       max(CASE WHEN hs.nositelid = p.id AND p23.maxporadi  = hs."Poøadí" THEN hs."U¾ivatel, který provedl pøepnutí stavu"
       	   ELSE null END) "Naposledy do PP23*/PN23 pøepnul" ,
       p23.maxdatum - p22.maxdatum "Poèet dní ve VH",
       CASE WHEN zopr.id IS NOT NULL THEN 'A'
       	    ELSE 'N' END AS "®oPø proti VH",

       max(CASE WHEN hs.nositelid = p.id AND p25.maxporadi  = hs."Poøadí" THEN hs."Datum pøepnutí"
       	   ELSE null END) "Naposledy pøepnuto do PP25*/PN25" ,
       max(CASE WHEN hs.nositelid = p.id AND p25.maxporadi  = hs."Poøadí" THEN hs."U¾ivatel, který provedl pøepnutí stavu"
       	   ELSE null END) "Naposledy do PP25*/PN25/PU25 pøepnul" ,
       p25.maxdatum - p23.maxdatum "Poèet dní do VK"

       

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
-- Z historie stavù mì zajíma poèet pøepnutí do PP20
INNER JOIN (SELECT hs.nositelid ,
      	   	   count(hs.id) pocetprepnuti,
		   max(hs."Datum pøepnutí") maxdatum,
		   max(hs."Poøadí") maxporadi
	    FROM historie_stavu hs 
	    INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
	    WHERE pwf."Kód" = 'PP20'
	    GROUP BY hs.nositelid ) pp20 ON pp20.nositelid = p.id
LEFT JOIN (SELECT hs.nositelid ,
      	   	   count(hs.id) pocetprepnuti,
		   max(hs."Datum pøepnutí") maxdatum,
		   max(hs."Poøadí") maxporadi
	    FROM historie_stavu hs 
	    INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
	    WHERE pwf."Kód" in ('PP22', 'PN22')
	    GROUP BY hs.nositelid ) p22 ON p22.nositelid = p.id
LEFT JOIN (SELECT hs.nositelid ,
      	   	   count(hs.id) pocetprepnuti,
		   max(hs."Datum pøepnutí") maxdatum,
		   max(hs."Poøadí") maxporadi
	    FROM historie_stavu hs 
	    INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
	    WHERE pwf."Kód" in ('PP23a', 'PN23b','PN23')
	    GROUP BY hs.nositelid ) p23 ON p23.nositelid = p.id
LEFT JOIN namitka_vyberova_komise zopr ON zopr.id_noshodnoceni = p.id AND zopr."Byla ¾ádost o pøezkum  rozhodnutí VK podána?" = 'A' AND  zopr.id_druhhodn = 488571 -- VH 
LEFT JOIN (SELECT hs.nositelid ,
      	   	   count(hs.id) pocetprepnuti,
		   max(hs."Datum pøepnutí") maxdatum,
		   max(hs."Poøadí") maxporadi
	    FROM historie_stavu hs 
	    INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
	    WHERE pwf."Kód" in ('PP25a', 'PN25b','PN25','PU25')
	    GROUP BY hs.nositelid ) p25 ON p25.nositelid = p.id
LEFT JOIN (SELECT hs.nositelid ,
      	   	   count(hs.id) pocetprepnuti,
		   max(hs."Datum pøepnutí") maxdatum,
		   max(hs."Poøadí") maxporadi
	    FROM historie_stavu hs 
	    INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
	    WHERE pwf."Kód" in ('PP26', 'PN26','PU26')
	    GROUP BY hs.nositelid ) p25 ON p25.nositelid = p.id




INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN ciselnik_stav_workflow wf ON wf.id = p.id_wfstav
INNER JOIN historie_stavu hs ON hs.nositelid = p.id


WHERE --p."Registraèní èíslo projektu" is not null
-- AND
p."Registraèní èíslo projektu" = 'CZ.01.01.01/01/22_002/0000106'

GROUP BY op.nazev ,
       v."Èíslo výzvy" ,
       v."Název výzvy",
       p."Registraèní èíslo projektu",
       wf."Kód" ,
       "Poèet vrácení v PP20",
       "Poèet dní ve FNaP",
       "Poèet dní ve VH",
       "Poèet dní do VK",
       "®oPø proti VH"
-- ORDER BY p."Registraèní èíslo projektu" , p."Datum zmìny stavu"


