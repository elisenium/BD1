---------------------------
--Exercices avec subselect
---------------------------
--1
--Donnez, pour chaque album dont le prix est supérieur au prix moyen de tous les albums, son isbn, son titre,
--sa date d’édition, son prix et le nom de son éditeur.
--Triez le résultat par ordre décroissant de prix et pour un même prix, dans l’ordre chronologique.
SELECT al.isbn, al.titre, al.prix, al.editeur
FROM bd3.albums al
WHERE al.prix > (SELECT AVG(al.prix)
                 FROM bd3.albums al)
ORDER BY al.prix DESC, al.date_edition;

--2
--Donnez l’identifiant et le nom de tous les auteurs ayant été scénariste mais jamais coloriste ou dessinateur.
SELECT DISTINCT au.id_auteur, au.nom
FROM bd3.auteurs au, bd3.participations p
WHERE au.id_auteur = p.auteur
  AND au.id_auteur NOT IN (SELECT DISTINCT p.auteur
                           FROM bd3.participations p
                           WHERE p.role = 'd'
                              OR p.role = 'c');

--3
--Donnez les éditeurs qui ont publié au moins un album n’ayant pas d’auteurs connus.
SELECT DISTINCT ed.*
FROM bd3.editeurs ed, bd3.albums al
WHERE ed.id_editeur = al.editeur
  AND al.isbn NOT IN (SELECT p.isbn
                        FROM bd3.participations p);

--4
--Donnez l’identifiant et le nom des auteurs ayant publié tous leurs albums chez "Dupuis".
--Il ne faut pas prendre les auteurs n’ayant participé à aucun album.
SELECT DISTINCT au.id_auteur, au.nom
FROM bd3.auteurs au, bd3.participations p
WHERE au.id_auteur = p.auteur
  AND au.id_auteur NOT IN (SELECT p.auteur
                            FROM bd3.participations p, bd3.albums al, bd3.editeurs ed
                            WHERE p.isbn = al.isbn
                              AND ed.id_editeur = al.editeur
                              AND ed.nom <> 'Dupuis');

---------------------------
--Exercices mélangés
---------------------------

--5
--Donnez les noms des séries dont au moins un album a été édité chez "Dupuis", et, pour chacune d’elles,
--le nombre d’albums édités chez "Dupuis".
SELECT s.nom, COUNT(al.*) nb_albums
FROM bd3.series s, bd3.albums al, bd3.editeurs ed
WHERE s.id_serie = al.serie
  AND ed.id_editeur = al.editeur
  AND ed.nom = 'Dupuis'
GROUP BY s.nom
HAVING COUNT(al.*) >= 1;

--6
--Donnez les éditeurs qui ont édité des albums en 1978 ?
SELECT DISTINCT ed.*
FROM bd3.editeurs ed, bd3.albums al
WHERE ed.id_editeur = al.editeur
  AND al.date_edition > '1977-12-31'
  AND al.date_edition < '1979-01-01';

--7
--Quels sont les albums pour lesquels le coloriste n'a pas été spécifié ?
SELECT al.*
FROM bd3.albums al
WHERE al.isbn NOT IN (SELECT p.isbn
                      FROM bd3.participations p
                      WHERE p.role = 'c');

--8
--Donnez, pour chaque série, son nom ainsi que le nombre d’auteurs y ayant contribué.
--Il ne faut garder que les séries pour lesquelles plusieurs auteurs ont contribué.
--Classez les résultats en ordre décroissant du nombre d’auteurs.
SELECT s.nom, COUNT(DISTINCT p.auteur) nb_auteurs
FROM bd3.series s, bd3.participations p, bd3.albums al
WHERE s.id_serie = al.serie
  AND p.isbn = al.isbn
GROUP BY s.nom
HAVING COUNT(DISTINCT p.auteur) >= 2
ORDER BY nb_auteurs DESC;

--9
--Donnez, pour chaque scénariste, son identifiant, son nom et le nombre d’albums qu’il a écrits.
SELECT au.id_auteur, au.nom, COUNT(p.isbn)
FROM  bd3.participations p, bd3.auteurs au
WHERE p.role = 's'
AND au.id_auteur = p.auteur
GROUP BY au.nom, au.id_auteur;

--10
--Donnez, pour chaque auteur, son identifiant, son nom et le nombre d’albums auxquels il a participé ;
--affichez les résultats dans l’ordre décroissant du nombre d’albums.
--Les auteurs n’ayant participé à aucun album ne doivent pas apparaître.
SELECT au.id_auteur, au.nom, COUNT(DISTINCT p.isbn) nb_albums
FROM bd3.auteurs au, bd3.participations p, bd3.albums al
WHERE au.id_auteur = p.auteur
  AND p.isbn = al.isbn
GROUP BY au.id_auteur, au.nom
HAVING COUNT(p.isbn) >= 1
ORDER BY nb_albums DESC;

--11
--Quels sont les scénaristes dont on a édité, après 1990, des albums qui coûtent moins de 12 euros ?
SELECT DISTINCT au.*
FROM bd3.participations p, bd3.albums al, bd3.auteurs au
WHERE p.isbn = al.isbn
  AND au.id_auteur = p.auteur
  AND p.role = 's'
  AND al.date_edition > '1990-12-31'
  AND al.prix < 12;

