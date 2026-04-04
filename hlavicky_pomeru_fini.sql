SELECT	DISTINCT v."Název výzvy",
	v."Číslo výzvy"
	-- ci."Název",
	-- ci.id

FROM isum.v_bi_UMFPomeryHlavicka ph
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=ph.id_nositelpompf
INNER JOIN isum.v_bi_UMSCisMiryVP cis ON cis.id = ph.id_verejnapodpora
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = cis.id_rezimpodpory

WHERE
-- ph.id in (1127589496, 179463381)
NOT EXISTS
(SELECT 1
 FROM isum.v_bi_UmsCisZakladni cz
 WHERE cz.id = 1196332
 AND ci.id = cz.id)
