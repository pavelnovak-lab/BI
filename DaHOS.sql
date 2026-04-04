SELECT 	p."Registrační číslo projektu",
--	status.pocetbodu,
--	status.*
	kv.popis AS "Krok hodnocení",
	-- kv.platnost AS "Platnost posudku",
	hodnotitel."Jméno",
	hodnotitel."Příjmení",
	hodnotitel."Externí hodnotitel",
	hodnotitel.create_uzivatel AS "Uživatelské jméno",
	hodnotitel."Kód" AS "Kód hodnotitele",
	komp."Arbitr",
	komp."Datum odeslání žádosti",
	komp."Datum vyjádření",
	komp."Datum založení záznamu",
	komp.FINALIZOVANO,
	komp."Hodnocení finalizováno",
	komp."Hodnocení založeno",
	komp.id_hodnlos,
	komp."Lhůta vyjádření",
	komp."Náhradník",
	komp."Nominace přijata",
	komp."Opravný hodnotitel",
	komp."Řádný hodnotitel",
	komp."Schvalovatel",
	komp."Platnost posudku" AS "Platný?",
	sch.SCHVALENOSCHVAL,
	sch.FINSCHVAL
	


FROM		isum.v_bi_UmzProjekt p
INNER JOIN 	isum.v_bi_UmvHodnStatusDH status ON status.id_noshodnoceni=p.id
INNER JOIN 	isum.v_bi_UmvHodnKrokVecne kv ON kv.id=status.id_krokvechodn
INNER JOIN	isum.v_bi_UmvHodnoceni hodnoceni ON hodnoceni.id_noshodnoceni=p.id
INNER JOIN	isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id=hodnoceni.id_hodnotitel
INNER JOIN 	isum.v_bi_UMVHodnotitelKomp komp ON komp.id=hodnoceni.id_hodnkomp
INNER JOIN	isum.V_BI_UMVHODNSCHVALENI sch ON hodnoceni.id=sch.id_hodnoceni
-- INNER JOIN 	isum.v_bi_UmvHodnSchvaleni schval ON schval.id=hodnoceni.id_hodnkomp



WHERE 	p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/19_262/0020117'
-- AND	status.id_krokvechodn <> 0
-- AND 	status.ID_DRUHHODN=171152    /* Vybere pouze věcné hodnocení */
-- --AND 	status.kodpopisstatutu=32    /*vybere celkový výsledek fáze věcného hodnoení*/
-- AND 	status.id_kolohodn=171212   /*vybere jen hodnocení "ostré" žádosti projektu*/
-- -- AND 	status.soulad2dh='A'
-- AND	hodnotitel."Jméno" is not null



--INNER JOIN 	isum.v_bi_UmvHodnKolo kolo ON kolo.id=status.id_kolohodn /* Napoví kolo hodnocení */
--INNER JOIN	isum.v_bi_UMVHodnStatusCis cishod ON cishod.id=status.id_statushodn







-- SELECT 	hodnotitel."Jméno",
-- 	hodnotitel."Příjmení",
-- 	hodnotitel."Externí hodnotitel",
-- 	hodnotitel.create_uzivatel AS "Uživatelské jméno",
-- 	hodnotitel."Kód" AS "Kód hodnotitele",
-- --	sch.SCHVALENOSCHVAL,
-- --	sch.FINSCHVAL,
-- 	sch.*

-- FROM		isum.v_bi_UmvHodnoceni hodnoceni 
-- RIGHT JOIN 	isum.v_bi_UMVHodnotitelKomp komp ON komp.id=hodnoceni.id_hodnkomp
-- RIGHT JOIN	isum.v_bi_UmvHodnotitel hodnotitel ON hodnotitel.id=hodnoceni.id_hodnotitel
-- RIGHT JOIN	isum.V_BI_UMVHODNSCHVALENI sch ON hodnoceni.id=sch.id_hodnoceni
-- -- RIGHT JOIN 	isum.V_BI_UMVHODNSCHVALENIPRJ schval ON hodnotitel.id=schval.id_hodnotitel

-- WHERE hodnoceni.id=989293169
-- -- komp.id=964395652
-- -- hodnotitel.id=938460614

