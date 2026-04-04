SELECT p."Registrační číslo projektu",
       castky.VyuctCZCelk


FROM	isum.v_bi_UmpPlatbaPrj platba
 inner join	isum.v_bi_UmpCastkySchval castky ON platba.id_SchvaleneCastky=castky.id
-- Lukáš Píše jednostrannou vazbu
  inner join  	isum.v_bi_UmzProjekt p ON p.id=platba.id_NositelPlatby

WHERE 	p."Registrační číslo projektu"='CZ.01.1.02/0.0/0.0/15_019/0004353'
