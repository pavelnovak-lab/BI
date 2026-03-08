SELECT p."Registraèní èíslo projektu",
       p.Progkod,
       vs.*
FROM projekt p
INNER JOIN verze_subjektu vs ON vs.id = p.id_zadatel

WHERE p.progkod = 'MPO'
