-- *+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
-- +*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+=  Les Déclencheurs (Triggers)  =+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
-- *+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+*+
-- syntaxe : 
CREATE TRIGGER nom_du_trigger
{ BEFORE | AFTER } { INSERT | UPDATE | DELETE }
ON nom_de_la_table
FOR EACH ROW
BEGIN
    -- Instructions SQL à exécuter
END;


-- BEFORE | AFTER :
-- INSERT | UPDATE | DELETE : L'événement qui déclenche le trigger.
-- FOR EACH ROW :
-- NEW.column_name : Représente la nouvelle valeur de la colonne (pour INSERT ou UPDATE).
-- OLD.column_name : Représente l'ancienne valeur de la colonne (pour UPDATE ou DELETE).


-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 1 : 1. trigger qui vérifier si un livre est déjà existant dans la base de données avant l'insertion dans la table Livres : 
DELIMITER $$
CREATE TRIGGER insert_Livre
BEFORE INSERT ON Livres
for each ROW
BEGIN
    DECLARE already_existe INT ;
    SET already_existe = 0 ;

    SELECT count(*) INTO already_existe 
    FROM Livres 
    WHERE Titre_book = NEW.Titre_book AND auteur = NEW.auteur ;

    IF already_existe > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Le livre existe deja';
    END IF ;
end$$
DELIMITER ;

INSERT INTO Livres (Titre_book, auteur, Price, Quantite) 
VALUES ('La Boîte à Merveilles', 'Ahmed Sefrioui', 15.5, 10);

INSERT INTO Livres (Titre_book, auteur, Price, Quantite) 
VALUES ('La Boîte à Merveilles', 'Ahmed Sefrioui', 19.5, 30);

-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 2 : 2. Avant de mettre à jour le prix d'un livre, on vérifie qu'il est supérieur à 0.
DELIMITER $$
CREATE TRIGGER verifier_prix_av_update
BEFORE UPDATE ON Livres
FOR EACH ROW
BEGIN
    IF NEW.Price <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Le prix doit être supérieur à 0';
    END IF;
END$$
DELIMITER ;

-- test :
UPDATE Livres SET Price = 25.0 WHERE Titre_book = '1984';

UPDATE Livres SET Price = 0 WHERE Titre_book = '1984';

select * from Livres ;



-- ______________________________________________________________________________________________________________________________________________________________________
-- Exercice 3 : 3. Trigger AFTER DELETE : Cascade dans une autre table
-- Lorsqu'un livre est supprimé, tous les emprunts associés sont également supprimés.
DELIMITER $$
CREATE TRIGGER supprimer_emprunts_ap_livre
AFTER DELETE ON Livres
FOR EACH ROW
BEGIN
    DELETE FROM Emprunts WHERE id_book = OLD.id_book;
END$$
DELIMITER ;

-- test
DELETE FROM Livres WHERE id_book = 2;

select * from Livres ;
select * from emprunts ;

-- ______________________________________________________________________________________________________________________________________________________________________
-- explication de for each row :

-- creer une tabel Historique_Suppressions : 
CREATE TABLE Historique_Suppressions(
    id_sup INT AUTO_INCREMENT PRIMARY KEY,
    Titre_book varchar(100),
    auteur varchar(100),
    date_suppression DATETIME
);

DROP TABLE Historique_Suppressions;

-- trigger pour stocker les livres supprimés dans la table Historique_Suppressions :
DELIMITER $$
CREATE TRIGGER enregistrement_suppression
AFTER DELETE ON Livres
FOR EACH ROW
BEGIN
    INSERT INTO Historique_Suppressions (Titre_book, auteur, Date_Suppression)
    VALUES (OLD.Titre_book, OLD.auteur, NOW());
END $$
DELIMITER ;

-- test:
DELETE FROM Livres WHERE id_book = 5;
SELECT * FROM Historique_Suppressions ;
SELECT * FROM Livres ;


-- ______________________________________________________________________________________________________________________________________________________________________
-- trigger qui verifier la quantité des livres lors de l'ajout de vente :
DELIMITER $$

CREATE TRIGGER insert_Ventes_Qt
BEFORE INSERT ON Ventes
FOR EACH ROW
BEGIN
    DECLARE quantite_disponible INT;

    -- Vérifier la quantité disponible du livre dans la table Livres
    SELECT Quantite INTO quantite_disponible 
    FROM Livres 
    WHERE id_book = NEW.id_book;

    -- Si le livre n'existe pas ou n'a plus de stock
    IF quantite_disponible IS NULL OR quantite_disponible <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Le stock de ce livre est épuisé ou le livre n existe pas';
    END IF;

    -- Si la quantité demandée dépasse le stock disponible
    IF NEW.Quantite_Vendue > quantite_disponible THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La quantité demandée dépasse la quantité disponible';
    END IF;

    -- Si la quantité demandée est négative
    IF NEW.Quantite_Vendue <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La quantité demandée doit être supérieure à 0';
    END IF;
END$$

DELIMITER ;


INSERT INTO Ventes(id_book, Quantite_Vendue) VALUES(4, 10);

SELECT * FROM Ventes ;

-- ______________________________________________________________________________________________________________________________________________________________________
-- afficher les triggers existe dans la base de donnees 
SHOW TRIGGERS;
-- pour supprimer les triggers : 
DROP TRIGGER IF EXISTS insert_Livre;


