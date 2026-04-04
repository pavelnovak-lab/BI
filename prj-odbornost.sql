SELECT	p."Registrační číslo projektu",
	cis."Název" as "Odbornost na projektu",
	v."Číslo výzvy",
	v."Název výzvy"

FROM	isum.v_bi_umzvyzva v 
 JOIN	isum.v_bi_umzprojekt p ON v.id=p.id_vyzva
 JOIN	isum.v_bi_umvhodnnosodbornost nos ON nos.id_noshodnoceni=p.id
 JOIN	isum.v_bi_umscisodbornost cis ON cis.id=nos.id_odbornost

WHERE p."Registrační číslo projektu" in ('CZ.01.4.03/0.0/0.0/19_259/0025071','CZ.01.1.02/0.0/0.0/20_321/0024137')

