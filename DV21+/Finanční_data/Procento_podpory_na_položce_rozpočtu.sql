SELECT -- op.nazev as "Opatøení" ,
       p."Registraèní èíslo projektu" ,
       spol."Kód" ,
       spol."Název",
       vpo."Èástka poskytnuté veøejné podpory celkem - Pøíspìvek Unie v Kè" / vpo."Èástka poskytnuté veøejné podpory celkem v Kè" * 100 AS "Procento podpory",
       vpo.id_nositel,
       substring(spol."Kód" , 0, len(spol."Kód") - 2) "Kód polo¾ky"


FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva 
INNER JOIN v_rav_umzvyzvamd AS md ON md.id_vyzva = v.id AND md.platnost = 'A' AND md.id_cisseznam = 278210  
INNER JOIN rozpocet_skupina_polozka spol ON spol.id_predpis = md.id_ciszakladni --  sr.id --  AND UPPER(spol."Název") like ('%PAU©%') OR UPPER(spol."Název") like ('%NEPØÍM%')
INNER JOIN ciselnik_kombinace_verejne_podpory kvpo ON kvpo.id = spol.id_verejnapodpora
INNER JOIN verejna_podpora vpo ON vpo.id_projekt = p.id -- AND vpo."Platnost" = 'A' AND vpo.id_verejnapodpora = kvpo.id 


WHERE   p."Registraèní èíslo projektu" IN ( 'CZ.01.01.01/01/22_002/0000447')
