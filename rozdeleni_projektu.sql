SELECT historie."Poèet projektù",
       count(historie."IÈ")

FROM 
(
  SELECT count(p.id) "Poèet projektù",
	 p."IÈ"

  FROM isum.v_bi_UmzProjekt p 
  INNER JOIN 
    (SELECT max(hs.datumod) max_2019,
	   p.id

    FROM isum.v_bi_UMZPrjGGii P 
    INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id

    WHERE trunc(hs.datumod) <= to_date('2019-12-31','yyyy-mm-dd')

    GROUP BY p.id) max19 ON max19.id = p.id
  INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id AND max19.max_2019 = hs.datumod

  WHERE p."Registraèní èíslo projektu" is not null 
  -- in ('CZ.01.1.02/0.0/0.0/15_030/0005988','CZ.01.1.02/0.0/0.0/15_019/0004507','CZ.01.1.02/0.0/0.0/15_019/0004384')

  AND (hs.stavdo like ('PP%'))
--  or hs.stavz in ('V2', 'V5', 'Z1', 'Z2' ) or hs.stavz like 'PU%' )
  AND EXISTS
  (SELECT 1
  FROM isum.v_bi_UmpCertifikace cert 
  INNER JOIN isum.v_bi_UMPEKPlatba ek ON ek.id = cert.id_perioda
  WHERE p.id = cert.id_projekt
  AND cert."Typ certifikace" = 2
  AND ek.datumcertifikace < to_date('2020-01-01','yyyy-mm-dd')
  AND ek.datumcertifikace >= to_date('2019-01-01','yyyy-mm-dd')
  )    

  GROUP BY p."IÈ"
) historie

GROUP BY historie."Poèet projektù"

ORDER BY historie."Poèet projektù" ASC
