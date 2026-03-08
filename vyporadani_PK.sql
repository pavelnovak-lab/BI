SELECT p."Registraèní èíslo projektu" ,
       p.zadatel,
       vyp.DATUMVYPORADANI "Datum vyproøádání",
       LISTAGG( kriterium.kod, '; ') WITHIN GROUP (ORDER BY UPPER(kriterium.kod))  "Kriteria k opravì"
       
FROM isum.v_bi_UmzProjekt p 
-- tuhle dvojnou vazbu pí¹u proto¾e v UMVHODNVYPORADANI je jak celé vypoøádání, tak i dílèí kritéria. 
INNER JOIN isum.v_bi_UMVHodnVyporadani vyp ON vyp.id_noshodnoceni = p.id AND vyp.DATUMVYPORADANI is not null
INNER JOIN (SELECT vyp.id_noshodnoceni,
     	  	  krit.kod
           FROM isum.v_bi_UMVHodnVyporadani vyp
	   INNER JOIN isum.V_BI_UMVHodnKriterium krit ON krit.id = vyp.id_hodnkriterium AND vyp.OPRAVIT = 'A'
	   ) kriterium ON kriterium.id_noshodnoceni = p.id
	     


WHERE p."Registraèní èíslo projektu" IN ('CZ.31.1.0/0.0/0.0/23_078/0008035','CZ.31.1.0/0.0/0.0/23_078/0008038','CZ.31.1.0/0.0/0.0/23_078/0008031','CZ.31.1.0/0.0/0.0/23_078/0008029','CZ.31.1.0/0.0/0.0/23_078/0008027','CZ.31.1.0/0.0/0.0/23_078/0008036','CZ.31.1.0/0.0/0.0/23_078/0008034','CZ.31.1.0/0.0/0.0/23_078/0008032','CZ.31.1.0/0.0/0.0/23_078/0008096','CZ.31.1.0/0.0/0.0/23_078/0008069','CZ.31.1.0/0.0/0.0/23_078/0008081','CZ.31.1.0/0.0/0.0/23_078/0008086','CZ.31.1.0/0.0/0.0/23_078/0008107','CZ.31.1.0/0.0/0.0/23_078/0008085','CZ.31.1.0/0.0/0.0/23_078/0008104','CZ.31.1.0/0.0/0.0/23_078/0008106','CZ.31.1.0/0.0/0.0/23_078/0008082','CZ.31.1.0/0.0/0.0/23_078/0008078','CZ.31.1.0/0.0/0.0/23_078/0008098','CZ.31.1.0/0.0/0.0/23_078/0008101','CZ.31.1.0/0.0/0.0/23_078/0008064','CZ.31.1.0/0.0/0.0/23_078/0008075','CZ.31.1.0/0.0/0.0/23_078/0008089','CZ.31.1.0/0.0/0.0/23_078/0008087','CZ.31.1.0/0.0/0.0/23_078/0008091','CZ.31.1.0/0.0/0.0/23_078/0008080','CZ.31.1.0/0.0/0.0/23_078/0008105','CZ.31.1.0/0.0/0.0/23_078/0008084','CZ.31.1.0/0.0/0.0/23_078/0008100','CZ.31.1.0/0.0/0.0/23_078/0008067','CZ.31.1.0/0.0/0.0/23_078/0008065','CZ.31.1.0/0.0/0.0/23_078/0008088','CZ.31.1.0/0.0/0.0/23_078/0008071','CZ.31.1.0/0.0/0.0/23_078/0008073','CZ.31.1.0/0.0/0.0/23_078/0008083','CZ.31.1.0/0.0/0.0/23_078/0008092','CZ.31.1.0/0.0/0.0/23_078/0008070','CZ.31.1.0/0.0/0.0/23_078/0008074','CZ.31.1.0/0.0/0.0/23_078/0008090','CZ.31.1.0/0.0/0.0/23_078/0008102')


GROUP BY p."Registraèní èíslo projektu" ,
       vyp.DATUMVYPORADANI

ORDER BY p.zadatel 
