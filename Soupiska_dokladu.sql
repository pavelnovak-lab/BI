SELECT
p."Registrační číslo projektu",
a."PORADI#Pořadí finančního plánu",
d."Pořadové číslo",
decode(d.TYPDOKLADU,0,'Příjmy',
				1,'Obecný',
				2,'Mzdy',
				3,'Cestovné',
				4,'Nezpůsobilé výdaje',
				5,'Jednotky') as TYPDOKLADU,
d."Snížení prokazovaných způsobil",
d.SNIZENIBEZDPH,
d.VYDAJESCHVAL,
y."Kód",
y."Název",
decode(d."Investice/Neinvestice",0,'Neinvestice',1,'Investice') as "Investice/Neinvestice",
d."Částka DPH připadající na \nPr",
d."Částka bez DPH připadající na",
d."Celková částka \nuvedená na do",
d."Číslo účetního dokladu \nv úče",
to_char(d."Datum vystavení dokladu",'dd.MM.yyyy') as "Datum vystavení dokladu",
to_char(d."Datum uskutečnění \nzdanitelné",'dd.MM.yyyy') as "Datum uskutečnění \nzdanitelné",
to_char(d."DATUMUHRADY",'dd.MM.yyyy') as "DATUMUHRADY",
d."Celková částka bez DPH \nuvede",
d."Celková částka DPH \nuvedená n",
d.VYDAJEPROKAZ,
d."IČO Dodavatele",
d."Název Dodavatele",
d."Číslo smlouvy/objednávky, ke k",
decode(d."Nerelevantní",'A','Ano','Ne') as "Nerelevantní",
vz.NAZEV,
vz.PORADOVECISLO,
decode(d."VŘ nerelevantní",'A','Ano','Ne') as "VŘ nerelevantní",
d.ZTOHOSF,
d.ZTOHOSR,
d.NEZPUSOBILE,
d.DUVODKRACENI,
to_char(d.DATUMLZ,'MM.yyyy') as DATUMLZ,
d.JMENO,
d.PRIJMENI,
decode(d.DRUHPRACVZTAHU,0,'Pracovní smlouva',
				1,'Dohoda o pracovní činnosti',
				2,'Dohoda o provedení práce do 10 tis. Kč vč. měsíčně',
				3,'Dohoda o provedení práce nad 10 tis. Kč měsíčně') as DRUHPRACVZTAHU,
d.FONDPRACDOBY,
d.MZDAMESIC,
d.MZDAHODINOVA,
d.MZDAHODINOVABCD,
d.POCETHODINNAPRJ,
d.JINEVYDAJESODVODY,
d.JINEVYDAJEBEZODVODU,
d.PLATOVYVYDAJ,
d.POJISTNE,
decode(d."Druh pracovní cesty",0,'Tuzemská',1,'Zahraniční',2,'Zahraniční expert') as "Druh pracovní cesty",
d."Účel pracovní cesty",
to_char(d."Datum zahájení \npracovní cest",'dd.MM.yyyy') as "Datum zahájení \npracovní cest",
to_char(d."Datum ukončení \npracovní cest",'dd.MM.yyyy') as "Datum ukončení \npracovní cest",
d."Počet dnů/nocí pracovní cesty",
d."Popis příjmu",
d."Snížení částky DPH připadající",
tk.NAZEV as zpusob_kraceni,
d."Počet příloh",
m."Kód" as mena,
s."Název subjektu"
FROM
isum.V_BI_UMZPRJGGii p
inner join isum.V_BI_UMPPLATBAPRJ a on a.ID_NOSITELPLATBY=p.id and a.KODWFSTAV in ('P6T','P10')
inner join isum.V_BI_UMFSOUPISKADOKLAD d on d.ID_PLATBA=a.id
inner join isum.V_BI_UMFROZPOLOZKY y on y.id=d.id_polozka
inner join isum.V_BI_UMVVYBEROVARIZENI vz on vz.id=d.id_vz
inner join isum.V_BI_UMSCisZakladni m on m.id=d.id_mena
inner join isum.V_BI_UMSrsVerzeSubjektu s on s.id=d.id_subjekt
inner join isum.V_BI_UMSCisTypKorekce tk on tk.id=d.id_zpusobkraceni

WHERE p."Registrační číslo projektu" is not null

-- p.id in (:projekt)
-- and a."PORADI#Pořadí finančního plánu" in (:Poradi)
-- and (((d.VYDAJESCHVAL<7462 and  d."TYPDOKLADU" ='2' and (y."Kód" like :D0 or y."Kód" like :D1)) and d."TYPDOKLADU"  not in ('1','3'))
-- 			or ((d.VYDAJESCHVAL<10001 and  d."TYPDOKLADU" ='2' and y."Kód" like :D2) and d."TYPDOKLADU"  not in ('1','3'))
-- 			or (((d.VYDAJESCHVAL<10001 and  d."TYPDOKLADU"  in ('1','3') and :D3=1) or d."TYPDOKLADU"  in ('1','3') and :D3=0))
-- 			or (:D0='%' and :D1='%' and :D2='%' and :D3=0))
