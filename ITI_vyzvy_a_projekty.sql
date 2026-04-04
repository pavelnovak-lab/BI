SELECT v."Název výzvy",
       v."Číslo výzvy",
       v."Finanční alokace Celk",
       v.wfstav,
       v."Datum zahájení příjmu žádosti",
       round((v."Datum ukončení příjmu žádosti"-v."Datum zahájení příjmu žádosti")/30) as "Vyhlasena_mesicu",
       decode(ISg.id_strategie,47207531,'Hradec-Pardubice',52055106,'Plzeň',47466198,'Olomouc',48093763,'Brno',45804583,'Ostrava','Neuvedena') as "Aglomerace ITI",

       p."Registrační číslo projektu",
       p.kodwfstav as "Stav projektu" ,
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory",
       gg.eu AS "Požadovaná dotace",
       gg.czv ,

       sum(castky.EuVyuctCelkem) AS "Zatím proplaceno"


FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
INNER JOIN isum.v_bi_UmzVyzvaStrategie ISg on ISg.id_vyzva = v.id
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_UmzVyzvaKategorie kat ON kat.id_vyzva = v.id
INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby
INNER JOIN isum.v_bi_UmpCastkySchval castky ON platba.id_SchvaleneCastky=castky.id 


WHERE p."Registrační číslo projektu" is not null 
AND v."OP kod" ='01' 
AND kat.integrovany ='Ano'

GROUP BY v."Název výzvy",
       v."Číslo výzvy",
       v."Finanční alokace Celk",
       v.wfstav,
       v."Datum zahájení příjmu žádosti",
       round((v."Datum ukončení příjmu žádosti"-v."Datum zahájení příjmu žádosti")/30) , 
       ISg.id_strategie ,

       p."Registrační číslo projektu",
       p.kodwfstav ,
       p.kompetencniutvar, 
       gg.eu ,
       gg.czv 




Toto je nějaký text.

 ,
