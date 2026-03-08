select
v."OP zkratka",
p.id,
osa.kod||' '||"Název programové linie" as posa,
p."Registraèní èíslo projektu",
p."Název projektu CZ" as naz,
REPLACE(REPLACE(p."Anotace projektu",CHR(10),' '),CHR(13),' ') as anotace,
decode(z.jepravosoba,'A',z."Název subjektu",'xxx') as zadatel,
z."IÈ",
typ."Název" as zadatelpforma,
za.psc,
TO_CHAR(p."Datum zahájení skut",'dd.MM.yyyy') as dzrskut,
TO_CHAR(p."Datum ukonèení pøedp",'dd.MM.yyyy') as durpred,
TO_CHAR(p."Datum ukonèení skut",'dd.MM.yyyy') as durskut,
p.kodwfstav||' '||p.wfstav as Stav,
case when exists(select 1 from isum.v_bi_UMZPrjUmisteni ur1 inner JOIN isum.v_bi_UMSCisUzemniJednotky uzr1 on uzr1.id=ur1.id_UzemniJednotky where uzr1.uroven>3 and ur1.id_projekt=p.id)
	then 'Ne' else 'Ano' end as jenkraj,
(SELECT LISTAGG(case when sc."Èíslo specifického cíle / oper" in ('06.6.127.6.1','SC 06.7.127.7.1') then 'EFRR REACT-EU' else c."Zkratka" end, '; ') WITHIN GROUP (ORDER BY c."Zkratka")
									from isum.v_bi_UMzprjggsc psc
										inner join isum.v_bi_umshisc sc on psc.id_sc=sc.id
										inner join isum.v_bi_umsciszakladni c on c.id= sc.id_fondy
										where psc.id_prjgg=p.id group by psc.id_prjgg) as fond,
DECODE(f.czv,0,0,f.eu/f.czv ) as pomerEU, --katregionu?
f.czv,
f.eu,
f.cnv,
f.s_sn,
klas.F1_czv,
klas.F1_eu,
klas.F1_cnv,
klas.F1_s_sn,
sh.d30
from isum.v_bi_umzprjggii p
inner join isum.v_bi_umshiplinie osa on osa.id=p.id_prioritniosa
inner join isum.v_bi_UMZVYZVA v on v.id=p.id_vyzva and v.id_prg in (:op)
inner join (select min(datumod) as d30, nositelid from isum.v_bi_UMSWFHistorieStavu where "Unikátní kód stavu do" in ('CPP12','STR31') group by nositelid) sh on sh.nositelid=p.id
--left outer join (select count(*) as pocet, ur1.id_projekt from isum.v_bi_UMZPrjUmisteni ur1 inner JOIN isum.v_bi_UMSCisUzemniJednotky uzr1 on uzr1.id=ur1.id_UzemniJednotky where uzr1.uroven>3 group by ur1.id_projekt) um on p.id= um.id_projekt
inner join ISUM.V_BI_UMSRSVerzeSubjektu z on z.id=p.id_zadatel
inner join isum.v_bi_UMSRSVerzeAdresy za on za.id=z.id_oficialniadresa
inner join isum.v_bi_UMSCisZakladni typ on typ.id=z.id_hosppravforma
--inner join (select id_projekt,(LISTAGG("Název", '; ') WITHIN GROUP (ORDER BY "Název")) as krajrealizace,
--							(LISTAGG("Kód", '; ') WITHIN GROUP (ORDER BY "Kód")) as kodkrajrealizace
--				from isum.v_bi_UMZPrjUmistenikraj where typ='Realizace'
--				group by id_projekt) umistkraj on umistkraj.id_projekt=p.id
left outer join (select id,
					sum("Celkové zpùsobilé výdaje") as CZV,
					sum("Pøíspìvek Unie") as eu,
				    sum (nvl("Jiné národní veøejné finanèní",0)+nvl("Finanèní prostø z rozp obce",0)+nvl("Finanèní prostøedky ze SR",0)+nvl("Finanèní prostø z rozp kraje",0)+nvl("Finanèní prostøedky ze SF",0)) as cnv,
					sum(nvl("Soukromý zdroj",0)+nvl("Soukromé národní",0)) as s_sn
			from isum.V_BI_UMSDB39PRJPA
--      where 1=0
--			where id=331461679
			group by id) f on p.id = f.id
left outer join (	SELECT rozpad.id_projekt,
					sum(case when rozpad."Zdroj financování" in ('SOUKROME','SOUKROMENAR','JINE','OBEC','KRAJ','SF','SR','EFRR','FS','ESF', 'EMFF', 'YEI', 'ESF_SOUVISEJICI') then Rozpad."Èástka CZK" else 0 end) as F1_czv,
					sum(case when rozpad."Zdroj financování"  in ('EU','FEAD','EMFF','EAFRD','YEI','ESF_SOUVISEJICI','ESF','ESF_CELKEM','EFRR','FS') then Rozpad."Èástka CZK" else 0 end) as F1_EU,
					sum(case when rozpad."Zdroj financování" in ('JINE','OBEC','SR','KRAJ','SF') then Rozpad."Èástka CZK" else 0 end) as F1_cnv,
					sum(case when rozpad."Zdroj financování" in ('SOUKROME','SOUKROMENAR') then Rozpad."Èástka CZK" else 0 end) as F1_s_sn
					FROM isum.V_BI_UMSDB50PVYUCTO Rozpad
--					where 1=0
--					where id_projekt=12438680
					group by rozpad.id_projekt) klas on klas.id_projekt=p.id
where p."Registraèní èíslo projektu" is not null
--and p.id in (1991147, 331461679)

