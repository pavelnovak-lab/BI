SELECT p."Registraèní èíslo projektu" ,
       p."Název projektu CZ" ,
       p.zadatel ,
       p."IÈ",
       p.typpodepsani,
       REPLACE(REPLACE(p."Jaký problém projekt øe¹í?" ,CHR(10),' | '),CHR(13),' | ') AS "Jaký problém projekt øe¹í?",
       REPLACE(REPLACE(p."Anotace projektu",CHR(10),' | '), CHR(13),' | ') as "Anotace projektu",
       TO_CHAR(p."Datum zahájení pøedp",'dd.MM.yyyy') AS "Datum zahájení pøedp",
       TO_CHAR(p."Datum ukonèení pøedp",'dd.MM.yyyy') AS "Datum ukonèení pøedp",
       indprj."Cílová hodnota" "Poèet inovací, cílová hodnota",
       pol."Èástka za 1 rok" "Celkové výdaje 2023",
       pol."Èástka za 2 rok" "Celkové výdaje 2024",
       pol."Èástka za 3 rok" "Celkové výdaje 2025",
       pol."Èástka za 4 rok" "Celkové výdaje 2026",
       fp."Celkové zdroje",
       fp."Celkové nezpùsobilé výdaje",
       fp."JPP nezpùsobilé",
       fp."Celkové zpùsobilé výdaje",
       fp."Jiné penì¾ní pøíjmy (JPP)",
       fp."CZV bez pøíjmù",
       fp."Pøíspìvek Unie",
       fp."Národní veøejné zdroje",
       fp."Podpora celkem",
       fp."Vlastní zdroj financování",
       adr."Adresa uvedená textovì",
       adr.KODYTYPUADRESY "R/A - adresa",
       o1.nazev as "Hl. kont. osoba",
       o1.mail as "Email",
       o1.telefon as "Tel",
       o1.mobil as "Mobil" ,

       listagg (cis."Název" , '; ' on overflow truncate) "Odbornost projektu",
       listagg (cis."Kód" , '; ' on overflow truncate) "Kód odbornosti" ,

       listagg(DISTINCT ci."Název", '; ' on overflow truncate) "Klíèové aktivity",
       listagg(DISTINCT ci."Kód", '; ' on overflow truncate) "Kód klíèové aktivity",

       LISTAGG(DISTINCT cn."Kód",'; ' on overflow truncate) AS "Kód CZ NACE",
       LISTAGG(DISTINCT cn."Název",'; ' on overflow truncate) AS "Název CZ NACE" 


FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMVHodnNosOdbornost odb ON odb.id_noshodnoceni = p.id
INNER JOIN isum.V_BI_UMSCisOdbornost cis ON odb.id_odbornost = cis.id
INNER JOIN isum.V_BI_UMVAKTIVITY akt ON akt.id_nositelakt = p.id
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = akt.id_ciska
LEFT JOIN isum.v_bi_umsrscznace n ON n.id_subjekt=p.id_zadatel AND n."Je souèástí projektu?" = 'A'
LEFT JOIN isum.v_bi_umsciszakladni cn ON cn.id=n.id_cznace
INNER JOIN isum.v_bi_UmvIndiHodnotaPRJ indprj ON indprj.id_nositelindi=p.id 
INNER JOIN isum.v_bi_UmvIndikator ind ON ind.id=indprj.id_indikator
INNER JOIN isum.v_bi_umsciszakladni cis ON cis.id=ind.id_mernajednotka
INNER JOIN isum.v_bi_UMFROZHlavickaPrj hl ON p.id = hl.id_nrozpocet AND hl."Aktuální" = 'A'
INNER JOIN isum.V_BI_UMFROZPOLOZKYPRJ pol ON pol.id_hlavicka = hl.id AND pol."Kód" = '1'
INNER JOIN isum.v_bi_UMFPFCelkem fp ON fp.id_projekt = p.id AND fp.id_faze = 99991000000000005
INNER JOIN isum.v_bi_umzprjggvs pggvs ON pggvs.id=p.id_zadatel  
LEFT JOIN ISUM.V_BI_UMSRSVERZEADRESY adr on pggvs.id_oficialniadresa=adr.id
LEFT JOIN 
 (select
  (LISTAGG (CONCAT(o."Jméno", (concat(' ',o."Pøíjmení"))), ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Pøíjmení")))) ) AS nazev,
 (LISTAGG (o."Email", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Pøíjmení")))) ) AS mail,
 (LISTAGG (o."Telefon", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Pøíjmení")))) ) AS telefon,
 (LISTAGG (o."Mobil", ', ') WITHIN GROUP (ORDER BY CONCAT(o."Jméno", (concat(' ',o."Pøíjmení")))) ) AS mobil,
 o.id_verzesubjektu as vazba
 from isum.v_bi_umsrsverzeosoby o
 inner join isum.v_bi_umzprjggvs vs on vs.id_verzesubjektu=o.id_verzesubjektu
 where o."Hlavní kontaktní osoba" ='A'
 group by o.id_verzesubjektu
 ) o1 on o1.vazba=pggvs.id_verzesubjektu

WHERE p."Registraèní èíslo projektu" is not null 
-- p."Registraèní èíslo projektu" = 'CZ.31.4.0/0.0/0.0/22_017/0002823'
AND indprj.ID_SPECCIL > 0
-- AND p.id_vyzva = 1607294465 -- vyzva  '31_22_017'
AND p.id_vyzva = 1775714122 -- vyzva  '31_23_069'

GROUP BY p."Registraèní èíslo projektu" ,
       p."Název projektu CZ" ,
       p.zadatel ,
       p."IÈ",
       p.typpodepsani,
       p."Jaký problém projekt øe¹í?",
       p."Anotace projektu",
       p."Datum zahájení pøedp",
       p."Datum ukonèení pøedp",
       pol."Èástka za 1 rok",
       pol."Èástka za 2 rok",
       pol."Èástka za 3 rok",
       pol."Èástka za 4 rok",
       indprj."Cílová hodnota",
       fp."Celkové zdroje",
       fp."Celkové nezpùsobilé výdaje",
       fp."JPP nezpùsobilé",
       fp."Celkové zpùsobilé výdaje",
       fp."Jiné penì¾ní pøíjmy (JPP)",
       fp."CZV bez pøíjmù",
       fp."Pøíspìvek Unie",
       fp."Národní veøejné zdroje",
       fp."Podpora celkem",
       fp."Vlastní zdroj financování",
       adr."Adresa uvedená textovì",
       adr.KODYTYPUADRESY,
       o1.nazev ,
       o1.mail ,
       o1.telefon,
       o1.mobil 


ORDER BY p."Registraèní èíslo projektu"
