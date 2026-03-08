SELECT p."Registraèní èíslo projektu" ,
       va.*

FROM projekt p
INNER JOIN subjekt s ON s.id_prjgg = p.id
INNER JOIN verze_adresy va ON va.id_verzesubjektu = s.id

WHERE va."Typ adresy" = 'Adresa místa realizace'
