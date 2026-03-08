SELECT v."Èíslo výzvy",
       i."Kód NÈI 2014+",
       i."Název indikátoru",
       ci."Název" "Typ indikátoru",
       hi."Projektový",
       l.KOD "Èíslo komponenty v MS14+"
       

FROM isum.v_bi_UmzVyzva v 
INNER JOIN isum.v_bi_UMVIndiHodnota hi ON hi.id_nositelindi = v.id
INNER JOIN isum.v_bi_umvindikator i ON i.id = hi.id_indikator
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = i.id_typindi
INNER JOIN isum.v_bi_umzvyzvahierarchie vh on vh.id_vyzva = v.id
INNER JOIN isum.v_bi_umshisc sh on sh.id = vh.id_speccil
INNER JOIN isum.v_bi_umshiplinie l on l.id = sh.id_osa


WHERE v."Èíslo výzvy" = '31_23_104'
AND hi."Platnost" = 'A'
AND hi.id_speccil > 0

----------------------------------------



select	 
	 "V_BI_UMVINDIHODNOTA"."Povinný k naplnìní" as "Povinný k naplnìní",
	 "V_BI_UMZVYZVA"."Èíslo výzvy" as "Èíslo výzvy",
	 "V_BI_UMVINDIKATOR"."Kód NÈI 2014+" as "Kód NÈI 2014+",
	 "V_BI_UMVINDIKATOR"."Název indikátoru" as "Název indikátoru",
	 "V_BI_UMZVYZVA"."Název výzvy" as "Název výzvy",
	 "V_BI_UMZVYZVA"."OP kod" as "OP kod",
	 "V_BI_UMZVYZVA"."OP název" as "OP název" 
 from	"ISUM"."V_BI_UMVINDIKATOR" "V_BI_UMVINDIKATOR",
	"ISUM"."V_BI_UMZVYZVA" "V_BI_UMZVYZVA",
	"ISUM"."V_BI_UMVINDIHODNOTA" "V_BI_UMVINDIHODNOTA" 
 where   "V_BI_UMVINDIHODNOTA"."ID_NOSITELINDI"="V_BI_UMZVYZVA"."ID"
 and	 "V_BI_UMVINDIHODNOTA"."ID_INDIKATOR"="V_BI_UMVINDIKATOR"."ID"
  and 	 "V_BI_UMVINDIHODNOTA"."Povinný k naplnìní" ='A'
