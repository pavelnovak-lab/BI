select	schval."Číslo případu",
	schval.CasPrepnuti,
	sch."Název příjemce",
	sch."Název konečného příjemce",
	sch."TYP",
	sch."STAVDO", 
	sch."CREATE_UZIVATEL" 

from

(select	 nesr."Číslo případu",
	 min(hs."CREATE_CAS") as CasPrepnuti
from	isum.v_bi_umznesrovnalost nesr
	inner join isum.v_bi_umswfhistoriestavu hs on nesr.id=hs.nositelid
where   
/* 	nesr."Číslo případu" in ('CZ.01.2.06/0.0/0.0/15_038/0006617/18/001','CZ.01.1.02/0.0/0.0/15_002/0000344/18/001','CZ.01.4.04/0.0/0.0/15_005/0001460/18/001
') and	 */
	(hs."STAVDO" ='SCHV' or	hs."STAVDO" ='SCHVAL') and
	hs."CREATE_UZIVATEL" <> 'JOAHEL' and
	nesr."Číslo případu" is not null
group by nesr."Číslo případu") schval

join

(select	 nesrovnalost."Číslo případu",
	 nesrovnalost."Název příjemce",
	 nesrovnalost."Název konečného příjemce",
  	 nesrovnalost."TYP",
	 hsta."STAVDO",
	 hsta."CREATE_CAS" as CasPrepnuti,
	 hsta."CREATE_UZIVATEL"

from	isum.v_bi_umznesrovnalost nesrovnalost
	inner join isum.v_bi_umswfhistoriestavu hsta on nesrovnalost.id=hsta.nositelid) sch

on (sch."Číslo případu"=schval."Číslo případu" AND sch.CasPrepnuti=schval.CasPrepnuti)
