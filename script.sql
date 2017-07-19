/*
DROP DATABASE IF EXISTS ADBD5;

CREATE DATABASE adbd5;

USE adbd5;
*/

DROP TABLE if exists Persona;
DROP TABLE if exists Animal;
DROP TABLE if exists Tenencia;
DROP TABLE if exists Incidente;
DROP TABLE if exists Licencia;
DROP TABLE if exists Censado
DROP TABLE if exists NoCensado;


/*creacion de las tablas*/

CREATE TABLE Persona ( nif_cif CHAR(9) NOT NULL,
 nombre CHAR(20),
 apellidos CHAR(30),
 direccion CHAR(100),
 nacimiento DATE,
 PRIMARY KEY(nif_cif));

ALTER TABLE Persona ADD CONSTRAINT fechaP CHECK (0>=CURRENT_DATE-nacimiento);

CREATE TABLE Animal(id INT NOT NULL,
 pasaporte INT,
 peligroso BOOLEAN,
 chip CHAR(20),
 explotacion BOOLEAN,
 abandonado BOOLEAN,
 PRIMARY KEY(id));

CREATE TABLE Tenencia(fecha_propiedad DATE NOT NULL,
 fecha_fin DATE,
 nif_cif CHAR(9),
 id INT,
 PRIMARY KEY (fecha_propiedad,nif_cif,id),
 FOREIGN KEY(nif_cif) REFERENCES Persona(nif_cif),
 FOREIGN KEY (id) REFERENCES Animal(id));

ALTER TABLE Animal ADD CONSTRAINT fechaT CHECK (0>=CURRENT_DATE-fecha_propiedad);
ALTER TABLE Animal ADD CONSTRAINT fechaT2 CHECK (0>=CURRENT_DATE-fecha_fin);

CREATE TABLE Incidente(id_acto INT NOT NULL,
 tipo_infraccion INT,
 fecha_acto DATE,
 fecha_propiedad DATE,
 id INT, nif_cif CHAR(9),
 PRIMARY KEY(id_acto),
 FOREIGN KEY (fecha_propiedad) REFERENCES Tenencia(fecha_propiedad),
 FOREIGN KEY(id) REFERENCES Tenencia(id),
 FOREIGN KEY (nif_cif) REFERENCES Tenencia(nif_cif));

ALTER TABLE Animal ADD CONSTRAINT fechaI CHECK (0>=CURRENT_DATE-fecha_acto);

CREATE TABLE Licencia (numero_licencia INT NOT NULL,
 fecha_expedicion DATE,
 tipo INT,
 direccion_local CHAR(100),
 nif_cif CHAR(9),
 PRIMARY KEY(numero_licencia),
 FOREIGN KEY (nif_cif) REFERENCES Persona(nif_cif));

ALTER TABLE Licencia ADD CONSTRAINT menor CHECK (18*365<CURRENT_DATE-(SELECT P.edad FROM Persona P, Licencia L WHERE P.nif_cif=L.nif_cif));

ALTER TABLE Animal ADD CONSTRAINT fechaL CHECK (0>=CURRENT_DATE-fecha_expedicion);

ALTER TABLE Licencia ADD CONSTRAINT tipo2 CHECK (tipo=1 OR (tipo=2 AND direccion_local IS NOT NULL));

CREATE TABLE Censado(id INT,
 id_censo INT,
 especie CHAR (20),
 raza CHAR (20),
 aptitud CHAR(20),
 capa CHAR(20),
 nacimiento DATE,
 domicilio_animal CHAR(30),
 PRIMARY KEY (id),
 FOREIGN KEY (id) REFERENCES Animal(id));

ALTER TABLE Animal ADD CONSTRAINT fechaC CHECK (0>=CURRENT_DATE-nacimiento);

ALTER TABLE Animal ADD CONSTRAINT especie CHECK (especie = 'gato' OR especie = 'perro');

CREATE TABLE NoCensado(id INT,
 tipo_animal CHAR(20),
 extranjero BOOL,
 certificado INT,
 cites INT,
 PRIMARY KEY (id),
 FOREIGN KEY (id) REFERENCES Animal(id));

ALTER TABLE NoCensado ADD CONSTRAINT certificadoCites CHECK ((extranjero=TRUE AND certificado IS NOT NULL AND cites IS NOT NULL) OR extranjero=FALSE);

ALTER TABLE Animal ADD CONSTRAINT licenciaPeligroso CHECK (1=(SELECT L.tipo FROM Licencia L WHERE L.nif_cif IN (SELECT T.nif_cif FROM Tenencia T WHERE T.id IN(SELECT A.id FROM Animal A WHERE A.peligroso=TRUE))));


/*insert en tablas*/

