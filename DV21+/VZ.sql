-- CREATE or REPLACE view "KL na VZ" FOLDER= AS 

SELECT p."Registraèní èíslo projektu" ,
       sk."Název souboru kritérií" "Název KL" ,
       z."Poøadové èíslo" "Poøadové èíslo VZ",
       vypr."Pøíjmení" "Vypracovala KL" ,
       sch."Pøíjmení"  "Schválila KL" ,
       k."Datum zahájení kontroly" ,
       k."Datum ukonèení kontroly",
       z."Název veøejné zakázky",
       k."Název kontroly",
       k."Pøedmìt kontroly"
       -- k."Zkontrolované fáze VZ",
       -- hs."Zmìnil/a",
       

FROM projekt p 
INNER JOIN zakazka_projekt zp ON zp.id_projekt = p.id
INNER JOIN zakazka z ON z.id = zp.id_vz
INNER JOIN kontrola k ON k.id_nositelkontroly = z.id
INNER JOIN historie_stavu hs ON hs.nositelid = k.id
INNER JOIN ciselnik_stav_workflow kstav ON kstav.id = hs.id_stavdo
INNER JOIN hodnoceni h ON h.id_noshodnoceni = k.id
INNER JOIN zamestnanec sch ON sch.id = h.id_schvalil
INNER JOIN zamestnanec vypr ON vypr.id = h.id_vypracoval
INNER JOIN soubor_kriterii sk ON sk.id = h.id_souborkrit


WHERE -- k.id = 200076825
p."Registraèní èíslo projektu" is not null  -- = 'CZ.01.04.01/01/22_006/0000307'
-- AND kstav."Kód" = 'AOP03' -- kontrola ukonèena
-- AND h.id IN (200105468, 200077877)

ORDER BY  p."Registraèní èíslo projektu" , z."Poøadové èíslo"
