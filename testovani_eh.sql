SELECT p.*

from isum.v_bi_UmzProjekt p
INNER JOIN isum.v_bi_UmzVyzva v ON v.id=p.id_vyzva

WHERE v."Èíslo výzvy" = '01_17_038'
