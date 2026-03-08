SELECT p."Registraèní èíslo projektu",
       knm."KOD#Èíslo kontroly" "Kód kontroly",
       ni.cislo,
       ni.id "UMVKONTRZJISTENI.id",
       knm.id "UmvKontrolaNaMiste.id"
       

FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmvKontrolaNaMiste knm ON p.id = knm.id_nositelkontroly
inner join isum.V_BI_UMVKONTRZJISTENI ni on ni.ID_KONTROLA=knm.id

WHERE ni.cislo like '%.' or ni.cislo like '0%'
AND ni.cislo <> '0'

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , ni.cislo

-- WHERE
--knm."KOD#Èíslo kontroly" like '017571%'



