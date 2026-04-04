select	 "V_BI_UMZPROJEKT"."KODWFSTAV" as "KODWFSTAV",
	 "V_BI_UMZPROJEKT"."Registrační číslo projektu" as "Registrační číslo projektu",
/*	 "V_BI_UMPPLATBA"."VYUCTPLAN#Vyúčtování plán" as plan, */
	 "V_BI_UMFPFCELKEM"."Celkové způsobilé výdaje" as "Celkové způsobilé výdaje",
/*	CAST("V_BI_UMPPLATBA"."VYUCTSKUT" AS NřUMERIC(12, 0)) */
	 "V_BI_UMPPLATBA"."VYUCTSKUT" as skut 

 from	"ISUM"."V_BI_UMZPROJEKT" "V_BI_UMZPROJEKT",
	"ISUM"."V_BI_UMPPLATBA" "V_BI_UMPPLATBA",
	"ISUM"."V_BI_UMFPFCELKEM" "V_BI_UMFPFCELKEM" 

where  	"V_BI_UMPPLATBA"."ID_NOSITELPLATBY"="V_BI_UMZPROJEKT"."ID"
 and	"V_BI_UMFPFCELKEM"."ID_PROJEKT"="V_BI_UMZPROJEKT"."ID"
 and	"V_BI_UMFPFCELKEM"."ID_FAZE" ='99991000000000005'
 and	"V_BI_UMPPLATBA"."SOUCTOVYRADEK" ='A'
 and 	"V_BI_UMZPROJEKT"."KODWFSTAV" like 'PP%'
 and  	"V_BI_UMFPFCELKEM"."Celkové způsobilé výdaje" > 0
 and  	"V_BI_UMPPLATBA"."VYUCTSKUT" > "V_BI_UMFPFCELKEM"."Celkové způsobilé výdaje" 


/* and 	 "V_BI_UMZPROJEKT"."Registrační číslo projektu" like ('CZ.01.2.06/0.0/0.0/15_038/0006724') */
/* and 	"V_BI_UMZPROJEKT"."Registrační číslo projektu" is not null */
/* and  	"V_BI_UMFPFCELKEM"."Celkové způsobilé výdaje" > "V_BI_UMPPLATBA"."VYUCTPLAN#Vyúčtování plán" */
