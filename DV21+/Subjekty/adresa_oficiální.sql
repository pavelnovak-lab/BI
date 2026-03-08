-- Zajímají mì poèty oficiálních adres

SELECT distinct 
		s.pocet
FROM projekt p
INNER JOIN (SELECT s.id_prjgg,
      	   	   count(s.id_oficialniadresa) pocet
	    FROM projekt p
	    INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462 -- ¾adatel 
	    WHERE p."Registraèní èíslo projektu" is not null
	    AND s."Neplatný od" is not null 

	    GROUP BY s.id_prjgg ) s ON s.id_prjgg = p.id 

WHERE p."Registraèní èíslo projektu" is not null
AND s.pocet = 2




----------------------------------------

SELECT p."Registraèní èíslo projektu" ,
       s.*

FROM projekt p
INNER JOIN subjekt s ON s.id_prjgg = p.id AND s.id_typsubjektuedit = 413462 -- ¾adatel 

WHERE p."Registraèní èíslo projektu" = 'CZ.01.01.01/03/23_024/0002856'


----------------------------------------
/* Adresa realizace */
SELECT	ROW_NUMBER() OVER (PARTITION BY s.id ORDER BY adr.id ASC) AS "Poøadí záznamu" ,
	-- p."Registraèní èíslo projektu" ,
	s."Název subjektu",
        s."IÈ",
	s.id,
	s.id_prjgg,
        adr."Název kraj",
        -- adr."Typ adresy",
	adr."Neplatný záznam adresy",
        CASE WHEN adr."Název kraj" IN ('Plzeòský kraj', 'Støedoèeský kraj', 'Kraj Vysoèina', 'Jihoèeský kraj', 'Jihomoravský kraj') THEN 'PR'
       	     WHEN adr."Název kraj" IN ('Karlovarský kraj', 'Ústecký kraj', 'Liberecký kraj', 'Královéhradecký kraj', 'Pardubický kraj', 'Olomoucký kraj', 'Zlínský kraj', 'Moravskoslezský kraj') THEN 'MRR'
	     WHEN adr."Název kraj" = 'Hlavní mìsto Praha' THEN 'VRR'
	     ELSE NULL END AS "KR"
       -- SUM(verejna_podpora."Èástka poskytnuté veøejné podpory celkem v Kè" ) AS "CZV",
       -- SUM(verejna_podpora."Èástka veøejné podpory\n (CZK, dotaèní zdroje)" ) AS "EU"

     
FROM subjekt s -- ON s.id_prjgg = p.id 
INNER JOIN verze_adresy adr  ON s.id = adr.id_verzesubjektu  
-- INNER JOIN verejna_podpora vpo ON vpo.id_nositel = s.id 

-- (projekt.id = verejna_podpora.id_projekt AND subjekt.id = verejna_podpora.id_nositel)


WHERE adr."Typ adresy" like '%Adresa místa realizace%'
AND s."Neplatný od" is null
AND s.id_typsubjektuedit IN (413462, 413467) -- ¾adatel, partner s FP
AND adr."Neplatný záznam adresy" is null 
-- AND s.id = 75974618
AND s.id_prjgg IN (68643484, 75974570)
