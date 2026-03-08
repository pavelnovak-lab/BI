SELECT p."Registraèní èíslo projektu",
       p."Název projektu CZ",
       p.zadatel "®adatel",
       p.kodwfstav,
       hod.poradi "Posudek è.",
       hod.vyhovel "Celkový statut posudku",
       tel."Kód",
       tel."Název" "Jméno hodnotitele",
       krit.POCETBODU "Bodù v A1",
       krit.VYHOVEL "Vyhovìl v A1?"

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmvHodnoceni hod ON hod.id_noshodnoceni = p.id
INNER JOIN isum.v_bi_UMVHodnotaKrit krit ON krit.id_hodnoceni = hod.id 
INNER JOIN isum.v_bi_UmvHodnotitel tel ON tel.id = hod.id_hodnotitel

WHERE p."Registraèní èíslo projektu" IN ('CZ.31.1.0/0.0/0.0/23_082/0008180') -- ,'CZ.31.1.0/0.0/0.0/23_082/0008181','CZ.31.1.0/0.0/0.0/23_082/0008176','CZ.31.1.0/0.0/0.0/23_082/0008153','CZ.31.1.0/0.0/0.0/23_082/0008155','CZ.31.1.0/0.0/0.0/23_082/0008183','CZ.31.1.0/0.0/0.0/23_082/0008170','CZ.31.1.0/0.0/0.0/23_082/0008160','CZ.31.1.0/0.0/0.0/23_082/0008172','CZ.31.1.0/0.0/0.0/23_082/0008175','CZ.31.1.0/0.0/0.0/23_082/0008182','CZ.31.1.0/0.0/0.0/23_082/0008167','CZ.31.1.0/0.0/0.0/23_082/0008174','CZ.31.1.0/0.0/0.0/23_082/0008173','CZ.31.1.0/0.0/0.0/23_082/0008179','CZ.31.1.0/0.0/0.0/23_082/0008178','CZ.31.1.0/0.0/0.0/23_082/0008151','CZ.31.1.0/0.0/0.0/23_082/0008161','CZ.31.1.0/0.0/0.0/23_082/0008165','CZ.31.1.0/0.0/0.0/23_082/0008162','CZ.31.1.0/0.0/0.0/23_082/0008163','CZ.31.1.0/0.0/0.0/23_082/0008157','CZ.31.1.0/0.0/0.0/23_082/0008171','CZ.31.1.0/0.0/0.0/23_082/0008152','CZ.31.1.0/0.0/0.0/23_082/0008156','CZ.31.1.0/0.0/0.0/23_082/0008154','CZ.31.1.0/0.0/0.0/23_082/0008164','CZ.31.1.0/0.0/0.0/23_082/0008158','CZ.31.1.0/0.0/0.0/23_082/0008177','CZ.31.1.0/0.0/0.0/23_082/0008166','CZ.31.1.0/0.0/0.0/23_082/0008168','CZ.31.1.0/0.0/0.0/23_082/0008169')

-- AND hod.id_kolohodnoceni=171212
AND hod.id_krokvechodn IN (171213)
AND hod.platnost = 'A'
-- AND hod.schvalenoschval='A'
AND krit.kod = 'A1'
-- AND krit.pocetbodu = 0

ORDER BY p."Registraèní èíslo projektu" , hod.poradi
