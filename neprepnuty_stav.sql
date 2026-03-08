SELECT p."Registraèní èíslo projektu" ,
       p.kodwfstav ,
       hs.stavdo

FROM isum.v_bi_UmzProjekt p
INNER join (select max(datumod) datumod,
      	   	   NositelId
	    FROM isum.v_bi_UmsWFHistorieStavu
	    GROUP BY Nositelid) ma ON ma.NositelId = p.id
INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND hs.datumod = ma.datumod
WHERE hs.stavdo <> p.kodwfstav
AND p.kodwfstav <> 'Z1'
