SELECT p."Registraèní èíslo projektu",
       p.kodwfstav ,
       v."Èíslo výzvy",
       -- prpr.nazevpril "Název pøílohy",
       prpr."Link DMS" "Link na soubor"
       -- uz.uzivatel "1. verzi vlo¾il",
       -- 	case when uz.typ = 'Externí' then 'Zástupce pøíjemce'
       -- 	     when uz.typ = 'Interní' then 'Zástupce OP PIK'
       -- 	     else 'Jiný'
       -- 	end as "Typ u¾ivatele"

       -- przop.CREATECASPRIL "Datum vytvoøení ®oP",
       -- przop.CREATEUZIVPRIL "Vytvoøil u¾ivatel ®oP",
       -- przop."Název dokumentu" "Název pøílohy ®oP",
       -- przop."Typ dokumentu" "Typ pøílohy ®oP",
       -- przop."Druh dokumentu" "Druh pøílohy ®oP",
       -- przop."Poøadí" "Poradí ®oP"
       
FROM isum.V_BI_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.V_BI_UMSPRILOHYPRJ prpr  ON p.id=prpr.id_nositelpril
-- INNER JOIN isum.v_bi_CUzivatel uz ON uz.username = prpr.CREATEUZIVPRIL
-- INNER JOIN isum.v_bi_UmpPlatba platba ON p.id=platba.id_NositelPlatby
-- INNER JOIN isum.v_bi_umsprilohy przop ON przop.id_nositelpril = platba.id

WHERE p."Registraèní èíslo projektu" is not null
AND v."Èíslo výzvy" in ('01_16_045','01_17_115','01_17_205','01_18_215','01_20_319','01_20_358')
AND prpr.nazevpril like '%Nabídka poskytnutí slu¾by'
-- ORDER BY prpr.poradip
