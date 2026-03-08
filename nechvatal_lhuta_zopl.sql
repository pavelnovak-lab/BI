select	 pl.wfstav,
	pl."Číslo žádosti o platbu",
	prj.wfstav as wfstav_1,
	prj."Registrační číslo projektu",
        prj."KOMPETENCNIUTVAR",
	pl.kodwfstav,
	pl."Datum předložení",
	pl.schvalil1stdatum,
	pl.schvalil1stjmeno,
	pl."Verze ŽoP",
	pl."VYUCTPLAN#Vyúčtování plán",
	pl.vyuctskut,
	pl."Datum změny stavu",
	pl."Závěrečná platba",
	vy."Číslo výzvy",
	vy."Název výzvy",
	prj.zadatel,
	prj."IČ",
	prj.velikostpodniku,
	prj.kodprioritniosa,
	cas.vyuctdotbezjppcelk,
	prj.prioritniosa,
	pl.datumcertifikace,
	pl.stavcertifikace,
	pl.zarazenidocert,
	pl.schvalil2stdatum,
	pl.schvalil2stjmeno,
	pl.kurz,
	cas.vyuctczvcelk,
	pl.datproplacenaprij,
	castky.castkapozadovanadotace,
	castky.castkaschvalenadotace,
	castky.castkapozadovanaczv,
	castky.castkaschvaleczv,
	castky.castkaschvalenaprocesif,
	h.datumod,
	decode(h.datumod,null,null,'F1_P4') as "Unikátní kód stavu do",
	hs.create_cas "Datum PP41"
	
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
left outer join (select min(datumod) as datumod,
     	   	nositelid from isum."V_BI_UMSWFHISTORIESTAVU"
		where "Unikátní kód stavu do" ='F1_P4'
		group by nositelid) h on pl.id=h.nositelid
left join isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = prj.id and 	hs.StavDo = 'PP41'

where	pl."Číslo žádosti o platbu" is not null
-- and	prj."Registrační číslo projektu" is not null
 AND prj."Registrační číslo projektu" = 'CZ.01.3.10/0.0/0.0/17_138/0011761'


