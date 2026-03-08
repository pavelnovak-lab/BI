-- CREATE or REPLACE view "RIS3_T2_OPTAK" FOLDER='/06_Data_models/29_RIS3/01_OPTAK' AS 
SELECT '01' "Operační program (KOD)",
      'Operační program podnikání a inovace pro konkurenceschopnost' "Operační program (NÁZEV)",
       sc.kodnovy "Kód SC",
       sc.nazev "Název SC",
       op.nazev as "Opatření" ,
       i."Kód NČI 2021+" "Kód indikátoru",
       i."Název indikátoru CZ" "Název indikátoru",
       cti."Typ indikátoru" ,
       cmj."Název měrné jednotky" "Měrná jednotka",
       sum(ip."Výchozí hodnota") "Výchozí hodnota",
       sum(ip."Cílová hodnota") "Cílová hodnota",
       sum(ip."Dosažená hodnota") "Dosažená hodnota"

       
FROM  v_rav_umshisc op -- on op.id=vh.id_speccil 
INNER JOIN v_rav_umshisc AS sc ON sc.id = op.id_hierarchie
INNER JOIN indikator_hodnota_program ip ON ip.id_speccil = op.id
INNER JOIN indikator i on ip.id_indikator = i.id
INNER JOIN ciselnik_merna_jednotka cmj on i.id_mernajednotka = cmj.id
INNER JOIN ciselnik_typ_indikatoru cti ON cti.id = i.id_typindi

WHERE (
     (op.nazev = 'Aplikace' AND i."Kód NČI 2021+" IN  ('214001','214011','204002'))
     OR
     (op.nazev = 'Digitální podnik' AND i."Kód NČI 2021+" IN ('101022','103002','250001','107301'))
     OR
     (op.nazev = 'Inovační vouchery' AND i."Kód NČI 2021+" IN ('214001','214011','101022','103002','200002'))
     OR
     (op.nazev = 'Marketing' AND i."Kód NČI 2021+" IN ('101022','101042'))
     OR
     (op.nazev = 'Partnerství znalostního transferu' AND i."Kód NČI 2021+" IN ('101022','103002','200002'))
     OR
     (op.nazev = 'Poradenství' AND i."Kód NČI 2021+" IN ('101022','101042'))
     OR
     (op.nazev = 'Potenciál' AND i."Kód NČI 2021+" IN ('241020','204002'))
     OR
     (op.nazev = 'Proof of concept' AND i."Kód NČI 2021+" IN ('214001','214011','101022','103002','200002'))
     OR
     (op.nazev = 'Služby infrastruktury' AND i."Kód NČI 2021+" IN ('101022','103002','200002','204002'))
     OR
     (op.nazev = 'Spolupráce' AND i."Kód NČI 2021+" IN ('101022','103002','200002','204002'))
     OR
     (op.nazev = 'Vysokorychlostní internet' AND i."Kód NČI 2021+" IN ('302031','303031'))
     OR
     (op.nazev = 'Expanze' AND i."Kód NČI 2021+" IN ('101052'))
     OR
     (op.nazev = 'Rizikový kapitál' AND i."Kód NČI 2021+" IN ('101052'))
     OR
     (op.nazev = 'Inovace' AND i."Kód NČI 2021+" IN ('212002','225010','204002'))
      )
     
GROUP BY "Operační program (KOD)",
         "Operační program (NÁZEV)",
         sc.kodnovy,
       	 sc.nazev ,
       	 op.nazev  ,
         "Kód indikátoru",
         "Název indikátoru",
       	 cti."Typ indikátoru" ,
         "Měrná jednotka"

ORDER BY sc.kodnovy, op.nazev, "Kód indikátoru"
