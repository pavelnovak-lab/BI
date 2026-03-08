select	 pl.wfstav,
	pl."Èíslo ¾ádosti o platbu",
	prj.wfstav as wfstav_1,
	prj."Registraèní èíslo projektu",
	pl.kodwfstav,
	pl."Datum pøedlo¾ení",
	pl.schvalil1stdatum,
	pl.schvalil1stjmeno,
	pl."Verze ®oP",
	pl."VYUCTPLAN#Vyúètování plán",
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
	h.datumod,
	decode(h.datumod,null,null,'F1_P4') as "Unikátní kód stavu do",
	sou."Èíslo souhrnné ¾ádosti"	,
	sou."Datum autorizace",
	sou."Datum odeslání",
	sou."Datum vystavení",
	sou."STAV_WORKFLOW"

from isum.v_bi_umzprojekt prj
inner join isum.v_bi_umzvyzva vy on vy.id=prj.id_vyzva
inner join isum.v_bi_umpplatbaprj pl on pl.id_nositelplatby=prj.id
inner join isum.v_bi_umpcastkyschval cas on pl.id_schvalenecastky=cas.id
inner join (select rf.id_platba,
max(decode(cis."Kód",'10a',rf.castkaschvalena)) as castkaschvalenadotace,
max(decode(cis."Kód",'10a',rf.castkapozadovana)) as castkapozadovanadotace,
max(decode(cis."Kód",'2',rf.castkapozadovana)) as castkapozadovanaczv,
max(decode(cis."Kód",'2',rf.castkaschvalena)) as castkaschvaleczv,
max(decode(cis."Kód",'10b',rf.castkaschvalena)) as castkaschvalenaprocesif
from isum.v_bi_umprozpisfinprj rf
inner join isum.v_bi_umsciszakladni cis on rf.id_ukazatel=cis.id
where cis."Kód" in ('10a','2','10b')
group by rf.id_platba) castky on pl.id=castky.id_platba
left outer join (select min(datumod) as datumod,nositelid from isum."V_BI_UMSWFHISTORIESTAVU" where "Unikátní kód stavu do" ='F1_P4' group by nositelid) h on pl.id=h.nositelid
LEFT JOIN isum.V_BI_UMPKLASIFIKACE_SP sp on sp.id_platba=pl.id
LEFT JOIN  isum.V_BI_UMPSOUHRNNAPLATBA sou on sou.id=sp.id_sz





where
pl."Èíslo ¾ádosti o platbu" is not null
-- pl."Èíslo ¾ádosti o platbu" = 'CZ.01.2.111/0.0/0.0/15_016/0000743/2016/001/POST'
and	prj."Registraèní èíslo projektu" is not null
