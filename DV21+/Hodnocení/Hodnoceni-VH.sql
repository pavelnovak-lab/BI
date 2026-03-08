CREATE or REPLACE view "vysledky_vh" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Hodnoceni' AS	
SELECT op."Název specifického cíle/opatření" as "Opatření" ,
       v."Číslo výzvy",
       v."Název výzvy",
       p."Registrační číslo projektu" ,
       w."Kód" "Stav projektu" ,
       w."Název" "Název stavu",
       krok."Krok hodnocení",
       skv."Bodová hranice" "Bodová hranice z výzvy",
       h."Pořadí" "Pořadí posudku",
       hdntl."Kód uživatele",
       hdntl."Interní hodnotitel" ,
       h."Arbitr",
       h."Výsledek (v bodech)",
       status."Název" "Status posudku",
       s."Popis statutu" "Popis statutu kroku VH"    
       

FROM projekt p
INNER JOIN ciselnik_stav_workflow w ON p.id_wfstav = w.id  
INNER JOIN vyzva v ON v.id = p.id_vyzva
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN specificky_cil op on op.id=vh.id_speccil
INNER JOIN soubor_kriterii_vyzvy skv ON skv.id_vyzva = v.id
      AND skv.id_kolohodnoceni= 488844 /* hodnocení "ostré" žádosti (nikoli předběžné) */
      AND skv."Platnost do" IS NULL /* na výzvách existují i zneplatněné soubory kritérií s ukončenou platností, ty nás nezajímají */
      AND skv.id_vardruhhodn = 488774 /* věcné hodnocení */
      AND skv."Počet hodnotitelů" = 2 /* VH hodnoctí vždy dva hodnotitelé */
INNER JOIN hodnoceni h ON h.id_noshodnoceni = p.id AND h.id_krokvechodn = skv.id_krokvechodn
INNER JOIN ciselnik_krok_vecneho_hodnoceni krok ON krok.id = h.id_krokvechodn
INNER JOIN hodnotitel hdntl ON hdntl.id = h.id_hodnotitel 
INNER JOIN ciselnik_status_hodnoceni status ON status.id = h.id_statushodn
INNER JOIN hodnoceni_status s ON s.id_noshodnoceni = p.id AND skv.id = s.id_vazbaskvyz 
-- INNER JOIN ciselnik_typ_vysledku_hodnoceni typ ON typ.id = s.id_typvysledku


WHERE (v."Číslo výzvy" NOT LIKE 'CLLD%' OR v."Číslo výzvy" NOT LIKE 'ITI%')
AND h."Opravný posudek" = 'N'
AND h.id_kolohodnoceni= 488844 -- 171212   /* hodnocení "ostré" žádosti */
AND h."Platný" = 'A'
AND h.id_druhhodn = 488571 -- věcné hodnocení
AND p."Registrační číslo projektu" in ('CZ.01.01.01/01/22_002/0000076','CZ.01.02.01/04/23_017/0002699')
-- AND krok."Krok hodnocení" = '1. krok věcného hodnocení'



ORDER BY "Opatření", p."Registrační číslo projektu" , h."Pořadí"
