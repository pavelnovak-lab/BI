SELECT p."Registraèní èíslo projektu",
       vs."Zahrnout subjekt do definice j" "Jeden podnik",
       vs."Název subjektu",
       ci."Název" "Typ subjektu"
FROM isum.v_bi_UmzPrjGGII p
INNER JOIN isum.v_bi_UmzPrjGGvs vs ON vs.id_prjgg=p.id
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = vs.id_typSubjektu


WHERE p."Registraèní èíslo projektu" is not null 
AND vs."Zahrnout subjekt do definice j" = 'A'
