SELECT DISTINCT  p."Registrační číslo projektu" ,
       p.zadatel ,
       p.kodwfstav ,       
       v."Název výzvy" ,
       pp."Identifikační číslo akce"
       

FROM isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva
inner join isum.V_BI_UMZISPeProjekt pp on pp.id_nositelispeproj=p.id
-- inner join isum.V_BI_UMZISPeBilance e on e.id_eprojekt=pp.id


WHERE pp."Identifikační číslo akce" IN ('122D185004339', '122D185004188', '122D187001191', '122D182000326', '122D185002869', '122D185004188', '122D185004286', '122D185004339', '122D185004371', '122D187001191', '122D18C000227')


