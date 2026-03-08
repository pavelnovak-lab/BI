SELECT platba.*

FROM isum.v_bi_UmpPlatbaPrj platba

WHERE platba.id_nositelplatby = 1810700795

ORDER BY platba."PORADI#Pořadí finančního plánu"


select p."Registrační číslo projektu" ,
       zoz.*

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva AND v."Číslo výzvy" = '01_23_034'
INNER JOIN zmena zoz ON zoz.id_zad = p.id

