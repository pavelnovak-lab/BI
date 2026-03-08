SELECT
	-- count(p."Identifikace ¾ádosti (hash)") 
       -- p."Registraèní èíslo projektu",
       p."Registraèní èíslo projektu" ,
       p."Identifikace ¾ádosti (hash)" 

FROM projekt p
INNER JOIN vyzva v ON v.id = p.id_vyzva


WHERE v."Èíslo výzvy" = '01_23_021'
AND p."Registraèní èíslo projektu" is null 
