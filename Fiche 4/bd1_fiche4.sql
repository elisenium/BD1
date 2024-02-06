--1
--Pour quel(s) éditeur(s) a travaillé « Goscinny » ?
SELECT DISTINCT ed.*
FROM bd3.albums al, bd3.participations p, bd3.editeurs ed
WHERE ed.id_editeur = al.editeur
  AND al.isbn = p.isbn
  AND p.auteur = (SELECT au.id_auteur
                  FROM bd3.auteurs au
                  WHERE au.nom = 'Goscinny');

--2
--Quel est/sont le(s) dessinateur(s) de l'album « Astérix chez les Belges » ?
SELECT DISTINCT au.*
FROM bd3.auteurs au, bd3.albums al, bd3.participations p
WHERE al.isbn = p.isbn
  AND p.auteur = au.id_auteur
  AND al.titre = 'Astérix chez les Belges'
  AND p.role = 'd';

--3
--Quels sont les auteurs qui ont travaillé comme dessinateurs et/ou coloristes chez « Dupuis » ?
SELECT DISTINCT au.*
FROM bd3.auteurs au, bd3.editeurs ed, bd3.albums al, bd3.participations p
WHERE al.isbn = p.isbn
  AND p.auteur = au.id_auteur
  AND al.editeur = ed.id_editeur
  AND ed.nom = 'Dupuis'
  AND (p.role = 'd'
           OR p.role = 'c');

-----------------------------
-- Exercices sur 'GROUP BY'
-----------------------------
--4
--Donnez, pour chaque scénariste, son identifiant, son nom et le nombre d’albums qu’il a écrits.
SELECT au.id_auteur, au.nom, COUNT(al.*) nb_albums
FROM bd3.participations p, bd3.albums al, bd3.auteurs au
WHERE p.isbn = al.isbn
  AND p.auteur = au.id_auteur
  AND p.role = 's'
GROUP BY au.id_auteur;

--5
--Pour chaque éditeur ayant publié au moins 10 albums, donnez son identifiant, son nom,
--son pays et la date du plus ancien et du plus récent de ses albums.
SELECT ed.id_editeur, ed.nom, ed.pays, MIN(al.date_edition) date_plus_ancienne, MAX(al.date_edition) date_plus_recente
FROM bd3.albums al, bd3.editeurs ed
WHERE ed.id_editeur = al.editeur
  GROUP BY ed.id_editeur
  HAVING COUNT(al.*) >= 10;

--6
--Donnez, pour chaque série, son nom ainsi que le nombre d’albums en faisant partie et le prix total à payer si on veut
--acheter tous les albums de la série. Classez le résultat par ordre décroissant du nombre d’albums.
--Vous ne devez pas prendre les séries sans albums.
SELECT s.nom, COUNT(al.*) nb_albums, SUM(al.prix) prix_total
FROM bd3.series s, bd3.albums al
WHERE s.id_serie = al.serie
GROUP BY s.nom
ORDER BY nb_albums DESC;

--7
--Donnez, par année, le nombre d’albums édités en Belgique ainsi que le prix moyen de ces albums.
--Il ne faut garder que les années où il y a eu plusieurs albums édités en Belgique et il faut classer le résultat
--par ordre décroissant du nombre d’albums édités en Belgique et, en cas d’égalité, par ordre croissant de l’année.
SELECT date_part('year', al.date_edition) AS annee, COUNT(al.isbn) AS nb_albums, AVG(al.prix) AS prix_moyen
FROM bd3.albums al, bd3.editeurs ed
WHERE ed.id_editeur = al.editeur
AND ed.pays = 'be'
GROUP BY date_part('year', al.date_edition)
HAVING COUNT(al.isbn) > 1
ORDER BY 2 DESC, 1;

-----------------------------
-- Exercices mélangés
-----------------------------
--8
--Combien d'auteurs (différents) a-t-on répertoriés pour l'album « Coke en Stock » dont l’ISBN est 2-203-00109-0 ?
SELECT COUNT(DISTINCT au.*)
FROM bd3.auteurs au, bd3.albums al, bd3.participations p
WHERE au.id_auteur = p.auteur
  AND p.isbn = al.isbn
  AND al.titre = 'Coke en Stock'
  AND al.isbn = '2-203-00109-0';

--10
--Donnez la liste des albums édités en Belgique ou en France, appartenant à une série et ayant plusieurs auteurs.
--Pour chacun de ces albums, affichez son ISBN, son titre, le nom de sa série, son prix et son nombre d’auteurs.
SELECT al.isbn, al.titre, s.nom, al.prix, COUNT(DISTINCT p.auteur) AS nb_auteurs
FROM bd3.editeurs ed, bd3.albums al, bd3.participations p, bd3.series s
WHERE ed.id_editeur = al.editeur
  AND s.id_serie = al.serie
  AND p.isbn = al.isbn
  AND (ed.pays = 'be' OR ed.pays = 'fr')
GROUP BY al.isbn, al.titre, s.nom, al.prix
HAVING COUNT(DISTINCT p.auteur) > 1;

