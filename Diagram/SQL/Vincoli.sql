ALTER TABLE Utente
  ADD CONSTRAINT LunghezzaPassword CHECK(length(Password)>=6);

ALTER TABLE Recensione
  ADD CONSTRAINT recensioneUnicaUtenteLuogo UNIQUE(codBusiness, codUtente);

ALTER TABLE AssociazioneRaffinazione
	ADD CONSTRAINT raffinazioneUnica UNIQUE(codBusiness,raffinazione);

ALTER TABLE ImmagineProprietà
	ADD CONSTRAINT immagineUnica UNIQUE(Url,codBusiness);

--------------


CREATE FUNCTION checkRaffinazioneRistoranti() RETURNS TRIGGER AS
$BODY$
DECLARE
	raff AssociazioneRaffinazione.raffinazione%TYPE;
BEGIN
	FOR raff IN SELECT raffinazione FROM AssociazioneRaffinazione WHERE codBusiness = NEW.codBusiness
	LOOP
		IF raff.raffinazione NOT IN ('Bar','Braceria','Pizzeria','Paninoteca') THEN
			RAISE EXCEPTION 'Errore: Raffinazione non consentita';
		END IF;
	END LOOP;
END;
$BODY$
LANGUAGE PLPGSQL;
	

CREATE TRIGGER checkRaffinazioneRistoranti 
BEFORE INSERT ON Business
FOR EACH ROW
WHEN (NEW.tipo = 'Ristorante') 
EXECUTE PROCEDURE checkRaffinazioneRistoranti();



--------------


CREATE FUNCTION checkRaffinazioneAlloggio() RETURNS TRIGGER AS
$BODY$
DECLARE
	raff AssociazioneRaffinazione.raffinazione%TYPE;
BEGIN
	FOR raff IN SELECT raffinazione FROM AssociazioneRaffinazione WHERE codBusiness = NEW.codBusiness
	LOOP
		IF raff.raffinazione NOT IN ('Hotel','Casa Vacanze') THEN
			RAISE EXCEPTION 'Errore: Raffinazione non consentita';
		END IF;
	END LOOP;
END;
$BODY$
LANGUAGE PLPGSQL;
	

CREATE TRIGGER checkRaffinazioneAlloggio
BEFORE INSERT ON Business
FOR EACH ROW
WHEN (NEW.tipo = 'Alloggio') 
EXECUTE PROCEDURE checkRaffinazioneAlloggio();


-----------------



CREATE FUNCTION checkRaffinazioneAttrazioni() RETURNS TRIGGER AS
$BODY$
DECLARE
	raff AssociazioneRaffinazione.raffinazione%TYPE;
BEGIN
	FOR raff IN SELECT raffinazione FROM AssociazioneRaffinazione WHERE codBusiness = NEW.codBusiness
	LOOP
		IF raff.raffinazione NOT IN ('Cinema','ParcoGiochi','Museo','Shopping','Piscina') THEN
			RAISE EXCEPTION 'Errore: Raffinazione non consentita';
		END IF;
	END LOOP;
END;
$BODY$
LANGUAGE PLPGSQL;
	

CREATE TRIGGER checkRaffinazioneAttrazioni
BEFORE INSERT ON Business
FOR EACH ROW
WHEN (NEW.tipo = 'Attrazione') 
EXECUTE PROCEDURE checkRaffinazioneAttrazioni();


------------



