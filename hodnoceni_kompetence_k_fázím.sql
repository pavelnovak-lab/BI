bSELECT hd."Øádný hodnotitel",
       hd."Schvalovatel",
       hd."Opravný hodnotitel",
       hd."Arbitr",
       cis.Nazev "Fáze hodnocení",
       -- hodn."Název" "Jméno hodnotitele",
       hodn."Interní hodnotitel",
       hodn."Kód" "Kód hodnotitele"

FROM isum.v_bi_UMVHodnotitelDruh hd
INNER JOIN isum.V_BI_UMVHodnDruhCis cis ON cis.id = hd.id_druhhodn
INNER JOIN isum.V_BI_UMVHodnotitelPrg hprg ON hprg.id = id_hodnotitelprg
INNER JOIN isum.V_BI_UmvHodnotitel hodn ON hodn.id = hprg.id_hodnotitel

WHERE hodn."Pøíjmení" IN ('Hyková','Koøínková','Jurka','©tìpánek','Kulík')

ORDER BY hodn."Název"
