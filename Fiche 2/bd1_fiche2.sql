--21
--Quelle est la plus ancienne date d'édition de la table bd1.albums ?
SELECT MIN(date_edition)
FROM bd1.albums ;

--22
--Quel est le prix de l’album le plus cher parmi ceux qui ont été dessinés par un autre dessinateur qu'"Uderzo" ?
SELECT MAX(prix)
FROM bd1.albums
WHERE dessinateur != 'Uderzo';

--23
--Combien y a-t-il d’albums édités chez "Casterman" ?
SELECT COUNT(editeur)
FROM bd1.albums
WHERE editeur = 'Casterman';

--24
--Quels est le prix moyen des albums édités par " Blake et Mortimer " entre 1990 et 1999
-- (y compris ces deux années extrêmes) ?
SELECT AVG(prix)
FROM bd1.albums
WHERE (date_edition > '1989-12-31'
AND date_edition < '2000-01-01')
AND (editeur = 'Blake et Mortimer');

--25
--Combien devrais-je payer si je veux acheter un exemplaire de chaque album de la série « Spirou » ?
SELECT SUM(prix)
FROM bd1.albums
WHERE (serie = 'Spirou') ;

--26
--Listez les différents titres des albums qui contiennent le mot "mystère".
SELECT DISTINCT titre
FROM bd1.albums
WHERE titre LIKE '%mystère%';

--27
--Combien devrai-je payer si j’achète 3 exemplaires de chacun des albums édités par "Blake et Mortimer" et si le
-- libraire m’accorde une réduction de 25% ?
SELECT 3*SUM(prix)*0.75
FROM bd1.albums
WHERE editeur = 'Blake et Mortimer';

--28
--Combien d’années séparent l’album le plus ancien de l’album le plus récent ?
SELECT date_part('year',MAX(date_edition)) - date_part('year',MIN(date_edition))
FROM bd1.albums;

--29
--Quels sont les éditeurs dont le nom est composé d’au moins deux mots séparés par un espace ?
SELECT DISTINCT editeur
FROM bd1.albums
WHERE editeur LIKE '_% %_';

--30
--Listez les scénaristes des albums, de la série "Astérix" ou "Blake et Mortimer", édités en 2000 ou après.
-- Classez-les par ordre alphabétique.
SELECT DISTINCT scenariste
FROM bd1.albums
WHERE (serie = 'Astérix' OR serie = 'Blake et Mortimer')
AND date_edition > '1999-12-31'
AND scenariste IS NOT NULL;

--31 /!\ PARTICULARITE
--Combien y a-t-il de séries différentes dans la table bd1.albums ?
SELECT COUNT(DISTINCT serie)
FROM bd1.albums;

--32
--Combien y a-t-il d’albums pour lesquels la série est spécifiée ? Peut-on répondre à cette question par un query sans
-- clause WHERE ?
SELECT COUNT(serie)
FROM bd1.albums;

--33
--Combien y a-t-il d’albums pour lesquels la série n’est pas spécifiée ? Peut-on répondre à cette question par un query
-- sans clause WHERE ?

SELECT DISTINCT COUNT(*)-COUNT(serie)
FROM bd1.albums;

--34
--Donnez tous les albums dont l’ISBN commence par 2 et se termine par X (peu importe la casse).
SELECT *
FROM bd1.albums
WHERE LOWER(isbn) LIKE '2%x';

--35
--Chez combien d’éditeurs a-ton publié des albums de la série « Astérix » ?
SELECT COUNT(DISTINCT editeur)
FROM bd1.albums
WHERE serie = 'Astérix';

--36
--Listez les coloristes dont le nom commence par le mot "de" (peu importe la casse).
SELECT DISTINCT coloriste
FROM bd1.albums
WHERE LOWER(coloriste) LIKE 'de%';

--37
--Combien y a-t-il d'albums dont un des auteurs au moins s'appelle "Uderzo", et quelles sont les dates d'édition du
-- plus ancien et du plus récent d'entre eux ?
SELECT COUNT(*), MIN(date_edition), MAX(date_edition)
FROM bd1.albums
WHERE scenariste = 'Uderzo'
   OR dessinateur = 'Uderzo'
   OR coloriste = 'Uderzo';

--38
--Quel est le prix moyen des albums édités par "Dupuis" à l’exception des albums édités entre 1990 et 1999,
-- bornes comprises.
SELECT AVG(prix)
FROM bd1.albums
WHERE editeur = 'Dupuis'
  AND (date_edition < '1990-01-01' OR date_edition > '1999-12-31');

--39
--Donnez la liste des albums dont l’ISBN contient « 00 ». Classez-les par ordre décroissant de prix. Pour les albums de
-- même prix, classez-les par éditeur.
SELECT *
FROM bd1.albums
WHERE isbn LIKE '%00%'
ORDER BY prix DESC, editeur;

--40
--Quels sont les éditeurs d’albums qui sont soit édités en Belgique, soit dont le pays d’édition n’est pas spécifié,
-- et qui sont parus entre 2010 et 2020 inclus ?
SELECT DISTINCT editeur
FROM bd1.albums
WHERE (pays_edition = 'be' OR pays_edition IS NULL)
  AND (date_edition > '2010-01-01' AND date_edition <'2020-12-31');

--41
--Donnez l’ISBN, le titre, la série et la date d’édition de tous les albums édités entre 1980 et 1990 (bornes comprises).
-- Les albums d’une même série doivent se suivre et, pour une même série,
-- les albums doivent être classés du plus récent au plus ancien.
SELECT isbn, titre, serie, date_edition
FROM bd1.albums
WHERE (date_edition > '1980-01-01' AND date_edition <'1990-12-31')
ORDER BY serie, date_edition DESC ;

--42
--Si je veux acheter un exemplaire de tous les albums dont le scénariste est "Goscinny" et/ou le dessinateur "Uderzo",
-- combien devrais-je débourser ?
SELECT SUM(prix)
FROM bd1.albums
WHERE scenariste = 'Goscinny'
   OR dessinateur = 'Uderzo';

--43
--Si je veux acheter un exemplaire de tous les albums dont le scénariste n’est ni "Goscinny" ni "Uderzo",
-- combien devrais-je débourser ?
SELECT SUM(prix)
FROM bd1.albums
WHERE scenariste != 'Goscinny'
   AND scenariste != 'Uderzo';

--44
--Donnez l’ISBN, le titre, le scénariste et la série des albums dont le nom de la série apparaît dans le titre
-- (peu importe la casse du titre ou de la série).
SELECT isbn, titre, scenariste, serie
FROM bd1.albums
WHERE titre LIKE '%'||serie||'%';