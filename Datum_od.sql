select	 
"V_BI_UMZPROJEKT"."Registrační číslo projektu" as "Registrace",
"V_BI_UMZPROJEKT"."Název projektu CZ" as "Projekt",
"V_BI_UMZPROJEKT"."Datum registrace žádosti" as "Datum_registrace" 

 from	"ISUM"."V_BI_UMZPROJEKT" "V_BI_UMZPROJEKT" 
 where 	 "V_BI_UMZPROJEKT"."Registrační číslo projektu" is not null

/*definice parametru - zobrazení záznamu od data registrace zadaného uživatelem*/
/*nutno přidat logickou spojku "and", následně v závorkách definice, ke kterému atributu bude parametr navázán, následně operátor ">" pro porovnávání řetězců a navázání na parametr (parametr je označen dvojtečkou)*/

and ("V_BI_UMZPROJEKT"."Datum registrace žádosti" > (:P_DatumOD) or (:P_DatumOD) is null)

/*konstrukce "or (:P_DatumOD) is null" způsobí, že pokud uživatel nezadá žádný filtrační řetězec, výsledek zobrazení bude obsahovat všechny záznamy */
