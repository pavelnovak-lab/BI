select	p.kompetencniutvar AS "Program podpory" 
	hip.kod,
	hip."Název programové linie",
	pl."Datum pøedlo¾ení",
	v."Název výzvy",
	p."Registraèní èíslo projektu",
	vs."Název subjektu" as zadatel,
	to_char(pl."PORADI#Poøadí finanèního plánu") as "PORADI#Poøadí finanèního plánu",
	pl.wfstav as "Stav ®opl",
	s."datum prvního stavu P4",
	p.kodwfstav,
	p.wfstav,
	od.nazev,
	os."Email",
	os."Jméno",
	os."Pøíjmení",
	os."Mobil",
	pl.souctovyradek,
	od.role,
	od.datumdo,
	pl."VYUCTPLAN#Vyúètování plán" as CZV,
	((pl."VYUCTPLAN#Vyúètování plán"/100)*pf.proc_eu) as "Dotace",
	pl."Závìreèná platba",
  listagg(cis_tag."Název",',') within group (order by cis_tag."Název") as "Název tagu"
	

from isum.v_bi_umzprojekt p
inner join isum.v_bi_umzvyzva v on v.id = p.id_vyzva
inner join isum.v_bi_umpplatbaprj pl on pl.id_nositelplatby = p.id
inner join isum.v_bi_umfpfcelkem pf on pf.id_projekt = p.id
inner join isum.v_bi_umzprojodpovedn od on od.idprojekt = p.id
inner join isum.v_bi_umshiplinie hip on hip.id = p.id_prioritniosa
inner join isum.v_bi_umsrsverzesubjektu vs on vs.id = p.id_zadatel
inner join isum.v_bi_umsrsverzeosoby os on os.id=vs.id_hlkontaktosoba
left outer join 

(select 	hi.nositelid,
	min(hi.datumod) as "datum prvního stavu P4"
from isum.v_bi_umswfhistoriestavu hi
where hi.stavdo = 'P4'
group by hi.nositelid)s on s.nositelid=pl.id

left join isum.V_BI_UMZPRJGGTAG V_BI_UMZPRJGGTAG on V_BI_UMZPRJGGTAG.ID_PRJGG = p.id
left join isum.V_BI_UMSCISZAKLADNI cis_tag on CIS_TAG.ID = V_BI_UMZPRJGGTAG.ID_TAG

where pf.id_faze = 99991000000000005
and pl.souctovyradek is null
and od.role = 'MAN_PRJ'
and od.datumdo is null

AND v."Èíslo výzvy" like '01_%'

--and v.id_prg =172133
group by hip.kod,
	hip."Název programové linie",
	pl."Datum pøedlo¾ení",
	v."Název výzvy",
	p."Registraèní èíslo projektu",
	vs."Název subjektu",
	pl."PORADI#Poøadí finanèního plánu",
	pl.wfstav,
	s."datum prvního stavu P4",
	p.kodwfstav,
	p.wfstav,
	od.nazev,
	os."Email",
	os."Jméno",
	os."Pøíjmení",
	os."Mobil",
	pl.souctovyradek,
	od.role,
	od.datumdo,
	pl."VYUCTPLAN#Vyúètování plán",
  ((pl."VYUCTPLAN#Vyúètování plán"/100)*pf.proc_eu),
	pl."Závìreèná platba"
