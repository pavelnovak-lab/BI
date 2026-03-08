SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       p."Registraèní èíslo projektu" ,
       p."Datum registrace ¾ádosti",
       hs.datumod "Pøepnutí po FNaP" ,
       hs.stavdo "Stav po FNaP",
       v."Název výzvy" ,
       v."Èíslo výzvy" ,
       hodnotitel."Název" "PM",
       komp."Datum vyjádøení" "Datum pøijetí nominace",
       (select count(*) 
	    from isum.V_BI_UMSKALENDAR r 
	    where r.datum between trunc(komp."Datum vyjádøení") and trunc(hs.datumod)
	    and r.dentydne not in (6,7) 
	    and r.SVATEK='N') AS "Poèet pracovních dní"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.stavdo IN ('PP22','PP21','PN20a','PN20b')
INNER JOIN isum.v_bi_UMVHodnotitelKomp komp ON komp.id_noshodnoceni = p.id  AND komp."Nominace pøijata" = 'A' AND komp.ID_DRUHHODN = 1175378 AND komp."Schvalovatel" = 'N'
INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = komp.id_hodnotitel

WHERE p.kodwfstav in ('PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','PU27','V5','PP30','PP36','PP37','PP40','PP41','PP42','PP43','PU30') 
-- AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND v."Èíslo výzvy" = '01_20_358'