INSERT INTO Persona (nif_cif,nombre, apellidos, direccion,nacimiento) values ( '91662548G' , 'Raquel' , 'Iglesias' , 'Alamillo Alto' , '1971-12-2');
INSERT INTO Persona (nif_cif,nombre, apellidos, direccion,nacimiento) values ( '37230022Z' , 'Miguel' , 'Garcia  ' , 'Alamillo Bajo' , '1985-7-14' );
INSERT INTO Persona (nif_cif,nombre, apellidos, direccion,nacimiento) values ( '28810410N' , 'Jesus' , 'Soler ' , 'Alarcos' , '1980-5-26');
INSERT INTO Persona (nif_cif,nombre, apellidos, direccion,nacimiento) values ( '72671602C' , 'Angel' , 'Puerto ' , 'Alarcos' , '1995-9-5' );
INSERT INTO Persona (nif_cif,nombre, apellidos, direccion,nacimiento) values ( '17526773Z' , 'Maria Pilar' , 'Serra' , 'Alcantara' , '1972-11-13' );
INSERT INTO Persona (nif_cif,nombre, apellidos, direccion,nacimiento) values ( '62007899Z' , 'Joaquin' , 'Lopez' , 'Altagracia' , '1982-7-20 ' );
INSERT INTO Persona (nif_cif,nombre, apellidos, direccion,nacimiento) values ( '87769805B' , 'Adrian' , 'Gonzalez' , 'Av. Alfonso X El Sabio' , '1974-7-20' );
INSERT INTO Persona (nif_cif,nombre, apellidos, direccion,nacimiento) values ( '59577567T' , 'Elena' , 'Esteban' , ' Av. de La Mancha' , '1999-9-25' );
INSERT INTO Persona (nif_cif,nombre, apellidos, direccion,nacimiento) values ( '22866859Y' , 'Maria Isabel' , 'Vega' , ' Av. Rey Santo' , '1977-12-3' );
INSERT INTO Persona (nif_cif,nombre, apellidos, direccion,nacimiento) values ( '50994169H' , 'Carmen' , 'Santiago' , 'Av. Rey Santo' , '1985-8-12' );
INSERT INTO Persona (nif_cif,nombre, apellidos, direccion,nacimiento) values ( '84441680D' , 'Perrera' , NULL , 'Azucena' , NULL );


INSERT INTO Licencia (numero_licencia, fecha_expedicion, tipo, direccion_local, nif_cif) values (1,'2013-01-31', 1, 'Av. Rey Santo', '50994169H');
INSERT INTO Licencia (numero_licencia, fecha_expedicion, tipo, direccion_local, nif_cif) values (2,'2011-02-05', 1, 'Alarcos', '28810410N');
INSERT INTO Licencia (numero_licencia, fecha_expedicion, tipo, direccion_local, nif_cif) values (3,'2011-02-05', 2, 'Alamillo Bajo', '37230022Z');


INSERT INTO Animal(id, pasaporte, peligroso, chip, explotacion, abandonado) VALUES (1, 1111, FALSE, 99, FALSE, FALSE);
INSERT INTO Animal(id, pasaporte, peligroso, chip, explotacion, abandonado) VALUES (2, 2222, FALSE, 98, TRUE, FALSE);
INSERT INTO Animal(id, pasaporte, peligroso, chip, explotacion, abandonado) VALUES (3, 3333, TRUE, 97, FALSE, FALSE);
INSERT INTO Animal(id, pasaporte, peligroso, chip, explotacion, abandonado) VALUES (4, 4444, FALSE, 96, FALSE, FALSE);
INSERT INTO Animal(id, pasaporte, peligroso, chip, explotacion, abandonado) VALUES (5, 5555, FALSE, 95, FALSE, FALSE);
INSERT INTO Animal(id, pasaporte, peligroso, chip, explotacion, abandonado) VALUES (6, 6666, FALSE, 94, FALSE, TRUE);
INSERT INTO Animal(id, pasaporte, peligroso, chip, explotacion, abandonado) VALUES (7, 7777, FALSE, 93, FALSE, FALSE);
INSERT INTO Animal(id, pasaporte, peligroso, chip, explotacion, abandonado) VALUES (8, 8888, FALSE, 92, FALSE, FALSE);
INSERT INTO Animal(id, pasaporte, peligroso, chip, explotacion, abandonado) VALUES (9, 9999, FALSE, 91, FALSE, TRUE);
INSERT INTO Animal(id, pasaporte, peligroso, chip, explotacion, abandonado) VALUES (10, 1234, TRUE, 90, FALSE, FALSE);
INSERT INTO Animal(id, pasaporte, peligroso, chip, explotacion, abandonado) VALUES (11, 2345, FALSE, 89, FALSE, TRUE);


