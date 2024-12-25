
-- Plan pour les transactions :
-- * syntaxe
-- * COMMIT
-- * rollback
-- * AUTOCOMMIT = 0 , 1
-- * ROW_COUNT()
-- * FOUND_ROWS()
-- * savePoint



-- Syntaxe : 
-- _____________________________________________________________________________________________________________________________________________________________________________
START TRANSACTION;  -- Démarre une transaction
-- Ou BEGIN WORK; (optionnel)

-- Une ou plusieurs instructions SQL
UPDATE ...;
INSERT ...;
DELETE ...;

COMMIT;  -- Valider toutes les modifications
-- Ou ROLLBACK;  -- Annuler toutes les modifications
-- __________________________________________________________________________________________________________________________________________________________________________________________

-- * COMMIT + ROLLBACK : ____________________________________________________________________________________________________________________________________________________________________
SET @id = 3 ;
START TRANSACTION;

INSERT INTO Ventes (id_book, Quantite_Vendue) VALUES(@id, 1);

UPDATE Livres SET Quantite = Quantite - 1 WHERE id_book = @id ;

-- COMMIT;
ROLLBACK;

-- ______________________________________________________________________________________________________________________________________________________________________________________

SELECT * FROM ventes;
SELECT * FROM livres;

SELECT * FROM Emprunts ;

DELETE FROM ventes WHERE id_book = 3 ;

DELETE FROM livres WHERE id_book > 5 ;



--set AUTOCOMMIT = 0 : ___________________________________________________________________________________________________________________________________________________________________

-- vérifier l' AUTOCOMMIT si 0 ou 1
SELECT @@AUTOCOMMIT;

-- ___________________________________________________________________________________________________________________________________________________________________
SET AUTOCOMMIT = 0 ;
START TRANSACTION ; 
INSERT INTO livres(Titre_book, auteur, Price, Quantite) VALUES ("the man", "Ernest", 15, 15);
-- ROLLBACK;
COMMIT ;

-- SET AUTOCOMMIT = 1 : ______________________________________________________________________________________________________________________________________________
set AUTOCOMMIT = 1 ;

-- ___________________________________________________________________________________________________________________________________________________________________
-- savepoint : ___________________________________________________________________________________________________________________________________________________________________

START TRANSACTION ;

-- part 1 :
INSERT INTO livres(Titre_book, auteur, Price, Quantite) VALUES ("Book A ", "auteur A ", 10, 50);

savepoint after_parti_1 ;
-- part 2 :
INSERT INTO livres(Titre_book, auteur, Price, Quantite) VALUES ("Book B", "author B", 5, 25);

rollback to after_parti_1 ;
-- part 3 :
INSERT INTO livres(Titre_book, auteur, Price, Quantite) VALUES ("Book C", "author C", 7, 19);
COMMIT ;

SELECT * FROM livres;


-- ROW_COUNT() : ___________________________________________________________________________________________________________________________________________________________________
-- retourne les nombre des lignes trouver : 
UPDATE livres SET Price = Price * 2 WHERE Price = 10 ;

SELECT ROW_COUNT() AS lignes_modifiees;


-- FOUND_ROWS() : ___________________________________________________________________________________________________________________________________________________________________

SELECT * FROM Livres WHERE Price > 20;

SELECT FOUND_ROWS();

-- ___________________________________________________________________________________________________________________________________________________________________
-- exemple de transaction avec les conditions : ___________________________________________________________________________________________________________________________________________________________________

DELIMITER $$
CREATE PROCEDURE EffectuerVente(IN p_id_book INT, IN p_quantite INT)
BEGIN
    DECLARE livre_disponible INT;

    START TRANSACTION ;

    SELECT Quantite INTO livre_disponible FROM livres WHERE id_book = p_id_book ;

    savepoint point1 ;

    IF livre_disponible > p_quantite THEN
        ROLLBACK to point1 ;
    END IF ;

    INSERT INTO Ventes (id_book, Quantite_Vendue) VALUES (p_id_book, p_quantite); 

    UPDATE Livres SET Quantite = Quantite - p_quantite WHERE id_book = p_id_book;

    COMMIT ;
    SELECT 'Vente effectuée avec succès.' AS Message; 
END$$
DELIMITER ;



CALL EffectuerVente(1, 2); 

SELECT * FROM ventes ;
SELECT * FROM livres ;
