select platba."Èíslo ¾ádosti o platbu" ,
       platba.kodwfstav  ,
       platba."Datum zmìny stavu",
       platba."Export do ÚIS",
       platba."Bez proplacení",
       rf.CASTKASCHVALENA "Èástka schválená" 


FROM isum.v_bi_UmpPlatbaPrj platba
INNER JOIN isum.v_bi_UmpRozpisFin rf ON rf.id_platba = platba.id AND rf.id_ukazatel in ( 361356 ) -- XX, YY, 10a, ZZ

where platba."Èíslo ¾ádosti o platbu" IN ('CZ.31.3.0/0.0/0.0/22_006/0007729/2024/002/POST','CZ.31.3.0/0.0/0.0/22_001/0000704/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0001242/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0001353/2025/001/POST','CZ.31.3.0/0.0/0.0/22_001/0001907/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0001915/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0001917/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0002754/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0004042/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0005932/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0006697/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0006724/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0006868/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0006950/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0007286/2024/001/POST','CZ.31.3.0/0.0/0.0/22_001/0002513/2025/001/POST')
