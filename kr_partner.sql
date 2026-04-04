SELECT	p."Registrační číslo projektu"
	-- ci."Název" as "Typ subjektu",
	-- va.KrajKodNUTS,
	-- uk."Název" as "Kraj realizace"
	-- um.typ,
	-- uj."Název" as "Místo realizace"

FROM isum.v_bi_UmzPrjGGII p 

INNER JOIN
( SELECT p.id
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektuedit = 300798 -- žadatel
INNER JOIN isum.v_bi_UmsRsVerzeAdresy va ON va.id = vs.id_oficialniadresa
WHERE REGEXP_LIKE(va.KrajKodNUTS, 'CZ0[4,5,7,8][0-4]') -- MRR
) zadatel ON zadatel.id = p.id
LEFT JOIN
( SELECT p.id
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektuedit = 300799 --partner s fin. příspěvkem
INNER JOIN isum.v_bi_UmsRsVerzeAdresy va ON va.id = vs.id_oficialniadresa
WHERE REGEXP_LIKE(va.KrajKodNUTS, 'CZ0[2,3,6][0-4]') -- PR
) partner ON partner.id = p.id

INNER JOIN isum.v_bi_UmzPrjUmisteniKraj uk ON uk.id_projekt = p.id AND uk.typ = 'Realizace'
-- INNER JOIN isum.v_bi_UmzPrjUmisteni um ON  um.id_projekt = p.id
-- INNER JOIN isum.v_bi_UmsCisUzemniJednotky uj ON uj.id = um.id_uzemnijednotky

WHERE p."Registrační číslo projektu" is not null 
AND   p.kodwfstav like ('PP3*')
-- vs.id = 382272380
-- AND vs.id_typsubjektuedit = 300799 --partner s fin. příspěvkem
-- AND vs.id_typsubjektuedit = 300798 --žadatel s fin. příspěvkem
-- AND um.typ = 0 -- místo realizace
-- AND va.KrajKodNUTS = napr CZ064
-- uk.KrajKodNUTS
