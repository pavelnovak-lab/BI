SELECT
--	v1."Číslo výzvy" as "Číslo výzvy",
-- 	v1."Název výzvy" as "Název výzvy",
-- 	p1."WFSTAV" as "WFSTAV",
-- 	p1."KODWFSTAV" as "KODWFSTAV",
-- 	p1."CZV" as "CZV",
-- 	p1."EU" as "EU",
--	p1."Název projektu CZ" as "Název projektu CZ",
	pp1."ZADATEL" as "zadatel",
	pp1."ZADATELPFORMA" AS "ZADATELPFORMA",	   
        pp1."Registrační číslo projektu",

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

where pp1."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/15_002/0000920'
-- is not null 

/* AND 'SC '||substr(sc."Číslo specifického cíle / oper",length(sc."Číslo specifického cíle / oper")-2,3)= 'SC 2.1' */

/*and (to_number(substr(p1."Registrační číslo projektu",-5,5))>=:parametr1 and to_number(substr(p1."Registrační číslo projektu",-5,5))<:parametr2) and (v1."Integrovaný nástroj  kód" LIKE 'ITI%' or v1."Integrovaný nástroj  kód" LIKE 'IPR%') */

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


/*order by substr(p1."Registrační číslo projektu",-5,5) asc*/
