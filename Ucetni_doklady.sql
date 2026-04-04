SELECT	s."Pořadové číslo",
 	s."Číslo účetního dokladu \nv úče" AS doklad,
 	s."Částka bez DPH připadající na" as castka,
 	pl."Číslo žádosti o platbu" as zop,
	pl.kodwfstav
	
FROM isum.V_BI_UMZPRJGGVS vs
INNER JOIN isum.V_BI_UMFSOUPISKADOKLADPRJ s on s.ID_SUBJEKT=vs.ID
INNER JOIN isum.V_BI_UMPPLATBAPRJ pl on pl.ID=s.ID_PLATBA

WHERE vs.ID_TYPSUBJEKTU = 300784 -- žadatel/příjemce
AND pl.kodwfstav = 'P10' 
AND s."Částka bez DPH připadající na" >0
-- AND pl.kodwfstav in ('P10','P11')
AND pl.id_wfstav in (171855,171856)

ORDER BY pl."Číslo žádosti o platbu", s."Pořadové číslo" 




-- bez filtru na stav ŽoP byl součet částek 78 615 385 414,32 o chvilku déle 78 621 068 550,72
-- v ŽoP v P1O a P11 je 70 967 288 086,32


