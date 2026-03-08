SELECT p."Registraèní èíslo projektu" ,
       zoz.poradi "Poøadí ZoZ",
       round(pzf."Pøíspìvek spoleèenství (% veøejných)",0) "Procento EU ®oPo",
       sum(pf.pomerfin) "Pomìr EU na ®oZ"

FROM projekt p
INNER JOIN v_rav_umzzozprojekt zoz ON zoz.id_zad = p.id
INNER JOIN v_rav_umfpomerfinancovani pf ON pf.id_nositelpompf = zoz.id
INNER JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 



WHERE
-- zoz.id = 126195706
-- AND
pf.vlastni = 'N'
AND pf.pomerfin <> 2*round(pzf."Pøíspìvek spoleèenství (% veøejných)",0)
AND 2*pf.pomerfin <> round(pzf."Pøíspìvek spoleèenství (% veøejných)",0)



GROUP BY p."Registraèní èíslo projektu" 
      , zoz.poradi
      , pzf."Pøíspìvek spoleèenství (% veøejných)"


HAVING sum(pf.pomerfin) <>  pzf."Pøíspìvek spoleèenství (% veøejných)"

----------------------------------------

SELECT count(p.id) "Poèet rozpracovaných a nepodaných",
       pod."Poèet podaných"
FROM projekt p

INNER JOIN (
      SELECT count(p.id) "Poèet podaných",
      	     p.id_vyzva
      FROM projekt p
      WHERE p.id_vyzva = 19421537 -- vyzva 01_22_006 úspory energie
      AND p."Registraèní èíslo projektu" is not null
      GROUP BY p.id_vyzva) pod ON pod.id_vyzva = p.id_vyzva

WHERE p.id_vyzva = 19421537
AND p."Registraèní èíslo projektu" is  null

GROUP BY pod."Poèet podaných"



----------------------------------------

SELECT count(p.id) "Poèet rozpracovaných ®oPo"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN prehled_zdroju_financovani pf ON pf.id_projekt = p.id AND pf.id_faze = 99991000000000005 -- aktuální stav 


WHERE p."Registraèní èíslo projektu" is null
AND v."Èíslo výzvy" = '01_22_006'
