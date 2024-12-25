-- *+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
-- PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs PROCEDUREs :
-- *+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 1 : 1. Créer une procédure pour ajouter un nouveau livre

DELIMITER $$

CREATE PROCEDURE ajouterLivre(IN Title VARCHAR(100) , IN auteur VARCHAR(100), IN prix float , IN quantite INT )
BEGIN 
    INSERT INTO Livres(Titre_book, auteur, price, Quantite) VALUES(Title, auteur, prix, quantite);
END$$

DELIMITER;

-- test
CALL ajouterLivre ("test", "Ayman Al-Atoum", 10.5, 10);

-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 2 : 2. Créer une procédure pour enregistrer un emprunt
DELIMITER $$

CREATE PROCEDURE ajouterEmprunt(IN id_livre INT, IN nom_emprunteur VARCHAR(50))
BEGIN
    DECLARE Qt_disponible INT ;
    SELECT Quantite INTO Qt_disponible FROM Livres WHERE id_book = id_livre ;
    IF Qt_disponible > 0 THEN
        INSERT INTO Emprunts(id_book, Nom_Emprunteur) VALUES(id_livre, nom_emprunteur);
        UPDATE Livres SET Quantite = Qt_disponible - 1 WHERE id_book = id_livre ;
    ELSE 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuffisant pour cet emprunt.';
    END IF ;
END$$

DELIMITER;

-- test
CALL ajouterEmprunt (2, 'Adam');

-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 3 : 3. Créer une procédure pour supprimer un livre
DELIMITER $$

CREATE PROCEDURE supprimerLivre(IN id_livre INT)
BEGIN 
    DELETE FROM Livres WHERE id_book = id_livre ;
END$$

DELIMITER;

-- test
CALL supprimerLivre (4);

-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 4 : 4. Créer une procédure qui prend un seuil en entrée (IN) et retourne (OUT) le nombre total de livres dont la quantité est supérieure au seuil.
DELIMITER $$

CREATE PROCEDURE CalculerStockTotal(IN seuil INT, OUT total INT)
BEGIN
    SELECT 
        sum(Quantite) INTO total
    FROM 
        Livres 
    WHERE 
        Quantite > seuil ;
END$$

DELIMITER;

-- test
@total_stock;

CALL CalculerStockTotal (10, @total_stock);

SELECT @total_stock AS TotalStock;

-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 5 : 5. Créer une procédure qui prend en entrée Le titre d'un livre (IN). Elle retourne (OUT) la quantité disponible du livre.

DELIMITER $$

CREATE PROCEDURE VerifierDisponibilite(IN title VARCHAR(100), OUT QT_livre INT)
BEGIN
    SELECT Quantite INTO QT_livre FROM Livres WHERE Titre_book = title;
END$$

DELIMITER;

-- test
CALL VerifierDisponibilite ('Les Misérables', @quantite);

SELECT @quantite AS QuantiteDisponible;

-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 6 : 6. Créer une procédure qui prend le titre d’un livre (IN) et le nouveau prix (IN).
-- Retourne un message (OUT) INdiquant si la mise à jour a réussi ou si le livre n'existe pas.
DELIMITER $$

CREATE PROCEDURE MettreAJourPrix(
    IN title VARCHAR(100),
    IN new_Price FLOAT,
    OUT message VARCHAR(100)
)
BEGIN
    DECLARE livre_existe INT;
    SELECT count(*) INTO livre_existe
    FROM Livres 
    WHERE Titre_book = title ;
    IF livre_existe > 0 THEN
        UPDATE Livres 
        SET price = new_Price
        WHERE Titre_book = title;
        SET message = 'Price mis a jour avec succès.';
    ELSE    
        SET message = 'Le livre n existe pas ';
        END IF ;
END$$

DELIMITER;

-- test
CALL MettreAJourPrix ('1984', 20.50, @msg);

SELECT @msg AS Message;

-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 7 : 7. Créer une procédure qui prend le nom d’un auteur (IN).
-- Retourne la valeur totale des livres de cet auteur (OUT).
DELIMITER $$

CREATE PROCEDURE ValeurStockAuteur(IN auteurNom VARCHAR(100), OUT valeur_stock DECIMAL(10,2))
BEGIN
    SELECT SUM(Price * Quantite) INTO valeur_stock
    FROM Livres
    WHERE auteur = auteurNom;
END$$

DELIMITER;

-- test
CALL ValeurStockAuteur ('Victor Hugo', @valeur);

SELECT @valeur AS ValeurStock;

-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 8 : 8. Créer une procédure qui prend le titre (IN), l’auteur (IN), le prix (IN), et la quantité (INOUT).
-- Si le livre existe déjà, elle met à jour le prix et ajoute à la quantité existante.
-- sinon, elle insère un nouveau livre.

DELIMITER $$

CREATE PROCEDURE AjouterOuMettreAJourLivre(
    IN titreLivre VARCHAR(100),
    IN auteurNom VARCHAR(100),
    IN nouveauPrix DECIMAL(10,2),
    INOUT quantiteLivre INT
)
BEGIN

    DECLARE livre_existe INT;

    SELECT COUNT(*) INTO livre_existe FROM Livres 
    WHERE Titre_book = titreLivre;

    IF livre_existe > 0 THEN
        UPDATE Livres SET Price = nouveauPrix, Quantite = Quantite + quantiteLivre
        WHERE Titre_book = titreLivre;
    ELSE
        INSERT INTO Livres (Titre_book, auteur, Price, Quantite)
        VALUES (titreLivre, auteurNom, nouveauPrix, quantiteLivre);
    END IF;

END$$

DELIMITER;

-- test
SET @quantite = 5;

CALL AjouterOuMettreAJourLivre ('Candide', 'Voltaire', 18.00, @quantite);

SELECT * FROM Livres;


-- ______________________________________________________________________________________________________________________________________________________________________
-- suppression des procedures : 
DROP PROCEDURE IF EXISTS ValeurStockAuteur;