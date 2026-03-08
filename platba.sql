SELECT -- platba.kodwfstav ,
       -- platba."PORADI#Poøadí finanèního plánu" ,
       zou.*

FROM isum.v_bi_UmzProjekt p 
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
INNER JOIN isum.v_bi_UMZZIProjekt zou ON zou.id_zad = p.id 
WHERE p."Registraèní èíslo projektu" like 'CZ.31.2.0/0.0/0.0/22_014/0005676'