INSERT INTO Censado(id,id_censo,especie,raza,aptitud,capa,nacimiento,domicilio_animal) VALUES (1, 298, 'perro', 'yorkshire', 'compañia', 'corto', '2000-01-05', 'Alamillo Alto');
INSERT INTO Censado(id,id_censo,especie,raza,aptitud,capa,nacimiento,domicilio_animal) VALUES (4, 712, 'gato', 'siames', 'compañia', 'corto', '2010-02-05', 'Alarcos');
INSERT INTO Censado(id,id_censo,especie,raza,aptitud,capa,nacimiento,domicilio_animal) VALUES (6, 823, 'perro', 'golden retriever', 'compañia', 'largo', '2006-01-05', 'Azucena');
INSERT INTO Censado(id,id_censo,especie,raza,aptitud,capa,nacimiento,domicilio_animal) VALUES (10, 192, 'perro', 'pitbull', 'vigilancia', 'corto', '2011-02-05', 'Av. Rey Santo');
INSERT INTO Censado(id,id_censo,especie,raza,aptitud,capa,nacimiento,domicilio_animal) VALUES (5, 653, 'gato', 'comun europeo', 'crianza', 'largo', '2014-02-05', 'Alcantara');
INSERT INTO Censado(id,id_censo,especie,raza,aptitud,capa,nacimiento,domicilio_animal) VALUES (7, 532, 'gato', 'munchkin', 'compañia', 'corto', '2008-02-05', 'Av. Alfonso X El Sabio');



INSERT INTO NoCensado(id,tipo_animal,extranjero,certificado,cites) VALUES (2,'vaca',FALSE,NULL,NULL);
INSERT INTO NoCensado(id,tipo_animal,extranjero,certificado,cites) VALUES (3,'leon',TRUE,34,345);
INSERT INTO NoCensado(id,tipo_animal,extranjero,certificado,cites) VALUES (8,'tortuga',FALSE,NULL,NULL);
INSERT INTO NoCensado(id,tipo_animal,extranjero,certificado,cites) VALUES (9,'serpiente',FALSE,NULL,NULL);
INSERT INTO NoCensado(id,tipo_animal,extranjero,certificado,cites) VALUES (11,'kiwi',TRUE,78,129);


INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2000-01-05', '2014-04-09' , '91662548G', 1);
INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2000-01-05', NULL, '37230022Z', 2);
INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2011-02-05', NULL, '28810410N', 3);
INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2010-02-05', NULL, '72671602C', 4);
INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2014-02-05', '2016-07-24' , '17526773Z', 5);
INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2006-01-05', NULL, '84441680D', 6);
INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2008-02-05', NULL, '87769805B', 7);
INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2011-02-05', NULL , '59577567T', 8);
INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2003-01-05', NULL , '22866859Y', 9);
INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2011-02-05', NULL , '50994169H', 10);
INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2011-02-05', NULL , '84441680D', 11);
INSERT INTO Tenencia(fecha_propiedad, fecha_fin, nif_cif, id) VALUES ('2009-07-21', '2011-02-05' , '62007899Z', 11);

INSERT INTO Incidente (id_acto, tipo_infraccion, fecha_acto, fecha_propiedad, id, nif_cif) values (1, 1, '2001-02-04', '2000-01-05', 1, '91662548G');
INSERT INTO Incidente (id_acto, tipo_infraccion, fecha_acto, fecha_propiedad, id, nif_cif) values (2, 1, '2011-02-05', '2011-02-05', 3, '28810410N');
INSERT INTO Incidente (id_acto, tipo_infraccion, fecha_acto, fecha_propiedad, id, nif_cif) values (3, 2, '2013-05-04', '2010-02-05', 4, '72671602C');

/*consultas*/

SELECT P.nombre, count(*) as nanimal
FROM Persona P, Tenencia T
WHERE P.nombre = 'Perrera' AND P.nif_cif=T.nif_cif;

SELECT DISTINCT AC.id, AC.raza
 FROM Censado AC
 WHERE AC.especie = 'gato';

SELECT P.nif_cif, P.direccion, I.tipo_infraccion 
FROM Persona P, Incidente I, Censado AC 
WHERE P.nif_cif=I.nif_cif AND I.id=AC.id;

SELECT DISTINCT T1.nif_cif, C.especie
FROM Tenencia T1, Tenencia T2, Censado C
WHERE C.id= T1.id AND C.especie='perro' AND T1.id = T2.id  AND T1.fecha_propiedad-T2.fecha_propiedad>=0 AND T1.fecha_fin IS NULL;

SELECT P.nombre, P.direccion
FROM Persona P, Tenencia T, Incidente I 
WHERE P.nif_cif=T.nif_cif AND T.id=I.id;

SELECT T.id, COUNT(*) as nTenencias
FROM NoCensado NC, Tenencia T 
WHERE NC.id = T.id AND NC.extranjero= TRUE
GROUP BY T.id
HAVING nTenencias>1;

SELECT P.nif_cif
FROM Persona P, Animal A, Incidente I
WHERE A.peligroso=TRUE AND I.id=A.id AND P.nif_cif=I.nif_cif;