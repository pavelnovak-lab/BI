SELECT v."Èíslo výzvy" ,
       v."Název výzvy" ,
       v.EDSSMVS,
       v.JEEDS,
       kom."Název"

FROM isum.v_bi_UmzVyzva v
INNER JOIN isum.V_BI_UmzVyzvaUtvar utvar ON utvar.id_vyzva=v.id
INNER JOIN isum.V_BI_UMSHIUtvarKomp kom ON kom.id=utvar.id_utvarkomp 

where v."Èíslo výzvy" in ('01_15_020','01_16_080','01_19_313','01_19_285','01_19_307','01_19_251','01_19_255','01_19_316','01_19_263','01_20_358','01_21_380','01_21_374','01_21_375','01_21_376','01_20_371','01_20_345','01_20_370')
AND kom."Název" <> 'Operaèní program Podnikání a inovace pro konkurenceschopnost'




