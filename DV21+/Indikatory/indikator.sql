select p."Registrační číslo projektu" ,
       i.*

from projekt p
inner join indikator_hodnota i on i.id_nositelindi = p.id

where p."Registrační číslo projektu" = 'CZ.01.01.01/01/24_062/0006868'
