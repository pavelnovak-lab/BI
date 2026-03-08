SELECT p."Registraèní èíslo projektu" ,
       zoz."Poøadové èíslo ®oZ",
       nvl(zo."Poèet ®oZ", 0) "Poèet ®oZ"
       
FROM isum.v_bi_UmzProjekt p
LEFT JOIN isum.v_bi_UmzZoZProjekt zoz ON zoz.id_zad = p.id
LEFT JOIN 
(SELECT max(z."Poøadové èíslo ®oZ") AS "Poèet ®oZ",
	z.id_zad
        FROM isum.v_bi_UmzZoZProjekt z
	GROUP BY z.id_zad) zo ON zo.id_zad = p.id 
      


WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5') 
AND p."Registraèní èíslo projektu" is not null 
-- p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/15_014/0000327'
-- AND p."Registraèní èíslo projektu" in ('CZ.01.3.10/0.0/0.0/15_010/0000001' , 'CZ.01.3.10/0.0/0.0/15_010/0000002')

-- GROUP BY p."Registraèní èíslo projektu", zoz."Poøadové èíslo ®oZ"

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC,  zoz."Poøadové èíslo ®oZ" ASC
