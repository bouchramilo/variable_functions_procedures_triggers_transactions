-- Active: 1733819346903@@127.0.0.1@3306@revision_db
-- +*+*+*+*+*+*+*+*+*+*=  Les variables  =+*+*+*+*+*+*+*+*+*+*+*+


-- deux types des variables dans mysql : 
-- 1. Variables locales dans un bloc de code (dans des procédures ou des fonctions)
-- Les variables locales sont déclarées à l'intérieur d'un bloc BEGIN...END, comme dans une procédure stockée ou une fonction.

-- exemple 1 :
DELIMITER $$
CREATE PROCEDURE exemple()
BEGIN
    DECLARE compteur INT;
    SET compteur = 0 ;
    SELECT compteur ;
    SET compteur = 5;
    SELECT compteur;
END$$
DELIMITER ;
-- appel
call exemple();

-- drop procedure exemple ;

-- exemple 2 :

DELIMITER $$
CREATE PROCEDURE exempleVariables()
BEGIN
    
    DECLARE total_livres INT;
    DECLARE prix_moyen FLOAT;

    SELECT COUNT(*) INTO total_livres FROM Livres; 
    SELECT AVG(Price) INTO prix_moyen FROM Livres; 

    SELECT CONCAT('Nombre total de livres: ', total_livres) AS Message;
    SELECT CONCAT('Prix moyen des livres: ', prix_moyen) AS Message;
END $$
DELIMITER ;

-- appel 
CALL exempleVariables();

drop PROCEDURE exempleVariables;
-- 2. Variables utilisateur (Session Variables)
-- Les variables utilisateur (précédées par @) sont accessibles dans une session MySQL. Elles sont utilisées en dehors des blocs BEGIN...END et leur portée est limitée à la session en cours.

-- définition et initialisation : 
SET @prix_min = 10;
SELECT * FROM Livres WHERE Price > @prix_min;

-- modification : 
SET @prix_min = 20;
SELECT * FROM Livres WHERE Price > @prix_min;
