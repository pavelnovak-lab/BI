-- CREATE OR replace VIEW "Stav_vyzev" FOLDER = '/06_data_models/01_op_tak/mpo/novak-pavel/' AS

SELECT v."Èíslo výzvy",
       v."Název výzvy",
       op.nazev as "Opatøení",
       v."Finanèní alokace výzvy (CZV)",
       vw."Název" "Stav výzvy" 
--        count(case when pw."Kód" in ('PP20','PP22','PU22a', 'PP23a', 'PP23b','PU24','PP24','PP25a','PP25b','PP26','PU26') then 1 END) AS "Projektù bez RoPD" ,
--        sum(case when pw."Kód" in ('PP20', 'PP22', 'PU22a', 'PP23a', 'PP23b','PU24','PP24','PP25a','PP25b','PP26','PU26') then pzf."Pøíspìvek Unie" END) AS "EU dotace pøed RoPD" ,
--        count(case when pw."Kód" in ('PP20', 'PP22', 'PU22a', 'PP23a', 'PP23b','PU24','PP24','PP25a','PP25b','PP26','PU26')
-- 		     then pl.id END) AS "Poèet ®oP projektù pøed RoPD" ,

-- --- BLBOST je SÈ9TAT celkové peníze, musím scitat èástky z ®oP -- kde jsou tam vyúètování skut, jine plán. 
--        count(case when (pw."Kód" like 'PP3%' or pw."Kód" like 'PP40') then 1 END) AS "Projektù s RoPD bez finanèního ukonèení",
--        sum(case when (pw."Kód" like 'PP3%' or pw."Kód" like 'PP40') then pzf."Pøíspìvek Unie" END) AS "Neproplacená EU dotace projektù s RoPD bez finanèního ukonèení" ,
--        count(case when ((pw."Kód" like 'PP3%' or pw."Kód" like 'PP40') AND wpl."Kód" not IN ('P6T','P9T','P10','P11','P12','P13','P13T','P14','P14T')) then pl.id END) AS "Poèet neproplacených ®oP projektù s RoPD" ,


--        sum(case WHEN ((pw."Kód" like 'PP3%' or pw."Kód" like 'PP40') AND wpl."Kód" IN ('P6T','P9T','P10','P11','P12','P13','P13T','P14','P14T')) then pzf."Pøíspìvek Unie" END) AS "Proplacená EU dotace projektù s RoPD bez finanèního ukonèení" ,
--        count(case when ((pw."Kód" like 'PP3%' or pw."Kód" like 'PP40') AND wpl."Kód" IN ('P6T','P9T','P10','P11','P12','P13','P13T','P14','P14T')) then pl.id END) AS "Poèet proplacených ®oP projektù s RoPD" 




FROM vyzva AS v
INNER JOIN ciselnik_stav_workflow AS vw ON vw.id = v.id_wfstav



LEFT JOIN projekt AS p ON p.id_vyzva = v.id and p."Registraèní èíslo projektu" is not null
LEFT JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav
LEFT JOIN prehled_zdroju_financovani pzf ON pzf.id_projekt = p.id AND pzf.id_faze = 99991000000000005
INNER JOIN vyzva_hierarchie vh ON vh.id_vyzva = v.id
INNER JOIN v_rav_umshisc op on op.id=vh.id_speccil
INNER JOIN platba pl ON pl.id_nositelplatby = p.id 
INNER JOIN ciselnik_stav_workflow wpl ON pl.id_wfstav = wpl.id  


WHERE v.id_integnastr = 0 -- vyhazuje ven výzvy na ISg CLLD a ITI
AND vw."Název" <> 'Zru¹ená'
AND v."Èíslo výzvy" IN ('01_23_013', '01_23_011')


-- GROUP BY v."Èíslo výzvy",
--        v."Název výzvy",
--        op.nazev ,
--        v."Finanèní alokace výzvy (CZV)",
--        vw."Název"
