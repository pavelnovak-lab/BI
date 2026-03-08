
SELECT p."Registraèní èíslo projektu",
       -- p."Datum registrace ¾ádosti",
       -- ek.datumcertifikace,
      p."IÈ" 
       -- vs."IÈ zahranièní / REGON",
       -- vs.ID_VELIKOSTPODNIKU,
       -- ci."Název" 

FROM isum.v_bi_UmzProjekt p
-- INNER JOIN isum.v_bi_UmsWFHistorieStavu hs ON hs.NositelId = p.id 
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
-- INNER JOIN isum.v_bi_UmpCastkySchval castky ON platba.id_SchvaleneCastky=castky.id 
-- INNER JOIN isum.v_bi_UmpCertifikace cert ON p.id = cert.id_projekt
-- INNER JOIN isum.v_bi_UMPEKPlatba ek ON ek.id = cert.id_perioda
-- -- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON cert.id_platba=platba.id

-- INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id AND vs.id_typsubjektu = 300784 -- zadatel
-- INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  vs.id_velikostpodniku

WHERE
-- p."Datum registrace ¾ádosti" is null
-- AND p."Registraèní èíslo projektu" is not null 
p."Registraèní èíslo projektu" in ( 'CZ.01.4.04/0.0/0.0/16_076/0009479','CZ.01.3.10/0.0/0.0/19_251/0022360')

-- AND p."Datum registrace ¾ádosti"  < to_date('2021-01-01','yyyy-mm-dd')
-- AND cert."Typ certifikace" = 2
-- AND vs.neplatny is null
-- AND ek.datumcertifikace < to_date('2020-01-01','yyyy-mm-dd')
-- AND ek.datumcertifikace >= to_date('2019-01-01','yyyy-mm-dd')
AND EXISTS
(SELECT 1

FROM isum.v_bi_UmpCertifikace cert 
INNER JOIN isum.v_bi_UMPEKPlatba ek ON ek.id = cert.id_perioda

WHERE p.id = cert.id_projekt
AND cert."Typ certifikace" = 2
AND ek.datumcertifikace < to_date('2020-01-01','yyyy-mm-dd')
AND ek.datumcertifikace >= to_date('2019-01-01','yyyy-mm-dd')
)





SELECT *

FROM isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
