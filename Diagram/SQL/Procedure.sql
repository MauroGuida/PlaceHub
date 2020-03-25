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


CREATE OR REPLACE PROCEDURE inserisciDocumentiUtente(INT, VARCHAR(1000), VARCHAR(1000))
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE Utente
  SET FronteDocumento = $2, RetroDocumento = $3
  WHERE codUtente = $1;

  COMMIT;
END;
$$;


CREATE OR REPLACE PROCEDURE inserisciBusiness( VARCHAR(50), VARCHAR(100), VARCHAR(10), VARCHAR(100), VARCHAR(100), VARCHAR(2000), INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO Business (Nome, Indirizzo, Telefono, PartitaIVA, tipo, Descrizione, codUtente)
  VALUES ( $1, $2, $3, $4, ($5)::tipoBusiness , $6, $7);
  COMMIT;
END;
$$;



---------------------------------------------------


--PROCEDURES ASSOCIAZIONE IMMAGINI A BUSINESS
CREATE OR REPLACE PROCEDURE inserisciImmaginiABusiness(INTEGER, VARCHAR(1000))
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO ImmagineProprieta
  VALUES ( $1, $2);
END;
$$;



--FUNZIONE RECUPERO CODICE BUSINESS
CREATE FUNCTION recuperaCodBusiness(VARCHAR(100))
RETURNS INTEGER
AS $$
DECLARE codiceBusiness INTEGER;
BEGIN
	SELECT codBusiness INTO codiceBusiness
	FROM Business
	WHERE PartitaIVA = $1;
	RETURN codiceBusiness;
END;
$$  LANGUAGE plpgsql;



--INSERIMENTO RAFFINAZIONI
CREATE OR REPLACE PROCEDURE inserisciRaffinazioni(INTEGER, VARCHAR(3000))
LANGUAGE plpgsql
AS $$
DECLARE lunghezza INTEGER;
DECLARE stringa VARCHAR(3000);
DECLARE pos1 INTEGER;
DECLARE pos2 INTEGER;
DECLARE raffinazione VARCHAR(200);
DECLARE occorrenza INTEGER = 1;
BEGIN
  lunghezza = LENGTH($2);
  stringa = $2;
  pos1 = 1;
  LOOP
  	pos2 = INSTR(stringa, ',', 1, occorrenza);
	EXIT WHEN pos2 = 0;
	raffinazione = SUBSTRING(stringa, pos1, pos2-pos1);
        INSERT INTO AssociazioneRaffinazione
	VALUES ($1, raffinazione::tipoRaffinazione);
	EXIT WHEN pos2 = lunghezza;
	occorrenza = occorrenza+1;
	pos1 = pos2+1;
  END LOOP;
END;
$$;



create or replace function instr(str text, sub text, startpos int, occurrence int)
returns int language plpgsql
as $$
declare 
    tail text;
    shift int;
    pos int;
    i int;
begin
    shift:= 0;
    if startpos = 0 or occurrence <= 0 then
        return 0;
    end if;
    if startpos < 0 then
        str:= reverse(str);
        sub:= reverse(sub);
        pos:= -startpos;
    else
        pos:= startpos;
    end if;
    for i in 1..occurrence loop
        shift:= shift+ pos;
        tail:= substr(str, shift);
        pos:= strpos(tail, sub);
        if pos = 0 then
            return 0;
        end if;
    end loop;
    if startpos > 0 then
        return pos+ shift- 1;
    else
        return length(str)- length(sub)- pos- shift+ 3;
    end if;
end $$;


