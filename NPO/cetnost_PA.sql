SELECT	sml.typ,
	count(p."Registraèní èíslo projektu")

FROM isum.v_bi_umfsmlouva sml
INNER JOIN isum.v_bi_UmzProjekt p ON sml.idprojekt = p.id

WHERE -- p."Registraèní èíslo projektu" like 'CZ.01.%'
-- (sml.typ = 'Rozhodnutí o odnìtí dotace') 
-- AND p.wfstavdatum > to_date('2021-04-07','yyyy-mm-dd')
--AND
p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22','31.26') 

group by sml.typ

order by count(p."Registraèní èíslo projektu") desc
