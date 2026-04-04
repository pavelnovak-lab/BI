SELECT kraceni."Registrační číslo projektu" 

FROM
	(SELECT	  p."Registrační číslo projektu" as "Registrační číslo projektu",
		    p.id
	 	    
		    FROM		isum.v_bi_UMZProjekt p
		    inner join 		isum.v_bi_UMPPLatba pl ON pl.id_nositelplatby=p.id

		    WHERE	 p."Registrační číslo projektu" is not null
		     and 	 pl.WFStav = 'Proplacena příjemci s krácením/Vypořádána s krácením') kraceni

INNER JOIN
	(SELECT	  p."Registrační číslo projektu" as "Registrační číslo projektu",
		      p.id
	 	    
		    FROM		isum.v_bi_UMZProjekt p
		    inner join 		isum.v_bi_UMPPLatba pl ON pl.id_nositelplatby=p.id

		    WHERE	 p."Registrační číslo projektu" is not null
		     and 	 pl.WFStav = ('Proplacena příjemci/Vypořádána') bezkraceni
      
ON kraceni.id=bezkraceni.id

INNER JOIN

	(SELECT	  p."Registrační číslo projektu" as "Registrační číslo projektu",
		  p.id
	 	    
		    FROM		isum.v_bi_UMZProjekt p
		    inner join 		isum.v_bi_UMPPLatba pl ON pl.id_nositelplatby=p.id

		    WHERE	 p."Registrační číslo projektu" is not null
		     and 	 pl.WFStav = ('Plánovaná') planovana
      
ON kraceni.id=planovana.id
