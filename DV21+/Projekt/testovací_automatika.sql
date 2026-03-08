CREATE or REPLACE view "Test_mailove_automatiky" FOLDER= AS 
SELECT count(p."Registraèní èíslo projektu");
       1/count(p."Registraèní èíslo projektu")


FROM projekt p

WHERE p."Registraèní èíslo projektu"  = 'CZ.01.01.01/02/24_051/0004965'
