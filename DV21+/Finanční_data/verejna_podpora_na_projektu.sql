SELECT op."Název specifického cíle/opatření" as "Opatření" , 
    p."Registrační číslo projektu",
    rez."Režim podpory",
    clanek."Podkategorie" AS "Článek GBER",
    vpo."Částka poskytnuté veřejné podpory celkem - Příspěvek Unie v Kč" AS "Částka",
    pf."Doporučený poměr financování (%)" AS "EU podíl max",
    (100 - pf."Doporučený poměr financování (%)") AS "Vlastní podíl min"

FROM projekt AS p
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil 
INNER JOIN verejna_podpora AS vpo ON vpo.id_projekt = p.id
INNER JOIN ciselnik_rezim_podpory AS rez ON rez.id = vpo.id_rezimpodpory
INNER JOIN pomery_financovani AS pf ON vpo.id = pf.id_nositelpompf AND pf.id_zdrojfin = 415432
LEFT JOIN (
    SELECT
        gber."Podkategorie",
        vpo.id_projekt,
        vpo.id
    FROM verejna_podpora AS vpo
    INNER JOIN ciselnik_podkategorie_podpory AS gber ON gber.id = vpo.id_podkategorie
    ) AS clanek ON clanek.id_projekt = p.id AND clanek.id = vpo.id

WHERE vpo."Platnost" = 'A'
AND p."Registrační číslo projektu" IS NOT NULL
AND clanek."Podkategorie" regexp_like 'Článek č\. 2[5-9].*' 


ORDER BY "Režim podpory" ASC, "Článek GBER" DESC;



------------------------------

