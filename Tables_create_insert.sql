-- Active: 1733819346903@@127.0.0.1@3306@revision_db

-- create DB :
create database Revision_DB;
-- show DB existe
show databases;

-- use a database :
use Revision_DB;

-- création des tables :

CREATE TABLE Livres (
    id_book INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Titre_book VARCHAR(100) NOT NULL,
    Price FLOAT,
    Quantite INT,
    auteur VARCHAR(50)
);

CREATE TABLE Emprunts (
    id_emprunt INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    id_book INT NOT NULL,
    Nom_Emprunteur VARCHAR(50),
    Date_Emprunt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_book) REFERENCES Livres (id_book) ON DELETE CASCADE
);

CREATE TABLE Ventes (
    id_vente INT PRIMARY KEY AUTO_INCREMENT,
    id_book INT,
    Quantite_Vendue INT,
    FOREIGN KEY (id_book) REFERENCES Livres (id_book)
);


insert into Ventes (id_book, Quantite_Vendue) values (1, 2);
-- insertion des donnees dans les tables

INSERT INTO Livres (Titre_book, Price, Quantite, auteur)
VALUES ( 'Les Misérables', 20.50, 5, 'Victor Hugo'),
    ( '1984', 15.00, 2, 'George Orwell'),
    ( 'Le Petit Prince', 10.00, 3, 'Antoine de Saint-Exupéry');

INSERT INTO
    Emprunts (id_book, Nom_Emprunteur)
VALUES (1, 'Alice'),
    (2, 'Bob');


-- selection des donnees 
select * from livres;

select * from emprunts;

select * from Ventes ;

-- PROCEDURE pour selectionner les donnees a partir des toutes les tables : 
delimiter $$
create procedure afficherTables()
begin

    select * from livres;

    select * from emprunts;

    select * from Ventes ;

    select * from Historique_Suppressions ;

end $$
delimiter ;

drop procedure afficherTables ;

call afficherTables();

-- suppresion des tables :
DROP table Ventes;

DROP table Emprunts;

drop table Livres;
drop table Historique_Suppressions ;