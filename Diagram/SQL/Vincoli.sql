ALTER TABLE Utente
  ADD CONSTRAINT LunghezzaPassword CHECK(length(Password)>=6);

ALTER TABLE Recensione
  ADD CONSTRAINT recensioneUnicaUtenteLuogo UNIQUE(codBusiness, codUtente);

ALTER TABLE AssociazioneRaffinazione
	ADD CONSTRAINT raffinazioneUnica UNIQUE(codBusiness,raffinazione);

ALTER TABLE ImmagineProprietà
	ADD CONSTRAINT immagineUnica UNIQUE(Url,codBusiness);

CREATE ASSERTION raffinazioneRistoranti CHECK NOT EXISTS(
  SELECT *
  FROM Associazione_Tipo AT1
  WHERE AT1.raffinazione IN ('Bar','Braceria','Pizzeria','Paninoteca') AND
        AT1.codBusiness NOT IN (SELECT A.codBusiness
                                FROM Business A
       						              WHERE A.Tipo = 'Ristorante')
);

CREATE ASSERTION raffinazioneAlloggi CHECK NOT EXISTS(
  SELECT *
  FROM Associazione_Tipo AT1
  WHERE AT1.raffinazione IN ('Hotel','Casa Vacanze') AND
        AT1.codBusiness NOT IN (SELECT A.codBusiness
       		                      FROM Business A
       			                    WHERE A.Tipo = 'Alloggio')
);

CREATE ASSERTION raffinazioneIntrattenimento CHECK NOT EXISTS(
  SELECT *
  FROM Associazione_Tipo AT1
  WHERE AT1.raffinazione IN ('Cinema','ParcoGiochi','Museo','Shopping','Piscina') AND
   	    AT1.codBusiness NOT IN (SELECT A.codBusiness
   	   	                        FROM Business A
   	   	                        WHERE A.Tipo = 'Intrattenimento')
);
