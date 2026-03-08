SELECT	p."Registraèní èíslo projektu" ,
	SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
	SUBSTR(p.kompetencniutvar, 9) AS "Komponenta NPO",

FROM isum.v_bi_UmzProjekt p

WHERE p."Registraèní èíslo projektu" IN ('CZ.31.3.0/0.0/0.0/22_001/0005171','CZ.01.3.14/0.0/0.0/18_185/0018385')
