SELECT 	p."Registraèní èíslo projektu",
	p."Název projektu CZ",
	v."Èíslo výzvy",
	v."Název výzvy",
	p.kodwfstav,
	p.eu,
	p.czv,
	p.wfstav,
	p.wfstavdatum
--	hs.datumod,

FROM 		isum.v_bi_Umzprjgg p
-- INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 
INNER JOIN	isum.v_bi_umzvyzva v ON p.id_vyzva=v.id

WHERE
-- v."Èíslo výzvy" in ('01_17_106','01_17_107')

-- AND hs.STAVDO in ('PP21','PP22')
AND p.kodwfstav like ('PP21','PP22')


AND EXISTS
(SELECT p."Registraèní èíslo projektu" 
	FROM 		isum.v_bi_Umzprjggii pp
	INNER JOIN	isum.v_bi_umswfhistoriestavu hs ON hs.nositelid=p.id 
	WHERE hs.STAVDO = 'PN29'
	AND pp.id=p.id)

-- ORDER BY "Poèet dní po FNaP"




CZ.01.3.10/0.0/0.0/17_138/0011587|CZ.01.3.10/0.0/0.0/17_178/0014021|CZ.01.1.02/0.0/0.0/20_321/0024869|CZ.01.1.02/0.0/0.0/19_262/0020350|CZ.01.3.10/0.0/0.0/17_101/0013545|CZ.01.3.14/0.0/0.0/19_254/0022126|CZ.01.3.10/0.0/0.0/17_138/0011726|CZ.01.3.10/0.0/0.0/17_178/0013966|CZ.01.3.10/0.0/0.0/18_183/0017773|CZ.01.1.02/0.0/0.0/15_002/0002493|CZ.01.3.14/0.0/0.0/18_186/0018444|CZ.01.3.10/0.0/0.0/17_178/0013478|CZ.01.1.02/0.0/0.0/15_014/0000112|CZ.01.1.02/0.0/0.0/15_018/0001238



SELECT *
FROM isum.v_bi_UMVHodnVyporadani
WHERE id = 216900321
