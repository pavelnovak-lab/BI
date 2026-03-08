SELECT p."Registraèní èíslo projektu",
       listagg(cis."Název",'; ') "Odbornost"

FROM isum.v_bi_UmzPrjGGII p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
LEFT JOIN isum.v_bi_UMVHodnNosOdbornost odb ON odb.id_noshodnoceni
 = p.id
LEFT JOIN isum.v_bi_UMSCisOdbornost cis ON cis.id = odb.id_odbornost


WHERE p."Registraèní èíslo projektu" is not null
AND   v."Èíslo výzvy" = '01_20_321'
AND   cis."Název" is null 

GROUP BY p."Registraèní èíslo projektu"

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC
