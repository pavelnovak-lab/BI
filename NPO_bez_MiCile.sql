SELECT	p."Registraèní èíslo projektu" ,
	v."Èíslo výzvy" ,
	v."Název výzvy",
	ci."Název" ,
	ci."Kód" 
	

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  p.id_micil

WHERE p."Registraèní èíslo projektu" like 'CZ.31%'
