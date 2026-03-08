SELECT	v."Název výzvy",
	v."Èíslo výzvy",
	v."Poèet ZoU",
	v.wfstav

FROM isum.v_bi_UmzVyzva v

WHERE v."Èíslo výzvy" is not null
AND v.wfstav <> 'Zru¹ená'
