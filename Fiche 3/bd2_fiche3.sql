--1
--Donnez la liste des albums, avec, pour chacun d'eux, l'isbn, le titre, le scénariste, le dessinateur et
-- le numéro de l'éditeur.
SELECT alb.isbn, alb.titre, alb.scenariste, alb.dessinateur, ed.id_editeur
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur;

--2
--Donnez la liste des albums, avec, pour chacun d'eux, l'isbn, le titre, le scénariste, le dessinateur et
-- le nom de l'éditeur.
SELECT alb.isbn, alb.titre, alb.scenariste, alb.dessinateur, id_editeur, ed.nom
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur;

--3
--Donnez la liste des albums (isbn, titre et nom de l'éditeur) dont l'éditeur est belge.
SELECT alb.isbn, alb.titre, ed.nom, ed.pays
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND ed.pays = 'be';

--4
--Donnez la liste des albums dont l'éditeur est belge sans la condition de jointure (isbn, titre et nom de l'éditeur).
-- Que constatez-vous ?
SELECT *
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.pays = 'be';

--5
--Quels sont les albums (isbn et titre) de la série « Astérix » qui n'ont pas été édités chez « Dargaud » ?
SELECT alb.isbn, alb.titre
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND ed.nom <> 'Dargaud'
  AND serie = 'Astérix';

--6
--Quels sont les éditeurs (id et nom) qui ont édité en 1999 des livres coûtant au moins 10 euros ?
SELECT ed.id_editeur, ed.nom
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND (alb.date_edition > '1998-12-31' AND alb.date_edition < '1999-12-31')
  AND alb.prix >= 10;

--7
--Chez quel(s) éditeur(s) (id et nom) « Uderzo » a-t-il publié des albums (en tant que scénariste, dessinateur ou
-- coloriste) ?
SELECT DISTINCT ed.id_editeur, ed.nom
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND (alb.scenariste = 'Uderzo'
           OR alb.dessinateur = 'Uderzo'
           OR alb.coloriste = 'Uderzo');

--8
--Quels sont les éditeurs (id et nom) localisés ailleurs qu'en Belgique ou pour lequel le pays n'est pas précisé ?
SELECT id_editeur, nom
FROM bd2.editeurs
WHERE pays != 'be'
   OR pays IS NULL;

--9
--Quels sont les albums qui ont été édités en Belgique ou en France, et qui ne sont ni des albums de la série « Tintin »,
-- ni des albums de la série « Astérix » ?
SELECT alb.*
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND (ed.pays = 'be' OR ed.pays = 'fr')
  AND (alb.serie <> 'Tintin'
  AND alb.serie <> 'Astérix'
   OR alb.serie IS NULL);

--10
--Quels sont les dessinateurs qui ont été édités par « Dupuis » ? Affichez-les en ordre alphabétique.
SELECT DISTINCT alb.dessinateur
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND ed.nom = 'Dupuis'
  AND alb.dessinateur IS NOT NULL
ORDER BY alb.dessinateur;

--11
--Donnez la liste des albums édités par « Dupuis » entre 1990 et 2000 (bornes incluses),
-- en affichant pour chacun son isbn, son titre, son dessinateur et sa date d’édition.
-- Triez le tout par dessinateur. Pour chaque dessinateur, les albums doivent être rangés en ordre chronologique.
SELECT alb.isbn, alb.titre, alb.dessinateur, alb.date_edition
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND ed.nom = 'Dupuis'
  AND (alb.date_edition > '1990-01-01' AND alb.date_edition < '2000-01-01')
ORDER BY dessinateur, date_edition;

--12
--Chez quels éditeurs (id et nom) y a-t-il des albums pour lesquels aucun auteur n'est fourni ?
SELECT DISTINCT ed.id_editeur, ed.nom
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND (alb.dessinateur IS NULL
  AND alb.scenariste IS NULL
  AND alb.coloriste IS NULL);

--13
--Y a-t-il des albums pour lesquels le nom de l'éditeur est le même que celui de la série ? Donnez, pour ces albums,
-- leur isbn et leur titre.
SELECT alb.isbn, alb.titre
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND ed.nom = alb.serie;

--14
--Donnez le nom des éditeurs qui portent le même nom qu’au moins un auteur.
SELECT DISTINCT ed.nom
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND ed.nom = alb.coloriste
   OR ed.nom = alb.dessinateur
   OR ed.nom = alb.scenariste;

--15
--Quelle est la date d’édition du dernier album édité en octobre 2013 ?
SELECT MAX(date_edition) "date_dernier_album"
FROM bd2.albums
WHERE date_edition > '2013-10-01' AND date_edition < '2013-10-31';

--16
--Combien y a-t-il d'albums édités en Belgique dont le dessinateur et le scénariste sont des personnes différentes ?
SELECT COUNT(alb.*) "nb_albums"
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND alb.dessinateur != alb.scenariste
  AND ed.pays = 'be';

--17
--Quelle est la date d'édition la plus ancienne pour les albums édités chez « Casterman » ?
SELECT MIN(alb.date_edition) "date_plus_ancienne"
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND ed.nom = 'Casterman';

--18
--Quel est le prix moyen des albums édités par des éditeurs français ?
SELECT AVG(alb.prix) "prix_moyen"
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND ed.pays = 'fr';

--19
--Si je n'ai que 5 euros en poche, quelle est la date d'édition de l'album le plus ancien que je puisse acheter ?
SELECT MIN(alb.date_edition) "date_edition_album_plus_ancien"
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND alb.prix <= 5;

--20
--Combien d'albums n'ont ni scénariste, ni dessinateur, ni coloriste mentionné ?
SELECT COUNT(alb.*) "nb_albums"
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND alb.scenariste IS NULL
  AND alb.dessinateur IS NULL
  AND alb.coloriste IS NULL;

--21
--Combien dois-je débourser pour acheter tous les albums dont l’éditeur est belge et coûtant moins de 8 euros ?
-- Et combien d'albums achèterai-je ainsi ? Quel sera leur prix moyen ?
SELECT SUM(alb.prix) "prix_tous_album", COUNT(alb.*) "nb_albums", AVG(alb.prix) "prix_moyen"
FROM bd2.albums alb, bd2.editeurs ed
WHERE ed.id_editeur = alb.editeur
  AND ed.pays = 'be'
  AND alb.prix < 8;

--22
--Combien d'années « Franquin » a-t-il écrit ?
SELECT date_part('year',MAX(date_edition)) - date_part('year',MIN(date_edition)) + 1 "nb_annees"
FROM bd2.albums
WHERE scenariste = 'Franquin';

--23
--Oscar a reçu pour son anniversaire l’album « Le mystère de la grande pyramide » dont l’isbn est 2-87097-008-0.
-- Malheureusement, il l’a déjà. Heureusement il peut l’échanger contre n’importe quel autre album du même prix mais
-- dont le titre est différent. Contre quels albums peut-il l’échanger ?
SELECT *
FROM bd2.albums
WHERE titre <> 'Le mystère de la grande pyramide'
  AND prix = 10;