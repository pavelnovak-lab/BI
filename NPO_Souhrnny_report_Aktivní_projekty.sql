select	 "V_BI_UMZPROJEKT"."Registraèní èíslo projektu" as "Registraèní èíslo projektu",
	 "V_BI_UMZPROJODPOVEDN"."ROLE" as "ROLE",
	 "V_BI_UMZPROJODPOVEDN"."DATUMDO" as "DATUMDO",
	 "V_BI_UMZPROJODPOVEDN"."USERNAME" as "PM",
	 "V_BI_UMZPROJEKT"."WFSTAV" as "WFSTAV",
	 "V_BI_UMZPROJEKT"."KODWFSTAV" as "KODWFSTAV",
	 "V_BI_UMFPFCELKEM"."Pøíspìvek Unie" as "Pøíspìvek Unie",
	 "V_BI_UMFPFCELKEM"."Evropský fond pro regionální r" as "Evropský fond pro regionální r",
	 "V_BI_UMFPFFAZE"."KOD" as "KOD",
	 "V_BI_UMZVYZVA"."Název výzvy" as "Název výzvy",
	 "V_BI_UMZVYZVA"."Èíslo výzvy" as "Èíslo výzvy" 
 from	"ISUM"."V_BI_UMZVYZVA" "V_BI_UMZVYZVA",
	"ISUM"."V_BI_UMFPFFAZE" "V_BI_UMFPFFAZE",
	"ISUM"."V_BI_UMFPFCELKEM" "V_BI_UMFPFCELKEM",
	"ISUM"."V_BI_UMZPROJODPOVEDN" "V_BI_UMZPROJODPOVEDN",
	"ISUM"."V_BI_UMZPROJEKT" "V_BI_UMZPROJEKT" 
 where   "V_BI_UMZPROJEKT"."ID"="V_BI_UMZPROJODPOVEDN"."IDPROJEKT"
 and	 "V_BI_UMFPFCELKEM"."ID_PROJEKT"="V_BI_UMZPROJEKT"."ID"
 and	 "V_BI_UMFPFCELKEM"."ID_FAZE"="V_BI_UMFPFFAZE"."ID"
 and	 "V_BI_UMZPROJEKT"."ID_VYZVA"="V_BI_UMZVYZVA"."ID"
  and 	 "V_BI_UMZPROJEKT"."Registraèní èíslo projektu" is not null 
   and	 "V_BI_UMZPROJODPOVEDN"."ROLE" ='MAN_PRJ' 
   and	 "V_BI_UMZPROJODPOVEDN"."DATUMDO" is null 
   and	 "V_BI_UMZPROJEKT"."KODWFSTAV" IN ('PP01', 'PU01', 'PP02', 'PP03', 'PP04a', 'PP04b', 'PP20', 'PP21', 'PU21', 'PP22', 'PP23a', 'PP23b', 'PP24a', 'PP24b', 'PU24', 'PP25a', 'PP25b', 'PP27a', 'PP27b', 'PU27', 'PP29', 'PP30', 'PP36', 'PP37', 'PP40', 'Z1', 'Z2', 'Z3') 
   and	 "V_BI_UMFPFFAZE"."KOD" ='AKT'
-- and "V_BI_UMZPROJEKT"."Registraèní èíslo projektu" like '%CZ.01%'

AND "V_BI_UMZPROJEKT".KodPrioritniOsa in ('31.3') 
