SELECT p."Identifikace žádosti (Hash)" ,
       p."Název projektu CZ",
       p.zadatel ,
       pzf.*

FROM isum.v_bi_umzprojekt p
INNER JOIN  isum.v_bi_umzvyzva v on p.id_vyzva = v.id
INNER JOIN isum.v_bi_UMFPFCelkem pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005 -- aktuální stav 

WHERE p."Registrační číslo projektu" is null
and v."Číslo výzvy" = '31_25_157'
AND p."Název projektu CZ" like 'Úspory vody%'
