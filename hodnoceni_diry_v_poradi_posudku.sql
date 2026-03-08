SELECT	p."Registrační číslo projektu", 
	typvzniku."Název" "Typ vzniku posudku",
	kolo.NAZEV "Kolo hodnocení", 
	hodnotitel."Kód" "Kód hodnotitele",
	druh.nazev "Druh hodnocení",
	krok.nazev "Krok VH",
	sch.lmt "Poslední změna u schválení",
	-- stavsch."Kód" "Kód schválení",
	stavsch."Název" "Stav schvaleni" ,
	status.nazev "Status posudku",
	CASE WHEN statusdh."Celkový status" = 159204682 THEN 'Projekt prošel úspěšně všemi kroky hodnocení.'
	     ELSE statusdh."Celkový status" END "Celkový výsledek VH", 
	statusdh.popisstatutu "Popis celkového statutu" ,
	 h.*

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmvHodnoceni h ON h.id_noshodnoceni = p.id 
INNER JOIN isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id = h.id_hodnotitel -- AND h.id_KrokVecHodn = 171214 /* 2. krok VH */ AND h.id_kolohodnoceni= 17
INNER JOIN isum.V_BI_UMVHodnDruhCis druh ON druh.id = h.id_druhhodn
INNER JOIN isum.v_bi_UMVHodnKolo kolo ON kolo.id = h.id_kolohodnoceni
INNER JOIN isum.V_BI_UMVHodnKrokVecne krok ON krok.id = h.id_krokvechodn
INNER JOIN isum.V_BI_UMVHodnSchvaleni sch ON sch.id = h.id_schvaleni
INNER JOIN isum.V_BI_UMSZamestnanec vatel ON vatel.id = h.id_schvalil
INNER JOIN isum.v_bi_UmsCisZakladni stavsch ON stavsch.id = sch.id_stavschvaleni
INNER JOIN isum.V_BI_UMVHodnStatusCis status ON status.id = h.id_statushodn
INNER JOIN isum.V_BI_UMVHodnTypVznikuHodn typvzniku ON typvzniku.id = id_typvznikuhodn
INNER JOIN isum.V_BI_UMVHodnVarDruhCis vardruh ON vardruh.id = h.id_vardruhhodn -- obsahuje mezivýpočty vyloučených posudků
LEFT JOIN isum.V_BI_UMVHODNSTATUSDH statusdh ON statusdh.id_noshodnoceni = p.id AND statusdh.id_druhhodn = h.id_druhhodn AND statusdh.id_krokvechodn = h.id_krokvechodn AND statusdh.id_kolohodn = h.id_kolohodnoceni


WHERE h.id_noshodnoceni =  7635837

ORDER BY h.create_cas


----------------------------------------
SELECT *
from isum.V_BI_UMVHODNSTATUSDH
where id = 159204682
