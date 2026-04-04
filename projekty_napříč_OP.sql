SELECT p.czv, p.eu, p."Registrační číslo projektu",
--       p."Anotace projektu",
       p."Datum podání",
       p."Doba trvání proj skut (měs)",
       p."Integrovaný",
       p."Název projektu CZ" ,
       p.kodwfstav,
       p."Velký projekt",
       proj.zadatel,
       proj."IČ",
       proj."Počet ZoU",
       v."OP kod"

FROM isum.v_bi_umzprjgg p
INNER JOIN isum.v_bi_UmzProjekt proj ON proj.id = p.id
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 


WHERE p."Registrační číslo projektu" is not null 
