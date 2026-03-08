SELECT p."Registraèní èíslo projektu",
       p."Název projektu CZ",
       p.zadatel,
       p."IÈ" "IÈ ¾adatele",
       p.kodwfstav ,
       vz.nazev as nazevvz,
       vz.poradovecislo as cislovz,
       vz.CENADLESMLOUVY,
       vz.CASTKAPREDPOKLAD,
       vz.DatumUkonceni "Pøedpokldáné datum ukonèení",
       v."Èíslo výzvy",
       v."Název výzvy" ,
       ci."Název" "Administrativní stav VØ",
       cis."Název" "Stav VØ",
       dz."Název" "Specifikace druhu zadavatele",
       druh."Název" "Druh zadávacího/výbìrového øízení"

FROM isum.v_bi_umzprojekt p
INNER JOIN isum.v_bi_umvvyberovarizeni vz on vz.id_nositelvr=p.id
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = vz.id_admstav
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vz.id_vrstav
INNER JOIN isum.v_bi_UmsCisZakladni dz ON dz.id = vz.id_vrdruhzadav
INNER JOIN isum.v_bi_UmsCisZakladni druh ON druh.id = vz.id_vrdruh
LEFT JOIN isum.v_bi_UMVVRDODAVATEL dod ON dod.id_vyberovarizeni = vz.id
LEFT JOIN isum.v_bi_umsrsverzesubjektu vs ON vs.id = dod.ID_VERZESUBJEKTU 


WHERE p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PN40a','PN40b') 
AND (dz."Název" IN ('Dotovaný (dle ZVZ) / zadavatel dotované VZ (ZZVZ)','Veøejný') OR druh."Název" = 'Zjednodu¹ené podlimitní øízení')

ORDER BY substr(p."Registraèní èíslo projektu",-5,5) DESC , vz.DatumUkonceni
