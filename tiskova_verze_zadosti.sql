SELECT mapa.*

FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UMSPrilohyProjekt pril ON pril.id_nositelpril = p.id 
-- INNER JOIN isum.v_bi_UMSPrilohy pril ON pril.id_nositelpril = p.id 
-- INNER JOIN isum.v_bi_UMSRSVerzeSubjektu verze ON verze.id = pril.id_verzesubjektu
INNER JOIN isum.V_BI_UMSVerzMapa mapa ON mapa.id = pril.id_verzmapa



WHERE p.id = 904115573
-- AND pril.DRUHPRIL = '®ádost o podporu individuálního projektu'
AND pril.id_druhpri = 9172223
-- AND pril."Druh dokumentu = '®ádost o podporu individuálního projektu'
