CREATE SCHEMA bd3;

CREATE TABLE bd3.editeurs
(id_editeur	INTEGER	 PRIMARY KEY,
 nom		VARCHAR(20) NOT NULL,
 adresse	VARCHAR(30) ,
 pays		CHAR(2));

CREATE TABLE bd3.series(
    id_serie INTEGER PRIMARY KEY,
    nom VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE bd3.albums
(isbn 			CHAR(13) 	PRIMARY KEY,
 titre 			VARCHAR(50) 	NOT NULL,
 serie 			INTEGER REFERENCES bd3.series(id_serie),
 editeur 	    INTEGER  NOT NULL REFERENCES bd3.editeurs(id_editeur),
 date_edition 	DATE,
 prix 			DOUBLE PRECISION NOT NULL);

CREATE TABLE bd3.auteurs
(id_auteur	INTEGER	PRIMARY KEY,
nom		    VARCHAR(20) NOT NULL,
e_mail      VARCHAR(30));

CREATE TABLE bd3.participations
(isbn		CHAR(13) NOT NULL REFERENCES bd3.albums(isbn),
auteur	INTEGER NOT NULL REFERENCES bd3.auteurs(id_auteur),
role	    CHAR(1) NOT NULL CHECK (role IN ('s','d','c')),
PRIMARY KEY  (isbn, auteur,role)
 );