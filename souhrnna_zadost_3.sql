SELECT platba."»Ìslo æ·dosti o platbu" ,
       platba.kodwfstav  "WFStav ÆoP" , 
       sz."»Ìslo souhrnnÈ æ·dosti",
       sz."WFSTAVDATUM",
       w."KÛd stavu",
       w.wfstav 
       
FROM isum.v_bi_UmpPlatbaPrj platba 
LEFT JOIN isum.v_bi_UmpKlasifikace_SP sp on sp.id_platba=platba.id
LEFT JOIN isum.v_bi_UmpSouhrnnaPlatba sz on sz.id=sp.id_sz
LEFT JOIN isum.v_bi_UMSCisStavWF w ON w.id = sz.id_wfstav 


where platba."»Ìslo æ·dosti o platbu" in ('CZ.01.2.111/0.0/0.0/15_016/0000743/2016/001/POST', 'CZ.31.3.0/0.0/0.0/22_001/0000504/2023/001/POST')


