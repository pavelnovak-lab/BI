SELECT p."Registraèní èíslo projektu" ,
       p.zed,
       p.zadatel ,
       p."Název projektu CZ",
       p.akcezed
       
FROM isum.v_bi_UmzProjekt p

WHERE p."Registraèní èíslo projektu" is not null 
-- AND p.akcezed = 'Z220601002124'
-- AND p."Registraèní èíslo projektu" = 'CZ.01.1.02/0.0/0.0/17_176/0015643'
AND p.akcezed IN ('Z220601002184','Z220601002185','Z220601002186')


Kod IN ['CZ.01.1.02/0.0/0.0/16_083/0010350','CZ.01.1.02/0.0/0.0/20_321/0024633','CZ.01.1.02/0.0/0.0/20_358/0027909','CZ.01.1.02/0.0/0.0/17_176/0015614','CZ.01.1.02/0.0/0.0/21_374/0027290']

Z220601002184
Z220601002185
Z220601002186




