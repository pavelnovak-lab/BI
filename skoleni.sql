SELECT p.kodkrajrealizace,
       p."Registraèní èíslo projektu"

FROM isum.v_bi_UmzProjekt p

WHERE p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000920'


---------------

SELECT
--	v1."Èíslo výzvy" as "Èíslo výzvy",
-- 	v1."Název výzvy" as "Název výzvy",
-- 	p1."WFSTAV" as "WFSTAV",
-- 	p1."KODWFSTAV" as "KODWFSTAV",
-- 	p1."CZV" as "CZV",
-- 	p1."EU" as "EU",
--	p1."Název projektu CZ" as "Název projektu CZ",
	pp1."ZADATEL" as "zadatel",
	pp1."ZADATELPFORMA" AS "ZADATELPFORMA",	   
        pp1."Registraèní èíslo projektu",

	cc7.nazev7,
	cc6.nazev6,
	cc7.kod7,
	cc6.kod6,
	cc5.nazev5,
	cc4.nazev4,
	cc5.kod5,
	cc4.kod4,
	cc3."Kód",
	cc3."Název" as nazevkraj


FROM isum.v_bi_umzprojekt pp1
-- INNER JOIN isum.v_bi_umzprjgg p1 on p1.id= pp1.id
-- INNER JOIN isum.v_bi_umzvyzva v1 on v1.id= pp1.id_vyzva
-- INNER JOIN isum.v_bi_umzprjggsc prggsc1 on prggsc1."ID_PRJGG"=p1."ID"
-- INNER JOIN isum.v_bi_umshisc sc on prggsc1."ID_SC"=sc."ID"

LEFT OUTER JOIN (SELECT 

    v_bi_umscisuzemnijednotky."Název" as nazev7,
    v_bi_umscisuzemnijednotky."Kód" as kod7,
    p1.id as idcko

    FROM isum.v_bi_umzprojekt p1
    INNER JOIN isum.v_bi_umzprjumisteni v_bi_umzprjumisteni on v_bi_umzprjumisteni.id_projekt=p1.id
    left outer join isum.v_bi_umscisuzemnijednotky v_bi_umscisuzemnijednotky on v_bi_umzprjumisteni.id_uzemnijednotky= v_bi_umscisuzemnijednotky.id
    where V_BI_UMSCISUZEMNIJEDNOTKY.UROVEN = 7
    and v_bi_umzprjumisteni.typ in ('1')) cc7 on cc7.idcko=pp1.id

LEFT OUTER JOIN (SELECT 
    v_bi_umscisuzemnijednotky."Název" as nazev6,
    v_bi_umscisuzemnijednotky."Kód" as kod6,
    p1.id as idcko
    FROM isum.v_bi_umzprojekt p1
    INNER JOIN isum.v_bi_umzprjumisteni v_bi_umzprjumisteni on v_bi_umzprjumisteni.id_projekt=p1.id
    LEFT OUTER JOIN isum.v_bi_umscisuzemnijednotky v_bi_umscisuzemnijednotky on v_bi_umzprjumisteni.id_uzemnijednotky= v_bi_umscisuzemnijednotky.id
    WHERE V_BI_UMSCISUZEMNIJEDNOTKY.UROVEN = 6
    AND v_bi_umzprjumisteni.typ in ('1')) cc6 on cc6.idcko=pp1.id

LEFT OUTER JOIN (select 

    v_bi_umscisuzemnijednotky."Název",
    v_bi_umscisuzemnijednotky."Kód",
    p1.id as idcko
    from isum.v_bi_umzprojekt p1
    inner join isum.v_bi_umzprjumisteni v_bi_umzprjumisteni on v_bi_umzprjumisteni.id_projekt=p1.id
    left outer join isum.v_bi_umscisuzemnijednotky v_bi_umscisuzemnijednotky on v_bi_umzprjumisteni.id_uzemnijednotky= v_bi_umscisuzemnijednotky.id
    where V_BI_UMSCISUZEMNIJEDNOTKY.UROVEN = 3
    and v_bi_umzprjumisteni.typ in ('1')) cc3 on cc3.idcko=pp1.id

LEFT OUTER JOIN (select 
    v_bi_umscisuzemnijednotky."Název" as nazev5,
    v_bi_umscisuzemnijednotky."Kód" as kod5,
    p1.id as idcko
    from isum.v_bi_umzprojekt p1
    inner join isum.v_bi_umzprjumisteni v_bi_umzprjumisteni on v_bi_umzprjumisteni.id_projekt=p1.id
    left outer join isum.v_bi_umscisuzemnijednotky v_bi_umscisuzemnijednotky on v_bi_umzprjumisteni.id_uzemnijednotky= v_bi_umscisuzemnijednotky.id
    where V_BI_UMSCISUZEMNIJEDNOTKY.UROVEN = 5
    and v_bi_umzprjumisteni.typ in ('1'))cc5 on cc5.idcko=pp1.id

