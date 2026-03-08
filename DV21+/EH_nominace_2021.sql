SELECT p."Registraèní èíslo projektu" ,
       v."Èíslo výzvy",
       v."Název výzvy",
       h."Kód u¾ivatele",
       h."Jméno",
       h."Pøíjmení",
       kh."Datum vyjádøení k nominaci",
       kh."Lhùta vyjádøení",
       kh."Datum odeslání ¾ádosti",
       kh."Náhradník",
       kh."Datum vyjádøení k nominaci",
       kh."Potvrdil nepodjatost"  ,     
       kh."Arbitr",
       kh."Opravný hodnotitel",
       kh."Øádný hodnotitel"

FROM projekt p
INNER JOIN vyzva v ON p.id_vyzva = v.id
INNER JOIN hodnotitel_kompetenece kh ON kh.id_noshodnoceni = p.id
INNER JOIN hodnotitel h ON kh.id_hodnotitel = h.id

WHERE p."Registraèní èíslo projektu" = 'CZ.01.04.01/01/22_006/0000019'
