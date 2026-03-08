SELECT v."Èíslo výzvy",
       op.kod as Kopatreni,
       op.nazev as Nopatreni,
       sc.kod as KSC,
       sc.nazev as NSC,
       prg."Kód",
       prg."Název"
FROM  vyzva v
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
inner join v_rav_umshisc op on op.id=vh.id_speccil
inner join v_rav_umshisc sc on sc.id=op.id_hierarchie
INNER JOIN programova_linie prg ON prg.id = sc.id_osa
