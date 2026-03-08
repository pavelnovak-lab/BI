SELECT SUBSTR(p.kompetencniutvar, 6) AS "Program podpory",
       p.kodwfstav ,
       replace(replace(p."Registraèní èíslo projektu",CHR(10), ' --- '), Chr(13), ' --- ') AS "Registraèní èíslo projektu",
       replace(replace(p."Anotace projektu",CHR(10), ' --- '), Chr(13), ' --- ') AS "Anotace projektu",
       replace(replace(p."Jaký problém projekt øe¹í?",CHR(10), ' --- '), Chr(13), ' --- ') AS "Jaký problém projekt øe¹í?",
       replace(replace(p."Jaké jsou pøíèiny problému?",CHR(10), ' --- '), Chr(13), ' --- ') AS "Jaké jsou pøíèiny problému?",
       replace(replace(p."Co je cílem projektu?",CHR(10), ' --- '), Chr(13), ' --- ') AS "Co je cílem projektu?",
       replace(replace(p."Jaká zmìna/y je/jsou v dùsledk",CHR(10), ' --- '), Chr(13), ' --- ') AS "Jaká zmìna/y je/jsou v dùsledk",
       replace(replace(p."Jaké aktivity v projektu budou",CHR(10), ' --- '), Chr(13), ' --- ') AS "Jaké aktivity v projektu budou"
       

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
-- INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON p.id=platba.id_NositelPlatby 
-- INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- øádky cis.


WHERE v."Èíslo výzvy" IN ('01_15_007','01_15_018','01_15_019','01_16_053','01_16_056','01_16_079','01_16_083','01_16_084','01_17_103','01_17_106','01_17_107','01_17_125','01_17_147','01_17_166','01_17_173','01_17_174','01_17_175','01_17_176','01_18_212','01_19_262','01_19_263','01_19_274','01_19_275','01_20_321','01_20_336','01_21_374','01_21_375','01_21_373','01_20_339','01_20_338','01_20_318','01_19_297','01_19_273','01_19_268','01_19_267','01_19_266','01_19_261','01_18_243','01_17_206','01_17_170','01_17_165','01_17_164','01_17_163','01_17_162','01_17_157','01_17_127','01_17_124','01_17_121','01_17_109','01_17_093','01_16_092','01_16_051','01_16_050','01_16_049','01_15_030','01_15_014','01_15_002')
-- AND platba.kodwfstav in ('P10','P11')

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC
