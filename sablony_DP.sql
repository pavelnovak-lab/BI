SELECT	l.kod,
	v."Èíslo výzvy" ,
	v."Název výzvy" ,
	v.wfstav,
	sdp."Název ¹ablony",
	ci."Kód" ,
	ci."Název" "Název zdroje" ,
	sdp."Poøadí",
	sdp.investice,
        sdp.typdp

FROM isum.v_bi_UmzVyzva v 
inner join isum.v_bi_umzvyzvahierarchie vh on vh.id_vyzva = v.id
inner join isum.v_bi_umshisc sh on sh.id = vh.id_speccil
inner join isum.v_bi_umshiplinie l on l.id = sh.id_osa
INNER JOIN isum.v_bi_UMZRadekSabDP sdp ON id_nositelsablony = v.id   AND id_zdrojfin = 1440201391 -- Zdroj RRF
INNER JOIN isum.v_bi_UmsCisZakladni ci ON  sdp.id_rszdroj = ci.id
INNER JOIN isum.v_bi_UMZSablonaDP sab ON sab.id = id_sablonadp


WHERE l.kod in ('31.1', '31.2', '31.3', '31.5','31.14','31.22','31.26')
AND v.wfstav IN ('Otevøená','Uzavøená','Modifikovaná')
-- AND v."Èíslo výzvy" = '31_22_005'
AND ci."Kód" like '1%'


ORDER BY l.kod, v."Èíslo výzvy" 



------------------------------

SELECT platba."Èíslo ¾ádosti o platbu",
       p.zadatel,
       platba."Datum zmìny stavu" ,
       platba.kodwfstav ,
       platba.wfstav ,
       -- dp.id_oss,
       -- dp.id_ucetoss,
       -- uc."Èíslo úètu prezentaèní forma"
       dp.REGCISLO "Detail platby",
       ci."Kód",
       ci."Název"


FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_umpklasifikace dp ON dp.id_platba = platba.id -- AND id_zdrojfin = 1440201391 -- Zdroj RRF
-- INNER JOIN isum.V_BI_UMSRSVerzeUctu uc ON uc.id = dp.id_ucetoss
-- INNER JOIN isum.v_bi_UMSCisZdrojeF zdroj ON zdroj.id = dp.id_zdrojfin
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = dp.id_zdroj


WHERE dp.druhdp = 1
AND platba.kodwfstav IN ('P5T','P6','P6T')
AND p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22','31.26') 
-- AND platba."Èíslo ¾ádosti o platbu" = 'CZ.31.5.0/0.0/0.0/22_008/0003746/2023/001/POST'
-- AND platba."Èíslo ¾ádosti o platbu" like 'CZ.31.5%' 
AND ci."Kód" like '1%'
ORDER BY platba.kodwfstav
