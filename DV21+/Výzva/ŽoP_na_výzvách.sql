

    SELECT v."Èíslo výzvy",
           v."Název výzvy",
           op.kodnovy,
           op.nazev AS "Opatøení",
           v."Finanèní alokace výzvy (CZV)",
           vw."Název" AS "Stav výzvy",
           (
               (
                   (
                       coalesce(
                           predpa."Poèet ®oP projektù pøed RoPD",
                           0
                       ) + coalesce(
                           popaiskp."Poèet nepodanýc ®oP projektù s RoPD",
                           0
                       )
                   ) + coalesce(
                       popapodane."Poèet neproplacených podaných ®oP",
                       0
                   )
               ) + coalesce(popapropl."Poèet proplacených ®oP projektù po RoPD", 0)
           ) AS "®oP celkem",
           (
               (
                   coalesce(
                       predpa."Poèet ®oP projektù pøed RoPD",
                       0
                   ) + coalesce(
                       popaiskp."Poèet nepodanýc ®oP projektù s RoPD",
                       0
                   )
               ) + coalesce(popapodane."Poèet neproplacených podaných ®oP", 0)
           ) AS "Nepropacených ®oP celkem",
           coalesce(popapropl."Poèet proplacených ®oP projektù po RoPD", 0) AS "Proplacených ®oP celkem",
           (
               (
                   coalesce(
                       popapropl."Poèet proplacených ®oP projektù po RoPD",
                       0
                   ) /(
                       (
                           (
                               coalesce(
                                   predpa."Poèet ®oP projektù pøed RoPD",
                                   0
                               ) + coalesce(
                                   popaiskp."Poèet nepodanýc ®oP projektù s RoPD",
                                   0
                               )
                           ) + coalesce(
                               popapodane."Poèet neproplacených podaných ®oP",
                               0
                           )
                       ) + coalesce(
                           popapropl."Poèet proplacených ®oP projektù po RoPD",
                           0
                       )
                   )
               ) * 100
           ) AS "Proplaceno ®oP (%)",
           (
               (
                   (
                       (
                           coalesce(
                               predpa."EU dotace pøed RoPD",
                               0
                           ) + coalesce(
                               popaiskp."Nepropacene EU dotace v nepodaných ®oP projektù s RoPD",
                               0
                           )
                       ) + coalesce(
                           popapodane."Poèet neproplacených podaných ®oP",
                           0
                       )
                   ) + coalesce(
                       popapodane."Nepropacene EU dotace v podaných ®oP",
                       0
                   )
               ) + coalesce(popapropl."Proplacené EU dotace po RoPD", 0)
           ) AS "Celková po¾adovaná EU dotace",
           (
               (
                   (
                       coalesce(
                           predpa."EU dotace pøed RoPD",
                           0
                       ) + coalesce(
                           popaiskp."Nepropacene EU dotace v nepodaných ®oP projektù s RoPD",
                           0
                       )
                   ) + coalesce(
                       popapodane."Poèet neproplacených podaných ®oP",
                       0
                   )
               ) + coalesce(popapodane."Nepropacene EU dotace v podaných ®oP", 0)
           ) AS "Celková nepropacená EU dotace",
           coalesce(popapropl."Proplacené EU dotace po RoPD", 0) AS "Proplacené EU dotace po RoPD",
           (
               coalesce(popapropl."Proplacené EU dotace po RoPD", 0) /(
                   (
                       (
                           (
                               coalesce(
                                   predpa."EU dotace pøed RoPD",
                                   0
                               ) + coalesce(
                                   popaiskp."Nepropacene EU dotace v nepodaných ®oP projektù s RoPD",
                                   0
                               )
                           ) + coalesce(
                               popapodane."Poèet neproplacených podaných ®oP",
                               0
                           )
                       ) + coalesce(
                           popapodane."Nepropacene EU dotace v podaných ®oP",
                           0
                       )
                   ) + coalesce(popapropl."Proplacené EU dotace po RoPD", 0)
               )
           ) AS "Proplacená dotace (%)",
           coalesce(predpa."Poèet ®oP projektù pøed RoPD", 0) AS "Poèet ®oP projektù pøed RoPD",
           coalesce(predpa."EU dotace pøed RoPD", 0) AS "EU dotace pøed RoPD",
           coalesce(popaiskp."Poèet nepodanýc ®oP projektù s RoPD", 0) AS "Poèet nepodanýc ®oP projektù s RoPD",
           coalesce(
               popaiskp."Nepropacene EU dotace v nepodaných ®oP projektù s RoPD",
               0
           ) AS "Nepropacene EU dotace v nepodaných ®oP projektù s RoPD",
           coalesce(popapodane."Poèet neproplacených podaných ®oP", 0) AS "Poèet neproplacených podaných ®oP",
           coalesce(popapodane."Nepropacene EU dotace v podaných ®oP", 0) AS "Nepropacene EU dotace v podaných ®oP" ,

	   coalesce(propl."Proplaceno v zálohových ®oP",0) "Proplaceno v zálohových ®oP",
           coalesce(propl."Poèet proplacených ®oP",0) "Poèet proplacených ®oP",
	   coalesce(propl."Proplaceno EU") "Proplaceno EU"


