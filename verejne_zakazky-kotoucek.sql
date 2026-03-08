
/* Od Kotouèka, nedotahuje správnì vazba na Projektu 26 */

SELECT
p."Registraèní èíslo projektu",
p."Název projektu CZ",
p.zadatel,
p."IÈ" "IÈ ¾adatele",
p.kodwfstav ,
vz.nazev as nazevvz,
vz.poradovecislo as cislovz,
vz.CENADLESMLOUVY,
vz.CASTKAPREDPOKLAD,
v."Èíslo výzvy",
v."Název výzvy" ,
ci."Název" "Administrativní stav VØ",
cis."Název" "Stav VØ",
gg.eu,
gg.czv,
nvl(vs."Název subjektu",
(SELECT s."Název subjektu"
 FROM isum.v_bi_UMVVRDodatek d
 INNER JOIN isum.v_bi_umsciszakladni typd on typd.id=d.id_typ and typd."Kód"='2'
 INNER JOIN isum.v_bi_umsrsverzesubjektu s on s.id=d.ID_VERZESUBJEKTU
 WHERE d.id_vyberovarizeni=vz.id and d.ID_VERZESUBJEKTU>0 and rownum=1)
 )  as "Vítìzný dodavatel",
 vs."IÈ"

FROM isum.v_bi_umzprojekt p
INNER JOIN isum.v_bi_umzprjgg gg ON gg.id=p.id 
INNER JOIN isum.v_bi_umvvyberovarizeni vz on vz.id_nositelvr=p.id
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva 
INNER JOIN isum.v_bi_UmsCisZakladni ci ON ci.id = vz.id_admstav
INNER JOIN isum.v_bi_UmsCisZakladni cis ON cis.id = vz.id_vrstav
LEFT JOIN isum.v_bi_UMVVRDODAVATEL dod ON dod.id_vyberovarizeni = vz.id
LEFT JOIN isum.v_bi_umsrsverzesubjektu vs ON vs.id = dod.ID_VERZESUBJEKTU 


WHERE
p."Registraèní èíslo projektu"='CZ.01.1.02/0.0/0.0/15_002/0000026'
-- p.KodPrioritniOsa in ('01.1', '01.2', '01.3', '01.4','01.5')
AND p.kodwfstav in ('PP30','PP36','PP37','PP40','PP41','PP42','PP43','PN40a','PN40b') 


ORDER BY substr(p."Registraèní èíslo projektu",-5,5) ASC , vz.poradovecislo






















