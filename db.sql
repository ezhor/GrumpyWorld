DROP DATABASE GrumpyWorld; -- Borrar línea al terminar los tests

-- Base de datos
CREATE DATABASE GrumpyWorld;
USE GrumpyWorld;

-- Tablas
CREATE TABLE Usuarios(
  ID INT NOT NULL AUTO_INCREMENT,
  Usuario NVARCHAR(30) NOT NULL UNIQUE,
  Contrasena NVARCHAR(255) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE Amigos(
	ID_Usuario1 INT NOT NULL,
    ID_Usuario2 INT NOT NULL,
    CONSTRAINT FK_ID_Usuario1 FOREIGN KEY (ID_Usuario1) REFERENCES Usuarios(ID) ON DELETE CASCADE,
    CONSTRAINT FK_ID_Usuario2 FOREIGN KEY (ID_Usuario2) REFERENCES Usuarios(ID) ON DELETE CASCADE,
    PRIMARY KEY(ID_Usuario1, ID_Usuario2)
);

CREATE TABLE Zonas(
  ID INT NOT NULL AUTO_INCREMENT,
  Nombre NVARCHAR(30) NOT NULL UNIQUE,
  Nivel INT NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE Atributos(
	ID INT NOT NULL AUTO_INCREMENT,
	Fuerza INT NOT NULL DEFAULT 1,
	Constitucion INT NOT NULL DEFAULT 1,
	Destreza INT NOT NULL DEFAULT 1,
    FinEntrenamiento INT NULL DEFAULT 0,
    PRIMARY KEY(ID)
);

CREATE TABLE Rollos(
  ID_Usuario INT,
  ID_Atributos INT NOT NULL,
  ID_Zona INT NOT NULL,
  Nivel INT NOT NULL DEFAULT 0,
  Honor INT NOT NULL DEFAULT 0,
  CONSTRAINT FK_Rollos_Usuario FOREIGN KEY(ID_Usuario) REFERENCES Usuarios(ID) ON DELETE CASCADE,
  CONSTRAINT FK_Rollos_Zona FOREIGN KEY (ID_Zona) REFERENCES Zonas(ID) ON DELETE NO ACTION,
  PRIMARY KEY(ID_Usuario)
);

CREATE TABLE Duelos(
	ID_Rollo INT NOT NULL,
    ID_RolloEnemigo INT NOT NULL,
    Vida TINYINT NOT NULL DEFAULT 100,
    Turno TINYINT NULL,
    Ataque TINYINT NULL,
    Momento INT NULL,
    CONSTRAINT FK_Duelos_ID_Rollo FOREIGN KEY (ID_Rollo) REFERENCES Rollos(ID_Usuario) ON DELETE CASCADE,
    CONSTRAINT FK_Duelos_RolloEnemigo FOREIGN KEY (ID_RolloEnemigo) REFERENCES Rollos(ID_Usuario) ON DELETE CASCADE
);

CREATE TABLE Equipables(
  ID INT NOT NULL AUTO_INCREMENT,
  Nombre NVARCHAR(30) NOT NULL UNIQUE,
  Tipo CHAR(1),
  Bonus INT NOT NULL,
  DestrezaNecesaria INT NOT NULL,
  NivelNecesario INT NOT NULL,
  PRIMARY KEY(ID),
  CHECK (Tipo='S' OR Tipo='A')
);

CREATE TABLE Rollos_Equipables(
  ID_Rollo INT NOT NULL,
  ID_Equipable INT NOT NULL,
  Equipada CHAR(1) NOT NULL DEFAULT 'N',
  CONSTRAINT FK_Rollos_Equipables_ID_Rollo FOREIGN KEY (ID_Rollo) REFERENCES Rollos(ID_Usuario) ON DELETE CASCADE,
  CONSTRAINT FK_Rollos_Equipables_ID_Equipable FOREIGN KEY (ID_Equipable) REFERENCES Equipables(ID) ON DELETE CASCADE,
  PRIMARY KEY(ID_Rollo, ID_Equipable),
  CHECK (Equipada='S' OR Tipo='N')
);

CREATE TABLE Materiales(
  ID INT NOT NULL AUTO_INCREMENT,
  Nombre NVARCHAR(30) NOT NULL UNIQUE,
  PRIMARY KEY(ID)
);

CREATE TABLE Materiales_Materiales(
	ID_Material INT NOT NULL,
    ID_Submaterial INT NOT NULL,
    Cantidad INT NOT NULL,
    CONSTRAINT FK_Materiales_Materiales_Material FOREIGN KEY (ID_Material) REFERENCES Materiales(ID) ON DELETE CASCADE,
    CONSTRAINT FK_Materiales_Materiales_Submaterial FOREIGN KEY (ID_Submaterial) REFERENCES Materiales(ID) ON DELETE CASCADE,
    PRIMARY KEY (ID_Material, ID_Submaterial)
);

CREATE TABLE Rollos_Materiales(
	ID_Rollo INT NOT NULL,
    ID_Material INT NOT NULL,
    Cantidad INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Rollos_Materiales_ID_Rollo FOREIGN KEY (ID_Rollo) REFERENCES Rollos(ID_Usuario) ON DELETE CASCADE,
	CONSTRAINT FK_Rollos_Materiales_ID_Material FOREIGN KEY (ID_Material) REFERENCES Materiales(ID) ON DELETE CASCADE,
    PRIMARY KEY (ID_Rollo, ID_Material)
);

CREATE TABLE Equipables_Materiales(
	ID_Equipable INT NOT NULL,
    ID_Material INT NOT NULL,
    Cantidad INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_Equipables_Materiales_ID_Equipable FOREIGN KEY (ID_Equipable) REFERENCES Equipables(ID) ON DELETE CASCADE,
	CONSTRAINT FK_Equipables_Materiales_ID_Material FOREIGN KEY (ID_Material) REFERENCES Materiales(ID) ON DELETE CASCADE,
    PRIMARY KEY (ID_Equipable, ID_Material)
);

CREATE TABLE Enemigos(
  ID INT NOT NULL AUTO_INCREMENT,
  Nombre NVARCHAR(30) NOT NULL UNIQUE,
  Fuerza INT NOT NULL,
  Constitucion INT NOT NULL,
  Destreza INT NOT NULL,
  ID_Zona INT NOT NULL,
  EsJefe BIT(1) NOT NULL,
  CONSTRAINT FK_Enemigos_Zona FOREIGN KEY (ID_Zona) REFERENCES Zonas(ID) ON DELETE NO ACTION,
  PRIMARY KEY(ID)
);

CREATE TABLE Vencidos(
	ID_Rollo INT NOT NULL,
    ID_Enemigo INT NOT NULL,
    CONSTRAINT FK_Vencidos_Rollo FOREIGN KEY (ID_Rollo) REFERENCES Rollos(ID_Usuario) ON DELETE CASCADE,
    CONSTRAINT FK_Vencidos_Enemigo FOREIGN KEY (ID_Enemigo) REFERENCES Enemigos(ID) ON DELETE CASCADE
);

CREATE TABLE Caza(
	ID_Rollo INT NOT NULL,
    ID_Enemigo INT NOT NULL,
    VidaRollo TINYINT NOT NULL DEFAULT 100,
    VidaEnemigo TINYINT NOT NULL DEFAULT 100,
    AtaqueRollo TINYINT NULL,
    AtaqueEnemigos TINYINT NULL,
    CONSTRAINT FK_Rollos_Enemigos_Rollo FOREIGN KEY (ID_Rollo) REFERENCES Rollos(ID_Usuario) ON DELETE CASCADE,
    CONSTRAINT FK_Rollos_Enemigos_Enemigo FOREIGN KEY (ID_Enemigo) REFERENCES Enemigos(ID) ON DELETE CASCADE
);



-- Funciones y procedimientos
DELIMITER $$
CREATE FUNCTION existeUsuario(nombre_usuario NVARCHAR(30))
RETURNS BIT
BEGIN
  /*DECLARE existe BIT;
  SET existe = FALSE;
    IF((SELECT COUNT(*) FROM Usuarios WHERE Usuario = nombre_usuario)>0) THEN
    BEGIN
		SET existe = TRUE;
    END;
    END IF;*/
	RETURN (SELECT COUNT(*) FROM Usuarios WHERE Usuario = nombre_usuario)>0;
END $$

CREATE PROCEDURE crearUsuario(IN usuario NVARCHAR(30), IN contrasena NVARCHAR(255), OUT conseguido BIT)
BEGIN
    INSERT INTO Usuarios (Usuario, Contrasena) VALUE (usuario, contrasena);
    IF(ROW_COUNT()>0) THEN
    BEGIN
		SET @ID_Usuario = LAST_INSERT_ID();
        INSERT INTO Atributos () VALUES ();
        SET @ID_Atributo = LAST_INSERT_ID();
		INSERT INTO Rollos(ID_Usuario, ID_Atributos, ID_Zona) SELECT @ID_Usuario, @ID_Atributo, ID FROM Zonas WHERE Nombre='bano';
        
        SELECT 1 INTO conseguido;
    END;
    END IF;
    
END $$

CREATE PROCEDURE entrenar(IN usuario NVARCHAR(30), IN atributo VARCHAR(15))
BEGIN
	IF (atributo = 'fuerza') THEN
		BEGIN
			UPDATE Atributos
				INNER JOIN Rollos
				ON Atributos.ID = Rollos.ID_Atributos
				INNER JOIN Usuarios
				ON Rollos.ID_Usuario = Usuarios.ID
			SET Atributos.FinEntrenamiento = UNIX_TIMESTAMP()+((Atributos.Fuerza)*(Atributos.Fuerza)),
				Atributos.Fuerza = Atributos.Fuerza+1
			WHERE Usuarios.Usuario = usuario;
				
        END;
        ELSE IF (atributo = 'constitucion') THEN
			BEGIN
				UPDATE Atributos
					INNER JOIN Rollos
					ON Atributos.ID = Rollos.ID_Atributos
					INNER JOIN Usuarios
					ON Rollos.ID_Usuario = Usuarios.ID
				SET Atributos.FinEntrenamiento = UNIX_TIMESTAMP()+((Atributos.Constitucion)*(Atributos.Constitucion)),
					Atributos.Constitucion = Atributos.Constitucion+1
				WHERE Usuarios.Usuario = usuario;
					
			END;
            ELSE IF (atributo = 'destreza') THEN
				BEGIN
					UPDATE Atributos
						INNER JOIN Rollos
						ON Atributos.ID = Rollos.ID_Atributos
						INNER JOIN Usuarios
						ON Rollos.ID_Usuario = Usuarios.ID
					SET Atributos.FinEntrenamiento = UNIX_TIMESTAMP()+((Atributos.Destreza)*(Atributos.Destreza)),
						Atributos.Destreza = Atributos.Destreza+1
				WHERE Usuarios.Usuario = usuario;
						
				END;
				END IF;
			END IF;
        END IF;
END $$

DELIMITER ;

-- Datos iniciales

-- Zonas
INSERT INTO Zonas (Nombre, Nivel) VALUES
	('bano', 1),
	('cocina', 2),
    ('oficina', 3),
    ('parque', 4),
    ('cementerio', 5),
    ('infierno', 6);

-- Enemigos
INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'stripper', 10, 20, 30, 0, ID FROM Zonas WHERE Nombre = 'bano';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'cepillo', 10, 30, 20, 0, ID FROM Zonas WHERE Nombre = 'bano';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'cuchilla', 30, 20, 10, 0, ID FROM Zonas WHERE Nombre = 'bano';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'champu', 20, 10, 30, 0, ID FROM Zonas WHERE Nombre = 'bano';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'vater', 30, 50, 20, 1, ID FROM Zonas WHERE Nombre = 'bano';


INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'leche', 60, 80, 70, 0, ID FROM Zonas WHERE Nombre = 'cocina';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'zanahoria', 80, 60, 70, 0, ID FROM Zonas WHERE Nombre = 'cocina';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'cuchara', 70, 80, 60, 0, ID FROM Zonas WHERE Nombre = 'cocina';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'limon', 70, 60, 80, 0, ID FROM Zonas WHERE Nombre = 'cocina';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'calabaza', 80, 100, 70, 1, ID FROM Zonas WHERE Nombre = 'cocina';


INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'raton', 120, 110, 130, 0, ID FROM Zonas WHERE Nombre = 'oficina';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'grapadora', 130, 120, 110, 0, ID FROM Zonas WHERE Nombre = 'oficina';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'lapiz', 130, 110, 120, 0, ID FROM Zonas WHERE Nombre = 'oficina';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'libro', 110, 130, 120, 0, ID FROM Zonas WHERE Nombre = 'oficina';

INSERT INTO Enemigos (Nombre, Fuerza, Constitucion, Destreza, EsJefe, ID_Zona)
	SELECT 'pendrive', 110, 150, 120, 1, ID FROM Zonas WHERE Nombre = 'oficina';


-- Usuario de prueba
CALL crearUsuario('dani', '$2y$10$8hnEpmUyg8WKrAU9U.tV.e75hFxq9SZRbRc8gmFTU5RThuWDF9Luy', @conseguido);
SELECT * FROM Atributos;