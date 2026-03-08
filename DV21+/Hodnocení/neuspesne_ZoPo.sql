CREATE or REPLACE view "ZoPo_negativni_stav" FOLDER=   AS 

SELECT	op.nazev as "Opatøení" ,
	p."Registraèní èíslo projektu",
       pwf."Kód" "Pøedchozí stav" ,
       posl."Stav projektu"
                     

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil 
INNER JOIN (
     SELECT p.id,
     	    w."Kód" "Stav projektu" ,
	    max(hs."Poøadí") poradi
     FROM projekt p
     INNER JOIN historie_stavu hs ON hs.nositelid = p.id
     -- INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
     -- INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
     INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
     WHERE p."Registraèní èíslo projektu" is not null 
     AND w."Kód" like 'PN2%'
     GROUP BY p.id, w."Kód"  ) posl ON posl.id = p.id 
     -- INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavdo
INNER JOIN historie_stavu hs ON hs.nositelid = p.id AND posl.poradi = hs."Poøadí"
INNER JOIN ciselnik_stav_workflow pwf ON pwf.id = hs.id_stavz


