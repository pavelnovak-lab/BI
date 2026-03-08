SELECT v."Název výzvy",
       v."Èíslo výzvy" ,
       pa.ropd,
       count(p.id) "Pøed PP30",
       p.prioritniosa,
       DECODE (p.kodprioritniosa, '31.1' , '1.3',
       	      			  '31.2', '1.5',
				  '31.3', '2.3',
				  '31.5', '2.7',
				  '31.9', '4.2',
				  '31.14', '5.2',
				  '31.22', '1.4' ) "Èíslo komponenty" 

FROM  isum.v_bi_UmzVyzva v
LEFT JOIN isum.v_bi_UmzProjekt p ON v.id=p.id_vyzva
LEFT JOIN
 (SELECT count(p.id) ropd,
 	 p.id_vyzva
  FROM isum.v_bi_UmzPrjGGII p
  WHERE p.kodwfstav like 'PP3%'
  GROUP BY p.id_vyzva) pa ON pa.id_vyzva = v.id

WHERE (p.kodwfstav like ('PP2%') OR p.kodwfstav like 'PU%')
AND p.KodPrioritniOsa in ('31.1', '31.2', '31.3', '31.4','31.5','31.9','31.14','31.22') 

GROUP BY v."Název výzvy",
      	 v."Èíslo výzvy",
	 pa.ropd,
	 p.prioritniosa,
	 p.kodprioritniosa

ORDER BY p.kodprioritniosa
