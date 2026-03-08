SELECT p."Registrační číslo projektu",
      isg."Číslo integrované strategie",
      isg."Název integrované strategie",
      s."Název subjektu" "MAS"
      
FROM projekt p 
INNER JOIN integrovane_strategie isg on isg.id = p.id_isg
INNER JOIN verze_subjektu s ON s.id = isg.id_zadatel AND s."Neplatný od" is null
-- INNER JOIN ciselnik_integrovane_nastroje mas ON mas.id = v.id_integnastr

WHERE p."Registrační číslo projektu" = 'CZ.01.02.01/01/23_026/0007857'



------------------------------
SELECT p."Registrační číslo projektu" ,
       kr."Název kraje"

FROM projekt p
INNER JOIN ciselnik_uzemi_kraje kr ON kr.id_projekt = p.id

WHERE p."Registrační číslo projektu" = 'CZ.01.02.01/01/23_026/0007857'




