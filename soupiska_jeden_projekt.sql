SELECT 	  platba."PORADI#Poøadí finanèního plánu" "Poøadí ®oP",
	  s."Èíslo úèetního dokladu \nv úèe" AS "Èíslo dokladu",
	  s."Celková èástka bez DPH \nuvede" ,
	  s."Celková èástka DPH \nuvedená n",
	  s."Èástka bez DPH pøipadající na" as "Èástka czv bez DPH",
	  s."Èástka DPH pøipadající na \nPr"


FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.V_BI_UMFSOUPISKADOKLADPRJ s ON s.id_projekt = p.id
INNER JOIN isum.V_BI_UMPPLATBAPRJ pl on pl.ID=s.ID_PLATBA

WHERE p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/20_321/0024778'
AND s."Èíslo úèetního dokladu \nv úèe" in ('220100512','42200305','220109525','FV220017269','220110541','FV220017141','1022009342','202210795','2660405578','FV220017716','105220794','220110891','2660402283','131220045','131220069','22242319','202212166','22103605','223101252','220112482','131220074','220111555','131220054','FV220018449','2660407998','22242320','FV220018410','2660406963','202210857','202244011','131230009','2660410762','131230007','23100008','131230044','131230071','FV1230235','223163','222089','222090','222091','20221495','20222478','222147','2309100649','FV1230236','223017','223016','20230288')





------------------------------

SELECT 	  platba."PORADI#Poøadí finanèního plánu" "Poøadí ®oP",
	  s.*


FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.V_BI_UMFSOUPISKADOKLADPRJ s ON s.id_projekt = p.id
INNER JOIN isum.V_BI_UMPPLATBAPRJ pl on pl.ID=s.ID_PLATBA


WHERE p."Registraèní èíslo projektu" = 'CZ.31.1.0/0.0/0.0/24_135/0010838'
