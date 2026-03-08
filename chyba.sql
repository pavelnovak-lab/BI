select	p."Registraèní èíslo projektu",
	p.kodprioritniosa,
	v."Název výzvy",
	pl."VYUCTPLAN#Vyúètování plán",
	pl."PORADI#Poøadí finanèního plánu",
	pl.vyuctskut,
        pl.kurz,
	pl."Závìreèná platba",
	pl.kodwfstav,
	pl."Datum zmìny stavu",
	D."datum proplacení",
	c.vyuctczvcelk,
	c.VYUCTDOTBEZJPPCELK,
	s."Poøadové èíslo",
	s.VYDAJESCHVAL,
	s."Celková èástka \nuvedená na do",
	sk."Kód",
	sk."Název"

from 		isum.v_bi_umpplatbaprj pl
inner join 	isum.v_bi_umpcastkyschval c on pl.id_schvalenecastky = c.id
inner join 	isum.v_bi_umzprojekt p on p.id = c.id_projekt
inner join	isum.v_bi_umzvyzva v on v.id = p.id_vyzva
inner join	isum.v_bi_umfsoupiskadoklad s on s.id_platba = pl.id
inner join	isum.v_bi_umfrozskupinapol sk on sk.id = s.id_cispolozka


inner join

(select	pl.id,
	min (h.datumod) as "datum proplacení"


from		isum.v_bi_umpplatbaprj pl
inner join 	isum.v_bi_umswfhistoriestavu h on h.nositelid= pl.id

where	h.stavdo in ('P10','P11')
group by pl.id) D

on D.id = pl.id


where	p."Registraèní èíslo projektu" is not null
and s."Souètový øádek" is null
--and (p.kodprioritniosa in (:po) or least (:po) is null)
--and (v."Název výzvy" in (:vyzva) or least (:vyzva) is null)
and p."Registraèní èíslo projektu" = 'CZ.01.3.09/0.0/0.0/17_158/0013010'



SELECT p."Registraèní èíslo projektu" ,
       v."Název výzvy" ,
       v."Èíslo výzvy" 

FROM 	isum.v_bi_umzprojekt p
INNER JOIN isum.v_bi_umzvyzva v on v.id = p.id_vyzva

WHERE p."Registraèní èíslo projektu" is not null
AND (v."Název výzvy" in (:vyzva))

-- and p."Registraèní èíslo projektu" = 'CZ.01.3.09/0.0/0.0/17_158/0013010'



SELECT
	-- count(sml.id) "Poèet",
      	sml.typ,
	p."Registraèní èíslo projektu",
	p.kodwfstav 

FROM isum.v_bi_umfsmlouva sml
INNER JOIN isum.v_bi_UmzPrjGGII p ON sml.idprojekt = p.id

WHERE (sml.typ = 'Rozhodnutí o zamítnutí ¾ádosti' or sml.typ = 'Usnesení o zastavení øízení') 

ORDER BY sml.typ


-- GROUP BY sml.typ

-- ORDER BY "Poèet"
