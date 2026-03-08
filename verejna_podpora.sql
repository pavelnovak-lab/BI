CREATE or REPLACE view "tak-mpo-novak-pavel Nenulové VPo na projektech" FOLDER='' AS 
SELECT op.nazev as "Opatøení" ,
       v."Èíslo výzvy",
       v."Název výzvy" ,
       p."Registraèní èíslo projektu" ,
       w."Kód" "Kód stavu" ,
       rp."Re¾im podpory",
       kvpo."Kód",
       kvpo."Název" ,
       vpo."Èástka veøejné podpory\n (CZK, dotaèní zdroje)",
       vpo."Èástka poskytnuté veøejné podpory celkem - Ostatní zdroje v Kè",
       vpo."Èástka poskytnuté veøejné podpory celkem v Kè",
       vpo."Platnost",
       vpo."Souètový øádek"

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id   
INNER JOIN verejna_podpora vpo ON vpo.id_projekt = p.id
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN ciselnik_kombinace_verejne_podpory kvpo ON vpo.id_verejnapodpora = kvpo.id
INNER JOIN ciselnik_rezim_podpory rp ON vpo.id_rezimpodpory = rp.id	


WHERE  p."Registraèní èíslo projektu" is not null
AND vpo."Èástka veøejné podpory\n (CZK, dotaèní zdroje)" > 0
AND vpo."Souètový øádek" is null 

ORDER BY p."Registraèní èíslo projektu", rp."Re¾im podpory", kvpo."Kód"
