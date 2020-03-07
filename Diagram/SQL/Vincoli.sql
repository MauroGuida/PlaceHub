ALTER TABLE Recensione
  ADD CONSTRAINT recensioneUnicaUtenteLuogo UNIQUE(codAttivita, codUser);

ALTER TABLE Associazione_Tipo
	ADD CONSTRAINT tagUnico UNIQUE(codAttività,parola);

ALTER TABLE Associazione_Tag
	ADD CONSTRAINT raffinazioneUnica UNIQUE(codAttivita,raffinazione);

ALTER TABLE ImmagineProprietà
	ADD CONSTRAINT immagineUnica UNIQUE(Url,codAttivita);

CREATE ASSERTION raffinazioneRistoranti CHECK NOT EXISTS
(SELECT *
 FROM Associazione_Tipo AT1
 WHERE AT1.raffinazione IN ('Bar','Braceria','Pizzeria','Paninoteca') AND
       AT1.codAttivita NOT IN (SELECT A.codAttivita
       						   FROM Attività A
       						   WHERE A.Tipo = 'Ristorante'));

CREATE ASSERTION raffinazioneAlloggi CHECK NOT EXISTS
(SELECT *
 FROM Associazione_Tipo AT1
 WHERE AT1.raffinazione IN ('Hotel','Casa Vacanze') AND
       AT1.codAttivita NOT IN (SELECT A.codAttivita
       						   FROM Attività A
       						   WHERE A.Tipo = 'Alloggio'));

CREATE ASSERTION raffinazioneIntrattenimento CHECK NOT EXISTS
(SELECT *
 FROM Associazione_Tipo AT1
 WHERE AT1.raffinazione IN ('Cinema','ParcoGiochi','Museo','Shopping','Piscina') AND
   	   AT1.codAttività NOT IN (SELECT A.codAttivita
   	   	  					   FROM Attività A
   	   	  					   WHERE A.Tipo = 'Intrattenimento'));
