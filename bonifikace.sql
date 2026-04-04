SELECT p."Registrační číslo projektu",
       SUBSTR(p.kompetencniutvar, 6 ) AS "Program podpory" ,
       p.VELIKOSTPODNIKU,
       p.kodwfstav,
       kraj."Míra podpory" ,
       kraj."Kraj realizace" ,
       case when kraj."Kraj realizace" = 'Středočeský kraj' then  'Střední Čechy'
       	     when kraj."Kraj realizace" in ('Jihočeský kraj','Plzeňský kraj')  then 'Jihozápad'
	     when kraj."Kraj realizace" in ('Karlovarský kraj','Ústecký kraj')  then 'Severozápad'
	     when kraj."Kraj realizace" in ('Liberecký kraj','Královéhradecký kraj','Pardubický kraj') then 'Severovýchod'
       	     when kraj."Kraj realizace" in ('Kraj Vysočina','Jihomoravský kraj')  then 'Jihovýchod'
       	     when kraj."Kraj realizace" in ('Olomoucký kraj','Zlínský kraj') then 'Střední Morava'
       	     when kraj."Kraj realizace" = 'Moravskoslezský kraj'  then 'Moravskoslezský kraj'	
       	     else 'Jiný případ'
       	end as "Region NUTS2"


FROM isum.v_bi_UmzProjekt p 
INNER JOIN (
SELECT LISTAGG(DISTINCT uk."Název", '; ') "Kraj realizace" ,
       p.id,
       p.eu/p.czv "Míra podpory" 

FROM  isum.v_bi_UmzPrjGG p
INNER JOIN isum.v_bi_UmzPrjUmisteniKraj uk ON uk.id_projekt = p.id AND uk.typ = 'Realizace'

WHERE p."Registrační číslo projektu" is not null
AND p.kodwfstav in ('PP20','PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','PU21','PU27','V2','V5','Z1','Z3')
GROUP BY p.id ,
      	 p.eu/p.czv
) kraj ON kraj.id = p.id

WHERE p."Registrační číslo projektu" is not null
AND p.kodwfstav in ('PP20','PP21','PP22','PP23a','PP23b','PP27a','PP27b','PP29','PU21','PU27','V2','V5','Z1','Z3')