left outer join (select 
    v_bi_umscisuzemnijednotky."Název" as nazev4,
    v_bi_umscisuzemnijednotky."Kód" as kod4,
    p1.id as idcko
    from isum.v_bi_umzprojekt p1
    inner join isum.v_bi_umzprjumisteni v_bi_umzprjumisteni on v_bi_umzprjumisteni.id_projekt=p1.id
    left outer join isum.v_bi_umscisuzemnijednotky v_bi_umscisuzemnijednotky on v_bi_umzprjumisteni.id_uzemnijednotky= v_bi_umscisuzemnijednotky.id
    where V_BI_UMSCISUZEMNIJEDNOTKY.UROVEN = 4
    and v_bi_umzprjumisteni.typ in ('1'))cc4 on cc4.idcko=pp1.id

where pp1."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000920'
-- is not null 

/* AND 'SC '||substr(sc."Èíslo specifického cíle / oper",length(sc."Èíslo specifického cíle / oper")-2,3)= 'SC 2.1' */

/*and (to_number(substr(p1."Registraèní èíslo projektu",-5,5))>=:parametr1 and to_number(substr(p1."Registraèní èíslo projektu",-5,5))<:parametr2) and (v1."Integrovaný nástroj  kód" LIKE 'ITI%' or v1."Integrovaný nástroj  kód" LIKE 'IPR%') */

/*and cc3."Kód" not in ('CZ041',
'CZ031',
'CZ064',
'CZ052',
'CZ042',
'CZ053',
'CZ080',
'CZ020',
'CZ063',
'CZ051',
'CZ072',
'CZ071',
'CZ032',
'CZ010')*/


/*order by substr(p1."Registraèní èíslo projektu",-5,5) asc*/


-------------

SELECT	p."Registraèní èíslo projektu",
--	uk."Název",
--	:typ "Realizace/dopad"
		


FROM  isum.v_bi_UmzPrjGGII p
LEFT OUTER JOIN isum.v_bi_UMZPRJUMISTENIKRAJ kr ON kr.id_projekt = p.id AND
-- kr.typ=:typ AND :kr=0
-- INNER JOIN isum.v_bi_UMSCisUzemniJednotky cuj ON cuj.id = uk.id_uzemnijednotky


WHERE p."Registraèní èíslo projektu" = ('CZ.01.3.43/0.0/0.0/15_027/0006508')
-- 'CZ.01.1.02/0.0/0.0/15_002/0000920',


---------------

SELECT
p."Registraèní èíslo projektu",
decode(:kr3,0,e1.NAZEV7,'') as ZUJ,
coalesce(kr."Název",y."Název",e.NAZEV,e1.NAZEV) as "Název",
Decode(:kr,0,:typ,decode(:kr1,0,decode(:typ1,1,'Realizace',0, 'Dopad'),decode(:kr2,0,decode(:typ2,1,'Realizace',0, 'Dopad'),decode(:kr3,0,decode(:typ3,1,'Realizace',0, 'Dopad'))))) as "Realizace/Dopad"
FROM
isum.V_BI_UMZPRJGGII p
left outer join isum.V_BI_UMZPRJUMISTENIKRAJ kr on kr.ID_PROJEKT=p.ID and kr.TYP=:typ and :kr=0
left outer join isum.V_BI_UMZPRJUMISTENI ni on ni.ID_PROJEKT=p.ID and ni.TYP=:typ1 and :kr1=0
left outer join isum.V_BI_UMSCISUZEMNIJEDNOTKY y on y.ID=ni.ID_UZEMNIJEDNOTKY

left outer join isum.V_BI_UMZPRJUMISTENIGEN gn on gn.ID_PROJEKT=p.ID and gn.TYP =:typ2 and :kr2=0
left outer join isum.V_BI_UMSCISUZEMNIJEDNOTKYHIE e on e.ID=gn.ID_UZEMNIJEDNOTKY

left outer join isum.V_BI_UMZPRJUMISTENIGEN gn1 on gn1.ID_PROJEKT=p.ID and gn1.TYP =:typ3 and :kr3=0
left outer join isum.V_BI_UMSCISUZEMNIJEDNOTKYHIE e1 on e1.ID=gn1.ID_UZEMNIJEDNOTKY

WHERE
--p."Registraèní èíslo projektu" ='CZ.02.1.01/0.0/0.0/16_013/0001792'
p."Registraèní èíslo projektu" ='CZ.01.3.43/0.0/0.0/15_027/0006508'



---------------

SELECT	p."Registraèní èíslo projektu",
	nvl(soucet.suma, platba.vyuctskut) AS "Skuteènì vyuètováno",
	nvl(soucet."PORADI#Poøadí finanèního plánu",platba."PORADI#Poøadí finanèního plánu") AS "Poøadí finanèního plánu"
	
FROM isum.v_bi_UmzPrjGGII p
LEFT JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby AND platba.souctovyradek is null AND :typ=0
LEFT JOIN (SELECT id_nositelplatby,
     	  	  "PORADI#Poøadí finanèního plánu",
     	  	  sum(vyuctskut) as suma
  	   FROM isum.v_bi_UmpPlatbaPrj
	   WHERE souctovyradek is null
	   GROUP BY id_nositelplatby, "PORADI#Poøadí finanèního plánu") soucet ON soucet.id_nositelplatby = p.id AND :typ=1
  

