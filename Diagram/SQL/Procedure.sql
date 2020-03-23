CREATE OR REPLACE PROCEDURE generaCodiceVerifica(INT)
LANGUAGE plpgsql
AS $$
BEGIN
  Update utente
  set codiceVerifica=(select substr(md5(random()::text), 0, 10))
  where codutente=$1;

  COMMIT;
END;
$$;


CREATE FUNCTION login(INusername VARCHAR(50), INpassword VARCHAR(100))
RETURNS INTEGER AS $$
DECLARE codUtenteDaRestituire INTEGER;
BEGIN
        SELECT  codUtente INTO codUtenteDaRestituire
        FROM    utente
        WHERE   username = $1 AND password = $2;

        RETURN codUtenteDaRestituire;
END;
$$  LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE registrati(INusername VARCHAR(50), INnome VARCHAR(50),
  INcognome VARCHAR(50), INemail VARCHAR(100), INdata DATE, INpassword VARCHAR(100))
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO Utente(Username, Nome, Cognome, Email, DataDiNascita, Password)
  Values($1,$2,$3,$4,$5,$6);

  COMMIT;
END;
$$;


CREATE OR REPLACE PROCEDURE impostaNuovaPassword(INT, VARCHAR(50))
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE utente
  SET password = $2
  WHERE codutente=$1;

  COMMIT;
END;
$$;


CREATE FUNCTION controllaDocumentiUtente(INT)
RETURNS BOOLEAN AS $$
DECLARE flag BOOLEAN = '1';
BEGIN
	IF EXISTS (SELECT 1
		   FROM Utente U
		   WHERE U.codUtente = $1 AND U.FronteDocumento IS NULL AND U.RetroDocumento IS NULL) THEN
		flag = '0';
	END IF;
	RETURN flag;
END;
$$  LANGUAGE plpgsql;


CREATE FUNCTION controllaCodiceVerifica(INT, VARCHAR(10))
RETURNS BOOLEAN AS $$
DECLARE flag BOOLEAN = '0';
BEGIN
	IF EXISTS (SELECT 1
		   FROM Utente U
		   WHERE codUtente = $1 AND U.codiceVerifica = $2)  THEN
		flag = '1';
    UPDATE Utente SET codiceVerifica = null WHERE codUtente = $1;
	END IF;
	RETURN flag;
END;
$$  LANGUAGE plpgsql;
