-- *+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
-- fonction  fonction  fonction  fonction  fonction  fonction  fonction  fonction  fonction  fonction  fonction  fonction  fonction  fonction
-- *+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 1 : 1. Créer une fonction pour calculer le prix total des livres disponibles
-- Écrivez une fonction nommée CalculerPrixTotal qui retourne la somme totale des prix des livres disponibles en fonction de leur quantité.
DELIMITER $$
CREATE FUNCTION CalculerPrixTotal() 
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
    DECLARE prix_total DECIMAL(10,2);
    SELECT SUM(Price * Quantite) INTO prix_total FROM Livres;
    RETURN prix_total;
END$$
DELIMITER;

-- test
SELECT CalculerPrixTotal ();

DROP FUNCTION CalculerPrixTotal;

-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 2 : 2. Créer une fonction pour vérifier la disponibilité d’un livre
-- Écrivez une fonction nommée EstDisponible qui prend un ID_Livre en paramètre et retourne 1 (vrai) si le livre est disponible (quantité > 0) ou 0 (faux) sinon.
DELIMITER $$

CREATE FUNCTION EstDisponible(id_livre INT) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN 
    DECLARE disponible VARCHAR(100);
    SELECT CASE
        WHEN Quantite > 0 THEN 'disponible'
        ELSE 'non disponible'
    END INTO disponible 
    FROM livres
    WHERE id_book = id_livre;
    RETURN disponible ;
END$$
DELIMITER;

-- test
SELECT EstDisponible (1);

DROP FUNCTION EstDisponible;



DELIMITER $$
CREATE FUNCTION random_number() 
RETURNS INT
NOT DETERMINISTIC
BEGIN
    RETURN FLOOR(RAND() * 100);
END$$
DELIMITER ;

drop function random_number;



-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 3 : 3. Créer une fonction pour obtenir le nombre total d'emprunts d'un livre
-- Écrivez une fonction nommée NombreEmprunts qui prend un ID_Livre en paramètre et retourne le nombre d'emprunts pour ce livre.
DELIMITER $$

CREATE FUNCTION NombreEmprunts(id_livre INT) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE nb_emprunts INT ;
    SELECT count(*) INTO nb_emprunts FROM Emprunts WHERE id_book = id_livre ;
    RETURN nb_emprunts;
END$$
DELIMITER;

-- test
SELECT NombreEmprunts (2);

SELECT NombreEmprunts (3);

DROP FUNCTION NombreEmprunts ; 


-- ______________________________________________________________________________________________________________________________________________________________________
--  la suppresion des fonctions :
DROP FUNCTION IF EXISTS Nom_function;





