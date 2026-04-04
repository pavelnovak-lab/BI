WITH soup AS (SELECT
	  pl.ID,
	  vs."IČ",
	  s."Číslo účetního dokladu \nv úče" AS doklad,
	  s."Částka bez DPH připadající na" as castka,
	  pl."Číslo žádosti o platbu" as zop
  FROM isum.V_BI_UMZPRJGGVS vs
	  inner join isum.V_BI_UMFSOUPISKADOKLADPRJ s on s.ID_SUBJEKT=vs.ID
	  inner join isum.V_BI_UMPPLATBAPRJ pl on pl.ID=s.ID_PLATBA
  WHERE vs.ID_TYPSUBJEKTU =300784
	  and s."Částka bez DPH připadající na" >0
	  AND s."Typ úpravy dokladu" <> 2
	  and (vs."IČ" = :ic or :ic is null)
   and substr(pl."Číslo žádosti o platbu",4,2) =:op)


SELECT soup.*,
(select (listagg(soup2.ZOP,'; ') WITHIN GROUP (ORDER BY soup2.ZOP)) from soup soup2
   where soup2."IČ"=soup."IČ"
	   and soup2.doklad = soup.doklad
	   and soup2.castka = soup.castka
	   and soup2.ID != soup.ID) AS NZOP
FROM soup
WHERE ExISTS (select 1 from soup soup1
  where soup1."IČ"=soup."IČ"
   and soup1.doklad = soup.doklad
   and soup1.castka = soup.castka
   and soup1.ID != soup.ID)
