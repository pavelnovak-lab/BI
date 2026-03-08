Dobrý den,

omlouvám se, ale dnes jsem se dozvìdìl, ¾e ta èástka de minimis byla celou dobu na jiných výzvách doplòována ruènì. Do ¹ablony bychom tedy chtìli doplnít to, co v BI Publisheru mohu (pro projekt v pøíkladu) vytáhnout takto. Je to èástka na formuláøi VPo (kde je více záznamù).

Prosím tedy o doplnìní do ¹ablony. 

Návodný kód v BI Publisheru:


SELECT	p."Registraèní èíslo projektu" ,
	rdm.CASTKAEU_KC

FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UMSRdMPodpora rdm ON rdm.id_projekt = p.id AND rdm.id_rezimpodpory = 1196334

WHERE p."Registraèní èíslo projektu" = 'CZ.01.4.04/0.0/0.0/21_376/0027467'
