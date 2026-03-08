SELECT  p.kod,
	w."Kód" ,
	CASE WHEN c.nazev like 'Podpora de minimis%' then 'De minimis'
       		ELSE c.nazev END "Režim podpory",
       gber.nazev "Článek GBER",
       vpo.castkacelk_kc "Způsobilé výdaje", 
       sum(case when pf.id_kategorieregionu =  283463 THEN pf.pomerfin*kr.less  --MRR
       			when pf.id_kategorieregionu =  283468 THEN pf.pomerfin*kr.more -- PR
          		END)/100 "EU podíl maximálně",
 	100-sum(case when pf.id_kategorieregionu =  283463 THEN pf.pomerfin*kr.less  --MRR
       			when pf.id_kategorieregionu =  283468 THEN pf.pomerfin*kr.more -- PR
         		END)/100 "Vlastní podíl minimálně"
      
FROM v_rav_umzprojekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN v_rav_umsrdmpodpora vpo ON vpo.id_projekt = p.id
INNER JOIN v_rav_umsciszakladni c on c.id = vpo.id_rezimpodpory
LEFT JOIN v_rav_umsciszakladni gber on gber.id = vpo.id_podkategorie
inner join v_rav_umzprjggsc kr on kr.id_prjgg = p.id 
inner join v_rav_umfpomerfinancovani pf on pf.id_nositelpompf = vpo.id 

WHERE vpo.platnost = 'A'
and pf.id_zdrojfin = 415432 -- EU
-- and p.kod = 'CZ.01.04.01/01/24_049/0004874'
AND v."Číslo výzvy" = '01_23_034'
group by p.kod , w."Kód" ,
      c.nazev,
        --CASE WHEN c.nazev like 'Podpora de minimis%' then substring (c.nazev, 0, 18)
       	--	ELSE c.nazev END ,
       gber.nazev ,
       vpo.castkacelk_kc

ORDER BY p.kod , w."Kód" DESC  , c.nazev ASC , substring(gber.nazev,10)