FROM (
             (
                 (
                     (
                         (
                             (vyzva AS v INNER JOIN ciselnik_stav_workflow AS vw ON vw.id = v.id_wfstav)
                             INNER JOIN vyzva_hierarchie AS vh
                                 ON vh.id_vyzva = v.id
                         )
                         INNER JOIN v_rav_umshisc AS op
                             ON op.id = vh.id_speccil
                     )
                     LEFT OUTER JOIN (
                         SELECT p.id_vyzva,
                                sum(
                                    CASE WHEN ((p.id_typplatby = 282638 AND pl."Zálohová platba" = 'A')) THEN
                                        pl."Èástka na krytí výdajù - skuteènost"
                                    ELSE
                                        pl."Vyúètování - skuteènost"
                                    END
                                ) AS "EU dotace pøed RoPD",
                                count(pl.id) AS "Poèet ®oP projektù pøed RoPD"
                         FROM (projekt AS p INNER JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav)
                              INNER JOIN platba AS pl
                                  ON pl.id_nositelplatby = p.id
                         WHERE (
                                   pw."Kód" IN (
                                       'Z1',
                                       'Z2',
                                       'Z3',
                                       'Z4',
                                       'PP20',
                                       'PP22',
                                       'PU22a',
                                       'PP23a',
                                       'PP23b',
                                       'PU24',
                                       'PP24',
                                       'PP25a',
                                       'PP25b',
                                       'PP26',
                                       'PU26'
                                   )
                                   AND p."Registraèní èíslo projektu" IS NOT NULL
                               )
                         GROUP BY p.id_vyzva
                     ) AS predpa
                         ON predpa.id_vyzva = v.id
                 )
                 LEFT OUTER JOIN (
                     SELECT p.id_vyzva,
                            sum(
                                CASE WHEN ((p.id_typplatby = 282638 AND pl."Zálohová platba" = 'A')) THEN
                                    pl."Èástka na krytí výdajù - skuteènost"
                                ELSE
                                    pl."Vyúètování - skuteènost"
                                END
                            ) AS "Proplacené EU dotace po RoPD",
                            count(pl.id) AS "Poèet proplacených ®oP projektù po RoPD"
                     FROM (
                              (projekt AS p INNER JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav)
                              INNER JOIN platba AS pl
                                  ON pl.id_nositelplatby = p.id
                          )
                          INNER JOIN ciselnik_stav_workflow AS w
                              ON pl.id_wfstav = w.id
                     WHERE (
                               pw."Kód" regexp_like '^PP[34][0-9]'
                               AND w."Kód" IN ('P10', 'P11', 'P12', 'P13', 'P13T', 'P14', 'P14T')
                           )
                     GROUP BY p.id_vyzva
                 ) AS popapropl
                     ON popapropl.id_vyzva = v.id
             )
             LEFT OUTER JOIN (
                 SELECT p.id_vyzva,
                        sum(
                            CASE WHEN ((p.id_typplatby = 282638 AND pl."Zálohová platba" = 'A')) THEN
                                pl."Èástka na krytí výdajù - skuteènost"
                            ELSE
                                pl."Vyúètování - skuteènost"
                            END
                        ) AS "Nepropacene EU dotace v podaných ®oP",
                        count(pl.id) AS "Poèet neproplacených podaných ®oP"
                 FROM (
                          (projekt AS p INNER JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav)
                          INNER JOIN platba AS pl
                              ON pl.id_nositelplatby = p.id
                      )
                      INNER JOIN ciselnik_stav_workflow AS w
                          ON pl.id_wfstav = w.id
                 WHERE (pw."Kód" regexp_like '^PP[34][0-9]' AND w."Kód" IN ('P4', 'P5', 'P5T', 'P6', 'P6T'))
                 GROUP BY p.id_vyzva
             ) AS popapodane
                 ON popapodane.id_vyzva = v.id
         )
         LEFT OUTER JOIN (
             SELECT p.id_vyzva,
                    sum(
                        CASE WHEN ((p.id_typplatby = 282638 AND pl."Zálohová platba" = 'A')) THEN
                            pl."Èástka na krytí výdajù - skuteènost"
                        ELSE
                            pl."Vyúètování - skuteènost"
                        END
                    ) AS "Nepropacene EU dotace v nepodaných ®oP projektù s RoPD",
                    count(pl.id) AS "Poèet nepodanýc ®oP projektù s RoPD"
             FROM (
                      (projekt AS p INNER JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav)
                      INNER JOIN platba AS pl
                          ON pl.id_nositelplatby = p.id
                  )
                  INNER JOIN ciselnik_stav_workflow AS w
                      ON pl.id_wfstav = w.id
             WHERE (pw."Kód" regexp_like '^PP[34][0-9]' AND w."Kód" regexp_like '^P[0-3]')
             GROUP BY p.id_vyzva
         ) AS popaiskp
             ON popaiskp.id_vyzva = v.id

