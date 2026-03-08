select	 pl.wfstav,
	pl."Èíslo ¾ádosti o platbu",
	prj.wfstav as wfstav_1,
        prj.kodwfstav as kodwfstav_1,
	prj."Registraèní èíslo projektu",
	pl.kodwfstav,
	pl."Datum pøedlo¾ení",
	pl.schvalil1stdatum,
	pl.schvalil1stjmeno,
	pl."Verze ®oP",
	pl."VYUCTPLAN#Vyúètování plán",
        pl."PORADI#Poøadí finanèního plánu",
	pl.vyuctskut,
	pl."Datum zmìny stavu",
	pl."Závìreèná platba",
	vy."Èíslo výzvy",
	vy."Název výzvy",
	prj.zadatel,
	prj."IÈ",
	prj.velikostpodniku,
	cas.vyuctdotbezjppcelk,
	castky.castkapozadovanadotace,
	prj.kodprioritniosa,
	prj.prioritniosa,
        prj.kompetencniutvar,
        prj.kodspecifcil,
	pl.datumcertifikace,
	pl.stavcertifikace,
	pl.zarazenidocert,
	pl.schvalil2stdatum,
	pl.schvalil2stjmeno,
	pl.kurz,
	castky.castkaschvalenadotace,
	cas.vyuctczvcelk,
	pl.datproplacenaprij,
	castky.castkapozadovanaczv,
	castky.castkaschvaleczv,
	castky.castkaschvalenaprocesif,
	(select min(datumod) from isum.V_BI_UMSWFHISTORIESTAVU where id_stavdo=171845 and pl.id=nositelid) as datumod
--	decode(h.datumod,null,null,'F1_P4') as "Unikátní kód stavu do"
from isum.v_bi_umzprojekt prj
inner join isum.v_bi_umzvyzva vy on vy.id=prj.id_vyzva
inner join isum.v_bi_umpplatbaprj pl on pl.id_nositelplatby=prj.id
inner join isum.v_bi_umpcastkyschval cas on pl.id_schvalenecastky=cas.id

left join (select rf.id_platba,
 max(decode(rf.id_ukazatel,361356,rf.castkaschvalena)) as castkaschvalenadotace,
 max(decode(rf.id_ukazatel,361356,rf.castkapozadovana)) as castkapozadovanadotace,
 max(decode(rf.id_ukazatel,361347,rf.castkapozadovana)) as castkapozadovanaczv,
 max(decode(rf.id_ukazatel,361347,rf.castkaschvalena)) as castkaschvaleczv,
 max(decode(rf.id_ukazatel,361357,rf.castkaschvalena)) as castkaschvalenaprocesif
 from isum.v_bi_umprozpisfinprj rf
--									inner join isum.v_bi_umsciszakladni cis on rf.id_ukazatel=cis.id
 where rf.id_ukazatel in (361356,361347,361357) --cis."Kód" in ('10a','2','10b')
 group by rf.id_platba) castky on pl.id=castky.id_platba

where	pl."Èíslo ¾ádosti o platbu" is not null
	AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
	and	prj."Registraèní èíslo projektu" is not null
        and pl.id_wfstav in (171855,171856,171863)
-- and pl."Èíslo ¾ádosti o platbu" ='CZ.01.2.07/0.0/0.0/15_004/0000315/2017/001/POST'

-- order by prj."KODPRIORITNIOSA" ASC, prj."KODSPECIFCIL" ASC, vy."Èíslo výzvy" ASC, prj."Registraèní èíslo projektu" ASC, pl."Èíslo ¾ádosti o platbu" ASC


