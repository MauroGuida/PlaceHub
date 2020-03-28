ALTER TABLE Utente
  ADD CONSTRAINT LunghezzaPassword CHECK(length(Password)>=6);

ALTER TABLE Recensione
  ADD CONSTRAINT RecensioneUnicaUtenteLuogo UNIQUE(codBusiness, codUtente);

ALTER TABLE AssociazioneRaffinazione
	ADD CONSTRAINT RaffinazioneUnica UNIQUE(codBusiness,raffinazione);

ALTER TABLE Business
  ADD CONSTRAINT NumeroDiTelefonoNonValido CHECK(Telefono ~ '^[0-9 ]*$');

ALTER TABLE Business
  ADD CONSTRAINT NumeroDiTelefonoTroppoCorto CHECK(LENGTH(Telefono) = 10);

ALTER TABLE Business
  ADD CONSTRAINT lunghezzaPartitaIVA CHECK(LENGTH(PartitaIVA) = 11);

ALTER TABLE Utente
  ADD CONSTRAINT DataDiNascitaNonValida CHECK(NOT(DataDiNascita >= date('now')));
--------------


CREATE FUNCTION checkRaffinazioneRistoranti() RETURNS TRIGGER AS
$BODY$
DECLARE
	raff AssociazioneRaffinazione.raffinazione%TYPE;
BEGIN
	FOR raff IN SELECT raffinazione FROM AssociazioneRaffinazione WHERE codBusiness = NEW.codBusiness
	LOOP
		IF raff.raffinazione NOT IN ('Pizzeria', 'Braceria', 'FastFood',
				      	     'Paninoteca', 'Osteria', 'Tavola Calda',
						'Taverna','Trattoria', 'Pesce') THEN
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
		IF raff.raffinazione NOT IN ('Hotel', 'Bed&Breakfast', 'Ostello', 'CasaVacanze' ,'Residence') THEN
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
		IF raff.raffinazione NOT IN ('Cinema', 'Shopping','Monumento', 'Museo', 'Parco Giochi', 'Piscina', 'Bar/Lounge') THEN
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