--11
--Donnez, pour chaque éditeur, son identifiant, son nom et le nombre de séries pour lesquelles il a publié au moins un album.
--Classez les résultats par ordre décroissant du nombre de séries, et pour les éditeurs ayant le même nombre de séries,
--par nom d’éditeur.
--Vous ne devez pas afficher les éditeurs n’ayant pas publié d’albums appartenant à une série.
SELECT ed.id_editeur, ed.nom, COUNT(DISTINCT s.*) nb_series
FROM bd3.editeurs ed, bd3.series s, bd3.albums al
WHERE s.id_serie = al.serie
  AND ed.id_editeur = al.editeur
GROUP BY ed.id_editeur, ed.nom
HAVING COUNT(al.*) >= 1
ORDER BY nb_series DESC , ed.nom ;

--12
--Quels sont les albums édités par « Dupuis » pour lesquels on connaît le coloriste ?
SELECT DISTINCT al.*
FROM bd3.participations p, bd3.albums al, bd3.editeurs e
WHERE p.isbn = al.isbn AND al.editeur = e.id_editeur
  AND e.nom = 'Dupuis'
  AND p.role = 'c';

--13
--Quelle est la date d’édition de l'album le plus récent ayant « Goscinny » parmi ses auteurs ?
SELECT MAX(al.date_edition) date_edition_plus_recente
FROM bd3.albums al, bd3.participations p, bd3.auteurs au
WHERE al.isbn = p.isbn
  AND au.id_auteur = p.auteur
  AND au.nom = 'Goscinny';

--14
--Donnez les identifiants et noms des auteurs qui ont collaboré, d'une façon ou d'une autre,
--à des albums de la série « Astérix » avant 2010.
SELECT DISTINCT au.id_auteur, au.nom
FROM bd3.auteurs au, bd3.albums al, bd3.series s, bd3.participations p
WHERE au.id_auteur = p.auteur
  AND al.isbn = p.isbn
  AND s.id_serie = al.serie
  AND s.nom = 'Astérix'
  AND al.date_edition < '2010-01-01';

--15
--Quels rôles « Uderzo » a-t-il tenus dans les albums édités par « Dargaud » ?
SELECT DISTINCT p.role
FROM bd3.participations p, bd3.albums al, bd3.editeurs ed, bd3.auteurs au
WHERE p.isbn = al.isbn
  AND ed.id_editeur = al.editeur
  AND au.id_auteur = p.auteur
  AND au.nom = 'Uderzo'
  AND ed.nom = 'Dargaud';

--16
--Quels sont les auteurs qui ont joué plusieurs rôles (dessinateur, coloriste ...) dans un même album ?
SELECT DISTINCT au.*
FROM bd3.auteurs au, bd3.participations p1, bd3.participations p2
WHERE au.id_auteur = p1.auteur
  AND p1.isbn = p2.isbn
  AND p1.auteur = p2.auteur
  AND p1.role <> p2.role;

SELECT DISTINCT au.*
FROM bd3.auteurs au, bd3.participations p
WHERE au.id_auteur = p.auteur
GROUP BY au.id_auteur, au.nom, au.e_mail, p.isbn
HAVING COUNT(p.role) > 1;

--17
--Combien y a-t-il d'albums dessinés par chaque dessinateur ? Pour chaque dessinateur, affichez son identifiant,
-- son nom et le nombre d’albums dessinés en classant le résultat par ordre décroissant du nombre d’albums dessinés
SELECT au.id_auteur, au.nom, COUNT(p.isbn)
FROM bd3.auteurs au, bd3.participations p
WHERE au.id_auteur = p.auteur
  AND p.role = 'd'
GROUP BY au.id_auteur, au.nom
ORDER BY COUNT(p.isbn) DESC;

--18
--Affichez le nom des séries n’ayant eu qu’un seul auteur.
SELECT s.nom
FROM bd3.series s, bd3.auteurs au, bd3.albums al, bd3.participations p
WHERE s.id_serie = al.serie
  AND al.isbn = p.isbn
  AND au.id_auteur = p.auteur
GROUP BY s.nom
HAVING COUNT(DISTINCT au.*) = 1;

--19
--Donnez l’isbn, le titre et la date d’édition de tous les albums,
--édités en 1980 ou en 1981, n’appartenant pas à une série.
SELECT al.isbn, al.titre, al.date_edition
FROM bd3.albums al
WHERE (al.date_edition > '1979-12-31'
  AND al.date_edition < '1982-01-01'
  AND al.serie IS NULL);

--20
--Pour chaque éditeur qui a édité au moins un album de moins de 10€, affichez son identifiant, son nom, sa nationalité,
--et le nombre d’albums de moins de 10€ qu'il a publiés.
--Les éditeurs de même nationalité doivent se suivre et pour une même nationalité,
--les éditeurs doivent être triés par ordre décroissant du nombre d'albums de moins de 10 euros.
SELECT ed.id_editeur, ed.nom, ed.pays, COUNT(al.*) albums_moins_de_10_eur
FROM bd3.editeurs ed, bd3.albums al
WHERE ed.id_editeur = al.editeur
  AND al.prix < 10
GROUP BY ed.pays, ed.id_editeur
HAVING COUNT(al.*) >= 1
ORDER BY albums_moins_de_10_eur DESC ;