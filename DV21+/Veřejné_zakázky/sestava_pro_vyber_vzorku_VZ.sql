SELECT p."Registrační číslo projektu",
       s."Název subjektu" 
       k.*
FROM kontrola k
INNER JOIN projekt p ON p.id = k.id_projekt
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s."Neplatný od" is null -- AND s.id_typsubjektuedit IN (413462, 413467) -- žadatel, partner s FP
INNER JOIN ciselnik_typ_subjektu ts ON ts.id = s.id_typsubjektuedit 
-- INNER JOIN ciselnik_stav_workflow wvz ON k.id_wfstav = wvz.id 
-- LEFT JOIN ciselnik_mira_zavaznosti_zjisteni mz ON k.id_mirazavaznosti = mz.id
-- LEFT JOIN ciselnik_podrobnosti_k_ukonceni_kontroly_se_zjistenim cpk ON cpk.id = k.id_ukonkontr AND k.id_ukonkontr > 0
INNER JOIN ciselnik_kontrolni_organ ko ON ko.id = k.id_kontrorgan

-- WHERE k.id_nositelkontroly = 387238675
WHERE ko."Organizační jednotka" = 'Oddělení kontrol výběrových řízení'
-- GROUP BY k.id_nositelkontroly 




