--1
--Ecrivez une requête SQL qui permette d'afficher tout le contenu de votre table bd1.albums.
--Vous trouverez le contenu complet de cette table dans l’annexe 2.
SELECT * FROM bd1.albums;

--2
--Donnez, pour chaque album, son isbn, son titre, son scénariste,
--son dessinateur ainsi que sa date d'édition.
SELECT isbn,titre,scenariste,dessinateur,date_edition
FROM bd1.albums;

--3
--Quels sont les albums édités par "Dupuis" ?
SELECT * FROM bd1.albums
WHERE editeur = 'Dupuis';

--4
--Quels sont les différents titres des albums dont le scénariste est "Sente" ?
SELECT DISTINCT titre
FROM bd1.albums
WHERE scenariste = 'Sente';

--5
--Quels sont les différents titres et éditeurs des albums dont un des auteurs s'appelle "Uderzo" ?
SELECT DISTINCT titre, editeur
FROM bd1.albums
WHERE scenariste = 'Uderzo'
OR dessinateur = 'Uderzo'
OR coloriste = 'Uderzo';

--6
--Quels sont les albums pour lesquels le coloriste n'a pas été spécifié ?
SELECT *
FROM bd1.albums
WHERE coloriste IS NULL;

--7
--Quels sont les éditeurs qui ont édité des albums en 1977 ?
SELECT DISTINCT editeur
FROM bd1.albums
WHERE (date_edition > '1976-12-31' AND date_edition < '1978-01-01');

--8
--Quels sont les couples scénaristes-dessinateurs ayant travaillé ensemble pour l'éditeur "Dargaud" ?
--(Attention : si le nom du dessinateur est le même que celui du scénariste,
-- c'est que la même personne a effectué les deux tâches, et on ne parlera donc pas de "couple".)
SELECT DISTINCT scenariste, dessinateur
FROM bd1.albums
WHERE editeur = 'Dargaud'
  AND scenariste != dessinateur;

--9
--Quels sont les albums dont le scénariste et le dessinateur sont la même personne,
-- mais qui ont été mis en couleur par quelqu'un d'autre ?
SELECT *
FROM bd1.albums
WHERE scenariste = dessinateur
  AND coloriste <> scenariste
  AND coloriste <> dessinateur;

--10
--Quels sont les albums dont le scénariste, le dessinateur et le coloriste sont la même personne ?
SELECT *
FROM bd1.albums
WHERE scenariste = dessinateur
  AND scenariste = coloriste;

--11
--Quels sont les albums qui n'ont qu'un seul auteur ? (Cela recouvre les cas de l'exercice précédent,
-- mais il ne faut pas oublier les tuples pour lesquels un ou deux des trois attributs concernés ont la valeur NULL !)
SELECT DISTINCT *
FROM bd1.albums
WHERE (scenariste IS NULL AND dessinateur IS NULL AND coloriste IS NOT NULL)
   OR (dessinateur IS NULL AND coloriste IS NULL AND scenariste IS NOT NULL)
   OR (scenariste IS NULL AND coloriste IS NULL AND dessinateur IS NOT NULL)
   OR (scenariste = dessinateur AND scenariste = coloriste)
   OR (scenariste = dessinateur AND coloriste IS NULL)
   OR (dessinateur = coloriste AND scenariste IS NULL)
   OR (scenariste = coloriste AND dessinateur IS NULL);

--12
--Quels sont les scénaristes dont on a édité, en 1980 ou après, des œuvres qui coûtent moins de 12 € ?
SELECT DISTINCT scenariste
FROM bd1.albums
WHERE (date_edition > '1980-12-31')
AND (prix < 12);

--13
--Quels sont les ISBN et les titres des albums édités en dehors de la décennie 1990-1999,
-- par un éditeur autre que "Casterman ", et dont le coloriste est ou bien non spécifié
-- ou bien le même que le dessinateur ?
SELECT isbn, titre
FROM bd1.albums
WHERE (date_edition < '1990-01-01' OR date_edition > '1999-12-31')
  AND (editeur != 'Casterman')
  AND (coloriste IS NULL OR coloriste = dessinateur);

--14
--Quels sont les différents titres qui n'ont été édités ni par "Casterman", ni par "Dupuis", et qui ont,
-- comme scénariste, dessinateur et coloriste, trois auteurs distincts ?
SELECT DISTINCT titre
FROM bd1.albums
WHERE (editeur != 'Casterman' AND editeur != 'Dupuis')
  AND (scenariste != coloriste AND coloriste != dessinateur AND scenariste != dessinateur);

--15
-- Quels sont tous les albums qui rentrent dans une des catégories suivantes au moins :
-- ▪ albums de la série "Lucky Luke" édités chez "Dargaud",
-- ▪ albums de la série "Astérix" édités chez "Albert René" ou au "Le Lombard"
-- ▪ albums sans aucun auteur spécifié.

SELECT *
FROM bd1.albums
WHERE serie = 'Lucky Luke' AND editeur = 'Dargaud'
   OR (serie = 'Astérix' AND (editeur = 'Albert René' OR editeur = 'Le Lombard'))
   OR (scenariste IS NULL AND dessinateur IS NULL AND coloriste IS NULL);

--16
--Quelles sont les différents titres et prix des albums édités en France dont soit le dessinateur est inconnu,
-- soit le coloriste est inconnu, soit les deux sont inconnus ?
SELECT DISTINCT titre, prix
FROM bd1.albums
WHERE (pays_edition = 'fr')
  AND (dessinateur IS NULL
   OR coloriste IS NULL
   OR (dessinateur IS NULL AND coloriste IS NULL AND scenariste IS NOT NULL));

--17
-- Donnez l’ISBN, le titre et la date d’édition des albums de la série "Astérix" dans l’ordre chronologique
-- (cf. date d'édition).
SELECT isbn,titre,date_edition
FROM bd1.albums
WHERE serie = 'Astérix'
ORDER BY date_edition;

--18
--Donnez les différents titres des albums de la série "Astérix", en ordre alphabétique des titres.
SELECT titre
FROM bd1.albums
WHERE serie = 'Astérix'
ORDER BY LOWER(titre);

--19
--Donnez les albums (isbn, titre, nom d’éditeur et date d'édition) en les classant par éditeur,
-- et pour chaque éditeur, par date d'édition.
SELECT DISTINCT isbn, titre, editeur, date_edition
FROM bd1.albums
ORDER BY editeur, date_edition;

--20
--Donnez l’ISBN, le titre et les prix des albums édités par "Dupuis", par ordre décroissant de prix.
SELECT DISTINCT isbn, titre, prix
FROM bd1.albums
WHERE editeur = 'Dupuis'
ORDER BY prix DESC;