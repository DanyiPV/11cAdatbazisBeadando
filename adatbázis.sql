create database kozossegi_szolgalat default charset utf8 collate utf8_hungarian_ci;

create table diak(
    id int not null auto_increment,
    nev varchar(50),
    osztaly varchar(20),
    constraint pk_diak primary key (id)
)

create table jelentkezes(
    diakid int not null,
    munkaid int not null, 
    ervenyes boolean,
    elfogadva boolean,
    teljesítve boolean
)

create table munka(
    id int not null auto_increment,
    datum date,
    kezdes time,
    hossz int,
    maxletszam int,
    tevekenysegid int,
    constraint pk_munka primary key (id)
)

create table tevekenyseg(
    id int not null auto_increment,
    nev varchar(50),
    iskolai boolean,
    constraint pk_tevekenyseg primary key (id)
)

alter table jelentkezes add constraint fk_jelentkezes_diak foreign key (diakid) references diak(id);
alter table jelentkezes add constraint fk_jelentkezes_munka foreign key (munkaid) references munka(id);
alter table munka add constraint fk_munka_tevekenyseg foreign key (tevekenysegid) references tevekenyseg(id);

--a.

INSERT INTO diak VALUES((SELECT MAX(d.id)+1
						 FROM diak d),"Kis Abdul","10/A")

--b.

SELECT d.nev
FROM diak d
WHERE d.osztaly = (SELECT d.osztaly
                    FROM diak d
                    WHERE d.nev = "Kerényi Zsuzsanna")

--c.

SELECT m.datum
FROM munka m
WHERE m.id = (SELECT j.munkaid
                FROM jelentkezes j
                WHERE j.teljesítve is false AND j.diakid = (SELECT d.id
                                                            FROM diak d
                                                            WHERE d.nev = "Pék Roland"))

--d.

SELECT DISTINCT d.nev
FROM diak d
WHERE d.id IN (SELECT j.diakid
                FROM jelentkezes j
                WHERE j.munkaid IN (SELECT m.id
                                    FROM munka m
                                    WHERE m.tevekenysegid = (SELECT t.id
                                                                FROM tevekenyseg t
                                                                WHERE t.nev = "teremrendezés")))

--e.

SELECT d.nev
from diak d
where d.id not in (
    SELECT j.diakid
    from jelentkezes j
    where j.elfogadva is false
)


--f.

SELECT d.nev
from diak d, jelentkezes j 
where d.id=j.diakid 
having count(d.id) > ALL (
    SELECT count(j.diakid)
    from jelentkezes j
)

--g.

SELECT DISTINCT t.nev
FROM munka m, tevekenyseg t
WHERE m.tevekenysegid = t.id AND t.iskolai is false AND m.maxletszam < ANY (SELECT m.maxletszam
                                                                            FROM munka m, tevekenyseg t
                                                                            WHERE t.iskolai is true AND m.tevekenysegid = t.id)

--h.



--i.

SELECT d.osztaly, COUNT(j.diakid) 
FROM diak d INNER JOIN jelentkezes j on d.id = j.diakid
WHERE d.osztaly LIKE "10%"
GROUP BY d.osztaly

--j.

SELECT d.nev, COUNT(j.munkaid)
FROM diak d INNER JOIN jelentkezes j on d.id = j.diakid
GROUP BY d.nev
HAVING d.nev LIKE "A%" OR d.nev LIKE "K%"
ORDER BY COUNT(j.munkaid) DESC
LIMIT 3

--k.

SELECT d.nev
FROM diak d left join jelentkezes j on d.id = j.diakid
WHERE j.diakid is null

--l. 

SELECT d.nev, COUNT(j.munkaid)
FROM diak d left join jelentkezes j on d.id = j.diakid
WHERE j.diakid is not null
GROUP BY d.nev

--m.
SELECT count(d.id)
from diak d left join jelentkezes j on d.id=j.diakid
left join munka m on m.id=j.munkaid
left join tevekenyseg t on t.id=m.tevekenysegid
where t.iskolai is true


--n.

select distinct d.nev
from jelentkezes j left join diak d on j.diakid=d.id

--o.


