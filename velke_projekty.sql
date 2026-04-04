SELECT  SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
	p."Název projektu CZ" ,
	p.zadatel,
	p."Registrační číslo projektu" ,
	pzf."Příspěvek Unie",
	p.kodwfstav ,
        pril."Link DMS" "Tisková verze ŽoPo"	

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 
INNER JOIN isum.v_bi_UMSPrilohyProjekt pril ON pril.id_nositelpril = p.id AND pril.id_druhpril =  (9172223)
-- INNER JOIN  
-- (SELECT SUBSTR(p.kompetencniutvar, 6) AS pp ,
--        -- p."Registrační číslo projektu",
--        max(pzf."Příspěvek Unie") eu

-- FROM isum.v_bi_UmzProjekt p
--  JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav


-- WHERE p.kodwfstav like 'PP4%'
-- AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
-- -- p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/20_318/0024679'
-- GROUP BY SUBSTR(p.kompetencniutvar, 6) 
-- -- ORDER BY pzf."Příspěvek Unie" desc
-- ) pp_max ON SUBSTR(p.kompetencniutvar, 6) = pp_max.pp AND pp_max.eu = pzf."Příspěvek Unie"


INNER JOIN 
(SELECT SUBSTR(p.kompetencniutvar, 6) AS pp ,
       -- p."Registrační číslo projektu",
       -- pril."Link DMS" "Tisková verze ŽoPo"
       max(pzf."Příspěvek Unie") eu

FROM isum.v_bi_UmzProjekt p
 JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav
-- INNER JOIN isum.v_bi_UMSPrilohyProjekt pril ON pril.id_nositelpril = p.id AND pril.id_druhpril =  (9172223)

WHERE p.kodwfstav = 'PN23a'
AND p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4') 
-- p."Registrační číslo projektu" = 'CZ.01.1.02/0.0/0.0/20_318/0024679'
GROUP BY SUBSTR(p.kompetencniutvar, 6) 
-- ORDER BY pzf."Příspěvek Unie" desc
) pp_min ON SUBSTR(p.kompetencniutvar, 6) = pp_min.pp AND pp_min.eu = pzf."Příspěvek Unie"

WHERE p.kodwfstav like ('PP23a')
-- p."Název projektu CZ" IN ('Vývoj personalizované lyžařské přilby s využitím digitálních technologií','Inovace recyklačního procesu průmyslových akumulátorů a baterií společnosti NIMETAL, spol. s r.o.', 'Výzkum a vývoj nového systému MEDIMONITOR pro inteligentní prognózování vývoje diagnóz', 'P4.0 v LAKUM GALMA', 'Zavedení non-IT výroby, skladování a digitální transformace ve společnosti Mironet.cz a.s.', 'Rekonstrukce objektu Parketárna Úvaly', 'Kotel na vytápění biomasou pro společnost DUDINGER s.r.o', 'Výroba chladu s parním absorpčním systémem', 'Areál ekologického využití komunálních odpadů Mladá Boleslav – čištění bioplynu a plnění CNG – COMPAG MLADÁ BOLESLAV s.r.o.', 'Digitalizace společnosti FSG Finaudit, s. r. o.', 'Výzkumně vývojové centrum pro GLP testování', 'Vývoj prototypu meteorologického radaru ve společnosti METEOPRESS, spol. s r.o.', 'ITI PMO – Posílení kapacit coworkingu a technologického centra BIC Plzeň', 'Vývoj zařízení pro pyrolýzní zpracování čistírenských kalů', 'Revitalizace haly Fibichova', 'Školicí středisko Sh Slavonice', 'Automatizace a digitalizace výrobního procesu školního nábytku ve společnosti SANTAL spol. s r. o.', 'Propojení soustav SZT v Písku za účelem úspor primární energie', 'Travní tašky', 'Úspory energie ve výrobním středisku Písek','Monokrystaly v optoelektronice', 'Zavedení inovativní technologie výroby z druhotných surovin', 'Využití druhotných surovin z elektrovodičů pro vstřikované dlaždice ve společnosti Fortemix produkce s.r.o.')
ORDER BY SUBSTR(p.kompetencniutvar, 6) , p."Název projektu CZ" 
