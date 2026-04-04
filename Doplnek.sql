(SELECT p."Registrační číslo projektu"

FROM isum.v_bi_UmzProjekt p

WHERE p."Registrační číslo projektu" in  ('CZ.01.5.125/0.0/0.0/15_020/0015310','CZ.01.1.02/0.0/0.0/15_018/0004790'))


MINUS


(SELECT p."Registrační číslo projektu"

FROM isum.v_bi_UmzProjekt p

WHERE p."Registrační číslo projektu" in  ('CZ.01.5.125/0.0/0.0/15_020/0015310'))
