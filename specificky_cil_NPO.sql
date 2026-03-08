SELECT	osa."Název programové linie",
	osa."KOD",
	REPLACE(REPLACE(sc."Popis",CHR(10),' $ '),CHR(13),' $ ') as "Popis",
       sc."Platnost",
       sc."Èíslo specifického cíle / oper",
       sc."Datum finalizace"


FROM isum.v_bi_UMSHISC sc
INNER JOIN isum.V_BI_UMSHIPLinie osa ON osa.id = sc.id_osa

WHERE osa.KOD like '31%'
ORDER BY sc."Èíslo specifického cíle / oper"