--12
--Donnez les isbn et titre du (des) album(s) le(s) moins cher(s) édités en 1976 ?
SELECT al.isbn, al.titre
FROM bd3.albums al
WHERE EXTRACT(YEAR FROM al.date_edition) = 1976
  AND al.prix = (SELECT MIN(al.prix)
                 FROM bd3.albums al
                 WHERE EXTRACT(YEAR FROM al.date_edition) = 1976);

--13
--Quels sont les albums qui n'ont qu'un seul auteur ?
SELECT al.*
FROM bd3.albums al, bd3.participations p
WHERE al.isbn = p.isbn
GROUP BY al.isbn
HAVING COUNT(DISTINCT p.auteur) = 1;

--14
--Donnez, par année, le nombre d’albums édité cette année-là ainsi que le prix moyen de ces albums.
--Les années où aucun album n’a été édité ne doivent pas apparaître.
SELECT EXTRACT(YEAR FROM al.date_edition) annee, COUNT(al.*) nb_albums, AVG(al.prix) prix_moyen
FROM bd3.albums al
WHERE EXTRACT(YEAR FROM al.date_edition) IS NOT NULL
GROUP BY annee;

--15
--Donnez les dessinateurs qui ont travaillé sur des albums de plusieurs séries.
SELECT DISTINCT au.*
FROM bd3.participations p, bd3.albums al, bd3.series s, bd3.auteurs au
WHERE p.isbn = al.isbn
  AND au.id_auteur = p.auteur
  AND s.id_serie = al.serie
  AND p.role = 'd'
GROUP BY au.id_auteur
HAVING COUNT(DISTINCT al.serie) > 1;

--16
--Donnez la date d'édition la plus ancienne parmi les albums édités chez "Dargaud".
SELECT MIN(al.date_edition)
FROM bd3.albums al, bd3.editeurs ed
WHERE al.editeur = ed.id_editeur
  AND ed.nom = 'Dargaud';

--17
--Donnez le(s) albums le(s) plus ancien(s) parmi ceux édités chez "Dargaud".
SELECT al.*
FROM bd3.albums al, bd3.editeurs ed
WHERE al.editeur = ed.id_editeur
  AND al.date_edition = (SELECT MIN(al.date_edition)
                         FROM bd3.albums al, bd3.editeurs ed
                         WHERE al.editeur = ed.id_editeur
                           AND ed.nom = 'Dargaud');

--18
--Donnez, pour chaque album, édité en Belgique ou en France, ayant au moins un auteur répertorié,
--son isbn, son titre et le nombre d’auteurs intervenant dans cet album.
--Classez les albums par ordre décroissant du nombre d’auteurs.
SELECT DISTINCT al.isbn, al.titre, COUNT(DISTINCT p.auteur) nb_auteurs
FROM bd3.albums al, bd3.editeurs ed, bd3.participations p, bd3.auteurs au
WHERE al.isbn = p.isbn
  AND ed.id_editeur = al.editeur
  AND au.id_auteur = p.auteur
  AND (ed.pays = 'be'
   OR ed.pays = 'fr')
GROUP BY al.isbn, al.titre
HAVING COUNT(DISTINCT p.auteur) >= 1
ORDER BY nb_auteurs DESC;

--19
--Donnez, pour chaque paire d’albums de même titre, les isbn, date d’édition et le titre.
SELECT al1.isbn,
       al2.isbn,
       al1.date_edition,
       al2.date_edition,
       al1.titre
FROM bd3.albums al1,
     bd3.albums al2
WHERE al1.titre = al2.titre
  AND al1.isbn > al2.isbn;

--20
--Donnez, pour chaque auteur dont l’adresse e-mail contient «@yahoo» et ayant participé à plusieurs albums,
--son identifiant, son nom, son adresse e-mail, son nombre d’albums et le nombre d’éditeurs ayant publié au moins un de ses albums.
SELECT au.id_auteur, au.nom, au.e_mail , COUNT(DISTINCT al.*) nb_albums, COUNT(DISTINCT al.editeur) nb_editeurs
FROM bd3.auteurs au, bd3.participations p, bd3.albums al
WHERE au.e_mail LIKE '%@yahoo%'
  AND au.id_auteur = p.auteur
  AND p.isbn = al.isbn
GROUP BY au.id_auteur
HAVING COUNT(DISTINCT al.editeur) >= 1 AND COUNT(DISTINCT al.*) >= 2;

--21
--Pour chaque auteur, donnez son identifiant, son nom et le nombre d’albums pour lesquels il est le seul auteur.
--Il ne faut pas prendre les auteurs n’ayant aucun album pour lequel il est le seul auteur.
SELECT DISTINCT au.id_auteur, au.nom, COUNT(DISTINCT al.*)
FROM  bd3.auteurs au, bd3.albums al, bd3.participations p
WHERE al.isbn = p.isbn
AND p.auteur = au.id_auteur
AND al.isbn IN (SELECT p2.isbn
    FROM bd3.participations p2
    WHERE p.isbn IS NOT NULL
    GROUP BY p2.isbn HAVING COUNT(DISTINCT p2.auteur) = 1)
GROUP BY au.id_auteur, au.nom, au.e_mail
ORDER BY id_auteur;