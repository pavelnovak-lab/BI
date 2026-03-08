SELECT	p."Registraèní èíslo projektu" ,
	rdm."Úèel podpory",
	rdm."Odùvodnìní zmìny údajù zaslaný",
	dm."Jméno",
	dm."Obchodní jméno"

FROM isum.v_bi_UmzPrjGGII p 
INNER JOIN isum.v_bi_UMSSubjektDeMinimis dm ON dm.id_projekt = p.id
INNER JOIN isum.v_bi_UMSRdMPodpora rdm ON rdm.id_seznampodpor = dm.id

WHERE p."Registraèní èíslo projektu" is not null 
AND (
rdm."Úèel podpory" is not null
OR
rdm."Odùvodnìní zmìny údajù zaslaný" is not null )