-------------------- Ruènì dopisuji proplacené platby 
 LEFT OUTER JOIN (
             SELECT p.id_vyzva,
                    sum(
                        CASE WHEN ((p.id_typplatby = 282638 AND pl."Zálohová platba" = 'A')) THEN
                            pl."Èástka na krytí výdajù - skuteènost"
                        ELSE
                            pl."Vyúètování - skuteènost"
                        END
                    ) AS "Proplaceno v zálohových ®oP",
                    count(pl.id) AS "Poèet proplacených ®oP" ,
		    count(rf."Schválené vyúètování ZS/ØO v této ®oP") AS "Proplaceno EU"
             FROM projekt AS p
 	     	  INNER JOIN ciselnik_stav_workflow AS pw ON pw.id = p.id_wfstav
 		  INNER JOIN platba AS pl ON pl.id_nositelplatby = p.id
 		  INNER JOIN ciselnik_stav_workflow AS w ON pl.id_wfstav = w.id
		  INNER JOIN rozpis_financovani rf ON rf.id_platba = pl.id 
		  INNER JOIN ciselnik_ukazatel_rozpis_financovani cuk ON cuk.id = rf.id_ukazatel AND cuk."Kód" = '7' -- øádek F1-C EU celkem
 
             WHERE (pw."Kód" regexp_like '^PP[34][0-9]' AND w."Kód" regexp_like 'P1[01]')
             GROUP BY p.id_vyzva
         ) AS propl ON propl.id_vyzva = v.id



    WHERE ( 
              v.id_integnastr = 0
              AND vw."Název" <> 'Zru¹ená'
	      AND v."Èíslo výzvy" = '01_22_006'

              AND (
                  (
                      (
                          coalesce(
                              predpa."Poèet ®oP projektù pøed RoPD",
                              0
                          ) + coalesce(
                              popaiskp."Poèet nepodanýc ®oP projektù s RoPD",
                              0
                          )
                      ) + coalesce(
                          popapodane."Poèet neproplacených podaných ®oP",
                          0
                      )
                  ) + coalesce(popapropl."Poèet proplacených ®oP projektù po RoPD", 0)
              ) > 0
          )
    ORDER BY kodnovy ASC,
             "Èíslo výzvy" ASC;
