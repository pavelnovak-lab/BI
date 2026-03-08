SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory" ,
       p."Registraèní èíslo projektu",
       p.zadatel ,
       p."IÈ" "IÈ ¾adatele",
       s."Název Dodavatele",
       s."IÈO Dodavatele",
       s."Celková èástka bez DPH \nuvede" ,
       s."Celková èástka DPH \nuvedená n",
       s."Èástka bez DPH pøipadající na",
       s."Èástka DPH pøipadající na \nPr",
       s."Datum vystavení dokladu",
       s."Poøadové èíslo",
       s.NEZPUSOBILE,
       s.VYDAJESCHVAL,
       platba."PORADI#Poøadí finanèního plánu" "Poøadí ®oP",
       platba.wfstav "Stav platby" ,
       platba."Datum zmìny stavu" "Datum zmìny stavu ®oP"
              
FROM isum.v_bi_UmzProjekt p
-- INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.V_BI_UMFSOUPISKADOKLADPRJ s ON s.id_projekt = p.id
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON platba.id = s.id_platba


WHERE s."Souètový øádek" is null
AND s."IÈO Dodavatele" IN ('27696057','26883490')



ORDER BY s."IÈO Dodavatele"
