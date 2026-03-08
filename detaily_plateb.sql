SELECT p.kompetencniutvar AS "Komponenta" ,
	p.kodprioritniosa,
       v."Èíslo výzvy",
       v."Název výzvy",

       sdp.*
       -- kl.wfstav ,

       -- ci."Název" "Druhové tø. polo¾ka",
       -- ci."Kód" "Kód polo¾ka",
       -- cis."Název" "Odvìtvové tøídìní, paragraf",
       -- cis."Kód" "Paragraf kód"

       -- kl.DATUMZUCTOVANIUIS,
       -- kl.WFSTAV
       
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UMZSablonaDP sdp ON sdp.id_nositelsablony = v.id
-- isum.v_bi_UmpPlatbaPrj platba
-- INNER JOIN isum.v_bi_UMPKlasifikace kl ON kl.idprojekt = p.id
-- ON kl.id_platba = platba.id
-- INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id =  kl.id_polozka
-- INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id =  kl.id_paragraf
      
WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
-- AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PU30') 
-- kl."Èíslo ¾ádosti o platbu" = 'CZ.01.1.02/0.0/0.0/20_321/0024444/2022/002/POST'
-- AND kl.id = 1730593191
-- AND kl.wfstav = 'Proplacená OSS'
AND v."Èíslo výzvy" = '31_22_006'


----------------------------------------
SELECT *
FROM isum.v_bi_UMZSablonaDP
WHERE id = 1571138904

-- 1571138904


SELECT v.*
FROM isum.v_bi_UmzVyzva v
WHERE -- id = 1571138904
v."Èíslo výzvy" = '31_22_006'
