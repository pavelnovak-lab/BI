SELECT count(p.id),
       p."IÈ" ,
       p.zadatel,
       sum(gg.eu),
       sum(rf.castkaschvalena) "Dosud proplaceno" 

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
LEFT JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel = 361356  -- øádky cis.
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 

WHERE p."Registraèní èíslo projektu" like 'CZ.01.%'
AND p.kodwfstav not like 'PN%'
-- AND platba.kodwfstav IN ('P10','P11')


GROUP BY p."IÈ" , p.zadatel
