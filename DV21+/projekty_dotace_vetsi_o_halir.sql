CREATE or REPLACE view "RIS3_OPTAK" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/RIS3' AS 
SELECT p."Registraèní èíslo projektu",
	pf."Doporuèený pomìr financování (%)",
	umpf.proc_eu, 
    umpf.eu,
    umpf.czv,
    umpf.eu/umpf.czv,
    w.kod,
    v."Èíslo výzvy",
    v."Název výzvy" 

from projekt p
INNER JOIN vyzva v ON v.id=p.id_vyzva 
inner join pomery_financovani pf on pf.id_nositelpompf = p.id
INNER JOIN v_rav_umfpfcelkem umpf on umpf.id_projekt = p.id AND umpf.id_faze = 99991000000000005 AND umpf.czv <> 0
INNER JOIN v_rav_umscisstavwf w ON w.id = p.id_wfstav

where p."Registraèní èíslo projektu" like 'CZ.01%'
-- and p."Registraèní èíslo projektu" IN ('CZ.01.04.01/01/22_006/0000992','CZ.01.04.01/01/22_006/0001024')
and pf."Vlastní prostøedky financování" = 'N'
--and umpf.proc_eu/100 < umpf.eu/umpf.czv
AND pf."Doporuèený pomìr financování (%)" < umpf.eu/umpf.czv

