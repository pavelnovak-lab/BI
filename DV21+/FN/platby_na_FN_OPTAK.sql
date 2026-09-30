CREATE or REPLACE view "optak_platby_fn" FOLDER='/06_Data_models/01_OP_TAK/MPO/novak-pavel/Financni_nastroje' AS
SELECT fn."Registrační číslo FN/HF",
       fn."Název FN/HF",
       wfn."Název" "Stav workflow FN/HF",
       fn."Datum podpisu dohody o financování se správcem FN/HF",
       fn."Celková alokace FN/HF",
       fn."Celková výše počátečního vkladu",
       -- souhrny za FN, jen platby ve stavu Proplacena / Proplacena s krácením
       fnsum."FN - proplacený počáteční vklad",
       fnsum."FN - proplacené průběžné vyúčtování",
       fnsum."FN - vyčerpaný počáteční vklad",
       fnsum."FN - nesrovnalosti",
       fnsum."FN - proplaceno celkem",
       pl."Pořadí finančního plánu" "Pořadové číslo platby",
       wfpl."Název" "Stav workflow platby",
       pl."Bez proplacení",
       -- pl."Zálohová platba",
       pl."Závěrečná platba",
       pl."Eport do ÚIS" "Export do EIS",
       pl."Datum změny stavu",
       -- napočteno z PREDF DP, pole na platbě nejsou plněna
       zop."ŽoP - počáteční vklad",
       zop."ŽoP - průběžné vyúčtování",
       zop."ŽoP - vyúčtování počátečního vkladu",
       zop."ŽoP - nesrovnalosti",
       zop."ŽoP - proplaceno",
       zop."Datum proplacení platby",
       dp."Datum odeslání žádosti o platbu EK",
       dp."Pořadí" "Pořadí DP",
       dp."Registrační číslo detailu platby",
       wfdp."Název" "Stav workflow DP" ,
       dp."Datum schválení",
       dp."Datum proplacení v ÚIS" "Datum proplacení v EIS",
       dp."Datum refundace" "Datum refundace",
       CASE WHEN dp."Druh detailu platby" = '1' THEN 'PREDF'
       WHEN dp."Druh detailu platby" = '2' THEN 'REF'
       ELSE CAST(dp."Druh detailu platby" AS varchar) END "Druh DP",
       CASE WHEN dp."Typ detailu platby" = 2 THEN 'VYUCT PRŮBĚŽNÉ'
       WHEN dp."Typ detailu platby" = 1 THEN 'VYUCT P. VKLADU'
       WHEN dp."Typ detailu platby" = 0 THEN 'POČÁTEČNÍ VKLAD'
       ELSE CAST(dp."Typ detailu platby" AS varchar) END "Typ DP",
       dp."Částka v CZK - žádost",
       dp."Částka v CZK - skutečnost",
       CASE WHEN dp."Částka v CZK - žádost" < 0 THEN 'Ano'
       ELSE NULL END "Je DP Nesrovnalost?"



FROM financni_nastroj fn
  INNER JOIN ciselnik_stav_workflow wfn ON fn.id_wfstav = wfn.id
  INNER JOIN platba pl ON pl.id_nositelplatby = fn.id
  INNER JOIN ciselnik_stav_workflow wfpl ON wfpl.id = pl.id_wfstav
  INNER JOIN klasifikace dp ON dp.id_platba = pl.id
  INNER JOIN ciselnik_stav_workflow wfdp ON wfdp.id = dp.id_wfstav

  -- součty PREDF DP za ŽoP; počítá se ze žádosti, skutečnost se plní ručně
  LEFT JOIN (
    SELECT d.id_platba,
           SUM(CASE WHEN d."Typ detailu platby" = 0 THEN d."Částka v CZK - žádost" ELSE 0 END) "ŽoP - počáteční vklad",
           SUM(CASE WHEN d."Typ detailu platby" = 2 AND d."Částka v CZK - žádost" > 0 THEN d."Částka v CZK - žádost" ELSE 0 END) "ŽoP - průběžné vyúčtování",
           SUM(CASE WHEN d."Typ detailu platby" = 1 THEN d."Částka v CZK - žádost" ELSE 0 END) "ŽoP - vyúčtování počátečního vkladu",
           SUM(CASE WHEN d."Částka v CZK - žádost" < 0 THEN d."Částka v CZK - žádost" ELSE 0 END) "ŽoP - nesrovnalosti",
           -- vyúčtování počátečního vkladu se neproplácí
           SUM(CASE WHEN d."Typ detailu platby" IN (0, 2) THEN d."Částka v CZK - žádost" ELSE 0 END) "ŽoP - proplaceno",
           MAX(CASE WHEN w."Název" IN ('Proplacená OSS', 'Proplacená', 'Schválená') THEN d."Datum proplacení v ÚIS" END) "Datum proplacení platby"
    FROM klasifikace d
      INNER JOIN ciselnik_stav_workflow w ON w.id = d.id_wfstav
    WHERE d."Druh detailu platby" = '1'
      AND w."Název" IN ('Proplacená OSS', 'Proplacená', 'Schválená', 'Navrácená')
    GROUP BY d.id_platba
  ) zop ON zop.id_platba = pl.id

  -- součty PREDF DP za FN, jen proplacené platby
  LEFT JOIN (
    SELECT p.id_nositelplatby,
           SUM(CASE WHEN d."Typ detailu platby" = 0 THEN d."Částka v CZK - žádost" ELSE 0 END) "FN - proplacený počáteční vklad",
           SUM(CASE WHEN d."Typ detailu platby" = 2 THEN d."Částka v CZK - žádost" ELSE 0 END) "FN - proplacené průběžné vyúčtování",
           SUM(CASE WHEN d."Typ detailu platby" = 1 THEN d."Částka v CZK - žádost" ELSE 0 END) "FN - vyčerpaný počáteční vklad",
           SUM(CASE WHEN d."Částka v CZK - žádost" < 0 THEN d."Částka v CZK - žádost" ELSE 0 END) "FN - nesrovnalosti",
           SUM(CASE WHEN d."Typ detailu platby" IN (0, 2) THEN d."Částka v CZK - žádost" ELSE 0 END) "FN - proplaceno celkem"
    FROM platba p
      INNER JOIN ciselnik_stav_workflow wp ON wp.id = p.id_wfstav
      INNER JOIN klasifikace d ON d.id_platba = p.id
      INNER JOIN ciselnik_stav_workflow w ON w.id = d.id_wfstav
    WHERE wp."Název" IN ('Proplacena', 'Proplacena s krácením')
      AND d."Druh detailu platby" = '1'
      AND w."Název" IN ('Proplacená OSS', 'Proplacená', 'Schválená', 'Navrácená')
    GROUP BY p.id_nositelplatby
  ) fnsum ON fnsum.id_nositelplatby = fn.id


ORDER BY fn."Registrační číslo FN/HF", pl."Pořadí finančního plánu" , dp."Pořadí"
