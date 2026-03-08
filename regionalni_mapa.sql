SELECT p."Registraèní èíslo projektu",
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       p.VELIKOSTPODNIKU,
       p.kodwfstav,
       kraj."Míra podpory" ,
       kraj."Kraj realizace" ,
       kraj.eu "Dotace EU",
       case when kraj."Kraj realizace" = 'Støedoèeský kraj' then  'Støední Èechy'
       	     when kraj."Kraj realizace" in ('Jihoèeský kraj','Plzeòský kraj')  then 'Jihozápad'
	     when kraj."Kraj realizace" in ('Karlovarský kraj','Ústecký kraj')  then 'Severozápad'
	     when kraj."Kraj realizace" in ('Liberecký kraj','Královéhradecký kraj','Pardubický kraj') then 'Severovýchod'
       	     when kraj."Kraj realizace" in ('Kraj Vysoèina','Jihomoravský kraj')  then 'Jihovýchod'
       	     when kraj."Kraj realizace" in ('Olomoucký kraj','Zlínský kraj') then 'Støední Morava'
       	     when kraj."Kraj realizace" = 'Moravskoslezský kraj'  then 'Moravskoslezsko'	
       	     else 'Jiný pøípad'
       	end as "Region NUTS2",
	kraj."Realizace (ZUJ)",
	v."Název výzvy",
	v."Èíslo výzvy"
	
FROM isum.v_bi_UmzProjekt p 
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN (
SELECT LISTAGG(DISTINCT uk."Název", '; ') "Kraj realizace" ,
       p.id,
       p.eu,
       p.eu/p.czv "Míra podpory" ,
       LISTAGG(DISTINCT ciu."Název",';') WITHIN GROUP (ORDER BY ciu."Název") AS "Realizace (ZUJ)"

FROM  isum.v_bi_UmzPrjGG p
INNER JOIN isum.v_bi_UmzPrjUmisteniKraj uk ON uk.id_projekt = p.id AND uk.typ = 'Realizace'
LEFT JOIN  isum.v_bi_UmzPrjUmisteni um ON um.id_projekt = p.id AND um.Typ = 1
INNER JOIN isum.v_bi_UmsCisZakladni ciu ON um.id_uzemnijednotky = ciu.id

WHERE p."Registraèní èíslo projektu" is not null
AND p.kodwfstav in ('PP20','PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','PU21','PU27','V2','V5','Z1','Z3')
AND REGEXP_LIKE(ciu."Kód", '5[0-9]{5}') -- kódem s pìtkou na zaèátku zaèínají ZUJ

GROUP BY p.id ,
      	 p.eu/p.czv,
	 p.eu
) kraj ON kraj.id = p.id

WHERE p."Registraèní èíslo projektu" is not null
AND p.kodwfstav in ('PP20','PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','PU21','PU27','V2','V5','Z1','Z3')