WHERE p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000920'

--------------------

select * from
(SELECT
nvl(p."Registraèní èíslo projektu",'Celkový ') as "Reg. èíslo/celkem",
p.KODWFSTAV,
nvl(to_char(a."PORADI#Poøadí finanèního plánu"),'souèet') as "Jednotlivì/Souèet",
sum(a."VYUCTSKUT") as SUMAVYUCTSKUT
FROM
isum.v_bi_umzprjggII p
inner join isum.V_BI_UMPPLATBAPRJ a on a.ID_NOSITELPLATBY=p.ID and a.souctovyradek is null 
WHERE 
p."Registraèní èíslo projektu" in ('CZ.01.4.04/0.0/0.0/15_005/0000176')
group by rollup (p."Registraèní èíslo projektu",p.KODWFSTAV,a."PORADI#Poøadí finanèního plánu"))
where 
KODWFSTAV is not null
and (:stav='0' or decode("Jednotlivì/Souèet",'souèet','1','2')=:stav)


--------------------

select * from
(SELECT
nvl(p."Registraèní èíslo projektu",'Celkový ') as "Reg. èíslo/celkem",
p.KODWFSTAV,
nvl(to_char(a."PORADI#Poøadí finanèního plánu"),'souèet') as "Jednotlivì/Souèet",
sum(a."VYUCTSKUT") as SUMAVYUCTSKUT
FROM
isum.v_bi_umzprjggII p
inner join isum.V_BI_UMPPLATBAPRJ a on a.ID_NOSITELPLATBY=p.ID and a.souctovyradek is null 
WHERE 
p."Registraèní èíslo projektu" in ('CZ.01.4.04/0.0/0.0/15_005/0000176')
group by rollup (p."Registraèní èíslo projektu",p.KODWFSTAV,a."PORADI#Poøadí finanèního plánu"))
where 
KODWFSTAV is not null
and (:stav='0' or decode("Jednotlivì/Souèet",'souèet','1','2')=:stav)


--------------------



select * from
(SELECT
nvl(p."Registraèní èíslo projektu",'Celkový ') as "Reg. èíslo/celkem",
p.KODWFSTAV,
nvl(to_char(a."PORADI#Poøadí finanèního plánu"),'souèet') as "Jednotlivì/Souèet",
sum(a."VYUCTSKUT") as SUMAVYUCTSKUT
FROM
isum.v_bi_umzprjggII p
inner join isum.V_BI_UMPPLATBAPRJ a on a.ID_NOSITELPLATBY=p.ID and a.souctovyradek is null 
WHERE 
p."Registraèní èíslo projektu" in ('CZ.01.4.04/0.0/0.0/15_005/0000176')
group by rollup (p."Registraèní èíslo projektu",p.KODWFSTAV,a."PORADI#Poøadí finanèního plánu"))
where 
KODWFSTAV is not null
and (:stav='0' or decode("Jednotlivì/Souèet",'souèet','1','2')=:stav)


----------------

SELECT

              substr(p."Registraèní èíslo projektu",4,2) as OPKOD,

              p."Registraèní èíslo projektu" as rcp,

              k."KOD#Èíslo kontroly" as kodk,

              wf.JMENO,

              k."Dùvod znovuotevøení kontroly" as duvod,

              wf.DATUM,

              wf.JMENO2,

              wf.DATUM2,

              k.typkontrolyvycet as typ

FROM isum.V_BI_UMZPRJGGII p

              inner join isum.V_BI_UMZVYZVA v on v.id=p.ID_VYZVA

              inner join isum.V_BI_UMVKONTROLANAMISTEPRJ k on k. ID_NOSITELKONTROLY=p.ID

              inner join (select nositelid,

 case when STAVDO in ('KU01','KP02') then LAST_MODIF_UZIVATEL end as JMENO,
 
 case when STAVDO in ('KU01','KP02') then DATUMOD end as DATUM,
 
 lead(case when STAVDO in ('KN02','KP03') then LAST_MODIF_UZIVATEL end,1) over (partition by nositelid order by PORADI) as JMENO2,
 
 lead(case when STAVDO in ('KN02','KP03') then  DATUMOD end,1) over (partition by nositelid order by PORADI) as DATUM2

 FROM isum.V_BI_UMSWFHISTORIESTAVU

 where PORADI>3 and STAVDO in ('KP02', 'KP03', 'KU01', 'KN02') order by PORADI) wf on wf.nositelid=k.id

WHERE p."Registraèní èíslo projektu" is not null

 and v.id_prg in (:op)

 and wf.JMENO is not null

 and k.typkontrolyvycet in (:fk)

 and p."Registraèní èíslo projektu" in ('CZ.07.4.68/0.0/0.0/18_066/0001398','CZ.07.4.67/0.0/0.0/16_036/0000408')
