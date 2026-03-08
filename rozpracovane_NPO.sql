SELECT	p."Identifikace ¾ádosti (Hash)",
	p.ZADATEL,
	p."Unikátní kód stavu",
   	p."Název projektu CZ",
	p.velikostpodniku,
	p.wfstav,
	p.kodwfstav,
	p.WFStavDatum,
	v."Èíslo výzvy",
	v."Název výzvy",
	p."Registraèní èíslo projektu" 

FROM isum.v_bi_umzprojekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 

WHERE v."Èíslo výzvy" = (:cv)



---------------------------------
SELECT p.*

FROM isum.v_bi_UmzProjekt p

WHERE p."Identifikace ¾ádosti (Hash)" = '1PUbrFP'
