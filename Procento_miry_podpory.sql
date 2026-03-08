select 	zopo.proc_zopo,
	skutecnost.proc_skut,
	ropd.proc_ropd,
/*	ropd_zmena.proc_ropd_zmena,
	zmen_rizeni.proc_zmen_rizeni, */

	zopo."Název výzvy",
	zopo."Èíslo výzvy",

	zopo.reg_cis1,
	zopo.nazev1,
	zopo.wf,
        zopo.zadatel1,
        zopo.ico

from

(select	"V_BI_UMFPFCELKEM"."PROC_EU" as proc_zopo,
	"V_BI_UMZPROJEKT"."ZADATEL" as zadatel1,
	"V_BI_UMZPROJEKT"."IÈ" as ico,
	"V_BI_UMZPROJEKT"."Registraèní èíslo projektu" as reg_cis1,
	"V_BI_UMZPROJEKT"."Název projektu CZ" as nazev1, 
	"V_BI_UMZPROJEKT"."ID" as id1,
	v."Název výzvy",
	v."Èíslo výzvy",
	"V_BI_UMZPROJEKT"."KODWFSTAV" as wf

 from	"ISUM"."V_BI_UMZPROJEKT" "V_BI_UMZPROJEKT",
	"ISUM"."V_BI_UMFPFCELKEM" "V_BI_UMFPFCELKEM",
	isum.v_bi_UmzVyzva v

 where	"V_BI_UMFPFCELKEM"."ID_PROJEKT"="V_BI_UMZPROJEKT"."ID"
 and	v.id="V_BI_UMZPROJEKT".id_vyzva	
 and	"V_BI_UMZPROJEKT"."Registraèní èíslo projektu" like ('CZ.01%')
 and	"V_BI_UMFPFCELKEM"."ID_FAZE"='99991000000000001' ) zopo

inner join

(select	"V_BI_UMFPFCELKEM"."PROC_EU" as proc_skut,
	"V_BI_UMZPROJEKT"."ID" as id2
 from	"ISUM"."V_BI_UMZPROJEKT" "V_BI_UMZPROJEKT",
	"ISUM"."V_BI_UMFPFCELKEM" "V_BI_UMFPFCELKEM" 
 where	"V_BI_UMFPFCELKEM"."ID_PROJEKT"="V_BI_UMZPROJEKT"."ID"
 and 	"V_BI_UMZPROJEKT"."Registraèní èíslo projektu" like ('CZ.01%')
 and 	"V_BI_UMFPFCELKEM"."ID_FAZE"='99991000000000005' ) skutecnost

on zopo.id1=skutecnost.id2

inner join

(select	"V_BI_UMFPFCELKEM"."PROC_EU" as proc_ropd,
	"V_BI_UMZPROJEKT"."ID" as id3
 from	"ISUM"."V_BI_UMZPROJEKT" "V_BI_UMZPROJEKT",
	"ISUM"."V_BI_UMFPFCELKEM" "V_BI_UMFPFCELKEM" 
 where	"V_BI_UMFPFCELKEM"."ID_PROJEKT"="V_BI_UMZPROJEKT"."ID"
 and 	"V_BI_UMZPROJEKT"."Registraèní èíslo projektu" like ('CZ.01%')
 and 	"V_BI_UMFPFCELKEM"."ID_FAZE"='99991000000000011' ) ropd

on skutecnost.id2=ropd.id3
