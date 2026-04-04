SELECT	p."Registrační číslo projektu"

FROM	isum.v_bi_UmzProjekt p 


WHERE EXISTS
(SELECT platba.id
 FROM   isum.v_bi_UmzProjekt pp
 INNER JOIN isum.v_bi_UmpPlatbaPrj platba ON pp.id=platba.id_NositelPlatby
 WHERE platba.kodwfstav in ('P10','P11')
 AND   platba."Závěrečná platba" = 'A'
 AND   pp.id  = p.id)

AND    p.kodwfstav = 'PP40'
