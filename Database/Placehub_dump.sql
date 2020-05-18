--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.2

-- Started on 2020-05-18 17:39:56

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 659 (class 1247 OID 24876)
-- Name: tipobusiness; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tipobusiness AS ENUM (
    'Attrazione',
    'Alloggio',
    'Ristorante'
);


ALTER TYPE public.tipobusiness OWNER TO postgres;

--
-- TOC entry 671 (class 1247 OID 24914)
-- Name: tiporaffinazione; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tiporaffinazione AS ENUM (
    'Pizzeria',
    'Braceria',
    'FastFood',
    'Paninoteca',
    'Osteria',
    'Tavola Calda',
    'Taverna',
    'Trattoria',
    'Pesce',
    'Cinema',
    'Shopping',
    'Monumento',
    'Museo',
    'Parco Giochi',
    'Piscina',
    'Lounge',
    'Hotel',
    'Bed&Breakfast',
    'Ostello',
    'CasaVacanze',
    'Residence'
);


ALTER TYPE public.tiporaffinazione OWNER TO postgres;

--
-- TOC entry 216 (class 1255 OID 25085)
-- Name: aggiornamediastelle(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.aggiornamediastelle() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE nuovaMedia NUMERIC;
BEGIN
    SELECT AVG(Stelle) INTO nuovaMedia
    FROM Recensione 
    WHERE codBusiness = NEW.codBusiness; 

    UPDATE Business
    SET Stelle = nuovaMedia
    WHERE codBusiness = NEW.codBusiness;
	
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.aggiornamediastelle() OWNER TO postgres;

--
-- TOC entry 236 (class 1255 OID 25024)
-- Name: controllacodiceverifica(integer, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.controllacodiceverifica(integer, character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
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
$_$;


ALTER FUNCTION public.controllacodiceverifica(integer, character varying) OWNER TO postgres;

--
-- TOC entry 235 (class 1255 OID 25023)
-- Name: controlladocumentiutente(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.controlladocumentiutente(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE flag BOOLEAN = '1';
BEGIN
	IF EXISTS (SELECT 1
		   FROM Utente U
		   WHERE U.codUtente = $1 AND U.FronteDocumento IS NULL AND U.RetroDocumento IS NULL) THEN
		flag = '0';
	END IF;
	RETURN flag;
END;
$_$;


ALTER FUNCTION public.controlladocumentiutente(integer) OWNER TO postgres;

--
-- TOC entry 219 (class 1255 OID 25019)
-- Name: generacodiceverifica(integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.generacodiceverifica(integer)
    LANGUAGE plpgsql
    AS $_$
BEGIN
  Update utente
  set codiceVerifica=(select substr(md5(random()::text), 0, 10))
  where codutente=$1;

  COMMIT;
END;
$_$;


ALTER PROCEDURE public.generacodiceverifica(integer) OWNER TO postgres;

--
-- TOC entry 234 (class 1255 OID 25022)
-- Name: impostanuovapassword(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.impostanuovapassword(integer, character varying)
    LANGUAGE plpgsql
    AS $_$
BEGIN
  UPDATE utente
  SET password = $2
  WHERE codutente=$1;

  COMMIT;
END;
$_$;


ALTER PROCEDURE public.impostanuovapassword(integer, character varying) OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 25026)
-- Name: inseriscibusiness(character varying, character varying, character varying, character varying, character varying, character varying, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inseriscibusiness(character varying, character varying, character varying, character varying, character varying, character varying, integer)
    LANGUAGE plpgsql
    AS $_$
BEGIN
  INSERT INTO Business (Nome, Indirizzo, Telefono, PartitaIVA, tipo, Descrizione, codUtente)
  VALUES ( $1, $2, $3, $4, ($5)::tipoBusiness , $6, $7);
  COMMIT;
END;
$_$;


ALTER PROCEDURE public.inseriscibusiness(character varying, character varying, character varying, character varying, character varying, character varying, integer) OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 25081)
-- Name: inseriscibusiness(character varying, character varying, character varying, character varying, character varying, character varying, integer, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inseriscibusiness(character varying, character varying, character varying, character varying, character varying, character varying, integer, integer)
    LANGUAGE plpgsql
    AS $_$
BEGIN
  IF EXISTS ( SELECT 1 FROM Business WHERE PartitaIVA = $4 ) THEN
	UPDATE BUSINESS
	SET Nome = $1, Indirizzo = $2, Telefono = $3, tipo = ($5)::tipoBusiness, Descrizione = $6 
	WHERE PartitaIVA = $4;
  ELSE
	INSERT INTO Business (Nome, Indirizzo, Telefono, PartitaIVA, tipo, Descrizione, codUtente, codMappa)
	VALUES ( $1, $2, $3, $4, ($5)::tipoBusiness , $6, $7, $8);
  END IF;
  COMMIT;
END;
$_$;


ALTER PROCEDURE public.inseriscibusiness(character varying, character varying, character varying, character varying, character varying, character varying, integer, integer) OWNER TO postgres;

--
-- TOC entry 237 (class 1255 OID 25025)
-- Name: inseriscidocumentiutente(integer, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inseriscidocumentiutente(integer, character varying, character varying)
    LANGUAGE plpgsql
    AS $_$
BEGIN
  UPDATE Utente
  SET FronteDocumento = $2, RetroDocumento = $3
  WHERE codUtente = $1;

  COMMIT;
END;
$_$;


ALTER PROCEDURE public.inseriscidocumentiutente(integer, character varying, character varying) OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 25082)
-- Name: inserisciimmaginerecensione(character varying, integer); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inserisciimmaginerecensione(character varying, integer)
    LANGUAGE plpgsql
    AS $_$
BEGIN
  INSERT INTO ImmagineRecensione
  VALUES ( $1, $2);
  COMMIT;
END;
$_$;


ALTER PROCEDURE public.inserisciimmaginerecensione(character varying, integer) OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 25027)
-- Name: inserisciimmaginiabusiness(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inserisciimmaginiabusiness(integer, character varying)
    LANGUAGE plpgsql
    AS $_$
BEGIN
  INSERT INTO ImmagineProprieta(codBusiness, Url)
  VALUES($1, $2);
END;
$_$;


ALTER PROCEDURE public.inserisciimmaginiabusiness(integer, character varying) OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 25029)
-- Name: inserisciraffinazioni(integer, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.inserisciraffinazioni(integer, character varying)
    LANGUAGE plpgsql
    AS $_$
DECLARE lunghezza INTEGER;
DECLARE stringa VARCHAR(3000);
DECLARE pos1 INTEGER;
DECLARE pos2 INTEGER;
DECLARE raffinazione VARCHAR(200);
DECLARE occorrenza INTEGER = 1;
BEGIN
  DELETE 
  FROM AssociazioneRaffinazione
  WHERE codBusiness = $1;
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
$_$;


ALTER PROCEDURE public.inserisciraffinazioni(integer, character varying) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 25083)
-- Name: inseriscirecensione(character varying, numeric, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.inseriscirecensione(character varying, numeric, integer, integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE codRecen INTEGER;
BEGIN
  INSERT INTO Recensione (Testo, Stelle, CodBusiness, CodUtente) 
  VALUES ( $1, $2, $3, $4) RETURNING codRecensione INTO codRecen;
  RETURN codRecen;
END;
$_$;


ALTER FUNCTION public.inseriscirecensione(character varying, numeric, integer, integer) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 25030)
-- Name: instr(text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.instr(str text, sub text, startpos integer, occurrence integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
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


ALTER FUNCTION public.instr(str text, sub text, startpos integer, occurrence integer) OWNER TO postgres;

--
-- TOC entry 220 (class 1255 OID 25020)
-- Name: login(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.login(inusername character varying, inpassword character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE codUtenteDaRestituire INTEGER;
BEGIN
        SELECT  codUtente INTO codUtenteDaRestituire
        FROM    utente
        WHERE   username = $1 AND password = $2;

        RETURN codUtenteDaRestituire;
END;
$_$;


ALTER FUNCTION public.login(inusername character varying, inpassword character varying) OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 25038)
-- Name: recuperabusinessdacodutente(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recuperabusinessdacodutente(integer) RETURNS TABLE(codbusiness integer, nome character varying, indirizzo character varying, stelle numeric, url character varying)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY SELECT DISTINCT B.codBusiness, B.Nome, B.Indirizzo, B.Stelle, I.Url
   		 FROM Business B JOIN ImmagineProprieta I ON (B.codBusiness = I.codBusiness)
   		 WHERE codUtente = $1;
END;
$_$;


ALTER FUNCTION public.recuperabusinessdacodutente(integer) OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 25028)
-- Name: recuperacodbusiness(character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recuperacodbusiness(character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE codiceBusiness INTEGER;
BEGIN
	SELECT codBusiness INTO codiceBusiness
	FROM Business
	WHERE PartitaIVA = $1;
	RETURN codiceBusiness;
END;
$_$;


ALTER FUNCTION public.recuperacodbusiness(character varying) OWNER TO postgres;

--
-- TOC entry 213 (class 1255 OID 25035)
-- Name: recuperaimmaginilocale(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recuperaimmaginilocale(integer) RETURNS TABLE(url character varying)
    LANGUAGE plpgsql
    AS $_$
BEGIN
   RETURN QUERY SELECT Url
   		FROM ImmagineProprieta
   		WHERE codBusiness = $1;
END; 
$_$;


ALTER FUNCTION public.recuperaimmaginilocale(integer) OWNER TO postgres;

--
-- TOC entry 214 (class 1255 OID 25036)
-- Name: recuperalocaledacodbusiness(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recuperalocaledacodbusiness(integer) RETURNS TABLE(nome character varying, indirizzo character varying, telefono character varying, partitaiva character varying, descrizione character varying, stelle numeric, tipo public.tipobusiness)
    LANGUAGE plpgsql
    AS $_$
BEGIN
   RETURN QUERY SELECT Nome, Indirizzo, Telefono, PartitaIVA, Descrizione, Stelle, tipo
   		FROM Business
   		WHERE codBusiness = $1;
END; 
$_$;


ALTER FUNCTION public.recuperalocaledacodbusiness(integer) OWNER TO postgres;

--
-- TOC entry 215 (class 1255 OID 25037)
-- Name: recuperaraffinazionilocale(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.recuperaraffinazionilocale(integer) RETURNS TABLE(raffinazione public.tiporaffinazione)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY SELECT raffinazione
   		 FROM AssociazioneRaffinazione
   		 WHERE codBusiness = $1 ;
END; 
$_$;


ALTER FUNCTION public.recuperaraffinazionilocale(integer) OWNER TO postgres;

--
-- TOC entry 233 (class 1255 OID 25021)
-- Name: registrati(character varying, character varying, character varying, character varying, date, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.registrati(inusername character varying, innome character varying, incognome character varying, inemail character varying, indata date, inpassword character varying)
    LANGUAGE plpgsql
    AS $_$
BEGIN
  INSERT INTO Utente(Username, Nome, Cognome, Email, DataDiNascita, Password)
  Values($1,$2,$3,$4,$5,$6);

  COMMIT;
END;
$_$;


ALTER PROCEDURE public.registrati(inusername character varying, innome character varying, incognome character varying, inemail character varying, indata date, inpassword character varying) OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 25084)
-- Name: ricercalocale(character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ricercalocale(character varying, character varying) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $_$
BEGIN 
	IF ( $1 = '' AND $2 = '' ) THEN
		RETURN QUERY 
		SELECT  B.codBusiness, B.Nome, B.Indirizzo, B.Stelle, I.Url 
		FROM Business B, ImmagineProprieta I 
		WHERE B.codBusiness = I.codBusiness AND I.URL = (SELECT IP.URL FROM ImmagineProprieta IP WHERE IP.codBusiness = B.codBusiness LIMIT 1);
	
	ELSE 
		RETURN QUERY 
		SELECT B.codBusiness, B.Nome, B.Indirizzo, B.Stelle, I.Url 
		FROM ((Business B JOIN ImmagineProprieta I ON (B.codBusiness = I.codBusiness)) JOIN Mappa M ON (B.codMappa = M.codMappa)) 
		WHERE I.URL = (SELECT IP.URL FROM ImmagineProprieta IP WHERE IP.codBusiness = B.codBusiness LIMIT 1) AND 
		     ((B.Nome ILIKE '%' || $1 || '%') OR (SELECT 1 
					       	          FROM AssociazioneRaffinazione A 
					                  WHERE A.codBusiness = B.codBusiness AND CAST(A.raffinazione AS VARCHAR(100)) ILIKE '%' || $1 || '%') IS NOT NULL)
		     AND 
		    ((M.Provincia ILIKE '%' || $2 || '%') OR (M.Comune ILIKE '%' || $2 || '%'));
	END IF;	
END; 
$_$;


ALTER FUNCTION public.ricercalocale(character varying, character varying) OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 25087)
-- Name: utenteconrecensione(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.utenteconrecensione(integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE flag BOOLEAN = '0';
BEGIN
	IF EXISTS (SELECT 1 FROM Recensione WHERE codUtente = $1) THEN
		flag = '1';
	END IF;
	RETURN flag;
END;
$_$;


ALTER FUNCTION public.utenteconrecensione(integer) OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 25088)
-- Name: utenteconrecensione(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.utenteconrecensione(integer, integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $_$
DECLARE flag BOOLEAN = '0';
BEGIN
	IF EXISTS (SELECT 1 FROM Recensione WHERE codUtente = $1 AND codBusiness = $2) THEN
		flag = '1';
	END IF;
	RETURN flag;
END;
$_$;


ALTER FUNCTION public.utenteconrecensione(integer, integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 207 (class 1259 OID 24957)
-- Name: associazioneraffinazione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.associazioneraffinazione (
    codbusiness integer,
    raffinazione public.tiporaffinazione
);


ALTER TABLE public.associazioneraffinazione OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 24885)
-- Name: business; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.business (
    codbusiness integer NOT NULL,
    nome character varying(50) NOT NULL,
    indirizzo character varying(100) NOT NULL,
    partitaiva character varying(100) NOT NULL,
    tipo public.tipobusiness NOT NULL,
    descrizione character varying(2000) NOT NULL,
    stelle numeric,
    telefono character varying(10) NOT NULL,
    codutente integer,
    codmappa integer,
    CONSTRAINT business_stelle_check CHECK ((((stelle >= (1)::numeric) AND (stelle <= (5)::numeric)) OR (stelle IS NULL))),
    CONSTRAINT lunghezzapartitaiva CHECK ((length((partitaiva)::text) = 11)),
    CONSTRAINT numeroditelefonononvalido CHECK (((telefono)::text ~ '^[0-9 ]*$'::text)),
    CONSTRAINT numeroditelefonotroppocorto CHECK ((length((telefono)::text) = 10))
);


ALTER TABLE public.business OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 24883)
-- Name: business_codbusiness_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.business_codbusiness_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.business_codbusiness_seq OWNER TO postgres;

--
-- TOC entry 2937 (class 0 OID 0)
-- Dependencies: 204
-- Name: business_codbusiness_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.business_codbusiness_seq OWNED BY public.business.codbusiness;


--
-- TOC entry 206 (class 1259 OID 24902)
-- Name: immagineproprieta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.immagineproprieta (
    url character varying(1000),
    codbusiness integer
);


ALTER TABLE public.immagineproprieta OWNER TO postgres;

--
-- TOC entry 210 (class 1259 OID 24987)
-- Name: immaginerecensione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.immaginerecensione (
    url character varying(1000) NOT NULL,
    codrecensione integer
);


ALTER TABLE public.immaginerecensione OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 25063)
-- Name: mappa; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mappa (
    stato character varying(5),
    cap character varying(7),
    comune character varying(100),
    regione character varying(100),
    provincia character varying(100),
    siglaprovincia character varying(5),
    codmappa integer NOT NULL
);


ALTER TABLE public.mappa OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 25067)
-- Name: mappa_codmappa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mappa_codmappa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mappa_codmappa_seq OWNER TO postgres;

--
-- TOC entry 2938 (class 0 OID 0)
-- Dependencies: 212
-- Name: mappa_codmappa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mappa_codmappa_seq OWNED BY public.mappa.codmappa;


--
-- TOC entry 209 (class 1259 OID 24967)
-- Name: recensione; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recensione (
    testo character varying(2000) NOT NULL,
    stelle numeric NOT NULL,
    codrecensione integer NOT NULL,
    codbusiness integer,
    codutente integer,
    CONSTRAINT recensione_stelle_check CHECK (((stelle >= (1)::numeric) AND (stelle <= (5)::numeric)))
);


ALTER TABLE public.recensione OWNER TO postgres;

--
-- TOC entry 208 (class 1259 OID 24965)
-- Name: recensione_codrecensione_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.recensione_codrecensione_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recensione_codrecensione_seq OWNER TO postgres;

--
-- TOC entry 2939 (class 0 OID 0)
-- Dependencies: 208
-- Name: recensione_codrecensione_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.recensione_codrecensione_seq OWNED BY public.recensione.codrecensione;


--
-- TOC entry 203 (class 1259 OID 24857)
-- Name: utente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.utente (
    codutente integer NOT NULL,
    username character varying(50) NOT NULL,
    nome character varying(50) NOT NULL,
    cognome character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    datadinascita date NOT NULL,
    password character varying(100) NOT NULL,
    immagine character varying(1000) DEFAULT NULL::character varying,
    codiceverifica character varying(10) DEFAULT NULL::character varying,
    frontedocumento character varying(1000) DEFAULT NULL::character varying,
    retrodocumento character varying(1000) DEFAULT NULL::character varying,
    CONSTRAINT datadinascitanonvalida CHECK ((NOT (datadinascita >= '2020-03-26'::date))),
    CONSTRAINT lunghezzapassword CHECK ((length((password)::text) >= 6)),
    CONSTRAINT utente_email_check CHECK (((email)::text ~~ '_%@%.__%'::text))
);


ALTER TABLE public.utente OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 24855)
-- Name: utente_codutente_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.utente_codutente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.utente_codutente_seq OWNER TO postgres;

--
-- TOC entry 2940 (class 0 OID 0)
-- Dependencies: 202
-- Name: utente_codutente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.utente_codutente_seq OWNED BY public.utente.codutente;


--
-- TOC entry 2759 (class 2604 OID 24888)
-- Name: business codbusiness; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business ALTER COLUMN codbusiness SET DEFAULT nextval('public.business_codbusiness_seq'::regclass);


--
-- TOC entry 2766 (class 2604 OID 25069)
-- Name: mappa codmappa; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mappa ALTER COLUMN codmappa SET DEFAULT nextval('public.mappa_codmappa_seq'::regclass);


--
-- TOC entry 2764 (class 2604 OID 24970)
-- Name: recensione codrecensione; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recensione ALTER COLUMN codrecensione SET DEFAULT nextval('public.recensione_codrecensione_seq'::regclass);


--
-- TOC entry 2751 (class 2604 OID 24860)
-- Name: utente codutente; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utente ALTER COLUMN codutente SET DEFAULT nextval('public.utente_codutente_seq'::regclass);


--
-- TOC entry 2926 (class 0 OID 24957)
-- Dependencies: 207
-- Data for Name: associazioneraffinazione; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.associazioneraffinazione (codbusiness, raffinazione) FROM stdin;
14	Hotel
15	Hotel
15	Bed&Breakfast
17	Monumento
18	Paninoteca
18	FastFood
18	Osteria
19	Pesce
\.


--
-- TOC entry 2924 (class 0 OID 24885)
-- Dependencies: 205
-- Data for Name: business; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.business (codbusiness, nome, indirizzo, partitaiva, tipo, descrizione, stelle, telefono, codutente, codmappa) FROM stdin;
14	Hotel Moresco	Sestiere Dorsoduro	54584684fsd	Alloggio	L`Hotel Moresco, ubicato sul canale Rio Nuovo (1,4 km dalla Collezione Peggy Guggenheim e 1,6 km dal Ponte di Rialto, a meno di 5 minuti a piedi da Piazzale Roma e 700 metri dalla stazione di Venezia-Santa Lucia ) è un gioiello meraviglioso nel pieno centro della meravigliosa città di Venezia.\n\nL´hotel è caldamente arredato con mobili di pregio, dispone di biblioteca con poltrone in pelle e caminetto per gli ospiti. e si affaccia su un giardino privato tipicamente veneziano, con solarium e zona bar.\n\nLe eleganti camere offrono WiFi gratuito, TV LCD 32“ con canali satellitari, cassaforte privata, macchina per caffè Nespresso, minibar e servizio in camera. Le camere di categoria superiore includono angolo relax e/o balcone, mentre la suite dispone di vasca idromassaggio.\n\nLa reception è aperta 24/7. La colazione e il taxi per Murano sono inclusi nel prezzo. La cura e la solerzia del personale vi faranno sentire circondati da un oasi di benessere.	4.0000000000000000	0412440202	5	17151
17	Acquario di Genova	Ponte Spinola	5sdfds4ffsg	Attrazione	L'Acquario di Genova è un acquario situato a Ponte Spinola, nel cinquecentesco porto antico di Genova. Attualmente è il terzo più grande d'Europa e il nono nel mondo. Di proprietà di Porto Antico di Genova SpA e gestito dalla società Costa Edutainment SpA, è stato inaugurato nel 1992 in occasione delle Colombiadi, ossia della Expo celebrativa del cinquecentesimo anniversario della scoperta dell'America.	4.0000000000000000	0102345100	5	5495
18	Vulio	Via degli Scipioni 55	fdsf4584r52	Ristorante	Localino molto piccolo ma molto carino e ben arredato a due passi dalla fermata metro Ottaviano. La proposta principale prevede una fetta di pane con prodotti tutti di origine pugliese. Personale qualificato e all'altezza.	4.0000000000000000	0639733825	5	5217
15	Giardino Eden	Via Nuova Cartaromana 68	564165dfdtd	Alloggio	Cerchi un alloggio a Ischia? Soggiorna al Giardino Eden, un piccolo hotel romantico a due passi dal meglio che Ischia ha da offrire.\n\nGiardino Eden è un piccolo hotel romantico con camere dotate di aria condizionata. Durante il soggiorno, gli ospiti avranno a disposizione la connessione Wi-Fi gratuita.\n\nIl piccolo hotel offre uno servizio in camera. Gli ospiti possono anche approfittare della piscina e della colazione inclusa, che hanno reso questa struttura una tra le più richieste dai viaggiatori che visitano Ischia.\n\nIn posizione ideale vicino ad alcuni dei principali punti d'interesse di Ischia, come Chiesa di Santa Maria di Costantinopoli (0,6 km) e Chiesa dello Spirito Santo (0,6 km), il Giardino Eden è un'ottima destinazione per i turisti.\n\nSe cerchi un ristorante di pesce, perché non provi Ristorante Aglio Olio E Pomodoro, Il Giardino Eden o Ristorante Da Ciccio, non lontano dal Giardino Eden.\n\nSe cerchi qualcosa da fare, Castello Aragonese (0,6 km), Palazzo dell'Orologio (0,5 km) e Parco Pineta Mirtina (1,1 km) sono un'ottima idea per trascorrere il tempo libero e sono raggiungibili a piedi dal Giardino Eden.\n\nTrascorrerai un fantastico soggiorno al Giardino Eden e da qui potrai facilmente scoprire il meglio che Ischia ha da offrire.	4.5000000000000000	0815648674	5	1837
19	Ristorante San Silvestro	San Polo1022B Rio Tera San Silvestro	sdfd9659654	Ristorante	A 4 passi da Rialto, condotto da tre fratelli, tutti impegnati nel locale. Cucina Veneziana ma non solo, ottima qualità, porzioni abbondanti. 	3.0000000000000000	0412601787	5	17155
\.


--
-- TOC entry 2925 (class 0 OID 24902)
-- Dependencies: 206
-- Data for Name: immagineproprieta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.immagineproprieta (url, codbusiness) FROM stdin;
https://media-cdn.tripadvisor.com/media/photo-o/0d/dd/6a/78/hotel-moresco.jpg	14
https://media-cdn.tripadvisor.com/media/photo-o/0d/dd/6a/61/hotel-moresco.jpg	14
https://media-cdn.tripadvisor.com/media/photo-o/10/99/f8/ca/hotel-moresco.jpg	14
https://media-cdn.tripadvisor.com/media/photo-o/0d/dd/6a/cc/hotel-moresco.jpg	14
https://media-cdn.tripadvisor.com/media/photo-o/0d/dd/6a/7f/hotel-moresco.jpg	14
https://media-cdn.tripadvisor.com/media/photo-o/0d/dd/6a/a4/hotel-moresco.jpg	14
https://media-cdn.tripadvisor.com/media/oyster/1430/05/e0/93/04/the-breakfast-room--v2019835.jpg	14
https://media-cdn.tripadvisor.com/media/oyster/1430/05/e0/92/b3/the-bar--v2019643.jpg	14
https://media-cdn.tripadvisor.com/media/photo-o/0f/79/68/dc/img-20170604-wa0003-largejpg.jpg	15
https://media-cdn.tripadvisor.com/media/photo-o/09/c9/57/f1/giardino-eden.jpg	15
https://media-cdn.tripadvisor.com/media/photo-o/10/4d/73/3d/img-20170809-173633-largejpg.jpg	15
https://media-cdn.tripadvisor.com/media/photo-o/08/e4/05/9c/photo3jpg.jpg	15
https://media-cdn.tripadvisor.com/media/photo-o/08/ff/18/80/giardino-eden.jpg	15
https://media-cdn.tripadvisor.com/media/photo-o/0f/79/68/d9/img-20170530-wa0000-largejpg.jpg	15
https://i.ytimg.com/vi/j5A0XzAKLP4/maxresdefault.jpg	17
https://www.italymagazine.com/sites/default/files/point-of-interest/acquario-di-genova.jpg	17
https://liguria.bizjournal.it/wp-content/uploads/2014/12/AcquariodiGenova-Padiglione_Cetacei_Delfini.jpg	17
https://media-cdn.tripadvisor.com/media/photo-s/12/8e/21/4f/il-caparezza.jpg	18
https://media-cdn.tripadvisor.com/media/photo-s/12/8e/21/58/l-aperipuglia.jpg	18
https://c.tfstatic.com/w_656,h_368,c_fill,g_auto:subject,q_auto,f_auto/restaurant_photos/827/444827/source/san-silvestro-entrata-92ddb.jpg	19
https://c.tfstatic.com/w_656,h_368,c_fill,g_auto:subject,q_auto,f_auto/restaurant_photos/827/444827/source/san-silvestro-vista-della-sala-c72cd.jpg	19
https://c.tfstatic.com/w_656,h_368,c_fill,g_auto:subject,q_auto,f_auto/restaurant_photos/827/444827/source/san-silvestro-vista-della-sala-2aa9e.jpg	19
https://c.tfstatic.com/w_656,h_368,c_fill,g_auto:subject,q_auto,f_auto/restaurant_photos/827/444827/source/san-silvestro-vista-della-sala-c4670.jpg	19
https://c.tfstatic.com/w_656,h_368,c_fill,g_auto:subject,q_auto,f_auto/restaurant_photos/827/444827/source/san-silvestro-vista-della-sala-88897.jpg	19
\.


--
-- TOC entry 2929 (class 0 OID 24987)
-- Dependencies: 210
-- Data for Name: immaginerecensione; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.immaginerecensione (url, codrecensione) FROM stdin;
https://media-cdn.tripadvisor.com/media/photo-m/1280/1a/43/75/d9/hotel-moresco.jpg	19
https://media-cdn.tripadvisor.com/media/photo-w/1a/38/d1/18/photo2jpg.jpg	19
https://media-cdn.tripadvisor.com/media/photo-w/1a/38/d1/16/photo0jpg.jpg	19
https://media-cdn.tripadvisor.com/media/photo-w/1a/06/23/e6/hotel-moresco.jpg	19
https://media-cdn.tripadvisor.com/media/photo-w/1a/06/23/e1/hotel-moresco.jpg	19
\.


--
-- TOC entry 2930 (class 0 OID 25063)
-- Dependencies: 211
-- Data for Name: mappa; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mappa (stato, cap, comune, regione, provincia, siglaprovincia, codmappa) FROM stdin;
IT	75010	Oliveto Lucano	Basilicata	Matera	MT	1
IT	75010	Cirigliano	Basilicata	Matera	MT	2
IT	75010	Aliano	Basilicata	Matera	MT	3
IT	75010	Peschiera	Basilicata	Matera	MT	4
IT	75010	Miglionico	Basilicata	Matera	MT	5
IT	75010	San Mauro Forte	Basilicata	Matera	MT	6
IT	75010	Grottole	Basilicata	Matera	MT	7
IT	75010	Garaguso	Basilicata	Matera	MT	8
IT	75010	Calciano	Basilicata	Matera	MT	9
IT	75010	Gorgoglione	Basilicata	Matera	MT	10
IT	75010	Craco	Basilicata	Matera	MT	11
IT	75011	Accettura	Basilicata	Matera	MT	12
IT	75012	Bernalda	Basilicata	Matera	MT	13
IT	75012	Metaponto	Basilicata	Matera	MT	14
IT	75012	Metaponto Lido	Basilicata	Matera	MT	15
IT	75012	Serra Marina	Basilicata	Matera	MT	16
IT	75013	Ferrandina	Basilicata	Matera	MT	17
IT	75013	Macchia	Basilicata	Matera	MT	18
IT	75013	Borgo Macchia	Basilicata	Matera	MT	19
IT	75014	Grassano	Basilicata	Matera	MT	20
IT	75015	Pisticci	Basilicata	Matera	MT	21
IT	75015	Marconia	Basilicata	Matera	MT	22
IT	75015	Pisticci Scalo	Basilicata	Matera	MT	23
IT	75016	Pomarico	Basilicata	Matera	MT	24
IT	75017	Salandra	Basilicata	Matera	MT	25
IT	75018	Stigliano	Basilicata	Matera	MT	26
IT	75019	Calle	Basilicata	Matera	MT	27
IT	75019	Tricarico	Basilicata	Matera	MT	28
IT	75020	Scanzano Jonico	Basilicata	Matera	MT	29
IT	75020	Nova Siri	Basilicata	Matera	MT	30
IT	75020	Nova Siri Scalo	Basilicata	Matera	MT	31
IT	75020	Recoleta	Basilicata	Matera	MT	32
IT	75020	Nova Siri Stazione	Basilicata	Matera	MT	33
IT	75021	Colobraro	Basilicata	Matera	MT	34
IT	75022	Irsina	Basilicata	Matera	MT	35
IT	75022	Taccone	Basilicata	Matera	MT	36
IT	75023	Montalbano Jonico	Basilicata	Matera	MT	37
IT	75024	Montescaglioso	Basilicata	Matera	MT	38
IT	75025	Policoro	Basilicata	Matera	MT	39
IT	75026	Rotondella	Basilicata	Matera	MT	40
IT	75027	San Giorgio Lucano	Basilicata	Matera	MT	41
IT	75028	Caprarico	Basilicata	Matera	MT	42
IT	75028	Gannano	Basilicata	Matera	MT	43
IT	75028	Tursi	Basilicata	Matera	MT	44
IT	75029	Valsinni	Basilicata	Matera	MT	45
IT	75100	Venusio	Basilicata	Matera	MT	46
IT	75100	La Martella	Basilicata	Matera	MT	47
IT	75100	Matera	Basilicata	Matera	MT	48
IT	85010	Gallicchio	Basilicata	Potenza	PZ	49
IT	85010	Vaglio Basilicata	Basilicata	Potenza	PZ	50
IT	85010	Albano Di Lucania	Basilicata	Potenza	PZ	51
IT	85010	Castelmezzano	Basilicata	Potenza	PZ	52
IT	85010	Pignola	Basilicata	Potenza	PZ	53
IT	85010	Armento	Basilicata	Potenza	PZ	54
IT	85010	Cancellara	Basilicata	Potenza	PZ	55
IT	85010	Pantano	Basilicata	Potenza	PZ	56
IT	85010	Rifreddo	Basilicata	Potenza	PZ	57
IT	85010	Guardia Perticara	Basilicata	Potenza	PZ	58
IT	85010	Brindisi Montagna	Basilicata	Potenza	PZ	59
IT	85010	Pietrapertosa	Basilicata	Potenza	PZ	60
IT	85010	Abriola	Basilicata	Potenza	PZ	61
IT	85010	Madonna Del Pantano	Basilicata	Potenza	PZ	62
IT	85010	Campomaggiore	Basilicata	Potenza	PZ	63
IT	85010	Missanello	Basilicata	Potenza	PZ	64
IT	85010	Anzi	Basilicata	Potenza	PZ	65
IT	85010	San Chirico Nuovo	Basilicata	Potenza	PZ	66
IT	85010	Calvello	Basilicata	Potenza	PZ	67
IT	85010	Banzi	Basilicata	Potenza	PZ	68
IT	85011	Acerenza	Basilicata	Potenza	PZ	69
IT	85012	Corleto Perticara	Basilicata	Potenza	PZ	70
IT	85013	Genzano Di Lucania	Basilicata	Potenza	PZ	71
IT	85014	Laurenzana	Basilicata	Potenza	PZ	72
IT	85015	Oppido Lucano	Basilicata	Potenza	PZ	73
IT	85016	San Giorgio	Basilicata	Potenza	PZ	74
IT	85016	Pietragalla	Basilicata	Potenza	PZ	75
IT	85017	Tolve	Basilicata	Potenza	PZ	76
IT	85018	Trivigno	Basilicata	Potenza	PZ	77
IT	85020	Pescopagano	Basilicata	Potenza	PZ	78
IT	85020	Montemilone	Basilicata	Potenza	PZ	79
IT	85020	Ginestra	Basilicata	Potenza	PZ	80
IT	85020	Dragonetti	Basilicata	Potenza	PZ	81
IT	85020	Maschito	Basilicata	Potenza	PZ	82
IT	85020	Ripacandida	Basilicata	Potenza	PZ	83
IT	85020	Sterpito Di Sopra	Basilicata	Potenza	PZ	84
IT	85020	Filiano	Basilicata	Potenza	PZ	85
IT	85020	Sterpito Di Sotto	Basilicata	Potenza	PZ	86
IT	85020	Ruvo Del Monte	Basilicata	Potenza	PZ	87
IT	85020	Scalera	Basilicata	Potenza	PZ	88
IT	85020	Lagopesole	Basilicata	Potenza	PZ	89
IT	85020	Atella	Basilicata	Potenza	PZ	90
IT	85020	Sant'Ilario	Basilicata	Potenza	PZ	91
IT	85020	Sterpito	Basilicata	Potenza	PZ	92
IT	85020	Rapone	Basilicata	Potenza	PZ	93
IT	85020	San Nicola	Basilicata	Potenza	PZ	94
IT	85020	Sant'Andrea	Basilicata	Potenza	PZ	95
IT	85020	Piano San Nicola	Basilicata	Potenza	PZ	96
IT	85020	Avigliano Scalo	Basilicata	Potenza	PZ	97
IT	85020	Sant'Angelo Di Avigliano	Basilicata	Potenza	PZ	98
IT	85020	San Fele	Basilicata	Potenza	PZ	99
IT	85020	San Giorgio Di Pietragalla	Basilicata	Potenza	PZ	100
IT	85021	Possidente	Basilicata	Potenza	PZ	101
IT	85021	Piano Del Conte	Basilicata	Potenza	PZ	102
IT	85021	San Cataldo	Basilicata	Potenza	PZ	103
IT	85021	Sant'Angelo	Basilicata	Potenza	PZ	104
IT	85021	Castel Lagopesole	Basilicata	Potenza	PZ	105
IT	85021	Avigliano	Basilicata	Potenza	PZ	106
IT	85021	San Cataldo Di Bella	Basilicata	Potenza	PZ	107
IT	85022	Barile	Basilicata	Potenza	PZ	108
IT	85023	Forenza	Basilicata	Potenza	PZ	109
IT	85024	Lavello	Basilicata	Potenza	PZ	110
IT	85024	Gaudiano	Basilicata	Potenza	PZ	111
IT	85025	Leonessa Di Melfi	Basilicata	Potenza	PZ	112
IT	85025	Foggiano	Basilicata	Potenza	PZ	113
IT	85025	Melfi	Basilicata	Potenza	PZ	114
IT	85026	Palazzo San Gervasio	Basilicata	Potenza	PZ	115
IT	85027	Rapolla	Basilicata	Potenza	PZ	116
IT	85028	Monticchio Bagni	Basilicata	Potenza	PZ	117
IT	85028	Monticchio	Basilicata	Potenza	PZ	118
IT	85028	Rionero In Vulture	Basilicata	Potenza	PZ	119
IT	85029	Venosa	Basilicata	Potenza	PZ	120
IT	85030	San Costantino Albanese	Basilicata	Potenza	PZ	121
IT	85030	San Paolo Albanese	Basilicata	Potenza	PZ	122
IT	85030	Calvera	Basilicata	Potenza	PZ	123
IT	85030	Terranova Di Pollino	Basilicata	Potenza	PZ	124
IT	85030	Cersosimo	Basilicata	Potenza	PZ	125
IT	85030	San Chirico Raparo	Basilicata	Potenza	PZ	126
IT	85030	San Severino Lucano	Basilicata	Potenza	PZ	127
IT	85030	Castronuovo Di Sant'Andrea	Basilicata	Potenza	PZ	128
IT	85030	Villaneto	Basilicata	Potenza	PZ	129
IT	85030	Mezzana Salice	Basilicata	Potenza	PZ	130
IT	85030	San Martino D'Agri	Basilicata	Potenza	PZ	131
IT	85030	Carbone	Basilicata	Potenza	PZ	132
IT	85030	Mezzana	Basilicata	Potenza	PZ	133
IT	85030	Casa Del Conte	Basilicata	Potenza	PZ	134
IT	85031	Frusci	Basilicata	Potenza	PZ	135
IT	85031	Castelsaraceno	Basilicata	Potenza	PZ	136
IT	85031	Miraldo	Basilicata	Potenza	PZ	137
IT	85032	Teana	Basilicata	Potenza	PZ	138
IT	85032	Chiaromonte	Basilicata	Potenza	PZ	139
IT	85033	Episcopia	Basilicata	Potenza	PZ	140
IT	85034	Francavilla In Sinni	Basilicata	Potenza	PZ	141
IT	85034	Fardella	Basilicata	Potenza	PZ	142
IT	85035	Noepoli	Basilicata	Potenza	PZ	143
IT	85036	Roccanova	Basilicata	Potenza	PZ	144
IT	85037	Sant'Arcangelo	Basilicata	Potenza	PZ	145
IT	85037	San Brancato	Basilicata	Potenza	PZ	146
IT	85038	Senise	Basilicata	Potenza	PZ	147
IT	85039	Spinoso	Basilicata	Potenza	PZ	148
IT	85040	Nemoli	Basilicata	Potenza	PZ	149
IT	85040	Rivello	Basilicata	Potenza	PZ	150
IT	85040	San Costantino Di Rivello	Basilicata	Potenza	PZ	151
IT	85040	Castelluccio Superiore	Basilicata	Potenza	PZ	152
IT	85040	Castelluccio Inferiore	Basilicata	Potenza	PZ	153
IT	85040	Viggianello	Basilicata	Potenza	PZ	154
IT	85040	San Costantino	Basilicata	Potenza	PZ	155
IT	85040	Pedali Di Viggianello	Basilicata	Potenza	PZ	156
IT	85042	Lagonegro	Basilicata	Potenza	PZ	157
IT	85043	Latronico	Basilicata	Potenza	PZ	158
IT	85043	Mileo	Basilicata	Potenza	PZ	159
IT	85043	Cerri	Basilicata	Potenza	PZ	160
IT	85043	Magnano	Basilicata	Potenza	PZ	161
IT	85043	Agromonte	Basilicata	Potenza	PZ	162
IT	85044	Cogliandrino	Basilicata	Potenza	PZ	163
IT	85044	Galdo Di Lauria	Basilicata	Potenza	PZ	164
IT	85044	Lauria	Basilicata	Potenza	PZ	165
IT	85044	Seluci	Basilicata	Potenza	PZ	166
IT	85044	Pecorone	Basilicata	Potenza	PZ	167
IT	85044	Galdo	Basilicata	Potenza	PZ	168
IT	85044	Lauria Inferiore	Basilicata	Potenza	PZ	169
IT	85044	Lauria Superiore	Basilicata	Potenza	PZ	170
IT	85046	Maratea	Basilicata	Potenza	PZ	171
IT	85046	Massa	Basilicata	Potenza	PZ	172
IT	85046	Maratea Porto	Basilicata	Potenza	PZ	173
IT	85046	Acquafredda	Basilicata	Potenza	PZ	174
IT	85046	Fiumicello Santa Venere	Basilicata	Potenza	PZ	175
IT	85047	Moliterno	Basilicata	Potenza	PZ	176
IT	85048	Rotonda	Basilicata	Potenza	PZ	177
IT	85049	Trecchina	Basilicata	Potenza	PZ	178
IT	85049	Piano Dei Peri	Basilicata	Potenza	PZ	179
IT	85050	Brienza	Basilicata	Potenza	PZ	180
IT	85050	Sarconi	Basilicata	Potenza	PZ	181
IT	85050	Grumento Nova	Basilicata	Potenza	PZ	182
IT	85050	Savoia Di Lucania	Basilicata	Potenza	PZ	183
IT	85050	Baragiano	Basilicata	Potenza	PZ	184
IT	85050	Balvano	Basilicata	Potenza	PZ	185
IT	85050	Sasso Di Castalda	Basilicata	Potenza	PZ	186
IT	85050	Sant'Angelo Le Fratte	Basilicata	Potenza	PZ	187
IT	85050	Castelgrande	Basilicata	Potenza	PZ	188
IT	85050	Satriano Di Lucania	Basilicata	Potenza	PZ	189
IT	85050	Villa D'Agri	Basilicata	Potenza	PZ	190
IT	85050	Paterno	Basilicata	Potenza	PZ	191
IT	85050	Baragiano Scalo	Basilicata	Potenza	PZ	192
IT	85050	Tito	Basilicata	Potenza	PZ	193
IT	85050	Marsicovetere	Basilicata	Potenza	PZ	194
IT	85050	Scalo Di Baragiano	Basilicata	Potenza	PZ	195
IT	85050	Tito Scalo	Basilicata	Potenza	PZ	196
IT	85051	Sant'Antonio Casalini	Basilicata	Potenza	PZ	197
IT	85051	Bella	Basilicata	Potenza	PZ	198
IT	85052	Galaino	Basilicata	Potenza	PZ	199
IT	85052	Marsico Nuovo	Basilicata	Potenza	PZ	200
IT	85052	Pergola	Basilicata	Potenza	PZ	201
IT	85053	Montemurro	Basilicata	Potenza	PZ	202
IT	85054	Muro Lucano	Basilicata	Potenza	PZ	203
IT	85054	Capo Di Giano	Basilicata	Potenza	PZ	204
IT	85055	Picerno	Basilicata	Potenza	PZ	205
IT	85056	Ruoti	Basilicata	Potenza	PZ	206
IT	85057	Tramutola	Basilicata	Potenza	PZ	207
IT	85058	Vietri Di Potenza	Basilicata	Potenza	PZ	208
IT	85058	Mosileo	Basilicata	Potenza	PZ	209
IT	85059	Viggiano	Basilicata	Potenza	PZ	210
IT	85100	Montocchio	Basilicata	Potenza	PZ	211
IT	85100	Potenza	Basilicata	Potenza	PZ	212
IT	85100	Giuliano	Basilicata	Potenza	PZ	213
IT	87010	Lungro	Calabria	Cosenza	CS	214
IT	87010	San Sosti	Calabria	Cosenza	CS	215
IT	87010	Policastrello	Calabria	Cosenza	CS	216
IT	87010	Santa Maria Le Grotte	Calabria	Cosenza	CS	217
IT	87010	San Martino Di Finita	Calabria	Cosenza	CS	218
IT	87010	Civita	Calabria	Cosenza	CS	219
IT	87010	Eianina	Calabria	Cosenza	CS	220
IT	87010	Lattarico	Calabria	Cosenza	CS	221
IT	87010	Rota Greca	Calabria	Cosenza	CS	222
IT	87010	Cervicati	Calabria	Cosenza	CS	223
IT	87010	Mottafollone	Calabria	Cosenza	CS	224
IT	87010	Acquaformosa	Calabria	Cosenza	CS	225
IT	87010	Sant'Agata Di Esaro	Calabria	Cosenza	CS	226
IT	87010	Torano Castello	Calabria	Cosenza	CS	227
IT	87010	Regina	Calabria	Cosenza	CS	228
IT	87010	Ioggi	Calabria	Cosenza	CS	229
IT	87010	Firmo	Calabria	Cosenza	CS	230
IT	87010	San Donato Di Ninea	Calabria	Cosenza	CS	231
IT	87010	Saracena	Calabria	Cosenza	CS	232
IT	87010	Torano Castello Scalo	Calabria	Cosenza	CS	233
IT	87010	Sartano	Calabria	Cosenza	CS	234
IT	87010	Terranova Da Sibari	Calabria	Cosenza	CS	235
IT	87010	Frascineto	Calabria	Cosenza	CS	236
IT	87010	Santa Caterina Albanese	Calabria	Cosenza	CS	237
IT	87010	San Basile	Calabria	Cosenza	CS	238
IT	87010	Malvito	Calabria	Cosenza	CS	239
IT	87011	Lauropoli	Calabria	Cosenza	CS	240
IT	87011	Pianoscafo	Calabria	Cosenza	CS	241
IT	87011	Doria	Calabria	Cosenza	CS	242
IT	87011	Cassano Allo Ionio	Calabria	Cosenza	CS	243
IT	87011	Sibari	Calabria	Cosenza	CS	244
IT	87011	Sibari Stazione	Calabria	Cosenza	CS	245
IT	87011	Lattughelle	Calabria	Cosenza	CS	246
IT	87012	Castrovillari	Calabria	Cosenza	CS	247
IT	87012	Vigne Di Castrovillari	Calabria	Cosenza	CS	248
IT	87013	Fagnano Castello	Calabria	Cosenza	CS	249
IT	87014	Laino Borgo	Calabria	Cosenza	CS	250
IT	87015	Laino Castello	Calabria	Cosenza	CS	251
IT	87016	Morano Calabro	Calabria	Cosenza	CS	252
IT	87017	Roggiano Gravina	Calabria	Cosenza	CS	253
IT	87018	San Marco Argentano	Calabria	Cosenza	CS	254
IT	87018	San Marco Argentano Stazione	Calabria	Cosenza	CS	255
IT	87018	San Marco Roggiano Stazione	Calabria	Cosenza	CS	256
IT	87019	Spezzano Albanese	Calabria	Cosenza	CS	257
IT	87019	Spezzano Albanese Terme	Calabria	Cosenza	CS	258
IT	87019	Spezzano Albanese Stazione	Calabria	Cosenza	CS	259
IT	87020	Sangineto Lido	Calabria	Cosenza	CS	260
IT	87020	Tortora	Calabria	Cosenza	CS	261
IT	87020	Cittadella Del Capo	Calabria	Cosenza	CS	262
IT	87020	Guardia Piemontese Marina	Calabria	Cosenza	CS	263
IT	87020	Tortora Marina	Calabria	Cosenza	CS	264
IT	87020	Acquappesa	Calabria	Cosenza	CS	265
IT	87020	Marina Di Tortora	Calabria	Cosenza	CS	266
IT	87020	Marcellina	Calabria	Cosenza	CS	267
IT	87020	Orsomarso	Calabria	Cosenza	CS	268
IT	87020	Santa Domenica Talao	Calabria	Cosenza	CS	269
IT	87020	Papasidero	Calabria	Cosenza	CS	270
IT	87020	Grisolia	Calabria	Cosenza	CS	271
IT	87020	Le Crete	Calabria	Cosenza	CS	272
IT	87020	Guardia Piemontese	Calabria	Cosenza	CS	273
IT	87020	Bonifati	Calabria	Cosenza	CS	274
IT	87020	Maiera'	Calabria	Cosenza	CS	275
IT	87020	Torrevecchia	Calabria	Cosenza	CS	276
IT	87020	Verbicaro	Calabria	Cosenza	CS	277
IT	87020	Santa Maria Del Cedro	Calabria	Cosenza	CS	278
IT	87020	Buonvicino	Calabria	Cosenza	CS	279
IT	87020	Granata	Calabria	Cosenza	CS	280
IT	87020	Acquappesa Marina	Calabria	Cosenza	CS	281
IT	87020	Guardia Piemontese Terme	Calabria	Cosenza	CS	282
IT	87020	San Nicola Arcella	Calabria	Cosenza	CS	283
IT	87020	Sangineto	Calabria	Cosenza	CS	284
IT	87020	Aieta	Calabria	Cosenza	CS	285
IT	87020	Intavolata	Calabria	Cosenza	CS	286
IT	87021	Laise	Calabria	Cosenza	CS	287
IT	87021	Marina Di Belvedere Marittimo	Calabria	Cosenza	CS	288
IT	87021	Belvedere Marittimo	Calabria	Cosenza	CS	289
IT	87022	Battendieri	Calabria	Cosenza	CS	290
IT	87022	Cetraro	Calabria	Cosenza	CS	291
IT	87022	San Filippo	Calabria	Cosenza	CS	292
IT	87022	Cetraro Marina	Calabria	Cosenza	CS	293
IT	87022	Sant'Angelo Di Cetraro	Calabria	Cosenza	CS	294
IT	87022	Sant'Angelo	Calabria	Cosenza	CS	295
IT	87023	Diamante	Calabria	Cosenza	CS	296
IT	87023	Cirella	Calabria	Cosenza	CS	297
IT	87024	Scarcelli	Calabria	Cosenza	CS	298
IT	87024	Cariglio	Calabria	Cosenza	CS	299
IT	87024	Marina Di Fuscaldo	Calabria	Cosenza	CS	300
IT	87024	Fuscaldo	Calabria	Cosenza	CS	301
IT	87026	Mormanno	Calabria	Cosenza	CS	302
IT	87027	San Miceli	Calabria	Cosenza	CS	303
IT	87027	Fosse	Calabria	Cosenza	CS	304
IT	87027	Paola	Calabria	Cosenza	CS	305
IT	87027	Paola Marina	Calabria	Cosenza	CS	306
IT	87027	Paola Santuario	Calabria	Cosenza	CS	307
IT	87027	Santuario San Francesco	Calabria	Cosenza	CS	308
IT	87028	Praia A Mare	Calabria	Cosenza	CS	309
IT	87029	Scalea	Calabria	Cosenza	CS	310
IT	87030	Serra D'Aiello	Calabria	Cosenza	CS	311
IT	87030	San Pietro In Amantea	Calabria	Cosenza	CS	312
IT	87030	Reggio	Calabria	Cosenza	CS	313
IT	87030	Carolei	Calabria	Cosenza	CS	314
IT	87030	Scornavacca	Calabria	Cosenza	CS	315
IT	87030	Malito	Calabria	Cosenza	CS	316
IT	87030	Savuto	Calabria	Cosenza	CS	317
IT	87030	Longobardi Marina	Calabria	Cosenza	CS	318
IT	87030	Savuto Di Cleto	Calabria	Cosenza	CS	319
IT	87030	Belsito	Calabria	Cosenza	CS	320
IT	87030	Domanico	Calabria	Cosenza	CS	321
IT	87030	San Vincenzo La Costa	Calabria	Cosenza	CS	322
IT	87030	Fiumefreddo Bruzio	Calabria	Cosenza	CS	323
IT	87030	Falconara Albanese	Calabria	Cosenza	CS	324
IT	87030	San Biase	Calabria	Cosenza	CS	325
IT	87030	Vadue	Calabria	Cosenza	CS	326
IT	87030	Cleto	Calabria	Cosenza	CS	327
IT	87030	Torremezzo	Calabria	Cosenza	CS	328
IT	87030	Gesuiti	Calabria	Cosenza	CS	329
IT	87030	Longobardi	Calabria	Cosenza	CS	330
IT	87030	Torremezzo Di Falconara	Calabria	Cosenza	CS	331
IT	87030	Marina Di Fiumefreddo Bruzio	Calabria	Cosenza	CS	332
IT	87030	Stazione Di Fiumefreddo Bruzio	Calabria	Cosenza	CS	333
IT	87031	Aiello Calabro	Calabria	Cosenza	CS	334
IT	87032	Corica	Calabria	Cosenza	CS	335
IT	87032	Amantea	Calabria	Cosenza	CS	336
IT	87032	Campora San Giovanni	Calabria	Cosenza	CS	337
IT	87032	Amantea Marina	Calabria	Cosenza	CS	338
IT	87033	Vadi	Calabria	Cosenza	CS	339
IT	87033	Belmonte Calabro	Calabria	Cosenza	CS	340
IT	87033	Belmonte Calabro Marina	Calabria	Cosenza	CS	341
IT	87034	Grimaldi	Calabria	Cosenza	CS	342
IT	87035	Lago	Calabria	Cosenza	CS	343
IT	87035	Greci	Calabria	Cosenza	CS	344
IT	87035	Terrati	Calabria	Cosenza	CS	345
IT	87035	Aria Di Lupi	Calabria	Cosenza	CS	346
IT	87036	Surdo	Calabria	Cosenza	CS	347
IT	87036	Santo Stefano	Calabria	Cosenza	CS	348
IT	87036	Quattromiglia	Calabria	Cosenza	CS	349
IT	87036	Arcavacata	Calabria	Cosenza	CS	350
IT	87036	Castiglione Cosentino Stazione	Calabria	Cosenza	CS	351
IT	87036	Rende	Calabria	Cosenza	CS	352
IT	87036	Roges	Calabria	Cosenza	CS	353
IT	87036	Commenda	Calabria	Cosenza	CS	354
IT	87037	Bucita	Calabria	Cosenza	CS	355
IT	87037	San Fili	Calabria	Cosenza	CS	356
IT	87038	Pollella	Calabria	Cosenza	CS	357
IT	87038	San Lucido	Calabria	Cosenza	CS	358
IT	87040	Timparello	Calabria	Cosenza	CS	359
IT	87040	Cerzeto	Calabria	Cosenza	CS	360
IT	87040	Rosario	Calabria	Cosenza	CS	361
IT	87040	Taverna Di Montalto Uffugo	Calabria	Cosenza	CS	362
IT	87040	San Bartolo	Calabria	Cosenza	CS	363
IT	87040	Rose	Calabria	Cosenza	CS	364
IT	87040	Tarsia	Calabria	Cosenza	CS	365
IT	87040	Marano Principato	Calabria	Cosenza	CS	366
IT	87040	Tivolille	Calabria	Cosenza	CS	367
IT	87040	Andreotta	Calabria	Cosenza	CS	368
IT	87040	Maione	Calabria	Cosenza	CS	369
IT	87040	Andreotta Di Castrolibero	Calabria	Cosenza	CS	370
IT	87040	Altilia	Calabria	Cosenza	CS	371
IT	87040	San Benedetto Ullano	Calabria	Cosenza	CS	372
IT	87040	Timparello Di Luzzi	Calabria	Cosenza	CS	373
IT	87040	Paterno Calabro	Calabria	Cosenza	CS	374
IT	87040	Deposito Di Luzzi	Calabria	Cosenza	CS	375
IT	87040	Malavicina	Calabria	Cosenza	CS	376
IT	87040	San Giacomo Di Cerzeto	Calabria	Cosenza	CS	377
IT	87040	Mendicino	Calabria	Cosenza	CS	378
IT	87040	Mongrassano Stazione	Calabria	Cosenza	CS	379
IT	87040	Mongrassano	Calabria	Cosenza	CS	380
IT	87040	Castrolibero	Calabria	Cosenza	CS	381
IT	87040	Marano Marchesato	Calabria	Cosenza	CS	382
IT	87040	Zumpano	Calabria	Cosenza	CS	383
IT	87040	Castiglione Cosentino	Calabria	Cosenza	CS	384
IT	87040	San Giacomo	Calabria	Cosenza	CS	385
IT	87040	Stazione Di Mongrassano	Calabria	Cosenza	CS	386
IT	87040	Parenti	Calabria	Cosenza	CS	387
IT	87040	Montalto Uffugo Scalo	Calabria	Cosenza	CS	388
IT	87040	Cavallerizzo	Calabria	Cosenza	CS	389
IT	87040	Casal Di Basso	Calabria	Cosenza	CS	390
IT	87040	Luzzi	Calabria	Cosenza	CS	391
IT	87040	Ortomatera	Calabria	Cosenza	CS	392
IT	87040	San Lorenzo Del Vallo	Calabria	Cosenza	CS	393
IT	87041	Serricella	Calabria	Cosenza	CS	394
IT	87041	Acri	Calabria	Cosenza	CS	395
IT	87041	Montagnola	Calabria	Cosenza	CS	396
IT	87041	San Giacomo D'Acri	Calabria	Cosenza	CS	397
IT	87041	Duglia	Calabria	Cosenza	CS	398
IT	87042	Altomonte	Calabria	Cosenza	CS	399
IT	87043	Bisignano	Calabria	Cosenza	CS	400
IT	87044	Cerisano	Calabria	Cosenza	CS	401
IT	87045	Tessano	Calabria	Cosenza	CS	402
IT	87045	Dipignano	Calabria	Cosenza	CS	403
IT	87045	Laurignano	Calabria	Cosenza	CS	404
IT	87046	Caldopiano	Calabria	Cosenza	CS	405
IT	87046	Montalto Uffugo	Calabria	Cosenza	CS	406
IT	87046	Parantoro	Calabria	Cosenza	CS	407
IT	87046	Vaccarizzo	Calabria	Cosenza	CS	408
IT	87046	Vaccarizzo Di Montalto	Calabria	Cosenza	CS	409
IT	87047	San Pietro In Guarano	Calabria	Cosenza	CS	410
IT	87047	Redipiano	Calabria	Cosenza	CS	411
IT	87047	San Benedetto In Guarano	Calabria	Cosenza	CS	412
IT	87048	Santa Sofia D'Epiro	Calabria	Cosenza	CS	413
IT	87050	Marzi	Calabria	Cosenza	CS	414
IT	87050	Serra Pedace	Calabria	Cosenza	CS	415
IT	87050	Figline Vegliaturo	Calabria	Cosenza	CS	416
IT	87050	Silvana Mansio	Calabria	Cosenza	CS	417
IT	87050	Pedace	Calabria	Cosenza	CS	418
IT	87050	Panettieri	Calabria	Cosenza	CS	419
IT	87050	Casole Bruzio	Calabria	Cosenza	CS	420
IT	87050	Trenta	Calabria	Cosenza	CS	421
IT	87050	Carpanzano	Calabria	Cosenza	CS	422
IT	87050	Piane Crati	Calabria	Cosenza	CS	423
IT	87050	Lappano	Calabria	Cosenza	CS	424
IT	87050	Perito	Calabria	Cosenza	CS	425
IT	87050	Mangone	Calabria	Cosenza	CS	426
IT	87050	Colosimi	Calabria	Cosenza	CS	427
IT	87050	Borboruso	Calabria	Cosenza	CS	428
IT	87050	Spezzano Piccolo	Calabria	Cosenza	CS	429
IT	87050	Rovito	Calabria	Cosenza	CS	430
IT	87050	Bianchi	Calabria	Cosenza	CS	431
IT	87050	Pian Del Lago	Calabria	Cosenza	CS	432
IT	87050	Pedivigliano	Calabria	Cosenza	CS	433
IT	87050	Morelli	Calabria	Cosenza	CS	434
IT	87050	Pietrafitta	Calabria	Cosenza	CS	435
IT	87050	Magli	Calabria	Cosenza	CS	436
IT	87050	Cellara	Calabria	Cosenza	CS	437
IT	87051	Aprigliano	Calabria	Cosenza	CS	438
IT	87051	Vico	Calabria	Cosenza	CS	439
IT	87051	Camarda Di Aprigliano	Calabria	Cosenza	CS	440
IT	87052	Camigliatello	Calabria	Cosenza	CS	441
IT	87052	Fago Del Soldato	Calabria	Cosenza	CS	442
IT	87052	Croce Di Magara	Calabria	Cosenza	CS	443
IT	87052	Camigliatello Silano	Calabria	Cosenza	CS	444
IT	87052	Moccone	Calabria	Cosenza	CS	445
IT	87053	Celico	Calabria	Cosenza	CS	446
IT	87054	Rogliano	Calabria	Cosenza	CS	447
IT	87054	Saliano	Calabria	Cosenza	CS	448
IT	87055	Lorica	Calabria	Cosenza	CS	449
IT	87055	San Giovanni In Fiore	Calabria	Cosenza	CS	450
IT	87055	Monte Oliveto	Calabria	Cosenza	CS	451
IT	87056	Santo Stefano Di Rogliano	Calabria	Cosenza	CS	452
IT	87057	Scigliano	Calabria	Cosenza	CS	453
IT	87057	Diano	Calabria	Cosenza	CS	454
IT	87057	Calvisi	Calabria	Cosenza	CS	455
IT	87058	Spezzano Della Sila	Calabria	Cosenza	CS	456
IT	87060	Scala Coeli	Calabria	Cosenza	CS	457
IT	87060	Marinella	Calabria	Cosenza	CS	458
IT	87060	Calopezzati	Calabria	Cosenza	CS	459
IT	87060	Mirto	Calabria	Cosenza	CS	460
IT	87060	Crosia	Calabria	Cosenza	CS	461
IT	87060	Cropalati	Calabria	Cosenza	CS	462
IT	87060	Paludi	Calabria	Cosenza	CS	463
IT	87060	San Cosmo Albanese	Calabria	Cosenza	CS	464
IT	87060	San Giorgio Albanese	Calabria	Cosenza	CS	465
IT	87060	Bocchigliero	Calabria	Cosenza	CS	466
IT	87060	Pietrapaola	Calabria	Cosenza	CS	467
IT	87060	Mandatoriccio	Calabria	Cosenza	CS	468
IT	87060	Camigliano	Calabria	Cosenza	CS	469
IT	87060	Terravecchia	Calabria	Cosenza	CS	470
IT	87060	Caloveto	Calabria	Cosenza	CS	471
IT	87060	San Morello	Calabria	Cosenza	CS	472
IT	87060	Pietrapaola Stazione	Calabria	Cosenza	CS	473
IT	87060	Vecchiarello	Calabria	Cosenza	CS	474
IT	87060	Vaccarizzo Albanese	Calabria	Cosenza	CS	475
IT	87061	Campana	Calabria	Cosenza	CS	476
IT	87062	Cariati	Calabria	Cosenza	CS	477
IT	87062	Cariati Marina	Calabria	Cosenza	CS	478
IT	87064	Corigliano Scalo	Calabria	Cosenza	CS	479
IT	87064	Marina Di Schiavonea	Calabria	Cosenza	CS	480
IT	87064	Villaggio Frasso	Calabria	Cosenza	CS	481
IT	87064	Fabrizio	Calabria	Cosenza	CS	482
IT	87064	Cantinella	Calabria	Cosenza	CS	483
IT	87064	Schiavonea	Calabria	Cosenza	CS	484
IT	87064	Corigliano Calabro Stazione	Calabria	Cosenza	CS	485
IT	87064	Corigliano Calabro	Calabria	Cosenza	CS	486
IT	87066	Longobucco	Calabria	Cosenza	CS	487
IT	87066	Destro	Calabria	Cosenza	CS	488
IT	87067	Rossano	Calabria	Cosenza	CS	489
IT	87067	Amica	Calabria	Cosenza	CS	490
IT	87067	Rossano Stazione	Calabria	Cosenza	CS	491
IT	87067	Piragineti	Calabria	Cosenza	CS	492
IT	87069	San Demetrio Corone	Calabria	Cosenza	CS	493
IT	87069	Macchia Albanese	Calabria	Cosenza	CS	494
IT	87070	San Lorenzo Bellizzi	Calabria	Cosenza	CS	495
IT	87070	Roseto Capo Spulico	Calabria	Cosenza	CS	496
IT	87070	Montegiordano Marina	Calabria	Cosenza	CS	497
IT	87070	Farneta	Calabria	Cosenza	CS	498
IT	87070	Nocara	Calabria	Cosenza	CS	499
IT	87070	Plataci	Calabria	Cosenza	CS	500
IT	87070	Castroregio	Calabria	Cosenza	CS	501
IT	87070	Canna	Calabria	Cosenza	CS	502
IT	87070	Borgata Marina	Calabria	Cosenza	CS	503
IT	87070	Albidona	Calabria	Cosenza	CS	504
IT	87070	Alessandria Del Carretto	Calabria	Cosenza	CS	505
IT	87070	Montegiordano	Calabria	Cosenza	CS	506
IT	87070	Cerchiara Di Calabria	Calabria	Cosenza	CS	507
IT	87070	Piana Di Cerchiara	Calabria	Cosenza	CS	508
IT	87070	Roseto Capo Spulico Stazione	Calabria	Cosenza	CS	509
IT	87071	Amendolara Marina	Calabria	Cosenza	CS	510
IT	87071	Amendolara	Calabria	Cosenza	CS	511
IT	87072	Francavilla Marittima	Calabria	Cosenza	CS	512
IT	87073	Oriolo	Calabria	Cosenza	CS	513
IT	87074	Rocca Imperiale	Calabria	Cosenza	CS	514
IT	87074	Rocca Imperiale Marina	Calabria	Cosenza	CS	515
IT	87075	Trebisacce	Calabria	Cosenza	CS	516
IT	87076	Villapiana Scalo	Calabria	Cosenza	CS	517
IT	87076	Villapiana Lido	Calabria	Cosenza	CS	518
IT	87076	Villapiana	Calabria	Cosenza	CS	519
IT	87076	Torre Cerchiar	Calabria	Cosenza	CS	520
IT	87100	Cosenza	Calabria	Cosenza	CS	521
IT	87100	Donnici Superiore	Calabria	Cosenza	CS	522
IT	87100	Donnici Inferiore	Calabria	Cosenza	CS	523
IT	87100	Borgo Partenope	Calabria	Cosenza	CS	524
IT	87100	Casali	Calabria	Cosenza	CS	525
IT	87100	Sant'Ippolito Di Cosenza	Calabria	Cosenza	CS	526
IT	87100	Sanvito	Calabria	Cosenza	CS	527
IT	88020	Cortale	Calabria	Catanzaro	CZ	528
IT	88020	Jacurso	Calabria	Catanzaro	CZ	529
IT	88021	Borgia	Calabria	Catanzaro	CZ	530
IT	88021	Roccelletta	Calabria	Catanzaro	CZ	531
IT	88021	San Floro	Calabria	Catanzaro	CZ	532
IT	88022	Acconia	Calabria	Catanzaro	CZ	533
IT	88022	Curinga	Calabria	Catanzaro	CZ	534
IT	88024	Girifalco	Calabria	Catanzaro	CZ	535
IT	88025	Maida	Calabria	Catanzaro	CZ	536
IT	88025	San Pietro A Maida	Calabria	Catanzaro	CZ	537
IT	88040	Castagna	Calabria	Catanzaro	CZ	538
IT	88040	Martelletto	Calabria	Catanzaro	CZ	539
IT	88040	Conflenti Inferiore	Calabria	Catanzaro	CZ	540
IT	88040	Miglierina	Calabria	Catanzaro	CZ	541
IT	88040	Angoli	Calabria	Catanzaro	CZ	542
IT	88040	Motta Santa Lucia	Calabria	Catanzaro	CZ	543
IT	88040	Martirano Lombardo	Calabria	Catanzaro	CZ	544
IT	88040	Accaria Rosaria	Calabria	Catanzaro	CZ	545
IT	88040	San Mango D'Aquino	Calabria	Catanzaro	CZ	546
IT	88040	Gizzeria Lido	Calabria	Catanzaro	CZ	547
IT	88040	Amato	Calabria	Catanzaro	CZ	548
IT	88040	Martirano	Calabria	Catanzaro	CZ	549
IT	88040	Cancello	Calabria	Catanzaro	CZ	550
IT	88040	Carlopoli	Calabria	Catanzaro	CZ	551
IT	88040	Platania	Calabria	Catanzaro	CZ	552
IT	88040	San Pietro Apostolo	Calabria	Catanzaro	CZ	553
IT	88040	Conflenti	Calabria	Catanzaro	CZ	554
IT	88040	Feroleto Antico	Calabria	Catanzaro	CZ	555
IT	88040	Pratora Sarrottino	Calabria	Catanzaro	CZ	556
IT	88040	Serrastretta	Calabria	Catanzaro	CZ	557
IT	88040	San Mazzeo	Calabria	Catanzaro	CZ	558
IT	88040	Settingiano	Calabria	Catanzaro	CZ	559
IT	88040	Ievoli	Calabria	Catanzaro	CZ	560
IT	88040	Pianopoli	Calabria	Catanzaro	CZ	561
IT	88040	San Michele	Calabria	Catanzaro	CZ	562
IT	88040	Accaria	Calabria	Catanzaro	CZ	563
IT	88040	Cicala	Calabria	Catanzaro	CZ	564
IT	88040	Gizzeria	Calabria	Catanzaro	CZ	565
IT	88040	Migliuso	Calabria	Catanzaro	CZ	566
IT	88041	Cerrisi	Calabria	Catanzaro	CZ	567
IT	88041	Adami	Calabria	Catanzaro	CZ	568
IT	88041	Decollatura	Calabria	Catanzaro	CZ	569
IT	88041	San Bernardo	Calabria	Catanzaro	CZ	570
IT	88042	Falerna Scalo	Calabria	Catanzaro	CZ	571
IT	88042	Castiglione Marittimo	Calabria	Catanzaro	CZ	572
IT	88042	Falerna	Calabria	Catanzaro	CZ	573
IT	88044	Marcellinara	Calabria	Catanzaro	CZ	574
IT	88045	Cavora'	Calabria	Catanzaro	CZ	575
IT	88045	Cavora' Di Gimigliano	Calabria	Catanzaro	CZ	576
IT	88045	Gimigliano	Calabria	Catanzaro	CZ	577
IT	88045	Gimigliano Inferiore	Calabria	Catanzaro	CZ	578
IT	88046	Sambiase	Calabria	Catanzaro	CZ	579
IT	88046	Acquafredda	Calabria	Catanzaro	CZ	580
IT	88046	Santa Eufemia Lamezia	Calabria	Catanzaro	CZ	581
IT	88046	San Pietro Lametino	Calabria	Catanzaro	CZ	582
IT	88046	Fronti	Calabria	Catanzaro	CZ	583
IT	88046	Gabella	Calabria	Catanzaro	CZ	584
IT	88046	Lamezia Terme	Calabria	Catanzaro	CZ	585
IT	88046	Zangarona	Calabria	Catanzaro	CZ	586
IT	88046	Bella Di Lamezia Terme	Calabria	Catanzaro	CZ	587
IT	88046	Nicastro	Calabria	Catanzaro	CZ	588
IT	88046	Caronte	Calabria	Catanzaro	CZ	589
IT	88046	Sant'Eufemia Di Lamezia Terme	Calabria	Catanzaro	CZ	590
IT	88046	Zangarona Di Lamezia Terme	Calabria	Catanzaro	CZ	591
IT	88046	Sambiase Di Lamezia Terme	Calabria	Catanzaro	CZ	592
IT	88047	Nocera Terinese	Calabria	Catanzaro	CZ	593
IT	88047	Marina Di Nocera Terinese	Calabria	Catanzaro	CZ	594
IT	88049	San Tommaso	Calabria	Catanzaro	CZ	595
IT	88049	Colla	Calabria	Catanzaro	CZ	596
IT	88049	Soveria Mannelli	Calabria	Catanzaro	CZ	597
IT	88050	Soveria Simeri	Calabria	Catanzaro	CZ	598
IT	88050	Magisano	Calabria	Catanzaro	CZ	599
IT	88050	Uria	Calabria	Catanzaro	CZ	600
IT	88050	Belcastro	Calabria	Catanzaro	CZ	601
IT	88050	Vallefiorita	Calabria	Catanzaro	CZ	602
IT	88050	La Petrizia	Calabria	Catanzaro	CZ	603
IT	88050	Sorbo San Basile	Calabria	Catanzaro	CZ	604
IT	88050	Petrona'	Calabria	Catanzaro	CZ	605
IT	88050	San Pietro Magisano	Calabria	Catanzaro	CZ	606
IT	88050	Cerva	Calabria	Catanzaro	CZ	607
IT	88050	Zagarise	Calabria	Catanzaro	CZ	608
IT	88050	Sellia	Calabria	Catanzaro	CZ	609
IT	88050	Pentone	Calabria	Catanzaro	CZ	610
IT	88050	Sellia Marina	Calabria	Catanzaro	CZ	611
IT	88050	San Pietro	Calabria	Catanzaro	CZ	612
IT	88050	Caraffa Di Catanzaro	Calabria	Catanzaro	CZ	613
IT	88050	Palermiti	Calabria	Catanzaro	CZ	614
IT	88050	Petrizia	Calabria	Catanzaro	CZ	615
IT	88050	Marcedusa	Calabria	Catanzaro	CZ	616
IT	88050	Simeri	Calabria	Catanzaro	CZ	617
IT	88050	Calabricata	Calabria	Catanzaro	CZ	618
IT	88050	Crichi	Calabria	Catanzaro	CZ	619
IT	88050	Amaroni	Calabria	Catanzaro	CZ	620
IT	88050	Andali	Calabria	Catanzaro	CZ	621
IT	88050	Simeri Crichi	Calabria	Catanzaro	CZ	622
IT	88050	Fossato Serralta	Calabria	Catanzaro	CZ	623
IT	88050	Scoppolise	Calabria	Catanzaro	CZ	624
IT	88051	Cropani Marina	Calabria	Catanzaro	CZ	625
IT	88051	Cuturella	Calabria	Catanzaro	CZ	626
IT	88051	Cropani	Calabria	Catanzaro	CZ	627
IT	88054	Sersale	Calabria	Catanzaro	CZ	628
IT	88055	Villaggio Racise	Calabria	Catanzaro	CZ	629
IT	88055	Villaggio Mancuso	Calabria	Catanzaro	CZ	630
IT	88055	Taverna	Calabria	Catanzaro	CZ	631
IT	88055	Albi	Calabria	Catanzaro	CZ	632
IT	88055	San Giovanni	Calabria	Catanzaro	CZ	633
IT	88055	Buturo	Calabria	Catanzaro	CZ	634
IT	88055	San Giovanni D'Albi	Calabria	Catanzaro	CZ	635
IT	88056	Pratora	Calabria	Catanzaro	CZ	636
IT	88056	Tiriolo	Calabria	Catanzaro	CZ	637
IT	88060	Montauro	Calabria	Catanzaro	CZ	638
IT	88060	Badolato	Calabria	Catanzaro	CZ	639
IT	88060	Santa Caterina Dello Ionio	Calabria	Catanzaro	CZ	640
IT	88060	Isca Sullo Ionio	Calabria	Catanzaro	CZ	641
IT	88060	Santa Caterina Dello Ionio Marina	Calabria	Catanzaro	CZ	642
IT	88060	Montepaone Lido	Calabria	Catanzaro	CZ	643
IT	88060	Gasperina	Calabria	Catanzaro	CZ	644
IT	88060	Davoli	Calabria	Catanzaro	CZ	645
IT	88060	Isca Marina	Calabria	Catanzaro	CZ	646
IT	88060	Petrizzi	Calabria	Catanzaro	CZ	647
IT	88060	Montepaone	Calabria	Catanzaro	CZ	648
IT	88060	Sant'Andrea Apostolo Dello Ionio	Calabria	Catanzaro	CZ	649
IT	88060	Gagliato	Calabria	Catanzaro	CZ	650
IT	88060	Sant'Andrea Ionio Marina	Calabria	Catanzaro	CZ	651
IT	88060	Marina Di Davoli	Calabria	Catanzaro	CZ	652
IT	88060	Marina Di Guardavalle	Calabria	Catanzaro	CZ	653
IT	88060	Argusto	Calabria	Catanzaro	CZ	654
IT	81030	Arnone	Campania	Caserta	CE	655
IT	88060	Badolato Marina	Calabria	Catanzaro	CZ	656
IT	88060	Marina Di Sant'Andrea Jonio	Calabria	Catanzaro	CZ	657
IT	88060	San Sostene Marina	Calabria	Catanzaro	CZ	658
IT	88060	Torre Di Ruggiero	Calabria	Catanzaro	CZ	659
IT	88060	Satriano	Calabria	Catanzaro	CZ	660
IT	88060	Montauro Stazione	Calabria	Catanzaro	CZ	661
IT	88060	San Sostene	Calabria	Catanzaro	CZ	662
IT	88062	Cardinale	Calabria	Catanzaro	CZ	663
IT	88062	Novalba	Calabria	Catanzaro	CZ	664
IT	88064	Chiaravalle Centrale	Calabria	Catanzaro	CZ	665
IT	88065	Guardavalle Marina	Calabria	Catanzaro	CZ	666
IT	88065	Guardavalle	Calabria	Catanzaro	CZ	667
IT	88067	Cenadi	Calabria	Catanzaro	CZ	668
IT	88067	Olivadi	Calabria	Catanzaro	CZ	669
IT	88067	San Vito Sullo Ionio	Calabria	Catanzaro	CZ	670
IT	88067	Centrache	Calabria	Catanzaro	CZ	671
IT	88068	Soverato Marina	Calabria	Catanzaro	CZ	672
IT	88068	Soverato Superiore	Calabria	Catanzaro	CZ	673
IT	88068	Soverato	Calabria	Catanzaro	CZ	674
IT	88069	Copanello	Calabria	Catanzaro	CZ	675
IT	88069	Lido Di Squillace	Calabria	Catanzaro	CZ	676
IT	88069	Staletti	Calabria	Catanzaro	CZ	677
IT	88069	Squillace	Calabria	Catanzaro	CZ	678
IT	88069	Squillace Lido	Calabria	Catanzaro	CZ	679
IT	88070	Botricello	Calabria	Catanzaro	CZ	680
IT	88100	Catanzaro	Calabria	Catanzaro	CZ	681
IT	88100	Catanzaro Lido	Calabria	Catanzaro	CZ	682
IT	88100	Cava Di Catanzaro	Calabria	Catanzaro	CZ	683
IT	88100	Sant'Elia	Calabria	Catanzaro	CZ	684
IT	88100	Pontegrande	Calabria	Catanzaro	CZ	685
IT	88100	Siano	Calabria	Catanzaro	CZ	686
IT	88100	Santa Maria Di Catanzaro	Calabria	Catanzaro	CZ	687
IT	88100	Catanzaro Sala	Calabria	Catanzaro	CZ	688
IT	88811	Ciro' Marina	Calabria	Crotone	KR	689
IT	88812	Crucoli Torretta	Calabria	Crotone	KR	690
IT	88812	Crucoli	Calabria	Crotone	KR	691
IT	88812	Torretta	Calabria	Crotone	KR	692
IT	88813	Ciro'	Calabria	Crotone	KR	693
IT	88814	Melissa	Calabria	Crotone	KR	694
IT	88814	Torre Melissa	Calabria	Crotone	KR	695
IT	88815	Marina Di Strongoli	Calabria	Crotone	KR	696
IT	88816	Strongoli	Calabria	Crotone	KR	697
IT	88817	Carfizzi	Calabria	Crotone	KR	698
IT	88817	San Nicola Dell'Alto	Calabria	Crotone	KR	699
IT	88818	Pallagorio	Calabria	Crotone	KR	700
IT	88819	Verzino	Calabria	Crotone	KR	701
IT	88821	Rocca Di Neto	Calabria	Crotone	KR	702
IT	88821	Corazzo	Calabria	Crotone	KR	703
IT	88822	Casabona	Calabria	Crotone	KR	704
IT	88822	Zinga	Calabria	Crotone	KR	705
IT	88823	Perticaro	Calabria	Crotone	KR	706
IT	88823	Umbriatico	Calabria	Crotone	KR	707
IT	88824	Belvedere Di Spinello	Calabria	Crotone	KR	708
IT	88825	Savelli	Calabria	Crotone	KR	709
IT	88831	Scandale	Calabria	Crotone	KR	710
IT	88831	San Mauro Marchesato	Calabria	Crotone	KR	711
IT	88832	Altilia	Calabria	Crotone	KR	712
IT	88832	Santa Severina	Calabria	Crotone	KR	713
IT	88833	Cerenzia	Calabria	Crotone	KR	714
IT	88833	Caccuri	Calabria	Crotone	KR	715
IT	88834	Castelsilano	Calabria	Crotone	KR	716
IT	88835	Roccabernarda	Calabria	Crotone	KR	717
IT	88836	Cotronei	Calabria	Crotone	KR	718
IT	88837	Camellino	Calabria	Crotone	KR	719
IT	88837	Foresta	Calabria	Crotone	KR	720
IT	88837	Petilia Policastro	Calabria	Crotone	KR	721
IT	88837	Pagliarelle	Calabria	Crotone	KR	722
IT	88838	Mesoraca	Calabria	Crotone	KR	723
IT	88838	Filippa	Calabria	Crotone	KR	724
IT	88841	Isola Di Capo Rizzuto	Calabria	Crotone	KR	725
IT	88841	Le Castella	Calabria	Crotone	KR	726
IT	88841	Sant'Anna	Calabria	Crotone	KR	727
IT	88841	Punta Le Castella	Calabria	Crotone	KR	728
IT	88842	San Leonardo Di Cutro	Calabria	Crotone	KR	729
IT	88842	Cutro	Calabria	Crotone	KR	730
IT	88842	Steccato Di Cutro	Calabria	Crotone	KR	731
IT	88900	Crotone	Calabria	Crotone	KR	732
IT	88900	Villaggio Bucchi	Calabria	Crotone	KR	733
IT	88900	Papanice	Calabria	Crotone	KR	734
IT	89010	Molochio	Calabria	Reggio Di Calabria	RC	735
IT	89010	Varapodio	Calabria	Reggio Di Calabria	RC	736
IT	89010	Terranova Sappo Minulio	Calabria	Reggio Di Calabria	RC	737
IT	89010	Scido	Calabria	Reggio Di Calabria	RC	738
IT	89011	Solano Inferiore	Calabria	Reggio Di Calabria	RC	739
IT	89011	Ceramida	Calabria	Reggio Di Calabria	RC	740
IT	89011	Marinella	Calabria	Reggio Di Calabria	RC	741
IT	89011	Porelli Di Bagnara	Calabria	Reggio Di Calabria	RC	742
IT	89011	Bagnara Calabra	Calabria	Reggio Di Calabria	RC	743
IT	89011	Pellegrina	Calabria	Reggio Di Calabria	RC	744
IT	89012	Delianuova	Calabria	Reggio Di Calabria	RC	745
IT	89013	Marina Di Gioia Tauro	Calabria	Reggio Di Calabria	RC	746
IT	89013	Gioia Tauro	Calabria	Reggio Di Calabria	RC	747
IT	89014	Castellace	Calabria	Reggio Di Calabria	RC	748
IT	89014	Oppido Mamertina	Calabria	Reggio Di Calabria	RC	749
IT	89014	Messignadi	Calabria	Reggio Di Calabria	RC	750
IT	89014	Piminoro	Calabria	Reggio Di Calabria	RC	751
IT	89014	Tresilico	Calabria	Reggio Di Calabria	RC	752
IT	89014	Zurgonadio	Calabria	Reggio Di Calabria	RC	753
IT	89015	Palmi	Calabria	Reggio Di Calabria	RC	754
IT	89015	Taureana	Calabria	Reggio Di Calabria	RC	755
IT	89015	Trodio	Calabria	Reggio Di Calabria	RC	756
IT	89016	Spina	Calabria	Reggio Di Calabria	RC	757
IT	89016	Cirello	Calabria	Reggio Di Calabria	RC	758
IT	89016	Rizziconi	Calabria	Reggio Di Calabria	RC	759
IT	89016	Drosi	Calabria	Reggio Di Calabria	RC	760
IT	89017	San Giorgio Morgeto	Calabria	Reggio Di Calabria	RC	761
IT	89018	Villa San Giovanni	Calabria	Reggio Di Calabria	RC	762
IT	89018	Cannitello	Calabria	Reggio Di Calabria	RC	763
IT	89018	Ferrito	Calabria	Reggio Di Calabria	RC	764
IT	89018	Pezzo Di Villa San Giovanni	Calabria	Reggio Di Calabria	RC	765
IT	89018	Acciarello	Calabria	Reggio Di Calabria	RC	766
IT	89020	Serrata	Calabria	Reggio Di Calabria	RC	767
IT	89020	San Pier Fedele	Calabria	Reggio Di Calabria	RC	768
IT	89020	Melicucco	Calabria	Reggio Di Calabria	RC	769
IT	89020	San Pietro Di Carida'	Calabria	Reggio Di Calabria	RC	770
IT	89020	Melicucca'	Calabria	Reggio Di Calabria	RC	771
IT	89020	Candidoni	Calabria	Reggio Di Calabria	RC	772
IT	89020	Anoia Superiore	Calabria	Reggio Di Calabria	RC	773
IT	89020	Tritanti	Calabria	Reggio Di Calabria	RC	774
IT	89020	Anoia	Calabria	Reggio Di Calabria	RC	775
IT	89020	Sinopoli Inferiore	Calabria	Reggio Di Calabria	RC	776
IT	89020	Maropati	Calabria	Reggio Di Calabria	RC	777
IT	89020	Giffone	Calabria	Reggio Di Calabria	RC	778
IT	89020	Sinopoli	Calabria	Reggio Di Calabria	RC	779
IT	89020	Anoia Inferiore	Calabria	Reggio Di Calabria	RC	780
IT	89020	San Procopio	Calabria	Reggio Di Calabria	RC	781
IT	89021	Cinquefrondi	Calabria	Reggio Di Calabria	RC	782
IT	89022	Cittanova	Calabria	Reggio Di Calabria	RC	783
IT	89023	Bellantone	Calabria	Reggio Di Calabria	RC	784
IT	89023	Laureana Di Borrello	Calabria	Reggio Di Calabria	RC	785
IT	89023	Stelletanone	Calabria	Reggio Di Calabria	RC	786
IT	89024	Polistena	Calabria	Reggio Di Calabria	RC	787
IT	89025	Rosarno	Calabria	Reggio Di Calabria	RC	788
IT	89025	Bosco	Calabria	Reggio Di Calabria	RC	789
IT	89026	San Ferdinando	Calabria	Reggio Di Calabria	RC	790
IT	89027	Sant'Eufemia D'Aspromonte	Calabria	Reggio Di Calabria	RC	791
IT	89028	Seminara	Calabria	Reggio Di Calabria	RC	792
IT	89028	Sant'Anna	Calabria	Reggio Di Calabria	RC	793
IT	89028	Barritteri	Calabria	Reggio Di Calabria	RC	794
IT	89028	Sant'Anna Di Seminara	Calabria	Reggio Di Calabria	RC	795
IT	89029	Amato Di Taurianova	Calabria	Reggio Di Calabria	RC	796
IT	89029	Taurianova	Calabria	Reggio Di Calabria	RC	797
IT	89029	San Martino	Calabria	Reggio Di Calabria	RC	798
IT	89029	San Martino Di Taurianova	Calabria	Reggio Di Calabria	RC	799
IT	89030	Staiti	Calabria	Reggio Di Calabria	RC	800
IT	89030	Benestare	Calabria	Reggio Di Calabria	RC	801
IT	89030	Caraffa Del Bianco	Calabria	Reggio Di Calabria	RC	802
IT	89030	Canalello	Calabria	Reggio Di Calabria	RC	803
IT	89030	Belloro	Calabria	Reggio Di Calabria	RC	804
IT	89030	Condofuri	Calabria	Reggio Di Calabria	RC	805
IT	89030	San Luca	Calabria	Reggio Di Calabria	RC	806
IT	89030	Natile Vecchio	Calabria	Reggio Di Calabria	RC	807
IT	89030	Samo	Calabria	Reggio Di Calabria	RC	808
IT	89030	Careri	Calabria	Reggio Di Calabria	RC	809
IT	89030	Casignana	Calabria	Reggio Di Calabria	RC	810
IT	89030	Natile Nuovo	Calabria	Reggio Di Calabria	RC	811
IT	89030	San Carlo	Calabria	Reggio Di Calabria	RC	812
IT	89030	Ferruzzano	Calabria	Reggio Di Calabria	RC	813
IT	89030	Sant'Agata Del Bianco	Calabria	Reggio Di Calabria	RC	814
IT	89030	Condofuri Marina	Calabria	Reggio Di Calabria	RC	815
IT	89030	Bruzzano Zeffirio	Calabria	Reggio Di Calabria	RC	816
IT	89030	Africo	Calabria	Reggio Di Calabria	RC	817
IT	89030	Motticella	Calabria	Reggio Di Calabria	RC	818
IT	89030	Santuario Di Polsi	Calabria	Reggio Di Calabria	RC	819
IT	89030	Natile	Calabria	Reggio Di Calabria	RC	820
IT	89031	Bombile	Calabria	Reggio Di Calabria	RC	821
IT	89031	San Nicola	Calabria	Reggio Di Calabria	RC	822
IT	89031	Ardore	Calabria	Reggio Di Calabria	RC	823
IT	89032	Pardesca	Calabria	Reggio Di Calabria	RC	824
IT	89032	Bianco	Calabria	Reggio Di Calabria	RC	825
IT	89033	Bova	Calabria	Reggio Di Calabria	RC	826
IT	89034	Bovalino Marina	Calabria	Reggio Di Calabria	RC	827
IT	89034	Bovalino Superiore	Calabria	Reggio Di Calabria	RC	828
IT	89034	Bovalino	Calabria	Reggio Di Calabria	RC	829
IT	89034	Bosco Sant'Ippolito	Calabria	Reggio Di Calabria	RC	830
IT	89035	Bova Marina	Calabria	Reggio Di Calabria	RC	831
IT	89036	Galati	Calabria	Reggio Di Calabria	RC	832
IT	89036	Brancaleone	Calabria	Reggio Di Calabria	RC	833
IT	89036	Brancaleone Marina	Calabria	Reggio Di Calabria	RC	834
IT	89036	Capo Spartivento	Calabria	Reggio Di Calabria	RC	835
IT	89037	Ardore Marina	Calabria	Reggio Di Calabria	RC	836
IT	89037	Marina D'Ardore	Calabria	Reggio Di Calabria	RC	837
IT	89038	Palizzi Marina	Calabria	Reggio Di Calabria	RC	838
IT	89038	Palizzi	Calabria	Reggio Di Calabria	RC	839
IT	89038	Pietrapennata	Calabria	Reggio Di Calabria	RC	840
IT	89038	Marina Di Palizzi	Calabria	Reggio Di Calabria	RC	841
IT	89039	Plati'	Calabria	Reggio Di Calabria	RC	842
IT	89040	Monasterace	Calabria	Reggio Di Calabria	RC	843
IT	89040	Cirella	Calabria	Reggio Di Calabria	RC	844
IT	89040	Pazzano	Calabria	Reggio Di Calabria	RC	845
IT	89040	Agnana Calabra	Calabria	Reggio Di Calabria	RC	846
IT	89040	Gerace	Calabria	Reggio Di Calabria	RC	847
IT	89040	Riace	Calabria	Reggio Di Calabria	RC	848
IT	89040	Antonimina	Calabria	Reggio Di Calabria	RC	849
IT	89040	Bivongi	Calabria	Reggio Di Calabria	RC	850
IT	89040	Cimina'	Calabria	Reggio Di Calabria	RC	851
IT	89040	Canolo Nuova	Calabria	Reggio Di Calabria	RC	852
IT	89040	Placanica	Calabria	Reggio Di Calabria	RC	853
IT	89040	Martone	Calabria	Reggio Di Calabria	RC	854
IT	89040	San Giovanni Di Gerace	Calabria	Reggio Di Calabria	RC	855
IT	89040	Camini	Calabria	Reggio Di Calabria	RC	856
IT	89040	Sant'Ilario Dello Ionio	Calabria	Reggio Di Calabria	RC	857
IT	89040	Marina Di Caulonia	Calabria	Reggio Di Calabria	RC	858
IT	89040	Canolo	Calabria	Reggio Di Calabria	RC	859
IT	89040	Marina Di Sant'Ilario Dello Ionio	Calabria	Reggio Di Calabria	RC	860
IT	89040	Portigliola	Calabria	Reggio Di Calabria	RC	861
IT	89040	Stignano	Calabria	Reggio Di Calabria	RC	862
IT	89040	Condojanni	Calabria	Reggio Di Calabria	RC	863
IT	89040	Riace Marina	Calabria	Reggio Di Calabria	RC	864
IT	89040	Monasterace Marina	Calabria	Reggio Di Calabria	RC	865
IT	89041	San Nicola Di Caulonia	Calabria	Reggio Di Calabria	RC	866
IT	89041	Campoli Di Caulonia	Calabria	Reggio Di Calabria	RC	867
IT	89041	Caulonia Marina	Calabria	Reggio Di Calabria	RC	868
IT	89041	Caulonia	Calabria	Reggio Di Calabria	RC	869
IT	89041	Ursini	Calabria	Reggio Di Calabria	RC	870
IT	89042	Gioiosa Ionica	Calabria	Reggio Di Calabria	RC	871
IT	89043	Grotteria	Calabria	Reggio Di Calabria	RC	872
IT	89043	Croce Ferrata	Calabria	Reggio Di Calabria	RC	873
IT	89044	Locri	Calabria	Reggio Di Calabria	RC	874
IT	89044	Moschetta	Calabria	Reggio Di Calabria	RC	875
IT	89044	Merici	Calabria	Reggio Di Calabria	RC	876
IT	89044	Moschetta Di Locri	Calabria	Reggio Di Calabria	RC	877
IT	89045	Mammola	Calabria	Reggio Di Calabria	RC	878
IT	89046	Marina Di Gioiosa Ionica	Calabria	Reggio Di Calabria	RC	879
IT	89047	Roccella Ionica	Calabria	Reggio Di Calabria	RC	880
IT	89048	Siderno Superiore	Calabria	Reggio Di Calabria	RC	881
IT	89048	Donisi	Calabria	Reggio Di Calabria	RC	882
IT	89048	Siderno	Calabria	Reggio Di Calabria	RC	883
IT	89048	Siderno Marina	Calabria	Reggio Di Calabria	RC	884
IT	89049	Stilo	Calabria	Reggio Di Calabria	RC	885
IT	89050	Sant'Alessio In Aspromonte	Calabria	Reggio Di Calabria	RC	886
IT	89050	Plaesano	Calabria	Reggio Di Calabria	RC	887
IT	89050	Colelli	Calabria	Reggio Di Calabria	RC	888
IT	89050	Feroleto Della Chiesa	Calabria	Reggio Di Calabria	RC	889
IT	89050	Sitizano	Calabria	Reggio Di Calabria	RC	890
IT	89050	Villa Mesa	Calabria	Reggio Di Calabria	RC	891
IT	89050	Fiumara	Calabria	Reggio Di Calabria	RC	892
IT	89050	Calanna	Calabria	Reggio Di Calabria	RC	893
IT	89050	Cosoleto	Calabria	Reggio Di Calabria	RC	894
IT	89050	San Roberto	Calabria	Reggio Di Calabria	RC	895
IT	89050	Acquacalda	Calabria	Reggio Di Calabria	RC	896
IT	89050	Laganadi	Calabria	Reggio Di Calabria	RC	897
IT	89052	Campo Calabro	Calabria	Reggio Di Calabria	RC	898
IT	89054	Galatro	Calabria	Reggio Di Calabria	RC	899
IT	89056	Lubrichi	Calabria	Reggio Di Calabria	RC	900
IT	89056	Santa Cristina D'Aspromonte	Calabria	Reggio Di Calabria	RC	901
IT	89057	Santo Stefano In Aspromonte	Calabria	Reggio Di Calabria	RC	902
IT	89057	Gambarie	Calabria	Reggio Di Calabria	RC	903
IT	89058	Melia	Calabria	Reggio Di Calabria	RC	904
IT	89058	Favazzina	Calabria	Reggio Di Calabria	RC	905
IT	89058	Scilla	Calabria	Reggio Di Calabria	RC	906
IT	89058	Milea	Calabria	Reggio Di Calabria	RC	907
IT	89060	Ghorio	Calabria	Reggio Di Calabria	RC	908
IT	89060	Bagaladi	Calabria	Reggio Di Calabria	RC	909
IT	89060	Roghudi	Calabria	Reggio Di Calabria	RC	910
IT	89060	Roccaforte Del Greco	Calabria	Reggio Di Calabria	RC	911
IT	89060	Cardeto	Calabria	Reggio Di Calabria	RC	912
IT	89060	Saline Joniche	Calabria	Reggio Di Calabria	RC	913
IT	89060	Roghudi Nuovo	Calabria	Reggio Di Calabria	RC	914
IT	89062	Lazzaro	Calabria	Reggio Di Calabria	RC	915
IT	89063	Prunella	Calabria	Reggio Di Calabria	RC	916
IT	89063	Melito Di Porto Salvo	Calabria	Reggio Di Calabria	RC	917
IT	89063	Pentedattilo	Calabria	Reggio Di Calabria	RC	918
IT	89063	Anna'	Calabria	Reggio Di Calabria	RC	919
IT	89063	Caredia	Calabria	Reggio Di Calabria	RC	920
IT	89063	Lacco	Calabria	Reggio Di Calabria	RC	921
IT	89064	Montebello Ionico	Calabria	Reggio Di Calabria	RC	922
IT	89064	Saline Ioniche	Calabria	Reggio Di Calabria	RC	923
IT	89064	Fossato Ionico	Calabria	Reggio Di Calabria	RC	924
IT	89064	Masella	Calabria	Reggio Di Calabria	RC	925
IT	89065	Motta San Giovanni	Calabria	Reggio Di Calabria	RC	926
IT	89069	San Fantino	Calabria	Reggio Di Calabria	RC	927
IT	89069	Marina Di San Lorenzo	Calabria	Reggio Di Calabria	RC	928
IT	89069	Chorio	Calabria	Reggio Di Calabria	RC	929
IT	89069	San Pantaleone	Calabria	Reggio Di Calabria	RC	930
IT	89069	San Lorenzo	Calabria	Reggio Di Calabria	RC	931
IT	89100	Reggio Calabria	Calabria	Reggio Di Calabria	RC	932
IT	89121	Archi	Calabria	Reggio Di Calabria	RC	933
IT	89121	Santa Caterina	Calabria	Reggio Di Calabria	RC	934
IT	89121	Reggio Calabria	Calabria	Reggio Di Calabria	RC	935
IT	89122	Vito	Calabria	Reggio Di Calabria	RC	936
IT	89122	Reggio Calabria	Calabria	Reggio Di Calabria	RC	937
IT	89123	Reggio Calabria	Calabria	Reggio Di Calabria	RC	938
IT	89124	Eremo	Calabria	Reggio Di Calabria	RC	939
IT	89124	Reggio Calabria	Calabria	Reggio Di Calabria	RC	940
IT	89125	Reggio Calabria	Calabria	Reggio Di Calabria	RC	941
IT	89126	Schindilifa'	Calabria	Reggio Di Calabria	RC	942
IT	89126	Cerasi	Calabria	Reggio Di Calabria	RC	943
IT	89126	Podargoni	Calabria	Reggio Di Calabria	RC	944
IT	89126	Trizzino	Calabria	Reggio Di Calabria	RC	945
IT	89126	Arasi'	Calabria	Reggio Di Calabria	RC	946
IT	89126	Terreti	Calabria	Reggio Di Calabria	RC	947
IT	89126	Reggio Calabria	Calabria	Reggio Di Calabria	RC	948
IT	89126	Orti'	Calabria	Reggio Di Calabria	RC	949
IT	89126	Orti' Superiore	Calabria	Reggio Di Calabria	RC	950
IT	89126	In Via Dalmazia	Calabria	Reggio Di Calabria	RC	951
IT	89126	Sant'Elia Di Condera	Calabria	Reggio Di Calabria	RC	952
IT	89126	Orti' Inferiore	Calabria	Reggio Di Calabria	RC	953
IT	89126	Trabocchetto	Calabria	Reggio Di Calabria	RC	954
IT	89127	Reggio Calabria	Calabria	Reggio Di Calabria	RC	955
IT	89128	Spirito Santo	Calabria	Reggio Di Calabria	RC	956
IT	89128	Reggio Calabria	Calabria	Reggio Di Calabria	RC	957
IT	89129	Reggio Calabria	Calabria	Reggio Di Calabria	RC	958
IT	89131	Gallina	Calabria	Reggio Di Calabria	RC	959
IT	89131	Armo	Calabria	Reggio Di Calabria	RC	960
IT	89131	Reggio Calabria	Calabria	Reggio Di Calabria	RC	961
IT	89131	Puzzi	Calabria	Reggio Di Calabria	RC	962
IT	89131	Ravagnese	Calabria	Reggio Di Calabria	RC	963
IT	89132	Reggio Calabria	Calabria	Reggio Di Calabria	RC	964
IT	89133	San Salvatore	Calabria	Reggio Di Calabria	RC	965
IT	89133	Sbarre	Calabria	Reggio Di Calabria	RC	966
IT	89133	Pavigliana	Calabria	Reggio Di Calabria	RC	967
IT	89133	Cataforio	Calabria	Reggio Di Calabria	RC	968
IT	89133	Mosorrofa	Calabria	Reggio Di Calabria	RC	969
IT	89133	Reggio Calabria	Calabria	Reggio Di Calabria	RC	970
IT	89133	San Sperato	Calabria	Reggio Di Calabria	RC	971
IT	89133	Vinco	Calabria	Reggio Di Calabria	RC	972
IT	89133	Cannavo'	Calabria	Reggio Di Calabria	RC	973
IT	89133	San Giorgio Extra	Calabria	Reggio Di Calabria	RC	974
IT	89134	Croce Valanidi	Calabria	Reggio Di Calabria	RC	975
IT	89134	Pellaro	Calabria	Reggio Di Calabria	RC	976
IT	89134	Bocale	Calabria	Reggio Di Calabria	RC	977
IT	89134	Rosario Valanidi	Calabria	Reggio Di Calabria	RC	978
IT	89134	San Gregorio	Calabria	Reggio Di Calabria	RC	979
IT	89135	Sambatello	Calabria	Reggio Di Calabria	RC	980
IT	89135	Reggio Calabria	Calabria	Reggio Di Calabria	RC	981
IT	89135	Catona	Calabria	Reggio Di Calabria	RC	982
IT	89135	Gallico	Calabria	Reggio Di Calabria	RC	983
IT	89135	Diminniti	Calabria	Reggio Di Calabria	RC	984
IT	89135	Salice Calabro	Calabria	Reggio Di Calabria	RC	985
IT	89135	Rosali'	Calabria	Reggio Di Calabria	RC	986
IT	89135	Villa San Giuseppe	Calabria	Reggio Di Calabria	RC	987
IT	89812	Pizzo	Calabria	Vibo Valentia	VV	988
IT	89812	Pizzo Marina	Calabria	Vibo Valentia	VV	989
IT	89813	Trecroci	Calabria	Vibo Valentia	VV	990
IT	89813	Menniti	Calabria	Vibo Valentia	VV	991
IT	89813	Polia	Calabria	Vibo Valentia	VV	992
IT	89814	Scarro	Calabria	Vibo Valentia	VV	993
IT	89814	Filadelfia	Calabria	Vibo Valentia	VV	994
IT	89814	Montesoro	Calabria	Vibo Valentia	VV	995
IT	89815	Francavilla Angitola	Calabria	Vibo Valentia	VV	996
IT	89816	San Cono	Calabria	Vibo Valentia	VV	997
IT	89816	Cessaniti	Calabria	Vibo Valentia	VV	998
IT	89816	Pannaconi	Calabria	Vibo Valentia	VV	999
IT	89816	Favelloni	Calabria	Vibo Valentia	VV	1000
IT	89817	San Costantino Di Briatico	Calabria	Vibo Valentia	VV	1001
IT	89817	Paradisoni	Calabria	Vibo Valentia	VV	1002
IT	89817	Potenzoni	Calabria	Vibo Valentia	VV	1003
IT	89817	Sciconi	Calabria	Vibo Valentia	VV	1004
IT	89817	San Costantino	Calabria	Vibo Valentia	VV	1005
IT	89817	Briatico	Calabria	Vibo Valentia	VV	1006
IT	89818	Capistrano	Calabria	Vibo Valentia	VV	1007
IT	89819	Monterosso Calabro	Calabria	Vibo Valentia	VV	1008
IT	89821	Vallelonga	Calabria	Vibo Valentia	VV	1009
IT	89821	San Nicola Da Crissa	Calabria	Vibo Valentia	VV	1010
IT	89822	Simbario	Calabria	Vibo Valentia	VV	1011
IT	89822	Brognaturo	Calabria	Vibo Valentia	VV	1012
IT	89822	Serra San Bruno	Calabria	Vibo Valentia	VV	1013
IT	89822	Spadola	Calabria	Vibo Valentia	VV	1014
IT	89823	Mongiana	Calabria	Vibo Valentia	VV	1015
IT	89823	Fabrizia	Calabria	Vibo Valentia	VV	1016
IT	89824	Nardodipace	Calabria	Vibo Valentia	VV	1017
IT	89831	Gerocarne	Calabria	Vibo Valentia	VV	1018
IT	89831	Ciano	Calabria	Vibo Valentia	VV	1019
IT	89831	Sant'Angelo Gerocarne	Calabria	Vibo Valentia	VV	1020
IT	89831	Sorianello	Calabria	Vibo Valentia	VV	1021
IT	89831	Soriano Calabro	Calabria	Vibo Valentia	VV	1022
IT	89831	Sant'Angelo	Calabria	Vibo Valentia	VV	1023
IT	89832	Arena	Calabria	Vibo Valentia	VV	1024
IT	89832	Dasa'	Calabria	Vibo Valentia	VV	1025
IT	89832	Acquaro	Calabria	Vibo Valentia	VV	1026
IT	89832	Limpidi	Calabria	Vibo Valentia	VV	1027
IT	89833	Monsoreto	Calabria	Vibo Valentia	VV	1028
IT	89833	Dinami	Calabria	Vibo Valentia	VV	1029
IT	89833	Melicucca' Di Dinami	Calabria	Vibo Valentia	VV	1030
IT	89834	Pizzoni	Calabria	Vibo Valentia	VV	1031
IT	89834	Vazzano	Calabria	Vibo Valentia	VV	1032
IT	89841	Presinaci	Calabria	Vibo Valentia	VV	1033
IT	89841	Arzona	Calabria	Vibo Valentia	VV	1034
IT	89841	Moladi	Calabria	Vibo Valentia	VV	1035
IT	89841	Pernocari	Calabria	Vibo Valentia	VV	1036
IT	89841	Pizzinni	Calabria	Vibo Valentia	VV	1037
IT	89841	Filandari	Calabria	Vibo Valentia	VV	1038
IT	89841	Rombiolo	Calabria	Vibo Valentia	VV	1039
IT	89842	San Calogero	Calabria	Vibo Valentia	VV	1040
IT	89842	Calimera Calabra	Calabria	Vibo Valentia	VV	1041
IT	89843	Maierato	Calabria	Vibo Valentia	VV	1042
IT	89843	Sant'Onofrio	Calabria	Vibo Valentia	VV	1043
IT	89843	Stefanaconi	Calabria	Vibo Valentia	VV	1044
IT	89843	Filogaso	Calabria	Vibo Valentia	VV	1045
IT	89844	Badia	Calabria	Vibo Valentia	VV	1046
IT	89844	Mandaradoni	Calabria	Vibo Valentia	VV	1047
IT	89844	Preitoni	Calabria	Vibo Valentia	VV	1048
IT	89844	Comerconi	Calabria	Vibo Valentia	VV	1049
IT	89844	Caroni	Calabria	Vibo Valentia	VV	1050
IT	89844	Nicotera	Calabria	Vibo Valentia	VV	1051
IT	89844	Limbadi	Calabria	Vibo Valentia	VV	1052
IT	89844	Marina Di Nicotera	Calabria	Vibo Valentia	VV	1053
IT	89844	Motta Filocastro	Calabria	Vibo Valentia	VV	1054
IT	89851	Francica	Calabria	Vibo Valentia	VV	1055
IT	89851	Jonadi	Calabria	Vibo Valentia	VV	1056
IT	89851	San Costantino Calabro	Calabria	Vibo Valentia	VV	1057
IT	89851	Nao	Calabria	Vibo Valentia	VV	1058
IT	89852	Comparni	Calabria	Vibo Valentia	VV	1059
IT	89852	Mileto	Calabria	Vibo Valentia	VV	1060
IT	89852	San Giovanni	Calabria	Vibo Valentia	VV	1061
IT	89852	Paravati	Calabria	Vibo Valentia	VV	1062
IT	89853	San Gregorio D'Ippona	Calabria	Vibo Valentia	VV	1063
IT	89861	Fitili	Calabria	Vibo Valentia	VV	1064
IT	89861	Parghelia	Calabria	Vibo Valentia	VV	1065
IT	89861	Tropea	Calabria	Vibo Valentia	VV	1066
IT	89862	Caria	Calabria	Vibo Valentia	VV	1067
IT	89862	Brattiro'	Calabria	Vibo Valentia	VV	1068
IT	89862	Gasponi	Calabria	Vibo Valentia	VV	1069
IT	89862	Drapia	Calabria	Vibo Valentia	VV	1070
IT	89863	Coccorino	Calabria	Vibo Valentia	VV	1071
IT	89863	Caroniti	Calabria	Vibo Valentia	VV	1072
IT	89863	Joppolo	Calabria	Vibo Valentia	VV	1073
IT	89864	Panaia	Calabria	Vibo Valentia	VV	1074
IT	89864	Spilinga	Calabria	Vibo Valentia	VV	1075
IT	89866	Ricadi	Calabria	Vibo Valentia	VV	1076
IT	89866	Santa Domenica	Calabria	Vibo Valentia	VV	1077
IT	89866	Barbalaconi	Calabria	Vibo Valentia	VV	1078
IT	89866	Santa Domenica Ricadi	Calabria	Vibo Valentia	VV	1079
IT	89866	San Nicolo' Di Ricadi	Calabria	Vibo Valentia	VV	1080
IT	89866	Lampazzone	Calabria	Vibo Valentia	VV	1081
IT	89866	San Nicolo'	Calabria	Vibo Valentia	VV	1082
IT	89867	Zungri	Calabria	Vibo Valentia	VV	1083
IT	89867	Zaccanopoli	Calabria	Vibo Valentia	VV	1084
IT	89868	San Giovanni Di Zambrone	Calabria	Vibo Valentia	VV	1085
IT	89868	Daffina'	Calabria	Vibo Valentia	VV	1086
IT	89868	Zambrone	Calabria	Vibo Valentia	VV	1087
IT	89900	Vena Superiore	Calabria	Vibo Valentia	VV	1088
IT	89900	Vibo Valentia	Calabria	Vibo Valentia	VV	1089
IT	89900	Vibo Valentia Marina	Calabria	Vibo Valentia	VV	1090
IT	89900	Triparni	Calabria	Vibo Valentia	VV	1091
IT	89900	Porto Salvo	Calabria	Vibo Valentia	VV	1092
IT	89900	Piscopio	Calabria	Vibo Valentia	VV	1093
IT	89900	Longobardi	Calabria	Vibo Valentia	VV	1094
IT	89900	Vena	Calabria	Vibo Valentia	VV	1095
IT	89900	Vibo Marina	Calabria	Vibo Valentia	VV	1096
IT	83010	Tufo	Campania	Avellino	AV	1097
IT	83010	Capriglia Irpina	Campania	Avellino	AV	1098
IT	83010	Torrioni	Campania	Avellino	AV	1099
IT	83010	Grottolella	Campania	Avellino	AV	1100
IT	83010	Petruro Irpino	Campania	Avellino	AV	1101
IT	83010	Chianche	Campania	Avellino	AV	1102
IT	83010	Summonte	Campania	Avellino	AV	1103
IT	83010	Starze Di Summonte	Campania	Avellino	AV	1104
IT	83010	Starze	Campania	Avellino	AV	1105
IT	83010	San Felice	Campania	Avellino	AV	1106
IT	83010	Sant'Angelo A Scala	Campania	Avellino	AV	1107
IT	83011	Altavilla Irpina	Campania	Avellino	AV	1108
IT	83012	Trescine	Campania	Avellino	AV	1109
IT	83012	Cervinara	Campania	Avellino	AV	1110
IT	83012	Ioffredo	Campania	Avellino	AV	1111
IT	83013	Mercogliano	Campania	Avellino	AV	1112
IT	83013	Torelli Di Mercogliano	Campania	Avellino	AV	1113
IT	83013	Santuario Di Montevergine	Campania	Avellino	AV	1114
IT	83013	Torelli	Campania	Avellino	AV	1115
IT	83013	Torrette	Campania	Avellino	AV	1116
IT	83014	Ospedaletto D'Alpinolo	Campania	Avellino	AV	1117
IT	83015	Pietrastornina	Campania	Avellino	AV	1118
IT	83015	Ciardelli Inferiore	Campania	Avellino	AV	1119
IT	83016	Roccabascerana	Campania	Avellino	AV	1120
IT	83016	Squillani	Campania	Avellino	AV	1121
IT	83016	Tufara Valle	Campania	Avellino	AV	1122
IT	83016	Cassano Caudino	Campania	Avellino	AV	1123
IT	83017	Rotondi	Campania	Avellino	AV	1124
IT	83017	Ferrari Di Cervinara	Campania	Avellino	AV	1125
IT	83018	San Martino Valle Caudina	Campania	Avellino	AV	1126
IT	83020	Marzano Di Nola	Campania	Avellino	AV	1127
IT	83020	Celzi	Campania	Avellino	AV	1128
IT	83020	Pago Del Vallo Di Lauro	Campania	Avellino	AV	1129
IT	83020	Quadrelle	Campania	Avellino	AV	1130
IT	83020	Aiello Del Sabato	Campania	Avellino	AV	1131
IT	83020	San Michele Di Serino	Campania	Avellino	AV	1132
IT	83020	Petruro	Campania	Avellino	AV	1133
IT	83020	Quindici	Campania	Avellino	AV	1134
IT	83020	Cesinali	Campania	Avellino	AV	1135
IT	83020	Sirignano	Campania	Avellino	AV	1136
IT	83020	Taurano	Campania	Avellino	AV	1137
IT	83020	Contrada	Campania	Avellino	AV	1138
IT	83020	Domicella	Campania	Avellino	AV	1139
IT	83020	Casola	Campania	Avellino	AV	1140
IT	83020	Forino	Campania	Avellino	AV	1141
IT	83020	Sperone	Campania	Avellino	AV	1142
IT	83020	Moschiano	Campania	Avellino	AV	1143
IT	83020	Santa Lucia Di Serino	Campania	Avellino	AV	1144
IT	83020	Tavernola San Felice	Campania	Avellino	AV	1145
IT	83021	Avella	Campania	Avellino	AV	1146
IT	83022	Baiano	Campania	Avellino	AV	1147
IT	83023	Lauro	Campania	Avellino	AV	1148
IT	83023	Migliano	Campania	Avellino	AV	1149
IT	83023	Fontenovella	Campania	Avellino	AV	1150
IT	83024	Monteforte Irpino	Campania	Avellino	AV	1151
IT	83024	Molinelle	Campania	Avellino	AV	1152
IT	83025	Torchiati	Campania	Avellino	AV	1153
IT	83025	Piazza Di Pandola	Campania	Avellino	AV	1154
IT	83025	San Pietro	Campania	Avellino	AV	1155
IT	83025	Montoro Superiore	Campania	Avellino	AV	1156
IT	83025	Misciano	Campania	Avellino	AV	1157
IT	83025	Banzano	Campania	Avellino	AV	1158
IT	83025	Montoro Inferiore	Campania	Avellino	AV	1159
IT	83025	Piano	Campania	Avellino	AV	1160
IT	83025	Borgo	Campania	Avellino	AV	1161
IT	83025	Montoro	Campania	Avellino	AV	1162
IT	83025	Caliano	Campania	Avellino	AV	1163
IT	83025	Aterrana	Campania	Avellino	AV	1164
IT	83025	Preturo	Campania	Avellino	AV	1165
IT	83025	Borgo Di Montoro Inferiore	Campania	Avellino	AV	1166
IT	83025	Figlioli	Campania	Avellino	AV	1167
IT	81030	Casanova	Campania	Caserta	CE	1168
IT	83026	Banzano Di Montoro Superiore	Campania	Avellino	AV	1169
IT	83026	San Pietro Di Montoro Superiore	Campania	Avellino	AV	1170
IT	83027	Mugnano Del Cardinale	Campania	Avellino	AV	1171
IT	83028	Sala	Campania	Avellino	AV	1172
IT	83028	Serino	Campania	Avellino	AV	1173
IT	83028	Canale	Campania	Avellino	AV	1174
IT	83028	San Biagio	Campania	Avellino	AV	1175
IT	83028	San Sossio Di Serino	Campania	Avellino	AV	1176
IT	83028	Ferrari Stazione Serino	Campania	Avellino	AV	1177
IT	83029	Solofra	Campania	Avellino	AV	1178
IT	83029	Sant'Agata Irpina	Campania	Avellino	AV	1179
IT	83029	Sant'Andrea Apostolo	Campania	Avellino	AV	1180
IT	83030	Campanarello	Campania	Avellino	AV	1181
IT	83030	Lapio	Campania	Avellino	AV	1182
IT	83030	Venticano	Campania	Avellino	AV	1183
IT	83030	Santa Paolina	Campania	Avellino	AV	1184
IT	83030	Zungoli	Campania	Avellino	AV	1185
IT	83030	Torre Le Nocelle	Campania	Avellino	AV	1186
IT	83030	Pietradefusi	Campania	Avellino	AV	1187
IT	83030	Sant'Angelo A Cancelli	Campania	Avellino	AV	1188
IT	83030	Dentecane	Campania	Avellino	AV	1189
IT	83030	Serra	Campania	Avellino	AV	1190
IT	83030	Montefalcione	Campania	Avellino	AV	1191
IT	83030	Montefredane	Campania	Avellino	AV	1192
IT	83030	Prata Di Principato Ultra	Campania	Avellino	AV	1193
IT	83030	Arcella	Campania	Avellino	AV	1194
IT	83030	Villanova Del Battista	Campania	Avellino	AV	1195
IT	83030	Taurasi	Campania	Avellino	AV	1196
IT	83030	San Barbato	Campania	Avellino	AV	1197
IT	83030	Montefusco	Campania	Avellino	AV	1198
IT	83030	Savignano Irpino	Campania	Avellino	AV	1199
IT	83030	Manocalzati	Campania	Avellino	AV	1200
IT	83030	Melito Irpino	Campania	Avellino	AV	1201
IT	83030	Savignano Stazione	Campania	Avellino	AV	1202
IT	83030	Castello Del Lago	Campania	Avellino	AV	1203
IT	83030	Sant'Elena Irpina	Campania	Avellino	AV	1204
IT	83030	Montaguto	Campania	Avellino	AV	1205
IT	83030	Greci	Campania	Avellino	AV	1206
IT	83031	Ariano Irpino	Campania	Avellino	AV	1207
IT	83031	Palazzisi	Campania	Avellino	AV	1208
IT	83031	Orneta	Campania	Avellino	AV	1209
IT	83031	Ariano Scalo	Campania	Avellino	AV	1210
IT	83031	La Manna	Campania	Avellino	AV	1211
IT	83031	Ariano Irpino Stazione	Campania	Avellino	AV	1212
IT	83032	Morroni	Campania	Avellino	AV	1213
IT	83032	Bonito	Campania	Avellino	AV	1214
IT	83034	Casalbore	Campania	Avellino	AV	1215
IT	83035	Grottaminarda	Campania	Avellino	AV	1216
IT	83035	Carpignano	Campania	Avellino	AV	1217
IT	83036	Calore	Campania	Avellino	AV	1218
IT	83036	Passo Di Mirabella	Campania	Avellino	AV	1219
IT	83036	Mirabella Eclano	Campania	Avellino	AV	1220
IT	83036	Pianopantano	Campania	Avellino	AV	1221
IT	83037	Montecalvo Irpino	Campania	Avellino	AV	1222
IT	83038	Montemiletto	Campania	Avellino	AV	1223
IT	83038	Montaperto	Campania	Avellino	AV	1224
IT	83039	San Michele Di Pratola Serra	Campania	Avellino	AV	1225
IT	83039	Pratola Serra	Campania	Avellino	AV	1226
IT	83039	San Michele Di Pratola	Campania	Avellino	AV	1227
IT	83039	Serra Di Pratola Serra	Campania	Avellino	AV	1228
IT	83039	Serra	Campania	Avellino	AV	1229
IT	83040	Castel Baronia	Campania	Avellino	AV	1230
IT	83040	Caposele	Campania	Avellino	AV	1231
IT	83040	Cairano	Campania	Avellino	AV	1232
IT	83040	Morra De Sanctis	Campania	Avellino	AV	1233
IT	83040	Gesualdo	Campania	Avellino	AV	1234
IT	83040	Fontanarosa	Campania	Avellino	AV	1235
IT	83040	Materdomini	Campania	Avellino	AV	1236
IT	83040	Chiusano Di San Domenico	Campania	Avellino	AV	1237
IT	83040	Guardia Lombardi	Campania	Avellino	AV	1238
IT	83040	Luogosano	Campania	Avellino	AV	1239
IT	83040	Alvano	Campania	Avellino	AV	1240
IT	83040	Mattinella	Campania	Avellino	AV	1241
IT	83040	Candida	Campania	Avellino	AV	1242
IT	83040	Carife	Campania	Avellino	AV	1243
IT	83040	Frigento	Campania	Avellino	AV	1244
IT	83040	Calabritto	Campania	Avellino	AV	1245
IT	83040	Pila Ai Piani	Campania	Avellino	AV	1246
IT	83040	Cassano Irpino	Campania	Avellino	AV	1247
IT	83040	Montemarano	Campania	Avellino	AV	1248
IT	83040	Castelvetere Sul Calore	Campania	Avellino	AV	1249
IT	83040	Castelfranci	Campania	Avellino	AV	1250
IT	83040	Conza Della Campania	Campania	Avellino	AV	1251
IT	83040	Andretta	Campania	Avellino	AV	1252
IT	83040	Quaglietta	Campania	Avellino	AV	1253
IT	83040	Pagliara	Campania	Avellino	AV	1254
IT	83040	Flumeri	Campania	Avellino	AV	1255
IT	83041	Aquilonia	Campania	Avellino	AV	1256
IT	83042	Atripalda	Campania	Avellino	AV	1257
IT	83043	Laceno	Campania	Avellino	AV	1258
IT	83043	Bagnoli Irpino	Campania	Avellino	AV	1259
IT	83043	Villaggio Laceno	Campania	Avellino	AV	1260
IT	83044	Bisaccia Nuova	Campania	Avellino	AV	1261
IT	83044	Bisaccia	Campania	Avellino	AV	1262
IT	83044	Piano Regolatore	Campania	Avellino	AV	1263
IT	83045	Calitri	Campania	Avellino	AV	1264
IT	83046	Lacedonia	Campania	Avellino	AV	1265
IT	83047	Lioni	Campania	Avellino	AV	1266
IT	83048	Sorbo Di Montella	Campania	Avellino	AV	1267
IT	83048	Montella	Campania	Avellino	AV	1268
IT	83048	Fontana Di Montella	Campania	Avellino	AV	1269
IT	83049	Monteverde	Campania	Avellino	AV	1270
IT	83050	San Nicola Baronia	Campania	Avellino	AV	1271
IT	83050	Parolise	Campania	Avellino	AV	1272
IT	83050	Senerchia	Campania	Avellino	AV	1273
IT	83050	Villamaina	Campania	Avellino	AV	1274
IT	83050	Volturara Irpina	Campania	Avellino	AV	1275
IT	83050	Sorbo Serpico	Campania	Avellino	AV	1276
IT	83050	Rocca San Felice	Campania	Avellino	AV	1277
IT	83050	Scampitella	Campania	Avellino	AV	1278
IT	83050	San Sossio Baronia	Campania	Avellino	AV	1279
IT	83050	Sant'Angelo All'Esca	Campania	Avellino	AV	1280
IT	83050	Santo Stefano Del Sole	Campania	Avellino	AV	1281
IT	83050	San Mango Sul Calore	Campania	Avellino	AV	1282
IT	83050	Salza Irpina	Campania	Avellino	AV	1283
IT	83050	San Potito Ultra	Campania	Avellino	AV	1284
IT	83050	Vallesaccarda	Campania	Avellino	AV	1285
IT	83051	Nusco	Campania	Avellino	AV	1286
IT	83051	Ponteromito	Campania	Avellino	AV	1287
IT	83052	Paternopoli	Campania	Avellino	AV	1288
IT	83053	Sant'Andrea Di Conza	Campania	Avellino	AV	1289
IT	83054	Sant'Angelo Dei Lombardi	Campania	Avellino	AV	1290
IT	83054	San Vito Dei Lombardi	Campania	Avellino	AV	1291
IT	83054	San Vito	Campania	Avellino	AV	1292
IT	83055	Sturno	Campania	Avellino	AV	1293
IT	83056	Teora	Campania	Avellino	AV	1294
IT	83057	Torella Dei Lombardi	Campania	Avellino	AV	1295
IT	83058	Trevico	Campania	Avellino	AV	1296
IT	83058	Molini	Campania	Avellino	AV	1297
IT	83059	Vallata	Campania	Avellino	AV	1298
IT	83100	Valle Ponticelli	Campania	Avellino	AV	1299
IT	83100	Picarelli	Campania	Avellino	AV	1300
IT	83100	Avellino	Campania	Avellino	AV	1301
IT	83100	Bellizzi Irpino	Campania	Avellino	AV	1302
IT	82010	Bucciano	Campania	Benevento	BN	1303
IT	82010	Ripabianca	Campania	Benevento	BN	1304
IT	82010	Iannassi	Campania	Benevento	BN	1305
IT	82010	San Leucio Del Sannio	Campania	Benevento	BN	1306
IT	82010	Perrillo	Campania	Benevento	BN	1307
IT	82010	Bosco Perrotta	Campania	Benevento	BN	1308
IT	82010	Sant'Angelo A Cupolo	Campania	Benevento	BN	1309
IT	82010	Luzzano	Campania	Benevento	BN	1310
IT	82010	Montorsi	Campania	Benevento	BN	1311
IT	82010	Cavuoti	Campania	Benevento	BN	1312
IT	82010	Pagliara	Campania	Benevento	BN	1313
IT	82010	Monterocchetta	Campania	Benevento	BN	1314
IT	82010	Beltiglio	Campania	Benevento	BN	1315
IT	82010	Motta	Campania	Benevento	BN	1316
IT	82010	Maccoli	Campania	Benevento	BN	1317
IT	82010	Arpaise	Campania	Benevento	BN	1318
IT	82010	Ceppaloni	Campania	Benevento	BN	1319
IT	82010	Moiano	Campania	Benevento	BN	1320
IT	82010	San Martino Sannita	Campania	Benevento	BN	1321
IT	82010	Terranova	Campania	Benevento	BN	1322
IT	82010	Beltiglio Di Ceppaloni	Campania	Benevento	BN	1323
IT	82010	Bagnara	Campania	Benevento	BN	1324
IT	82010	Pastene	Campania	Benevento	BN	1325
IT	82010	Ripabianca Tressanti	Campania	Benevento	BN	1326
IT	82010	San Nicola Manfredi	Campania	Benevento	BN	1327
IT	82010	San Giovanni Di Ceppaloni	Campania	Benevento	BN	1328
IT	82010	Terranova D'Arpaise	Campania	Benevento	BN	1329
IT	82011	Forchia	Campania	Benevento	BN	1330
IT	82011	Paolisi	Campania	Benevento	BN	1331
IT	82011	Arpaia	Campania	Benevento	BN	1332
IT	82011	Airola	Campania	Benevento	BN	1333
IT	82013	Bonea	Campania	Benevento	BN	1334
IT	82015	Durazzano	Campania	Benevento	BN	1335
IT	82016	Montesarchio	Campania	Benevento	BN	1336
IT	82016	Varoni	Campania	Benevento	BN	1337
IT	82016	Cirignano	Campania	Benevento	BN	1338
IT	82017	Pannarano	Campania	Benevento	BN	1339
IT	82018	Calvi	Campania	Benevento	BN	1340
IT	82018	San Nazzaro	Campania	Benevento	BN	1341
IT	82018	San Giorgio Del Sannio	Campania	Benevento	BN	1342
IT	82018	Cubante	Campania	Benevento	BN	1343
IT	82018	San Giovanni Di San Giorgio Del Sannio	Campania	Benevento	BN	1344
IT	82019	Laiano	Campania	Benevento	BN	1345
IT	82019	Bagnoli	Campania	Benevento	BN	1346
IT	82019	Sant'Agata De' Goti	Campania	Benevento	BN	1347
IT	82019	Faggiano	Campania	Benevento	BN	1348
IT	82020	San Giorgio La Molara	Campania	Benevento	BN	1349
IT	82020	Fragneto Monforte	Campania	Benevento	BN	1350
IT	82020	Campolattaro	Campania	Benevento	BN	1351
IT	82020	Pesco Sannita	Campania	Benevento	BN	1352
IT	82020	Buonalbergo	Campania	Benevento	BN	1353
IT	82020	Santa Croce Del Sannio	Campania	Benevento	BN	1354
IT	82020	Circello	Campania	Benevento	BN	1355
IT	82020	Reino	Campania	Benevento	BN	1356
IT	82020	Ginestra Degli Schiavoni	Campania	Benevento	BN	1357
IT	82020	Molinara	Campania	Benevento	BN	1358
IT	82020	Pago Veiano	Campania	Benevento	BN	1359
IT	82020	Pietrelcina	Campania	Benevento	BN	1360
IT	82020	Fragneto L'Abate	Campania	Benevento	BN	1361
IT	82020	Foiano Di Val Fortore	Campania	Benevento	BN	1362
IT	82020	Paduli	Campania	Benevento	BN	1363
IT	82020	Baselice	Campania	Benevento	BN	1364
IT	82021	Sant'Arcangelo Trimonte	Campania	Benevento	BN	1365
IT	82021	Apice	Campania	Benevento	BN	1366
IT	82021	Apice Nuovo	Campania	Benevento	BN	1367
IT	82022	Castelfranco In Miscano	Campania	Benevento	BN	1368
IT	82023	Castelvetere In Val Fortore	Campania	Benevento	BN	1369
IT	82024	Colle Sannita	Campania	Benevento	BN	1370
IT	82024	Castelpagano	Campania	Benevento	BN	1371
IT	82024	Decorata	Campania	Benevento	BN	1372
IT	82025	Montefalcone Di Val Fortore	Campania	Benevento	BN	1373
IT	82026	Cuffiano	Campania	Benevento	BN	1374
IT	82026	Morcone	Campania	Benevento	BN	1375
IT	82026	Sassinoro	Campania	Benevento	BN	1376
IT	82027	Giallonardo	Campania	Benevento	BN	1377
IT	82027	Pontelandolfo	Campania	Benevento	BN	1378
IT	82027	Casalduni	Campania	Benevento	BN	1379
IT	82028	San Bartolomeo In Galdo	Campania	Benevento	BN	1380
IT	82029	San Marco Dei Cavoti	Campania	Benevento	BN	1381
IT	82030	Limatola	Campania	Benevento	BN	1382
IT	82030	Dugenta	Campania	Benevento	BN	1383
IT	82030	Tocco Caudio	Campania	Benevento	BN	1384
IT	82030	Pietraroja	Campania	Benevento	BN	1385
IT	82030	Campoli Del Monte Taburno	Campania	Benevento	BN	1386
IT	82030	Ponte	Campania	Benevento	BN	1387
IT	82030	Castelpoto	Campania	Benevento	BN	1388
IT	82030	Apollosa	Campania	Benevento	BN	1389
IT	82030	Foglianise	Campania	Benevento	BN	1390
IT	82030	Torrecuso	Campania	Benevento	BN	1391
IT	82030	Ave Gratia Plena	Campania	Benevento	BN	1392
IT	82030	Melizzano	Campania	Benevento	BN	1393
IT	82030	Cacciano	Campania	Benevento	BN	1394
IT	82030	Biancano	Campania	Benevento	BN	1395
IT	82030	Faicchio	Campania	Benevento	BN	1396
IT	82030	Massa	Campania	Benevento	BN	1397
IT	82030	Paupisi	Campania	Benevento	BN	1398
IT	82030	Torello	Campania	Benevento	BN	1399
IT	82030	San Lorenzello	Campania	Benevento	BN	1400
IT	82030	Torello Di Melizzano	Campania	Benevento	BN	1401
IT	82030	Frasso Telesino	Campania	Benevento	BN	1402
IT	82030	Cautano	Campania	Benevento	BN	1403
IT	82030	Puglianello	Campania	Benevento	BN	1404
IT	82030	Giardoni	Campania	Benevento	BN	1405
IT	82030	San Salvatore Telesino	Campania	Benevento	BN	1406
IT	82031	Amorosi	Campania	Benevento	BN	1407
IT	82032	Cerreto Sannita	Campania	Benevento	BN	1408
IT	82033	Civitella Licinio	Campania	Benevento	BN	1409
IT	82033	Cusano Mutri	Campania	Benevento	BN	1410
IT	82034	San Lupo	Campania	Benevento	BN	1411
IT	82034	Guardia Sanframondi	Campania	Benevento	BN	1412
IT	82034	San Lorenzo Maggiore	Campania	Benevento	BN	1413
IT	82036	Solopaca	Campania	Benevento	BN	1414
IT	82037	Telese Terme	Campania	Benevento	BN	1415
IT	82037	Castelvenere	Campania	Benevento	BN	1416
IT	82038	Vitulano	Campania	Benevento	BN	1417
IT	82100	Benevento	Campania	Benevento	BN	1418
IT	82100	Perrillo	Campania	Benevento	BN	1419
IT	82100	Pastene	Campania	Benevento	BN	1420
IT	81010	Ciorlano	Campania	Caserta	CE	1421
IT	81010	Dragoni	Campania	Caserta	CE	1422
IT	81010	San Gregorio Matese	Campania	Caserta	CE	1423
IT	81010	Squille	Campania	Caserta	CE	1424
IT	81010	Letino	Campania	Caserta	CE	1425
IT	81010	Prata Sannita	Campania	Caserta	CE	1426
IT	81010	Vallelunga	Campania	Caserta	CE	1427
IT	81010	Castel Campagnano	Campania	Caserta	CE	1428
IT	81010	Ruviano	Campania	Caserta	CE	1429
IT	81010	Gioia Sannitica	Campania	Caserta	CE	1430
IT	81010	Pratella	Campania	Caserta	CE	1431
IT	81010	Alvignanello	Campania	Caserta	CE	1432
IT	81010	Ailano	Campania	Caserta	CE	1433
IT	81010	San Giorgio	Campania	Caserta	CE	1434
IT	81010	Calvisi	Campania	Caserta	CE	1435
IT	81010	Valle Agricola	Campania	Caserta	CE	1436
IT	81010	Gallo Matese	Campania	Caserta	CE	1437
IT	81010	Torcino	Campania	Caserta	CE	1438
IT	81010	Carattano	Campania	Caserta	CE	1439
IT	81010	Latina Di Baia	Campania	Caserta	CE	1440
IT	81010	Baia E Latina	Campania	Caserta	CE	1441
IT	81011	Totari	Campania	Caserta	CE	1442
IT	81011	Alife	Campania	Caserta	CE	1443
IT	81012	Alvignano	Campania	Caserta	CE	1444
IT	81012	Marciano Freddo	Campania	Caserta	CE	1445
IT	81013	Piana Di Monte Verna	Campania	Caserta	CE	1446
IT	81013	Villa Santa Croce	Campania	Caserta	CE	1447
IT	81013	San Giovanni E Paolo	Campania	Caserta	CE	1448
IT	81013	Caiazzo	Campania	Caserta	CE	1449
IT	81014	Capriati A Volturno	Campania	Caserta	CE	1450
IT	81014	Fontegreca	Campania	Caserta	CE	1451
IT	81016	Piedimonte Matese	Campania	Caserta	CE	1452
IT	81016	Sepicciano	Campania	Caserta	CE	1453
IT	81016	Castello Del Matese	Campania	Caserta	CE	1454
IT	81016	San Potito Sannitico	Campania	Caserta	CE	1455
IT	81016	Piedimonte D'Alife	Campania	Caserta	CE	1456
IT	81017	Sant'Angelo D'Alife	Campania	Caserta	CE	1457
IT	81017	Raviscanina	Campania	Caserta	CE	1458
IT	81017	Quattroventi	Campania	Caserta	CE	1459
IT	81020	Casapulla	Campania	Caserta	CE	1460
IT	81020	San Nicola La Strada	Campania	Caserta	CE	1461
IT	81020	San Marco Evangelista	Campania	Caserta	CE	1462
IT	81020	Capodrise	Campania	Caserta	CE	1463
IT	81020	Recale	Campania	Caserta	CE	1464
IT	81020	Castel Morrone	Campania	Caserta	CE	1465
IT	81020	Annunziata	Campania	Caserta	CE	1466
IT	81020	Valle Di Maddaloni	Campania	Caserta	CE	1467
IT	81021	Arienzo	Campania	Caserta	CE	1468
IT	81022	Casagiove	Campania	Caserta	CE	1469
IT	81023	Forchia Di Cervino	Campania	Caserta	CE	1470
IT	81023	Cervino	Campania	Caserta	CE	1471
IT	81023	Messercola	Campania	Caserta	CE	1472
IT	81024	Montedecoro	Campania	Caserta	CE	1473
IT	81024	Maddaloni	Campania	Caserta	CE	1474
IT	81024	Grotticella	Campania	Caserta	CE	1475
IT	81025	Marcianise	Campania	Caserta	CE	1476
IT	81025	Cantone	Campania	Caserta	CE	1477
IT	81027	Cave	Campania	Caserta	CE	1478
IT	81027	San Felice A Cancello	Campania	Caserta	CE	1479
IT	81027	Cave Di San Felice	Campania	Caserta	CE	1480
IT	81027	Cancello Di Ferrovia	Campania	Caserta	CE	1481
IT	81027	Polvica	Campania	Caserta	CE	1482
IT	81027	San Marco Trotti	Campania	Caserta	CE	1483
IT	81028	Santa Maria A Vico	Campania	Caserta	CE	1484
IT	81030	Casaluce	Campania	Caserta	CE	1485
IT	81030	Orta Di Atella	Campania	Caserta	CE	1486
IT	81030	Teverola	Campania	Caserta	CE	1487
IT	81030	Villa Di Briano	Campania	Caserta	CE	1488
IT	81030	Casapesenna	Campania	Caserta	CE	1489
IT	81030	Carinola	Campania	Caserta	CE	1490
IT	81030	Succivo	Campania	Caserta	CE	1491
IT	81030	Falciano Del Massico	Campania	Caserta	CE	1492
IT	81030	Cesa	Campania	Caserta	CE	1493
IT	81030	Baia Domizia	Campania	Caserta	CE	1494
IT	81030	Gricignano Di Aversa	Campania	Caserta	CE	1495
IT	81030	Nocelleto	Campania	Caserta	CE	1496
IT	81030	Cellole	Campania	Caserta	CE	1497
IT	81030	Frignano	Campania	Caserta	CE	1498
IT	81030	San Marcellino	Campania	Caserta	CE	1499
IT	81030	Cancello	Campania	Caserta	CE	1500
IT	81030	Cancello Ed Arnone	Campania	Caserta	CE	1501
IT	81030	Castel Volturno	Campania	Caserta	CE	1502
IT	81030	Casale Di Carinola	Campania	Caserta	CE	1503
IT	81030	Sant'Arpino	Campania	Caserta	CE	1504
IT	81030	Villaggio Coppola Pinetamare	Campania	Caserta	CE	1505
IT	81030	Casale	Campania	Caserta	CE	1506
IT	81030	Lusciano	Campania	Caserta	CE	1507
IT	81030	Parete	Campania	Caserta	CE	1508
IT	81031	Aversa	Campania	Caserta	CE	1509
IT	81032	Carinaro	Campania	Caserta	CE	1510
IT	81033	Casal Di Principe	Campania	Caserta	CE	1511
IT	81034	Mondragone	Campania	Caserta	CE	1512
IT	81035	Gallo	Campania	Caserta	CE	1513
IT	81035	Roccamonfina	Campania	Caserta	CE	1514
IT	81035	Ameglio	Campania	Caserta	CE	1515
IT	81035	Fontanafredda	Campania	Caserta	CE	1516
IT	81035	Marzano Appio	Campania	Caserta	CE	1517
IT	81035	Campagnola	Campania	Caserta	CE	1518
IT	81035	Grottola	Campania	Caserta	CE	1519
IT	81035	Filorsi	Campania	Caserta	CE	1520
IT	81035	Garofali	Campania	Caserta	CE	1521
IT	81036	San Cipriano D'Aversa	Campania	Caserta	CE	1522
IT	81037	San Castrese	Campania	Caserta	CE	1523
IT	81037	Cascano	Campania	Caserta	CE	1524
IT	81037	San Carlo Di Sessa Aurunca	Campania	Caserta	CE	1525
IT	81037	Lauro Di Sessa Aurunca	Campania	Caserta	CE	1526
IT	81037	San Carlo	Campania	Caserta	CE	1527
IT	81037	Santa Maria Valongo	Campania	Caserta	CE	1528
IT	81037	Valogno	Campania	Caserta	CE	1529
IT	81037	Carano	Campania	Caserta	CE	1530
IT	81037	Cupa	Campania	Caserta	CE	1531
IT	81037	San Martino Di Sessa Aurunca	Campania	Caserta	CE	1532
IT	81037	Cupa E Fasani	Campania	Caserta	CE	1533
IT	81037	Carano Di Sessa Aurunca	Campania	Caserta	CE	1534
IT	81037	Corigliano	Campania	Caserta	CE	1535
IT	81037	San Martino	Campania	Caserta	CE	1536
IT	81037	Piedimonte Di Sessa Aurunca	Campania	Caserta	CE	1537
IT	81037	Avezzano Sorbello	Campania	Caserta	CE	1538
IT	81037	Piedimonte	Campania	Caserta	CE	1539
IT	81037	Fontanaradina	Campania	Caserta	CE	1540
IT	81037	Sessa Aurunca	Campania	Caserta	CE	1541
IT	81037	Sant'Agata	Campania	Caserta	CE	1542
IT	81037	Fasani	Campania	Caserta	CE	1543
IT	81038	Trentola Ducenta	Campania	Caserta	CE	1544
IT	81039	Villa Literno	Campania	Caserta	CE	1545
IT	81039	Bonifica Villa Literno	Campania	Caserta	CE	1546
IT	81040	Pietravairano	Campania	Caserta	CE	1547
IT	81040	Camino	Campania	Caserta	CE	1548
IT	81040	Bivio Mortola	Campania	Caserta	CE	1549
IT	81040	Treglia	Campania	Caserta	CE	1550
IT	81040	Pontelatone	Campania	Caserta	CE	1551
IT	81040	Maiorano Di Monte	Campania	Caserta	CE	1552
IT	81040	Castel Di Sasso	Campania	Caserta	CE	1553
IT	81040	Cisterna Di Castel Di Sasso	Campania	Caserta	CE	1554
IT	81040	Rocca D'Evandro	Campania	Caserta	CE	1555
IT	81040	Cocuruzzo	Campania	Caserta	CE	1556
IT	81040	San Felice A Pietravairano	Campania	Caserta	CE	1557
IT	81040	Formicola	Campania	Caserta	CE	1558
IT	81040	Cisterna	Campania	Caserta	CE	1559
IT	81040	Liberi	Campania	Caserta	CE	1560
IT	81040	San Felice	Campania	Caserta	CE	1561
IT	81040	Curti	Campania	Caserta	CE	1562
IT	81040	Borgo Sant'Antonio Abate	Campania	Caserta	CE	1563
IT	81041	Bellona	Campania	Caserta	CE	1564
IT	81041	Vitulazio	Campania	Caserta	CE	1565
IT	81042	Giano Vetusto	Campania	Caserta	CE	1566
IT	81042	Petrulo	Campania	Caserta	CE	1567
IT	81042	Visciano	Campania	Caserta	CE	1568
IT	81042	Calvi Risorta	Campania	Caserta	CE	1569
IT	81042	Rocchetta E Croce	Campania	Caserta	CE	1570
IT	81042	Pozzillo	Campania	Caserta	CE	1571
IT	81042	Petrullo	Campania	Caserta	CE	1572
IT	81042	Val D'Assano	Campania	Caserta	CE	1573
IT	81043	Capua	Campania	Caserta	CE	1574
IT	81043	Sant'Angelo In Formis	Campania	Caserta	CE	1575
IT	81044	Orchi	Campania	Caserta	CE	1576
IT	81044	Galluccio	Campania	Caserta	CE	1577
IT	81044	Vaglie	Campania	Caserta	CE	1578
IT	81044	Conca Della Campania	Campania	Caserta	CE	1579
IT	81044	Piccilli	Campania	Caserta	CE	1580
IT	81044	Tora	Campania	Caserta	CE	1581
IT	81044	Cave	Campania	Caserta	CE	1582
IT	81044	Tora E Piccilli	Campania	Caserta	CE	1583
IT	81044	San Clemente	Campania	Caserta	CE	1584
IT	81044	Sipicciano	Campania	Caserta	CE	1585
IT	81046	Borgo Appio	Campania	Caserta	CE	1586
IT	81046	Brezza	Campania	Caserta	CE	1587
IT	81046	Grazzanise	Campania	Caserta	CE	1588
IT	81046	Borgo Rurale Appio	Campania	Caserta	CE	1589
IT	81047	Macerata Campania	Campania	Caserta	CE	1590
IT	81047	Caturano	Campania	Caserta	CE	1591
IT	81049	Mignano Monte Lungo	Campania	Caserta	CE	1592
IT	81049	San Pietro Infine	Campania	Caserta	CE	1593
IT	81049	Caspoli	Campania	Caserta	CE	1594
IT	81050	Francolise	Campania	Caserta	CE	1595
IT	81050	Santa Maria La Fossa	Campania	Caserta	CE	1596
IT	81050	Ciamprisco	Campania	Caserta	CE	1597
IT	81050	San Tammaro	Campania	Caserta	CE	1598
IT	81050	Pastorano	Campania	Caserta	CE	1599
IT	81050	Pantuliano	Campania	Caserta	CE	1600
IT	81050	Montanaro	Campania	Caserta	CE	1601
IT	81050	Camigliano	Campania	Caserta	CE	1602
IT	81050	San Felice	Campania	Caserta	CE	1603
IT	81050	Sant'Andrea Del Pizzone	Campania	Caserta	CE	1604
IT	81050	Portico Di Caserta	Campania	Caserta	CE	1605
IT	81050	Presenzano	Campania	Caserta	CE	1606
IT	81050	Musicile	Campania	Caserta	CE	1607
IT	81051	Pietramelara	Campania	Caserta	CE	1608
IT	81051	Roccaromana	Campania	Caserta	CE	1609
IT	81051	Statigliano	Campania	Caserta	CE	1610
IT	81052	Pignataro Maggiore	Campania	Caserta	CE	1611
IT	81053	Riardo	Campania	Caserta	CE	1612
IT	81054	San Prisco	Campania	Caserta	CE	1613
IT	81055	Santa Maria Capua Vetere	Campania	Caserta	CE	1614
IT	81056	Sparanise	Campania	Caserta	CE	1615
IT	81057	Teano	Campania	Caserta	CE	1616
IT	81057	Pugliano	Campania	Caserta	CE	1617
IT	81057	Versano	Campania	Caserta	CE	1618
IT	81057	Fontanelle	Campania	Caserta	CE	1619
IT	81057	San Marco	Campania	Caserta	CE	1620
IT	81057	Casafredda	Campania	Caserta	CE	1621
IT	81057	Casamostra	Campania	Caserta	CE	1622
IT	81057	San Giuliano	Campania	Caserta	CE	1623
IT	81057	Casale	Campania	Caserta	CE	1624
IT	81057	Furnolo	Campania	Caserta	CE	1625
IT	81057	Casi	Campania	Caserta	CE	1626
IT	81057	Casale Di Teano	Campania	Caserta	CE	1627
IT	81058	Vairano Patenora	Campania	Caserta	CE	1628
IT	81058	Marzanello	Campania	Caserta	CE	1629
IT	81058	Vairano Scalo	Campania	Caserta	CE	1630
IT	81058	Vairano	Campania	Caserta	CE	1631
IT	81058	Patenora	Campania	Caserta	CE	1632
IT	81059	Caianello	Campania	Caserta	CE	1633
IT	81059	Vairano Stazione	Campania	Caserta	CE	1634
IT	81059	Santa Lucia	Campania	Caserta	CE	1635
IT	81059	Montano	Campania	Caserta	CE	1636
IT	81100	Sala Di Caserta	Campania	Caserta	CE	1637
IT	81100	Casertavecchia	Campania	Caserta	CE	1638
IT	81100	Casola Di Caserta	Campania	Caserta	CE	1639
IT	81100	Caserta	Campania	Caserta	CE	1640
IT	81100	San Clemente Di Caserta	Campania	Caserta	CE	1641
IT	81100	Tuoro	Campania	Caserta	CE	1642
IT	81100	Tredici	Campania	Caserta	CE	1643
IT	81100	Santa Barbara	Campania	Caserta	CE	1644
IT	81100	Casola	Campania	Caserta	CE	1645
IT	81100	San Leucio	Campania	Caserta	CE	1646
IT	81100	Briano	Campania	Caserta	CE	1647
IT	81100	San Clemente	Campania	Caserta	CE	1648
IT	81100	Ercole	Campania	Caserta	CE	1649
IT	81100	Mezzano	Campania	Caserta	CE	1650
IT	81100	Vaccheria	Campania	Caserta	CE	1651
IT	81100	Staturano	Campania	Caserta	CE	1652
IT	81100	Centurano	Campania	Caserta	CE	1653
IT	81100	Casolla	Campania	Caserta	CE	1654
IT	81100	Falciano	Campania	Caserta	CE	1655
IT	81100	Puccianiello	Campania	Caserta	CE	1656
IT	80010	Quarto	Campania	Napoli	NA	1657
IT	80010	Scalzapecora	Campania	Napoli	NA	1658
IT	80010	Villaricca	Campania	Napoli	NA	1659
IT	80010	Torretta	Campania	Napoli	NA	1660
IT	80011	Pezzalunga	Campania	Napoli	NA	1661
IT	80011	Acerra	Campania	Napoli	NA	1662
IT	80012	Calvizzano	Campania	Napoli	NA	1663
IT	80013	Casarea	Campania	Napoli	NA	1664
IT	80013	Casalnuovo Di Napoli	Campania	Napoli	NA	1665
IT	80013	Tavernanova	Campania	Napoli	NA	1666
IT	80013	Licignano Di Napoli	Campania	Napoli	NA	1667
IT	80014	Varcaturo	Campania	Napoli	NA	1668
IT	80014	Lago Patria	Campania	Napoli	NA	1669
IT	80014	Giugliano In Campania	Campania	Napoli	NA	1670
IT	80016	Marano Di Napoli	Campania	Napoli	NA	1671
IT	80016	San Rocco	Campania	Napoli	NA	1672
IT	80016	Torre Piscitelli	Campania	Napoli	NA	1673
IT	80017	Melito Di Napoli	Campania	Napoli	NA	1674
IT	80018	Mugnano Di Napoli	Campania	Napoli	NA	1675
IT	80019	Qualiano	Campania	Napoli	NA	1676
IT	80020	Parco Delle Acacie	Campania	Napoli	NA	1677
IT	80020	Frattaminore	Campania	Napoli	NA	1678
IT	80020	Crispano	Campania	Napoli	NA	1679
IT	80020	Casavatore	Campania	Napoli	NA	1680
IT	80021	Afragola	Campania	Napoli	NA	1681
IT	80022	Arzano	Campania	Napoli	NA	1682
IT	80023	Pascarola	Campania	Napoli	NA	1683
IT	80023	Caivano	Campania	Napoli	NA	1684
IT	80024	Cardito	Campania	Napoli	NA	1685
IT	80024	Carditello	Campania	Napoli	NA	1686
IT	80025	Casandrino	Campania	Napoli	NA	1687
IT	80026	Casoria	Campania	Napoli	NA	1688
IT	80026	Arpino	Campania	Napoli	NA	1689
IT	80027	Frattamaggiore	Campania	Napoli	NA	1690
IT	80028	Grumo Nevano	Campania	Napoli	NA	1691
IT	80029	Sant'Antimo	Campania	Napoli	NA	1692
IT	80030	Visciano	Campania	Napoli	NA	1693
IT	80030	San Paolo Bel Sito	Campania	Napoli	NA	1694
IT	80030	Carbonara Di Nola	Campania	Napoli	NA	1695
IT	80030	San Vitaliano	Campania	Napoli	NA	1696
IT	80030	Comiziano	Campania	Napoli	NA	1697
IT	80030	Spartimento	Campania	Napoli	NA	1698
IT	80030	Scisciano	Campania	Napoli	NA	1699
IT	80030	Mariglianella	Campania	Napoli	NA	1700
IT	80030	Camposano	Campania	Napoli	NA	1701
IT	80030	Gallo	Campania	Napoli	NA	1702
IT	80030	Cimitile	Campania	Napoli	NA	1703
IT	80030	Tufino	Campania	Napoli	NA	1704
IT	80030	Castello Di Cisterna	Campania	Napoli	NA	1705
IT	80030	Liveri	Campania	Napoli	NA	1706
IT	80030	Gargani	Campania	Napoli	NA	1707
IT	80030	Roccarainola	Campania	Napoli	NA	1708
IT	80030	Schiava	Campania	Napoli	NA	1709
IT	80031	Brusciano	Campania	Napoli	NA	1710
IT	80032	Casamarciano	Campania	Napoli	NA	1711
IT	80033	Cicciano	Campania	Napoli	NA	1712
IT	80034	Selva	Campania	Napoli	NA	1713
IT	80034	Lausdomini	Campania	Napoli	NA	1714
IT	80034	Marigliano	Campania	Napoli	NA	1715
IT	80034	Faibano	Campania	Napoli	NA	1716
IT	80034	Casaferro	Campania	Napoli	NA	1717
IT	80035	Pollastri	Campania	Napoli	NA	1718
IT	80035	Cinquevie	Campania	Napoli	NA	1719
IT	80035	Piazzolla	Campania	Napoli	NA	1720
IT	80035	Nola	Campania	Napoli	NA	1721
IT	80035	Polvica	Campania	Napoli	NA	1722
IT	80036	Vico	Campania	Napoli	NA	1723
IT	80036	Castello	Campania	Napoli	NA	1724
IT	80036	Palma Campania	Campania	Napoli	NA	1725
IT	80036	Vico Di Palma	Campania	Napoli	NA	1726
IT	80038	Pomigliano D'Arco	Campania	Napoli	NA	1727
IT	80039	Piazzolla Di Saviano	Campania	Napoli	NA	1728
IT	80039	Saviano	Campania	Napoli	NA	1729
IT	80040	San Gennaro Vesuviano	Campania	Napoli	NA	1730
IT	80040	Volla	Campania	Napoli	NA	1731
IT	80040	Cercola	Campania	Napoli	NA	1732
IT	80040	Trecase	Campania	Napoli	NA	1733
IT	80040	Massa Di Somma	Campania	Napoli	NA	1734
IT	80040	Pollena Trocchia	Campania	Napoli	NA	1735
IT	80040	San Sebastiano Al Vesuvio	Campania	Napoli	NA	1736
IT	80040	Poggiomarino	Campania	Napoli	NA	1737
IT	80040	Terzigno	Campania	Napoli	NA	1738
IT	80040	Musci	Campania	Napoli	NA	1739
IT	80040	Flocco	Campania	Napoli	NA	1740
IT	80040	Striano	Campania	Napoli	NA	1741
IT	80040	Caravita	Campania	Napoli	NA	1742
IT	80040	Boccia Al Mauro	Campania	Napoli	NA	1743
IT	80041	Boscoreale	Campania	Napoli	NA	1744
IT	80041	Marchesa	Campania	Napoli	NA	1745
IT	80042	Boscotrecase	Campania	Napoli	NA	1746
IT	80044	Ottaviano	Campania	Napoli	NA	1747
IT	80044	San Gennarello	Campania	Napoli	NA	1748
IT	80045	Pompei	Campania	Napoli	NA	1749
IT	80045	Pompei Scavi	Campania	Napoli	NA	1750
IT	80045	Messigno	Campania	Napoli	NA	1751
IT	80045	Mariconda	Campania	Napoli	NA	1752
IT	80046	San Giorgio A Cremano	Campania	Napoli	NA	1753
IT	80047	San Giuseppe Vesuviano	Campania	Napoli	NA	1754
IT	80047	Santa Maria La Scala	Campania	Napoli	NA	1755
IT	80047	Casilli	Campania	Napoli	NA	1756
IT	80048	Ponte Di Ferro	Campania	Napoli	NA	1757
IT	80048	Madonna Dell'Arco	Campania	Napoli	NA	1758
IT	80048	Sant'Anastasia	Campania	Napoli	NA	1759
IT	80048	Starza Vecchia	Campania	Napoli	NA	1760
IT	80049	Somma Vesuviana	Campania	Napoli	NA	1761
IT	80050	Pimonte	Campania	Napoli	NA	1762
IT	80050	San Nicola	Campania	Napoli	NA	1763
IT	80050	Piazza Roma	Campania	Napoli	NA	1764
IT	80050	Casola Di Napoli	Campania	Napoli	NA	1765
IT	80050	Piazza	Campania	Napoli	NA	1766
IT	80050	Tralia	Campania	Napoli	NA	1767
IT	80050	Santa Maria La Carita'	Campania	Napoli	NA	1768
IT	80050	Franche	Campania	Napoli	NA	1769
IT	80050	Lettere	Campania	Napoli	NA	1770
IT	80051	Bomerano	Campania	Napoli	NA	1771
IT	80051	Agerola	Campania	Napoli	NA	1772
IT	80051	Pianillo	Campania	Napoli	NA	1773
IT	80051	San Lazzaro Di Agerola	Campania	Napoli	NA	1774
IT	80053	Castellammare Di Stabia	Campania	Napoli	NA	1775
IT	80053	Quisisana	Campania	Napoli	NA	1776
IT	80053	Scanzano	Campania	Napoli	NA	1777
IT	80053	Ponte Della Persica	Campania	Napoli	NA	1778
IT	80054	Gragnano	Campania	Napoli	NA	1779
IT	80054	Caprile	Campania	Napoli	NA	1780
IT	80055	Portici	Campania	Napoli	NA	1781
IT	80055	Bellavista	Campania	Napoli	NA	1782
IT	80056	Resina	Campania	Napoli	NA	1783
IT	80056	Ercolano	Campania	Napoli	NA	1784
IT	80057	Sant'Antonio Abate	Campania	Napoli	NA	1785
IT	80058	Torre Annunziata	Campania	Napoli	NA	1786
IT	80059	Torre Del Greco	Campania	Napoli	NA	1787
IT	80059	Santa Maria La Bruna	Campania	Napoli	NA	1788
IT	80059	Leopardi	Campania	Napoli	NA	1789
IT	80060	Monte Faito	Campania	Napoli	NA	1790
IT	80060	Massaquano	Campania	Napoli	NA	1791
IT	80061	Massa Lubrense	Campania	Napoli	NA	1792
IT	80061	Sant'Agata Sui Due Golfi	Campania	Napoli	NA	1793
IT	80061	Nerano	Campania	Napoli	NA	1794
IT	80061	Termini	Campania	Napoli	NA	1795
IT	80061	Monticchio Di Massa Lubrense	Campania	Napoli	NA	1796
IT	80062	Meta	Campania	Napoli	NA	1797
IT	80063	Piano Di Sorrento	Campania	Napoli	NA	1798
IT	80065	Colli Di Fontanelle	Campania	Napoli	NA	1799
IT	80065	Sant'Agnello	Campania	Napoli	NA	1800
IT	80066	Seiano	Campania	Napoli	NA	1801
IT	80066	Montechiaro	Campania	Napoli	NA	1802
IT	80066	Fornacella	Campania	Napoli	NA	1803
IT	80066	Fornacelle	Campania	Napoli	NA	1804
IT	80067	Capo Di Sorrento	Campania	Napoli	NA	1805
IT	80067	Sorrento	Campania	Napoli	NA	1806
IT	80067	Priora	Campania	Napoli	NA	1807
IT	80069	Vico Equense	Campania	Napoli	NA	1808
IT	80069	Villaggio Monte Faito	Campania	Napoli	NA	1809
IT	80069	Moiano	Campania	Napoli	NA	1810
IT	80070	Sant'Angelo	Campania	Napoli	NA	1811
IT	80070	Cuma	Campania	Napoli	NA	1812
IT	80070	Monte Di Procida	Campania	Napoli	NA	1813
IT	80070	Barano D'Ischia	Campania	Napoli	NA	1814
IT	80070	Miseno	Campania	Napoli	NA	1815
IT	80070	Serrara Fontana	Campania	Napoli	NA	1816
IT	80070	Bacoli	Campania	Napoli	NA	1817
IT	80070	Baia	Campania	Napoli	NA	1818
IT	80070	Cappella	Campania	Napoli	NA	1819
IT	80070	Capo Miseno	Campania	Napoli	NA	1820
IT	80070	Fusaro	Campania	Napoli	NA	1821
IT	80070	Fontana	Campania	Napoli	NA	1822
IT	80070	Miliscola	Campania	Napoli	NA	1823
IT	80070	Testaccio D'Ischia	Campania	Napoli	NA	1824
IT	80070	Serrara	Campania	Napoli	NA	1825
IT	80070	Buonopane	Campania	Napoli	NA	1826
IT	80070	Torregaveta	Campania	Napoli	NA	1827
IT	80070	Succhivo	Campania	Napoli	NA	1828
IT	80071	Anacapri	Campania	Napoli	NA	1829
IT	80073	Capri	Campania	Napoli	NA	1830
IT	80073	Marina Grande Di Capri	Campania	Napoli	NA	1831
IT	80074	Casamicciola Terme	Campania	Napoli	NA	1832
IT	80075	Monterone	Campania	Napoli	NA	1833
IT	80075	Forio	Campania	Napoli	NA	1834
IT	80075	Panza	Campania	Napoli	NA	1835
IT	80076	Lacco Ameno	Campania	Napoli	NA	1836
IT	80077	Ischia Ponte	Campania	Napoli	NA	1837
IT	80077	Ischia	Campania	Napoli	NA	1838
IT	80077	Ischia San Michele	Campania	Napoli	NA	1839
IT	80077	Ischia Porto	Campania	Napoli	NA	1840
IT	80077	Piedimonte D'Ischia	Campania	Napoli	NA	1841
IT	80077	Sant'Antuono D'Ischia	Campania	Napoli	NA	1842
IT	80078	Pozzuoli	Campania	Napoli	NA	1843
IT	80078	Monterusciello	Campania	Napoli	NA	1844
IT	80078	Lucrino	Campania	Napoli	NA	1845
IT	80078	Arco Felice	Campania	Napoli	NA	1846
IT	80078	Licola	Campania	Napoli	NA	1847
IT	80078	Cappuccini	Campania	Napoli	NA	1848
IT	80078	Lago Averno	Campania	Napoli	NA	1849
IT	80078	Lido Di Licola	Campania	Napoli	NA	1850
IT	80079	Procida	Campania	Napoli	NA	1851
IT	80100	Napoli	Campania	Napoli	NA	1852
IT	80121	Napoli	Campania	Napoli	NA	1853
IT	80122	Chiaia	Campania	Napoli	NA	1854
IT	80122	Napoli	Campania	Napoli	NA	1855
IT	80123	Napoli	Campania	Napoli	NA	1856
IT	80124	Bagnoli	Campania	Napoli	NA	1857
IT	80124	Napoli	Campania	Napoli	NA	1858
IT	80125	Agnano	Campania	Napoli	NA	1859
IT	80125	Napoli	Campania	Napoli	NA	1860
IT	80126	Soccavo	Campania	Napoli	NA	1861
IT	80126	Pianura	Campania	Napoli	NA	1862
IT	80126	Napoli	Campania	Napoli	NA	1863
IT	80127	Vomero	Campania	Napoli	NA	1864
IT	80127	Napoli	Campania	Napoli	NA	1865
IT	80128	Napoli	Campania	Napoli	NA	1866
IT	80129	Napoli	Campania	Napoli	NA	1867
IT	80131	Miano	Campania	Napoli	NA	1868
IT	80131	Napoli	Campania	Napoli	NA	1869
IT	80131	Cappella Cangiani	Campania	Napoli	NA	1870
IT	80131	Arenella	Campania	Napoli	NA	1871
IT	80132	Napoli	Campania	Napoli	NA	1872
IT	80133	Napoli	Campania	Napoli	NA	1873
IT	80134	Napoli	Campania	Napoli	NA	1874
IT	80135	Napoli	Campania	Napoli	NA	1875
IT	80136	Napoli	Campania	Napoli	NA	1876
IT	80137	Napoli	Campania	Napoli	NA	1877
IT	80138	Napoli	Campania	Napoli	NA	1878
IT	80139	Napoli	Campania	Napoli	NA	1879
IT	80141	Napoli	Campania	Napoli	NA	1880
IT	80142	Napoli	Campania	Napoli	NA	1881
IT	80143	Napoli	Campania	Napoli	NA	1882
IT	80144	Secondigliano	Campania	Napoli	NA	1883
IT	80144	San Pietro A Patierno	Campania	Napoli	NA	1884
IT	80144	Napoli	Campania	Napoli	NA	1885
IT	80145	Piscinola	Campania	Napoli	NA	1886
IT	80145	Miano	Campania	Napoli	NA	1887
IT	80145	Napoli	Campania	Napoli	NA	1888
IT	80145	Chiaiano Ed Uniti	Campania	Napoli	NA	1889
IT	80145	Scampia	Campania	Napoli	NA	1890
IT	80145	Marianella	Campania	Napoli	NA	1891
IT	80146	San Giovanni A Teduccio	Campania	Napoli	NA	1892
IT	80146	Napoli	Campania	Napoli	NA	1893
IT	80147	Barra	Campania	Napoli	NA	1894
IT	80147	Napoli	Campania	Napoli	NA	1895
IT	80147	Ponticelli	Campania	Napoli	NA	1896
IT	84010	Erchie	Campania	Salerno	SA	1897
IT	84010	Pontone	Campania	Salerno	SA	1898
IT	84010	Corbara	Campania	Salerno	SA	1899
IT	84010	Atrani	Campania	Salerno	SA	1900
IT	84010	Scala	Campania	Salerno	SA	1901
IT	84010	Campinola	Campania	Salerno	SA	1902
IT	84010	Sant'Egidio Del Monte Albino	Campania	Salerno	SA	1903
IT	84010	San Valentino Torio	Campania	Salerno	SA	1904
IT	84010	Tramonti	Campania	Salerno	SA	1905
IT	84010	Conca Dei Marini	Campania	Salerno	SA	1906
IT	84010	Ravello	Campania	Salerno	SA	1907
IT	84010	San Lorenzo Di Sant'Egidio	Campania	Salerno	SA	1908
IT	84010	Minori	Campania	Salerno	SA	1909
IT	84010	Maiori	Campania	Salerno	SA	1910
IT	84010	Praiano	Campania	Salerno	SA	1911
IT	84010	Cetara	Campania	Salerno	SA	1912
IT	84010	Furore	Campania	Salerno	SA	1913
IT	84010	San Michele	Campania	Salerno	SA	1914
IT	84010	San Marzano Sul Sarno	Campania	Salerno	SA	1915
IT	84011	Pogerola	Campania	Salerno	SA	1916
IT	84011	Amalfi	Campania	Salerno	SA	1917
IT	84011	Lone	Campania	Salerno	SA	1918
IT	84011	Pogerola Di Amalfi	Campania	Salerno	SA	1919
IT	84011	Vettica Pastena	Campania	Salerno	SA	1920
IT	84011	Pastena	Campania	Salerno	SA	1921
IT	84012	Angri	Campania	Salerno	SA	1922
IT	84013	Alessia	Campania	Salerno	SA	1923
IT	84013	Corpo Di Cava	Campania	Salerno	SA	1924
IT	84013	Marini	Campania	Salerno	SA	1925
IT	84013	Dupino	Campania	Salerno	SA	1926
IT	84013	Passiano	Campania	Salerno	SA	1927
IT	84013	Cava De' Tirreni	Campania	Salerno	SA	1928
IT	84013	Badia Di Cava De' Tirreni	Campania	Salerno	SA	1929
IT	84013	San Pietro Di Cava	Campania	Salerno	SA	1930
IT	84013	Arcara	Campania	Salerno	SA	1931
IT	84013	Santa Lucia Di Cava	Campania	Salerno	SA	1932
IT	84013	Pregiato	Campania	Salerno	SA	1933
IT	84014	Nocera Inferiore	Campania	Salerno	SA	1934
IT	84015	Materdomini Di Nocera	Campania	Salerno	SA	1935
IT	84015	Nocera Superiore	Campania	Salerno	SA	1936
IT	84016	Pagani	Campania	Salerno	SA	1937
IT	84017	Montepertuso	Campania	Salerno	SA	1938
IT	84017	Positano	Campania	Salerno	SA	1939
IT	84018	San Pietro Di Scafati	Campania	Salerno	SA	1940
IT	84018	Scafati	Campania	Salerno	SA	1941
IT	84019	Raito	Campania	Salerno	SA	1942
IT	84019	Dragonea	Campania	Salerno	SA	1943
IT	84019	Vietri Sul Mare	Campania	Salerno	SA	1944
IT	84019	Benincasa	Campania	Salerno	SA	1945
IT	84019	Molina	Campania	Salerno	SA	1946
IT	84019	Marina Di Vietri	Campania	Salerno	SA	1947
IT	84019	Molina Di Vietri Sul Mare	Campania	Salerno	SA	1948
IT	84020	Castelnuovo Di Conza	Campania	Salerno	SA	1949
IT	84020	Oliveto Citra	Campania	Salerno	SA	1950
IT	84020	Romagnano Al Monte	Campania	Salerno	SA	1951
IT	84020	Corleto Monforte	Campania	Salerno	SA	1952
IT	84020	Perrazze	Campania	Salerno	SA	1953
IT	84020	Petina	Campania	Salerno	SA	1954
IT	84020	Aquara	Campania	Salerno	SA	1955
IT	84020	Quadrivio Di Campagna	Campania	Salerno	SA	1956
IT	84020	Valva	Campania	Salerno	SA	1957
IT	84020	Roscigno	Campania	Salerno	SA	1958
IT	84020	Castelcivita	Campania	Salerno	SA	1959
IT	84020	Ricigliano	Campania	Salerno	SA	1960
IT	84020	Bellosguardo	Campania	Salerno	SA	1961
IT	84020	Salvitelle	Campania	Salerno	SA	1962
IT	84020	Laviano	Campania	Salerno	SA	1963
IT	84020	Santomenna	Campania	Salerno	SA	1964
IT	84020	Ottati	Campania	Salerno	SA	1965
IT	84020	San Gregorio Magno	Campania	Salerno	SA	1966
IT	84020	Serra Di Castelcivita	Campania	Salerno	SA	1967
IT	84020	Controne	Campania	Salerno	SA	1968
IT	84020	Bivio Palomonte	Campania	Salerno	SA	1969
IT	84020	Centro Urbano	Campania	Salerno	SA	1970
IT	84020	Colliano	Campania	Salerno	SA	1971
IT	84020	Palomonte	Campania	Salerno	SA	1972
IT	84021	Tufariello	Campania	Salerno	SA	1973
IT	84021	Buccino	Campania	Salerno	SA	1974
IT	84021	Buccino Stazione	Campania	Salerno	SA	1975
IT	84022	Puglietta	Campania	Salerno	SA	1976
IT	84022	Quadrivio	Campania	Salerno	SA	1977
IT	84022	Serradarce	Campania	Salerno	SA	1978
IT	84022	Campagna	Campania	Salerno	SA	1979
IT	84023	Persano	Campania	Salerno	SA	1980
IT	84024	Bagni Di Contursi	Campania	Salerno	SA	1981
IT	84024	Contursi Terme	Campania	Salerno	SA	1982
IT	84025	Santa Cecilia Di Eboli	Campania	Salerno	SA	1983
IT	84025	Corno D'Oro	Campania	Salerno	SA	1984
IT	84025	Eboli	Campania	Salerno	SA	1985
IT	84025	Bivio Santa Cecilia	Campania	Salerno	SA	1986
IT	84026	Postiglione	Campania	Salerno	SA	1987
IT	84027	Sant'Angelo A Fasanella	Campania	Salerno	SA	1988
IT	84028	Borgo San Lazzaro	Campania	Salerno	SA	1989
IT	84028	Serre	Campania	Salerno	SA	1990
IT	84029	Galdo Degli Alburni	Campania	Salerno	SA	1991
IT	84029	Zuppino	Campania	Salerno	SA	1992
IT	84029	Scorzo	Campania	Salerno	SA	1993
IT	84029	Castelluccio Cosentino	Campania	Salerno	SA	1994
IT	84029	Sicignano Degli Alburni	Campania	Salerno	SA	1995
IT	84029	Sicignano Degli Alburni Stazione	Campania	Salerno	SA	1996
IT	84030	San Pietro Al Tanagro	Campania	Salerno	SA	1997
IT	84030	Sicili'	Campania	Salerno	SA	1998
IT	84030	Caselle In Pittari	Campania	Salerno	SA	1999
IT	84030	Pertosa	Campania	Salerno	SA	2000
IT	84030	Taverne	Campania	Salerno	SA	2001
IT	84030	Morigerati	Campania	Salerno	SA	2002
IT	84030	Battaglia	Campania	Salerno	SA	2003
IT	84030	Casaletto Spartano	Campania	Salerno	SA	2004
IT	84030	Atena Lucana Scalo	Campania	Salerno	SA	2005
IT	84030	San Rufo	Campania	Salerno	SA	2006
IT	84030	Torraca	Campania	Salerno	SA	2007
IT	84030	Sanza	Campania	Salerno	SA	2008
IT	84030	Casalbuono	Campania	Salerno	SA	2009
IT	84030	Monte San Giacomo	Campania	Salerno	SA	2010
IT	84030	Caggiano	Campania	Salerno	SA	2011
IT	84030	Tortorella	Campania	Salerno	SA	2012
IT	84030	Atena Lucana	Campania	Salerno	SA	2013
IT	84031	Auletta	Campania	Salerno	SA	2014
IT	84032	Buonabitacolo	Campania	Salerno	SA	2015
IT	84033	Prato Comune	Campania	Salerno	SA	2016
IT	84033	Montesano Scalo	Campania	Salerno	SA	2017
IT	84033	Tardiano	Campania	Salerno	SA	2018
IT	84033	Montesano Sulla Marcellana	Campania	Salerno	SA	2019
IT	84033	Arenabianca	Campania	Salerno	SA	2020
IT	84034	Padula	Campania	Salerno	SA	2021
IT	84034	Padula Scalo	Campania	Salerno	SA	2022
IT	84035	Polla	Campania	Salerno	SA	2023
IT	84036	Sala Consilina	Campania	Salerno	SA	2024
IT	84036	Trinita'	Campania	Salerno	SA	2025
IT	84037	Sant'Arsenio	Campania	Salerno	SA	2026
IT	84038	Silla	Campania	Salerno	SA	2027
IT	84038	Sassano	Campania	Salerno	SA	2028
IT	84038	Caiazzano	Campania	Salerno	SA	2029
IT	84039	Teggiano	Campania	Salerno	SA	2030
IT	84039	San Marco Di Teggiano	Campania	Salerno	SA	2031
IT	84039	Prato Perillo	Campania	Salerno	SA	2032
IT	84039	Pantano Di Teggiano	Campania	Salerno	SA	2033
IT	84040	Acquavella	Campania	Salerno	SA	2034
IT	84040	Velina	Campania	Salerno	SA	2035
IT	84040	Poderia	Campania	Salerno	SA	2036
IT	84040	Casal Velino	Campania	Salerno	SA	2037
IT	84040	Alfano	Campania	Salerno	SA	2038
IT	84040	Cannalonga	Campania	Salerno	SA	2039
IT	84040	Ponte	Campania	Salerno	SA	2040
IT	84040	Celle Di Bulgheria	Campania	Salerno	SA	2041
IT	84040	Castelnuovo Vallo Stazione	Campania	Salerno	SA	2042
IT	84040	Castelnuovo Cilento	Campania	Salerno	SA	2043
IT	84040	Casal Velino Marina	Campania	Salerno	SA	2044
IT	84040	Campora	Campania	Salerno	SA	2045
IT	84040	Marina Di Casal Velino	Campania	Salerno	SA	2046
IT	84042	Acerno	Campania	Salerno	SA	2047
IT	84043	Agropoli	Campania	Salerno	SA	2048
IT	84043	Agropoli Stazione	Campania	Salerno	SA	2049
IT	84044	Matinella	Campania	Salerno	SA	2050
IT	84044	Albanella	Campania	Salerno	SA	2051
IT	84045	Carillia	Campania	Salerno	SA	2052
IT	84045	Altavilla Silentina	Campania	Salerno	SA	2053
IT	84045	Borgo Carillia	Campania	Salerno	SA	2054
IT	84045	Cerrelli	Campania	Salerno	SA	2055
IT	84046	Catona Di Ascea	Campania	Salerno	SA	2056
IT	84046	Mandia Di Ascea	Campania	Salerno	SA	2057
IT	84046	Marina Di Ascea	Campania	Salerno	SA	2058
IT	84046	Catona	Campania	Salerno	SA	2059
IT	84046	Mandia	Campania	Salerno	SA	2060
IT	84046	Terradura	Campania	Salerno	SA	2061
IT	84046	Terradura Di Ascea	Campania	Salerno	SA	2062
IT	84046	Ascea	Campania	Salerno	SA	2063
IT	84047	Torre Di Paestum	Campania	Salerno	SA	2064
IT	84047	Rettifilo	Campania	Salerno	SA	2065
IT	84047	Capaccio	Campania	Salerno	SA	2066
IT	84047	Licinella	Campania	Salerno	SA	2067
IT	84047	Laura	Campania	Salerno	SA	2068
IT	84047	Capaccio Scalo	Campania	Salerno	SA	2069
IT	84047	Vannullo	Campania	Salerno	SA	2070
IT	84047	Gromola	Campania	Salerno	SA	2071
IT	84047	Santa Venere	Campania	Salerno	SA	2072
IT	84047	Vuccolo Di Maiorano	Campania	Salerno	SA	2073
IT	84047	Borgo Nuovo	Campania	Salerno	SA	2074
IT	84047	Ponte Barizzo	Campania	Salerno	SA	2075
IT	84047	Paestum	Campania	Salerno	SA	2076
IT	84047	Cafasso	Campania	Salerno	SA	2077
IT	84048	Castellabate	Campania	Salerno	SA	2078
IT	84048	Ogliastro Marina	Campania	Salerno	SA	2079
IT	84048	Santa Maria Di Castellabate	Campania	Salerno	SA	2080
IT	84048	San Marco	Campania	Salerno	SA	2081
IT	84048	Santa Maria	Campania	Salerno	SA	2082
IT	84049	Castel San Lorenzo	Campania	Salerno	SA	2083
IT	84050	Magliano Nuovo	Campania	Salerno	SA	2084
IT	84050	Lustra	Campania	Salerno	SA	2085
IT	84050	Cuccaro Vetere	Campania	Salerno	SA	2086
IT	84050	Capitello	Campania	Salerno	SA	2087
IT	84050	Magliano Vetere	Campania	Salerno	SA	2088
IT	84050	Laureana Cilento	Campania	Salerno	SA	2089
IT	84050	Giungano	Campania	Salerno	SA	2090
IT	84050	Laurito	Campania	Salerno	SA	2091
IT	84050	Matonti	Campania	Salerno	SA	2092
IT	84050	Futani	Campania	Salerno	SA	2093
IT	84050	Ispani	Campania	Salerno	SA	2094
IT	84050	Sorvaro	Campania	Salerno	SA	2095
IT	84050	Capizzo	Campania	Salerno	SA	2096
IT	84051	Palinuro	Campania	Salerno	SA	2097
IT	84051	San Nicola Di Centola	Campania	Salerno	SA	2098
IT	84051	Centola	Campania	Salerno	SA	2099
IT	84051	San Severino	Campania	Salerno	SA	2100
IT	84051	San Nicola	Campania	Salerno	SA	2101
IT	84051	Foria	Campania	Salerno	SA	2102
IT	84051	San Severino Di Centola	Campania	Salerno	SA	2103
IT	84052	Ceraso	Campania	Salerno	SA	2104
IT	84052	San Biase	Campania	Salerno	SA	2105
IT	84052	Massascusa	Campania	Salerno	SA	2106
IT	84052	Santa Barbara	Campania	Salerno	SA	2107
IT	84052	San Sumino	Campania	Salerno	SA	2108
IT	84053	Cicerale	Campania	Salerno	SA	2109
IT	84053	Monte Cicerale	Campania	Salerno	SA	2110
IT	84055	Felitto	Campania	Salerno	SA	2111
IT	84056	Gioi	Campania	Salerno	SA	2112
IT	84056	Cardile	Campania	Salerno	SA	2113
IT	84057	Laurino	Campania	Salerno	SA	2114
IT	84057	Villa Littorio	Campania	Salerno	SA	2115
IT	84059	Lentiscosa	Campania	Salerno	SA	2116
IT	84059	Marina Di Camerota	Campania	Salerno	SA	2117
IT	84059	Licusati	Campania	Salerno	SA	2118
IT	84059	Camerota	Campania	Salerno	SA	2119
IT	84060	Ostigliano	Campania	Salerno	SA	2120
IT	84060	Mercato Cilento	Campania	Salerno	SA	2121
IT	84060	Acquavena	Campania	Salerno	SA	2122
IT	84060	Piano Vetrale	Campania	Salerno	SA	2123
IT	84060	Montano Antilia	Campania	Salerno	SA	2124
IT	84060	Omignano Scalo	Campania	Salerno	SA	2125
IT	84060	Novi Velia	Campania	Salerno	SA	2126
IT	84060	Vatolla	Campania	Salerno	SA	2127
IT	84060	Omignano	Campania	Salerno	SA	2128
IT	84060	Moio Della Civitella	Campania	Salerno	SA	2129
IT	84060	Pellare	Campania	Salerno	SA	2130
IT	84060	Fornelli	Campania	Salerno	SA	2131
IT	84060	Roccagloriosa	Campania	Salerno	SA	2132
IT	84060	Orria	Campania	Salerno	SA	2133
IT	84060	Perdifumo	Campania	Salerno	SA	2134
IT	84060	Case Del Conte	Campania	Salerno	SA	2135
IT	84060	Montecorice	Campania	Salerno	SA	2136
IT	84060	Omignano Stazione	Campania	Salerno	SA	2137
IT	84060	Massicelle	Campania	Salerno	SA	2138
IT	84060	Ortodonico	Campania	Salerno	SA	2139
IT	84060	Monteforte Cilento	Campania	Salerno	SA	2140
IT	84060	Prignano Cilento	Campania	Salerno	SA	2141
IT	84060	Agnone Cilento	Campania	Salerno	SA	2142
IT	84060	Perito	Campania	Salerno	SA	2143
IT	84060	Abatemarco	Campania	Salerno	SA	2144
IT	84061	Eredita	Campania	Salerno	SA	2145
IT	84061	Ogliastro Cilento	Campania	Salerno	SA	2146
IT	84061	Finocchito	Campania	Salerno	SA	2147
IT	84062	Salitto	Campania	Salerno	SA	2148
IT	84062	Valle	Campania	Salerno	SA	2149
IT	84062	Olevano Sul Tusciano	Campania	Salerno	SA	2150
IT	84062	Ariano	Campania	Salerno	SA	2151
IT	84062	Monticelli	Campania	Salerno	SA	2152
IT	84065	Piaggine	Campania	Salerno	SA	2153
IT	84066	Pisciotta	Campania	Salerno	SA	2154
IT	84066	Caprioli	Campania	Salerno	SA	2155
IT	84066	Marina Di Pisciotta	Campania	Salerno	SA	2156
IT	84066	Rodio	Campania	Salerno	SA	2157
IT	84067	Policastro Bussentino	Campania	Salerno	SA	2158
IT	84067	Santa Marina	Campania	Salerno	SA	2159
IT	84068	Cannicchio	Campania	Salerno	SA	2160
IT	84068	Acciaroli	Campania	Salerno	SA	2161
IT	84068	Pollica	Campania	Salerno	SA	2162
IT	84068	Pioppi	Campania	Salerno	SA	2163
IT	84068	Galdo	Campania	Salerno	SA	2164
IT	84068	Celso	Campania	Salerno	SA	2165
IT	84068	Galdo Cilento	Campania	Salerno	SA	2166
IT	84069	Serra	Campania	Salerno	SA	2167
IT	84069	Roccadaspide	Campania	Salerno	SA	2168
IT	84069	Carratiello	Campania	Salerno	SA	2169
IT	84069	Acquaviva	Campania	Salerno	SA	2170
IT	84069	Fonte	Campania	Salerno	SA	2171
IT	84070	San Mauro Cilento	Campania	Salerno	SA	2172
IT	84070	Rutino	Campania	Salerno	SA	2173
IT	84070	San Giovanni A Piro	Campania	Salerno	SA	2174
IT	84070	Stella Cilento	Campania	Salerno	SA	2175
IT	84070	Serramezzana	Campania	Salerno	SA	2176
IT	84070	Salento	Campania	Salerno	SA	2177
IT	84070	Valle Dell'Angelo	Campania	Salerno	SA	2178
IT	84070	Scario	Campania	Salerno	SA	2179
IT	84070	Sacco	Campania	Salerno	SA	2180
IT	84070	San Mauro La Bruca	Campania	Salerno	SA	2181
IT	84070	Casalsottano	Campania	Salerno	SA	2182
IT	84070	Trentinara	Campania	Salerno	SA	2183
IT	84070	Rofrano	Campania	Salerno	SA	2184
IT	84070	Bosco	Campania	Salerno	SA	2185
IT	84073	Sapri	Campania	Salerno	SA	2186
IT	84074	Sessa Cilento	Campania	Salerno	SA	2187
IT	84074	Santa Lucia Cilento	Campania	Salerno	SA	2188
IT	84074	San Mango	Campania	Salerno	SA	2189
IT	84074	San Mango Cilento	Campania	Salerno	SA	2190
IT	84075	Stio	Campania	Salerno	SA	2191
IT	84075	Gorga	Campania	Salerno	SA	2192
IT	84076	Torchiara	Campania	Salerno	SA	2193
IT	84076	Copersito Cilento	Campania	Salerno	SA	2194
IT	84076	Copersito	Campania	Salerno	SA	2195
IT	84077	Torre Orsaia	Campania	Salerno	SA	2196
IT	84077	Castel Ruggero	Campania	Salerno	SA	2197
IT	84078	Angellara	Campania	Salerno	SA	2198
IT	84078	Pattano	Campania	Salerno	SA	2199
IT	84078	Vallo Della Lucania	Campania	Salerno	SA	2200
IT	84078	Massa Della Lucania	Campania	Salerno	SA	2201
IT	84079	Vibonati	Campania	Salerno	SA	2202
IT	84079	Villammare	Campania	Salerno	SA	2203
IT	84080	Coperchia	Campania	Salerno	SA	2204
IT	84080	Capriglia	Campania	Salerno	SA	2205
IT	84080	Pellezzano	Campania	Salerno	SA	2206
IT	84080	Capezzano Inferiore	Campania	Salerno	SA	2207
IT	84080	Cologna	Campania	Salerno	SA	2208
IT	84080	Capezzano Superiore	Campania	Salerno	SA	2209
IT	84080	Calvanico	Campania	Salerno	SA	2210
IT	84080	Capezzano	Campania	Salerno	SA	2211
IT	84081	Fusara	Campania	Salerno	SA	2212
IT	84081	Baronissi	Campania	Salerno	SA	2213
IT	84081	Caprecano	Campania	Salerno	SA	2214
IT	84081	Acquamela	Campania	Salerno	SA	2215
IT	84081	Antessano	Campania	Salerno	SA	2216
IT	84081	Sava	Campania	Salerno	SA	2217
IT	84081	Saragnano	Campania	Salerno	SA	2218
IT	84082	San Nazario	Campania	Salerno	SA	2219
IT	84082	Bracigliano	Campania	Salerno	SA	2220
IT	84082	Manzi	Campania	Salerno	SA	2221
IT	84083	Castelluccio	Campania	Salerno	SA	2222
IT	84083	Castel San Giorgio	Campania	Salerno	SA	2223
IT	84083	Lanzara	Campania	Salerno	SA	2224
IT	84083	Fimiani	Campania	Salerno	SA	2225
IT	84084	Settefichi	Campania	Salerno	SA	2226
IT	84084	Gaiano	Campania	Salerno	SA	2227
IT	84084	Bolano	Campania	Salerno	SA	2228
IT	84084	Villa	Campania	Salerno	SA	2229
IT	84084	Penta	Campania	Salerno	SA	2230
IT	84084	Fisciano	Campania	Salerno	SA	2231
IT	84084	Pizzolano	Campania	Salerno	SA	2232
IT	84084	Lancusi	Campania	Salerno	SA	2233
IT	84085	Torello	Campania	Salerno	SA	2234
IT	84085	Mercato San Severino	Campania	Salerno	SA	2235
IT	84085	Acquarola	Campania	Salerno	SA	2236
IT	84085	Spiano	Campania	Salerno	SA	2237
IT	84085	Sant'Eustachio	Campania	Salerno	SA	2238
IT	84085	Carifi	Campania	Salerno	SA	2239
IT	84085	Curteri	Campania	Salerno	SA	2240
IT	84085	Sant'Angelo	Campania	Salerno	SA	2241
IT	84085	Piazza Del Galdo	Campania	Salerno	SA	2242
IT	84085	Pandola	Campania	Salerno	SA	2243
IT	84085	Sant'Angelo Di Mercato San Severino	Campania	Salerno	SA	2244
IT	84085	Monticelli	Campania	Salerno	SA	2245
IT	84085	Ciorani	Campania	Salerno	SA	2246
IT	84086	Casali Di Roccapiemonte	Campania	Salerno	SA	2247
IT	84086	Roccapiemonte	Campania	Salerno	SA	2248
IT	84086	Casali San Potito	Campania	Salerno	SA	2249
IT	84087	Sarno	Campania	Salerno	SA	2250
IT	84087	Episcopio	Campania	Salerno	SA	2251
IT	84087	Lavorate	Campania	Salerno	SA	2252
IT	84088	Siano	Campania	Salerno	SA	2253
IT	84090	San Mango Piemonte	Campania	Salerno	SA	2254
IT	84090	Pugliano	Campania	Salerno	SA	2255
IT	84090	Castiglione Del Genovesi	Campania	Salerno	SA	2256
IT	84090	Prepezzano	Campania	Salerno	SA	2257
IT	84090	Capitignano	Campania	Salerno	SA	2258
IT	84090	Montecorvino Pugliano	Campania	Salerno	SA	2259
IT	84090	Giffoni Sei Casali	Campania	Salerno	SA	2260
IT	84090	Castelpagano	Campania	Salerno	SA	2261
IT	84090	Sieti	Campania	Salerno	SA	2262
IT	84090	Santa Tecla	Campania	Salerno	SA	2263
IT	84091	Sant'Anna	Campania	Salerno	SA	2264
IT	84091	Battipaglia	Campania	Salerno	SA	2265
IT	84091	Belvedere Di Battipaglia	Campania	Salerno	SA	2266
IT	84091	Santa Lucia Di Battipaglia	Campania	Salerno	SA	2267
IT	84092	Bellizzi	Campania	Salerno	SA	2268
IT	84092	Bivio	Campania	Salerno	SA	2269
IT	84095	Ornito	Campania	Salerno	SA	2270
IT	84095	Giffoni Valle Piana	Campania	Salerno	SA	2271
IT	84095	Mercato	Campania	Salerno	SA	2272
IT	84095	Santa Caterina	Campania	Salerno	SA	2273
IT	84095	San Giovanni	Campania	Salerno	SA	2274
IT	84095	Curti	Campania	Salerno	SA	2275
IT	84096	Montecorvino Rovella	Campania	Salerno	SA	2276
IT	84096	Macchia	Campania	Salerno	SA	2277
IT	84096	Gauro	Campania	Salerno	SA	2278
IT	84096	Lenzi	Campania	Salerno	SA	2279
IT	84096	San Martino Montecorvino Rovella	Campania	Salerno	SA	2280
IT	84098	Pontecagnano	Campania	Salerno	SA	2281
IT	84098	Sant'Antonio Di Pontecagnano	Campania	Salerno	SA	2282
IT	84098	Faiano	Campania	Salerno	SA	2283
IT	84098	Magazzeno	Campania	Salerno	SA	2284
IT	84098	Corvinia	Campania	Salerno	SA	2285
IT	84098	Sant'Antonio	Campania	Salerno	SA	2286
IT	84098	Pontecagnano Faiano	Campania	Salerno	SA	2287
IT	84099	San Cipriano Picentino	Campania	Salerno	SA	2288
IT	84099	Campigliano	Campania	Salerno	SA	2289
IT	84099	Pezzano	Campania	Salerno	SA	2290
IT	84099	Vignale	Campania	Salerno	SA	2291
IT	84099	Filetta	Campania	Salerno	SA	2292
IT	84100	Salerno	Campania	Salerno	SA	2293
IT	84121	Salerno	Campania	Salerno	SA	2294
IT	84122	Salerno	Campania	Salerno	SA	2295
IT	84123	Salerno	Campania	Salerno	SA	2296
IT	84124	Salerno	Campania	Salerno	SA	2297
IT	84125	Salerno	Campania	Salerno	SA	2298
IT	84126	Salerno	Campania	Salerno	SA	2299
IT	84127	Torrione Di Salerno	Campania	Salerno	SA	2300
IT	84127	Salerno	Campania	Salerno	SA	2301
IT	84128	Pastena Di Salerno	Campania	Salerno	SA	2302
IT	84128	Salerno	Campania	Salerno	SA	2303
IT	84129	Salerno	Campania	Salerno	SA	2304
IT	84131	Mercatello Di Salerno	Campania	Salerno	SA	2305
IT	84131	Fuorni	Campania	Salerno	SA	2306
IT	84131	Salerno	Campania	Salerno	SA	2307
IT	84131	San Leonardo	Campania	Salerno	SA	2308
IT	84132	Salerno	Campania	Salerno	SA	2309
IT	84133	Salerno	Campania	Salerno	SA	2310
IT	84134	Giovi	Campania	Salerno	SA	2311
IT	84134	Salerno	Campania	Salerno	SA	2312
IT	84135	Fratte	Campania	Salerno	SA	2313
IT	84135	Salerno	Campania	Salerno	SA	2314
IT	84135	Matierno	Campania	Salerno	SA	2315
IT	84135	Ogliara	Campania	Salerno	SA	2316
IT	40010	Santa Maria In Duno	Emilia-Romagna	Bologna	BO	2317
IT	40010	Interporto Bentivoglio	Emilia-Romagna	Bologna	BO	2318
IT	40010	Sala Bolognese	Emilia-Romagna	Bologna	BO	2319
IT	40010	Padulle	Emilia-Romagna	Bologna	BO	2320
IT	40010	Bentivoglio	Emilia-Romagna	Bologna	BO	2321
IT	40010	San Marino	Emilia-Romagna	Bologna	BO	2322
IT	40010	Osteria Nuova	Emilia-Romagna	Bologna	BO	2323
IT	40011	Anzola Dell'Emilia	Emilia-Romagna	Bologna	BO	2324
IT	40011	Santa Maria In Strada	Emilia-Romagna	Bologna	BO	2325
IT	40011	Lavino Di Mezzo	Emilia-Romagna	Bologna	BO	2326
IT	40011	San Giacomo Del Martignone	Emilia-Romagna	Bologna	BO	2327
IT	40012	Tavernelle Emilia	Emilia-Romagna	Bologna	BO	2328
IT	40012	Bargellino	Emilia-Romagna	Bologna	BO	2329
IT	40012	Calderara Di Reno	Emilia-Romagna	Bologna	BO	2330
IT	40012	Tavernelle D'Emilia	Emilia-Romagna	Bologna	BO	2331
IT	40012	Lippo	Emilia-Romagna	Bologna	BO	2332
IT	40012	Longara	Emilia-Romagna	Bologna	BO	2333
IT	40013	Castel Maggiore	Emilia-Romagna	Bologna	BO	2334
IT	40013	Villa Salina	Emilia-Romagna	Bologna	BO	2335
IT	40013	Trebbo	Emilia-Romagna	Bologna	BO	2336
IT	40013	Trebbo Di Reno	Emilia-Romagna	Bologna	BO	2337
IT	40013	Progresso	Emilia-Romagna	Bologna	BO	2338
IT	40014	Palata Pepoli	Emilia-Romagna	Bologna	BO	2339
IT	40014	Crevalcore	Emilia-Romagna	Bologna	BO	2340
IT	40014	Caselle	Emilia-Romagna	Bologna	BO	2341
IT	40015	San Venanzio	Emilia-Romagna	Bologna	BO	2342
IT	40015	Galliera	Emilia-Romagna	Bologna	BO	2343
IT	40015	Bosco	Emilia-Romagna	Bologna	BO	2344
IT	40015	Galliera Frazione	Emilia-Romagna	Bologna	BO	2345
IT	40015	Bosco Di Galliera	Emilia-Romagna	Bologna	BO	2346
IT	40015	San Vincenzo	Emilia-Romagna	Bologna	BO	2347
IT	40016	San Giorgio Di Piano	Emilia-Romagna	Bologna	BO	2348
IT	40017	Decima	Emilia-Romagna	Bologna	BO	2349
IT	40017	Budrie	Emilia-Romagna	Bologna	BO	2350
IT	40017	Amola Di Piano	Emilia-Romagna	Bologna	BO	2351
IT	40017	San Giovanni In Persiceto	Emilia-Romagna	Bologna	BO	2352
IT	40017	San Matteo Della Decima	Emilia-Romagna	Bologna	BO	2353
IT	40018	San Pietro In Casale	Emilia-Romagna	Bologna	BO	2354
IT	40018	Maccaretolo	Emilia-Romagna	Bologna	BO	2355
IT	40019	Sant'Agata Bolognese	Emilia-Romagna	Bologna	BO	2356
IT	40020	Casalfiumanese	Emilia-Romagna	Bologna	BO	2357
IT	40021	Borgo Tossignano	Emilia-Romagna	Bologna	BO	2358
IT	40021	Tossignano	Emilia-Romagna	Bologna	BO	2359
IT	40022	Moraduccio Di Valsalva	Emilia-Romagna	Bologna	BO	2360
IT	40022	Castel Del Rio	Emilia-Romagna	Bologna	BO	2361
IT	40022	Moraduccio	Emilia-Romagna	Bologna	BO	2362
IT	40022	Sassoleone	Emilia-Romagna	Bologna	BO	2363
IT	40022	Giugnola	Emilia-Romagna	Bologna	BO	2364
IT	40023	Castel Guelfo Di Bologna	Emilia-Romagna	Bologna	BO	2365
IT	40024	Osteria Grande	Emilia-Romagna	Bologna	BO	2366
IT	40024	Castel San Pietro Terme	Emilia-Romagna	Bologna	BO	2367
IT	40024	San Martino In Pedriolo	Emilia-Romagna	Bologna	BO	2368
IT	40024	Gaiana	Emilia-Romagna	Bologna	BO	2369
IT	40024	Gallo	Emilia-Romagna	Bologna	BO	2370
IT	40025	Fontanelice	Emilia-Romagna	Bologna	BO	2371
IT	40025	Carseggio	Emilia-Romagna	Bologna	BO	2372
IT	40026	Sesto Imolese	Emilia-Romagna	Bologna	BO	2373
IT	40026	Spazzate Sassatelli	Emilia-Romagna	Bologna	BO	2374
IT	40026	Imola	Emilia-Romagna	Bologna	BO	2375
IT	40026	Piratello	Emilia-Romagna	Bologna	BO	2376
IT	40026	San Prospero	Emilia-Romagna	Bologna	BO	2377
IT	40026	Sasso Morelli	Emilia-Romagna	Bologna	BO	2378
IT	40026	Ponticelli	Emilia-Romagna	Bologna	BO	2379
IT	40027	Bubano	Emilia-Romagna	Bologna	BO	2380
IT	40027	Mordano	Emilia-Romagna	Bologna	BO	2381
IT	40030	Pioppe Di Salvaro	Emilia-Romagna	Bologna	BO	2382
IT	40030	Berzantina	Emilia-Romagna	Bologna	BO	2383
IT	40030	Piandisetta	Emilia-Romagna	Bologna	BO	2384
IT	40030	Grizzana Morandi	Emilia-Romagna	Bologna	BO	2385
IT	40030	Badi	Emilia-Romagna	Bologna	BO	2386
IT	40030	Pian Di Casale	Emilia-Romagna	Bologna	BO	2387
IT	40030	Castel Di Casio	Emilia-Romagna	Bologna	BO	2388
IT	40030	Piano Di Setta	Emilia-Romagna	Bologna	BO	2389
IT	40030	Suviana	Emilia-Romagna	Bologna	BO	2390
IT	40032	Ponte Di Verzuno	Emilia-Romagna	Bologna	BO	2391
IT	40032	Camugnano	Emilia-Romagna	Bologna	BO	2392
IT	40032	Bargi	Emilia-Romagna	Bologna	BO	2393
IT	40033	Casalecchio Di Reno	Emilia-Romagna	Bologna	BO	2394
IT	40033	Cantagallo	Emilia-Romagna	Bologna	BO	2395
IT	40033	Ceretolo	Emilia-Romagna	Bologna	BO	2396
IT	40034	Castel D'Aiano	Emilia-Romagna	Bologna	BO	2397
IT	40034	Villa D'Aiano	Emilia-Romagna	Bologna	BO	2398
IT	40034	Rocca Di Roffeno	Emilia-Romagna	Bologna	BO	2399
IT	40034	Santa Maria Di Labante	Emilia-Romagna	Bologna	BO	2400
IT	40035	Creda	Emilia-Romagna	Bologna	BO	2401
IT	40035	Castiglione Dei Pepoli	Emilia-Romagna	Bologna	BO	2402
IT	40035	Baragazza	Emilia-Romagna	Bologna	BO	2403
IT	40035	Lagaro	Emilia-Romagna	Bologna	BO	2404
IT	40036	Rioveggio	Emilia-Romagna	Bologna	BO	2405
IT	40036	Vado	Emilia-Romagna	Bologna	BO	2406
IT	40036	Monzuno	Emilia-Romagna	Bologna	BO	2407
IT	40037	Fontana	Emilia-Romagna	Bologna	BO	2408
IT	40037	Borgonuovo	Emilia-Romagna	Bologna	BO	2409
IT	40037	Sasso Marconi	Emilia-Romagna	Bologna	BO	2410
IT	40037	Pontecchio Marconi	Emilia-Romagna	Bologna	BO	2411
IT	40038	Riola	Emilia-Romagna	Bologna	BO	2412
IT	40038	Vergato	Emilia-Romagna	Bologna	BO	2413
IT	40038	Tole'	Emilia-Romagna	Bologna	BO	2414
IT	40038	Cereglio	Emilia-Romagna	Bologna	BO	2415
IT	40038	Susano	Emilia-Romagna	Bologna	BO	2416
IT	40041	Marano	Emilia-Romagna	Bologna	BO	2417
IT	40041	Silla	Emilia-Romagna	Bologna	BO	2418
IT	40041	Santa Maria Villiana	Emilia-Romagna	Bologna	BO	2419
IT	40041	Gaggio Montano	Emilia-Romagna	Bologna	BO	2420
IT	40041	Bombiana	Emilia-Romagna	Bologna	BO	2421
IT	40042	Querciola	Emilia-Romagna	Bologna	BO	2422
IT	40042	Lizzano In Belvedere	Emilia-Romagna	Bologna	BO	2423
IT	40042	Monteacuto Delle Alpi	Emilia-Romagna	Bologna	BO	2424
IT	40042	Farneto Di Lizzano	Emilia-Romagna	Bologna	BO	2425
IT	40042	Vidiciatico	Emilia-Romagna	Bologna	BO	2426
IT	40042	Pianaccio	Emilia-Romagna	Bologna	BO	2427
IT	40042	Rocca Corneta	Emilia-Romagna	Bologna	BO	2428
IT	40043	Pian Di Venola	Emilia-Romagna	Bologna	BO	2429
IT	40043	Lama Di Setta	Emilia-Romagna	Bologna	BO	2430
IT	40043	Marzabotto	Emilia-Romagna	Bologna	BO	2431
IT	40043	Lama Di Reno	Emilia-Romagna	Bologna	BO	2432
IT	40046	Borgo Capanne	Emilia-Romagna	Bologna	BO	2433
IT	40046	Capugnano	Emilia-Romagna	Bologna	BO	2434
IT	40046	Granaglione	Emilia-Romagna	Bologna	BO	2435
IT	40046	Molino Del Pallone	Emilia-Romagna	Bologna	BO	2436
IT	40046	Porretta Terme	Emilia-Romagna	Bologna	BO	2437
IT	40046	Vizzero	Emilia-Romagna	Bologna	BO	2438
IT	40046	Casa Calistri	Emilia-Romagna	Bologna	BO	2439
IT	40046	Ponte Della Venturina	Emilia-Romagna	Bologna	BO	2440
IT	40046	Castelluccio	Emilia-Romagna	Bologna	BO	2441
IT	40046	Casa Forlai	Emilia-Romagna	Bologna	BO	2442
IT	40048	San Benedetto Val Di Sambro	Emilia-Romagna	Bologna	BO	2443
IT	40048	Castel Dell'Alpi	Emilia-Romagna	Bologna	BO	2444
IT	40048	Madonna Dei Fornelli	Emilia-Romagna	Bologna	BO	2445
IT	40048	Piano Del Voglio	Emilia-Romagna	Bologna	BO	2446
IT	40050	Castelletto	Emilia-Romagna	Bologna	BO	2447
IT	40050	San Martino	Emilia-Romagna	Bologna	BO	2448
IT	40050	Monterenzio	Emilia-Romagna	Bologna	BO	2449
IT	40050	Venezzano	Emilia-Romagna	Bologna	BO	2450
IT	40050	Loiano	Emilia-Romagna	Bologna	BO	2451
IT	40050	Monteveglio	Emilia-Romagna	Bologna	BO	2452
IT	40050	Calderino	Emilia-Romagna	Bologna	BO	2453
IT	40050	Savazza	Emilia-Romagna	Bologna	BO	2454
IT	40050	Argelato	Emilia-Romagna	Bologna	BO	2455
IT	40050	Monte San Giovanni	Emilia-Romagna	Bologna	BO	2456
IT	40050	Casadio	Emilia-Romagna	Bologna	BO	2457
IT	40050	Monte San Pietro	Emilia-Romagna	Bologna	BO	2458
IT	40050	Castello D'Argile	Emilia-Romagna	Bologna	BO	2459
IT	40050	Pizzano	Emilia-Romagna	Bologna	BO	2460
IT	40050	Castello Di Serravalle	Emilia-Romagna	Bologna	BO	2461
IT	40050	Gavignano	Emilia-Romagna	Bologna	BO	2462
IT	40050	San Benedetto Del Querceto	Emilia-Romagna	Bologna	BO	2463
IT	40050	Rignano Bolognese	Emilia-Romagna	Bologna	BO	2464
IT	40050	Funo	Emilia-Romagna	Bologna	BO	2465
IT	40050	Bisano	Emilia-Romagna	Bologna	BO	2466
IT	40050	Centergross	Emilia-Romagna	Bologna	BO	2467
IT	40051	Altedo	Emilia-Romagna	Bologna	BO	2468
IT	40051	Malalbergo	Emilia-Romagna	Bologna	BO	2469
IT	40051	Pegola	Emilia-Romagna	Bologna	BO	2470
IT	40051	Casoni	Emilia-Romagna	Bologna	BO	2471
IT	40052	Baricella	Emilia-Romagna	Bologna	BO	2472
IT	40052	Boschi	Emilia-Romagna	Bologna	BO	2473
IT	40052	Mondonuovo	Emilia-Romagna	Bologna	BO	2474
IT	40052	San Gabriele	Emilia-Romagna	Bologna	BO	2475
IT	40053	Valsamoggia	Emilia-Romagna	Bologna	BO	2476
IT	40053	Bazzano	Emilia-Romagna	Bologna	BO	2477
IT	40054	Mezzolara	Emilia-Romagna	Bologna	BO	2478
IT	40054	Riccardina	Emilia-Romagna	Bologna	BO	2479
IT	40054	Bagnarola	Emilia-Romagna	Bologna	BO	2480
IT	40054	Vedrana	Emilia-Romagna	Bologna	BO	2481
IT	40054	Budrio	Emilia-Romagna	Bologna	BO	2482
IT	40055	Villanova	Emilia-Romagna	Bologna	BO	2483
IT	40055	Castenaso	Emilia-Romagna	Bologna	BO	2484
IT	40055	Fiesso	Emilia-Romagna	Bologna	BO	2485
IT	40056	Pragatto	Emilia-Romagna	Bologna	BO	2486
IT	40056	Crespellano	Emilia-Romagna	Bologna	BO	2487
IT	40056	Calcara	Emilia-Romagna	Bologna	BO	2488
IT	40056	Muffa	Emilia-Romagna	Bologna	BO	2489
IT	40057	Quarto Inferiore	Emilia-Romagna	Bologna	BO	2490
IT	40057	Lovoleto	Emilia-Romagna	Bologna	BO	2491
IT	40057	Granarolo Dell'Emilia	Emilia-Romagna	Bologna	BO	2492
IT	40057	Fabbreria Di Cadriana	Emilia-Romagna	Bologna	BO	2493
IT	40059	Portonovo	Emilia-Romagna	Bologna	BO	2494
IT	40059	Villa Fontana	Emilia-Romagna	Bologna	BO	2495
IT	40059	Sant'Antonio	Emilia-Romagna	Bologna	BO	2496
IT	40059	Medicina	Emilia-Romagna	Bologna	BO	2497
IT	40059	Ganzanigo	Emilia-Romagna	Bologna	BO	2498
IT	40059	Buda	Emilia-Romagna	Bologna	BO	2499
IT	40060	Savigno	Emilia-Romagna	Bologna	BO	2500
IT	40060	Dozza	Emilia-Romagna	Bologna	BO	2501
IT	40060	Toscanella	Emilia-Romagna	Bologna	BO	2502
IT	40060	Gallo Bolognese	Emilia-Romagna	Bologna	BO	2503
IT	40060	Vedegheto	Emilia-Romagna	Bologna	BO	2504
IT	40061	Ca' De' Fabbri	Emilia-Romagna	Bologna	BO	2505
IT	40061	Minerbio	Emilia-Romagna	Bologna	BO	2506
IT	40062	San Martino In Argine	Emilia-Romagna	Bologna	BO	2507
IT	40062	Molinella	Emilia-Romagna	Bologna	BO	2508
IT	40062	San Pietro Capofiume	Emilia-Romagna	Bologna	BO	2509
IT	40062	Selva Malvezzi	Emilia-Romagna	Bologna	BO	2510
IT	40062	Marmorta	Emilia-Romagna	Bologna	BO	2511
IT	40062	Selva	Emilia-Romagna	Bologna	BO	2512
IT	40063	Monghidoro	Emilia-Romagna	Bologna	BO	2513
IT	40064	Mercatale	Emilia-Romagna	Bologna	BO	2514
IT	40064	Ozzano Dell'Emilia	Emilia-Romagna	Bologna	BO	2515
IT	40065	Pianoro	Emilia-Romagna	Bologna	BO	2516
IT	40065	Livergnano	Emilia-Romagna	Bologna	BO	2517
IT	40065	Pianoro Vecchio	Emilia-Romagna	Bologna	BO	2518
IT	40066	Pieve Di Cento	Emilia-Romagna	Bologna	BO	2519
IT	40067	Rastignano	Emilia-Romagna	Bologna	BO	2520
IT	40068	Martiri Di Pizzocalvo	Emilia-Romagna	Bologna	BO	2521
IT	40068	Farneto	Emilia-Romagna	Bologna	BO	2522
IT	40068	Castel Dei Britti	Emilia-Romagna	Bologna	BO	2523
IT	40068	Ponticella	Emilia-Romagna	Bologna	BO	2524
IT	40068	San Lazzaro	Emilia-Romagna	Bologna	BO	2525
IT	40068	Pulce	Emilia-Romagna	Bologna	BO	2526
IT	40068	San Lazzaro Di Savena	Emilia-Romagna	Bologna	BO	2527
IT	40069	Zola Predosa	Emilia-Romagna	Bologna	BO	2528
IT	40069	Ponte Ronca	Emilia-Romagna	Bologna	BO	2529
IT	40069	Riale	Emilia-Romagna	Bologna	BO	2530
IT	40069	Zola	Emilia-Romagna	Bologna	BO	2531
IT	40100	Bologna	Emilia-Romagna	Bologna	BO	2532
IT	40121	Bologna	Emilia-Romagna	Bologna	BO	2533
IT	40122	Bologna	Emilia-Romagna	Bologna	BO	2534
IT	40123	Bologna	Emilia-Romagna	Bologna	BO	2535
IT	40124	Bologna	Emilia-Romagna	Bologna	BO	2536
IT	40125	Bologna	Emilia-Romagna	Bologna	BO	2537
IT	40126	Bologna	Emilia-Romagna	Bologna	BO	2538
IT	40127	San Donnino	Emilia-Romagna	Bologna	BO	2539
IT	40127	Bologna	Emilia-Romagna	Bologna	BO	2540
IT	40128	Corticella	Emilia-Romagna	Bologna	BO	2541
IT	40128	Bologna	Emilia-Romagna	Bologna	BO	2542
IT	40129	Bologna	Emilia-Romagna	Bologna	BO	2543
IT	40131	Bertalia	Emilia-Romagna	Bologna	BO	2544
IT	40131	Bologna	Emilia-Romagna	Bologna	BO	2545
IT	40132	Borgo Panigale	Emilia-Romagna	Bologna	BO	2546
IT	40132	Bologna	Emilia-Romagna	Bologna	BO	2547
IT	40133	Bologna	Emilia-Romagna	Bologna	BO	2548
IT	40134	Bologna	Emilia-Romagna	Bologna	BO	2549
IT	40135	Casaglia	Emilia-Romagna	Bologna	BO	2550
IT	40135	Bologna	Emilia-Romagna	Bologna	BO	2551
IT	40136	Paderno	Emilia-Romagna	Bologna	BO	2552
IT	40136	Bologna	Emilia-Romagna	Bologna	BO	2553
IT	40136	Roncrio	Emilia-Romagna	Bologna	BO	2554
IT	40136	Gaibola	Emilia-Romagna	Bologna	BO	2555
IT	40137	Bologna	Emilia-Romagna	Bologna	BO	2556
IT	40138	Roveri	Emilia-Romagna	Bologna	BO	2557
IT	40138	Bologna	Emilia-Romagna	Bologna	BO	2558
IT	40139	Bologna	Emilia-Romagna	Bologna	BO	2559
IT	40141	San Ruffillo	Emilia-Romagna	Bologna	BO	2560
IT	40141	Monte Donato	Emilia-Romagna	Bologna	BO	2561
IT	40141	Bologna	Emilia-Romagna	Bologna	BO	2562
IT	47010	Premilcuore	Emilia-Romagna	Forli	FC	2563
IT	47010	Strada San Zeno	Emilia-Romagna	Forli	FC	2564
IT	47010	Galeata	Emilia-Romagna	Forli	FC	2565
IT	47010	Bocconi	Emilia-Romagna	Forli	FC	2566
IT	47010	San Benedetto In Alpe	Emilia-Romagna	Forli	FC	2567
IT	47010	Portico E San Benedetto	Emilia-Romagna	Forli	FC	2568
IT	47010	Portico Di Romagna	Emilia-Romagna	Forli	FC	2569
IT	47011	Castrocaro Terme E Terra Del Sole	Emilia-Romagna	Forli	FC	2570
IT	47011	Pieve Salutare	Emilia-Romagna	Forli	FC	2571
IT	47011	Terra Del Sole	Emilia-Romagna	Forli	FC	2572
IT	47012	Voltre	Emilia-Romagna	Forli	FC	2573
IT	47012	Cusercoli	Emilia-Romagna	Forli	FC	2574
IT	47012	Civitella Di Romagna	Emilia-Romagna	Forli	FC	2575
IT	47012	Nespoli	Emilia-Romagna	Forli	FC	2576
IT	47013	Dovadola	Emilia-Romagna	Forli	FC	2577
IT	47013	San Ruffillo	Emilia-Romagna	Forli	FC	2578
IT	47014	Rico'	Emilia-Romagna	Forli	FC	2579
IT	47014	Vitignano	Emilia-Romagna	Forli	FC	2580
IT	47014	San Colombano	Emilia-Romagna	Forli	FC	2581
IT	47014	Meldola	Emilia-Romagna	Forli	FC	2582
IT	47014	Teodorano	Emilia-Romagna	Forli	FC	2583
IT	47014	Para	Emilia-Romagna	Forli	FC	2584
IT	47014	San Colombano Di Meldola	Emilia-Romagna	Forli	FC	2585
IT	47015	Modigliana	Emilia-Romagna	Forli	FC	2586
IT	47015	Santa Reparata	Emilia-Romagna	Forli	FC	2587
IT	47016	Predappio	Emilia-Romagna	Forli	FC	2588
IT	47016	Fiumana	Emilia-Romagna	Forli	FC	2589
IT	47016	Tontola	Emilia-Romagna	Forli	FC	2590
IT	47016	Rocca Delle Caminate	Emilia-Romagna	Forli	FC	2591
IT	47016	Predappio Alta	Emilia-Romagna	Forli	FC	2592
IT	47017	Calbola	Emilia-Romagna	Forli	FC	2593
IT	47017	Rocca San Casciano	Emilia-Romagna	Forli	FC	2594
IT	47018	Santa Sofia	Emilia-Romagna	Forli	FC	2595
IT	47018	Corniolo	Emilia-Romagna	Forli	FC	2596
IT	47018	Biserno	Emilia-Romagna	Forli	FC	2597
IT	47019	Tredozio	Emilia-Romagna	Forli	FC	2598
IT	47020	Budrio	Emilia-Romagna	Forli	FC	2599
IT	47020	Longiano	Emilia-Romagna	Forli	FC	2600
IT	47020	Roncofreddo	Emilia-Romagna	Forli	FC	2601
IT	47020	Montiano	Emilia-Romagna	Forli	FC	2602
IT	47020	Oriola	Emilia-Romagna	Forli	FC	2603
IT	47021	Bagno Di Romagna	Emilia-Romagna	Forli	FC	2604
IT	47021	Selvapiana	Emilia-Romagna	Forli	FC	2605
IT	47021	San Piero In Bagno	Emilia-Romagna	Forli	FC	2606
IT	47021	Vessa	Emilia-Romagna	Forli	FC	2607
IT	47021	Monte Guidi	Emilia-Romagna	Forli	FC	2608
IT	47023	Bulgaria	Emilia-Romagna	Forli	FC	2609
IT	47023	Madonna Dell Ulivo	Emilia-Romagna	Forli	FC	2610
IT	47023	Diegaro	Emilia-Romagna	Forli	FC	2611
IT	47023	Martorano	Emilia-Romagna	Forli	FC	2612
IT	47023	San Vittore	Emilia-Romagna	Forli	FC	2613
IT	47023	Rio Marano	Emilia-Romagna	Forli	FC	2614
IT	47023	Macerone	Emilia-Romagna	Forli	FC	2615
IT	47023	Saiano	Emilia-Romagna	Forli	FC	2616
IT	47023	Roversano	Emilia-Romagna	Forli	FC	2617
IT	47023	Sant'Egidio	Emilia-Romagna	Forli	FC	2618
IT	47023	Ronta	Emilia-Romagna	Forli	FC	2619
IT	47023	San Mauro In Valle	Emilia-Romagna	Forli	FC	2620
IT	47023	Lizzano	Emilia-Romagna	Forli	FC	2621
IT	47023	Torre Del Moro	Emilia-Romagna	Forli	FC	2622
IT	47023	Cesuola	Emilia-Romagna	Forli	FC	2623
IT	47023	Case Scuola Vecchia	Emilia-Romagna	Forli	FC	2624
IT	47023	Settecrociari	Emilia-Romagna	Forli	FC	2625
IT	47023	Cesena	Emilia-Romagna	Forli	FC	2626
IT	47023	San Giorgio Di Cesena	Emilia-Romagna	Forli	FC	2627
IT	47023	Borello	Emilia-Romagna	Forli	FC	2628
IT	47023	Pievesestina	Emilia-Romagna	Forli	FC	2629
IT	47023	Aie	Emilia-Romagna	Forli	FC	2630
IT	47023	Gattolino	Emilia-Romagna	Forli	FC	2631
IT	47023	Celletta	Emilia-Romagna	Forli	FC	2632
IT	47023	Calisese	Emilia-Romagna	Forli	FC	2633
IT	47023	San Carlo Di Cesena	Emilia-Romagna	Forli	FC	2634
IT	47023	Tessello	Emilia-Romagna	Forli	FC	2635
IT	47025	Linaro	Emilia-Romagna	Forli	FC	2636
IT	47025	Mercato Saraceno	Emilia-Romagna	Forli	FC	2637
IT	47025	Bacciolino	Emilia-Romagna	Forli	FC	2638
IT	47025	Tornano	Emilia-Romagna	Forli	FC	2639
IT	47025	Piavola	Emilia-Romagna	Forli	FC	2640
IT	47025	Ciola	Emilia-Romagna	Forli	FC	2641
IT	47025	Bora Bassa	Emilia-Romagna	Forli	FC	2642
IT	47025	Cella	Emilia-Romagna	Forli	FC	2643
IT	47025	Monte Castello	Emilia-Romagna	Forli	FC	2644
IT	47027	Pieve Di Rivoschio	Emilia-Romagna	Forli	FC	2645
IT	47027	Quarto	Emilia-Romagna	Forli	FC	2646
IT	47027	Sarsina	Emilia-Romagna	Forli	FC	2647
IT	47027	Sorbano	Emilia-Romagna	Forli	FC	2648
IT	47027	Ranchio	Emilia-Romagna	Forli	FC	2649
IT	47027	Quarto Di Sarsina	Emilia-Romagna	Forli	FC	2650
IT	47028	Balze	Emilia-Romagna	Forli	FC	2651
IT	47028	Alfero	Emilia-Romagna	Forli	FC	2652
IT	47028	Verghereto	Emilia-Romagna	Forli	FC	2653
IT	47030	Sogliano Al Rubicone	Emilia-Romagna	Forli	FC	2654
IT	47030	San Mauro A Mare	Emilia-Romagna	Forli	FC	2655
IT	47030	Savignano Di Rigo	Emilia-Romagna	Forli	FC	2656
IT	47030	San Giovanni In Galilea	Emilia-Romagna	Forli	FC	2657
IT	47030	San Mauro Pascoli	Emilia-Romagna	Forli	FC	2658
IT	47030	San Martino In Converseto	Emilia-Romagna	Forli	FC	2659
IT	47030	Montegelli	Emilia-Romagna	Forli	FC	2660
IT	47030	Lo Stradone	Emilia-Romagna	Forli	FC	2661
IT	47030	Rontagnano	Emilia-Romagna	Forli	FC	2662
IT	47030	Montepetra	Emilia-Romagna	Forli	FC	2663
IT	47030	Borghi	Emilia-Romagna	Forli	FC	2664
IT	47032	Fratta Terme	Emilia-Romagna	Forli	FC	2665
IT	47032	Capocolle	Emilia-Romagna	Forli	FC	2666
IT	47032	Bertinoro	Emilia-Romagna	Forli	FC	2667
IT	47032	Polenta	Emilia-Romagna	Forli	FC	2668
IT	47032	Santa Maria Nuova	Emilia-Romagna	Forli	FC	2669
IT	47032	Collinello	Emilia-Romagna	Forli	FC	2670
IT	47032	Collinello Polenta	Emilia-Romagna	Forli	FC	2671
IT	47032	Panighina	Emilia-Romagna	Forli	FC	2672
IT	47034	Forlimpopoli	Emilia-Romagna	Forli	FC	2673
IT	47034	Selbagnone	Emilia-Romagna	Forli	FC	2674
IT	47035	Gambettola	Emilia-Romagna	Forli	FC	2675
IT	47039	Fiumicino Di Savignano	Emilia-Romagna	Forli	FC	2676
IT	47039	Savignano Sul Rubicone	Emilia-Romagna	Forli	FC	2677
IT	47042	Cesenatico	Emilia-Romagna	Forli	FC	2678
IT	47042	Sala	Emilia-Romagna	Forli	FC	2679
IT	47042	Villalta	Emilia-Romagna	Forli	FC	2680
IT	47042	Bagnarola	Emilia-Romagna	Forli	FC	2681
IT	47043	Gatteo	Emilia-Romagna	Forli	FC	2682
IT	47043	Sant'Angelo In Salute	Emilia-Romagna	Forli	FC	2683
IT	47043	Gatteo A Mare	Emilia-Romagna	Forli	FC	2684
IT	47100	Barisano	Emilia-Romagna	Forli	FC	2685
IT	47100	Villanova	Emilia-Romagna	Forli	FC	2686
IT	47100	Roncadello	Emilia-Romagna	Forli	FC	2687
IT	47100	San Martino In Strada	Emilia-Romagna	Forli	FC	2688
IT	47100	Carpinello	Emilia-Romagna	Forli	FC	2689
IT	47100	Villafranca	Emilia-Romagna	Forli	FC	2690
IT	47100	Pianta	Emilia-Romagna	Forli	FC	2691
IT	47100	Ronco	Emilia-Romagna	Forli	FC	2692
IT	47100	Rovere	Emilia-Romagna	Forli	FC	2693
IT	47100	San Varano	Emilia-Romagna	Forli	FC	2694
IT	47100	Carpena	Emilia-Romagna	Forli	FC	2695
IT	47100	Cava	Emilia-Romagna	Forli	FC	2696
IT	47100	San Lorenzo In Noceto	Emilia-Romagna	Forli	FC	2697
IT	47100	Villa Rovere	Emilia-Romagna	Forli	FC	2698
IT	47100	Vecchiazzano	Emilia-Romagna	Forli	FC	2699
IT	47121	Forlì	Emilia-Romagna	Forli	FC	2700
IT	47122	Forlì	Emilia-Romagna	Forli	FC	2701
IT	44011	Anita	Emilia-Romagna	Ferrara	FE	2702
IT	44011	Longastrino	Emilia-Romagna	Ferrara	FE	2703
IT	44011	San Biagio	Emilia-Romagna	Ferrara	FE	2704
IT	44011	Campotto	Emilia-Romagna	Ferrara	FE	2705
IT	44011	Traghetto	Emilia-Romagna	Ferrara	FE	2706
IT	44011	Santa Maria Codifiume	Emilia-Romagna	Ferrara	FE	2707
IT	44011	Filo	Emilia-Romagna	Ferrara	FE	2708
IT	44011	San Nicolo'	Emilia-Romagna	Ferrara	FE	2709
IT	44011	La Fiorana	Emilia-Romagna	Ferrara	FE	2710
IT	44011	Bando	Emilia-Romagna	Ferrara	FE	2711
IT	44011	Consandolo	Emilia-Romagna	Ferrara	FE	2712
IT	44011	Ospital Monacale	Emilia-Romagna	Ferrara	FE	2713
IT	44011	Boccaleone	Emilia-Romagna	Ferrara	FE	2714
IT	44011	Argenta	Emilia-Romagna	Ferrara	FE	2715
IT	44012	Stellata	Emilia-Romagna	Ferrara	FE	2716
IT	44012	Ospitale	Emilia-Romagna	Ferrara	FE	2717
IT	44012	Gavello	Emilia-Romagna	Ferrara	FE	2718
IT	44012	Pilastri	Emilia-Romagna	Ferrara	FE	2719
IT	44012	Bondeno	Emilia-Romagna	Ferrara	FE	2720
IT	44012	Burana	Emilia-Romagna	Ferrara	FE	2721
IT	44012	Scortichino	Emilia-Romagna	Ferrara	FE	2722
IT	44014	Madonna Boschi	Emilia-Romagna	Ferrara	FE	2723
IT	44015	Runco	Emilia-Romagna	Ferrara	FE	2724
IT	44015	Ripapersico	Emilia-Romagna	Ferrara	FE	2725
IT	44015	Gambulaga	Emilia-Romagna	Ferrara	FE	2726
IT	44015	Portoverrara	Emilia-Romagna	Ferrara	FE	2727
IT	44015	Portomaggiore	Emilia-Romagna	Ferrara	FE	2728
IT	44015	Maiero	Emilia-Romagna	Ferrara	FE	2729
IT	44019	Voghiera	Emilia-Romagna	Ferrara	FE	2730
IT	44019	Voghenza	Emilia-Romagna	Ferrara	FE	2731
IT	44019	Montesanto	Emilia-Romagna	Ferrara	FE	2732
IT	44020	Masi Torello	Emilia-Romagna	Ferrara	FE	2733
IT	44020	Goro	Emilia-Romagna	Ferrara	FE	2734
IT	44020	Medelana	Emilia-Romagna	Ferrara	FE	2735
IT	44020	Gorino	Emilia-Romagna	Ferrara	FE	2736
IT	44020	Ostellato	Emilia-Romagna	Ferrara	FE	2737
IT	44020	San Giuseppe Di Comacchio	Emilia-Romagna	Ferrara	FE	2738
IT	44020	San Giovanni	Emilia-Romagna	Ferrara	FE	2739
IT	44020	Dogato	Emilia-Romagna	Ferrara	FE	2740
IT	44020	Rovereto Ferrarese	Emilia-Romagna	Ferrara	FE	2741
IT	44020	Gorino Di Goro	Emilia-Romagna	Ferrara	FE	2742
IT	44020	San Giovanni Di Ostellato	Emilia-Romagna	Ferrara	FE	2743
IT	44020	Masi San Giacomo	Emilia-Romagna	Ferrara	FE	2744
IT	44021	Codigoro	Emilia-Romagna	Ferrara	FE	2745
IT	44021	Pomposa	Emilia-Romagna	Ferrara	FE	2746
IT	44021	Pontemaodino	Emilia-Romagna	Ferrara	FE	2747
IT	44021	Mezzogoro	Emilia-Romagna	Ferrara	FE	2748
IT	44021	Pontelangorino	Emilia-Romagna	Ferrara	FE	2749
IT	44022	Volania	Emilia-Romagna	Ferrara	FE	2750
IT	44022	San Giuseppe	Emilia-Romagna	Ferrara	FE	2751
IT	44022	Comacchio	Emilia-Romagna	Ferrara	FE	2752
IT	44022	Vaccolino	Emilia-Romagna	Ferrara	FE	2753
IT	44023	Marozzo	Emilia-Romagna	Ferrara	FE	2754
IT	44023	Lagosanto	Emilia-Romagna	Ferrara	FE	2755
IT	44026	Monticelli	Emilia-Romagna	Ferrara	FE	2756
IT	44026	Massenzatica	Emilia-Romagna	Ferrara	FE	2757
IT	44026	Ariano	Emilia-Romagna	Ferrara	FE	2758
IT	44026	Mesola	Emilia-Romagna	Ferrara	FE	2759
IT	44026	Ariano Ferrarese	Emilia-Romagna	Ferrara	FE	2760
IT	44026	Bosco Mesola	Emilia-Romagna	Ferrara	FE	2761
IT	44026	Bosco	Emilia-Romagna	Ferrara	FE	2762
IT	44027	Massa Fiscaglia	Emilia-Romagna	Ferrara	FE	2763
IT	44027	Migliaro	Emilia-Romagna	Ferrara	FE	2764
IT	44027	Migliarino	Emilia-Romagna	Ferrara	FE	2765
IT	44027	Fiscaglia	Emilia-Romagna	Ferrara	FE	2766
IT	44028	Poggio Renatico	Emilia-Romagna	Ferrara	FE	2767
IT	44028	Coronella	Emilia-Romagna	Ferrara	FE	2768
IT	44028	Gallo	Emilia-Romagna	Ferrara	FE	2769
IT	44028	Chiesa Nuova	Emilia-Romagna	Ferrara	FE	2770
IT	44029	Lido Degli Estensi	Emilia-Romagna	Ferrara	FE	2771
IT	44029	Porto Garibaldi	Emilia-Romagna	Ferrara	FE	2772
IT	44029	Lido Di Spina	Emilia-Romagna	Ferrara	FE	2773
IT	44030	Guarda	Emilia-Romagna	Ferrara	FE	2774
IT	44030	Ro	Emilia-Romagna	Ferrara	FE	2775
IT	44030	Ruina	Emilia-Romagna	Ferrara	FE	2776
IT	44030	Alberone Di Ro	Emilia-Romagna	Ferrara	FE	2777
IT	44030	Alberone Di Guarda	Emilia-Romagna	Ferrara	FE	2778
IT	44030	Guarda Ferrarese	Emilia-Romagna	Ferrara	FE	2779
IT	44033	Serravalle	Emilia-Romagna	Ferrara	FE	2780
IT	44033	Berra	Emilia-Romagna	Ferrara	FE	2781
IT	44033	Cologna	Emilia-Romagna	Ferrara	FE	2782
IT	44034	Coccanile	Emilia-Romagna	Ferrara	FE	2783
IT	44034	Tamara	Emilia-Romagna	Ferrara	FE	2784
IT	44034	Copparo	Emilia-Romagna	Ferrara	FE	2785
IT	44034	Zenzalino	Emilia-Romagna	Ferrara	FE	2786
IT	44034	Sabbioncello San Vittore	Emilia-Romagna	Ferrara	FE	2787
IT	44034	Cesta	Emilia-Romagna	Ferrara	FE	2788
IT	44034	Fossalta	Emilia-Romagna	Ferrara	FE	2789
IT	44034	Saletta	Emilia-Romagna	Ferrara	FE	2790
IT	44034	Ambrogio	Emilia-Romagna	Ferrara	FE	2791
IT	44034	Gradizza	Emilia-Romagna	Ferrara	FE	2792
IT	44034	Sabbioncello San Pietro	Emilia-Romagna	Ferrara	FE	2793
IT	44035	Formignana	Emilia-Romagna	Ferrara	FE	2794
IT	44035	Brazzolo	Emilia-Romagna	Ferrara	FE	2795
IT	44037	Jolanda Di Savoia	Emilia-Romagna	Ferrara	FE	2796
IT	44039	Tresigallo	Emilia-Romagna	Ferrara	FE	2797
IT	44039	Final Di Rero	Emilia-Romagna	Ferrara	FE	2798
IT	44039	Rero	Emilia-Romagna	Ferrara	FE	2799
IT	44041	Reno Centese	Emilia-Romagna	Ferrara	FE	2800
IT	44041	Buonacompra	Emilia-Romagna	Ferrara	FE	2801
IT	44041	Casumaro	Emilia-Romagna	Ferrara	FE	2802
IT	44042	Corpo Di Reno	Emilia-Romagna	Ferrara	FE	2803
IT	44042	Cento	Emilia-Romagna	Ferrara	FE	2804
IT	44042	Alberone	Emilia-Romagna	Ferrara	FE	2805
IT	44042	Corpo Reno	Emilia-Romagna	Ferrara	FE	2806
IT	44042	Penzale	Emilia-Romagna	Ferrara	FE	2807
IT	44042	Alberone Di Cento	Emilia-Romagna	Ferrara	FE	2808
IT	44043	Mirabello	Emilia-Romagna	Ferrara	FE	2809
IT	44045	Dodici Morelli	Emilia-Romagna	Ferrara	FE	2810
IT	44045	Renazzo	Emilia-Romagna	Ferrara	FE	2811
IT	44047	Dosso	Emilia-Romagna	Ferrara	FE	2812
IT	44047	Sant'Agostino	Emilia-Romagna	Ferrara	FE	2813
IT	44047	San Carlo	Emilia-Romagna	Ferrara	FE	2814
IT	44049	Vigarano Mainarda	Emilia-Romagna	Ferrara	FE	2815
IT	44049	Vigarano Pieve	Emilia-Romagna	Ferrara	FE	2816
IT	44100	Torre Della Fossa	Emilia-Romagna	Ferrara	FE	2817
IT	44100	Baura	Emilia-Romagna	Ferrara	FE	2818
IT	44100	Codrea	Emilia-Romagna	Ferrara	FE	2819
IT	44100	Corlo	Emilia-Romagna	Ferrara	FE	2820
IT	44100	Gaibana	Emilia-Romagna	Ferrara	FE	2821
IT	44100	Quartesana	Emilia-Romagna	Ferrara	FE	2822
IT	44100	Pontegradella	Emilia-Romagna	Ferrara	FE	2823
IT	44100	Sant'Edigio	Emilia-Romagna	Ferrara	FE	2824
IT	44100	Villanova	Emilia-Romagna	Ferrara	FE	2825
IT	44100	Ravalle	Emilia-Romagna	Ferrara	FE	2826
IT	44100	Viconovo	Emilia-Romagna	Ferrara	FE	2827
IT	44100	Marrara	Emilia-Romagna	Ferrara	FE	2828
IT	44100	Fossanova San Marco	Emilia-Romagna	Ferrara	FE	2829
IT	44100	Gaibanella	Emilia-Romagna	Ferrara	FE	2830
IT	44100	San Bartolomeo In Bosco	Emilia-Romagna	Ferrara	FE	2831
IT	44100	Monestirolo	Emilia-Romagna	Ferrara	FE	2832
IT	44100	Chiesuol Del Fosso	Emilia-Romagna	Ferrara	FE	2833
IT	44100	Fossa D'Albero	Emilia-Romagna	Ferrara	FE	2834
IT	44100	Francolino	Emilia-Romagna	Ferrara	FE	2835
IT	44100	Montalbano	Emilia-Romagna	Ferrara	FE	2836
IT	44100	Casaglia	Emilia-Romagna	Ferrara	FE	2837
IT	44100	Boara	Emilia-Romagna	Ferrara	FE	2838
IT	44100	Cona	Emilia-Romagna	Ferrara	FE	2839
IT	44100	Cocomaro Di Cona	Emilia-Romagna	Ferrara	FE	2840
IT	44100	Denore	Emilia-Romagna	Ferrara	FE	2841
IT	44100	Porotto	Emilia-Romagna	Ferrara	FE	2842
IT	44100	Pontelagoscuro	Emilia-Romagna	Ferrara	FE	2843
IT	44100	Cassana	Emilia-Romagna	Ferrara	FE	2844
IT	44100	San Martino	Emilia-Romagna	Ferrara	FE	2845
IT	44100	Villanova Di Denore	Emilia-Romagna	Ferrara	FE	2846
IT	44121	Ferrara	Emilia-Romagna	Ferrara	FE	2847
IT	44122	Ferrara	Emilia-Romagna	Ferrara	FE	2848
IT	44123	Ferrara	Emilia-Romagna	Ferrara	FE	2849
IT	44124	Ferrara	Emilia-Romagna	Ferrara	FE	2850
IT	41011	Saliceto Buzzalino	Emilia-Romagna	Modena	MO	2851
IT	41011	Campogalliano	Emilia-Romagna	Modena	MO	2852
IT	41011	Panzano	Emilia-Romagna	Modena	MO	2853
IT	41012	Fossoli	Emilia-Romagna	Modena	MO	2854
IT	41012	Carpi	Emilia-Romagna	Modena	MO	2855
IT	41012	Gargallo	Emilia-Romagna	Modena	MO	2856
IT	41012	Cortile	Emilia-Romagna	Modena	MO	2857
IT	41012	Budrione	Emilia-Romagna	Modena	MO	2858
IT	41012	Migliarina	Emilia-Romagna	Modena	MO	2859
IT	41012	San Martino Secchia	Emilia-Romagna	Modena	MO	2860
IT	41012	San Marino	Emilia-Romagna	Modena	MO	2861
IT	41012	Santa Croce	Emilia-Romagna	Modena	MO	2862
IT	41013	Piumazzo	Emilia-Romagna	Modena	MO	2863
IT	41013	Castelfranco Emilia	Emilia-Romagna	Modena	MO	2864
IT	41013	Cavazzona	Emilia-Romagna	Modena	MO	2865
IT	41013	Gaggio Di Piano	Emilia-Romagna	Modena	MO	2866
IT	41013	Riolo	Emilia-Romagna	Modena	MO	2867
IT	41013	Rastellino	Emilia-Romagna	Modena	MO	2868
IT	41013	Manzolino	Emilia-Romagna	Modena	MO	2869
IT	41013	Recovato	Emilia-Romagna	Modena	MO	2870
IT	41014	Solignano Nuovo	Emilia-Romagna	Modena	MO	2871
IT	41014	Castelvetro Di Modena	Emilia-Romagna	Modena	MO	2872
IT	41014	Levizzano Rangone	Emilia-Romagna	Modena	MO	2873
IT	41014	Ca' Di Sola	Emilia-Romagna	Modena	MO	2874
IT	41015	Via Larga	Emilia-Romagna	Modena	MO	2875
IT	41015	Campazzo	Emilia-Romagna	Modena	MO	2876
IT	41015	Bagazzano	Emilia-Romagna	Modena	MO	2877
IT	41015	La Grande	Emilia-Romagna	Modena	MO	2878
IT	41015	Nonantola	Emilia-Romagna	Modena	MO	2879
IT	41015	Redu'	Emilia-Romagna	Modena	MO	2880
IT	41016	Sant'Antonio In Mercadello	Emilia-Romagna	Modena	MO	2881
IT	41016	Novi Di Modena	Emilia-Romagna	Modena	MO	2882
IT	41016	Rovereto Sulla Secchia	Emilia-Romagna	Modena	MO	2883
IT	41017	Ravarino	Emilia-Romagna	Modena	MO	2884
IT	41017	Stuffione	Emilia-Romagna	Modena	MO	2885
IT	41018	San Cesario Sul Panaro	Emilia-Romagna	Modena	MO	2886
IT	41019	Limidi	Emilia-Romagna	Modena	MO	2887
IT	41019	Sozzigalli	Emilia-Romagna	Modena	MO	2888
IT	41019	Soliera	Emilia-Romagna	Modena	MO	2889
IT	41019	Appalto	Emilia-Romagna	Modena	MO	2890
IT	41020	Castello	Emilia-Romagna	Modena	MO	2891
IT	41020	Serpiano	Emilia-Romagna	Modena	MO	2892
IT	41020	Groppo	Emilia-Romagna	Modena	MO	2893
IT	41020	Riolunato	Emilia-Romagna	Modena	MO	2894
IT	41020	Castellino	Emilia-Romagna	Modena	MO	2895
IT	41020	Castellino Brocco	Emilia-Romagna	Modena	MO	2896
IT	41021	Fellicarolo	Emilia-Romagna	Modena	MO	2897
IT	41021	Ospitale	Emilia-Romagna	Modena	MO	2898
IT	41021	Fanano	Emilia-Romagna	Modena	MO	2899
IT	41021	Lotta	Emilia-Romagna	Modena	MO	2900
IT	41021	Trentino Nel Frignano	Emilia-Romagna	Modena	MO	2901
IT	41021	Canevare	Emilia-Romagna	Modena	MO	2902
IT	41021	Serrazzone	Emilia-Romagna	Modena	MO	2903
IT	41021	Trignano Nel Frignano	Emilia-Romagna	Modena	MO	2904
IT	41021	Ospitale Nel Frignano	Emilia-Romagna	Modena	MO	2905
IT	41021	Trignano	Emilia-Romagna	Modena	MO	2906
IT	41022	Fiumalbo	Emilia-Romagna	Modena	MO	2907
IT	41022	Faidello	Emilia-Romagna	Modena	MO	2908
IT	41022	Dogana Nuova	Emilia-Romagna	Modena	MO	2909
IT	41023	Cadignano	Emilia-Romagna	Modena	MO	2910
IT	41023	Barigazzo	Emilia-Romagna	Modena	MO	2911
IT	41023	Sassostorno	Emilia-Romagna	Modena	MO	2912
IT	41023	Mocogno	Emilia-Romagna	Modena	MO	2913
IT	41023	Montecenere	Emilia-Romagna	Modena	MO	2914
IT	41023	Vaglio	Emilia-Romagna	Modena	MO	2915
IT	41023	Lama	Emilia-Romagna	Modena	MO	2916
IT	41023	La Santona	Emilia-Romagna	Modena	MO	2917
IT	41023	Pianorso	Emilia-Romagna	Modena	MO	2918
IT	41023	Lama Mocogno	Emilia-Romagna	Modena	MO	2919
IT	41025	Acquaria	Emilia-Romagna	Modena	MO	2920
IT	41025	Montecreto	Emilia-Romagna	Modena	MO	2921
IT	41026	Verica	Emilia-Romagna	Modena	MO	2922
IT	41026	Castagneto	Emilia-Romagna	Modena	MO	2923
IT	41026	Benedello	Emilia-Romagna	Modena	MO	2924
IT	41026	Olina	Emilia-Romagna	Modena	MO	2925
IT	41026	Pavullo Nel Frignano	Emilia-Romagna	Modena	MO	2926
IT	41026	Montebonello	Emilia-Romagna	Modena	MO	2927
IT	41026	Montecuccolo	Emilia-Romagna	Modena	MO	2928
IT	41026	Frassineti	Emilia-Romagna	Modena	MO	2929
IT	41026	Niviano	Emilia-Romagna	Modena	MO	2930
IT	41026	Gaiato	Emilia-Romagna	Modena	MO	2931
IT	41026	Renno	Emilia-Romagna	Modena	MO	2932
IT	41026	Sant'Antonio	Emilia-Romagna	Modena	MO	2933
IT	41026	Coscogno	Emilia-Romagna	Modena	MO	2934
IT	41026	Monzone	Emilia-Romagna	Modena	MO	2935
IT	41026	Camatta	Emilia-Romagna	Modena	MO	2936
IT	41026	Gaianello	Emilia-Romagna	Modena	MO	2937
IT	41026	Iddiano	Emilia-Romagna	Modena	MO	2938
IT	41026	Sasso Guidano	Emilia-Romagna	Modena	MO	2939
IT	41026	Miceno	Emilia-Romagna	Modena	MO	2940
IT	41026	Crocette	Emilia-Romagna	Modena	MO	2941
IT	41026	Montorso	Emilia-Romagna	Modena	MO	2942
IT	41027	Sant'Andrea Pelago	Emilia-Romagna	Modena	MO	2943
IT	41027	Pievepelago	Emilia-Romagna	Modena	MO	2944
IT	41027	Roccapelago	Emilia-Romagna	Modena	MO	2945
IT	41027	Sant'Anna Pelago	Emilia-Romagna	Modena	MO	2946
IT	41027	Tagliole	Emilia-Romagna	Modena	MO	2947
IT	41028	Pompeano	Emilia-Romagna	Modena	MO	2948
IT	41028	Faeto	Emilia-Romagna	Modena	MO	2949
IT	41028	San Dalmazio	Emilia-Romagna	Modena	MO	2950
IT	41028	Selva	Emilia-Romagna	Modena	MO	2951
IT	41028	Ricco'	Emilia-Romagna	Modena	MO	2952
IT	41028	Rocca Santa Maria	Emilia-Romagna	Modena	MO	2953
IT	41028	Montagnana	Emilia-Romagna	Modena	MO	2954
IT	41028	Monfestino	Emilia-Romagna	Modena	MO	2955
IT	41028	Varana	Emilia-Romagna	Modena	MO	2956
IT	41028	Valle	Emilia-Romagna	Modena	MO	2957
IT	41028	Serramazzoni	Emilia-Romagna	Modena	MO	2958
IT	41028	Selva Nel Frignano	Emilia-Romagna	Modena	MO	2959
IT	41028	Ligorzano	Emilia-Romagna	Modena	MO	2960
IT	41028	San Dalmazio Nel Frignano	Emilia-Romagna	Modena	MO	2961
IT	41028	Ricco' Nel Frignano	Emilia-Romagna	Modena	MO	2962
IT	41028	Pazzano	Emilia-Romagna	Modena	MO	2963
IT	41029	Vesale	Emilia-Romagna	Modena	MO	2964
IT	41029	Sestola	Emilia-Romagna	Modena	MO	2965
IT	41029	Roncoscaglia	Emilia-Romagna	Modena	MO	2966
IT	41029	Castellaro	Emilia-Romagna	Modena	MO	2967
IT	41029	Casine	Emilia-Romagna	Modena	MO	2968
IT	41029	Rocchetta Sandri	Emilia-Romagna	Modena	MO	2969
IT	41029	Castellaro Nel Frignano	Emilia-Romagna	Modena	MO	2970
IT	41030	Sorbara	Emilia-Romagna	Modena	MO	2971
IT	41030	San Martino	Emilia-Romagna	Modena	MO	2972
IT	41030	San Prospero	Emilia-Romagna	Modena	MO	2973
IT	41030	San Lorenzo Pioppa	Emilia-Romagna	Modena	MO	2974
IT	41030	Gorghetto	Emilia-Romagna	Modena	MO	2975
IT	41030	San Martino Di San Prospero	Emilia-Romagna	Modena	MO	2976
IT	41030	San Pietro	Emilia-Romagna	Modena	MO	2977
IT	41030	San Lorenzo Della Pioppa	Emilia-Romagna	Modena	MO	2978
IT	41030	Bastiglia	Emilia-Romagna	Modena	MO	2979
IT	41030	Solara	Emilia-Romagna	Modena	MO	2980
IT	41030	Bomporto	Emilia-Romagna	Modena	MO	2981
IT	41030	Staggia	Emilia-Romagna	Modena	MO	2982
IT	41030	San Pietro In Elda	Emilia-Romagna	Modena	MO	2983
IT	41030	Staggia Modenese	Emilia-Romagna	Modena	MO	2984
IT	41031	Camposanto	Emilia-Romagna	Modena	MO	2985
IT	41032	Cavezzo	Emilia-Romagna	Modena	MO	2986
IT	41032	Villa Motta	Emilia-Romagna	Modena	MO	2987
IT	41032	Motta Sulla Secchia	Emilia-Romagna	Modena	MO	2988
IT	41032	Motta	Emilia-Romagna	Modena	MO	2989
IT	41033	San Giovanni	Emilia-Romagna	Modena	MO	2990
IT	41033	Concordia Sulla Secchia	Emilia-Romagna	Modena	MO	2991
IT	41033	Fossa Di Concordia	Emilia-Romagna	Modena	MO	2992
IT	41033	Santa Caterina	Emilia-Romagna	Modena	MO	2993
IT	41033	Vallalta	Emilia-Romagna	Modena	MO	2994
IT	41033	Fossa	Emilia-Romagna	Modena	MO	2995
IT	41034	Finale Emilia	Emilia-Romagna	Modena	MO	2996
IT	41034	Reno Finalese	Emilia-Romagna	Modena	MO	2997
IT	41035	Massa Finalese	Emilia-Romagna	Modena	MO	2998
IT	41036	Villafranca	Emilia-Romagna	Modena	MO	2999
IT	41036	Medolla	Emilia-Romagna	Modena	MO	3000
IT	41036	Villafranca Di Medolla	Emilia-Romagna	Modena	MO	3001
IT	41036	Camurana	Emilia-Romagna	Modena	MO	3002
IT	41037	Ponte San Pellegrino	Emilia-Romagna	Modena	MO	3003
IT	41037	Mirandola	Emilia-Romagna	Modena	MO	3004
IT	41037	San Giacomo Roncole	Emilia-Romagna	Modena	MO	3005
IT	41037	Tramuschio	Emilia-Romagna	Modena	MO	3006
IT	41037	Gavello	Emilia-Romagna	Modena	MO	3007
IT	41037	Mortizzuolo	Emilia-Romagna	Modena	MO	3008
IT	41037	San Martino Spino	Emilia-Romagna	Modena	MO	3009
IT	41037	Quarantoli	Emilia-Romagna	Modena	MO	3010
IT	41037	San Martino Carano	Emilia-Romagna	Modena	MO	3011
IT	41037	Cividale	Emilia-Romagna	Modena	MO	3012
IT	41038	Pavignane	Emilia-Romagna	Modena	MO	3013
IT	41038	San Biagio	Emilia-Romagna	Modena	MO	3014
IT	41038	Dogaro	Emilia-Romagna	Modena	MO	3015
IT	41038	San Felice Sul Panaro	Emilia-Romagna	Modena	MO	3016
IT	41038	Confine	Emilia-Romagna	Modena	MO	3017
IT	41038	Rivara	Emilia-Romagna	Modena	MO	3018
IT	41038	San Biagio In Padule	Emilia-Romagna	Modena	MO	3019
IT	41039	San Possidonio	Emilia-Romagna	Modena	MO	3020
IT	41040	Polinago	Emilia-Romagna	Modena	MO	3021
IT	41040	Ponte Gombola	Emilia-Romagna	Modena	MO	3022
IT	41040	Cassano	Emilia-Romagna	Modena	MO	3023
IT	41040	Gombola	Emilia-Romagna	Modena	MO	3024
IT	41040	San Martino Vallata	Emilia-Romagna	Modena	MO	3025
IT	41042	Fiorano Modenese	Emilia-Romagna	Modena	MO	3026
IT	41042	Ubersetto	Emilia-Romagna	Modena	MO	3027
IT	41042	Spezzano	Emilia-Romagna	Modena	MO	3028
IT	41043	Colombaro Di Formigine	Emilia-Romagna	Modena	MO	3029
IT	41043	Magreta	Emilia-Romagna	Modena	MO	3030
IT	41043	Formigine	Emilia-Romagna	Modena	MO	3031
IT	41043	Corlo Di Formigine	Emilia-Romagna	Modena	MO	3032
IT	41043	Casinalbo	Emilia-Romagna	Modena	MO	3033
IT	41043	Colombaro	Emilia-Romagna	Modena	MO	3034
IT	41044	Romanoro	Emilia-Romagna	Modena	MO	3035
IT	41044	Riccovolto	Emilia-Romagna	Modena	MO	3036
IT	41044	Frassinoro	Emilia-Romagna	Modena	MO	3037
IT	41044	Sassatella	Emilia-Romagna	Modena	MO	3038
IT	41044	Cargedolo	Emilia-Romagna	Modena	MO	3039
IT	41044	Fontanaluccia	Emilia-Romagna	Modena	MO	3040
IT	41044	Piandelagotti	Emilia-Romagna	Modena	MO	3041
IT	41044	Madonna Di Pietravolta	Emilia-Romagna	Modena	MO	3042
IT	41044	Rovolo	Emilia-Romagna	Modena	MO	3043
IT	41045	Farneta	Emilia-Romagna	Modena	MO	3044
IT	41045	Casola	Emilia-Romagna	Modena	MO	3045
IT	41045	Gusciola	Emilia-Romagna	Modena	MO	3046
IT	41045	Montefiorino	Emilia-Romagna	Modena	MO	3047
IT	41045	Macognano	Emilia-Romagna	Modena	MO	3048
IT	41045	Vitriola	Emilia-Romagna	Modena	MO	3049
IT	41045	Lago	Emilia-Romagna	Modena	MO	3050
IT	41045	Rubbiano	Emilia-Romagna	Modena	MO	3051
IT	41046	Palagano	Emilia-Romagna	Modena	MO	3052
IT	41046	Savoniero	Emilia-Romagna	Modena	MO	3053
IT	41046	Costrignano	Emilia-Romagna	Modena	MO	3054
IT	41046	Monchio Nel Frignano	Emilia-Romagna	Modena	MO	3055
IT	41046	Monchio	Emilia-Romagna	Modena	MO	3056
IT	41046	Susano	Emilia-Romagna	Modena	MO	3057
IT	41046	Boccassuolo	Emilia-Romagna	Modena	MO	3058
IT	41048	Montebaranzone	Emilia-Romagna	Modena	MO	3059
IT	41048	Saltino Sulla Secchia	Emilia-Romagna	Modena	MO	3060
IT	41048	Moncerrato	Emilia-Romagna	Modena	MO	3061
IT	41048	Castelvecchio	Emilia-Romagna	Modena	MO	3062
IT	41048	Prignano Sulla Secchia	Emilia-Romagna	Modena	MO	3063
IT	41048	Pigneto	Emilia-Romagna	Modena	MO	3064
IT	41048	Sasso Morello	Emilia-Romagna	Modena	MO	3065
IT	41048	Saltino	Emilia-Romagna	Modena	MO	3066
IT	41048	Morano	Emilia-Romagna	Modena	MO	3067
IT	41048	Castelvecchio Sulla Secchia	Emilia-Romagna	Modena	MO	3068
IT	41049	Montegibbio	Emilia-Romagna	Modena	MO	3069
IT	41049	Sassuolo	Emilia-Romagna	Modena	MO	3070
IT	41049	San Michele Dei Mucchietti	Emilia-Romagna	Modena	MO	3071
IT	41051	Montale Rangone	Emilia-Romagna	Modena	MO	3072
IT	41051	Castelnuovo Rangone	Emilia-Romagna	Modena	MO	3073
IT	41051	Montale	Emilia-Romagna	Modena	MO	3074
IT	41052	Pieve Di Trebbio	Emilia-Romagna	Modena	MO	3075
IT	41052	Rocchetta	Emilia-Romagna	Modena	MO	3076
IT	41052	Rocca Malatina	Emilia-Romagna	Modena	MO	3077
IT	41052	Pieve Trebbio	Emilia-Romagna	Modena	MO	3078
IT	41052	Guiglia	Emilia-Romagna	Modena	MO	3079
IT	41052	Gainazzo	Emilia-Romagna	Modena	MO	3080
IT	41052	Castellino Delle Formiche	Emilia-Romagna	Modena	MO	3081
IT	41052	Samone	Emilia-Romagna	Modena	MO	3082
IT	41052	Monteorsello	Emilia-Romagna	Modena	MO	3083
IT	41053	Pozza	Emilia-Romagna	Modena	MO	3084
IT	41053	Gorzano	Emilia-Romagna	Modena	MO	3085
IT	41053	Maranello	Emilia-Romagna	Modena	MO	3086
IT	41053	Torre Maina	Emilia-Romagna	Modena	MO	3087
IT	41054	Marano Sul Panaro	Emilia-Romagna	Modena	MO	3088
IT	41054	Festa'	Emilia-Romagna	Modena	MO	3089
IT	41054	Villa Bianca	Emilia-Romagna	Modena	MO	3090
IT	41054	Ospitaletto	Emilia-Romagna	Modena	MO	3091
IT	41055	Maserno	Emilia-Romagna	Modena	MO	3092
IT	41055	Iola	Emilia-Romagna	Modena	MO	3093
IT	41055	Castelluccio	Emilia-Romagna	Modena	MO	3094
IT	41055	San Martino	Emilia-Romagna	Modena	MO	3095
IT	41055	Montese	Emilia-Romagna	Modena	MO	3096
IT	41055	Iola Di Montese	Emilia-Romagna	Modena	MO	3097
IT	41055	Castelluccio Di Moscheda	Emilia-Romagna	Modena	MO	3098
IT	41055	Bertocchi	Emilia-Romagna	Modena	MO	3099
IT	41055	Semelano	Emilia-Romagna	Modena	MO	3100
IT	41055	San Giacomo Maggiore	Emilia-Romagna	Modena	MO	3101
IT	41055	Salto	Emilia-Romagna	Modena	MO	3102
IT	41055	Montespecchio	Emilia-Romagna	Modena	MO	3103
IT	41055	Montalto	Emilia-Romagna	Modena	MO	3104
IT	41056	Mulino	Emilia-Romagna	Modena	MO	3105
IT	41056	Savignano Sul Panaro	Emilia-Romagna	Modena	MO	3106
IT	41056	Formica	Emilia-Romagna	Modena	MO	3107
IT	41056	Magazzino	Emilia-Romagna	Modena	MO	3108
IT	41056	Garofano	Emilia-Romagna	Modena	MO	3109
IT	41057	Spilamberto	Emilia-Romagna	Modena	MO	3110
IT	41057	San Vito	Emilia-Romagna	Modena	MO	3111
IT	41058	Vignola	Emilia-Romagna	Modena	MO	3112
IT	41059	Monteombraro	Emilia-Romagna	Modena	MO	3113
IT	41059	Rosola	Emilia-Romagna	Modena	MO	3114
IT	41059	Ciano	Emilia-Romagna	Modena	MO	3115
IT	41059	Zocca	Emilia-Romagna	Modena	MO	3116
IT	41059	Missano	Emilia-Romagna	Modena	MO	3117
IT	41059	Montetortore	Emilia-Romagna	Modena	MO	3118
IT	41059	Ciano Nel Frignano	Emilia-Romagna	Modena	MO	3119
IT	41059	Montecorone	Emilia-Romagna	Modena	MO	3120
IT	41059	Montealbano	Emilia-Romagna	Modena	MO	3121
IT	41100	Villanova	Emilia-Romagna	Modena	MO	3122
IT	41100	Marzaglia	Emilia-Romagna	Modena	MO	3123
IT	41100	San Donnino	Emilia-Romagna	Modena	MO	3124
IT	41100	Lesignana	Emilia-Romagna	Modena	MO	3125
IT	41100	Modena	Emilia-Romagna	Modena	MO	3126
IT	41100	Ganaceto	Emilia-Romagna	Modena	MO	3127
IT	41100	Chiesa Nuova Di Marzaglia	Emilia-Romagna	Modena	MO	3128
IT	41100	Albareto	Emilia-Romagna	Modena	MO	3129
IT	41100	Baggiovara	Emilia-Romagna	Modena	MO	3130
IT	41100	Portile	Emilia-Romagna	Modena	MO	3131
IT	41100	San Damaso	Emilia-Romagna	Modena	MO	3132
IT	41100	Vaciglio	Emilia-Romagna	Modena	MO	3133
IT	41100	Cognento	Emilia-Romagna	Modena	MO	3134
IT	41100	Villanova San Pancrazio	Emilia-Romagna	Modena	MO	3135
IT	41100	Saliceto San Giuliano	Emilia-Romagna	Modena	MO	3136
IT	41100	Freto	Emilia-Romagna	Modena	MO	3137
IT	41100	Saliceto Panaro	Emilia-Romagna	Modena	MO	3138
IT	29010	Pontenure	Emilia-Romagna	Piacenza	PC	3139
IT	29010	Gragnano Trebbiense	Emilia-Romagna	Piacenza	PC	3140
IT	29010	Calendasco	Emilia-Romagna	Piacenza	PC	3141
IT	29010	Gazzola	Emilia-Romagna	Piacenza	PC	3142
IT	29010	Pecorara	Emilia-Romagna	Piacenza	PC	3143
IT	29010	Agazzano	Emilia-Romagna	Piacenza	PC	3144
IT	29010	San Nicolo'	Emilia-Romagna	Piacenza	PC	3145
IT	29010	Campremoldo Sopra	Emilia-Romagna	Piacenza	PC	3146
IT	29010	Alseno	Emilia-Romagna	Piacenza	PC	3147
IT	29010	Stra'	Emilia-Romagna	Piacenza	PC	3148
IT	29010	Rezzanello	Emilia-Romagna	Piacenza	PC	3149
IT	29010	Cadeo	Emilia-Romagna	Piacenza	PC	3150
IT	29010	Nibbiano	Emilia-Romagna	Piacenza	PC	3151
IT	29010	Olza	Emilia-Romagna	Piacenza	PC	3152
IT	29010	Piozzano	Emilia-Romagna	Piacenza	PC	3153
IT	29010	Valconasso	Emilia-Romagna	Piacenza	PC	3154
IT	29010	Pianello Val Tidone	Emilia-Romagna	Piacenza	PC	3155
IT	29010	San Pietro In Cerro	Emilia-Romagna	Piacenza	PC	3156
IT	29010	Trevozzo	Emilia-Romagna	Piacenza	PC	3157
IT	29010	Sant'Imento	Emilia-Romagna	Piacenza	PC	3158
IT	29010	Villanova	Emilia-Romagna	Piacenza	PC	3159
IT	29010	Vernasca	Emilia-Romagna	Piacenza	PC	3160
IT	29010	Monticelli D'Ongina	Emilia-Romagna	Piacenza	PC	3161
IT	29010	Vigoleno	Emilia-Romagna	Piacenza	PC	3162
IT	29010	Besenzone	Emilia-Romagna	Piacenza	PC	3163
IT	29010	San Nazzaro D'Ongina	Emilia-Romagna	Piacenza	PC	3164
IT	29010	Sarmato	Emilia-Romagna	Piacenza	PC	3165
IT	29010	Castelnuovo Fogliani	Emilia-Romagna	Piacenza	PC	3166
IT	29010	Ziano Piacentino	Emilia-Romagna	Piacenza	PC	3167
IT	29010	Castelvetro Piacentino	Emilia-Romagna	Piacenza	PC	3168
IT	29010	Fogarole	Emilia-Romagna	Piacenza	PC	3169
IT	29010	Tassara	Emilia-Romagna	Piacenza	PC	3170
IT	29010	Campremoldo Sotto	Emilia-Romagna	Piacenza	PC	3171
IT	29010	Mezzano Chitantolo	Emilia-Romagna	Piacenza	PC	3172
IT	29010	Rottofreno	Emilia-Romagna	Piacenza	PC	3173
IT	29010	Lusurasco	Emilia-Romagna	Piacenza	PC	3174
IT	29010	Roveleto	Emilia-Romagna	Piacenza	PC	3175
IT	29010	Vicobarone	Emilia-Romagna	Piacenza	PC	3176
IT	29010	Fontana Fredda	Emilia-Romagna	Piacenza	PC	3177
IT	29010	Caminata	Emilia-Romagna	Piacenza	PC	3178
IT	29010	Chiaravalle	Emilia-Romagna	Piacenza	PC	3179
IT	29010	Casaliggio	Emilia-Romagna	Piacenza	PC	3180
IT	29010	San Giuliano Piacentino	Emilia-Romagna	Piacenza	PC	3181
IT	29010	Bacedasco Sotto	Emilia-Romagna	Piacenza	PC	3182
IT	29010	San Giuliano	Emilia-Romagna	Piacenza	PC	3183
IT	29010	Campremoldo Sopra E Sotto	Emilia-Romagna	Piacenza	PC	3184
IT	29010	Villanova Sull'Arda	Emilia-Romagna	Piacenza	PC	3185
IT	29010	San Nicolo' A Trebbia	Emilia-Romagna	Piacenza	PC	3186
IT	29011	Borgonovo Val Tidone	Emilia-Romagna	Piacenza	PC	3187
IT	29011	Castelnuovo	Emilia-Romagna	Piacenza	PC	3188
IT	29011	Castelnovo Val Tidone	Emilia-Romagna	Piacenza	PC	3189
IT	29012	Caorso	Emilia-Romagna	Piacenza	PC	3190
IT	29013	Rezzano	Emilia-Romagna	Piacenza	PC	3191
IT	29013	Carpaneto Piacentino	Emilia-Romagna	Piacenza	PC	3192
IT	29014	Castell'Arquato	Emilia-Romagna	Piacenza	PC	3193
IT	29014	Vigolo Marchese	Emilia-Romagna	Piacenza	PC	3194
IT	29015	Fontana Pradosa	Emilia-Romagna	Piacenza	PC	3195
IT	29015	Ganaghello	Emilia-Romagna	Piacenza	PC	3196
IT	29015	Creta	Emilia-Romagna	Piacenza	PC	3197
IT	29015	Castel San Giovanni	Emilia-Romagna	Piacenza	PC	3198
IT	29016	Cortemaggiore	Emilia-Romagna	Piacenza	PC	3199
IT	29017	San Protaso	Emilia-Romagna	Piacenza	PC	3200
IT	29017	Baselicaduce	Emilia-Romagna	Piacenza	PC	3201
IT	29017	Fiorenzuola D'Arda	Emilia-Romagna	Piacenza	PC	3202
IT	29018	Chiavenna Rocchetta	Emilia-Romagna	Piacenza	PC	3203
IT	29018	Rustigazzo	Emilia-Romagna	Piacenza	PC	3204
IT	29018	Lugagnano Val D'Arda	Emilia-Romagna	Piacenza	PC	3205
IT	29019	San Damiano	Emilia-Romagna	Piacenza	PC	3206
IT	29019	Godi	Emilia-Romagna	Piacenza	PC	3207
IT	29019	San Giorgio Piacentino	Emilia-Romagna	Piacenza	PC	3208
IT	29020	Settima	Emilia-Romagna	Piacenza	PC	3209
IT	29020	Travo	Emilia-Romagna	Piacenza	PC	3210
IT	29020	Zerba	Emilia-Romagna	Piacenza	PC	3211
IT	29020	Ponte Organasco	Emilia-Romagna	Piacenza	PC	3212
IT	29020	Villo'	Emilia-Romagna	Piacenza	PC	3213
IT	29020	Gossolengo	Emilia-Romagna	Piacenza	PC	3214
IT	29020	Carmiano	Emilia-Romagna	Piacenza	PC	3215
IT	29020	Coli	Emilia-Romagna	Piacenza	PC	3216
IT	29020	Vigolzone	Emilia-Romagna	Piacenza	PC	3217
IT	29020	Marsaglia	Emilia-Romagna	Piacenza	PC	3218
IT	29020	Cerignale	Emilia-Romagna	Piacenza	PC	3219
IT	29020	Pej	Emilia-Romagna	Piacenza	PC	3220
IT	29020	Perino	Emilia-Romagna	Piacenza	PC	3221
IT	29020	Quadrelli	Emilia-Romagna	Piacenza	PC	3222
IT	29020	Quarto	Emilia-Romagna	Piacenza	PC	3223
IT	29020	Grazzano Visconti	Emilia-Romagna	Piacenza	PC	3224
IT	29020	Morfasso	Emilia-Romagna	Piacenza	PC	3225
IT	29020	Corte Brugnatella	Emilia-Romagna	Piacenza	PC	3226
IT	29020	Quadrelli Di Fellino	Emilia-Romagna	Piacenza	PC	3227
IT	29021	Bettola	Emilia-Romagna	Piacenza	PC	3228
IT	29021	Groppoducale	Emilia-Romagna	Piacenza	PC	3229
IT	29021	San Bernardino	Emilia-Romagna	Piacenza	PC	3230
IT	29021	Bramaiano	Emilia-Romagna	Piacenza	PC	3231
IT	29021	San Giovanni	Emilia-Romagna	Piacenza	PC	3232
IT	29022	Mezzano Scotti	Emilia-Romagna	Piacenza	PC	3233
IT	29022	Cassolo	Emilia-Romagna	Piacenza	PC	3234
IT	29022	Bobbio	Emilia-Romagna	Piacenza	PC	3235
IT	29022	Santa Maria Di Bobbio	Emilia-Romagna	Piacenza	PC	3236
IT	29022	Vaccarezza	Emilia-Romagna	Piacenza	PC	3237
IT	29022	Santa Maria	Emilia-Romagna	Piacenza	PC	3238
IT	29022	Passo Penice	Emilia-Romagna	Piacenza	PC	3239
IT	29022	Ceci	Emilia-Romagna	Piacenza	PC	3240
IT	29023	Mareto	Emilia-Romagna	Piacenza	PC	3241
IT	29023	Farini	Emilia-Romagna	Piacenza	PC	3242
IT	29023	Groppallo	Emilia-Romagna	Piacenza	PC	3243
IT	29023	Le Moline	Emilia-Romagna	Piacenza	PC	3244
IT	29024	Ferriere	Emilia-Romagna	Piacenza	PC	3245
IT	29024	Centenaro Castello	Emilia-Romagna	Piacenza	PC	3246
IT	29024	Torrio Sopra	Emilia-Romagna	Piacenza	PC	3247
IT	29024	Centenaro	Emilia-Romagna	Piacenza	PC	3248
IT	29024	Torrio Casetta	Emilia-Romagna	Piacenza	PC	3249
IT	29024	Brugneto	Emilia-Romagna	Piacenza	PC	3250
IT	29024	Torrio Sopra E Sotto E Casetta	Emilia-Romagna	Piacenza	PC	3251
IT	29024	Salsominore	Emilia-Romagna	Piacenza	PC	3252
IT	29025	Groppovisdomo	Emilia-Romagna	Piacenza	PC	3253
IT	29025	Sariano	Emilia-Romagna	Piacenza	PC	3254
IT	29025	Gropparello	Emilia-Romagna	Piacenza	PC	3255
IT	29026	Ottone	Emilia-Romagna	Piacenza	PC	3256
IT	29026	Orezzoli	Emilia-Romagna	Piacenza	PC	3257
IT	29027	San Polo	Emilia-Romagna	Piacenza	PC	3258
IT	29027	Podenzano	Emilia-Romagna	Piacenza	PC	3259
IT	29028	Biana	Emilia-Romagna	Piacenza	PC	3260
IT	29028	Ponte Dell'Olio	Emilia-Romagna	Piacenza	PC	3261
IT	29028	Torrano	Emilia-Romagna	Piacenza	PC	3262
IT	29029	Rivergaro	Emilia-Romagna	Piacenza	PC	3263
IT	29029	Roveleto Landi	Emilia-Romagna	Piacenza	PC	3264
IT	29029	Ancarano Di Sopra	Emilia-Romagna	Piacenza	PC	3265
IT	29029	Niviano	Emilia-Romagna	Piacenza	PC	3266
IT	29029	Niviano Castello	Emilia-Romagna	Piacenza	PC	3267
IT	29100	Gerbido	Emilia-Romagna	Piacenza	PC	3268
IT	29100	Mucinasso	Emilia-Romagna	Piacenza	PC	3269
IT	29100	Raffaellina	Emilia-Romagna	Piacenza	PC	3270
IT	29100	Roncaglia	Emilia-Romagna	Piacenza	PC	3271
IT	29100	Piacenza	Emilia-Romagna	Piacenza	PC	3272
IT	29100	Sant'Antonio	Emilia-Romagna	Piacenza	PC	3273
IT	29100	Mortizza	Emilia-Romagna	Piacenza	PC	3274
IT	29100	San Bonico	Emilia-Romagna	Piacenza	PC	3275
IT	29100	Pittolo	Emilia-Romagna	Piacenza	PC	3276
IT	29100	Gerbido Di Mortizza	Emilia-Romagna	Piacenza	PC	3277
IT	29100	Baia Del Re	Emilia-Romagna	Piacenza	PC	3278
IT	29100	Verza	Emilia-Romagna	Piacenza	PC	3279
IT	29100	San Lazzaro Alberoni	Emilia-Romagna	Piacenza	PC	3280
IT	29100	Borgo Trebbia	Emilia-Romagna	Piacenza	PC	3281
IT	29100	Raffaelina	Emilia-Romagna	Piacenza	PC	3282
IT	29121	Piacenza	Emilia-Romagna	Piacenza	PC	3283
IT	29122	Piacenza	Emilia-Romagna	Piacenza	PC	3284
IT	43010	Riana	Emilia-Romagna	Parma	PR	3285
IT	43010	Fontanelle	Emilia-Romagna	Parma	PR	3286
IT	43010	Riana Di Monchio	Emilia-Romagna	Parma	PR	3287
IT	43010	Ponte Taro	Emilia-Romagna	Parma	PR	3288
IT	43010	Bianconese	Emilia-Romagna	Parma	PR	3289
IT	43010	Monchio Delle Corti	Emilia-Romagna	Parma	PR	3290
IT	43010	Ragazzola	Emilia-Romagna	Parma	PR	3291
IT	43010	Fontevivo	Emilia-Romagna	Parma	PR	3292
IT	43010	Rigoso	Emilia-Romagna	Parma	PR	3293
IT	43010	Valditacca	Emilia-Romagna	Parma	PR	3294
IT	43010	Roccabianca	Emilia-Romagna	Parma	PR	3295
IT	43010	Castelguelfo	Emilia-Romagna	Parma	PR	3296
IT	43011	Busseto	Emilia-Romagna	Parma	PR	3297
IT	43011	Roncole Verdi	Emilia-Romagna	Parma	PR	3298
IT	43012	Fontanellato	Emilia-Romagna	Parma	PR	3299
IT	43012	Parola	Emilia-Romagna	Parma	PR	3300
IT	43013	Cozzano	Emilia-Romagna	Parma	PR	3301
IT	43013	Riano	Emilia-Romagna	Parma	PR	3302
IT	43013	Langhirano	Emilia-Romagna	Parma	PR	3303
IT	43013	Torrechiara	Emilia-Romagna	Parma	PR	3304
IT	43013	Pastorello	Emilia-Romagna	Parma	PR	3305
IT	43013	Pilastro	Emilia-Romagna	Parma	PR	3306
IT	43014	Felegara	Emilia-Romagna	Parma	PR	3307
IT	43014	Ramiola	Emilia-Romagna	Parma	PR	3308
IT	43014	Medesano	Emilia-Romagna	Parma	PR	3309
IT	43015	Noceto	Emilia-Romagna	Parma	PR	3310
IT	43015	Costamezzana	Emilia-Romagna	Parma	PR	3311
IT	43015	Cella Di Costamezzana	Emilia-Romagna	Parma	PR	3312
IT	43016	Zibello	Emilia-Romagna	Parma	PR	3313
IT	43016	Polesine Parmense	Emilia-Romagna	Parma	PR	3314
IT	43016	Pieveottoville	Emilia-Romagna	Parma	PR	3315
IT	43017	San Secondo Parmense	Emilia-Romagna	Parma	PR	3316
IT	43018	San Quirico Trecasali	Emilia-Romagna	Parma	PR	3317
IT	43018	Ronco Campo Canneto	Emilia-Romagna	Parma	PR	3318
IT	43018	Sissa	Emilia-Romagna	Parma	PR	3319
IT	43018	Viarolo	Emilia-Romagna	Parma	PR	3320
IT	43018	Coltaro	Emilia-Romagna	Parma	PR	3321
IT	43018	Gramignazzo	Emilia-Romagna	Parma	PR	3322
IT	43018	Trecasali	Emilia-Romagna	Parma	PR	3323
IT	43018	Sissa Trecasali	Emilia-Romagna	Parma	PR	3324
IT	43019	Soragna	Emilia-Romagna	Parma	PR	3325
IT	43021	Ghiare Di Corniglio	Emilia-Romagna	Parma	PR	3326
IT	43021	Beduzzo	Emilia-Romagna	Parma	PR	3327
IT	43021	Bosco	Emilia-Romagna	Parma	PR	3328
IT	43021	Vestola Ghiare	Emilia-Romagna	Parma	PR	3329
IT	43021	Corniglio	Emilia-Romagna	Parma	PR	3330
IT	43021	Bosco Di Corniglio	Emilia-Romagna	Parma	PR	3331
IT	43022	Basilicagoiano	Emilia-Romagna	Parma	PR	3332
IT	43022	Montechiarugolo	Emilia-Romagna	Parma	PR	3333
IT	43022	Monticelli Terme Di Montechiarugolo	Emilia-Romagna	Parma	PR	3334
IT	43022	Basilicanova	Emilia-Romagna	Parma	PR	3335
IT	43022	Monticelli Terme	Emilia-Romagna	Parma	PR	3336
IT	43024	Lupazzano	Emilia-Romagna	Parma	PR	3337
IT	43024	Mozzano	Emilia-Romagna	Parma	PR	3338
IT	43024	Neviano Degli Arduini	Emilia-Romagna	Parma	PR	3339
IT	43024	Mediano	Emilia-Romagna	Parma	PR	3340
IT	43024	Scurano	Emilia-Romagna	Parma	PR	3341
IT	43024	Provazzano	Emilia-Romagna	Parma	PR	3342
IT	43024	Vezzano	Emilia-Romagna	Parma	PR	3343
IT	43024	Sasso Di Neviano	Emilia-Romagna	Parma	PR	3344
IT	43024	Bazzano Parmense	Emilia-Romagna	Parma	PR	3345
IT	43025	Isola	Emilia-Romagna	Parma	PR	3346
IT	43025	Ranzano	Emilia-Romagna	Parma	PR	3347
IT	43025	Selvanizza	Emilia-Romagna	Parma	PR	3348
IT	43025	Palanzano	Emilia-Romagna	Parma	PR	3349
IT	43025	Vairo Superiore	Emilia-Romagna	Parma	PR	3350
IT	43025	Ruzzano	Emilia-Romagna	Parma	PR	3351
IT	43025	Isola Di Palanzano	Emilia-Romagna	Parma	PR	3352
IT	43025	Vairo	Emilia-Romagna	Parma	PR	3353
IT	43028	Carpaneto	Emilia-Romagna	Parma	PR	3354
IT	43028	Musiara Inferiore	Emilia-Romagna	Parma	PR	3355
IT	43028	Tizzano Val Parma	Emilia-Romagna	Parma	PR	3356
IT	43028	Reno	Emilia-Romagna	Parma	PR	3357
IT	43028	Lagrimone	Emilia-Romagna	Parma	PR	3358
IT	43028	Capriglio	Emilia-Romagna	Parma	PR	3359
IT	43028	Capoponte	Emilia-Romagna	Parma	PR	3360
IT	43029	Vignale	Emilia-Romagna	Parma	PR	3361
IT	43029	Mamiano	Emilia-Romagna	Parma	PR	3362
IT	43029	Castione De' Baratti	Emilia-Romagna	Parma	PR	3363
IT	43029	Traversetolo	Emilia-Romagna	Parma	PR	3364
IT	43030	Bore	Emilia-Romagna	Parma	PR	3365
IT	43030	Ravarano	Emilia-Romagna	Parma	PR	3366
IT	43030	Calestano	Emilia-Romagna	Parma	PR	3367
IT	43030	Marzolara	Emilia-Romagna	Parma	PR	3368
IT	43032	Pione	Emilia-Romagna	Parma	PR	3369
IT	43032	Bardi	Emilia-Romagna	Parma	PR	3370
IT	43032	Gravago	Emilia-Romagna	Parma	PR	3371
IT	43032	Santa Giustina	Emilia-Romagna	Parma	PR	3372
IT	43032	Santa Giustina Val Di Lecca	Emilia-Romagna	Parma	PR	3373
IT	43035	San Michele Di Tiorre	Emilia-Romagna	Parma	PR	3374
IT	43035	Felino	Emilia-Romagna	Parma	PR	3375
IT	43035	Sant'Ilario Di Baganza	Emilia-Romagna	Parma	PR	3376
IT	43036	Castione Dei Marchesi	Emilia-Romagna	Parma	PR	3377
IT	43036	Pieve Di Cusignano	Emilia-Romagna	Parma	PR	3378
IT	43036	Fidenza	Emilia-Romagna	Parma	PR	3379
IT	43036	Chiusa Ferranda	Emilia-Romagna	Parma	PR	3380
IT	43036	Cogolonchio	Emilia-Romagna	Parma	PR	3381
IT	43036	Castione Marchesi	Emilia-Romagna	Parma	PR	3382
IT	43037	Santa Maria Del Piano	Emilia-Romagna	Parma	PR	3383
IT	43037	Mulazzano Ponte	Emilia-Romagna	Parma	PR	3384
IT	43037	Lesignano De' Bagni	Emilia-Romagna	Parma	PR	3385
IT	43037	San Michele Cavana	Emilia-Romagna	Parma	PR	3386
IT	43037	Mulazzano	Emilia-Romagna	Parma	PR	3387
IT	43038	Sala Baganza	Emilia-Romagna	Parma	PR	3388
IT	43038	San Vitale	Emilia-Romagna	Parma	PR	3389
IT	43038	Talignano	Emilia-Romagna	Parma	PR	3390
IT	43038	San Vitale Di Baganza	Emilia-Romagna	Parma	PR	3391
IT	43039	Pie' Di Via	Emilia-Romagna	Parma	PR	3392
IT	43039	Scipione	Emilia-Romagna	Parma	PR	3393
IT	43039	Bagni Di Tabiano	Emilia-Romagna	Parma	PR	3394
IT	43039	Congelasio	Emilia-Romagna	Parma	PR	3395
IT	43039	Salsomaggiore Terme	Emilia-Romagna	Parma	PR	3396
IT	43039	Tabiano	Emilia-Romagna	Parma	PR	3397
IT	43039	Bargone	Emilia-Romagna	Parma	PR	3398
IT	43039	Cangelasio	Emilia-Romagna	Parma	PR	3399
IT	43039	Campore	Emilia-Romagna	Parma	PR	3400
IT	43040	Solignano	Emilia-Romagna	Parma	PR	3401
IT	43040	Boschi Di Bardone	Emilia-Romagna	Parma	PR	3402
IT	43040	Corniana	Emilia-Romagna	Parma	PR	3403
IT	43040	Lesignano Palmia	Emilia-Romagna	Parma	PR	3404
IT	43040	Varano De' Melegari	Emilia-Romagna	Parma	PR	3405
IT	43040	Viazzano	Emilia-Romagna	Parma	PR	3406
IT	43040	Cassio	Emilia-Romagna	Parma	PR	3407
IT	43040	Terenzo	Emilia-Romagna	Parma	PR	3408
IT	43040	Casola	Emilia-Romagna	Parma	PR	3409
IT	43040	Vianino	Emilia-Romagna	Parma	PR	3410
IT	43040	Prelerna	Emilia-Romagna	Parma	PR	3411
IT	43040	Specchio	Emilia-Romagna	Parma	PR	3412
IT	43040	Selva Del Bocchetto	Emilia-Romagna	Parma	PR	3413
IT	43041	Ponteceno	Emilia-Romagna	Parma	PR	3414
IT	43041	Drusco	Emilia-Romagna	Parma	PR	3415
IT	43041	Bedonia	Emilia-Romagna	Parma	PR	3416
IT	43041	Masanti Di Sotto	Emilia-Romagna	Parma	PR	3417
IT	43041	Masanti	Emilia-Romagna	Parma	PR	3418
IT	43041	Pontestrambo	Emilia-Romagna	Parma	PR	3419
IT	43041	Molino Dell'Anzola	Emilia-Romagna	Parma	PR	3420
IT	43042	Bergotto	Emilia-Romagna	Parma	PR	3421
IT	43042	Fugazzolo	Emilia-Romagna	Parma	PR	3422
IT	43042	Berceto	Emilia-Romagna	Parma	PR	3423
IT	43042	Casaselvatica	Emilia-Romagna	Parma	PR	3424
IT	43042	Castellonchio	Emilia-Romagna	Parma	PR	3425
IT	43042	Ghiare	Emilia-Romagna	Parma	PR	3426
IT	43042	Ghiare Di Berceto	Emilia-Romagna	Parma	PR	3427
IT	43043	Ostia Di Borgo Val Di Taro	Emilia-Romagna	Parma	PR	3428
IT	43043	Borgo Val Di Taro	Emilia-Romagna	Parma	PR	3429
IT	43043	Ostia Parmense	Emilia-Romagna	Parma	PR	3430
IT	43043	Porcigatone	Emilia-Romagna	Parma	PR	3431
IT	43043	Pontolo	Emilia-Romagna	Parma	PR	3432
IT	43043	Tiedoli	Emilia-Romagna	Parma	PR	3433
IT	43044	Madregolo	Emilia-Romagna	Parma	PR	3434
IT	43044	Collecchio	Emilia-Romagna	Parma	PR	3435
IT	43044	Ozzano Taro	Emilia-Romagna	Parma	PR	3436
IT	43044	Gaiano	Emilia-Romagna	Parma	PR	3437
IT	43044	San Martino Sinzano	Emilia-Romagna	Parma	PR	3438
IT	43045	Piantonia	Emilia-Romagna	Parma	PR	3439
IT	43045	Sivizzano	Emilia-Romagna	Parma	PR	3440
IT	43045	Fornovo Di Taro	Emilia-Romagna	Parma	PR	3441
IT	43045	Ricco'	Emilia-Romagna	Parma	PR	3442
IT	43045	Neviano De' Rossi	Emilia-Romagna	Parma	PR	3443
IT	43047	Mariano	Emilia-Romagna	Parma	PR	3444
IT	43047	Grotta	Emilia-Romagna	Parma	PR	3445
IT	43047	Iggio	Emilia-Romagna	Parma	PR	3446
IT	43047	Pellegrino Parmense	Emilia-Romagna	Parma	PR	3447
IT	43048	Varano Marchesi	Emilia-Romagna	Parma	PR	3448
IT	43048	Varano Dei Marchesi	Emilia-Romagna	Parma	PR	3449
IT	43048	Sant'Andrea Bagni	Emilia-Romagna	Parma	PR	3450
IT	43049	Varsi	Emilia-Romagna	Parma	PR	3451
IT	43049	Pessola	Emilia-Romagna	Parma	PR	3452
IT	43049	Carpadasco	Emilia-Romagna	Parma	PR	3453
IT	43050	San Martino Di Valmozzola	Emilia-Romagna	Parma	PR	3454
IT	43050	Mormorola	Emilia-Romagna	Parma	PR	3455
IT	43050	Valmozzola Stazione	Emilia-Romagna	Parma	PR	3456
IT	43050	Valmozzola	Emilia-Romagna	Parma	PR	3457
IT	43050	Stazione Valmozzola	Emilia-Romagna	Parma	PR	3458
IT	43051	San Quirico	Emilia-Romagna	Parma	PR	3459
IT	43051	Albareto	Emilia-Romagna	Parma	PR	3460
IT	43051	Bertorella	Emilia-Romagna	Parma	PR	3461
IT	43051	San Quirico D'Albareto	Emilia-Romagna	Parma	PR	3462
IT	43052	Colorno	Emilia-Romagna	Parma	PR	3463
IT	43053	Compiano	Emilia-Romagna	Parma	PR	3464
IT	43053	Strela	Emilia-Romagna	Parma	PR	3465
IT	43053	Cereseto	Emilia-Romagna	Parma	PR	3466
IT	43055	Mezzano Inferiore	Emilia-Romagna	Parma	PR	3467
IT	43055	Mezzano Superiore	Emilia-Romagna	Parma	PR	3468
IT	43055	Casale	Emilia-Romagna	Parma	PR	3469
IT	43055	Mezzano Rondani	Emilia-Romagna	Parma	PR	3470
IT	43055	Mezzani	Emilia-Romagna	Parma	PR	3471
IT	43056	Torrile	Emilia-Romagna	Parma	PR	3472
IT	43056	San Polo	Emilia-Romagna	Parma	PR	3473
IT	43058	Chiozzola	Emilia-Romagna	Parma	PR	3474
IT	43058	Sorbolo	Emilia-Romagna	Parma	PR	3475
IT	43059	Tornolo	Emilia-Romagna	Parma	PR	3476
IT	43059	Tarsogno	Emilia-Romagna	Parma	PR	3477
IT	43059	Santa Maria Del Taro	Emilia-Romagna	Parma	PR	3478
IT	43059	Casale Di Tornolo	Emilia-Romagna	Parma	PR	3479
IT	43100	Parma	Emilia-Romagna	Parma	PR	3480
IT	43100	Paradigna	Emilia-Romagna	Parma	PR	3481
IT	43100	Vicofertile	Emilia-Romagna	Parma	PR	3482
IT	43100	Carignano	Emilia-Romagna	Parma	PR	3483
IT	43100	Fontana	Emilia-Romagna	Parma	PR	3484
IT	43100	Porporano	Emilia-Romagna	Parma	PR	3485
IT	43100	San Pancrazio Parmense	Emilia-Romagna	Parma	PR	3486
IT	43100	Gaione	Emilia-Romagna	Parma	PR	3487
IT	43100	Vigatto	Emilia-Romagna	Parma	PR	3488
IT	43100	Panocchia	Emilia-Romagna	Parma	PR	3489
IT	43100	Fontanini	Emilia-Romagna	Parma	PR	3490
IT	43100	Corcagnano	Emilia-Romagna	Parma	PR	3491
IT	43100	San Leonardo	Emilia-Romagna	Parma	PR	3492
IT	43100	Marano	Emilia-Romagna	Parma	PR	3493
IT	43100	Alberi	Emilia-Romagna	Parma	PR	3494
IT	43100	Baganzola	Emilia-Romagna	Parma	PR	3495
IT	43100	Cortile San Martino	Emilia-Romagna	Parma	PR	3496
IT	43100	Botteghino	Emilia-Romagna	Parma	PR	3497
IT	43100	Fraore	Emilia-Romagna	Parma	PR	3498
IT	43100	Vicomero	Emilia-Romagna	Parma	PR	3499
IT	43100	San Lazzaro Parmense	Emilia-Romagna	Parma	PR	3500
IT	43100	San Prospero Parmense	Emilia-Romagna	Parma	PR	3501
IT	43100	Moletolo	Emilia-Romagna	Parma	PR	3502
IT	43122	Parma	Emilia-Romagna	Parma	PR	3503
IT	43126	Parma	Emilia-Romagna	Parma	PR	3504
IT	48010	Casal Borsetti	Emilia-Romagna	Ravenna	RA	3505
IT	48011	Alfonsine	Emilia-Romagna	Ravenna	RA	3506
IT	48012	Bagnacavallo	Emilia-Romagna	Ravenna	RA	3507
IT	48012	Masiera	Emilia-Romagna	Ravenna	RA	3508
IT	48012	Boncellino	Emilia-Romagna	Ravenna	RA	3509
IT	48012	Villanova	Emilia-Romagna	Ravenna	RA	3510
IT	48012	Traversara	Emilia-Romagna	Ravenna	RA	3511
IT	48012	Glorie	Emilia-Romagna	Ravenna	RA	3512
IT	48012	Abbatesse	Emilia-Romagna	Ravenna	RA	3513
IT	48012	Villanova Di Bagnacavallo	Emilia-Romagna	Ravenna	RA	3514
IT	48013	Fognano	Emilia-Romagna	Ravenna	RA	3515
IT	48013	Marzeno	Emilia-Romagna	Ravenna	RA	3516
IT	48013	Brisighella	Emilia-Romagna	Ravenna	RA	3517
IT	48013	San Martino In Gattara	Emilia-Romagna	Ravenna	RA	3518
IT	48013	San Cassiano	Emilia-Romagna	Ravenna	RA	3519
IT	48013	Zattaglia	Emilia-Romagna	Ravenna	RA	3520
IT	48013	Monteromano	Emilia-Romagna	Ravenna	RA	3521
IT	48014	Castel Bolognese	Emilia-Romagna	Ravenna	RA	3522
IT	48015	Madonna Degli Angeli	Emilia-Romagna	Ravenna	RA	3523
IT	48015	Cervia Milano Marittima	Emilia-Romagna	Ravenna	RA	3524
IT	48015	Villa Inferno	Emilia-Romagna	Ravenna	RA	3525
IT	48015	Pisignano	Emilia-Romagna	Ravenna	RA	3526
IT	48015	Savio	Emilia-Romagna	Ravenna	RA	3527
IT	48015	Cervia	Emilia-Romagna	Ravenna	RA	3528
IT	48015	Pinarella	Emilia-Romagna	Ravenna	RA	3529
IT	48015	Cannuzzo	Emilia-Romagna	Ravenna	RA	3530
IT	48015	Castiglione	Emilia-Romagna	Ravenna	RA	3531
IT	48017	San Patrizio	Emilia-Romagna	Ravenna	RA	3532
IT	48017	Lavezzola	Emilia-Romagna	Ravenna	RA	3533
IT	48017	Conselice	Emilia-Romagna	Ravenna	RA	3534
IT	48018	Reda	Emilia-Romagna	Ravenna	RA	3535
IT	48018	Fossolo	Emilia-Romagna	Ravenna	RA	3536
IT	48018	Santa Lucia Delle Spianate	Emilia-Romagna	Ravenna	RA	3537
IT	48018	Errano	Emilia-Romagna	Ravenna	RA	3538
IT	48018	Prada	Emilia-Romagna	Ravenna	RA	3539
IT	48018	Mezzeno	Emilia-Romagna	Ravenna	RA	3540
IT	48018	San Martino	Emilia-Romagna	Ravenna	RA	3541
IT	48018	Granarolo	Emilia-Romagna	Ravenna	RA	3542
IT	48018	Sarna	Emilia-Romagna	Ravenna	RA	3543
IT	48018	Faenza	Emilia-Romagna	Ravenna	RA	3544
IT	48018	Celle	Emilia-Romagna	Ravenna	RA	3545
IT	48018	San Silvestro	Emilia-Romagna	Ravenna	RA	3546
IT	48018	Castel Raniero	Emilia-Romagna	Ravenna	RA	3547
IT	48018	Case San Martino	Emilia-Romagna	Ravenna	RA	3548
IT	48018	Cosina	Emilia-Romagna	Ravenna	RA	3549
IT	48020	Sant'Alberto	Emilia-Romagna	Ravenna	RA	3550
IT	48020	Savarna	Emilia-Romagna	Ravenna	RA	3551
IT	48020	Sant'Agata Sul Santerno	Emilia-Romagna	Ravenna	RA	3552
IT	48022	Belricetto	Emilia-Romagna	Ravenna	RA	3553
IT	48022	San Lorenzo Di Lugo	Emilia-Romagna	Ravenna	RA	3554
IT	48022	San Bernardino	Emilia-Romagna	Ravenna	RA	3555
IT	48022	Passogatto	Emilia-Romagna	Ravenna	RA	3556
IT	48022	Santa Maria In Fabriago	Emilia-Romagna	Ravenna	RA	3557
IT	48022	Villa San Martino	Emilia-Romagna	Ravenna	RA	3558
IT	48022	Voltana	Emilia-Romagna	Ravenna	RA	3559
IT	48022	Giovecca	Emilia-Romagna	Ravenna	RA	3560
IT	48022	Lugo	Emilia-Romagna	Ravenna	RA	3561
IT	48022	San Potito	Emilia-Romagna	Ravenna	RA	3562
IT	48022	Ascensione	Emilia-Romagna	Ravenna	RA	3563
IT	48024	Massa Lombarda	Emilia-Romagna	Ravenna	RA	3564
IT	48024	Villa Serraglio	Emilia-Romagna	Ravenna	RA	3565
IT	48025	Riolo Terme	Emilia-Romagna	Ravenna	RA	3566
IT	48025	Borgo Rivola	Emilia-Romagna	Ravenna	RA	3567
IT	48026	Russi	Emilia-Romagna	Ravenna	RA	3568
IT	48026	San Pancrazio	Emilia-Romagna	Ravenna	RA	3569
IT	48026	Godo	Emilia-Romagna	Ravenna	RA	3570
IT	48027	Solarolo	Emilia-Romagna	Ravenna	RA	3571
IT	48027	Gaiano	Emilia-Romagna	Ravenna	RA	3572
IT	48031	Bagnara Di Romagna	Emilia-Romagna	Ravenna	RA	3573
IT	48032	Casola Valsenio	Emilia-Romagna	Ravenna	RA	3574
IT	48033	Cotignola	Emilia-Romagna	Ravenna	RA	3575
IT	48033	San Severo	Emilia-Romagna	Ravenna	RA	3576
IT	48033	Barbiano	Emilia-Romagna	Ravenna	RA	3577
IT	48034	Fusignano	Emilia-Romagna	Ravenna	RA	3578
IT	48100	San Bartolo	Emilia-Romagna	Ravenna	RA	3579
IT	48100	Mezzano	Emilia-Romagna	Ravenna	RA	3580
IT	48100	Filetto	Emilia-Romagna	Ravenna	RA	3581
IT	48100	Camerlona	Emilia-Romagna	Ravenna	RA	3582
IT	48100	San Romualdo	Emilia-Romagna	Ravenna	RA	3583
IT	48100	Madonna Dell'Albero	Emilia-Romagna	Ravenna	RA	3584
IT	48100	Marina Di Ravenna	Emilia-Romagna	Ravenna	RA	3585
IT	48100	Lido Di Classe	Emilia-Romagna	Ravenna	RA	3586
IT	48100	Romea Vecchia	Emilia-Romagna	Ravenna	RA	3587
IT	48100	Punta Marina	Emilia-Romagna	Ravenna	RA	3588
IT	48100	San Zaccaria	Emilia-Romagna	Ravenna	RA	3589
IT	48100	Gambellara	Emilia-Romagna	Ravenna	RA	3590
IT	48100	Ravenna	Emilia-Romagna	Ravenna	RA	3591
IT	48100	Roncalceci	Emilia-Romagna	Ravenna	RA	3592
IT	48100	Santerno	Emilia-Romagna	Ravenna	RA	3593
IT	48100	Lido Adriano	Emilia-Romagna	Ravenna	RA	3594
IT	48100	Ducenta	Emilia-Romagna	Ravenna	RA	3595
IT	48100	Piangipane	Emilia-Romagna	Ravenna	RA	3596
IT	48100	Classe	Emilia-Romagna	Ravenna	RA	3597
IT	48100	Durazzano	Emilia-Romagna	Ravenna	RA	3598
IT	48100	Porto Fuori	Emilia-Romagna	Ravenna	RA	3599
IT	48100	Coccolia	Emilia-Romagna	Ravenna	RA	3600
IT	48100	Castiglione Di Ravenna	Emilia-Romagna	Ravenna	RA	3601
IT	48100	Ammonite	Emilia-Romagna	Ravenna	RA	3602
IT	48100	Lido Di Savio	Emilia-Romagna	Ravenna	RA	3603
IT	48100	Fosso Ghiaia	Emilia-Romagna	Ravenna	RA	3604
IT	48100	San Pietro In Campiano	Emilia-Romagna	Ravenna	RA	3605
IT	48100	Fornace Zarattini	Emilia-Romagna	Ravenna	RA	3606
IT	48100	Marina Romea	Emilia-Romagna	Ravenna	RA	3607
IT	48100	Campiano	Emilia-Romagna	Ravenna	RA	3608
IT	48100	San Pietro In Vincoli	Emilia-Romagna	Ravenna	RA	3609
IT	48100	San Pietro In Trento	Emilia-Romagna	Ravenna	RA	3610
IT	48100	Porto Corsini	Emilia-Romagna	Ravenna	RA	3611
IT	48100	Santo Stefano	Emilia-Romagna	Ravenna	RA	3612
IT	48100	Carraie	Emilia-Romagna	Ravenna	RA	3613
IT	48100	Ghibullo	Emilia-Romagna	Ravenna	RA	3614
IT	42010	Quara	Emilia-Romagna	Reggio Nell'Emilia	RE	3615
IT	42010	Rio Saliceto	Emilia-Romagna	Reggio Nell'Emilia	RE	3616
IT	42010	Toano	Emilia-Romagna	Reggio Nell'Emilia	RE	3617
IT	42010	Cavola	Emilia-Romagna	Reggio Nell'Emilia	RE	3618
IT	42010	San Cassiano	Emilia-Romagna	Reggio Nell'Emilia	RE	3619
IT	42010	Cerredolo	Emilia-Romagna	Reggio Nell'Emilia	RE	3620
IT	42011	Bagnolo In Piano	Emilia-Romagna	Reggio Nell'Emilia	RE	3621
IT	42012	Campagnola Emilia	Emilia-Romagna	Reggio Nell'Emilia	RE	3622
IT	42013	Casalgrande	Emilia-Romagna	Reggio Nell'Emilia	RE	3623
IT	42013	Veggia	Emilia-Romagna	Reggio Nell'Emilia	RE	3624
IT	42013	Salvaterra	Emilia-Romagna	Reggio Nell'Emilia	RE	3625
IT	42013	Villalunga	Emilia-Romagna	Reggio Nell'Emilia	RE	3626
IT	42014	Castellarano	Emilia-Romagna	Reggio Nell'Emilia	RE	3627
IT	42014	Cadiroggio	Emilia-Romagna	Reggio Nell'Emilia	RE	3628
IT	42014	Roteglia	Emilia-Romagna	Reggio Nell'Emilia	RE	3629
IT	42015	San Martino	Emilia-Romagna	Reggio Nell'Emilia	RE	3630
IT	42015	Prato	Emilia-Romagna	Reggio Nell'Emilia	RE	3631
IT	42015	Budrio	Emilia-Romagna	Reggio Nell'Emilia	RE	3632
IT	42015	Correggio	Emilia-Romagna	Reggio Nell'Emilia	RE	3633
IT	42015	Fosdondo	Emilia-Romagna	Reggio Nell'Emilia	RE	3634
IT	42016	Guastalla	Emilia-Romagna	Reggio Nell'Emilia	RE	3635
IT	42016	San Girolamo	Emilia-Romagna	Reggio Nell'Emilia	RE	3636
IT	42016	Pieve	Emilia-Romagna	Reggio Nell'Emilia	RE	3637
IT	42017	San Giovanni	Emilia-Romagna	Reggio Nell'Emilia	RE	3638
IT	42017	Vezzola	Emilia-Romagna	Reggio Nell'Emilia	RE	3639
IT	42017	Novellara	Emilia-Romagna	Reggio Nell'Emilia	RE	3640
IT	42017	San Bernardino	Emilia-Romagna	Reggio Nell'Emilia	RE	3641
IT	42017	Santa Maria	Emilia-Romagna	Reggio Nell'Emilia	RE	3642
IT	42018	San Martino In Rio	Emilia-Romagna	Reggio Nell'Emilia	RE	3643
IT	42019	Arceto	Emilia-Romagna	Reggio Nell'Emilia	RE	3644
IT	42019	Bosco	Emilia-Romagna	Reggio Nell'Emilia	RE	3645
IT	42019	Iano	Emilia-Romagna	Reggio Nell'Emilia	RE	3646
IT	42019	Pratissolo	Emilia-Romagna	Reggio Nell'Emilia	RE	3647
IT	42019	Fellegara	Emilia-Romagna	Reggio Nell'Emilia	RE	3648
IT	42019	Chiozza	Emilia-Romagna	Reggio Nell'Emilia	RE	3649
IT	42019	Ventoso	Emilia-Romagna	Reggio Nell'Emilia	RE	3650
IT	42019	Ca' De Caroli	Emilia-Romagna	Reggio Nell'Emilia	RE	3651
IT	42019	Rondinara	Emilia-Romagna	Reggio Nell'Emilia	RE	3652
IT	42019	Scandiano	Emilia-Romagna	Reggio Nell'Emilia	RE	3653
IT	42020	San Polo D'Enza	Emilia-Romagna	Reggio Nell'Emilia	RE	3654
IT	42020	Montecavolo	Emilia-Romagna	Reggio Nell'Emilia	RE	3655
IT	42020	Borzano	Emilia-Romagna	Reggio Nell'Emilia	RE	3656
IT	42020	Rosano	Emilia-Romagna	Reggio Nell'Emilia	RE	3657
IT	42020	Vetto	Emilia-Romagna	Reggio Nell'Emilia	RE	3658
IT	42020	Roncolo	Emilia-Romagna	Reggio Nell'Emilia	RE	3659
IT	42020	Puianello	Emilia-Romagna	Reggio Nell'Emilia	RE	3660
IT	42020	Cola	Emilia-Romagna	Reggio Nell'Emilia	RE	3661
IT	42020	Albinea	Emilia-Romagna	Reggio Nell'Emilia	RE	3662
IT	42020	Quattro Castella	Emilia-Romagna	Reggio Nell'Emilia	RE	3663
IT	42021	Barco	Emilia-Romagna	Reggio Nell'Emilia	RE	3664
IT	42021	Bibbiano	Emilia-Romagna	Reggio Nell'Emilia	RE	3665
IT	42022	Boretto	Emilia-Romagna	Reggio Nell'Emilia	RE	3666
IT	42023	Argine	Emilia-Romagna	Reggio Nell'Emilia	RE	3667
IT	42023	Cadelbosco Di Sopra	Emilia-Romagna	Reggio Nell'Emilia	RE	3668
IT	42023	Cadelbosco Di Sotto	Emilia-Romagna	Reggio Nell'Emilia	RE	3669
IT	42024	Meletole	Emilia-Romagna	Reggio Nell'Emilia	RE	3670
IT	42024	Castelnovo Di Sotto	Emilia-Romagna	Reggio Nell'Emilia	RE	3671
IT	42025	Cavriago	Emilia-Romagna	Reggio Nell'Emilia	RE	3672
IT	42026	Ciano D'Enza	Emilia-Romagna	Reggio Nell'Emilia	RE	3673
IT	42026	Canossa	Emilia-Romagna	Reggio Nell'Emilia	RE	3674
IT	42026	Compiano D'Enza	Emilia-Romagna	Reggio Nell'Emilia	RE	3675
IT	42027	Montecchio Emilia	Emilia-Romagna	Reggio Nell'Emilia	RE	3676
IT	42028	Poviglio	Emilia-Romagna	Reggio Nell'Emilia	RE	3677
IT	42030	Villa Minozzo	Emilia-Romagna	Reggio Nell'Emilia	RE	3678
IT	42030	Pecorile	Emilia-Romagna	Reggio Nell'Emilia	RE	3679
IT	42030	Gazzano	Emilia-Romagna	Reggio Nell'Emilia	RE	3680
IT	42030	Civago	Emilia-Romagna	Reggio Nell'Emilia	RE	3681
IT	42030	Montalto	Emilia-Romagna	Reggio Nell'Emilia	RE	3682
IT	42030	Minozzo	Emilia-Romagna	Reggio Nell'Emilia	RE	3683
IT	42030	La Vecchia	Emilia-Romagna	Reggio Nell'Emilia	RE	3684
IT	42030	Sologno	Emilia-Romagna	Reggio Nell'Emilia	RE	3685
IT	42030	Viano	Emilia-Romagna	Reggio Nell'Emilia	RE	3686
IT	42030	San Giovanni Di Querciola	Emilia-Romagna	Reggio Nell'Emilia	RE	3687
IT	42030	Vezzano Sul Crostolo	Emilia-Romagna	Reggio Nell'Emilia	RE	3688
IT	42030	Regnano	Emilia-Romagna	Reggio Nell'Emilia	RE	3689
IT	42030	Asta Nell'Emilia	Emilia-Romagna	Reggio Nell'Emilia	RE	3690
IT	42030	Succiso	Emilia-Romagna	Reggio Nell'Emilia	RE	3691
IT	42031	Baiso	Emilia-Romagna	Reggio Nell'Emilia	RE	3692
IT	42031	Levizzano	Emilia-Romagna	Reggio Nell'Emilia	RE	3693
IT	42031	Casino Levizzano	Emilia-Romagna	Reggio Nell'Emilia	RE	3694
IT	42032	Busana	Emilia-Romagna	Reggio Nell'Emilia	RE	3695
IT	42032	Pieve San Vincenzo	Emilia-Romagna	Reggio Nell'Emilia	RE	3696
IT	42032	Cerreto Alpi	Emilia-Romagna	Reggio Nell'Emilia	RE	3697
IT	42032	Cinquecerri	Emilia-Romagna	Reggio Nell'Emilia	RE	3698
IT	42032	Collagna	Emilia-Romagna	Reggio Nell'Emilia	RE	3699
IT	42032	Cervarezza	Emilia-Romagna	Reggio Nell'Emilia	RE	3700
IT	42032	Ramiseto	Emilia-Romagna	Reggio Nell'Emilia	RE	3701
IT	42032	Ligonchio	Emilia-Romagna	Reggio Nell'Emilia	RE	3702
IT	42032	Succiso Nuovo	Emilia-Romagna	Reggio Nell'Emilia	RE	3703
IT	42032	Castagneto	Emilia-Romagna	Reggio Nell'Emilia	RE	3704
IT	42033	Marola	Emilia-Romagna	Reggio Nell'Emilia	RE	3705
IT	42033	Pantano	Emilia-Romagna	Reggio Nell'Emilia	RE	3706
IT	42033	Carpineti	Emilia-Romagna	Reggio Nell'Emilia	RE	3707
IT	42033	Valestra	Emilia-Romagna	Reggio Nell'Emilia	RE	3708
IT	42033	Savognatica	Emilia-Romagna	Reggio Nell'Emilia	RE	3709
IT	42034	Paullo Di Casina	Emilia-Romagna	Reggio Nell'Emilia	RE	3710
IT	42034	Casina	Emilia-Romagna	Reggio Nell'Emilia	RE	3711
IT	42034	Trinita'	Emilia-Romagna	Reggio Nell'Emilia	RE	3712
IT	42035	Felina	Emilia-Romagna	Reggio Nell'Emilia	RE	3713
IT	42035	Croce	Emilia-Romagna	Reggio Nell'Emilia	RE	3714
IT	42035	Monteduro	Emilia-Romagna	Reggio Nell'Emilia	RE	3715
IT	42035	Vologno	Emilia-Romagna	Reggio Nell'Emilia	RE	3716
IT	42035	Casale	Emilia-Romagna	Reggio Nell'Emilia	RE	3717
IT	42035	Castelnuovo Ne' Monti	Emilia-Romagna	Reggio Nell'Emilia	RE	3718
IT	42035	Gatta	Emilia-Romagna	Reggio Nell'Emilia	RE	3719
IT	42035	Croce Ne' Monti	Emilia-Romagna	Reggio Nell'Emilia	RE	3720
IT	42035	Vologno Di Sotto	Emilia-Romagna	Reggio Nell'Emilia	RE	3721
IT	42035	Villaberza	Emilia-Romagna	Reggio Nell'Emilia	RE	3722
IT	42035	Castelnovo Ne' Monti	Emilia-Romagna	Reggio Nell'Emilia	RE	3723
IT	42040	Campegine	Emilia-Romagna	Reggio Nell'Emilia	RE	3724
IT	42040	Caprara	Emilia-Romagna	Reggio Nell'Emilia	RE	3725
IT	42041	Lentigione	Emilia-Romagna	Reggio Nell'Emilia	RE	3726
IT	42041	Brescello	Emilia-Romagna	Reggio Nell'Emilia	RE	3727
IT	3030	Coldragone	Lazio	Frosinone	FR	3728
IT	42042	Fabbrico	Emilia-Romagna	Reggio Nell'Emilia	RE	3729
IT	42043	Gattatico	Emilia-Romagna	Reggio Nell'Emilia	RE	3730
IT	42043	Taneto	Emilia-Romagna	Reggio Nell'Emilia	RE	3731
IT	42043	Praticello	Emilia-Romagna	Reggio Nell'Emilia	RE	3732
IT	42044	Pieve Saliceto	Emilia-Romagna	Reggio Nell'Emilia	RE	3733
IT	42044	Santa Vittoria Di Gualtieri	Emilia-Romagna	Reggio Nell'Emilia	RE	3734
IT	42044	Gualtieri	Emilia-Romagna	Reggio Nell'Emilia	RE	3735
IT	42044	Santa Vittoria	Emilia-Romagna	Reggio Nell'Emilia	RE	3736
IT	42045	Casoni	Emilia-Romagna	Reggio Nell'Emilia	RE	3737
IT	42045	Codisotto	Emilia-Romagna	Reggio Nell'Emilia	RE	3738
IT	42045	Luzzara	Emilia-Romagna	Reggio Nell'Emilia	RE	3739
IT	42045	Villarotta	Emilia-Romagna	Reggio Nell'Emilia	RE	3740
IT	42046	Reggiolo	Emilia-Romagna	Reggio Nell'Emilia	RE	3741
IT	42046	Brugneto	Emilia-Romagna	Reggio Nell'Emilia	RE	3742
IT	42047	Rolo	Emilia-Romagna	Reggio Nell'Emilia	RE	3743
IT	42048	Rubiera	Emilia-Romagna	Reggio Nell'Emilia	RE	3744
IT	42049	Calerno	Emilia-Romagna	Reggio Nell'Emilia	RE	3745
IT	42049	Sant'Ilario D'Enza	Emilia-Romagna	Reggio Nell'Emilia	RE	3746
IT	42100	San Maurizio	Emilia-Romagna	Reggio Nell'Emilia	RE	3747
IT	42100	Corticella	Emilia-Romagna	Reggio Nell'Emilia	RE	3748
IT	42100	Pieve Modolena	Emilia-Romagna	Reggio Nell'Emilia	RE	3749
IT	42100	Reggio Emilia	Emilia-Romagna	Reggio Nell'Emilia	RE	3750
IT	42100	Rivalta	Emilia-Romagna	Reggio Nell'Emilia	RE	3751
IT	42100	Sesso	Emilia-Romagna	Reggio Nell'Emilia	RE	3752
IT	42100	Gavasseto	Emilia-Romagna	Reggio Nell'Emilia	RE	3753
IT	42100	Castellazzo	Emilia-Romagna	Reggio Nell'Emilia	RE	3754
IT	42100	Fogliano	Emilia-Romagna	Reggio Nell'Emilia	RE	3755
IT	42100	Roncocesi	Emilia-Romagna	Reggio Nell'Emilia	RE	3756
IT	42100	Marmirolo	Emilia-Romagna	Reggio Nell'Emilia	RE	3757
IT	42100	Massenzatico	Emilia-Romagna	Reggio Nell'Emilia	RE	3758
IT	42100	Gaida	Emilia-Romagna	Reggio Nell'Emilia	RE	3759
IT	42100	Cella	Emilia-Romagna	Reggio Nell'Emilia	RE	3760
IT	42100	Masone	Emilia-Romagna	Reggio Nell'Emilia	RE	3761
IT	42100	San Pellegrino	Emilia-Romagna	Reggio Nell'Emilia	RE	3762
IT	42100	Canali	Emilia-Romagna	Reggio Nell'Emilia	RE	3763
IT	42100	Cavazzoli	Emilia-Romagna	Reggio Nell'Emilia	RE	3764
IT	42100	Codemondo	Emilia-Romagna	Reggio Nell'Emilia	RE	3765
IT	42100	Coviolo	Emilia-Romagna	Reggio Nell'Emilia	RE	3766
IT	42100	Bagno	Emilia-Romagna	Reggio Nell'Emilia	RE	3767
IT	42100	Gavassa	Emilia-Romagna	Reggio Nell'Emilia	RE	3768
IT	42100	Quaresimo	Emilia-Romagna	Reggio Nell'Emilia	RE	3769
IT	42100	Cade'	Emilia-Romagna	Reggio Nell'Emilia	RE	3770
IT	42100	Mancasale	Emilia-Romagna	Reggio Nell'Emilia	RE	3771
IT	42100	Ospizio	Emilia-Romagna	Reggio Nell'Emilia	RE	3772
IT	47814	Bellaria	Emilia-Romagna	Rimini	RN	3773
IT	47814	Igea Marina	Emilia-Romagna	Rimini	RN	3774
IT	47814	Bellaria Igea Marina	Emilia-Romagna	Rimini	RN	3775
IT	47822	San Vito	Emilia-Romagna	Rimini	RN	3776
IT	47822	Sant'Ermete	Emilia-Romagna	Rimini	RN	3777
IT	47822	San Martino Dei Mulini	Emilia-Romagna	Rimini	RN	3778
IT	47822	Montalbano Di Santarcangelo Di Romagna	Emilia-Romagna	Rimini	RN	3779
IT	47822	San Michele	Emilia-Romagna	Rimini	RN	3780
IT	47822	Ciola Corniale	Emilia-Romagna	Rimini	RN	3781
IT	47822	Santarcangelo Di Romagna	Emilia-Romagna	Rimini	RN	3782
IT	47822	Santa Giustina Di Santarcangelo	Emilia-Romagna	Rimini	RN	3783
IT	47824	Poggio Berni	Emilia-Romagna	Rimini	RN	3784
IT	47824	Santo Marino	Emilia-Romagna	Rimini	RN	3785
IT	47824	Trebbio	Emilia-Romagna	Rimini	RN	3786
IT	47824	Torriana	Emilia-Romagna	Rimini	RN	3787
IT	47824	Poggio Torriana	Emilia-Romagna	Rimini	RN	3788
IT	47826	Villa Verucchio	Emilia-Romagna	Rimini	RN	3789
IT	47826	Verucchio	Emilia-Romagna	Rimini	RN	3790
IT	47832	San Clemente	Emilia-Romagna	Rimini	RN	3791
IT	47832	Sant'Andrea In Casale	Emilia-Romagna	Rimini	RN	3792
IT	47833	Morciano Di Romagna	Emilia-Romagna	Rimini	RN	3793
IT	47834	Montefiore Conca	Emilia-Romagna	Rimini	RN	3794
IT	47834	Serbadone	Emilia-Romagna	Rimini	RN	3795
IT	47835	Saludecio	Emilia-Romagna	Rimini	RN	3796
IT	47835	Santa Maria Del Monte	Emilia-Romagna	Rimini	RN	3797
IT	47836	Mondaino	Emilia-Romagna	Rimini	RN	3798
IT	47837	Montegridolfo	Emilia-Romagna	Rimini	RN	3799
IT	47838	Riccione	Emilia-Romagna	Rimini	RN	3800
IT	47841	Cattolica	Emilia-Romagna	Rimini	RN	3801
IT	47842	Montalbano	Emilia-Romagna	Rimini	RN	3802
IT	47842	San Giovanni In Marignano	Emilia-Romagna	Rimini	RN	3803
IT	47842	Pianventena	Emilia-Romagna	Rimini	RN	3804
IT	47843	Misano Monte	Emilia-Romagna	Rimini	RN	3805
IT	47843	Villaggio Argentina	Emilia-Romagna	Rimini	RN	3806
IT	47843	Misano Adriatico	Emilia-Romagna	Rimini	RN	3807
IT	47843	Santa Monica	Emilia-Romagna	Rimini	RN	3808
IT	47843	Scacciano	Emilia-Romagna	Rimini	RN	3809
IT	47843	Belvedere	Emilia-Romagna	Rimini	RN	3810
IT	47843	Cella	Emilia-Romagna	Rimini	RN	3811
IT	47853	Coriano	Emilia-Romagna	Rimini	RN	3812
IT	47853	Sant'Andrea In Besanigo	Emilia-Romagna	Rimini	RN	3813
IT	47853	Cerasolo	Emilia-Romagna	Rimini	RN	3814
IT	47853	Ospedaletto	Emilia-Romagna	Rimini	RN	3815
IT	47853	Ospedaletto Di Rimini	Emilia-Romagna	Rimini	RN	3816
IT	47854	Croce	Emilia-Romagna	Rimini	RN	3817
IT	47854	Montescudo	Emilia-Romagna	Rimini	RN	3818
IT	47854	San Savino Di Monte Colombo	Emilia-Romagna	Rimini	RN	3819
IT	47854	San Savino	Emilia-Romagna	Rimini	RN	3820
IT	47854	Trarivi	Emilia-Romagna	Rimini	RN	3821
IT	47854	Monte Colombo	Emilia-Romagna	Rimini	RN	3822
IT	47854	Santa Maria Del Piano	Emilia-Romagna	Rimini	RN	3823
IT	47854	Taverna Di Monte Colombo	Emilia-Romagna	Rimini	RN	3824
IT	47855	Onferno	Emilia-Romagna	Rimini	RN	3825
IT	47855	Gemmano	Emilia-Romagna	Rimini	RN	3826
IT	47861	Casteldelci	Emilia-Romagna	Rimini	RN	3827
IT	47862	Maiolo	Emilia-Romagna	Rimini	RN	3828
IT	47863	Novafeltria	Emilia-Romagna	Rimini	RN	3829
IT	47863	Perticara	Emilia-Romagna	Rimini	RN	3830
IT	47863	Ponte Molino Baffoni	Emilia-Romagna	Rimini	RN	3831
IT	47863	Secchiano Marecchia	Emilia-Romagna	Rimini	RN	3832
IT	47864	Pennabilli	Emilia-Romagna	Rimini	RN	3833
IT	47864	Maciano	Emilia-Romagna	Rimini	RN	3834
IT	47864	Molino Di Bascio	Emilia-Romagna	Rimini	RN	3835
IT	47864	Ponte Messa	Emilia-Romagna	Rimini	RN	3836
IT	47864	Soanne	Emilia-Romagna	Rimini	RN	3837
IT	47865	San Leo	Emilia-Romagna	Rimini	RN	3838
IT	47865	Pietracuta	Emilia-Romagna	Rimini	RN	3839
IT	47865	Montemaggio	Emilia-Romagna	Rimini	RN	3840
IT	47866	Sant'Agata Feltria	Emilia-Romagna	Rimini	RN	3841
IT	47866	San Donato	Emilia-Romagna	Rimini	RN	3842
IT	47867	Talamello	Emilia-Romagna	Rimini	RN	3843
IT	47900	Santa Giustina	Emilia-Romagna	Rimini	RN	3844
IT	47900	Rimini	Emilia-Romagna	Rimini	RN	3845
IT	47900	Corpolo'	Emilia-Romagna	Rimini	RN	3846
IT	47900	San Fortunato	Emilia-Romagna	Rimini	RN	3847
IT	47900	Miramare Di Rimini	Emilia-Romagna	Rimini	RN	3848
IT	47900	Rivabella	Emilia-Romagna	Rimini	RN	3849
IT	47900	Vergiano	Emilia-Romagna	Rimini	RN	3850
IT	47900	Viserbella	Emilia-Romagna	Rimini	RN	3851
IT	47900	Torre Pedrera	Emilia-Romagna	Rimini	RN	3852
IT	47900	San Lorenzo In Correggiano	Emilia-Romagna	Rimini	RN	3853
IT	47900	Gaiofana	Emilia-Romagna	Rimini	RN	3854
IT	47900	Rivazzurra	Emilia-Romagna	Rimini	RN	3855
IT	47900	Bellariva	Emilia-Romagna	Rimini	RN	3856
IT	47900	Viserba	Emilia-Romagna	Rimini	RN	3857
IT	47900	Santa Aquilina	Emilia-Romagna	Rimini	RN	3858
IT	47900	San Giuliano A Mare	Emilia-Romagna	Rimini	RN	3859
IT	47921	Rimini	Emilia-Romagna	Rimini	RN	3860
IT	47922	Rimini	Emilia-Romagna	Rimini	RN	3861
IT	47923	Rimini	Emilia-Romagna	Rimini	RN	3862
IT	47924	Rimini	Emilia-Romagna	Rimini	RN	3863
IT	34070	Venco'	Friuli-Venezia Giulia	Gorizia	GO	3864
IT	34070	Polazzo	Friuli-Venezia Giulia	Gorizia	GO	3865
IT	34070	Savogna D'Isonzo	Friuli-Venezia Giulia	Gorizia	GO	3866
IT	34070	Cassegliano	Friuli-Venezia Giulia	Gorizia	GO	3867
IT	34070	San Floriano Del Collio	Friuli-Venezia Giulia	Gorizia	GO	3868
IT	34070	Jamiano	Friuli-Venezia Giulia	Gorizia	GO	3869
IT	34070	Moraro	Friuli-Venezia Giulia	Gorizia	GO	3870
IT	34070	Lonzano	Friuli-Venezia Giulia	Gorizia	GO	3871
IT	34070	Corona	Friuli-Venezia Giulia	Gorizia	GO	3872
IT	34070	San Michele Del Carso	Friuli-Venezia Giulia	Gorizia	GO	3873
IT	34070	Fogliano Redipuglia	Friuli-Venezia Giulia	Gorizia	GO	3874
IT	34070	San Pier D'Isonzo	Friuli-Venezia Giulia	Gorizia	GO	3875
IT	34070	Mossa	Friuli-Venezia Giulia	Gorizia	GO	3876
IT	34070	Villesse	Friuli-Venezia Giulia	Gorizia	GO	3877
IT	34070	Capriva Del Friuli	Friuli-Venezia Giulia	Gorizia	GO	3878
IT	34070	Turriaco	Friuli-Venezia Giulia	Gorizia	GO	3879
IT	34070	Redipuglia	Friuli-Venezia Giulia	Gorizia	GO	3880
IT	34070	Dolegna Del Collio	Friuli-Venezia Giulia	Gorizia	GO	3881
IT	34070	Doberdo' Del Lago	Friuli-Venezia Giulia	Gorizia	GO	3882
IT	34070	Giasbana	Friuli-Venezia Giulia	Gorizia	GO	3883
IT	34070	Scrio'	Friuli-Venezia Giulia	Gorizia	GO	3884
IT	34070	Mariano Del Friuli	Friuli-Venezia Giulia	Gorizia	GO	3885
IT	34070	Rupa	Friuli-Venezia Giulia	Gorizia	GO	3886
IT	34070	Marcottini	Friuli-Venezia Giulia	Gorizia	GO	3887
IT	34070	Gabria	Friuli-Venezia Giulia	Gorizia	GO	3888
IT	34070	San Lorenzo Isontino	Friuli-Venezia Giulia	Gorizia	GO	3889
IT	34070	Redipuglia Sacrario	Friuli-Venezia Giulia	Gorizia	GO	3890
IT	34070	Mernicco	Friuli-Venezia Giulia	Gorizia	GO	3891
IT	34071	Borgnano	Friuli-Venezia Giulia	Gorizia	GO	3892
IT	34071	Cormons	Friuli-Venezia Giulia	Gorizia	GO	3893
IT	34071	Brazzano	Friuli-Venezia Giulia	Gorizia	GO	3894
IT	34072	Farra D'Isonzo	Friuli-Venezia Giulia	Gorizia	GO	3895
IT	34072	Gradisca D'Isonzo	Friuli-Venezia Giulia	Gorizia	GO	3896
IT	34073	Grado Pineta	Friuli-Venezia Giulia	Gorizia	GO	3897
IT	34073	Grado	Friuli-Venezia Giulia	Gorizia	GO	3898
IT	34073	Fossalon	Friuli-Venezia Giulia	Gorizia	GO	3899
IT	34073	Grado Citta' Giardino	Friuli-Venezia Giulia	Gorizia	GO	3900
IT	34073	Rotta Primero	Friuli-Venezia Giulia	Gorizia	GO	3901
IT	34074	Marina Julia	Friuli-Venezia Giulia	Gorizia	GO	3902
IT	34074	Monfalcone	Friuli-Venezia Giulia	Gorizia	GO	3903
IT	34075	Pieris	Friuli-Venezia Giulia	Gorizia	GO	3904
IT	34075	Isola Morosini	Friuli-Venezia Giulia	Gorizia	GO	3905
IT	34075	San Canzian D'Isonzo	Friuli-Venezia Giulia	Gorizia	GO	3906
IT	34075	Begliano	Friuli-Venezia Giulia	Gorizia	GO	3907
IT	34076	Versa	Friuli-Venezia Giulia	Gorizia	GO	3908
IT	34076	Medea	Friuli-Venezia Giulia	Gorizia	GO	3909
IT	34076	Fratta	Friuli-Venezia Giulia	Gorizia	GO	3910
IT	34076	Romans D'Isonzo	Friuli-Venezia Giulia	Gorizia	GO	3911
IT	34077	Ronchi Dei Legionari	Friuli-Venezia Giulia	Gorizia	GO	3912
IT	34077	Vermegliano	Friuli-Venezia Giulia	Gorizia	GO	3913
IT	34078	Poggio Terzarmata	Friuli-Venezia Giulia	Gorizia	GO	3914
IT	34078	Sagrado	Friuli-Venezia Giulia	Gorizia	GO	3915
IT	34078	San Martino Del Carso	Friuli-Venezia Giulia	Gorizia	GO	3916
IT	34079	Staranzano	Friuli-Venezia Giulia	Gorizia	GO	3917
IT	34079	Bistrigna	Friuli-Venezia Giulia	Gorizia	GO	3918
IT	34170	Oslavia	Friuli-Venezia Giulia	Gorizia	GO	3919
IT	34170	Lucinico	Friuli-Venezia Giulia	Gorizia	GO	3920
IT	34170	Piuma	Friuli-Venezia Giulia	Gorizia	GO	3921
IT	34170	Gorizia	Friuli-Venezia Giulia	Gorizia	GO	3922
IT	34170	Piedimonte Del Calvario	Friuli-Venezia Giulia	Gorizia	GO	3923
IT	33070	Maron	Friuli-Venezia Giulia	Pordenone	PN	3924
IT	33070	Caneva	Friuli-Venezia Giulia	Pordenone	PN	3925
IT	33070	Dardago	Friuli-Venezia Giulia	Pordenone	PN	3926
IT	33070	Tamai	Friuli-Venezia Giulia	Pordenone	PN	3927
IT	33070	Brugnera	Friuli-Venezia Giulia	Pordenone	PN	3928
IT	33070	Stevena'	Friuli-Venezia Giulia	Pordenone	PN	3929
IT	33070	Budoia	Friuli-Venezia Giulia	Pordenone	PN	3930
IT	33070	San Giovanni Di Polcenigo	Friuli-Venezia Giulia	Pordenone	PN	3931
IT	33070	Santa Lucia Di Budoia	Friuli-Venezia Giulia	Pordenone	PN	3932
IT	33070	Sarone	Friuli-Venezia Giulia	Pordenone	PN	3933
IT	33070	Polcenigo	Friuli-Venezia Giulia	Pordenone	PN	3934
IT	33072	San Giovanni Di Casarsa	Friuli-Venezia Giulia	Pordenone	PN	3935
IT	33072	Casarsa Della Delizia	Friuli-Venezia Giulia	Pordenone	PN	3936
IT	33074	Fontanafredda	Friuli-Venezia Giulia	Pordenone	PN	3937
IT	33074	Ceolini	Friuli-Venezia Giulia	Pordenone	PN	3938
IT	33074	Nave	Friuli-Venezia Giulia	Pordenone	PN	3939
IT	33074	Vigonovo	Friuli-Venezia Giulia	Pordenone	PN	3940
IT	33075	Morsano Al Tagliamento	Friuli-Venezia Giulia	Pordenone	PN	3941
IT	33075	Mussons	Friuli-Venezia Giulia	Pordenone	PN	3942
IT	33075	Cordovado	Friuli-Venezia Giulia	Pordenone	PN	3943
IT	33076	Pravisdomini	Friuli-Venezia Giulia	Pordenone	PN	3944
IT	33076	Barco	Friuli-Venezia Giulia	Pordenone	PN	3945
IT	33077	Sacile	Friuli-Venezia Giulia	Pordenone	PN	3946
IT	33077	San Giovanni Di Livenza	Friuli-Venezia Giulia	Pordenone	PN	3947
IT	33077	Cavolano	Friuli-Venezia Giulia	Pordenone	PN	3948
IT	33077	Schiavoi	Friuli-Venezia Giulia	Pordenone	PN	3949
IT	33078	Gleris	Friuli-Venezia Giulia	Pordenone	PN	3950
IT	33078	Savorgnano	Friuli-Venezia Giulia	Pordenone	PN	3951
IT	33078	San Vito Al Tagliamento	Friuli-Venezia Giulia	Pordenone	PN	3952
IT	33079	Casette	Friuli-Venezia Giulia	Pordenone	PN	3953
IT	33079	Ramuscello	Friuli-Venezia Giulia	Pordenone	PN	3954
IT	33079	Sesto Al Reghena	Friuli-Venezia Giulia	Pordenone	PN	3955
IT	33079	Bagnarola	Friuli-Venezia Giulia	Pordenone	PN	3956
IT	33080	Villanova	Friuli-Venezia Giulia	Pordenone	PN	3957
IT	33080	Barcis	Friuli-Venezia Giulia	Pordenone	PN	3958
IT	33080	Orcenico Inferiore	Friuli-Venezia Giulia	Pordenone	PN	3959
IT	33080	San Quirino	Friuli-Venezia Giulia	Pordenone	PN	3960
IT	33080	Castions	Friuli-Venezia Giulia	Pordenone	PN	3961
IT	33080	Poffabro	Friuli-Venezia Giulia	Pordenone	PN	3962
IT	33080	Vajont	Friuli-Venezia Giulia	Pordenone	PN	3963
IT	33080	Sedrano	Friuli-Venezia Giulia	Pordenone	PN	3964
IT	33080	Porcia	Friuli-Venezia Giulia	Pordenone	PN	3965
IT	33080	Frisanco	Friuli-Venezia Giulia	Pordenone	PN	3966
IT	33080	Andreis	Friuli-Venezia Giulia	Pordenone	PN	3967
IT	33080	Claut	Friuli-Venezia Giulia	Pordenone	PN	3968
IT	33080	Cimolais	Friuli-Venezia Giulia	Pordenone	PN	3969
IT	33080	San Foca	Friuli-Venezia Giulia	Pordenone	PN	3970
IT	33080	Zoppola	Friuli-Venezia Giulia	Pordenone	PN	3971
IT	33080	Roveredo In Piano	Friuli-Venezia Giulia	Pordenone	PN	3972
IT	33080	Prata Di Pordenone	Friuli-Venezia Giulia	Pordenone	PN	3973
IT	33080	Cimpello	Friuli-Venezia Giulia	Pordenone	PN	3974
IT	33080	Puia	Friuli-Venezia Giulia	Pordenone	PN	3975
IT	33080	Bannia	Friuli-Venezia Giulia	Pordenone	PN	3976
IT	33080	Erto E Casso	Friuli-Venezia Giulia	Pordenone	PN	3977
IT	33080	Fiume Veneto	Friuli-Venezia Giulia	Pordenone	PN	3978
IT	33080	Roraipiccolo	Friuli-Venezia Giulia	Pordenone	PN	3979
IT	33080	Ghirano	Friuli-Venezia Giulia	Pordenone	PN	3980
IT	33080	Palse	Friuli-Venezia Giulia	Pordenone	PN	3981
IT	33081	Aviano	Friuli-Venezia Giulia	Pordenone	PN	3982
IT	33081	Marsure	Friuli-Venezia Giulia	Pordenone	PN	3983
IT	33081	Castello	Friuli-Venezia Giulia	Pordenone	PN	3984
IT	33081	Giais	Friuli-Venezia Giulia	Pordenone	PN	3985
IT	33081	San Martino Di Campagna	Friuli-Venezia Giulia	Pordenone	PN	3986
IT	33081	Cortina	Friuli-Venezia Giulia	Pordenone	PN	3987
IT	33081	Selva	Friuli-Venezia Giulia	Pordenone	PN	3988
IT	33081	Glera	Friuli-Venezia Giulia	Pordenone	PN	3989
IT	33082	Tiezzo	Friuli-Venezia Giulia	Pordenone	PN	3990
IT	33082	Fagnigola	Friuli-Venezia Giulia	Pordenone	PN	3991
IT	33082	Azzano Decimo	Friuli-Venezia Giulia	Pordenone	PN	3992
IT	33082	Corva	Friuli-Venezia Giulia	Pordenone	PN	3993
IT	33083	Villotta	Friuli-Venezia Giulia	Pordenone	PN	3994
IT	33083	Chions	Friuli-Venezia Giulia	Pordenone	PN	3995
IT	33083	Taiedo	Friuli-Venezia Giulia	Pordenone	PN	3996
IT	33084	Musil	Friuli-Venezia Giulia	Pordenone	PN	3997
IT	33084	Villa D'Arco	Friuli-Venezia Giulia	Pordenone	PN	3998
IT	33084	Cordenons	Friuli-Venezia Giulia	Pordenone	PN	3999
IT	33085	Maniago	Friuli-Venezia Giulia	Pordenone	PN	4000
IT	33085	Campagna	Friuli-Venezia Giulia	Pordenone	PN	4001
IT	33086	Montereale Valcellina	Friuli-Venezia Giulia	Pordenone	PN	4002
IT	33086	San Leonardo Valcellina	Friuli-Venezia Giulia	Pordenone	PN	4003
IT	33086	Malnisio	Friuli-Venezia Giulia	Pordenone	PN	4004
IT	33086	San Leonardo	Friuli-Venezia Giulia	Pordenone	PN	4005
IT	33087	Rivarotta	Friuli-Venezia Giulia	Pordenone	PN	4006
IT	33087	Pasiano	Friuli-Venezia Giulia	Pordenone	PN	4007
IT	33087	Pasiano Di Pordenone	Friuli-Venezia Giulia	Pordenone	PN	4008
IT	33087	Cecchini	Friuli-Venezia Giulia	Pordenone	PN	4009
IT	33087	Visinale	Friuli-Venezia Giulia	Pordenone	PN	4010
IT	33087	Pozzo	Friuli-Venezia Giulia	Pordenone	PN	4011
IT	33090	Clauzetto	Friuli-Venezia Giulia	Pordenone	PN	4012
IT	33090	Casiacco	Friuli-Venezia Giulia	Pordenone	PN	4013
IT	33090	Travesio	Friuli-Venezia Giulia	Pordenone	PN	4014
IT	33090	Colle	Friuli-Venezia Giulia	Pordenone	PN	4015
IT	33090	Anduins	Friuli-Venezia Giulia	Pordenone	PN	4016
IT	33090	Chievolis	Friuli-Venezia Giulia	Pordenone	PN	4017
IT	33090	Usago	Friuli-Venezia Giulia	Pordenone	PN	4018
IT	33090	Sequals	Friuli-Venezia Giulia	Pordenone	PN	4019
IT	33090	Toppo	Friuli-Venezia Giulia	Pordenone	PN	4020
IT	33090	Campone	Friuli-Venezia Giulia	Pordenone	PN	4021
IT	33090	Tramonti Di Sotto	Friuli-Venezia Giulia	Pordenone	PN	4022
IT	33090	Tramonti Di Sopra	Friuli-Venezia Giulia	Pordenone	PN	4023
IT	33090	Lestans	Friuli-Venezia Giulia	Pordenone	PN	4024
IT	33090	Arba	Friuli-Venezia Giulia	Pordenone	PN	4025
IT	33090	Pielungo	Friuli-Venezia Giulia	Pordenone	PN	4026
IT	33090	Vito D'Asio	Friuli-Venezia Giulia	Pordenone	PN	4027
IT	33090	Solimbergo	Friuli-Venezia Giulia	Pordenone	PN	4028
IT	33090	Castelnovo Del Friuli	Friuli-Venezia Giulia	Pordenone	PN	4029
IT	33092	Fanna	Friuli-Venezia Giulia	Pordenone	PN	4030
IT	33092	Meduno	Friuli-Venezia Giulia	Pordenone	PN	4031
IT	33092	Cavasso Nuovo	Friuli-Venezia Giulia	Pordenone	PN	4032
IT	33094	Pinzano Al Tagliamento	Friuli-Venezia Giulia	Pordenone	PN	4033
IT	33094	Valeriano	Friuli-Venezia Giulia	Pordenone	PN	4034
IT	33095	Provesano	Friuli-Venezia Giulia	Pordenone	PN	4035
IT	33095	Domanins	Friuli-Venezia Giulia	Pordenone	PN	4036
IT	33095	San Giorgio Della Richinvelda	Friuli-Venezia Giulia	Pordenone	PN	4037
IT	33095	Rauscedo	Friuli-Venezia Giulia	Pordenone	PN	4038
IT	33097	Tauriano	Friuli-Venezia Giulia	Pordenone	PN	4039
IT	33097	Spilimbergo	Friuli-Venezia Giulia	Pordenone	PN	4040
IT	33097	Barbeano	Friuli-Venezia Giulia	Pordenone	PN	4041
IT	33097	Istrago	Friuli-Venezia Giulia	Pordenone	PN	4042
IT	33097	Vacile	Friuli-Venezia Giulia	Pordenone	PN	4043
IT	33098	San Lorenzo	Friuli-Venezia Giulia	Pordenone	PN	4044
IT	33098	Arzene	Friuli-Venezia Giulia	Pordenone	PN	4045
IT	33098	San Martino Al Tagliamento	Friuli-Venezia Giulia	Pordenone	PN	4046
IT	33098	Valvasone Arzene	Friuli-Venezia Giulia	Pordenone	PN	4047
IT	33098	Valvasone	Friuli-Venezia Giulia	Pordenone	PN	4048
IT	33099	Vivaro	Friuli-Venezia Giulia	Pordenone	PN	4049
IT	33170	Pordenone	Friuli-Venezia Giulia	Pordenone	PN	4050
IT	33170	Vallenoncello	Friuli-Venezia Giulia	Pordenone	PN	4051
IT	33170	Borgo Meduna	Friuli-Venezia Giulia	Pordenone	PN	4052
IT	33170	Comina (La)	Friuli-Venezia Giulia	Pordenone	PN	4053
IT	33170	La Comina	Friuli-Venezia Giulia	Pordenone	PN	4054
IT	34010	Sgonico	Friuli-Venezia Giulia	Trieste	TS	4055
IT	34011	Aurisina	Friuli-Venezia Giulia	Trieste	TS	4056
IT	34011	Visogliano	Friuli-Venezia Giulia	Trieste	TS	4057
IT	34011	Duino	Friuli-Venezia Giulia	Trieste	TS	4058
IT	34011	Sistiana	Friuli-Venezia Giulia	Trieste	TS	4059
IT	34011	San Pelagio	Friuli-Venezia Giulia	Trieste	TS	4060
IT	34011	Duino Aurisina	Friuli-Venezia Giulia	Trieste	TS	4061
IT	34011	Villaggio Del Pescatore	Friuli-Venezia Giulia	Trieste	TS	4062
IT	34012	Basovizza	Friuli-Venezia Giulia	Trieste	TS	4063
IT	34014	Santa Croce Di Trieste	Friuli-Venezia Giulia	Trieste	TS	4064
IT	34014	Grignano	Friuli-Venezia Giulia	Trieste	TS	4065
IT	34014	Santa Croce	Friuli-Venezia Giulia	Trieste	TS	4066
IT	34015	Aquilinia	Friuli-Venezia Giulia	Trieste	TS	4067
IT	34015	Muggia	Friuli-Venezia Giulia	Trieste	TS	4068
IT	34015	San Rocco	Friuli-Venezia Giulia	Trieste	TS	4069
IT	34015	Stramare	Friuli-Venezia Giulia	Trieste	TS	4070
IT	34016	Monrupino	Friuli-Venezia Giulia	Trieste	TS	4071
IT	34017	Prosecco	Friuli-Venezia Giulia	Trieste	TS	4072
IT	34018	Sant'Antonio In Bosco	Friuli-Venezia Giulia	Trieste	TS	4073
IT	34018	Domio	Friuli-Venezia Giulia	Trieste	TS	4074
IT	34018	San Dorligo Della Valle	Friuli-Venezia Giulia	Trieste	TS	4075
IT	34018	Bagnoli Della Rosandra	Friuli-Venezia Giulia	Trieste	TS	4076
IT	34018	San Giuseppe Della Chiusa	Friuli-Venezia Giulia	Trieste	TS	4077
IT	34100	Trieste	Friuli-Venezia Giulia	Trieste	TS	4078
IT	34121	Trieste	Friuli-Venezia Giulia	Trieste	TS	4079
IT	34122	Trieste	Friuli-Venezia Giulia	Trieste	TS	4080
IT	34123	Trieste	Friuli-Venezia Giulia	Trieste	TS	4081
IT	34124	Trieste	Friuli-Venezia Giulia	Trieste	TS	4082
IT	34125	Trieste	Friuli-Venezia Giulia	Trieste	TS	4083
IT	34126	Trieste	Friuli-Venezia Giulia	Trieste	TS	4084
IT	34127	Trieste	Friuli-Venezia Giulia	Trieste	TS	4085
IT	34128	Trieste	Friuli-Venezia Giulia	Trieste	TS	4086
IT	34129	Trieste	Friuli-Venezia Giulia	Trieste	TS	4087
IT	34131	Trieste	Friuli-Venezia Giulia	Trieste	TS	4088
IT	34132	Trieste	Friuli-Venezia Giulia	Trieste	TS	4089
IT	34133	Trieste	Friuli-Venezia Giulia	Trieste	TS	4090
IT	34134	Trieste	Friuli-Venezia Giulia	Trieste	TS	4091
IT	34135	Trieste	Friuli-Venezia Giulia	Trieste	TS	4092
IT	34136	Cedas	Friuli-Venezia Giulia	Trieste	TS	4093
IT	34136	Trieste	Friuli-Venezia Giulia	Trieste	TS	4094
IT	34137	Trieste	Friuli-Venezia Giulia	Trieste	TS	4095
IT	34138	Trieste	Friuli-Venezia Giulia	Trieste	TS	4096
IT	34139	Trieste	Friuli-Venezia Giulia	Trieste	TS	4097
IT	34141	Trieste	Friuli-Venezia Giulia	Trieste	TS	4098
IT	34142	Trieste	Friuli-Venezia Giulia	Trieste	TS	4099
IT	34143	Trieste	Friuli-Venezia Giulia	Trieste	TS	4100
IT	34144	Trieste	Friuli-Venezia Giulia	Trieste	TS	4101
IT	34145	Trieste	Friuli-Venezia Giulia	Trieste	TS	4102
IT	34146	Trieste	Friuli-Venezia Giulia	Trieste	TS	4103
IT	34147	Aquilinia	Friuli-Venezia Giulia	Trieste	TS	4104
IT	34147	Trieste	Friuli-Venezia Giulia	Trieste	TS	4105
IT	34148	Trieste	Friuli-Venezia Giulia	Trieste	TS	4106
IT	34149	Cattinara	Friuli-Venezia Giulia	Trieste	TS	4107
IT	34149	Trieste	Friuli-Venezia Giulia	Trieste	TS	4108
IT	34151	Trieste	Friuli-Venezia Giulia	Trieste	TS	4109
IT	33010	Carvacco	Friuli-Venezia Giulia	Udine	UD	4110
IT	33010	Caporiacco	Friuli-Venezia Giulia	Udine	UD	4111
IT	33010	Vergnacco	Friuli-Venezia Giulia	Udine	UD	4112
IT	3030	Castelliri	Lazio	Frosinone	FR	4113
IT	33010	Montenars	Friuli-Venezia Giulia	Udine	UD	4114
IT	33010	Resia	Friuli-Venezia Giulia	Udine	UD	4115
IT	33010	Ugovizza	Friuli-Venezia Giulia	Udine	UD	4116
IT	33010	Adegliacco	Friuli-Venezia Giulia	Udine	UD	4117
IT	33010	Valbruna	Friuli-Venezia Giulia	Udine	UD	4118
IT	33010	La Carnia	Friuli-Venezia Giulia	Udine	UD	4119
IT	33010	Malborghetto Valbruna	Friuli-Venezia Giulia	Udine	UD	4120
IT	33010	Colugna	Friuli-Venezia Giulia	Udine	UD	4121
IT	33010	Venzone	Friuli-Venezia Giulia	Udine	UD	4122
IT	33010	Osoppo	Friuli-Venezia Giulia	Udine	UD	4123
IT	33010	Bordano	Friuli-Venezia Giulia	Udine	UD	4124
IT	33010	Resiutta	Friuli-Venezia Giulia	Udine	UD	4125
IT	33010	Malborghetto	Friuli-Venezia Giulia	Udine	UD	4126
IT	33010	Vedronza	Friuli-Venezia Giulia	Udine	UD	4127
IT	33010	Cassacco	Friuli-Venezia Giulia	Udine	UD	4128
IT	33010	Trasaghis	Friuli-Venezia Giulia	Udine	UD	4129
IT	33010	Lauzzana	Friuli-Venezia Giulia	Udine	UD	4130
IT	33010	Feletto Umberto	Friuli-Venezia Giulia	Udine	UD	4131
IT	33010	Avasinis	Friuli-Venezia Giulia	Udine	UD	4132
IT	33010	Pagnacco	Friuli-Venezia Giulia	Udine	UD	4133
IT	33010	Dogna	Friuli-Venezia Giulia	Udine	UD	4134
IT	33010	Braulins	Friuli-Venezia Giulia	Udine	UD	4135
IT	33010	Reana Del Roiale	Friuli-Venezia Giulia	Udine	UD	4136
IT	33010	Lusevera	Friuli-Venezia Giulia	Udine	UD	4137
IT	33010	Carnia	Friuli-Venezia Giulia	Udine	UD	4138
IT	33010	Stolvizza	Friuli-Venezia Giulia	Udine	UD	4139
IT	33010	Chiusaforte	Friuli-Venezia Giulia	Udine	UD	4140
IT	33010	Qualso	Friuli-Venezia Giulia	Udine	UD	4141
IT	33010	Cavalicco	Friuli-Venezia Giulia	Udine	UD	4142
IT	33010	Magnano In Riviera	Friuli-Venezia Giulia	Udine	UD	4143
IT	33010	Borgo Zurini	Friuli-Venezia Giulia	Udine	UD	4144
IT	33010	Treppo Grande	Friuli-Venezia Giulia	Udine	UD	4145
IT	33010	Alesso	Friuli-Venezia Giulia	Udine	UD	4146
IT	33010	Mels	Friuli-Venezia Giulia	Udine	UD	4147
IT	33010	Colloredo Di Monte Albano	Friuli-Venezia Giulia	Udine	UD	4148
IT	33010	Peonis	Friuli-Venezia Giulia	Udine	UD	4149
IT	33010	Tavagnacco	Friuli-Venezia Giulia	Udine	UD	4150
IT	33010	Vendoglio	Friuli-Venezia Giulia	Udine	UD	4151
IT	33011	Artegna	Friuli-Venezia Giulia	Udine	UD	4152
IT	33013	Gemona Del Friuli	Friuli-Venezia Giulia	Udine	UD	4153
IT	33013	Ospedaletto Di Gemona	Friuli-Venezia Giulia	Udine	UD	4154
IT	33013	Gemona Piovega	Friuli-Venezia Giulia	Udine	UD	4155
IT	33015	Moggio Udinese	Friuli-Venezia Giulia	Udine	UD	4156
IT	33015	Moggio Di Sopra	Friuli-Venezia Giulia	Udine	UD	4157
IT	33015	Moggio Di Sotto	Friuli-Venezia Giulia	Udine	UD	4158
IT	33016	Pontebba	Friuli-Venezia Giulia	Udine	UD	4159
IT	33017	Tarcento	Friuli-Venezia Giulia	Udine	UD	4160
IT	33017	Collalto	Friuli-Venezia Giulia	Udine	UD	4161
IT	33017	Bulfons	Friuli-Venezia Giulia	Udine	UD	4162
IT	33018	Tarvisio	Friuli-Venezia Giulia	Udine	UD	4163
IT	33018	Cave Del Predil	Friuli-Venezia Giulia	Udine	UD	4164
IT	33018	Camporosso In Valcanale	Friuli-Venezia Giulia	Udine	UD	4165
IT	33018	Fusine In Valromana	Friuli-Venezia Giulia	Udine	UD	4166
IT	33019	Tricesimo	Friuli-Venezia Giulia	Udine	UD	4167
IT	33019	Leonacco	Friuli-Venezia Giulia	Udine	UD	4168
IT	33020	Treppo Carnico	Friuli-Venezia Giulia	Udine	UD	4169
IT	33020	Ravascletto	Friuli-Venezia Giulia	Udine	UD	4170
IT	33020	Mediis	Friuli-Venezia Giulia	Udine	UD	4171
IT	33020	Forni Avoltri	Friuli-Venezia Giulia	Udine	UD	4172
IT	33020	Rigolato	Friuli-Venezia Giulia	Udine	UD	4173
IT	33020	Pieria	Friuli-Venezia Giulia	Udine	UD	4174
IT	33020	Cercivento	Friuli-Venezia Giulia	Udine	UD	4175
IT	33020	Forni Di Sotto	Friuli-Venezia Giulia	Udine	UD	4176
IT	33020	Prato Carnico	Friuli-Venezia Giulia	Udine	UD	4177
IT	33020	Preone	Friuli-Venezia Giulia	Udine	UD	4178
IT	33020	Ligosullo	Friuli-Venezia Giulia	Udine	UD	4179
IT	33020	Pesariis	Friuli-Venezia Giulia	Udine	UD	4180
IT	33020	Sauris	Friuli-Venezia Giulia	Udine	UD	4181
IT	33020	Cavazzo Carnico	Friuli-Venezia Giulia	Udine	UD	4182
IT	33020	Zuglio	Friuli-Venezia Giulia	Udine	UD	4183
IT	33020	Sutrio	Friuli-Venezia Giulia	Udine	UD	4184
IT	33020	Socchieve	Friuli-Venezia Giulia	Udine	UD	4185
IT	33020	Quinis	Friuli-Venezia Giulia	Udine	UD	4186
IT	33020	Amaro	Friuli-Venezia Giulia	Udine	UD	4187
IT	33020	Enemonzo	Friuli-Venezia Giulia	Udine	UD	4188
IT	33020	Verzegnis	Friuli-Venezia Giulia	Udine	UD	4189
IT	33021	Ampezzo	Friuli-Venezia Giulia	Udine	UD	4190
IT	33022	Arta Terme	Friuli-Venezia Giulia	Udine	UD	4191
IT	33022	Piano D'Arta	Friuli-Venezia Giulia	Udine	UD	4192
IT	33023	Comeglians	Friuli-Venezia Giulia	Udine	UD	4193
IT	33024	Forni Di Sopra	Friuli-Venezia Giulia	Udine	UD	4194
IT	33025	Ovaro	Friuli-Venezia Giulia	Udine	UD	4195
IT	33026	Cleulis	Friuli-Venezia Giulia	Udine	UD	4196
IT	33026	Timau	Friuli-Venezia Giulia	Udine	UD	4197
IT	33026	Paluzza	Friuli-Venezia Giulia	Udine	UD	4198
IT	33027	Salino	Friuli-Venezia Giulia	Udine	UD	4199
IT	33027	Dierico	Friuli-Venezia Giulia	Udine	UD	4200
IT	33027	Paularo	Friuli-Venezia Giulia	Udine	UD	4201
IT	33028	Terzo Di Tolmezzo	Friuli-Venezia Giulia	Udine	UD	4202
IT	33028	Imponzo	Friuli-Venezia Giulia	Udine	UD	4203
IT	33028	Caneva Di Tolmezzo	Friuli-Venezia Giulia	Udine	UD	4204
IT	33028	Illegio	Friuli-Venezia Giulia	Udine	UD	4205
IT	33028	Cadunea	Friuli-Venezia Giulia	Udine	UD	4206
IT	33028	Tolmezzo	Friuli-Venezia Giulia	Udine	UD	4207
IT	33028	Caneva	Friuli-Venezia Giulia	Udine	UD	4208
IT	33029	Chiassis	Friuli-Venezia Giulia	Udine	UD	4209
IT	33029	Villa Santina	Friuli-Venezia Giulia	Udine	UD	4210
IT	33029	Raveo	Friuli-Venezia Giulia	Udine	UD	4211
IT	33029	Trava	Friuli-Venezia Giulia	Udine	UD	4212
IT	33029	Invillino	Friuli-Venezia Giulia	Udine	UD	4213
IT	33029	Lauco	Friuli-Venezia Giulia	Udine	UD	4214
IT	33030	Moruzzo	Friuli-Venezia Giulia	Udine	UD	4215
IT	33030	San Vito Di Fagagna	Friuli-Venezia Giulia	Udine	UD	4216
IT	33030	Flumignano	Friuli-Venezia Giulia	Udine	UD	4217
IT	33030	Roveredo	Friuli-Venezia Giulia	Udine	UD	4218
IT	33030	Flagogna	Friuli-Venezia Giulia	Udine	UD	4219
IT	33030	Cisterna	Friuli-Venezia Giulia	Udine	UD	4220
IT	33030	Cisterna Del Friuli	Friuli-Venezia Giulia	Udine	UD	4221
IT	33030	Avilla	Friuli-Venezia Giulia	Udine	UD	4222
IT	33030	Rive D'Arcano	Friuli-Venezia Giulia	Udine	UD	4223
IT	33030	Basaldella	Friuli-Venezia Giulia	Udine	UD	4224
IT	33030	Santo Stefano Di Buja	Friuli-Venezia Giulia	Udine	UD	4225
IT	33030	Flambro	Friuli-Venezia Giulia	Udine	UD	4226
IT	33030	Talmassons	Friuli-Venezia Giulia	Udine	UD	4227
IT	33030	Buja	Friuli-Venezia Giulia	Udine	UD	4228
IT	33030	Muris Di Ragogna	Friuli-Venezia Giulia	Udine	UD	4229
IT	33030	Muris	Friuli-Venezia Giulia	Udine	UD	4230
IT	33030	Santa Margherita	Friuli-Venezia Giulia	Udine	UD	4231
IT	33030	Camino Al Tagliamento	Friuli-Venezia Giulia	Udine	UD	4232
IT	33030	Vidulis	Friuli-Venezia Giulia	Udine	UD	4233
IT	33030	San Tomaso	Friuli-Venezia Giulia	Udine	UD	4234
IT	33030	Dignano	Friuli-Venezia Giulia	Udine	UD	4235
IT	33030	Cornino	Friuli-Venezia Giulia	Udine	UD	4236
IT	33030	Rodeano	Friuli-Venezia Giulia	Udine	UD	4237
IT	33030	Carpacco	Friuli-Venezia Giulia	Udine	UD	4238
IT	33030	San Pietro	Friuli-Venezia Giulia	Udine	UD	4239
IT	33030	Urbignacco	Friuli-Venezia Giulia	Udine	UD	4240
IT	33030	Coseano	Friuli-Venezia Giulia	Udine	UD	4241
IT	33030	Brazzacco	Friuli-Venezia Giulia	Udine	UD	4242
IT	33030	Rodeano Basso	Friuli-Venezia Giulia	Udine	UD	4243
IT	33030	Campoformido	Friuli-Venezia Giulia	Udine	UD	4244
IT	33030	Majano	Friuli-Venezia Giulia	Udine	UD	4245
IT	33030	Madonna Di Buja	Friuli-Venezia Giulia	Udine	UD	4246
IT	33030	Varmo	Friuli-Venezia Giulia	Udine	UD	4247
IT	33030	Forgaria Nel Friuli	Friuli-Venezia Giulia	Udine	UD	4248
IT	33030	Silvella	Friuli-Venezia Giulia	Udine	UD	4249
IT	33030	Ragogna	Friuli-Venezia Giulia	Udine	UD	4250
IT	33030	Romans Di Varmo	Friuli-Venezia Giulia	Udine	UD	4251
IT	33030	Flaibano	Friuli-Venezia Giulia	Udine	UD	4252
IT	33030	San Giacomo	Friuli-Venezia Giulia	Udine	UD	4253
IT	33030	Romans	Friuli-Venezia Giulia	Udine	UD	4254
IT	33030	Bressa	Friuli-Venezia Giulia	Udine	UD	4255
IT	33030	Canussio	Friuli-Venezia Giulia	Udine	UD	4256
IT	33031	Basagliapenta	Friuli-Venezia Giulia	Udine	UD	4257
IT	33031	Vissandone	Friuli-Venezia Giulia	Udine	UD	4258
IT	33031	Villaorba	Friuli-Venezia Giulia	Udine	UD	4259
IT	33031	Variano	Friuli-Venezia Giulia	Udine	UD	4260
IT	33031	Blessano	Friuli-Venezia Giulia	Udine	UD	4261
IT	33031	Basiliano	Friuli-Venezia Giulia	Udine	UD	4262
IT	33031	Orgnano	Friuli-Venezia Giulia	Udine	UD	4263
IT	33032	Pozzecco	Friuli-Venezia Giulia	Udine	UD	4264
IT	33032	Bertiolo	Friuli-Venezia Giulia	Udine	UD	4265
IT	33033	Rivolto	Friuli-Venezia Giulia	Udine	UD	4266
IT	33033	Biauzzo	Friuli-Venezia Giulia	Udine	UD	4267
IT	33033	Lonca	Friuli-Venezia Giulia	Udine	UD	4268
IT	33033	Codroipo	Friuli-Venezia Giulia	Udine	UD	4269
IT	33033	Beano	Friuli-Venezia Giulia	Udine	UD	4270
IT	33033	Goricizza E Pozzo	Friuli-Venezia Giulia	Udine	UD	4271
IT	33034	Ciconicco	Friuli-Venezia Giulia	Udine	UD	4272
IT	33034	Madrisio	Friuli-Venezia Giulia	Udine	UD	4273
IT	33034	Fagagna	Friuli-Venezia Giulia	Udine	UD	4274
IT	33035	Nogaredo Di Prato	Friuli-Venezia Giulia	Udine	UD	4275
IT	33035	Martignacco	Friuli-Venezia Giulia	Udine	UD	4276
IT	33035	Torreano Di Martignacco	Friuli-Venezia Giulia	Udine	UD	4277
IT	33036	San Marco	Friuli-Venezia Giulia	Udine	UD	4278
IT	33036	Plasencis	Friuli-Venezia Giulia	Udine	UD	4279
IT	33036	Tomba	Friuli-Venezia Giulia	Udine	UD	4280
IT	33036	Pantianicco	Friuli-Venezia Giulia	Udine	UD	4281
IT	33036	Mereto Di Tomba	Friuli-Venezia Giulia	Udine	UD	4282
IT	33037	Pasian Di Prato	Friuli-Venezia Giulia	Udine	UD	4283
IT	33037	Passons	Friuli-Venezia Giulia	Udine	UD	4284
IT	33037	Colloredo Di Prato	Friuli-Venezia Giulia	Udine	UD	4285
IT	33038	Villanova Di San Daniele	Friuli-Venezia Giulia	Udine	UD	4286
IT	33038	San Daniele Del Friuli	Friuli-Venezia Giulia	Udine	UD	4287
IT	33038	Villanova	Friuli-Venezia Giulia	Udine	UD	4288
IT	33039	Turrida	Friuli-Venezia Giulia	Udine	UD	4289
IT	33039	Gradisca Di Sedegliano	Friuli-Venezia Giulia	Udine	UD	4290
IT	33039	Sedegliano	Friuli-Venezia Giulia	Udine	UD	4291
IT	33039	San Lorenzo	Friuli-Venezia Giulia	Udine	UD	4292
IT	33039	Coderno	Friuli-Venezia Giulia	Udine	UD	4293
IT	33040	Prepotto	Friuli-Venezia Giulia	Udine	UD	4294
IT	33040	Faedis	Friuli-Venezia Giulia	Udine	UD	4295
IT	33040	Magredis	Friuli-Venezia Giulia	Udine	UD	4296
IT	33040	Taipana	Friuli-Venezia Giulia	Udine	UD	4297
IT	33040	Torreano	Friuli-Venezia Giulia	Udine	UD	4298
IT	33040	Moimacco	Friuli-Venezia Giulia	Udine	UD	4299
IT	33040	Cavenzano	Friuli-Venezia Giulia	Udine	UD	4300
IT	33040	Primulacco	Friuli-Venezia Giulia	Udine	UD	4301
IT	33040	Racchiuso	Friuli-Venezia Giulia	Udine	UD	4302
IT	33040	Campolongo Al Torre	Friuli-Venezia Giulia	Udine	UD	4303
IT	33040	Premariacco	Friuli-Venezia Giulia	Udine	UD	4304
IT	33040	Ipplis	Friuli-Venezia Giulia	Udine	UD	4305
IT	33040	Savorgnano Del Torre	Friuli-Venezia Giulia	Udine	UD	4306
IT	33040	Drenchia	Friuli-Venezia Giulia	Udine	UD	4307
IT	33040	Savogna	Friuli-Venezia Giulia	Udine	UD	4308
IT	33040	San Leonardo	Friuli-Venezia Giulia	Udine	UD	4309
IT	33040	Castelmonte	Friuli-Venezia Giulia	Udine	UD	4310
IT	33040	Orsaria	Friuli-Venezia Giulia	Udine	UD	4311
IT	33040	Visco	Friuli-Venezia Giulia	Udine	UD	4312
IT	33040	Corno Di Rosazzo	Friuli-Venezia Giulia	Udine	UD	4313
IT	33040	Campeglio	Friuli-Venezia Giulia	Udine	UD	4314
IT	33040	Povoletto	Friuli-Venezia Giulia	Udine	UD	4315
IT	33040	Attimis	Friuli-Venezia Giulia	Udine	UD	4316
IT	33040	Stregna	Friuli-Venezia Giulia	Udine	UD	4317
IT	33040	Tapogliano	Friuli-Venezia Giulia	Udine	UD	4318
IT	33040	Grions	Friuli-Venezia Giulia	Udine	UD	4319
IT	33040	Clodig	Friuli-Venezia Giulia	Udine	UD	4320
IT	33040	Ravosa	Friuli-Venezia Giulia	Udine	UD	4321
IT	33040	Pradamano	Friuli-Venezia Giulia	Udine	UD	4322
IT	33040	Grimacco	Friuli-Venezia Giulia	Udine	UD	4323
IT	33040	Podresca	Friuli-Venezia Giulia	Udine	UD	4324
IT	33040	Paciug	Friuli-Venezia Giulia	Udine	UD	4325
IT	33041	Aiello Del Friuli	Friuli-Venezia Giulia	Udine	UD	4326
IT	33041	Joannis	Friuli-Venezia Giulia	Udine	UD	4327
IT	33042	Buttrio	Friuli-Venezia Giulia	Udine	UD	4328
IT	33043	Purgessimo	Friuli-Venezia Giulia	Udine	UD	4329
IT	33043	Cividale Del Friuli	Friuli-Venezia Giulia	Udine	UD	4330
IT	33043	Sanguarzo	Friuli-Venezia Giulia	Udine	UD	4331
IT	33044	Manzano	Friuli-Venezia Giulia	Udine	UD	4332
IT	33045	Nimis	Friuli-Venezia Giulia	Udine	UD	4333
IT	33046	Pulfero	Friuli-Venezia Giulia	Udine	UD	4334
IT	33047	Cerneglons	Friuli-Venezia Giulia	Udine	UD	4335
IT	33047	Orzano	Friuli-Venezia Giulia	Udine	UD	4336
IT	33047	Ziracco	Friuli-Venezia Giulia	Udine	UD	4337
IT	33047	Remanzacco	Friuli-Venezia Giulia	Udine	UD	4338
IT	33048	Dolegnano	Friuli-Venezia Giulia	Udine	UD	4339
IT	33048	Chiopris	Friuli-Venezia Giulia	Udine	UD	4340
IT	33048	San Giovanni Al Natisone	Friuli-Venezia Giulia	Udine	UD	4341
IT	33048	Medeuzza	Friuli-Venezia Giulia	Udine	UD	4342
IT	33048	Chiopris Viscone	Friuli-Venezia Giulia	Udine	UD	4343
IT	33048	Villanova Dello Iudrio	Friuli-Venezia Giulia	Udine	UD	4344
IT	33049	San Pietro Al Natisone	Friuli-Venezia Giulia	Udine	UD	4345
IT	33050	Bicinicco	Friuli-Venezia Giulia	Udine	UD	4346
IT	33050	Castello	Friuli-Venezia Giulia	Udine	UD	4347
IT	33050	Papariano	Friuli-Venezia Giulia	Udine	UD	4348
IT	33050	Pocenia	Friuli-Venezia Giulia	Udine	UD	4349
IT	33050	Porpetto	Friuli-Venezia Giulia	Udine	UD	4350
IT	33050	Malisana	Friuli-Venezia Giulia	Udine	UD	4351
IT	33050	Ontagnano	Friuli-Venezia Giulia	Udine	UD	4352
IT	33050	Castions Delle Mura	Friuli-Venezia Giulia	Udine	UD	4353
IT	33050	Castions Di Strada	Friuli-Venezia Giulia	Udine	UD	4354
IT	33050	Sammardenchia	Friuli-Venezia Giulia	Udine	UD	4355
IT	33050	Ronchis	Friuli-Venezia Giulia	Udine	UD	4356
IT	33050	Santa Maria La Longa	Friuli-Venezia Giulia	Udine	UD	4357
IT	33050	Carlino	Friuli-Venezia Giulia	Udine	UD	4358
IT	33050	Mereto Di Capitolo	Friuli-Venezia Giulia	Udine	UD	4359
IT	33050	Marano Lagunare	Friuli-Venezia Giulia	Udine	UD	4360
IT	33050	Terzo D'Aquileia	Friuli-Venezia Giulia	Udine	UD	4361
IT	33050	Torsa	Friuli-Venezia Giulia	Udine	UD	4362
IT	33050	Percoto	Friuli-Venezia Giulia	Udine	UD	4363
IT	33050	Torsa Di Pocenia	Friuli-Venezia Giulia	Udine	UD	4364
IT	33050	Torviscosa	Friuli-Venezia Giulia	Udine	UD	4365
IT	33050	Pozzuolo Del Friuli	Friuli-Venezia Giulia	Udine	UD	4366
IT	33050	Risano	Friuli-Venezia Giulia	Udine	UD	4367
IT	33050	Cargnacco	Friuli-Venezia Giulia	Udine	UD	4368
IT	33050	Bagnaria Arsa	Friuli-Venezia Giulia	Udine	UD	4369
IT	33050	Lestizza	Friuli-Venezia Giulia	Udine	UD	4370
IT	33050	Carpeneto	Friuli-Venezia Giulia	Udine	UD	4371
IT	33050	Perteole	Friuli-Venezia Giulia	Udine	UD	4372
IT	33050	Pavia Di Udine	Friuli-Venezia Giulia	Udine	UD	4373
IT	33050	Sevegliano	Friuli-Venezia Giulia	Udine	UD	4374
IT	33050	Terenzano	Friuli-Venezia Giulia	Udine	UD	4375
IT	33050	Lumignacco	Friuli-Venezia Giulia	Udine	UD	4376
IT	33050	Trivignano Udinese	Friuli-Venezia Giulia	Udine	UD	4377
IT	33050	Tissano	Friuli-Venezia Giulia	Udine	UD	4378
IT	33050	Sclaunicco	Friuli-Venezia Giulia	Udine	UD	4379
IT	33050	Precenicco	Friuli-Venezia Giulia	Udine	UD	4380
IT	33050	San Vito Al Torre	Friuli-Venezia Giulia	Udine	UD	4381
IT	33050	Casale Della Madonna	Friuli-Venezia Giulia	Udine	UD	4382
IT	33050	Felettis	Friuli-Venezia Giulia	Udine	UD	4383
IT	33050	Zugliano	Friuli-Venezia Giulia	Udine	UD	4384
IT	33050	Gonars	Friuli-Venezia Giulia	Udine	UD	4385
IT	33050	Lauzacco	Friuli-Venezia Giulia	Udine	UD	4386
IT	33050	Galleriano	Friuli-Venezia Giulia	Udine	UD	4387
IT	33050	San Valentino	Friuli-Venezia Giulia	Udine	UD	4388
IT	33050	Lavariano	Friuli-Venezia Giulia	Udine	UD	4389
IT	33050	Nespoledo	Friuli-Venezia Giulia	Udine	UD	4390
IT	33050	Santa Maria	Friuli-Venezia Giulia	Udine	UD	4391
IT	33050	Chiasellis	Friuli-Venezia Giulia	Udine	UD	4392
IT	33050	Ruda	Friuli-Venezia Giulia	Udine	UD	4393
IT	33050	Clauiano	Friuli-Venezia Giulia	Udine	UD	4394
IT	33050	Fiumicello	Friuli-Venezia Giulia	Udine	UD	4395
IT	33050	Mortegliano	Friuli-Venezia Giulia	Udine	UD	4396
IT	33051	Belvedere	Friuli-Venezia Giulia	Udine	UD	4397
IT	33051	Aquileia	Friuli-Venezia Giulia	Udine	UD	4398
IT	33051	Belvedere Di Aquileia	Friuli-Venezia Giulia	Udine	UD	4399
IT	33052	Strassoldo	Friuli-Venezia Giulia	Udine	UD	4400
IT	33052	Cervignano Del Friuli	Friuli-Venezia Giulia	Udine	UD	4401
IT	33053	Latisana	Friuli-Venezia Giulia	Udine	UD	4402
IT	33053	Gorgo	Friuli-Venezia Giulia	Udine	UD	4403
IT	33053	Pertegada	Friuli-Venezia Giulia	Udine	UD	4404
IT	33054	Lignano Pineta	Friuli-Venezia Giulia	Udine	UD	4405
IT	33054	Lignano Sabbiadoro	Friuli-Venezia Giulia	Udine	UD	4406
IT	33055	Muzzana Del Turgnano	Friuli-Venezia Giulia	Udine	UD	4407
IT	33056	Palazzolo Dello Stella	Friuli-Venezia Giulia	Udine	UD	4408
IT	33057	Ialmicco	Friuli-Venezia Giulia	Udine	UD	4409
IT	33057	Palmanova	Friuli-Venezia Giulia	Udine	UD	4410
IT	33057	Sottoselva	Friuli-Venezia Giulia	Udine	UD	4411
IT	33057	Jalmicco	Friuli-Venezia Giulia	Udine	UD	4412
IT	33058	San Giorgio Di Nogaro	Friuli-Venezia Giulia	Udine	UD	4413
IT	33059	Villa Vicentina	Friuli-Venezia Giulia	Udine	UD	4414
IT	33061	Teor	Friuli-Venezia Giulia	Udine	UD	4415
IT	33061	Rivignano	Friuli-Venezia Giulia	Udine	UD	4416
IT	33061	Rivarotta	Friuli-Venezia Giulia	Udine	UD	4417
IT	33061	Rivignano Teor	Friuli-Venezia Giulia	Udine	UD	4418
IT	33100	Godia	Friuli-Venezia Giulia	Udine	UD	4419
IT	33100	Laipacco	Friuli-Venezia Giulia	Udine	UD	4420
IT	33100	Udine	Friuli-Venezia Giulia	Udine	UD	4421
IT	33100	Cussignacco	Friuli-Venezia Giulia	Udine	UD	4422
IT	33100	Gervasutta	Friuli-Venezia Giulia	Udine	UD	4423
IT	33100	Baldasseria	Friuli-Venezia Giulia	Udine	UD	4424
IT	3010	Acuto	Lazio	Frosinone	FR	4425
IT	3010	Trevi Nel Lazio	Lazio	Frosinone	FR	4426
IT	3010	La Forma	Lazio	Frosinone	FR	4427
IT	3010	Collepardo	Lazio	Frosinone	FR	4428
IT	3010	Pitocco	Lazio	Frosinone	FR	4429
IT	3010	Torre Cajetani	Lazio	Frosinone	FR	4430
IT	3010	San Giovanni	Lazio	Frosinone	FR	4431
IT	3010	Quattro Strade	Lazio	Frosinone	FR	4432
IT	3010	Patoni	Lazio	Frosinone	FR	4433
IT	3010	Patrica	Lazio	Frosinone	FR	4434
IT	3010	Fumone	Lazio	Frosinone	FR	4435
IT	3010	Filettino	Lazio	Frosinone	FR	4436
IT	3010	Sgurgola	Lazio	Frosinone	FR	4437
IT	3010	Trivigliano	Lazio	Frosinone	FR	4438
IT	3010	Vico Nel Lazio	Lazio	Frosinone	FR	4439
IT	3010	Certosa Di Trisulti	Lazio	Frosinone	FR	4440
IT	3010	Piglio	Lazio	Frosinone	FR	4441
IT	3010	Serrone	Lazio	Frosinone	FR	4442
IT	3010	Madonna Delle Grazie	Lazio	Frosinone	FR	4443
IT	3011	Monte San Marino	Lazio	Frosinone	FR	4444
IT	3011	Alatri	Lazio	Frosinone	FR	4445
IT	3011	Tecchiena	Lazio	Frosinone	FR	4446
IT	3011	Collelavena	Lazio	Frosinone	FR	4447
IT	3012	Osteria Della Fontana	Lazio	Frosinone	FR	4448
IT	3012	Anagni	Lazio	Frosinone	FR	4449
IT	3013	Ferentino Stazione	Lazio	Frosinone	FR	4450
IT	3013	Porciano	Lazio	Frosinone	FR	4451
IT	3013	Ferentino	Lazio	Frosinone	FR	4452
IT	3013	Tofe	Lazio	Frosinone	FR	4453
IT	3014	Fiuggi	Lazio	Frosinone	FR	4454
IT	3014	Fiuggi Fonte	Lazio	Frosinone	FR	4455
IT	3016	Campocatino	Lazio	Frosinone	FR	4456
IT	3016	Guarcino	Lazio	Frosinone	FR	4457
IT	3017	Cerquotti Madonna Del Piano	Lazio	Frosinone	FR	4458
IT	3017	Morolo	Lazio	Frosinone	FR	4459
IT	3018	Paliano	Lazio	Frosinone	FR	4460
IT	3019	Supino	Lazio	Frosinone	FR	4461
IT	3020	Villa Santo Stefano	Lazio	Frosinone	FR	4462
IT	3020	San Sosio	Lazio	Frosinone	FR	4463
IT	3020	Falvaterra	Lazio	Frosinone	FR	4464
IT	3020	Vallecorsa	Lazio	Frosinone	FR	4465
IT	3020	Torrice	Lazio	Frosinone	FR	4466
IT	3020	Castro Dei Volsci	Lazio	Frosinone	FR	4467
IT	3020	Giuliano Di Roma	Lazio	Frosinone	FR	4468
IT	3020	Pastena	Lazio	Frosinone	FR	4469
IT	3020	Strangolagalli	Lazio	Frosinone	FR	4470
IT	3020	Arnara	Lazio	Frosinone	FR	4471
IT	3020	Pico	Lazio	Frosinone	FR	4472
IT	3020	Madonna Del Piano	Lazio	Frosinone	FR	4473
IT	3021	Amaseno	Lazio	Frosinone	FR	4474
IT	3022	Brecciaro	Lazio	Frosinone	FR	4475
IT	3022	Boville Ernica	Lazio	Frosinone	FR	4476
IT	3022	Scrima	Lazio	Frosinone	FR	4477
IT	3022	Antica Colle Piscioso	Lazio	Frosinone	FR	4478
IT	3022	Rotabile	Lazio	Frosinone	FR	4479
IT	3022	Mozzano Torretta	Lazio	Frosinone	FR	4480
IT	3022	Casavitola	Lazio	Frosinone	FR	4481
IT	3022	Colle Campano	Lazio	Frosinone	FR	4482
IT	3023	Ceccano	Lazio	Frosinone	FR	4483
IT	3024	Ceprano	Lazio	Frosinone	FR	4484
IT	3025	Monte San Giovanni Campano	Lazio	Frosinone	FR	4485
IT	3025	Porrino	Lazio	Frosinone	FR	4486
IT	3025	Colli	Lazio	Frosinone	FR	4487
IT	3025	Chiaiamari	Lazio	Frosinone	FR	4488
IT	3025	Anitrella	Lazio	Frosinone	FR	4489
IT	3026	Pofi	Lazio	Frosinone	FR	4490
IT	3027	Ripi	Lazio	Frosinone	FR	4491
IT	3028	San Giovanni Incarico	Lazio	Frosinone	FR	4492
IT	3029	Case Campoli	Lazio	Frosinone	FR	4493
IT	3029	Veroli	Lazio	Frosinone	FR	4494
IT	3029	Santa Francesca	Lazio	Frosinone	FR	4495
IT	3029	Castelmassimo	Lazio	Frosinone	FR	4496
IT	3029	Cotropagno	Lazio	Frosinone	FR	4497
IT	3029	Giglio	Lazio	Frosinone	FR	4498
IT	3029	Colleberardi	Lazio	Frosinone	FR	4499
IT	3029	Panetta	Lazio	Frosinone	FR	4500
IT	3029	Scifelli	Lazio	Frosinone	FR	4501
IT	3029	Casamari	Lazio	Frosinone	FR	4502
IT	3029	Sant'Angelo In Villa	Lazio	Frosinone	FR	4503
IT	3030	Vicalvi	Lazio	Frosinone	FR	4504
IT	3030	Campoli Appennino	Lazio	Frosinone	FR	4505
IT	3030	Casalattico	Lazio	Frosinone	FR	4506
IT	3030	Castrocielo	Lazio	Frosinone	FR	4507
IT	3030	Colle San Magno	Lazio	Frosinone	FR	4508
IT	3030	Madonna Della Stella	Lazio	Frosinone	FR	4509
IT	3030	Piedimonte San Germano	Lazio	Frosinone	FR	4510
IT	3030	Piedimonte San Germano Alta	Lazio	Frosinone	FR	4511
IT	3030	Colfelice	Lazio	Frosinone	FR	4512
IT	3030	Piumarola	Lazio	Frosinone	FR	4513
IT	3030	Santopadre	Lazio	Frosinone	FR	4514
IT	3030	Broccostella	Lazio	Frosinone	FR	4515
IT	3030	Posta Fibreno	Lazio	Frosinone	FR	4516
IT	3030	Rocca D'Arce	Lazio	Frosinone	FR	4517
IT	3030	Villa Santa Lucia	Lazio	Frosinone	FR	4518
IT	3030	Fontechiari	Lazio	Frosinone	FR	4519
IT	3030	Pescosolido	Lazio	Frosinone	FR	4520
IT	3030	Villa Felice	Lazio	Frosinone	FR	4521
IT	3031	Aquino	Lazio	Frosinone	FR	4522
IT	3032	Isoletta	Lazio	Frosinone	FR	4523
IT	3032	Arce	Lazio	Frosinone	FR	4524
IT	3033	Scaffa	Lazio	Frosinone	FR	4525
IT	3033	Arpino	Lazio	Frosinone	FR	4526
IT	3033	Scaffa San Sossio	Lazio	Frosinone	FR	4527
IT	3034	Roselli	Lazio	Frosinone	FR	4528
IT	3034	Casalvieri	Lazio	Frosinone	FR	4529
IT	3034	Purgatorio	Lazio	Frosinone	FR	4530
IT	3035	Collefontana	Lazio	Frosinone	FR	4531
IT	3035	San Paolo	Lazio	Frosinone	FR	4532
IT	3035	Fontana Liri	Lazio	Frosinone	FR	4533
IT	3035	Fontana Liri Superiore	Lazio	Frosinone	FR	4534
IT	3036	Isola Del Liri	Lazio	Frosinone	FR	4535
IT	3037	Sant'Oliva Di Pontecorvo	Lazio	Frosinone	FR	4536
IT	3037	Pastine Di Pontecorvo	Lazio	Frosinone	FR	4537
IT	3037	Pontecorvo	Lazio	Frosinone	FR	4538
IT	3037	Sant'Oliva	Lazio	Frosinone	FR	4539
IT	3038	Roccasecca	Lazio	Frosinone	FR	4540
IT	3038	Roccasecca Stazione	Lazio	Frosinone	FR	4541
IT	3038	Caprile	Lazio	Frosinone	FR	4542
IT	3039	Sora	Lazio	Frosinone	FR	4543
IT	3039	Carnello	Lazio	Frosinone	FR	4544
IT	3039	Selva Di Sora	Lazio	Frosinone	FR	4545
IT	3040	Ausonia	Lazio	Frosinone	FR	4546
IT	3040	Sant'Andrea Del Garigliano	Lazio	Frosinone	FR	4547
IT	3040	Vallerotonda	Lazio	Frosinone	FR	4548
IT	3040	Villa Latina	Lazio	Frosinone	FR	4549
IT	3040	Belmonte Castello	Lazio	Frosinone	FR	4550
IT	3040	Sant'Ambrogio Sul Garigliano	Lazio	Frosinone	FR	4551
IT	3040	Pietrafitta	Lazio	Frosinone	FR	4552
IT	3040	Casalcassinese	Lazio	Frosinone	FR	4553
IT	3040	Castelnuovo Parano	Lazio	Frosinone	FR	4554
IT	3040	Cerreto Di Vallerotonda	Lazio	Frosinone	FR	4555
IT	3040	Vallemaio	Lazio	Frosinone	FR	4556
IT	3040	Acquafondata	Lazio	Frosinone	FR	4557
IT	3040	Cardito Di Vallerotonda	Lazio	Frosinone	FR	4558
IT	3040	Selvacava	Lazio	Frosinone	FR	4559
IT	3040	Terelle	Lazio	Frosinone	FR	4560
IT	3040	San Vittore Del Lazio	Lazio	Frosinone	FR	4561
IT	3040	Viticuso	Lazio	Frosinone	FR	4562
IT	3040	Coreno Ausonio	Lazio	Frosinone	FR	4563
IT	3040	Settefrati	Lazio	Frosinone	FR	4564
IT	3040	Picinisco	Lazio	Frosinone	FR	4565
IT	3040	Valvori	Lazio	Frosinone	FR	4566
IT	3040	Pignataro Interamna	Lazio	Frosinone	FR	4567
IT	3040	Gallinaro	Lazio	Frosinone	FR	4568
IT	3040	San Biagio Saracinisco	Lazio	Frosinone	FR	4569
IT	3041	Sant'Onofrio	Lazio	Frosinone	FR	4570
IT	3041	Alvito	Lazio	Frosinone	FR	4571
IT	3041	Castello D'Alvito	Lazio	Frosinone	FR	4572
IT	3042	Atina Inferiore	Lazio	Frosinone	FR	4573
IT	3042	Atina	Lazio	Frosinone	FR	4574
IT	3042	Casino Pica	Lazio	Frosinone	FR	4575
IT	3043	Cassino	Lazio	Frosinone	FR	4576
IT	3043	Sant'Angelo In Theodice	Lazio	Frosinone	FR	4577
IT	3043	Cappella Morrone	Lazio	Frosinone	FR	4578
IT	3043	Caira	Lazio	Frosinone	FR	4579
IT	3043	San Bartolomeo	Lazio	Frosinone	FR	4580
IT	3043	Montecassino	Lazio	Frosinone	FR	4581
IT	3044	Pacitti	Lazio	Frosinone	FR	4582
IT	3044	Cervaro	Lazio	Frosinone	FR	4583
IT	3044	Sprumaro	Lazio	Frosinone	FR	4584
IT	3044	Santa Lucia	Lazio	Frosinone	FR	4585
IT	3044	Pastenelle	Lazio	Frosinone	FR	4586
IT	3045	Esperia Inferiore	Lazio	Frosinone	FR	4587
IT	3045	Esperia	Lazio	Frosinone	FR	4588
IT	3045	Monticelli	Lazio	Frosinone	FR	4589
IT	3046	San Donato Val Di Comino	Lazio	Frosinone	FR	4590
IT	3047	San Giorgio A Liri	Lazio	Frosinone	FR	4591
IT	3048	Sant'Apollinare	Lazio	Frosinone	FR	4592
IT	3049	Sant'Elia Fiumerapido	Lazio	Frosinone	FR	4593
IT	3049	Portella	Lazio	Frosinone	FR	4594
IT	3049	Olivella	Lazio	Frosinone	FR	4595
IT	3049	Valleluce	Lazio	Frosinone	FR	4596
IT	3100	Frosinone	Lazio	Frosinone	FR	4597
IT	3100	De Matteis	Lazio	Frosinone	FR	4598
IT	3100	Madonna Della Neve	Lazio	Frosinone	FR	4599
IT	3100	Frosinone Stazione	Lazio	Frosinone	FR	4600
IT	4010	Sonnino Scalo	Lazio	Latina	LT	4601
IT	4010	Pisterzo	Lazio	Latina	LT	4602
IT	4010	Roccasecca Dei Volsci	Lazio	Latina	LT	4603
IT	4010	Borgo San Donato	Lazio	Latina	LT	4604
IT	4010	Sonnino	Lazio	Latina	LT	4605
IT	4010	Norma	Lazio	Latina	LT	4606
IT	4010	Prossedi	Lazio	Latina	LT	4607
IT	4010	Bassiano	Lazio	Latina	LT	4608
IT	4010	Giulianello	Lazio	Latina	LT	4609
IT	4010	Maenza	Lazio	Latina	LT	4610
IT	4010	Cori	Lazio	Latina	LT	4611
IT	4010	Rocca Massima	Lazio	Latina	LT	4612
IT	4010	Roccagorga	Lazio	Latina	LT	4613
IT	4010	Sezze Stazione	Lazio	Latina	LT	4614
IT	4010	Sezze Scalo	Lazio	Latina	LT	4615
IT	4011	Fossignano	Lazio	Latina	LT	4616
IT	4011	Carano	Lazio	Latina	LT	4617
IT	4011	Torre Del Padiglione	Lazio	Latina	LT	4618
IT	4011	Pantanelle	Lazio	Latina	LT	4619
IT	4011	Campoleone	Lazio	Latina	LT	4620
IT	4011	Campo Di Carne	Lazio	Latina	LT	4621
IT	4011	Aprilia	Lazio	Latina	LT	4622
IT	4011	Camilleri	Lazio	Latina	LT	4623
IT	4011	Campoverde	Lazio	Latina	LT	4624
IT	4011	Vallelata	Lazio	Latina	LT	4625
IT	4011	Casalazara	Lazio	Latina	LT	4626
IT	4011	Cogna	Lazio	Latina	LT	4627
IT	4012	Borgo Flora	Lazio	Latina	LT	4628
IT	4012	Cisterna Di Latina	Lazio	Latina	LT	4629
IT	4012	Le Castella	Lazio	Latina	LT	4630
IT	4013	Sermoneta Scalo	Lazio	Latina	LT	4631
IT	4013	Carrara	Lazio	Latina	LT	4632
IT	4013	Doganella	Lazio	Latina	LT	4633
IT	4013	Monticchio	Lazio	Latina	LT	4634
IT	4013	Sermoneta	Lazio	Latina	LT	4635
IT	4013	Doganella Di Ninfa	Lazio	Latina	LT	4636
IT	4013	Latina Aeroporto	Lazio	Latina	LT	4637
IT	4014	Borgo Pasubio	Lazio	Latina	LT	4638
IT	4014	Pontinia	Lazio	Latina	LT	4639
IT	4015	Fossanova	Lazio	Latina	LT	4640
IT	4015	Priverno	Lazio	Latina	LT	4641
IT	4015	Abbazia Di Fossanova	Lazio	Latina	LT	4642
IT	4016	Baia D'Argento	Lazio	Latina	LT	4643
IT	4016	Sabaudia	Lazio	Latina	LT	4644
IT	4016	Borgo Vodice	Lazio	Latina	LT	4645
IT	4017	San Felice Circeo	Lazio	Latina	LT	4646
IT	4017	Borgo Montenero	Lazio	Latina	LT	4647
IT	4018	Sezze	Lazio	Latina	LT	4648
IT	4018	Colli Di Suso	Lazio	Latina	LT	4649
IT	4019	Badino	Lazio	Latina	LT	4650
IT	4019	Terracina	Lazio	Latina	LT	4651
IT	4019	Borgo Hermada	Lazio	Latina	LT	4652
IT	4019	La Fiora	Lazio	Latina	LT	4653
IT	4020	Santi Cosma E Damiano	Lazio	Latina	LT	4654
IT	4020	Spigno Saturnia	Lazio	Latina	LT	4655
IT	4020	Campodimele	Lazio	Latina	LT	4656
IT	4020	San Lorenzo Di Santi Cosma E Damiano	Lazio	Latina	LT	4657
IT	4020	Grunuovo Di Santi Cosma E Damiano	Lazio	Latina	LT	4658
IT	4020	Ventotene	Lazio	Latina	LT	4659
IT	4020	Grunuovo	Lazio	Latina	LT	4660
IT	4020	Santo Stefano	Lazio	Latina	LT	4661
IT	4020	Campomaggiore San Luca	Lazio	Latina	LT	4662
IT	4020	Itri	Lazio	Latina	LT	4663
IT	4020	Monte San Biagio	Lazio	Latina	LT	4664
IT	4020	Spigno Saturnia Inferiore	Lazio	Latina	LT	4665
IT	4021	San Cataldo	Lazio	Latina	LT	4666
IT	4021	Castelforte	Lazio	Latina	LT	4667
IT	4021	Forme Di Suio	Lazio	Latina	LT	4668
IT	4021	Suio Terme	Lazio	Latina	LT	4669
IT	4022	Fondi	Lazio	Latina	LT	4670
IT	4022	Salto Di Fondi	Lazio	Latina	LT	4671
IT	4022	San Magno	Lazio	Latina	LT	4672
IT	4023	Formia	Lazio	Latina	LT	4673
IT	4023	Penitro	Lazio	Latina	LT	4674
IT	4023	Maranola	Lazio	Latina	LT	4675
IT	4023	Acquatraversa Di Formia	Lazio	Latina	LT	4676
IT	4023	Castellonorato	Lazio	Latina	LT	4677
IT	4023	Vindicio Di Formia	Lazio	Latina	LT	4678
IT	4023	Trivio Di Formia	Lazio	Latina	LT	4679
IT	4024	Gaeta	Lazio	Latina	LT	4680
IT	4025	Valle Bernardo	Lazio	Latina	LT	4681
IT	4025	Lenola	Lazio	Latina	LT	4682
IT	4026	Minturno	Lazio	Latina	LT	4683
IT	4026	Tremensuoli	Lazio	Latina	LT	4684
IT	4026	Tufo Di Minturno	Lazio	Latina	LT	4685
IT	4026	Santa Maria Infante	Lazio	Latina	LT	4686
IT	4027	Ponza	Lazio	Latina	LT	4687
IT	4027	Le Forna	Lazio	Latina	LT	4688
IT	4028	Scauri	Lazio	Latina	LT	4689
IT	4028	Marina Di Minturno	Lazio	Latina	LT	4690
IT	4029	Sperlonga	Lazio	Latina	LT	4691
IT	4100	Fogliano	Lazio	Latina	LT	4692
IT	4100	Borgo Bainsizza	Lazio	Latina	LT	4693
IT	4100	Borgo Podgora	Lazio	Latina	LT	4694
IT	4100	Borgo Grappa	Lazio	Latina	LT	4695
IT	4100	Tor Tre Ponti	Lazio	Latina	LT	4696
IT	4100	Latina	Lazio	Latina	LT	4697
IT	4100	Borgo Faiti	Lazio	Latina	LT	4698
IT	4100	Le Ferriere	Lazio	Latina	LT	4699
IT	4100	Borgo Carso	Lazio	Latina	LT	4700
IT	4100	Borgo Isonzo	Lazio	Latina	LT	4701
IT	4100	Foce Verde	Lazio	Latina	LT	4702
IT	4100	Borgo San Michele	Lazio	Latina	LT	4703
IT	4100	Borgo Sabotino	Lazio	Latina	LT	4704
IT	4100	Latina Scalo	Lazio	Latina	LT	4705
IT	4100	Foro Appio	Lazio	Latina	LT	4706
IT	4100	Borgo Montello	Lazio	Latina	LT	4707
IT	4100	Borgo Piave	Lazio	Latina	LT	4708
IT	2010	Santa Croce	Lazio	Rieti	RI	4709
IT	2010	Cittareale	Lazio	Rieti	RI	4710
IT	2010	Rivodutri	Lazio	Rieti	RI	4711
IT	2010	Castel Sant'Angelo	Lazio	Rieti	RI	4712
IT	2010	Santa Croce Di Cittareale	Lazio	Rieti	RI	4713
IT	2010	Torrita	Lazio	Rieti	RI	4714
IT	2010	Colli Sul Velino	Lazio	Rieti	RI	4715
IT	2010	Borgo Velino	Lazio	Rieti	RI	4716
IT	2010	Micigliano	Lazio	Rieti	RI	4717
IT	2010	Borbona	Lazio	Rieti	RI	4718
IT	2010	Scai	Lazio	Rieti	RI	4719
IT	2010	Morro Reatino	Lazio	Rieti	RI	4720
IT	2010	Piedicolle	Lazio	Rieti	RI	4721
IT	2010	Labro	Lazio	Rieti	RI	4722
IT	2010	Canetra Di Castel Sant'Angelo	Lazio	Rieti	RI	4723
IT	2010	Vallemare	Lazio	Rieti	RI	4724
IT	2011	Grisciano	Lazio	Rieti	RI	4725
IT	2011	Accumoli	Lazio	Rieti	RI	4726
IT	2012	Preta	Lazio	Rieti	RI	4727
IT	2012	Sommati	Lazio	Rieti	RI	4728
IT	2012	Santa Giusta	Lazio	Rieti	RI	4729
IT	2012	Collemoresco	Lazio	Rieti	RI	4730
IT	2012	Amatrice	Lazio	Rieti	RI	4731
IT	2012	Santi Lorenzo E Flaviano	Lazio	Rieti	RI	4732
IT	2013	Antrodoco	Lazio	Rieti	RI	4733
IT	2014	Fantauzzi	Lazio	Rieti	RI	4734
IT	2014	Cantalice	Lazio	Rieti	RI	4735
IT	2014	San Liberato	Lazio	Rieti	RI	4736
IT	2015	Grotti	Lazio	Rieti	RI	4737
IT	2015	Cittaducale	Lazio	Rieti	RI	4738
IT	2015	Santa Rufina	Lazio	Rieti	RI	4739
IT	2015	Grotti Di Cittaducale	Lazio	Rieti	RI	4740
IT	2016	Vindoli	Lazio	Rieti	RI	4741
IT	2016	Albaneto	Lazio	Rieti	RI	4742
IT	2016	Terzone	Lazio	Rieti	RI	4743
IT	2016	San Clemente Di Leonessa	Lazio	Rieti	RI	4744
IT	2016	Villa Bigioni	Lazio	Rieti	RI	4745
IT	2016	Piedelpoggio	Lazio	Rieti	RI	4746
IT	2016	Leonessa	Lazio	Rieti	RI	4747
IT	2018	Poggio Bustone	Lazio	Rieti	RI	4748
IT	2019	Posta	Lazio	Rieti	RI	4749
IT	2019	Favischio	Lazio	Rieti	RI	4750
IT	2019	Sigillo Di Posta	Lazio	Rieti	RI	4751
IT	2019	Picciame	Lazio	Rieti	RI	4752
IT	2020	Paganico Sabino	Lazio	Rieti	RI	4753
IT	2020	Campolano	Lazio	Rieti	RI	4754
IT	2020	Turania	Lazio	Rieti	RI	4755
IT	2020	Longone Sabino	Lazio	Rieti	RI	4756
IT	2020	Stipes	Lazio	Rieti	RI	4757
IT	2020	Roccaranieri	Lazio	Rieti	RI	4758
IT	2020	Vaccareccia	Lazio	Rieti	RI	4759
IT	2020	Ascrea	Lazio	Rieti	RI	4760
IT	2020	Concerviano	Lazio	Rieti	RI	4761
IT	2020	Marcetelli	Lazio	Rieti	RI	4762
IT	2020	Belmonte In Sabina	Lazio	Rieti	RI	4763
IT	2020	Nespolo	Lazio	Rieti	RI	4764
IT	2020	Castel Di Tora	Lazio	Rieti	RI	4765
IT	2020	Colle Di Tora	Lazio	Rieti	RI	4766
IT	2020	Collegiove	Lazio	Rieti	RI	4767
IT	2020	Varco Sabino	Lazio	Rieti	RI	4768
IT	2021	Villerose	Lazio	Rieti	RI	4769
IT	2021	Collemaggiore	Lazio	Rieti	RI	4770
IT	2021	Poggiovalle Di Borgorose	Lazio	Rieti	RI	4771
IT	2021	Sant'Anatolia	Lazio	Rieti	RI	4772
IT	2021	Corvaro	Lazio	Rieti	RI	4773
IT	2021	Borgorose	Lazio	Rieti	RI	4774
IT	2021	Torano	Lazio	Rieti	RI	4775
IT	2021	Grotti Di Borgorose	Lazio	Rieti	RI	4776
IT	2021	Poggiovalle	Lazio	Rieti	RI	4777
IT	2022	Collalto Sabino	Lazio	Rieti	RI	4778
IT	2023	Peschieta	Lazio	Rieti	RI	4779
IT	2023	Fiamignano	Lazio	Rieti	RI	4780
IT	2023	Santa Lucia	Lazio	Rieti	RI	4781
IT	2023	Santa Lucia Di Fiamignano	Lazio	Rieti	RI	4782
IT	2023	Sant'Ippolito	Lazio	Rieti	RI	4783
IT	2023	Sant'Agapito	Lazio	Rieti	RI	4784
IT	2024	Pace	Lazio	Rieti	RI	4785
IT	2024	Pescorocchiano	Lazio	Rieti	RI	4786
IT	2024	Leofreni	Lazio	Rieti	RI	4787
IT	2024	Sant'Elpidio Di Pescorocchiano	Lazio	Rieti	RI	4788
IT	2024	Sant'Elpidio	Lazio	Rieti	RI	4789
IT	2025	Capradosso	Lazio	Rieti	RI	4790
IT	2025	Petrella Salto	Lazio	Rieti	RI	4791
IT	2025	Fiumata	Lazio	Rieti	RI	4792
IT	2025	Borgo San Pietro	Lazio	Rieti	RI	4793
IT	2025	Castelmareri	Lazio	Rieti	RI	4794
IT	2026	Rocca Sinibalda	Lazio	Rieti	RI	4795
IT	2026	Posticciola	Lazio	Rieti	RI	4796
IT	2030	Villetta Sant'Antonio	Lazio	Rieti	RI	4797
IT	2030	Collelungo	Lazio	Rieti	RI	4798
IT	2030	Poggio Nativo	Lazio	Rieti	RI	4799
IT	2030	Torricella In Sabina	Lazio	Rieti	RI	4800
IT	2030	Casaprota	Lazio	Rieti	RI	4801
IT	2030	Pozzaglia Sabina	Lazio	Rieti	RI	4802
IT	2030	Frasso Sabino	Lazio	Rieti	RI	4803
IT	2030	Collelungo Sabino	Lazio	Rieti	RI	4804
IT	2030	Monte Santa Maria	Lazio	Rieti	RI	4805
IT	2030	Poggio San Lorenzo	Lazio	Rieti	RI	4806
IT	2031	Castelnuovo Di Farfa	Lazio	Rieti	RI	4807
IT	2032	Corese Terra	Lazio	Rieti	RI	4808
IT	2032	Canneto	Lazio	Rieti	RI	4809
IT	2032	Farfa	Lazio	Rieti	RI	4810
IT	2032	Borgo Quinzio	Lazio	Rieti	RI	4811
IT	2032	Farfa Sabina	Lazio	Rieti	RI	4812
IT	2032	Talocci	Lazio	Rieti	RI	4813
IT	2032	Passo Corese	Lazio	Rieti	RI	4814
IT	2032	Coltodino	Lazio	Rieti	RI	4815
IT	2032	Fara In Sabina	Lazio	Rieti	RI	4816
IT	2032	Canneto Sabino	Lazio	Rieti	RI	4817
IT	2032	Prime Case	Lazio	Rieti	RI	4818
IT	2032	Borgo Salario	Lazio	Rieti	RI	4819
IT	2033	Monteleone Sabino	Lazio	Rieti	RI	4820
IT	2033	Ginestra Sabina	Lazio	Rieti	RI	4821
IT	2034	Bocchignano	Lazio	Rieti	RI	4822
IT	2034	Montopoli Di Sabina	Lazio	Rieti	RI	4823
IT	2035	Orvinio	Lazio	Rieti	RI	4824
IT	2037	Poggio Moiano	Lazio	Rieti	RI	4825
IT	2037	Cerdomare	Lazio	Rieti	RI	4826
IT	2037	Osteria Nuova	Lazio	Rieti	RI	4827
IT	2037	Fiacchini	Lazio	Rieti	RI	4828
IT	2038	Scandriglia	Lazio	Rieti	RI	4829
IT	2038	Ponticelli	Lazio	Rieti	RI	4830
IT	2039	Toffia	Lazio	Rieti	RI	4831
IT	2040	Poggio Catino	Lazio	Rieti	RI	4832
IT	2040	Montenero Sabino	Lazio	Rieti	RI	4833
IT	2040	Salisano	Lazio	Rieti	RI	4834
IT	2040	Montasola	Lazio	Rieti	RI	4835
IT	2040	Cottanello	Lazio	Rieti	RI	4836
IT	2040	Vacone	Lazio	Rieti	RI	4837
IT	2040	Tarano	Lazio	Rieti	RI	4838
IT	2040	Cantalupo In Sabina	Lazio	Rieti	RI	4839
IT	2040	Fianello	Lazio	Rieti	RI	4840
IT	2040	Configni	Lazio	Rieti	RI	4841
IT	2040	Monte San Giovanni In Sabina	Lazio	Rieti	RI	4842
IT	2040	Mompeo	Lazio	Rieti	RI	4843
IT	2040	Montebuono	Lazio	Rieti	RI	4844
IT	2040	Selci	Lazio	Rieti	RI	4845
IT	2040	San Polo	Lazio	Rieti	RI	4846
IT	2040	Roccantica	Lazio	Rieti	RI	4847
IT	2040	San Polo Sabino	Lazio	Rieti	RI	4848
IT	2041	Casperia	Lazio	Rieti	RI	4849
IT	2042	Collevecchio	Lazio	Rieti	RI	4850
IT	2043	San Filippo	Lazio	Rieti	RI	4851
IT	2043	Contigliano	Lazio	Rieti	RI	4852
IT	2043	San Filippo Di Contigliano	Lazio	Rieti	RI	4853
IT	2043	Montisola	Lazio	Rieti	RI	4854
IT	2044	Gavignano Sabino	Lazio	Rieti	RI	4855
IT	2044	Forano	Lazio	Rieti	RI	4856
IT	2045	Greccio	Lazio	Rieti	RI	4857
IT	2045	Limiti Di Greccio	Lazio	Rieti	RI	4858
IT	2046	Magliano Sabina	Lazio	Rieti	RI	4859
IT	2046	Foglia	Lazio	Rieti	RI	4860
IT	2047	Poggio Mirteto Scalo	Lazio	Rieti	RI	4861
IT	2047	Castel San Pietro	Lazio	Rieti	RI	4862
IT	2047	Poggio Mirteto	Lazio	Rieti	RI	4863
IT	2047	Poggio Mirteto Stazione	Lazio	Rieti	RI	4864
IT	2048	Stimigliano	Lazio	Rieti	RI	4865
IT	2048	Stimigliano Scalo	Lazio	Rieti	RI	4866
IT	2048	Stimigliano Stazione	Lazio	Rieti	RI	4867
IT	2049	Torri In Sabina	Lazio	Rieti	RI	4868
IT	2100	Poggio Perugino	Lazio	Rieti	RI	4869
IT	2100	San Giovanni Reatino	Lazio	Rieti	RI	4870
IT	2100	Monte Terminillo	Lazio	Rieti	RI	4871
IT	2100	Pie' Di Moggio	Lazio	Rieti	RI	4872
IT	2100	Casette	Lazio	Rieti	RI	4873
IT	2100	Poggio Fidoni	Lazio	Rieti	RI	4874
IT	2100	Rieti	Lazio	Rieti	RI	4875
IT	2100	Vazia	Lazio	Rieti	RI	4876
IT	10	Setteville Di Guidonia	Lazio	Roma	RM	4877
IT	10	Poli	Lazio	Roma	RM	4878
IT	10	San Gregorio Da Sassola	Lazio	Roma	RM	4879
IT	10	Sant'Angelo Romano	Lazio	Roma	RM	4880
IT	10	Villa Adriana	Lazio	Roma	RM	4881
IT	10	Moricone	Lazio	Roma	RM	4882
IT	10	Casape	Lazio	Roma	RM	4883
IT	10	Montelibretti	Lazio	Roma	RM	4884
IT	10	Montorio Romano	Lazio	Roma	RM	4885
IT	10	Marcellina	Lazio	Roma	RM	4886
IT	10	Borgo Santa Maria	Lazio	Roma	RM	4887
IT	10	Setteville	Lazio	Roma	RM	4888
IT	10	San Polo Dei Cavalieri	Lazio	Roma	RM	4889
IT	10	Gallicano Nel Lazio	Lazio	Roma	RM	4890
IT	10	Monteflavio	Lazio	Roma	RM	4891
IT	11	Tivoli Terme	Lazio	Roma	RM	4892
IT	11	Bagni Di Tivol	Lazio	Roma	RM	4893
IT	12	Villanova	Lazio	Roma	RM	4894
IT	12	Villalba	Lazio	Roma	RM	4895
IT	12	La Botte	Lazio	Roma	RM	4896
IT	12	Colle Verde	Lazio	Roma	RM	4897
IT	12	Villanova Di Guidonia	Lazio	Roma	RM	4898
IT	12	Guidonia	Lazio	Roma	RM	4899
IT	12	Albuccione	Lazio	Roma	RM	4900
IT	12	Montecelio	Lazio	Roma	RM	4901
IT	12	Guidonia Montecelio	Lazio	Roma	RM	4902
IT	13	Fonte Nuova	Lazio	Roma	RM	4903
IT	13	Tor Lupara	Lazio	Roma	RM	4904
IT	13	Torlupara Di Mentana	Lazio	Roma	RM	4905
IT	13	Mentana	Lazio	Roma	RM	4906
IT	13	Castelchiodato	Lazio	Roma	RM	4907
IT	13	Santa Lucia	Lazio	Roma	RM	4908
IT	15	Monterotondo	Lazio	Roma	RM	4909
IT	15	Monterotondo Stazione	Lazio	Roma	RM	4910
IT	17	Acquaviva	Lazio	Roma	RM	4911
IT	17	Nerola	Lazio	Roma	RM	4912
IT	18	Cretone	Lazio	Roma	RM	4913
IT	18	Palombara Sabina	Lazio	Roma	RM	4914
IT	19	Bivio San Polo	Lazio	Roma	RM	4915
IT	19	Arci	Lazio	Roma	RM	4916
IT	19	Empolitana	Lazio	Roma	RM	4917
IT	19	Tivoli	Lazio	Roma	RM	4918
IT	19	Pontelucano	Lazio	Roma	RM	4919
IT	20	Mandela	Lazio	Roma	RM	4920
IT	20	Vallepietra	Lazio	Roma	RM	4921
IT	20	Arcinazzo Romano	Lazio	Roma	RM	4922
IT	20	Ciciliano	Lazio	Roma	RM	4923
IT	20	Vallinfreda	Lazio	Roma	RM	4924
IT	20	Cerreto Laziale	Lazio	Roma	RM	4925
IT	20	Sambuci	Lazio	Roma	RM	4926
IT	20	Vivaro Romano	Lazio	Roma	RM	4927
IT	20	Percile	Lazio	Roma	RM	4928
IT	20	Saracinesco	Lazio	Roma	RM	4929
IT	20	Camerata Nuova	Lazio	Roma	RM	4930
IT	20	Roccagiovine	Lazio	Roma	RM	4931
IT	20	Madonna Della Pace	Lazio	Roma	RM	4932
IT	20	Jenne	Lazio	Roma	RM	4933
IT	20	Riofreddo	Lazio	Roma	RM	4934
IT	20	Agosta	Lazio	Roma	RM	4935
IT	20	Cineto Romano	Lazio	Roma	RM	4936
IT	20	Altipiani Di Arcinazzo	Lazio	Roma	RM	4937
IT	20	Cervara Di Roma	Lazio	Roma	RM	4938
IT	20	Canterano	Lazio	Roma	RM	4939
IT	20	Rocca Canterano	Lazio	Roma	RM	4940
IT	20	Pisoniano	Lazio	Roma	RM	4941
IT	20	Marano Equo	Lazio	Roma	RM	4942
IT	21	Affile	Lazio	Roma	RM	4943
IT	22	Anticoli Corrado	Lazio	Roma	RM	4944
IT	23	Arsoli	Lazio	Roma	RM	4945
IT	24	Castel Madama	Lazio	Roma	RM	4946
IT	25	Gerano	Lazio	Roma	RM	4947
IT	26	Civitella	Lazio	Roma	RM	4948
IT	26	Licenza	Lazio	Roma	RM	4949
IT	27	Roviano	Lazio	Roma	RM	4950
IT	28	Subiaco	Lazio	Roma	RM	4951
IT	29	Vicovaro	Lazio	Roma	RM	4952
IT	30	San Vito Romano	Lazio	Roma	RM	4953
IT	30	Guadagnolo	Lazio	Roma	RM	4954
IT	30	Rocca Di Cave	Lazio	Roma	RM	4955
IT	30	Montelanico	Lazio	Roma	RM	4956
IT	30	Capranica Prenestina	Lazio	Roma	RM	4957
IT	30	Rocca Santo Stefano	Lazio	Roma	RM	4958
IT	30	Gorga	Lazio	Roma	RM	4959
IT	30	Bellegra	Lazio	Roma	RM	4960
IT	30	Castel San Pietro Romano	Lazio	Roma	RM	4961
IT	30	Labico	Lazio	Roma	RM	4962
IT	30	Colonna	Lazio	Roma	RM	4963
IT	30	Colonna Stazione	Lazio	Roma	RM	4964
IT	30	Roiate	Lazio	Roma	RM	4965
IT	30	Gavignano	Lazio	Roma	RM	4966
IT	30	Genazzano	Lazio	Roma	RM	4967
IT	30	San Cesareo	Lazio	Roma	RM	4968
IT	31	Artena	Lazio	Roma	RM	4969
IT	31	Macere	Lazio	Roma	RM	4970
IT	31	Colubro	Lazio	Roma	RM	4971
IT	32	Carpineto Romano	Lazio	Roma	RM	4972
IT	33	San Bartolomeo	Lazio	Roma	RM	4973
IT	33	Cave	Lazio	Roma	RM	4974
IT	34	Colleferro	Lazio	Roma	RM	4975
IT	34	Colleferro Stazione	Lazio	Roma	RM	4976
IT	34	Colleferro Scalo	Lazio	Roma	RM	4977
IT	35	Olevano Romano	Lazio	Roma	RM	4978
IT	36	Carchitti	Lazio	Roma	RM	4979
IT	36	Palestrina	Lazio	Roma	RM	4980
IT	37	Segni	Lazio	Roma	RM	4981
IT	38	Valmontone	Lazio	Roma	RM	4982
IT	39	Zagarolo	Lazio	Roma	RM	4983
IT	39	Valle Martella	Lazio	Roma	RM	4984
IT	40	Rocca Di Papa	Lazio	Roma	RM	4985
IT	40	Frattocchie	Lazio	Roma	RM	4986
IT	40	Ardea	Lazio	Roma	RM	4987
IT	40	Ponte Sulla Moletta	Lazio	Roma	RM	4988
IT	40	Santa Maria Delle Mole	Lazio	Roma	RM	4989
IT	40	Marina Di Ardea	Lazio	Roma	RM	4990
IT	40	Tor San Lorenzo	Lazio	Roma	RM	4991
IT	41	Cecchina	Lazio	Roma	RM	4992
IT	41	Albano Laziale	Lazio	Roma	RM	4993
IT	41	Pavona Stazione	Lazio	Roma	RM	4994
IT	41	Pavona	Lazio	Roma	RM	4995
IT	41	Cecchina Stazione	Lazio	Roma	RM	4996
IT	42	Lido Dei Pini	Lazio	Roma	RM	4997
IT	42	Anzio	Lazio	Roma	RM	4998
IT	42	Colonia Di Anzio	Lazio	Roma	RM	4999
IT	42	Lavinio Lido Di Enea	Lazio	Roma	RM	5000
IT	43	Ciampino	Lazio	Roma	RM	5001
IT	43	Casabianca	Lazio	Roma	RM	5002
IT	43	Ciampino Aeroporto	Lazio	Roma	RM	5003
IT	44	Frascati	Lazio	Roma	RM	5004
IT	44	Vermicino	Lazio	Roma	RM	5005
IT	45	Pedica	Lazio	Roma	RM	5006
IT	45	Landi	Lazio	Roma	RM	5007
IT	45	Genzano Di Roma	Lazio	Roma	RM	5008
IT	46	Poggio Tulliano	Lazio	Roma	RM	5009
IT	46	Grottaferrata	Lazio	Roma	RM	5010
IT	47	Marino	Lazio	Roma	RM	5011
IT	48	Nettuno	Lazio	Roma	RM	5012
IT	49	Velletri	Lazio	Roma	RM	5013
IT	50	Testa Di Lepre Di Sopra	Lazio	Roma	RM	5014
IT	51	La Bianca	Lazio	Roma	RM	5015
IT	51	Allumiere	Lazio	Roma	RM	5016
IT	52	Ceri	Lazio	Roma	RM	5017
IT	52	Marina Di Cerveteri	Lazio	Roma	RM	5018
IT	52	Cerveteri	Lazio	Roma	RM	5019
IT	52	Borgo San Martino Di Cerveteri	Lazio	Roma	RM	5020
IT	52	Stazione Di Furbara	Lazio	Roma	RM	5021
IT	52	Furbara Cerenova	Lazio	Roma	RM	5022
IT	52	Cerenova	Lazio	Roma	RM	5023
IT	53	Civitavecchia	Lazio	Roma	RM	5024
IT	53	Aurelia Di Civitavecchia	Lazio	Roma	RM	5025
IT	53	Aurelia	Lazio	Roma	RM	5026
IT	54	Ara Nova	Lazio	Roma	RM	5027
IT	54	Focene	Lazio	Roma	RM	5028
IT	54	Fregene	Lazio	Roma	RM	5029
IT	54	Isola Sacra	Lazio	Roma	RM	5030
IT	54	Torrimpietra	Lazio	Roma	RM	5031
IT	54	Maccarese	Lazio	Roma	RM	5032
IT	54	Fiumicino	Lazio	Roma	RM	5033
IT	54	Fiumicino Aeroporto	Lazio	Roma	RM	5034
IT	54	Testa Di Lepre	Lazio	Roma	RM	5035
IT	54	Passo Oscuro	Lazio	Roma	RM	5036
IT	55	Palo	Lazio	Roma	RM	5037
IT	55	Marina San Nicola	Lazio	Roma	RM	5038
IT	55	Ladispoli	Lazio	Roma	RM	5039
IT	57	Malagrotta	Lazio	Roma	RM	5040
IT	57	Pantano Di Grano	Lazio	Roma	RM	5041
IT	58	Santa Marinella	Lazio	Roma	RM	5042
IT	58	Santa Severa	Lazio	Roma	RM	5043
IT	59	Santa Severa Nord	Lazio	Roma	RM	5044
IT	59	Tolfa	Lazio	Roma	RM	5045
IT	60	Bivio Di Capanelle	Lazio	Roma	RM	5046
IT	60	Le Rughe	Lazio	Roma	RM	5047
IT	60	Civitella San Paolo	Lazio	Roma	RM	5048
IT	60	Riano	Lazio	Roma	RM	5049
IT	60	Capena	Lazio	Roma	RM	5050
IT	60	Castelnuovo Di Porto	Lazio	Roma	RM	5051
IT	60	Canale Monterano	Lazio	Roma	RM	5052
IT	60	Nazzano	Lazio	Roma	RM	5053
IT	60	Montevirginio	Lazio	Roma	RM	5054
IT	60	Magliano Romano	Lazio	Roma	RM	5055
IT	60	Filacciano	Lazio	Roma	RM	5056
IT	60	Ponzano Romano	Lazio	Roma	RM	5057
IT	60	Sant'Oreste	Lazio	Roma	RM	5058
IT	60	Torrita Tiberina	Lazio	Roma	RM	5059
IT	60	Bagni Di Stigliano	Lazio	Roma	RM	5060
IT	60	Ponte Storto	Lazio	Roma	RM	5061
IT	60	Girardi	Lazio	Roma	RM	5062
IT	60	Mazzano Romano	Lazio	Roma	RM	5063
IT	60	Monte Caminetto	Lazio	Roma	RM	5064
IT	60	Formello	Lazio	Roma	RM	5065
IT	60	Terrazze	Lazio	Roma	RM	5066
IT	60	Sacrofano	Lazio	Roma	RM	5067
IT	60	Belvedere	Lazio	Roma	RM	5068
IT	60	Terme Di Stiglian	Lazio	Roma	RM	5069
IT	60	Bellavista	Lazio	Roma	RM	5070
IT	61	Anguillara Sabazia	Lazio	Roma	RM	5071
IT	62	Bracciano	Lazio	Roma	RM	5072
IT	62	Rinascente	Lazio	Roma	RM	5073
IT	62	Castel Giuliano	Lazio	Roma	RM	5074
IT	62	Vigna Di Valle	Lazio	Roma	RM	5075
IT	63	Campagnano Di Roma	Lazio	Roma	RM	5076
IT	65	Feronia	Lazio	Roma	RM	5077
IT	65	Fiano Romano	Lazio	Roma	RM	5078
IT	66	Quadroni	Lazio	Roma	RM	5079
IT	66	Manziana	Lazio	Roma	RM	5080
IT	67	Morlupo	Lazio	Roma	RM	5081
IT	68	Rignano Flaminio	Lazio	Roma	RM	5082
IT	69	Trevignano Romano	Lazio	Roma	RM	5083
IT	69	Vicarello	Lazio	Roma	RM	5084
IT	71	Santa Palomba	Lazio	Roma	RM	5085
IT	71	Pomezia	Lazio	Roma	RM	5086
IT	71	Torvaianica	Lazio	Roma	RM	5087
IT	71	Pratica Di Mare	Lazio	Roma	RM	5088
IT	72	Ariccia	Lazio	Roma	RM	5089
IT	72	Galloro	Lazio	Roma	RM	5090
IT	73	Castel Gandolfo	Lazio	Roma	RM	5091
IT	73	Laghetto Di Castel Gandolfo	Lazio	Roma	RM	5092
IT	74	Nemi	Lazio	Roma	RM	5093
IT	75	Lanuvio	Lazio	Roma	RM	5094
IT	75	Pascolare	Lazio	Roma	RM	5095
IT	76	Lariano	Lazio	Roma	RM	5096
IT	77	Montecompatri	Lazio	Roma	RM	5097
IT	77	Laghetto Di Montecompatri	Lazio	Roma	RM	5098
IT	77	Molara	Lazio	Roma	RM	5099
IT	78	Armetta	Lazio	Roma	RM	5100
IT	78	Monte Porzio Catone	Lazio	Roma	RM	5101
IT	79	Colle Di Fuori	Lazio	Roma	RM	5102
IT	79	Rocca Priora	Lazio	Roma	RM	5103
IT	118	Roma	Lazio	Roma	RM	5104
IT	119	Ostia Antica	Lazio	Roma	RM	5105
IT	119	Roma	Lazio	Roma	RM	5106
IT	120	Roma	Lazio	Roma	RM	5107
IT	121	Lido Di Ostia Ponente	Lazio	Roma	RM	5108
IT	121	Roma	Lazio	Roma	RM	5109
IT	122	Castel Porziano	Lazio	Roma	RM	5110
IT	122	Castel Fusano	Lazio	Roma	RM	5111
IT	122	Roma	Lazio	Roma	RM	5112
IT	122	Lido Di Ostia Levante	Lazio	Roma	RM	5113
IT	123	La Storta	Lazio	Roma	RM	5114
IT	123	Isola Farnese	Lazio	Roma	RM	5115
IT	123	Roma	Lazio	Roma	RM	5116
IT	124	Casal Palocco	Lazio	Roma	RM	5117
IT	124	Roma	Lazio	Roma	RM	5118
IT	125	Acilia	Lazio	Roma	RM	5119
IT	125	Roma	Lazio	Roma	RM	5120
IT	126	Roma	Lazio	Roma	RM	5121
IT	127	Mezzocammino	Lazio	Roma	RM	5122
IT	127	Risaro	Lazio	Roma	RM	5123
IT	127	Vitinia	Lazio	Roma	RM	5124
IT	127	Roma	Lazio	Roma	RM	5125
IT	128	Castel Romano	Lazio	Roma	RM	5126
IT	128	Tor De' Cenci	Lazio	Roma	RM	5127
IT	128	Castel Di Decima	Lazio	Roma	RM	5128
IT	128	Malpasso	Lazio	Roma	RM	5129
IT	128	Roma	Lazio	Roma	RM	5130
IT	131	Settecamini	Lazio	Roma	RM	5131
IT	131	Roma	Lazio	Roma	RM	5132
IT	132	Borgata Borghesiana	Lazio	Roma	RM	5133
IT	132	Roma	Lazio	Roma	RM	5134
IT	132	Borgata Finocchio	Lazio	Roma	RM	5135
IT	132	Colle Della Valentina	Lazio	Roma	RM	5136
IT	133	Torre Gaia	Lazio	Roma	RM	5137
IT	133	Torrenova	Lazio	Roma	RM	5138
IT	133	Roma	Lazio	Roma	RM	5139
IT	133	Torre Angela	Lazio	Roma	RM	5140
IT	134	Divino Amore	Lazio	Roma	RM	5141
IT	134	Roma	Lazio	Roma	RM	5142
IT	134	Castel Di Leva	Lazio	Roma	RM	5143
IT	135	La Giustiniana	Lazio	Roma	RM	5144
IT	135	Roma	Lazio	Roma	RM	5145
IT	135	Borgata Ottavia	Lazio	Roma	RM	5146
IT	136	Roma	Lazio	Roma	RM	5147
IT	137	Roma	Lazio	Roma	RM	5148
IT	138	Settebagni	Lazio	Roma	RM	5149
IT	138	Marcigliana	Lazio	Roma	RM	5150
IT	138	Roma	Lazio	Roma	RM	5151
IT	138	Borgata Fidene	Lazio	Roma	RM	5152
IT	138	Castel Giubileo	Lazio	Roma	RM	5153
IT	139	Roma	Lazio	Roma	RM	5154
IT	141	Roma	Lazio	Roma	RM	5155
IT	142	Roma	Lazio	Roma	RM	5156
IT	143	Cecchignola	Lazio	Roma	RM	5157
IT	143	Roma	Lazio	Roma	RM	5158
IT	144	Decima	Lazio	Roma	RM	5159
IT	144	Roma	Lazio	Roma	RM	5160
IT	145	Roma	Lazio	Roma	RM	5161
IT	146	Roma	Lazio	Roma	RM	5162
IT	147	Roma	Lazio	Roma	RM	5163
IT	148	Magliana Trullo	Lazio	Roma	RM	5164
IT	148	Roma	Lazio	Roma	RM	5165
IT	148	Borgata Corviale	Lazio	Roma	RM	5166
IT	149	Roma	Lazio	Roma	RM	5167
IT	151	Roma	Lazio	Roma	RM	5168
IT	152	Roma	Lazio	Roma	RM	5169
IT	153	Roma	Lazio	Roma	RM	5170
IT	154	Roma	Lazio	Roma	RM	5171
IT	155	Tor Sapienza	Lazio	Roma	RM	5172
IT	155	La Rustica	Lazio	Roma	RM	5173
IT	155	Roma	Lazio	Roma	RM	5174
IT	156	Rebibbia	Lazio	Roma	RM	5175
IT	156	Roma	Lazio	Roma	RM	5176
IT	157	Roma	Lazio	Roma	RM	5177
IT	158	Roma	Lazio	Roma	RM	5178
IT	159	Roma	Lazio	Roma	RM	5179
IT	161	Roma	Lazio	Roma	RM	5180
IT	162	Roma	Lazio	Roma	RM	5181
IT	163	Roma	Lazio	Roma	RM	5182
IT	164	Roma	Lazio	Roma	RM	5183
IT	165	Roma	Lazio	Roma	RM	5184
IT	166	Borgata Casalotti	Lazio	Roma	RM	5185
IT	166	Roma	Lazio	Roma	RM	5186
IT	167	Roma	Lazio	Roma	RM	5187
IT	168	Roma	Lazio	Roma	RM	5188
IT	169	Torre Maura	Lazio	Roma	RM	5189
IT	169	Roma	Lazio	Roma	RM	5190
IT	169	Torre Spaccata	Lazio	Roma	RM	5191
IT	171	Roma	Lazio	Roma	RM	5192
IT	172	Roma	Lazio	Roma	RM	5193
IT	173	Roma	Lazio	Roma	RM	5194
IT	174	Roma	Lazio	Roma	RM	5195
IT	175	Roma	Lazio	Roma	RM	5196
IT	176	Roma	Lazio	Roma	RM	5197
IT	177	Roma	Lazio	Roma	RM	5198
IT	178	Capannelle	Lazio	Roma	RM	5199
IT	178	Torricola	Lazio	Roma	RM	5200
IT	178	Roma	Lazio	Roma	RM	5201
IT	179	Roma	Lazio	Roma	RM	5202
IT	181	Roma	Lazio	Roma	RM	5203
IT	182	Roma	Lazio	Roma	RM	5204
IT	183	Roma	Lazio	Roma	RM	5205
IT	184	Roma	Lazio	Roma	RM	5206
IT	185	Roma	Lazio	Roma	RM	5207
IT	186	Roma	Lazio	Roma	RM	5208
IT	187	Roma	Lazio	Roma	RM	5209
IT	188	Labaro	Lazio	Roma	RM	5210
IT	188	Prima Porta	Lazio	Roma	RM	5211
IT	188	Roma	Lazio	Roma	RM	5212
IT	189	Tomba Di Nerone	Lazio	Roma	RM	5213
IT	189	Roma	Lazio	Roma	RM	5214
IT	189	Grottarossa	Lazio	Roma	RM	5215
IT	191	Roma	Lazio	Roma	RM	5216
IT	192	Roma	Lazio	Roma	RM	5217
IT	193	Roma	Lazio	Roma	RM	5218
IT	194	Roma	Lazio	Roma	RM	5219
IT	195	Roma	Lazio	Roma	RM	5220
IT	196	Roma	Lazio	Roma	RM	5221
IT	197	Roma	Lazio	Roma	RM	5222
IT	198	Roma	Lazio	Roma	RM	5223
IT	199	Roma	Lazio	Roma	RM	5224
IT	1010	Capodimonte	Lazio	Viterbo	VT	5225
IT	1010	Oriolo Romano	Lazio	Viterbo	VT	5226
IT	1010	Onano	Lazio	Viterbo	VT	5227
IT	1010	Civitella Cesi	Lazio	Viterbo	VT	5228
IT	1010	Gradoli	Lazio	Viterbo	VT	5229
IT	1010	Vejano	Lazio	Viterbo	VT	5230
IT	1010	Latera	Lazio	Viterbo	VT	5231
IT	1010	Blera	Lazio	Viterbo	VT	5232
IT	1010	Marta	Lazio	Viterbo	VT	5233
IT	1010	Ischia Di Castro	Lazio	Viterbo	VT	5234
IT	1010	Villa San Giovanni In Tuscia	Lazio	Viterbo	VT	5235
IT	1010	Farnese	Lazio	Viterbo	VT	5236
IT	1010	Cellere	Lazio	Viterbo	VT	5237
IT	1010	Arlena Di Castro	Lazio	Viterbo	VT	5238
IT	1010	Barbarano Romano	Lazio	Viterbo	VT	5239
IT	1010	Tessennano	Lazio	Viterbo	VT	5240
IT	1010	Piansano	Lazio	Viterbo	VT	5241
IT	1010	Monte Romano	Lazio	Viterbo	VT	5242
IT	1011	Canino	Lazio	Viterbo	VT	5243
IT	1011	Musignano	Lazio	Viterbo	VT	5244
IT	1012	Capranica	Lazio	Viterbo	VT	5245
IT	1012	Vico Matrino	Lazio	Viterbo	VT	5246
IT	1014	Montalto Di Castro	Lazio	Viterbo	VT	5247
IT	1014	Pescia Romana	Lazio	Viterbo	VT	5248
IT	1015	Sutri	Lazio	Viterbo	VT	5249
IT	1016	Marina Velca	Lazio	Viterbo	VT	5250
IT	1016	Lido Di Tarquinia	Lazio	Viterbo	VT	5251
IT	1016	Tarquinia	Lazio	Viterbo	VT	5252
IT	1017	Tuscania	Lazio	Viterbo	VT	5253
IT	1018	Valentano	Lazio	Viterbo	VT	5254
IT	1019	Cura	Lazio	Viterbo	VT	5255
IT	1019	Vetralla	Lazio	Viterbo	VT	5256
IT	1019	La Botte	Lazio	Viterbo	VT	5257
IT	1019	Pietrara	Lazio	Viterbo	VT	5258
IT	1019	Giardino	Lazio	Viterbo	VT	5259
IT	1019	Tre Croci	Lazio	Viterbo	VT	5260
IT	1020	San Lorenzo Nuovo	Lazio	Viterbo	VT	5261
IT	1020	Celleno	Lazio	Viterbo	VT	5262
IT	1020	Graffignano	Lazio	Viterbo	VT	5263
IT	1020	Fastello	Lazio	Viterbo	VT	5264
IT	1020	Proceno	Lazio	Viterbo	VT	5265
IT	1020	Mugnano	Lazio	Viterbo	VT	5266
IT	1020	Sipicciano	Lazio	Viterbo	VT	5267
IT	1020	Roccalvecce	Lazio	Viterbo	VT	5268
IT	1020	Bomarzo	Lazio	Viterbo	VT	5269
IT	1020	San Michele In Teverina	Lazio	Viterbo	VT	5270
IT	1020	Lubriano	Lazio	Viterbo	VT	5271
IT	1020	Civitella D'Agliano	Lazio	Viterbo	VT	5272
IT	1020	Casenuove	Lazio	Viterbo	VT	5273
IT	1021	Acquapendente	Lazio	Viterbo	VT	5274
IT	1021	Trevinano	Lazio	Viterbo	VT	5275
IT	1021	Torre Alfina	Lazio	Viterbo	VT	5276
IT	1022	Castel Cellesi	Lazio	Viterbo	VT	5277
IT	1022	Bagnoregio	Lazio	Viterbo	VT	5278
IT	1022	Vetriolo	Lazio	Viterbo	VT	5279
IT	1022	Civita	Lazio	Viterbo	VT	5280
IT	1023	Bolsena	Lazio	Viterbo	VT	5281
IT	1024	Sermugnano	Lazio	Viterbo	VT	5282
IT	1024	Castiglione In Teverina	Lazio	Viterbo	VT	5283
IT	1025	Grotte Di Castro	Lazio	Viterbo	VT	5284
IT	1026	Grotte Santo Stefano	Lazio	Viterbo	VT	5285
IT	1026	Magugnano	Lazio	Viterbo	VT	5286
IT	1027	Zepponami	Lazio	Viterbo	VT	5287
IT	1027	Montefiascone	Lazio	Viterbo	VT	5288
IT	1027	Le Mosse	Lazio	Viterbo	VT	5289
IT	1028	Orte Stazione	Lazio	Viterbo	VT	5290
IT	1028	Orte	Lazio	Viterbo	VT	5291
IT	1028	Orte Scalo	Lazio	Viterbo	VT	5292
IT	1030	Monterosi	Lazio	Viterbo	VT	5293
IT	1030	Corchiano	Lazio	Viterbo	VT	5294
IT	1030	Vasanello	Lazio	Viterbo	VT	5295
IT	1030	Calcata Nuova	Lazio	Viterbo	VT	5296
IT	1030	Faleria	Lazio	Viterbo	VT	5297
IT	1030	Calcata	Lazio	Viterbo	VT	5298
IT	1030	Carbognano	Lazio	Viterbo	VT	5299
IT	1030	Castel Sant'Elia	Lazio	Viterbo	VT	5300
IT	1030	Vallerano	Lazio	Viterbo	VT	5301
IT	1030	Bassano In Teverina	Lazio	Viterbo	VT	5302
IT	1030	Canepina	Lazio	Viterbo	VT	5303
IT	1030	Vitorchiano	Lazio	Viterbo	VT	5304
IT	1030	Bassano Romano	Lazio	Viterbo	VT	5305
IT	1030	Vitorchiano Stazione	Lazio	Viterbo	VT	5306
IT	1032	Caprarola	Lazio	Viterbo	VT	5307
IT	1033	Borghetto	Lazio	Viterbo	VT	5308
IT	1033	Borghetto Di Civita Castellana Stazione	Lazio	Viterbo	VT	5309
IT	1033	Civita Castellana	Lazio	Viterbo	VT	5310
IT	1033	Civita Castellana Stazione	Lazio	Viterbo	VT	5311
IT	1034	Regolelli	Lazio	Viterbo	VT	5312
IT	1034	Fabrica Di Roma	Lazio	Viterbo	VT	5313
IT	1035	Gallese	Lazio	Viterbo	VT	5314
IT	1035	Scalo Teverina	Lazio	Viterbo	VT	5315
IT	1036	Nepi	Lazio	Viterbo	VT	5316
IT	1037	Ronciglione	Lazio	Viterbo	VT	5317
IT	1037	Lago Di Vico	Lazio	Viterbo	VT	5318
IT	1038	Soriano Nel Cimino	Lazio	Viterbo	VT	5319
IT	1038	Chia	Lazio	Viterbo	VT	5320
IT	1039	Vignanello	Lazio	Viterbo	VT	5321
IT	1100	Viterbo	Lazio	Viterbo	VT	5322
IT	1100	Bagnaia	Lazio	Viterbo	VT	5323
IT	1100	La Quercia	Lazio	Viterbo	VT	5324
IT	1100	Tobia	Lazio	Viterbo	VT	5325
IT	1100	San Martino Al Cimino	Lazio	Viterbo	VT	5326
IT	16010	Mele	Liguria	Genova	GE	5327
IT	16010	Vobbia	Liguria	Genova	GE	5328
IT	16010	Ponte Di Savignone	Liguria	Genova	GE	5329
IT	16010	Pedemonte	Liguria	Genova	GE	5330
IT	16010	Rossiglione	Liguria	Genova	GE	5331
IT	16010	Savignone	Liguria	Genova	GE	5332
IT	16010	Carsi	Liguria	Genova	GE	5333
IT	16010	Tiglieto	Liguria	Genova	GE	5334
IT	16010	Prelo	Liguria	Genova	GE	5335
IT	16010	Acquasanta	Liguria	Genova	GE	5336
IT	16010	Masone	Liguria	Genova	GE	5337
IT	16010	Crocefieschi	Liguria	Genova	GE	5338
IT	16010	Castagna	Liguria	Genova	GE	5339
IT	16010	Manesseno	Liguria	Genova	GE	5340
IT	16010	Piccarello	Liguria	Genova	GE	5341
IT	16010	Serra Ricco'	Liguria	Genova	GE	5342
IT	16010	Valbrevenna	Liguria	Genova	GE	5343
IT	16010	Isorelle	Liguria	Genova	GE	5344
IT	16010	Orero Di Serra Ricco'	Liguria	Genova	GE	5345
IT	16010	Sant'Olcese	Liguria	Genova	GE	5346
IT	16010	Mainetto	Liguria	Genova	GE	5347
IT	16011	Arenzano	Liguria	Genova	GE	5348
IT	16011	Pineta Di Arenzano	Liguria	Genova	GE	5349
IT	16012	Camarza	Liguria	Genova	GE	5350
IT	16012	Busalla	Liguria	Genova	GE	5351
IT	16012	Sarissola	Liguria	Genova	GE	5352
IT	16013	Campo Ligure	Liguria	Genova	GE	5353
IT	16014	Langasco	Liguria	Genova	GE	5354
IT	16014	Guardia	Liguria	Genova	GE	5355
IT	16014	Ceranesi	Liguria	Genova	GE	5356
IT	16014	Pontasso	Liguria	Genova	GE	5357
IT	16014	Santuario Della Guardia	Liguria	Genova	GE	5358
IT	16014	Isoverde	Liguria	Genova	GE	5359
IT	16014	Campomorone	Liguria	Genova	GE	5360
IT	16014	Geo	Liguria	Genova	GE	5361
IT	16014	Ferriera	Liguria	Genova	GE	5362
IT	16015	Orero	Liguria	Genova	GE	5363
IT	16015	Casella	Liguria	Genova	GE	5364
IT	16016	Lerca	Liguria	Genova	GE	5365
IT	16016	Sciarborasca	Liguria	Genova	GE	5366
IT	16016	Cogoleto	Liguria	Genova	GE	5367
IT	16017	Isola Del Cantone	Liguria	Genova	GE	5368
IT	16018	Giovi	Liguria	Genova	GE	5369
IT	16018	Mignanego	Liguria	Genova	GE	5370
IT	16019	Ronco Scrivia	Liguria	Genova	GE	5371
IT	16019	Borgo Fornari	Liguria	Genova	GE	5372
IT	16019	Pieve	Liguria	Genova	GE	5373
IT	16020	Fontanarossa	Liguria	Genova	GE	5374
IT	16020	Gorreto	Liguria	Genova	GE	5375
IT	16020	Cassingheno	Liguria	Genova	GE	5376
IT	16020	Fascia	Liguria	Genova	GE	5377
IT	16021	Bargagli	Liguria	Genova	GE	5378
IT	16022	Davagna	Liguria	Genova	GE	5379
IT	16022	Moranego	Liguria	Genova	GE	5380
IT	16022	Scoffera	Liguria	Genova	GE	5381
IT	16022	Meco	Liguria	Genova	GE	5382
IT	16023	Casoni	Liguria	Genova	GE	5383
IT	16023	Canale Fontanigorda	Liguria	Genova	GE	5384
IT	16023	Fontanigorda	Liguria	Genova	GE	5385
IT	16023	Canale	Liguria	Genova	GE	5386
IT	16024	Lumarzo	Liguria	Genova	GE	5387
IT	16025	Montebruno	Liguria	Genova	GE	5388
IT	16025	Ponte Trebbia	Liguria	Genova	GE	5389
IT	16025	Rondanina	Liguria	Genova	GE	5390
IT	16026	Montoggio	Liguria	Genova	GE	5391
IT	16026	Trefontane	Liguria	Genova	GE	5392
IT	16027	Propata	Liguria	Genova	GE	5393
IT	16028	Rovegno	Liguria	Genova	GE	5394
IT	16028	Casanova	Liguria	Genova	GE	5395
IT	16029	Torriglia	Liguria	Genova	GE	5396
IT	16029	Fascia Di Carlo	Liguria	Genova	GE	5397
IT	16029	Laccio	Liguria	Genova	GE	5398
IT	16030	Zoagli	Liguria	Genova	GE	5399
IT	16030	Casarza Ligure	Liguria	Genova	GE	5400
IT	16030	Avegno	Liguria	Genova	GE	5401
IT	16030	Sant'Anna	Liguria	Genova	GE	5402
IT	16030	Pieve Ligure	Liguria	Genova	GE	5403
IT	16030	San Salvatore	Liguria	Genova	GE	5404
IT	16030	Moneglia	Liguria	Genova	GE	5405
IT	16030	Bargone	Liguria	Genova	GE	5406
IT	16030	Cogorno	Liguria	Genova	GE	5407
IT	16030	Capreno	Liguria	Genova	GE	5408
IT	16030	Castiglione Chiavarese	Liguria	Genova	GE	5409
IT	16030	Sori	Liguria	Genova	GE	5410
IT	16030	Tribogna	Liguria	Genova	GE	5411
IT	16030	Testana	Liguria	Genova	GE	5412
IT	16030	Canepa	Liguria	Genova	GE	5413
IT	16030	Velva	Liguria	Genova	GE	5414
IT	16030	Uscio	Liguria	Genova	GE	5415
IT	16030	Colonia Arnaldi	Liguria	Genova	GE	5416
IT	16031	Bogliasco	Liguria	Genova	GE	5417
IT	16031	San Bernardo	Liguria	Genova	GE	5418
IT	16031	Poggio Favaro	Liguria	Genova	GE	5419
IT	16032	San Rocco Di Camogli	Liguria	Genova	GE	5420
IT	16032	Camogli	Liguria	Genova	GE	5421
IT	16032	San Rocco	Liguria	Genova	GE	5422
IT	16032	Ruta	Liguria	Genova	GE	5423
IT	16032	San Fruttuoso	Liguria	Genova	GE	5424
IT	16032	San Fruttuoso Di Camogli	Liguria	Genova	GE	5425
IT	16033	Cavi	Liguria	Genova	GE	5426
IT	16033	Lavagna	Liguria	Genova	GE	5427
IT	16034	Portofino	Liguria	Genova	GE	5428
IT	16035	San Michele Di Pagana	Liguria	Genova	GE	5429
IT	16035	Rapallo	Liguria	Genova	GE	5430
IT	16035	San Massimo	Liguria	Genova	GE	5431
IT	16036	Recco	Liguria	Genova	GE	5432
IT	16038	San Lorenzo Della Costa	Liguria	Genova	GE	5433
IT	16038	Paraggi	Liguria	Genova	GE	5434
IT	16038	Santa Margherita Ligure	Liguria	Genova	GE	5435
IT	16039	Riva Trigoso	Liguria	Genova	GE	5436
IT	16039	Santa Vittoria Di Libiola	Liguria	Genova	GE	5437
IT	16039	Sestri Levante	Liguria	Genova	GE	5438
IT	16039	Pila Sul Gromolo	Liguria	Genova	GE	5439
IT	16040	Pian Dei Ratti	Liguria	Genova	GE	5440
IT	16040	Roccatagliata	Liguria	Genova	GE	5441
IT	16040	Statale	Liguria	Genova	GE	5442
IT	16040	Reppia	Liguria	Genova	GE	5443
IT	16040	Ne	Liguria	Genova	GE	5444
IT	16040	Piandifieno	Liguria	Genova	GE	5445
IT	16040	Coreglia Ligure	Liguria	Genova	GE	5446
IT	16040	Ognio	Liguria	Genova	GE	5447
IT	16040	Leivi	Liguria	Genova	GE	5448
IT	16040	Favale Di Malvaro	Liguria	Genova	GE	5449
IT	16040	Conscenti	Liguria	Genova	GE	5450
IT	16040	Isolona	Liguria	Genova	GE	5451
IT	16040	San Colombano Certenoli	Liguria	Genova	GE	5452
IT	16040	Orero	Liguria	Genova	GE	5453
IT	16040	Calvari	Liguria	Genova	GE	5454
IT	16040	Celesia	Liguria	Genova	GE	5455
IT	16040	Neirone	Liguria	Genova	GE	5456
IT	16041	Borzonasca	Liguria	Genova	GE	5457
IT	16041	Giaiette	Liguria	Genova	GE	5458
IT	16041	Bertigaro	Liguria	Genova	GE	5459
IT	16041	Brizzolara	Liguria	Genova	GE	5460
IT	16041	Prato Sopralacroce	Liguria	Genova	GE	5461
IT	16042	Graveglia	Liguria	Genova	GE	5462
IT	16042	Carasco	Liguria	Genova	GE	5463
IT	16042	Rivarola	Liguria	Genova	GE	5464
IT	16043	Chiavari	Liguria	Genova	GE	5465
IT	16043	Sant'Andrea Di Rovereto	Liguria	Genova	GE	5466
IT	16043	Caperana	Liguria	Genova	GE	5467
IT	16044	Cicagna	Liguria	Genova	GE	5468
IT	16044	Monleone	Liguria	Genova	GE	5469
IT	16045	Lorsica	Liguria	Genova	GE	5470
IT	16046	Borgonovo Ligure	Liguria	Genova	GE	5471
IT	16046	Borgonovo	Liguria	Genova	GE	5472
IT	16046	Mezzanego	Liguria	Genova	GE	5473
IT	16046	Passo Del Bocco	Liguria	Genova	GE	5474
IT	16047	Gattorna	Liguria	Genova	GE	5475
IT	16047	Moconesi	Liguria	Genova	GE	5476
IT	16047	Ferrada	Liguria	Genova	GE	5477
IT	16048	Magnasco	Liguria	Genova	GE	5478
IT	16048	Alpepiana	Liguria	Genova	GE	5479
IT	16048	Priosa	Liguria	Genova	GE	5480
IT	16048	Parazzuolo	Liguria	Genova	GE	5481
IT	16048	Rezzoaglio	Liguria	Genova	GE	5482
IT	16048	Cabanne	Liguria	Genova	GE	5483
IT	16049	Allegrezze	Liguria	Genova	GE	5484
IT	16049	Santo Stefano D'Aveto	Liguria	Genova	GE	5485
IT	16049	Amborzasco	Liguria	Genova	GE	5486
IT	16100	Genova	Liguria	Genova	GE	5487
IT	16121	Genova	Liguria	Genova	GE	5488
IT	16122	Genova	Liguria	Genova	GE	5489
IT	16123	Genova	Liguria	Genova	GE	5490
IT	16124	Genova	Liguria	Genova	GE	5491
IT	16125	Genova	Liguria	Genova	GE	5492
IT	16126	Genova	Liguria	Genova	GE	5493
IT	16127	Genova	Liguria	Genova	GE	5494
IT	16128	Genova	Liguria	Genova	GE	5495
IT	16129	Genova	Liguria	Genova	GE	5496
IT	16131	Genova	Liguria	Genova	GE	5497
IT	16132	Genova	Liguria	Genova	GE	5498
IT	16133	San Desiderio	Liguria	Genova	GE	5499
IT	16133	Bavari	Liguria	Genova	GE	5500
IT	16133	Genova	Liguria	Genova	GE	5501
IT	16133	Apparizione	Liguria	Genova	GE	5502
IT	16134	Genova	Liguria	Genova	GE	5503
IT	16135	Genova	Liguria	Genova	GE	5504
IT	16136	Genova	Liguria	Genova	GE	5505
IT	16137	Staglieno	Liguria	Genova	GE	5506
IT	16137	Genova	Liguria	Genova	GE	5507
IT	16138	Molassana	Liguria	Genova	GE	5508
IT	16138	Genova	Liguria	Genova	GE	5509
IT	16139	Genova	Liguria	Genova	GE	5510
IT	16141	Sant'Eusebio	Liguria	Genova	GE	5511
IT	16141	Genova	Liguria	Genova	GE	5512
IT	16142	Genova	Liguria	Genova	GE	5513
IT	16143	Genova	Liguria	Genova	GE	5514
IT	16144	Genova	Liguria	Genova	GE	5515
IT	16145	Genova	Liguria	Genova	GE	5516
IT	16146	Genova	Liguria	Genova	GE	5517
IT	16147	Sturla	Liguria	Genova	GE	5518
IT	16147	Genova	Liguria	Genova	GE	5519
IT	16148	Quarto Dei Mille	Liguria	Genova	GE	5520
IT	16148	Genova	Liguria	Genova	GE	5521
IT	16149	Sampierdarena	Liguria	Genova	GE	5522
IT	16149	Genova	Liguria	Genova	GE	5523
IT	16151	Campasso	Liguria	Genova	GE	5524
IT	16151	Genova	Liguria	Genova	GE	5525
IT	16152	Cornigliano Ligure	Liguria	Genova	GE	5526
IT	16152	Coronata	Liguria	Genova	GE	5527
IT	16152	Genova	Liguria	Genova	GE	5528
IT	16153	Borzoli	Liguria	Genova	GE	5529
IT	16153	Genova	Liguria	Genova	GE	5530
IT	16154	San Giovanni Battista	Liguria	Genova	GE	5531
IT	16154	Genova	Liguria	Genova	GE	5532
IT	16154	Sestri Ponente	Liguria	Genova	GE	5533
IT	16155	Pegli	Liguria	Genova	GE	5534
IT	16155	Multedo	Liguria	Genova	GE	5535
IT	16155	Genova	Liguria	Genova	GE	5536
IT	16156	Genova	Liguria	Genova	GE	5537
IT	16157	Palmaro Di Pra'	Liguria	Genova	GE	5538
IT	16157	Genova	Liguria	Genova	GE	5539
IT	16157	Pra'	Liguria	Genova	GE	5540
IT	16158	Genova	Liguria	Genova	GE	5541
IT	16158	Voltri	Liguria	Genova	GE	5542
IT	16158	Fabbriche	Liguria	Genova	GE	5543
IT	16159	Rivarolo Ligure	Liguria	Genova	GE	5544
IT	16159	Genova	Liguria	Genova	GE	5545
IT	16159	Certosa Di Rivarolo Ligure	Liguria	Genova	GE	5546
IT	16161	Fegino	Liguria	Genova	GE	5547
IT	16161	Teglia	Liguria	Genova	GE	5548
IT	16161	Genova	Liguria	Genova	GE	5549
IT	16162	Genova	Liguria	Genova	GE	5550
IT	16162	Bolzaneto	Liguria	Genova	GE	5551
IT	16163	San Quirico In Val Polcevera	Liguria	Genova	GE	5552
IT	16163	Genova	Liguria	Genova	GE	5553
IT	16164	Pontedecimo	Liguria	Genova	GE	5554
IT	16164	Genova	Liguria	Genova	GE	5555
IT	16165	Struppa	Liguria	Genova	GE	5556
IT	16165	Genova	Liguria	Genova	GE	5557
IT	16166	Quinto Al Mare	Liguria	Genova	GE	5558
IT	16166	Genova	Liguria	Genova	GE	5559
IT	16167	Nervi	Liguria	Genova	GE	5560
IT	16167	Sant'Ilario Ligure	Liguria	Genova	GE	5561
IT	16167	Genova	Liguria	Genova	GE	5562
IT	18010	Triora	Liguria	Imperia	IM	5563
IT	18010	Carpasio	Liguria	Imperia	IM	5564
IT	18010	Riva Faraldi	Liguria	Imperia	IM	5565
IT	18010	Boscomare	Liguria	Imperia	IM	5566
IT	18010	Badalucco	Liguria	Imperia	IM	5567
IT	18010	Montalto Ligure	Liguria	Imperia	IM	5568
IT	18010	Santo Stefano Al Mare	Liguria	Imperia	IM	5569
IT	18010	Villa Faraldi	Liguria	Imperia	IM	5570
IT	18010	Terzorio	Liguria	Imperia	IM	5571
IT	18010	Molini Di Triora	Liguria	Imperia	IM	5572
IT	18010	Cervo	Liguria	Imperia	IM	5573
IT	18010	Agaggio Inferiore	Liguria	Imperia	IM	5574
IT	18010	Pietrabruna	Liguria	Imperia	IM	5575
IT	18011	Castellaro	Liguria	Imperia	IM	5576
IT	18012	Bordighera	Liguria	Imperia	IM	5577
IT	18012	Borghetto San Nicolo'	Liguria	Imperia	IM	5578
IT	18012	Seborga	Liguria	Imperia	IM	5579
IT	18012	Piani Di Borghetto	Liguria	Imperia	IM	5580
IT	18012	Vallebona	Liguria	Imperia	IM	5581
IT	18012	Bordighera Alta	Liguria	Imperia	IM	5582
IT	18013	Diano San Pietro	Liguria	Imperia	IM	5583
IT	18013	Diano Arentino	Liguria	Imperia	IM	5584
IT	18013	Diano Marina	Liguria	Imperia	IM	5585
IT	18013	Diano Castello	Liguria	Imperia	IM	5586
IT	18014	Ospedaletti	Liguria	Imperia	IM	5587
IT	18015	Riva Ligure	Liguria	Imperia	IM	5588
IT	18015	Pompeiana	Liguria	Imperia	IM	5589
IT	18016	San Bartolomeo Al Mare	Liguria	Imperia	IM	5590
IT	18017	Civezza	Liguria	Imperia	IM	5591
IT	18017	Lingueglietta	Liguria	Imperia	IM	5592
IT	18017	San Lorenzo Al Mare	Liguria	Imperia	IM	5593
IT	18017	Costarainera	Liguria	Imperia	IM	5594
IT	18017	Cipressa	Liguria	Imperia	IM	5595
IT	18018	Arma Di Taggia	Liguria	Imperia	IM	5596
IT	18018	Taggia	Liguria	Imperia	IM	5597
IT	18019	Vallecrosia	Liguria	Imperia	IM	5598
IT	18019	Vallecrosia Alta	Liguria	Imperia	IM	5599
IT	18020	Lucinasco	Liguria	Imperia	IM	5600
IT	18020	Aquila Di Arroscia	Liguria	Imperia	IM	5601
IT	18020	Caravonica	Liguria	Imperia	IM	5602
IT	18020	Borghetto D'Arroscia	Liguria	Imperia	IM	5603
IT	18020	Dolcedo	Liguria	Imperia	IM	5604
IT	18020	Vasia	Liguria	Imperia	IM	5605
IT	18020	Aurigo	Liguria	Imperia	IM	5606
IT	18020	Prela'	Liguria	Imperia	IM	5607
IT	18020	Ranzo	Liguria	Imperia	IM	5608
IT	18021	Borgomaro	Liguria	Imperia	IM	5609
IT	18022	Cesio	Liguria	Imperia	IM	5610
IT	18022	Arzeno D'Oneglia	Liguria	Imperia	IM	5611
IT	18022	Cartari	Liguria	Imperia	IM	5612
IT	18023	Cosio Di Arroscia	Liguria	Imperia	IM	5613
IT	18024	Nava	Liguria	Imperia	IM	5614
IT	18024	Pornassio	Liguria	Imperia	IM	5615
IT	18024	Case Di Nava	Liguria	Imperia	IM	5616
IT	18025	Montegrosso Pian Latte	Liguria	Imperia	IM	5617
IT	18025	Mendatica	Liguria	Imperia	IM	5618
IT	18026	Cenova	Liguria	Imperia	IM	5619
IT	18026	Calderara	Liguria	Imperia	IM	5620
IT	18026	Vessalico	Liguria	Imperia	IM	5621
IT	18026	Rezzo	Liguria	Imperia	IM	5622
IT	18026	Pieve Di Teco	Liguria	Imperia	IM	5623
IT	18026	Armo	Liguria	Imperia	IM	5624
IT	18027	Chiusavecchia	Liguria	Imperia	IM	5625
IT	18027	Chiusanico	Liguria	Imperia	IM	5626
IT	18027	Pontedassio	Liguria	Imperia	IM	5627
IT	18030	Airole	Liguria	Imperia	IM	5628
IT	18030	Rocchetta Nervina	Liguria	Imperia	IM	5629
IT	18030	Olivetta San Michele	Liguria	Imperia	IM	5630
IT	18030	Castel Vittorio	Liguria	Imperia	IM	5631
IT	18031	Bajardo	Liguria	Imperia	IM	5632
IT	18032	Perinaldo	Liguria	Imperia	IM	5633
IT	18033	Camporosso	Liguria	Imperia	IM	5634
IT	18033	Camporosso Mare	Liguria	Imperia	IM	5635
IT	18034	Ceriana	Liguria	Imperia	IM	5636
IT	18035	Dolceacqua	Liguria	Imperia	IM	5637
IT	18035	Isolabona	Liguria	Imperia	IM	5638
IT	18035	Apricale	Liguria	Imperia	IM	5639
IT	18036	San Biagio Della Cima	Liguria	Imperia	IM	5640
IT	18036	Soldano	Liguria	Imperia	IM	5641
IT	18037	Pigna	Liguria	Imperia	IM	5642
IT	18038	San Romolo	Liguria	Imperia	IM	5643
IT	18038	Verezzo	Liguria	Imperia	IM	5644
IT	18038	Bussana	Liguria	Imperia	IM	5645
IT	18038	Borello	Liguria	Imperia	IM	5646
IT	18038	San Bartolomeo	Liguria	Imperia	IM	5647
IT	18038	Coldirodi	Liguria	Imperia	IM	5648
IT	18038	San Giacomo	Liguria	Imperia	IM	5649
IT	18038	San Remo	Liguria	Imperia	IM	5650
IT	18038	Poggio	Liguria	Imperia	IM	5651
IT	18039	Roverino	Liguria	Imperia	IM	5652
IT	18039	Trucco	Liguria	Imperia	IM	5653
IT	18039	Grimaldi	Liguria	Imperia	IM	5654
IT	18039	Latte	Liguria	Imperia	IM	5655
IT	18039	Torri	Liguria	Imperia	IM	5656
IT	18039	Ventimiglia	Liguria	Imperia	IM	5657
IT	18039	Calvo	Liguria	Imperia	IM	5658
IT	18039	Grimaldi Di Ventimiglia	Liguria	Imperia	IM	5659
IT	18039	Bevera	Liguria	Imperia	IM	5660
IT	18039	Sant'Antonio	Liguria	Imperia	IM	5661
IT	18039	Sealza	Liguria	Imperia	IM	5662
IT	18100	Oneglia	Liguria	Imperia	IM	5663
IT	18100	Porto Maurizio	Liguria	Imperia	IM	5664
IT	18100	Vasia	Liguria	Imperia	IM	5665
IT	18100	Imperia	Liguria	Imperia	IM	5666
IT	18100	Prela'	Liguria	Imperia	IM	5667
IT	18100	Dolcedo	Liguria	Imperia	IM	5668
IT	18100	Caramagna Ligure	Liguria	Imperia	IM	5669
IT	18100	Castelvecchio Di Santa Maria Maggiore	Liguria	Imperia	IM	5670
IT	18100	Borgo Primo	Liguria	Imperia	IM	5671
IT	19010	Torza	Liguria	La Spezia	SP	5672
IT	19010	Maissana	Liguria	La Spezia	SP	5673
IT	19011	Bonassola	Liguria	La Spezia	SP	5674
IT	19012	Carro	Liguria	La Spezia	SP	5675
IT	19012	Castello	Liguria	La Spezia	SP	5676
IT	19013	Deiva Marina	Liguria	La Spezia	SP	5677
IT	19014	Framura	Liguria	La Spezia	SP	5678
IT	19015	Levanto	Liguria	La Spezia	SP	5679
IT	19015	Montale	Liguria	La Spezia	SP	5680
IT	19016	Monterosso Al Mare	Liguria	La Spezia	SP	5681
IT	19017	Manarola	Liguria	La Spezia	SP	5682
IT	19017	Riomaggiore	Liguria	La Spezia	SP	5683
IT	19018	Corniglia	Liguria	La Spezia	SP	5684
IT	19018	Vernazza	Liguria	La Spezia	SP	5685
IT	19020	Beverino	Liguria	La Spezia	SP	5686
IT	19020	Bolano	Liguria	La Spezia	SP	5687
IT	19020	Carpena	Liguria	La Spezia	SP	5688
IT	19020	Pignone	Liguria	La Spezia	SP	5689
IT	19020	Ceparana	Liguria	La Spezia	SP	5690
IT	19020	Piano Di Follo	Liguria	La Spezia	SP	5691
IT	19020	Fornola	Liguria	La Spezia	SP	5692
IT	19020	Tivegna	Liguria	La Spezia	SP	5693
IT	19020	Bastremoli	Liguria	La Spezia	SP	5694
IT	19020	Vezzano Ligure	Liguria	La Spezia	SP	5695
IT	19020	Ricco' Del Golfo Di Spezia	Liguria	La Spezia	SP	5696
IT	19020	Follo	Liguria	La Spezia	SP	5697
IT	19020	Calice Al Cornoviglio	Liguria	La Spezia	SP	5698
IT	19020	Valeriano	Liguria	La Spezia	SP	5699
IT	19020	San Benedetto	Liguria	La Spezia	SP	5700
IT	19020	Piana Battolla	Liguria	La Spezia	SP	5701
IT	19020	Cavanella Vara	Liguria	La Spezia	SP	5702
IT	19020	Ponzo'	Liguria	La Spezia	SP	5703
IT	19020	Brugnato	Liguria	La Spezia	SP	5704
IT	19020	Padivarma	Liguria	La Spezia	SP	5705
IT	19020	Piano Di Valeriano	Liguria	La Spezia	SP	5706
IT	19020	Mattarana	Liguria	La Spezia	SP	5707
IT	19020	Rocchetta Di Vara	Liguria	La Spezia	SP	5708
IT	19020	Borghetto Di Vara	Liguria	La Spezia	SP	5709
IT	19020	Zignago	Liguria	La Spezia	SP	5710
IT	19020	Sesta Godano	Liguria	La Spezia	SP	5711
IT	19020	Bottagna	Liguria	La Spezia	SP	5712
IT	19020	Suvero	Liguria	La Spezia	SP	5713
IT	19020	Pieve Di Zignago	Liguria	La Spezia	SP	5714
IT	19020	Carrodano	Liguria	La Spezia	SP	5715
IT	19020	Veppo	Liguria	La Spezia	SP	5716
IT	19020	Prati	Liguria	La Spezia	SP	5717
IT	19020	Valdurasca	Liguria	La Spezia	SP	5718
IT	19020	Ponzo' Bovecchio	Liguria	La Spezia	SP	5719
IT	19020	San Martino Di Durasca	Liguria	La Spezia	SP	5720
IT	19020	Madonna Di Buonviaggio	Liguria	La Spezia	SP	5721
IT	19021	Arcola	Liguria	La Spezia	SP	5722
IT	19021	Romito Magra	Liguria	La Spezia	SP	5723
IT	19025	Portovenere	Liguria	La Spezia	SP	5724
IT	19025	Fezzano	Liguria	La Spezia	SP	5725
IT	19025	Le Grazie	Liguria	La Spezia	SP	5726
IT	19025	Le Grazie Varignano	Liguria	La Spezia	SP	5727
IT	19025	Isola Palmaria	Liguria	La Spezia	SP	5728
IT	19028	Varese Ligure	Liguria	La Spezia	SP	5729
IT	19028	Comuneglia	Liguria	La Spezia	SP	5730
IT	19028	Scurtabo'	Liguria	La Spezia	SP	5731
IT	19028	San Pietro Vara	Liguria	La Spezia	SP	5732
IT	19028	Porciorasco	Liguria	La Spezia	SP	5733
IT	19030	Fiumaretta	Liguria	La Spezia	SP	5734
IT	19031	Ameglia	Liguria	La Spezia	SP	5735
IT	19031	Bocca Di Magra	Liguria	La Spezia	SP	5736
IT	19031	Fiumaretta Di Ameglia	Liguria	La Spezia	SP	5737
IT	19031	Montemarcello	Liguria	La Spezia	SP	5738
IT	19032	San Terenzo	Liguria	La Spezia	SP	5739
IT	19032	Lerici	Liguria	La Spezia	SP	5740
IT	19032	Tellaro	Liguria	La Spezia	SP	5741
IT	19032	Serra	Liguria	La Spezia	SP	5742
IT	19032	Pugliola	Liguria	La Spezia	SP	5743
IT	19032	Fiascherino	Liguria	La Spezia	SP	5744
IT	19033	Castelnuovo Magra	Liguria	La Spezia	SP	5745
IT	19033	Molicciara	Liguria	La Spezia	SP	5746
IT	19033	Colombiera	Liguria	La Spezia	SP	5747
IT	19034	Dogana	Liguria	La Spezia	SP	5748
IT	19034	Luni	Liguria	La Spezia	SP	5749
IT	19034	Luni Mare	Liguria	La Spezia	SP	5750
IT	19034	Isola Di Ortonovo	Liguria	La Spezia	SP	5751
IT	19034	Ortonovo	Liguria	La Spezia	SP	5752
IT	19034	Nicola	Liguria	La Spezia	SP	5753
IT	19034	Casano	Liguria	La Spezia	SP	5754
IT	19034	Serravalle	Liguria	La Spezia	SP	5755
IT	19037	Ponzano Magra	Liguria	La Spezia	SP	5756
IT	19037	Santo Stefano Di Magra	Liguria	La Spezia	SP	5757
IT	19037	Ponzano Superiore	Liguria	La Spezia	SP	5758
IT	19038	Falcinello	Liguria	La Spezia	SP	5759
IT	19038	Marinella	Liguria	La Spezia	SP	5760
IT	19038	Marinella Di Sarzana	Liguria	La Spezia	SP	5761
IT	19038	Sarzanello	Liguria	La Spezia	SP	5762
IT	19038	Sarzana	Liguria	La Spezia	SP	5763
IT	19038	San Lazzaro	Liguria	La Spezia	SP	5764
IT	19038	Santa Caterina	Liguria	La Spezia	SP	5765
IT	19100	La Spezia	Liguria	La Spezia	SP	5766
IT	19121	Laspezia	Liguria	La Spezia	SP	5767
IT	19122	Laspezia	Liguria	La Spezia	SP	5768
IT	19123	Pegazzano	Liguria	La Spezia	SP	5769
IT	19123	Chiappa	Liguria	La Spezia	SP	5770
IT	19123	Laspezia	Liguria	La Spezia	SP	5771
IT	19123	Fabiano	Liguria	La Spezia	SP	5772
IT	19124	La Spezia	Liguria	La Spezia	SP	5773
IT	19124	Laspezia	Liguria	La Spezia	SP	5774
IT	19125	Migliarina	Liguria	La Spezia	SP	5775
IT	19125	Laspezia	Liguria	La Spezia	SP	5776
IT	19126	Isola	Liguria	La Spezia	SP	5777
IT	19126	Laspezia	Liguria	La Spezia	SP	5778
IT	19131	Laspezia	Liguria	La Spezia	SP	5779
IT	19131	Cadimare	Liguria	La Spezia	SP	5780
IT	19132	Campiglia	Liguria	La Spezia	SP	5781
IT	19132	Marola	Liguria	La Spezia	SP	5782
IT	19132	Laspezia	Liguria	La Spezia	SP	5783
IT	19133	Biassa	Liguria	La Spezia	SP	5784
IT	19133	Laspezia	Liguria	La Spezia	SP	5785
IT	19134	La Foce	Liguria	La Spezia	SP	5786
IT	19134	Laspezia	Liguria	La Spezia	SP	5787
IT	19134	Marinasco	Liguria	La Spezia	SP	5788
IT	19135	San Venerio	Liguria	La Spezia	SP	5789
IT	19135	Laspezia	Liguria	La Spezia	SP	5790
IT	19136	Termo	Liguria	La Spezia	SP	5791
IT	19136	Laspezia	Liguria	La Spezia	SP	5792
IT	19136	Melara	Liguria	La Spezia	SP	5793
IT	19136	Limone	Liguria	La Spezia	SP	5794
IT	19137	Pitelli	Liguria	La Spezia	SP	5795
IT	19137	Laspezia	Liguria	La Spezia	SP	5796
IT	19138	San Bartolomeo	Liguria	La Spezia	SP	5797
IT	19138	Laspezia	Liguria	La Spezia	SP	5798
IT	19139	Muggiano	Liguria	La Spezia	SP	5799
IT	19139	Laspezia	Liguria	La Spezia	SP	5800
IT	12071	Massimino	Liguria	Savona	SV	5801
IT	17010	Osiglia	Liguria	Savona	SV	5802
IT	17010	Giusvalla	Liguria	Savona	SV	5803
IT	17011	Albisola Superiore	Liguria	Savona	SV	5804
IT	17011	Ellera	Liguria	Savona	SV	5805
IT	17011	Albisola Capo	Liguria	Savona	SV	5806
IT	17012	Albissola Marina	Liguria	Savona	SV	5807
IT	17013	Piano	Liguria	Savona	SV	5808
IT	17013	Murialdo	Liguria	Savona	SV	5809
IT	17013	Valle	Liguria	Savona	SV	5810
IT	17013	Valle Di Murialdo	Liguria	Savona	SV	5811
IT	17014	Cairo Montenotte	Liguria	Savona	SV	5812
IT	17014	San Giuseppe	Liguria	Savona	SV	5813
IT	17014	Ferrania	Liguria	Savona	SV	5814
IT	17014	Rocchetta Cairo	Liguria	Savona	SV	5815
IT	17014	San Giuseppe Di Cairo	Liguria	Savona	SV	5816
IT	17014	Bragno	Liguria	Savona	SV	5817
IT	17015	Celle Ligure	Liguria	Savona	SV	5818
IT	17017	Millesimo	Liguria	Savona	SV	5819
IT	17017	Cosseria	Liguria	Savona	SV	5820
IT	17017	Roccavignale	Liguria	Savona	SV	5821
IT	17019	Pero	Liguria	Savona	SV	5822
IT	17019	Casanova	Liguria	Savona	SV	5823
IT	17019	Faie	Liguria	Savona	SV	5824
IT	17019	Alpicella	Liguria	Savona	SV	5825
IT	17019	Varazze	Liguria	Savona	SV	5826
IT	17020	Calice Ligure	Liguria	Savona	SV	5827
IT	17020	Tovo San Giacomo	Liguria	Savona	SV	5828
IT	17020	Testico	Liguria	Savona	SV	5829
IT	17020	Stellanello	Liguria	Savona	SV	5830
IT	17020	Magliolo	Liguria	Savona	SV	5831
IT	17020	Balestrino	Liguria	Savona	SV	5832
IT	17020	Rialto	Liguria	Savona	SV	5833
IT	17020	Bardino Vecchio	Liguria	Savona	SV	5834
IT	17020	Bardino Nuovo	Liguria	Savona	SV	5835
IT	17021	Alassio	Liguria	Savona	SV	5836
IT	17021	Moglio	Liguria	Savona	SV	5837
IT	17022	Borgio	Liguria	Savona	SV	5838
IT	17022	Borgio Verezzi	Liguria	Savona	SV	5839
IT	17023	Ceriale	Liguria	Savona	SV	5840
IT	17024	Orco Feglino	Liguria	Savona	SV	5841
IT	17024	Gorra	Liguria	Savona	SV	5842
IT	17024	Feglino	Liguria	Savona	SV	5843
IT	17024	Varigotti	Liguria	Savona	SV	5844
IT	17024	Finale Ligure	Liguria	Savona	SV	5845
IT	17024	Finalborgo	Liguria	Savona	SV	5846
IT	17025	Loano	Liguria	Savona	SV	5847
IT	17026	Noli	Liguria	Savona	SV	5848
IT	17027	Giustenice	Liguria	Savona	SV	5849
IT	17027	Pietra Ligure	Liguria	Savona	SV	5850
IT	17028	Vezzi Portio	Liguria	Savona	SV	5851
IT	17028	Bergeggi	Liguria	Savona	SV	5852
IT	17028	Spotorno	Liguria	Savona	SV	5853
IT	17030	Castelbianco	Liguria	Savona	SV	5854
IT	17030	Nasino	Liguria	Savona	SV	5855
IT	17030	Erli	Liguria	Savona	SV	5856
IT	17031	San Fedele	Liguria	Savona	SV	5857
IT	17031	Leca	Liguria	Savona	SV	5858
IT	17031	Campochiesa	Liguria	Savona	SV	5859
IT	17031	Bastia	Liguria	Savona	SV	5860
IT	17031	Lusignano	Liguria	Savona	SV	5861
IT	17031	Albenga	Liguria	Savona	SV	5862
IT	17032	Arnasco	Liguria	Savona	SV	5863
IT	17032	Vendone	Liguria	Savona	SV	5864
IT	17033	Garlenda	Liguria	Savona	SV	5865
IT	17033	Casanova Lerrone	Liguria	Savona	SV	5866
IT	17033	Villafranca	Liguria	Savona	SV	5867
IT	17034	Castelvecchio Di Rocca Barbena	Liguria	Savona	SV	5868
IT	17035	Cisano Sul Neva	Liguria	Savona	SV	5869
IT	17037	Pogli	Liguria	Savona	SV	5870
IT	17037	Ortovero	Liguria	Savona	SV	5871
IT	17037	Onzo	Liguria	Savona	SV	5872
IT	17038	Villanova D'Albenga	Liguria	Savona	SV	5873
IT	17039	Zuccarello	Liguria	Savona	SV	5874
IT	17040	Mioglia	Liguria	Savona	SV	5875
IT	17041	Altare	Liguria	Savona	SV	5876
IT	17041	Cadibona	Liguria	Savona	SV	5877
IT	17042	Pontinvrea	Liguria	Savona	SV	5878
IT	17042	Giovo	Liguria	Savona	SV	5879
IT	17042	Giovo Ligure	Liguria	Savona	SV	5880
IT	17043	Pallare	Liguria	Savona	SV	5881
IT	17043	Carcare	Liguria	Savona	SV	5882
IT	17043	Plodio	Liguria	Savona	SV	5883
IT	17043	Piani	Liguria	Savona	SV	5884
IT	17044	San Martino Stella	Liguria	Savona	SV	5885
IT	17044	Santa Giustina	Liguria	Savona	SV	5886
IT	17044	Stella	Liguria	Savona	SV	5887
IT	17044	San Martino	Liguria	Savona	SV	5888
IT	17044	San Bernardo	Liguria	Savona	SV	5889
IT	17045	Bormida	Liguria	Savona	SV	5890
IT	17045	Mallare	Liguria	Savona	SV	5891
IT	17046	Palo	Liguria	Savona	SV	5892
IT	17046	Sassello	Liguria	Savona	SV	5893
IT	17046	Piampaludo	Liguria	Savona	SV	5894
IT	17047	Vado Ligure	Liguria	Savona	SV	5895
IT	17047	Quiliano	Liguria	Savona	SV	5896
IT	17047	Valleggia	Liguria	Savona	SV	5897
IT	17048	Vara	Liguria	Savona	SV	5898
IT	17048	Urbe	Liguria	Savona	SV	5899
IT	17048	Vara Superiore	Liguria	Savona	SV	5900
IT	17048	Olba	Liguria	Savona	SV	5901
IT	17048	Vara Inferiore	Liguria	Savona	SV	5902
IT	17048	San Pietro D'Olba	Liguria	Savona	SV	5903
IT	17051	Marina Di Andora	Liguria	Savona	SV	5904
IT	17051	Andora	Liguria	Savona	SV	5905
IT	17052	Borghetto Santo Spirito	Liguria	Savona	SV	5906
IT	17053	Laigueglia	Liguria	Savona	SV	5907
IT	17054	Boissano	Liguria	Savona	SV	5908
IT	17055	Toirano	Liguria	Savona	SV	5909
IT	17056	Cengio	Liguria	Savona	SV	5910
IT	17057	Calizzano	Liguria	Savona	SV	5911
IT	17057	Bardineto	Liguria	Savona	SV	5912
IT	17057	Caragna	Liguria	Savona	SV	5913
IT	17058	Piana Crixia	Liguria	Savona	SV	5914
IT	17058	Dego	Liguria	Savona	SV	5915
IT	17100	Fornaci	Liguria	Savona	SV	5916
IT	17100	Savona	Liguria	Savona	SV	5917
IT	17100	Santuario	Liguria	Savona	SV	5918
IT	17100	Zinola	Liguria	Savona	SV	5919
IT	17100	Santuario Di Savona	Liguria	Savona	SV	5920
IT	17100	Legino	Liguria	Savona	SV	5921
IT	17100	Lavagnola	Liguria	Savona	SV	5922
IT	24010	Botta Di Sedrina	Lombardia	Bergamo	BG	5923
IT	24010	Santa Brigida	Lombardia	Bergamo	BG	5924
IT	24010	Botta	Lombardia	Bergamo	BG	5925
IT	24010	Valnegra	Lombardia	Bergamo	BG	5926
IT	24010	Roncobello	Lombardia	Bergamo	BG	5927
IT	24010	Ubiale	Lombardia	Bergamo	BG	5928
IT	24010	Branzi	Lombardia	Bergamo	BG	5929
IT	24010	Clanezzo	Lombardia	Bergamo	BG	5930
IT	24010	Muggiasca	Lombardia	Bergamo	BG	5931
IT	24010	Camerata Cornello	Lombardia	Bergamo	BG	5932
IT	24010	Colla	Lombardia	Bergamo	BG	5933
IT	24010	Cusio	Lombardia	Bergamo	BG	5934
IT	24010	Vedeseta	Lombardia	Bergamo	BG	5935
IT	24010	Valleve	Lombardia	Bergamo	BG	5936
IT	24010	Carona	Lombardia	Bergamo	BG	5937
IT	24010	Bracca	Lombardia	Bergamo	BG	5938
IT	24010	Valtorta	Lombardia	Bergamo	BG	5939
IT	24010	Bordogna	Lombardia	Bergamo	BG	5940
IT	24010	Cassiglio	Lombardia	Bergamo	BG	5941
IT	24010	Mezzoldo	Lombardia	Bergamo	BG	5942
IT	24010	Algua	Lombardia	Bergamo	BG	5943
IT	24010	Costa Serina	Lombardia	Bergamo	BG	5944
IT	24010	Sedrina	Lombardia	Bergamo	BG	5945
IT	24010	Piazzolo	Lombardia	Bergamo	BG	5946
IT	24010	Piazzatorre	Lombardia	Bergamo	BG	5947
IT	24010	Taleggio	Lombardia	Bergamo	BG	5948
IT	24010	Foppolo	Lombardia	Bergamo	BG	5949
IT	24010	Peghera	Lombardia	Bergamo	BG	5950
IT	24010	Ubiale Clanezzo	Lombardia	Bergamo	BG	5951
IT	24010	Olmo Al Brembo	Lombardia	Bergamo	BG	5952
IT	24010	Averara	Lombardia	Bergamo	BG	5953
IT	24010	Ornica	Lombardia	Bergamo	BG	5954
IT	24010	Sorisole	Lombardia	Bergamo	BG	5955
IT	24010	Petosino	Lombardia	Bergamo	BG	5956
IT	24010	Lenna	Lombardia	Bergamo	BG	5957
IT	24010	Blello	Lombardia	Bergamo	BG	5958
IT	24010	Fondra	Lombardia	Bergamo	BG	5959
IT	24010	Ponteranica	Lombardia	Bergamo	BG	5960
IT	24010	Dossena	Lombardia	Bergamo	BG	5961
IT	24010	Olda	Lombardia	Bergamo	BG	5962
IT	24010	Isola Di Fondra	Lombardia	Bergamo	BG	5963
IT	24010	Moio De' Calvi	Lombardia	Bergamo	BG	5964
IT	24011	Alme'	Lombardia	Bergamo	BG	5965
IT	24012	Brembilla	Lombardia	Bergamo	BG	5966
IT	24012	Laxolo	Lombardia	Bergamo	BG	5967
IT	24012	Gerosa	Lombardia	Bergamo	BG	5968
IT	24012	Val Brembilla	Lombardia	Bergamo	BG	5969
IT	24012	San Gottardo	Lombardia	Bergamo	BG	5970
IT	24013	Oltre Il Colle	Lombardia	Bergamo	BG	5971
IT	24014	Piazza Brembana	Lombardia	Bergamo	BG	5972
IT	24015	San Giovanni Bianco	Lombardia	Bergamo	BG	5973
IT	24016	San Pellegrino Terme	Lombardia	Bergamo	BG	5974
IT	24016	Santa Croce	Lombardia	Bergamo	BG	5975
IT	24017	Cornalba	Lombardia	Bergamo	BG	5976
IT	24017	Serina	Lombardia	Bergamo	BG	5977
IT	24018	Villa D'Alme'	Lombardia	Bergamo	BG	5978
IT	24019	Ambria	Lombardia	Bergamo	BG	5979
IT	24019	Zogno	Lombardia	Bergamo	BG	5980
IT	24019	Spino	Lombardia	Bergamo	BG	5981
IT	24019	Poscante	Lombardia	Bergamo	BG	5982
IT	24020	Songavazzo	Lombardia	Bergamo	BG	5983
IT	24020	Vilminore	Lombardia	Bergamo	BG	5984
IT	24020	Fiumenero	Lombardia	Bergamo	BG	5985
IT	24020	Cene	Lombardia	Bergamo	BG	5986
IT	24020	Ranica	Lombardia	Bergamo	BG	5987
IT	24020	Aviatico	Lombardia	Bergamo	BG	5988
IT	24020	Tribulina	Lombardia	Bergamo	BG	5989
IT	24020	Parre	Lombardia	Bergamo	BG	5990
IT	24020	Villassio	Lombardia	Bergamo	BG	5991
IT	24020	Gromo	Lombardia	Bergamo	BG	5992
IT	24020	Fiorano Al Serio	Lombardia	Bergamo	BG	5993
IT	24020	Piario	Lombardia	Bergamo	BG	5994
IT	24020	Villa D'Ogna	Lombardia	Bergamo	BG	5995
IT	24020	Azzone	Lombardia	Bergamo	BG	5996
IT	24020	Lizzola	Lombardia	Bergamo	BG	5997
IT	24020	Pradalunga	Lombardia	Bergamo	BG	5998
IT	24020	Vilminore Di Scalve	Lombardia	Bergamo	BG	5999
IT	24020	Oltressenda Alta	Lombardia	Bergamo	BG	6000
IT	24020	Gorle	Lombardia	Bergamo	BG	6001
IT	24020	Selvino	Lombardia	Bergamo	BG	6002
IT	24020	Cantoniera Della Presolana	Lombardia	Bergamo	BG	6003
IT	24020	Rovetta	Lombardia	Bergamo	BG	6004
IT	24020	Colere	Lombardia	Bergamo	BG	6005
IT	24020	Schilpario	Lombardia	Bergamo	BG	6006
IT	24020	Dezzo	Lombardia	Bergamo	BG	6007
IT	24020	Negrone	Lombardia	Bergamo	BG	6008
IT	24020	Cerete Basso	Lombardia	Bergamo	BG	6009
IT	24020	Boario	Lombardia	Bergamo	BG	6010
IT	24020	Ponte Selva	Lombardia	Bergamo	BG	6011
IT	24020	Ardesio	Lombardia	Bergamo	BG	6012
IT	24020	Valgoglio	Lombardia	Bergamo	BG	6013
IT	24020	Onore	Lombardia	Bergamo	BG	6014
IT	24020	Peia	Lombardia	Bergamo	BG	6015
IT	24020	Fino Del Monte	Lombardia	Bergamo	BG	6016
IT	24020	Cerete	Lombardia	Bergamo	BG	6017
IT	24020	Valbondione	Lombardia	Bergamo	BG	6018
IT	24020	Bondione	Lombardia	Bergamo	BG	6019
IT	24020	San Lorenzo Di Rovetta	Lombardia	Bergamo	BG	6020
IT	24020	Scanzorosciate	Lombardia	Bergamo	BG	6021
IT	24020	Premolo	Lombardia	Bergamo	BG	6022
IT	24020	Torre Boldone	Lombardia	Bergamo	BG	6023
IT	24020	Gorno	Lombardia	Bergamo	BG	6024
IT	24020	Castione Della Presolana	Lombardia	Bergamo	BG	6025
IT	24020	Casnigo	Lombardia	Bergamo	BG	6026
IT	24020	Gavarno	Lombardia	Bergamo	BG	6027
IT	24020	Oneta	Lombardia	Bergamo	BG	6028
IT	24020	Parre Ponte Selva	Lombardia	Bergamo	BG	6029
IT	24020	Colzate	Lombardia	Bergamo	BG	6030
IT	24020	Scanzo	Lombardia	Bergamo	BG	6031
IT	24020	Villa Di Serio	Lombardia	Bergamo	BG	6032
IT	24020	Rosciate	Lombardia	Bergamo	BG	6033
IT	24020	Gandellino	Lombardia	Bergamo	BG	6034
IT	24020	Bratto	Lombardia	Bergamo	BG	6035
IT	24020	Cornale	Lombardia	Bergamo	BG	6036
IT	24021	Abbazia	Lombardia	Bergamo	BG	6037
IT	24021	Albino	Lombardia	Bergamo	BG	6038
IT	24021	Desenzano Al Serio	Lombardia	Bergamo	BG	6039
IT	24021	Vall'Alta	Lombardia	Bergamo	BG	6040
IT	24021	Comenduno	Lombardia	Bergamo	BG	6041
IT	24021	Bondo Petello	Lombardia	Bergamo	BG	6042
IT	24022	Alzano Lombardo	Lombardia	Bergamo	BG	6043
IT	24022	Nese	Lombardia	Bergamo	BG	6044
IT	24023	Clusone	Lombardia	Bergamo	BG	6045
IT	24024	Gandino	Lombardia	Bergamo	BG	6046
IT	24025	Gazzaniga	Lombardia	Bergamo	BG	6047
IT	24025	Orezzo	Lombardia	Bergamo	BG	6048
IT	24026	Cazzano Sant'Andrea	Lombardia	Bergamo	BG	6049
IT	24026	Leffe	Lombardia	Bergamo	BG	6050
IT	24027	Gavarno Rinnovata	Lombardia	Bergamo	BG	6051
IT	24027	Nembro	Lombardia	Bergamo	BG	6052
IT	24028	Ponte Nossa	Lombardia	Bergamo	BG	6053
IT	24029	Vertova	Lombardia	Bergamo	BG	6054
IT	24030	Gromlongo	Lombardia	Bergamo	BG	6055
IT	24030	Paladina	Lombardia	Bergamo	BG	6056
IT	24030	Pontida	Lombardia	Bergamo	BG	6057
IT	24030	Sant'Antonio	Lombardia	Bergamo	BG	6058
IT	24030	Bedulita	Lombardia	Bergamo	BG	6059
IT	24030	Mozzo	Lombardia	Bergamo	BG	6060
IT	24030	Costa Valle Imagna	Lombardia	Bergamo	BG	6061
IT	24030	Presezzo	Lombardia	Bergamo	BG	6062
IT	24030	Berbenno	Lombardia	Bergamo	BG	6063
IT	24030	Caprino	Lombardia	Bergamo	BG	6064
IT	24030	Medolago	Lombardia	Bergamo	BG	6065
IT	24030	Corna Imagna	Lombardia	Bergamo	BG	6066
IT	24030	Palazzago	Lombardia	Bergamo	BG	6067
IT	24030	Camoneone	Lombardia	Bergamo	BG	6068
IT	24030	Barzana	Lombardia	Bergamo	BG	6069
IT	24030	Terno D'Isola	Lombardia	Bergamo	BG	6070
IT	24030	Carvico	Lombardia	Bergamo	BG	6071
IT	24030	Mapello	Lombardia	Bergamo	BG	6072
IT	24030	Solza	Lombardia	Bergamo	BG	6073
IT	24030	Almenno San Bartolomeo	Lombardia	Bergamo	BG	6074
IT	24030	Locatello	Lombardia	Bergamo	BG	6075
IT	24030	Fuipiano Valle Imagna	Lombardia	Bergamo	BG	6076
IT	24030	Ambivere	Lombardia	Bergamo	BG	6077
IT	24030	Brembate Di Sopra	Lombardia	Bergamo	BG	6078
IT	24030	Roncola	Lombardia	Bergamo	BG	6079
IT	24030	Villa D'Adda	Lombardia	Bergamo	BG	6080
IT	24030	Scano Al Brembo	Lombardia	Bergamo	BG	6081
IT	24030	Strozza	Lombardia	Bergamo	BG	6082
IT	24030	Capizzone	Lombardia	Bergamo	BG	6083
IT	24030	Ponte Giurino	Lombardia	Bergamo	BG	6084
IT	24030	Celana	Lombardia	Bergamo	BG	6085
IT	24030	Valbrembo	Lombardia	Bergamo	BG	6086
IT	24030	Crocette	Lombardia	Bergamo	BG	6087
IT	24030	Caprino Bergamasco	Lombardia	Bergamo	BG	6088
IT	24031	Almenno San Salvatore	Lombardia	Bergamo	BG	6089
IT	24033	Calusco D'Adda	Lombardia	Bergamo	BG	6090
IT	24034	Cisano Bergamasco	Lombardia	Bergamo	BG	6091
IT	24035	Curno	Lombardia	Bergamo	BG	6092
IT	24036	Ponte San Pietro	Lombardia	Bergamo	BG	6093
IT	24037	Calchera	Lombardia	Bergamo	BG	6094
IT	24037	Rota D'Imagna	Lombardia	Bergamo	BG	6095
IT	24037	Brumano	Lombardia	Bergamo	BG	6096
IT	24037	Frontale	Lombardia	Bergamo	BG	6097
IT	24038	Sant'Omobono Terme	Lombardia	Bergamo	BG	6098
IT	24038	Valsecca	Lombardia	Bergamo	BG	6099
IT	24038	Selino Basso	Lombardia	Bergamo	BG	6100
IT	24038	Mazzoleni	Lombardia	Bergamo	BG	6101
IT	24039	Sotto Il Monte Giovanni Xxiii	Lombardia	Bergamo	BG	6102
IT	24039	Piazza Caduti	Lombardia	Bergamo	BG	6103
IT	24040	Filago	Lombardia	Bergamo	BG	6104
IT	24040	Castel Rozzone	Lombardia	Bergamo	BG	6105
IT	24040	Pontirolo Nuovo	Lombardia	Bergamo	BG	6106
IT	24040	Ciserano	Lombardia	Bergamo	BG	6107
IT	24040	Arzago D'Adda	Lombardia	Bergamo	BG	6108
IT	24040	Levate	Lombardia	Bergamo	BG	6109
IT	24040	Stezzano	Lombardia	Bergamo	BG	6110
IT	24040	Bonate Sopra	Lombardia	Bergamo	BG	6111
IT	24040	Pognano	Lombardia	Bergamo	BG	6112
IT	24040	Misano Di Gera D'Adda	Lombardia	Bergamo	BG	6113
IT	24040	Madone	Lombardia	Bergamo	BG	6114
IT	24040	Osio Sopra	Lombardia	Bergamo	BG	6115
IT	24040	Ghiaie	Lombardia	Bergamo	BG	6116
IT	24040	Grumello Del Piano	Lombardia	Bergamo	BG	6117
IT	24040	Chignolo D'Isola	Lombardia	Bergamo	BG	6118
IT	24040	Boltiere	Lombardia	Bergamo	BG	6119
IT	24040	Isso	Lombardia	Bergamo	BG	6120
IT	24040	Bonate Sotto	Lombardia	Bergamo	BG	6121
IT	24040	Barbata	Lombardia	Bergamo	BG	6122
IT	24040	Calvenzano	Lombardia	Bergamo	BG	6123
IT	24040	Verdellino	Lombardia	Bergamo	BG	6124
IT	24040	Fornovo San Giovanni	Lombardia	Bergamo	BG	6125
IT	24040	Suisio	Lombardia	Bergamo	BG	6126
IT	24040	Bottanuco	Lombardia	Bergamo	BG	6127
IT	24040	Comun Nuovo	Lombardia	Bergamo	BG	6128
IT	24040	Lallio	Lombardia	Bergamo	BG	6129
IT	24040	Arcene	Lombardia	Bergamo	BG	6130
IT	24040	Canonica D'Adda	Lombardia	Bergamo	BG	6131
IT	24040	Casirate D'Adda	Lombardia	Bergamo	BG	6132
IT	24040	Pagazzano	Lombardia	Bergamo	BG	6133
IT	24040	Zingonia	Lombardia	Bergamo	BG	6134
IT	24041	Brembate	Lombardia	Bergamo	BG	6135
IT	24041	Grignano	Lombardia	Bergamo	BG	6136
IT	24042	San Gervasio D'Adda	Lombardia	Bergamo	BG	6137
IT	24042	Capriate San Gervasio	Lombardia	Bergamo	BG	6138
IT	24042	Crespi D'Adda	Lombardia	Bergamo	BG	6139
IT	24043	Masano	Lombardia	Bergamo	BG	6140
IT	24043	Caravaggio	Lombardia	Bergamo	BG	6141
IT	24043	Vidalengo	Lombardia	Bergamo	BG	6142
IT	24044	Dalmine	Lombardia	Bergamo	BG	6143
IT	24044	Sabbio Bergamasco	Lombardia	Bergamo	BG	6144
IT	24044	Sforzatica	Lombardia	Bergamo	BG	6145
IT	24045	Fara Gera D'Adda	Lombardia	Bergamo	BG	6146
IT	24045	Badalasco	Lombardia	Bergamo	BG	6147
IT	24046	Osio Sotto	Lombardia	Bergamo	BG	6148
IT	24047	Treviglio	Lombardia	Bergamo	BG	6149
IT	24047	Castel Cerreto	Lombardia	Bergamo	BG	6150
IT	24047	Geromina	Lombardia	Bergamo	BG	6151
IT	24048	Treviolo	Lombardia	Bergamo	BG	6152
IT	24049	Verdello	Lombardia	Bergamo	BG	6153
IT	24050	Zanica	Lombardia	Bergamo	BG	6154
IT	24050	Spirano	Lombardia	Bergamo	BG	6155
IT	24050	Orio Al Serio	Lombardia	Bergamo	BG	6156
IT	24050	Mornico Al Serio	Lombardia	Bergamo	BG	6157
IT	24050	Malpaga	Lombardia	Bergamo	BG	6158
IT	24050	Palosco	Lombardia	Bergamo	BG	6159
IT	24050	Bariano	Lombardia	Bergamo	BG	6160
IT	24050	Covo	Lombardia	Bergamo	BG	6161
IT	24050	Pumenengo	Lombardia	Bergamo	BG	6162
IT	24050	Lurano	Lombardia	Bergamo	BG	6163
IT	24050	Grassobbio	Lombardia	Bergamo	BG	6164
IT	24050	Torre Pallavicina	Lombardia	Bergamo	BG	6165
IT	24050	Mozzanica	Lombardia	Bergamo	BG	6166
IT	24050	Ghisalba	Lombardia	Bergamo	BG	6167
IT	24050	Cividate Al Piano	Lombardia	Bergamo	BG	6168
IT	24050	Cavernago	Lombardia	Bergamo	BG	6169
IT	24050	Cortenuova	Lombardia	Bergamo	BG	6170
IT	24050	Calcinate	Lombardia	Bergamo	BG	6171
IT	24050	Morengo	Lombardia	Bergamo	BG	6172
IT	24051	Antegnate	Lombardia	Bergamo	BG	6173
IT	24052	Azzano San Paolo	Lombardia	Bergamo	BG	6174
IT	24053	Brignano Gera D'Adda	Lombardia	Bergamo	BG	6175
IT	24054	Calcio	Lombardia	Bergamo	BG	6176
IT	24055	Cologno Al Serio	Lombardia	Bergamo	BG	6177
IT	24056	Fontanella	Lombardia	Bergamo	BG	6178
IT	24057	Martinengo	Lombardia	Bergamo	BG	6179
IT	24058	Sola	Lombardia	Bergamo	BG	6180
IT	24058	Romano Di Lombardia	Lombardia	Bergamo	BG	6181
IT	24058	Fara Olivana	Lombardia	Bergamo	BG	6182
IT	24058	Fara Olivana Con Sola	Lombardia	Bergamo	BG	6183
IT	24059	Urgnano	Lombardia	Bergamo	BG	6184
IT	24059	Basella	Lombardia	Bergamo	BG	6185
IT	24060	Castelli Calepio	Lombardia	Bergamo	BG	6186
IT	24060	Viadanica	Lombardia	Bergamo	BG	6187
IT	24060	Borgo Di Terzo	Lombardia	Bergamo	BG	6188
IT	24060	Bolgare	Lombardia	Bergamo	BG	6189
IT	24060	Monasterolo Del Castello	Lombardia	Bergamo	BG	6190
IT	24060	Gaverina Terme	Lombardia	Bergamo	BG	6191
IT	24060	Zandobbio	Lombardia	Bergamo	BG	6192
IT	24060	Tavernola Bergamasca	Lombardia	Bergamo	BG	6193
IT	24060	Sovere	Lombardia	Bergamo	BG	6194
IT	24060	Villongo	Lombardia	Bergamo	BG	6195
IT	24060	Casazza	Lombardia	Bergamo	BG	6196
IT	24060	Predore	Lombardia	Bergamo	BG	6197
IT	24060	Grone	Lombardia	Bergamo	BG	6198
IT	24060	Tolari	Lombardia	Bergamo	BG	6199
IT	24060	Celatica	Lombardia	Bergamo	BG	6200
IT	24060	Vigano San Martino	Lombardia	Bergamo	BG	6201
IT	24060	Telgate	Lombardia	Bergamo	BG	6202
IT	24060	Adrara San Rocco	Lombardia	Bergamo	BG	6203
IT	24060	Costa Di Mezzate	Lombardia	Bergamo	BG	6204
IT	24060	Bagnatica	Lombardia	Bergamo	BG	6205
IT	24060	Pianico	Lombardia	Bergamo	BG	6206
IT	24060	Entratico	Lombardia	Bergamo	BG	6207
IT	24060	Bossico	Lombardia	Bergamo	BG	6208
IT	24060	Cenate Sopra	Lombardia	Bergamo	BG	6209
IT	24060	Bianzano	Lombardia	Bergamo	BG	6210
IT	24060	Foresto Sparso	Lombardia	Bergamo	BG	6211
IT	24060	Credaro	Lombardia	Bergamo	BG	6212
IT	24060	Chiuduno	Lombardia	Bergamo	BG	6213
IT	24060	Berzo San Fermo	Lombardia	Bergamo	BG	6214
IT	24060	Carobbio Degli Angeli	Lombardia	Bergamo	BG	6215
IT	24060	Montello	Lombardia	Bergamo	BG	6216
IT	24060	Solto Collina	Lombardia	Bergamo	BG	6217
IT	24060	Piangaiano	Lombardia	Bergamo	BG	6218
IT	24060	Casco	Lombardia	Bergamo	BG	6219
IT	24060	Vigolo	Lombardia	Bergamo	BG	6220
IT	24060	San Paolo D'Argon	Lombardia	Bergamo	BG	6221
IT	24060	Riva Di Solto	Lombardia	Bergamo	BG	6222
IT	24060	Brusaporto	Lombardia	Bergamo	BG	6223
IT	24060	Ranzanico	Lombardia	Bergamo	BG	6224
IT	24060	Adrara San Martino	Lombardia	Bergamo	BG	6225
IT	24060	Gandosso	Lombardia	Bergamo	BG	6226
IT	24060	Parzanica	Lombardia	Bergamo	BG	6227
IT	24060	Fonteno	Lombardia	Bergamo	BG	6228
IT	24060	Endine Gaiano	Lombardia	Bergamo	BG	6229
IT	24060	Gorlago	Lombardia	Bergamo	BG	6230
IT	24060	Spinone Al Lago	Lombardia	Bergamo	BG	6231
IT	24060	Monasterolo	Lombardia	Bergamo	BG	6232
IT	24060	Torre De' Roveri	Lombardia	Bergamo	BG	6233
IT	24060	Endine	Lombardia	Bergamo	BG	6234
IT	24060	Castel De' Conti	Lombardia	Bergamo	BG	6235
IT	24060	Rogno	Lombardia	Bergamo	BG	6236
IT	24060	Cividino	Lombardia	Bergamo	BG	6237
IT	24061	Albano Sant'Alessandro	Lombardia	Bergamo	BG	6238
IT	24062	Costa Volpino	Lombardia	Bergamo	BG	6239
IT	24063	Castro	Lombardia	Bergamo	BG	6240
IT	24063	Fonderia Di Lovere	Lombardia	Bergamo	BG	6241
IT	24064	Grumello Del Monte	Lombardia	Bergamo	BG	6242
IT	24065	Lovere	Lombardia	Bergamo	BG	6243
IT	24066	Pedrengo	Lombardia	Bergamo	BG	6244
IT	24067	Sarnico	Lombardia	Bergamo	BG	6245
IT	24068	Seriate	Lombardia	Bergamo	BG	6246
IT	24068	Cassinone	Lombardia	Bergamo	BG	6247
IT	24069	Trescore Balneario	Lombardia	Bergamo	BG	6248
IT	24069	Cenate Di Sotto	Lombardia	Bergamo	BG	6249
IT	24069	Cenate Sotto	Lombardia	Bergamo	BG	6250
IT	24069	Luzzana	Lombardia	Bergamo	BG	6251
IT	24100	Bergamo	Lombardia	Bergamo	BG	6252
IT	24121	Bergamo	Lombardia	Bergamo	BG	6253
IT	24122	Bergamo	Lombardia	Bergamo	BG	6254
IT	24123	Valtesse	Lombardia	Bergamo	BG	6255
IT	24123	Bergamo	Lombardia	Bergamo	BG	6256
IT	24124	Redona	Lombardia	Bergamo	BG	6257
IT	24124	Bergamo	Lombardia	Bergamo	BG	6258
IT	24125	Boccaleone	Lombardia	Bergamo	BG	6259
IT	24125	Bergamo	Lombardia	Bergamo	BG	6260
IT	24126	Colognola Al Piano	Lombardia	Bergamo	BG	6261
IT	24126	Campagnola	Lombardia	Bergamo	BG	6262
IT	24126	Malpensata	Lombardia	Bergamo	BG	6263
IT	24126	Bergamo	Lombardia	Bergamo	BG	6264
IT	24127	Bergamo	Lombardia	Bergamo	BG	6265
IT	24128	Loreto	Lombardia	Bergamo	BG	6266
IT	24128	Bergamo	Lombardia	Bergamo	BG	6267
IT	24129	Longuelo	Lombardia	Bergamo	BG	6268
IT	24129	Bergamo	Lombardia	Bergamo	BG	6269
IT	25010	Pozzolengo	Lombardia	Brescia	BS	6270
IT	25010	Isorella	Lombardia	Brescia	BS	6271
IT	25010	Tremosine	Lombardia	Brescia	BS	6272
IT	25010	Remedello Di Sopra	Lombardia	Brescia	BS	6273
IT	25010	Remedello Di Sotto	Lombardia	Brescia	BS	6274
IT	25010	Limone Sul Garda	Lombardia	Brescia	BS	6275
IT	25010	Visano	Lombardia	Brescia	BS	6276
IT	25010	Vesio	Lombardia	Brescia	BS	6277
IT	25010	Rivoltella	Lombardia	Brescia	BS	6278
IT	25010	Campione Del Garda	Lombardia	Brescia	BS	6279
IT	25010	Campione	Lombardia	Brescia	BS	6280
IT	25010	San Zeno Naviglio	Lombardia	Brescia	BS	6281
IT	25010	San Felice Del Benaco	Lombardia	Brescia	BS	6282
IT	25010	Montirone	Lombardia	Brescia	BS	6283
IT	25010	Acquafredda	Lombardia	Brescia	BS	6284
IT	25010	San Martino Della Battaglia	Lombardia	Brescia	BS	6285
IT	25010	Borgosatollo	Lombardia	Brescia	BS	6286
IT	25010	Remedello	Lombardia	Brescia	BS	6287
IT	25011	Calcinato	Lombardia	Brescia	BS	6288
IT	25011	Ponte San Marco	Lombardia	Brescia	BS	6289
IT	25011	Calcinatello	Lombardia	Brescia	BS	6290
IT	25012	Viadana	Lombardia	Brescia	BS	6291
IT	25012	Malpaga	Lombardia	Brescia	BS	6292
IT	25012	Calvisano	Lombardia	Brescia	BS	6293
IT	25012	Mezzane	Lombardia	Brescia	BS	6294
IT	25013	Carpenedolo	Lombardia	Brescia	BS	6295
IT	25014	Castenedolo	Lombardia	Brescia	BS	6296
IT	25014	Capodimonte	Lombardia	Brescia	BS	6297
IT	25015	Desenzano Del Garda	Lombardia	Brescia	BS	6298
IT	25016	Ghedi	Lombardia	Brescia	BS	6299
IT	25017	Esenta	Lombardia	Brescia	BS	6300
IT	25017	Sedena	Lombardia	Brescia	BS	6301
IT	25017	Lonato	Lombardia	Brescia	BS	6302
IT	25017	Centenaro	Lombardia	Brescia	BS	6303
IT	25018	Vighizzolo	Lombardia	Brescia	BS	6304
IT	25018	Montichiari	Lombardia	Brescia	BS	6305
IT	25018	Sant'Antonio	Lombardia	Brescia	BS	6306
IT	25018	Novagli	Lombardia	Brescia	BS	6307
IT	25019	Sirmione	Lombardia	Brescia	BS	6308
IT	25019	Colombare Di Sirmione	Lombardia	Brescia	BS	6309
IT	25020	Alfianello	Lombardia	Brescia	BS	6310
IT	25020	Seniga	Lombardia	Brescia	BS	6311
IT	25020	Pavone Del Mella	Lombardia	Brescia	BS	6312
IT	25020	San Gervasio Bresciano	Lombardia	Brescia	BS	6313
IT	25020	Fiesse	Lombardia	Brescia	BS	6314
IT	25020	Poncarale	Lombardia	Brescia	BS	6315
IT	25020	Offlaga	Lombardia	Brescia	BS	6316
IT	25020	Cigole	Lombardia	Brescia	BS	6317
IT	25020	San Paolo	Lombardia	Brescia	BS	6318
IT	25020	Azzano Mella	Lombardia	Brescia	BS	6319
IT	25020	Pralboino	Lombardia	Brescia	BS	6320
IT	25020	Dello	Lombardia	Brescia	BS	6321
IT	25020	Quinzanello	Lombardia	Brescia	BS	6322
IT	25020	Bassano Bresciano	Lombardia	Brescia	BS	6323
IT	25020	Faverzano	Lombardia	Brescia	BS	6324
IT	25020	Corticelle Pieve	Lombardia	Brescia	BS	6325
IT	25020	Scarpizzolo	Lombardia	Brescia	BS	6326
IT	25020	Cignano	Lombardia	Brescia	BS	6327
IT	25020	Flero	Lombardia	Brescia	BS	6328
IT	25020	Capriano Del Colle	Lombardia	Brescia	BS	6329
IT	25020	Milzano	Lombardia	Brescia	BS	6330
IT	25020	Gambara	Lombardia	Brescia	BS	6331
IT	25021	Bagnolo Mella	Lombardia	Brescia	BS	6332
IT	25022	Padernello	Lombardia	Brescia	BS	6333
IT	25022	Motella	Lombardia	Brescia	BS	6334
IT	25022	Borgo San Giacomo	Lombardia	Brescia	BS	6335
IT	25022	Farfengo	Lombardia	Brescia	BS	6336
IT	25023	Gottolengo	Lombardia	Brescia	BS	6337
IT	25024	Leno	Lombardia	Brescia	BS	6338
IT	25024	Porzano	Lombardia	Brescia	BS	6339
IT	25024	Castelletto	Lombardia	Brescia	BS	6340
IT	25024	Castelletto Di Leno	Lombardia	Brescia	BS	6341
IT	25025	Manerbio	Lombardia	Brescia	BS	6342
IT	25026	Pontevico	Lombardia	Brescia	BS	6343
IT	25027	Quinzano D'Oglio	Lombardia	Brescia	BS	6344
IT	25028	Verolanuova	Lombardia	Brescia	BS	6345
IT	25028	Cadignano	Lombardia	Brescia	BS	6346
IT	25029	Verolavecchia	Lombardia	Brescia	BS	6347
IT	25030	Villa Pedergnano	Lombardia	Brescia	BS	6348
IT	25030	Barbariga	Lombardia	Brescia	BS	6349
IT	25030	Coccaglio	Lombardia	Brescia	BS	6350
IT	25030	Erbusco	Lombardia	Brescia	BS	6351
IT	25030	Trenzano	Lombardia	Brescia	BS	6352
IT	25030	Castrezzato	Lombardia	Brescia	BS	6353
IT	25030	Longhena	Lombardia	Brescia	BS	6354
IT	25030	Brandico	Lombardia	Brescia	BS	6355
IT	25030	Ludriano	Lombardia	Brescia	BS	6356
IT	25030	Mairano	Lombardia	Brescia	BS	6357
IT	25030	Berlingo	Lombardia	Brescia	BS	6358
IT	25030	Roccafranca	Lombardia	Brescia	BS	6359
IT	25030	Lograto	Lombardia	Brescia	BS	6360
IT	25030	Orzivecchi	Lombardia	Brescia	BS	6361
IT	25030	Paratico	Lombardia	Brescia	BS	6362
IT	25030	Cizzago	Lombardia	Brescia	BS	6363
IT	25030	Rudiano	Lombardia	Brescia	BS	6364
IT	25030	Urago D'Oglio	Lombardia	Brescia	BS	6365
IT	25030	Maclodio	Lombardia	Brescia	BS	6366
IT	25030	Castelcovati	Lombardia	Brescia	BS	6367
IT	25030	Pievedizio	Lombardia	Brescia	BS	6368
IT	25030	Torbiato	Lombardia	Brescia	BS	6369
IT	25030	Corzano	Lombardia	Brescia	BS	6370
IT	25030	Castel Mella	Lombardia	Brescia	BS	6371
IT	25030	Adro	Lombardia	Brescia	BS	6372
IT	25030	Roncadelle	Lombardia	Brescia	BS	6373
IT	25030	Torbole Casaglia	Lombardia	Brescia	BS	6374
IT	25030	Villachiara	Lombardia	Brescia	BS	6375
IT	25030	Pompiano	Lombardia	Brescia	BS	6376
IT	25030	Cossirano	Lombardia	Brescia	BS	6377
IT	25030	Comezzano	Lombardia	Brescia	BS	6378
IT	25030	Comezzano Cizzago	Lombardia	Brescia	BS	6379
IT	25030	Zocco	Lombardia	Brescia	BS	6380
IT	25031	Capriolo	Lombardia	Brescia	BS	6381
IT	25032	Chiari	Lombardia	Brescia	BS	6382
IT	25033	Cologne	Lombardia	Brescia	BS	6383
IT	25034	Coniolo	Lombardia	Brescia	BS	6384
IT	25034	Orzinuovi	Lombardia	Brescia	BS	6385
IT	25035	Ospitaletto	Lombardia	Brescia	BS	6386
IT	25036	San Pancrazio	Lombardia	Brescia	BS	6387
IT	25036	Palazzolo Sull'Oglio	Lombardia	Brescia	BS	6388
IT	25037	Pontoglio	Lombardia	Brescia	BS	6389
IT	25038	Sant'Anna	Lombardia	Brescia	BS	6390
IT	25038	Lodetto	Lombardia	Brescia	BS	6391
IT	25038	Sant'Andrea	Lombardia	Brescia	BS	6392
IT	25038	Rovato	Lombardia	Brescia	BS	6393
IT	25038	Duomo	Lombardia	Brescia	BS	6394
IT	25039	Travagliato	Lombardia	Brescia	BS	6395
IT	25040	Esine	Lombardia	Brescia	BS	6396
IT	25040	Cevo	Lombardia	Brescia	BS	6397
IT	25040	Ceto	Lombardia	Brescia	BS	6398
IT	25040	Berzo Inferiore	Lombardia	Brescia	BS	6399
IT	25040	Gianico	Lombardia	Brescia	BS	6400
IT	25040	Bonomelli	Lombardia	Brescia	BS	6401
IT	25040	Lozio	Lombardia	Brescia	BS	6402
IT	25040	Artogne	Lombardia	Brescia	BS	6403
IT	25040	Parmezzana Calzana	Lombardia	Brescia	BS	6404
IT	25040	Corte Franca	Lombardia	Brescia	BS	6405
IT	25040	Monno	Lombardia	Brescia	BS	6406
IT	25040	Nigoline	Lombardia	Brescia	BS	6407
IT	25040	Borgonato	Lombardia	Brescia	BS	6408
IT	25040	Badetto	Lombardia	Brescia	BS	6409
IT	25040	Colombaro	Lombardia	Brescia	BS	6410
IT	25040	Bienno	Lombardia	Brescia	BS	6411
IT	25040	Galleno	Lombardia	Brescia	BS	6412
IT	25040	Plemo	Lombardia	Brescia	BS	6413
IT	25040	Cerveno	Lombardia	Brescia	BS	6414
IT	25040	Cividate Camuno	Lombardia	Brescia	BS	6415
IT	25040	Berzo Demo	Lombardia	Brescia	BS	6416
IT	25040	Sacca	Lombardia	Brescia	BS	6417
IT	25040	Corteno Golgi	Lombardia	Brescia	BS	6418
IT	25040	Santicolo	Lombardia	Brescia	BS	6419
IT	25040	Braone	Lombardia	Brescia	BS	6420
IT	25040	Forno Allione	Lombardia	Brescia	BS	6421
IT	25040	Angolo Terme	Lombardia	Brescia	BS	6422
IT	25040	Incudine	Lombardia	Brescia	BS	6423
IT	25040	Monticelli Brusati	Lombardia	Brescia	BS	6424
IT	25040	Ono San Pietro	Lombardia	Brescia	BS	6425
IT	25040	Malonno	Lombardia	Brescia	BS	6426
IT	25040	Forno D'Allione	Lombardia	Brescia	BS	6427
IT	25040	Prestine	Lombardia	Brescia	BS	6428
IT	25040	Saviore Dell'Adamello	Lombardia	Brescia	BS	6429
IT	25040	Timoline	Lombardia	Brescia	BS	6430
IT	25041	Boario Terme	Lombardia	Brescia	BS	6431
IT	25041	Erbanno	Lombardia	Brescia	BS	6432
IT	25042	Borno	Lombardia	Brescia	BS	6433
IT	25043	Pescarzo	Lombardia	Brescia	BS	6434
IT	25043	Breno	Lombardia	Brescia	BS	6435
IT	25043	Astrio	Lombardia	Brescia	BS	6436
IT	25044	Capo Di Ponte	Lombardia	Brescia	BS	6437
IT	25045	Castegnato	Lombardia	Brescia	BS	6438
IT	25046	Pedrocca	Lombardia	Brescia	BS	6439
IT	25046	Bornato	Lombardia	Brescia	BS	6440
IT	25046	Calino	Lombardia	Brescia	BS	6441
IT	25046	Cazzago San Martino	Lombardia	Brescia	BS	6442
IT	25047	Darfo	Lombardia	Brescia	BS	6443
IT	25047	Darfo Boario Terme	Lombardia	Brescia	BS	6444
IT	25047	Gorzone	Lombardia	Brescia	BS	6445
IT	25048	Cortenedolo	Lombardia	Brescia	BS	6446
IT	25048	Edolo	Lombardia	Brescia	BS	6447
IT	25048	Sonico	Lombardia	Brescia	BS	6448
IT	25049	Clusane	Lombardia	Brescia	BS	6449
IT	25049	Iseo	Lombardia	Brescia	BS	6450
IT	25049	Pilzone	Lombardia	Brescia	BS	6451
IT	25050	Ome	Lombardia	Brescia	BS	6452
IT	25050	Provezze	Lombardia	Brescia	BS	6453
IT	25050	Gresine	Lombardia	Brescia	BS	6454
IT	25050	Siviano	Lombardia	Brescia	BS	6455
IT	25050	Pian Camuno	Lombardia	Brescia	BS	6456
IT	25050	Crist	Lombardia	Brescia	BS	6457
IT	25050	Zurane	Lombardia	Brescia	BS	6458
IT	25050	Vione	Lombardia	Brescia	BS	6459
IT	25050	Pontagna	Lombardia	Brescia	BS	6460
IT	25050	Ponte Cingoli	Lombardia	Brescia	BS	6461
IT	25050	Paisco Loveno	Lombardia	Brescia	BS	6462
IT	25050	Monterotondo	Lombardia	Brescia	BS	6463
IT	25050	Sellero	Lombardia	Brescia	BS	6464
IT	25050	Cimbergo	Lombardia	Brescia	BS	6465
IT	25050	Ossimo Superiore	Lombardia	Brescia	BS	6466
IT	25050	Monte Isola	Lombardia	Brescia	BS	6467
IT	25050	Provaglio D'Iseo	Lombardia	Brescia	BS	6468
IT	25050	Losine	Lombardia	Brescia	BS	6469
IT	25050	Valle Di Saviore	Lombardia	Brescia	BS	6470
IT	25050	Temu'	Lombardia	Brescia	BS	6471
IT	25050	Ossimo Inferiore	Lombardia	Brescia	BS	6472
IT	25050	Peschiera Maraglio	Lombardia	Brescia	BS	6473
IT	25050	Passirano	Lombardia	Brescia	BS	6474
IT	25050	Camignone	Lombardia	Brescia	BS	6475
IT	25050	Paspardo	Lombardia	Brescia	BS	6476
IT	25050	Stadolina	Lombardia	Brescia	BS	6477
IT	25050	Novelle	Lombardia	Brescia	BS	6478
IT	25050	Paderno Franciacorta	Lombardia	Brescia	BS	6479
IT	25050	Fontane	Lombardia	Brescia	BS	6480
IT	25050	Niardo	Lombardia	Brescia	BS	6481
IT	25050	Rodengo Saiano	Lombardia	Brescia	BS	6482
IT	25050	Ossimo	Lombardia	Brescia	BS	6483
IT	25050	Zone	Lombardia	Brescia	BS	6484
IT	25051	Cedegolo	Lombardia	Brescia	BS	6485
IT	25052	Piancogno	Lombardia	Brescia	BS	6486
IT	25052	Pian Di Borno	Lombardia	Brescia	BS	6487
IT	25052	Annunciata	Lombardia	Brescia	BS	6488
IT	25052	Cogno	Lombardia	Brescia	BS	6489
IT	25053	Malegno	Lombardia	Brescia	BS	6490
IT	25054	Marone	Lombardia	Brescia	BS	6491
IT	25055	Toline	Lombardia	Brescia	BS	6492
IT	25055	Pisogne	Lombardia	Brescia	BS	6493
IT	25055	Gratacasolo	Lombardia	Brescia	BS	6494
IT	25056	Ponte Di Legno	Lombardia	Brescia	BS	6495
IT	25057	Sale Marasino	Lombardia	Brescia	BS	6496
IT	25058	Sulzano	Lombardia	Brescia	BS	6497
IT	25059	Vezza D'Oglio	Lombardia	Brescia	BS	6498
IT	25060	Marmentino	Lombardia	Brescia	BS	6499
IT	25060	Lodrino	Lombardia	Brescia	BS	6500
IT	25060	Collio	Lombardia	Brescia	BS	6501
IT	25060	Pezzaze	Lombardia	Brescia	BS	6502
IT	25060	San Colombano	Lombardia	Brescia	BS	6503
IT	25060	Lavone	Lombardia	Brescia	BS	6504
IT	25060	Marcheno	Lombardia	Brescia	BS	6505
IT	25060	Fantasina	Lombardia	Brescia	BS	6506
IT	25060	Lavone Di Pezzaze	Lombardia	Brescia	BS	6507
IT	25060	Polaveno	Lombardia	Brescia	BS	6508
IT	25060	Brozzo	Lombardia	Brescia	BS	6509
IT	25060	Stravignino	Lombardia	Brescia	BS	6510
IT	25060	Collebeato	Lombardia	Brescia	BS	6511
IT	25060	Gombio	Lombardia	Brescia	BS	6512
IT	25060	Cellatica	Lombardia	Brescia	BS	6513
IT	25060	Brione	Lombardia	Brescia	BS	6514
IT	25060	Tavernole Sul Mella	Lombardia	Brescia	BS	6515
IT	25061	Bovegno	Lombardia	Brescia	BS	6516
IT	25061	Irma	Lombardia	Brescia	BS	6517
IT	25062	Concesio	Lombardia	Brescia	BS	6518
IT	25062	San Vigilio	Lombardia	Brescia	BS	6519
IT	25063	Magno	Lombardia	Brescia	BS	6520
IT	25063	Gardone Val Trompia	Lombardia	Brescia	BS	6521
IT	25064	Ronco	Lombardia	Brescia	BS	6522
IT	25064	Gussago	Lombardia	Brescia	BS	6523
IT	25064	Mandolossa	Lombardia	Brescia	BS	6524
IT	25064	Piazza	Lombardia	Brescia	BS	6525
IT	25065	San Sebastiano	Lombardia	Brescia	BS	6526
IT	25065	Lumezzane	Lombardia	Brescia	BS	6527
IT	25065	Lumezzane Pieve	Lombardia	Brescia	BS	6528
IT	25065	Lumezzane Sant'Apollonio	Lombardia	Brescia	BS	6529
IT	25065	Pieve	Lombardia	Brescia	BS	6530
IT	25065	Sant'Apollonio	Lombardia	Brescia	BS	6531
IT	25068	Sarezzo	Lombardia	Brescia	BS	6532
IT	25068	Ponte Zanano	Lombardia	Brescia	BS	6533
IT	25068	Zanano	Lombardia	Brescia	BS	6534
IT	25069	Carcina	Lombardia	Brescia	BS	6535
IT	25069	Villa Carcina	Lombardia	Brescia	BS	6536
IT	25069	Cogozzo	Lombardia	Brescia	BS	6537
IT	25070	Casto	Lombardia	Brescia	BS	6538
IT	25070	Anfo	Lombardia	Brescia	BS	6539
IT	25070	Ponte Caffaro	Lombardia	Brescia	BS	6540
IT	25070	Sottocastello	Lombardia	Brescia	BS	6541
IT	25070	Preseglie	Lombardia	Brescia	BS	6542
IT	25070	Caino	Lombardia	Brescia	BS	6543
IT	25070	Barghe	Lombardia	Brescia	BS	6544
IT	25070	Livemmo	Lombardia	Brescia	BS	6545
IT	25070	Gazzane	Lombardia	Brescia	BS	6546
IT	25070	Sabbio Chiese	Lombardia	Brescia	BS	6547
IT	25070	Capovalle	Lombardia	Brescia	BS	6548
IT	25070	Treviso Bresciano	Lombardia	Brescia	BS	6549
IT	25070	Bione	Lombardia	Brescia	BS	6550
IT	25070	Mura	Lombardia	Brescia	BS	6551
IT	25070	Provaglio Val Sabbia	Lombardia	Brescia	BS	6552
IT	25070	San Faustino	Lombardia	Brescia	BS	6553
IT	25070	Trebbio	Lombardia	Brescia	BS	6554
IT	25070	Pertica Alta	Lombardia	Brescia	BS	6555
IT	25071	Agnosine	Lombardia	Brescia	BS	6556
IT	25072	Bagolino	Lombardia	Brescia	BS	6557
IT	25073	Bovezzo	Lombardia	Brescia	BS	6558
IT	25074	Lavenone	Lombardia	Brescia	BS	6559
IT	25074	Crone	Lombardia	Brescia	BS	6560
IT	25074	Idro	Lombardia	Brescia	BS	6561
IT	25075	Nave	Lombardia	Brescia	BS	6562
IT	25076	Odolo	Lombardia	Brescia	BS	6563
IT	25077	Roe'	Lombardia	Brescia	BS	6564
IT	25077	Roe' Volciano	Lombardia	Brescia	BS	6565
IT	25078	Nozza	Lombardia	Brescia	BS	6566
IT	25078	Forno D'Ono	Lombardia	Brescia	BS	6567
IT	25078	Vestone	Lombardia	Brescia	BS	6568
IT	25078	Pertica Bassa	Lombardia	Brescia	BS	6569
IT	25079	Carpeneda	Lombardia	Brescia	BS	6570
IT	25079	Vobarno	Lombardia	Brescia	BS	6571
IT	25079	Pompegnino	Lombardia	Brescia	BS	6572
IT	25079	Degagna	Lombardia	Brescia	BS	6573
IT	25080	Case Nuove	Lombardia	Brescia	BS	6574
IT	25080	Solarolo	Lombardia	Brescia	BS	6575
IT	25080	Vallio Terme	Lombardia	Brescia	BS	6576
IT	25080	Nuvolera	Lombardia	Brescia	BS	6577
IT	25080	Gardola	Lombardia	Brescia	BS	6578
IT	25080	Moerna	Lombardia	Brescia	BS	6579
IT	25080	Molinetto	Lombardia	Brescia	BS	6580
IT	25080	Serle	Lombardia	Brescia	BS	6581
IT	25080	Polpenazze Del Garda	Lombardia	Brescia	BS	6582
IT	25080	Prevalle	Lombardia	Brescia	BS	6583
IT	25080	Muscoline	Lombardia	Brescia	BS	6584
IT	25080	Nuvolento	Lombardia	Brescia	BS	6585
IT	25080	Manerba Del Garda	Lombardia	Brescia	BS	6586
IT	25080	Tignale	Lombardia	Brescia	BS	6587
IT	25080	Mazzano	Lombardia	Brescia	BS	6588
IT	25080	Padenghe Sul Garda	Lombardia	Brescia	BS	6589
IT	25080	Moniga Del Garda	Lombardia	Brescia	BS	6590
IT	25080	Carzago Riviera	Lombardia	Brescia	BS	6591
IT	25080	Soiano	Lombardia	Brescia	BS	6592
IT	25080	Carzago Della Riviera	Lombardia	Brescia	BS	6593
IT	25080	Chiesa	Lombardia	Brescia	BS	6594
IT	25080	Castello	Lombardia	Brescia	BS	6595
IT	25080	Raffa	Lombardia	Brescia	BS	6596
IT	25080	Valvestino	Lombardia	Brescia	BS	6597
IT	25080	Paitone	Lombardia	Brescia	BS	6598
IT	25080	Puegnago Sul Garda	Lombardia	Brescia	BS	6599
IT	25080	Calvagese Della Riviera	Lombardia	Brescia	BS	6600
IT	25080	Magasa	Lombardia	Brescia	BS	6601
IT	25080	Ciliverghe	Lombardia	Brescia	BS	6602
IT	25080	Soiano Del Lago	Lombardia	Brescia	BS	6603
IT	25081	Bedizzole	Lombardia	Brescia	BS	6604
IT	25081	Campagnola	Lombardia	Brescia	BS	6605
IT	25082	Botticino	Lombardia	Brescia	BS	6606
IT	25082	Botticino Mattina	Lombardia	Brescia	BS	6607
IT	25082	San Gallo	Lombardia	Brescia	BS	6608
IT	25082	Botticino Sera	Lombardia	Brescia	BS	6609
IT	25083	Montecucco	Lombardia	Brescia	BS	6610
IT	25083	Gardone Riviera	Lombardia	Brescia	BS	6611
IT	25083	San Michele	Lombardia	Brescia	BS	6612
IT	25083	Fasano Del Garda	Lombardia	Brescia	BS	6613
IT	25084	Gargnano	Lombardia	Brescia	BS	6614
IT	25084	Navazzo	Lombardia	Brescia	BS	6615
IT	25084	Bogliaco	Lombardia	Brescia	BS	6616
IT	25085	San Giacomo	Lombardia	Brescia	BS	6617
IT	25085	Gavardo	Lombardia	Brescia	BS	6618
IT	25085	San Biagio	Lombardia	Brescia	BS	6619
IT	25085	Sopraponte	Lombardia	Brescia	BS	6620
IT	25086	Virle Treponti	Lombardia	Brescia	BS	6621
IT	25086	Rezzato	Lombardia	Brescia	BS	6622
IT	25087	Salo'	Lombardia	Brescia	BS	6623
IT	25087	Campoverde	Lombardia	Brescia	BS	6624
IT	25087	Barbarano	Lombardia	Brescia	BS	6625
IT	25088	Toscolano Maderno	Lombardia	Brescia	BS	6626
IT	25088	Maderno	Lombardia	Brescia	BS	6627
IT	25089	Villanuova Sul Clisi	Lombardia	Brescia	BS	6628
IT	25089	Bostone	Lombardia	Brescia	BS	6629
IT	25100	Brescia	Lombardia	Brescia	BS	6630
IT	25121	Brescia	Lombardia	Brescia	BS	6631
IT	25122	Brescia	Lombardia	Brescia	BS	6632
IT	25123	Brescia	Lombardia	Brescia	BS	6633
IT	25124	Brescia	Lombardia	Brescia	BS	6634
IT	25125	Brescia	Lombardia	Brescia	BS	6635
IT	25126	Brescia	Lombardia	Brescia	BS	6636
IT	25127	Brescia	Lombardia	Brescia	BS	6637
IT	25128	Brescia	Lombardia	Brescia	BS	6638
IT	25129	Bettole Di Buffalora	Lombardia	Brescia	BS	6639
IT	25129	Brescia	Lombardia	Brescia	BS	6640
IT	25131	Fornaci	Lombardia	Brescia	BS	6641
IT	25131	Brescia	Lombardia	Brescia	BS	6642
IT	25132	Mandolossa Di Brescia	Lombardia	Brescia	BS	6643
IT	25132	Brescia	Lombardia	Brescia	BS	6644
IT	25133	Mompiano	Lombardia	Brescia	BS	6645
IT	25133	Brescia	Lombardia	Brescia	BS	6646
IT	25134	San Polo	Lombardia	Brescia	BS	6647
IT	25134	Brescia	Lombardia	Brescia	BS	6648
IT	25135	Sant'Eufemia Della Fonte	Lombardia	Brescia	BS	6649
IT	25135	Brescia	Lombardia	Brescia	BS	6650
IT	25135	Caionvico	Lombardia	Brescia	BS	6651
IT	25136	Brescia	Lombardia	Brescia	BS	6652
IT	25136	Stocchetta	Lombardia	Brescia	BS	6653
IT	22010	San Gregorio	Lombardia	Como	CO	6654
IT	22010	Bene Lario	Lombardia	Como	CO	6655
IT	22010	Garzeno	Lombardia	Como	CO	6656
IT	22010	San Bartolomeo Val Cavargna	Lombardia	Como	CO	6657
IT	22010	Peglio	Lombardia	Como	CO	6658
IT	22010	Codogna	Lombardia	Como	CO	6659
IT	22010	Acquaseria	Lombardia	Como	CO	6660
IT	22010	Gera Lario	Lombardia	Como	CO	6661
IT	22010	Rezzonico	Lombardia	Como	CO	6662
IT	22010	Cusino	Lombardia	Como	CO	6663
IT	22010	Colonno	Lombardia	Como	CO	6664
IT	22010	Moltrasio	Lombardia	Como	CO	6665
IT	22010	Germasino	Lombardia	Como	CO	6666
IT	22010	Trezzone	Lombardia	Como	CO	6667
IT	22010	Livo	Lombardia	Como	CO	6668
IT	22010	Stazzona	Lombardia	Como	CO	6669
IT	22010	Azzano	Lombardia	Como	CO	6670
IT	22010	Claino Con Osteno	Lombardia	Como	CO	6671
IT	22010	Cremia	Lombardia	Como	CO	6672
IT	22010	Consiglio Di Rumo	Lombardia	Como	CO	6673
IT	22010	Corrido	Lombardia	Como	CO	6674
IT	22010	Mezzegra	Lombardia	Como	CO	6675
IT	22010	Brienno	Lombardia	Como	CO	6676
IT	22010	Ossuccio	Lombardia	Como	CO	6677
IT	22010	Val Rezzo	Lombardia	Como	CO	6678
IT	22010	Dosso Del Liro	Lombardia	Como	CO	6679
IT	22010	Laglio	Lombardia	Como	CO	6680
IT	22010	Argegno	Lombardia	Como	CO	6681
IT	22010	San Siro	Lombardia	Como	CO	6682
IT	22010	Piano Porlezza	Lombardia	Como	CO	6683
IT	22010	Santa Maria	Lombardia	Como	CO	6684
IT	22010	Musso	Lombardia	Como	CO	6685
IT	22010	Sorico	Lombardia	Como	CO	6686
IT	22010	Urio	Lombardia	Como	CO	6687
IT	22010	Montemezzo	Lombardia	Como	CO	6688
IT	22010	San Nazzaro Val Cavargna	Lombardia	Como	CO	6689
IT	22010	Carlazzo	Lombardia	Como	CO	6690
IT	22010	Pianello Del Lario	Lombardia	Como	CO	6691
IT	22010	Valsolda	Lombardia	Como	CO	6692
IT	22010	Calozzo	Lombardia	Como	CO	6693
IT	22010	Sala Comacina	Lombardia	Como	CO	6694
IT	22010	Carate Urio	Lombardia	Como	CO	6695
IT	22010	Santa Maria Rezzonico	Lombardia	Como	CO	6696
IT	22010	Plesio	Lombardia	Como	CO	6697
IT	22010	Grandola Ed Uniti	Lombardia	Como	CO	6698
IT	22010	San Pietro Sovera	Lombardia	Como	CO	6699
IT	22010	Albogasio	Lombardia	Como	CO	6700
IT	22010	Sant'Abbondio	Lombardia	Como	CO	6701
IT	22010	Oria	Lombardia	Como	CO	6702
IT	22010	Cavargna	Lombardia	Como	CO	6703
IT	22011	Griante	Lombardia	Como	CO	6704
IT	22011	Cadenabbia	Lombardia	Como	CO	6705
IT	22012	Cernobbio	Lombardia	Como	CO	6706
IT	22013	Vercana	Lombardia	Como	CO	6707
IT	22013	Domaso	Lombardia	Como	CO	6708
IT	22014	Dongo	Lombardia	Como	CO	6709
IT	22015	Gravedona	Lombardia	Como	CO	6710
IT	22016	Lenno	Lombardia	Como	CO	6711
IT	22016	Tremezzina	Lombardia	Como	CO	6712
IT	22017	Menaggio	Lombardia	Como	CO	6713
IT	22018	Cima	Lombardia	Como	CO	6714
IT	22018	Porlezza	Lombardia	Como	CO	6715
IT	22019	Tremezzo	Lombardia	Como	CO	6716
IT	22020	Pellio Intelvi	Lombardia	Como	CO	6717
IT	22020	Faloppio	Lombardia	Como	CO	6718
IT	22020	Drezzo	Lombardia	Como	CO	6719
IT	22020	Gaggino	Lombardia	Como	CO	6720
IT	22020	Cerano D'Intelvi	Lombardia	Como	CO	6721
IT	22020	Torno	Lombardia	Como	CO	6722
IT	22020	Cavallasca	Lombardia	Como	CO	6723
IT	22020	Zelbio	Lombardia	Como	CO	6724
IT	22020	Dizzasco	Lombardia	Como	CO	6725
IT	22020	Occagno	Lombardia	Como	CO	6726
IT	22020	Lemna	Lombardia	Como	CO	6727
IT	22020	Camnago Faloppio	Lombardia	Como	CO	6728
IT	22020	Nesso	Lombardia	Como	CO	6729
IT	22020	Pellio	Lombardia	Como	CO	6730
IT	22020	Faggeto Lario	Lombardia	Como	CO	6731
IT	22020	Schignano	Lombardia	Como	CO	6732
IT	22020	Veleso	Lombardia	Como	CO	6733
IT	22020	Boscone	Lombardia	Como	CO	6734
IT	22020	Ponna	Lombardia	Como	CO	6735
IT	22020	Blevio	Lombardia	Como	CO	6736
IT	22020	Ramponio Verna	Lombardia	Como	CO	6737
IT	22020	San Fermo Della Battaglia	Lombardia	Como	CO	6738
IT	22020	Pigra	Lombardia	Como	CO	6739
IT	22020	Camnago	Lombardia	Como	CO	6740
IT	22020	Laino	Lombardia	Como	CO	6741
IT	22020	Pare'	Lombardia	Como	CO	6742
IT	22020	Pognana Lario	Lombardia	Como	CO	6743
IT	22020	Bizzarone	Lombardia	Como	CO	6744
IT	22070	Minoprio	Lombardia	Como	CO	6745
IT	22021	San Giovanni Di Bellagio	Lombardia	Como	CO	6746
IT	22021	Bellagio	Lombardia	Como	CO	6747
IT	22022	Casasco D'Intelvi	Lombardia	Como	CO	6748
IT	22023	Castiglione D'Intelvi	Lombardia	Como	CO	6749
IT	22024	Lanzo D'Intelvi	Lombardia	Como	CO	6750
IT	22024	Scaria	Lombardia	Como	CO	6751
IT	22025	Lezzeno	Lombardia	Como	CO	6752
IT	22026	Maslianico	Lombardia	Como	CO	6753
IT	22027	Ronago	Lombardia	Como	CO	6754
IT	22028	Blessagno	Lombardia	Como	CO	6755
IT	22028	San Fedele Intelvi	Lombardia	Como	CO	6756
IT	22029	Uggiate Trevano	Lombardia	Como	CO	6757
IT	22030	Caslino D'Erba	Lombardia	Como	CO	6758
IT	22030	Barni	Lombardia	Como	CO	6759
IT	22030	Magreglio	Lombardia	Como	CO	6760
IT	22030	Penzano	Lombardia	Como	CO	6761
IT	22030	Montorfano	Lombardia	Como	CO	6762
IT	22030	Rezzago	Lombardia	Como	CO	6763
IT	22030	Orsenigo	Lombardia	Como	CO	6764
IT	22030	Civenna	Lombardia	Como	CO	6765
IT	22030	Proserpio	Lombardia	Como	CO	6766
IT	22030	Longone Al Segrino	Lombardia	Como	CO	6767
IT	22030	Lipomo	Lombardia	Como	CO	6768
IT	22030	Caglio	Lombardia	Como	CO	6769
IT	22030	Castelmarte	Lombardia	Como	CO	6770
IT	22030	Sormano	Lombardia	Como	CO	6771
IT	22030	Corneno	Lombardia	Como	CO	6772
IT	22030	Pusiano	Lombardia	Como	CO	6773
IT	22030	Galliano	Lombardia	Como	CO	6774
IT	22030	Lasnigo	Lombardia	Como	CO	6775
IT	22030	Eupilio	Lombardia	Como	CO	6776
IT	22031	Albavilla	Lombardia	Como	CO	6777
IT	22032	Albese Con Cassano	Lombardia	Como	CO	6778
IT	22033	Asso	Lombardia	Como	CO	6779
IT	22034	Brunate	Lombardia	Como	CO	6780
IT	22035	Canzo	Lombardia	Como	CO	6781
IT	22036	Erba	Lombardia	Como	CO	6782
IT	22036	Arcellasco	Lombardia	Como	CO	6783
IT	22037	Ponte Lambro	Lombardia	Como	CO	6784
IT	22038	Tavernerio	Lombardia	Como	CO	6785
IT	22038	Solzago	Lombardia	Como	CO	6786
IT	22039	Valbrona	Lombardia	Como	CO	6787
IT	22039	Osigo	Lombardia	Como	CO	6788
IT	22040	Lurago D'Erba	Lombardia	Como	CO	6789
IT	22040	Brenna	Lombardia	Como	CO	6790
IT	22040	Alzate Brianza	Lombardia	Como	CO	6791
IT	22040	Alserio	Lombardia	Como	CO	6792
IT	22040	Anzano Del Parco	Lombardia	Como	CO	6793
IT	22040	Fabbrica Durini	Lombardia	Como	CO	6794
IT	22040	Monguzzo	Lombardia	Como	CO	6795
IT	22040	Nobile	Lombardia	Como	CO	6796
IT	22041	Gironico	Lombardia	Como	CO	6797
IT	22041	Colverde	Lombardia	Como	CO	6798
IT	22041	Gironico Al Piano	Lombardia	Como	CO	6799
IT	22044	Romano' Brianza	Lombardia	Como	CO	6800
IT	22044	Inverigo	Lombardia	Como	CO	6801
IT	22044	Cremnago	Lombardia	Como	CO	6802
IT	22045	Lambrugo	Lombardia	Como	CO	6803
IT	22046	Merone	Lombardia	Como	CO	6804
IT	22060	Arosio	Lombardia	Como	CO	6805
IT	22060	Carugo	Lombardia	Como	CO	6806
IT	22060	Figino Serenza	Lombardia	Como	CO	6807
IT	22060	Novedrate	Lombardia	Como	CO	6808
IT	22060	Montesolaro	Lombardia	Como	CO	6809
IT	22060	Cucciago	Lombardia	Como	CO	6810
IT	22060	Campione D'Italia	Lombardia	Como	CO	6811
IT	22060	Carimate	Lombardia	Como	CO	6812
IT	22060	Cabiate	Lombardia	Como	CO	6813
IT	22063	Vighizzolo Di Cantu'	Lombardia	Como	CO	6814
IT	22063	Cantu' Asnago	Lombardia	Como	CO	6815
IT	22063	Mirabello Di Cantu'	Lombardia	Como	CO	6816
IT	22063	Cantu'	Lombardia	Como	CO	6817
IT	22063	Cascina Amata	Lombardia	Como	CO	6818
IT	22063	Asnago Di Cantu'	Lombardia	Como	CO	6819
IT	22066	Mariano Comense	Lombardia	Como	CO	6820
IT	22066	Perticato	Lombardia	Como	CO	6821
IT	22069	Rovellasca	Lombardia	Como	CO	6822
IT	22070	Bulgarograsso	Lombardia	Como	CO	6823
IT	22070	Senna Comasco	Lombardia	Como	CO	6824
IT	22070	Cirimido	Lombardia	Como	CO	6825
IT	22070	Bregnano	Lombardia	Como	CO	6826
IT	22070	Grandate	Lombardia	Como	CO	6827
IT	22070	Valmorea	Lombardia	Como	CO	6828
IT	22070	Montano Lucino	Lombardia	Como	CO	6829
IT	22070	Cassina Rizzardi	Lombardia	Como	CO	6830
IT	22070	Lucino	Lombardia	Como	CO	6831
IT	22070	Vertemate Con Minoprio	Lombardia	Como	CO	6832
IT	22070	Carbonate	Lombardia	Como	CO	6833
IT	22070	Concagno	Lombardia	Como	CO	6834
IT	22070	Appiano Gentile	Lombardia	Como	CO	6835
IT	22070	Cascina Restelli	Lombardia	Como	CO	6836
IT	22070	Puginate	Lombardia	Como	CO	6837
IT	22070	Albiolo	Lombardia	Como	CO	6838
IT	22070	Fenegro'	Lombardia	Como	CO	6839
IT	22070	Locate Varesino	Lombardia	Como	CO	6840
IT	22070	San Michele	Lombardia	Como	CO	6841
IT	22070	Limido Comasco	Lombardia	Como	CO	6842
IT	22070	Figliaro	Lombardia	Como	CO	6843
IT	22070	San Giorgio	Lombardia	Como	CO	6844
IT	22070	Oltrona Di San Mamette	Lombardia	Como	CO	6845
IT	22070	Beregazzo Con Figliaro	Lombardia	Como	CO	6846
IT	22070	Casnate Con Bernate	Lombardia	Como	CO	6847
IT	22070	Rodero	Lombardia	Como	CO	6848
IT	22070	Solbiate	Lombardia	Como	CO	6849
IT	22070	Beregazzo	Lombardia	Como	CO	6850
IT	22070	Casnate	Lombardia	Como	CO	6851
IT	22070	Rovello Porro	Lombardia	Como	CO	6852
IT	22070	Binago	Lombardia	Como	CO	6853
IT	22070	Castelnuovo Bozzente	Lombardia	Como	CO	6854
IT	22070	Lurago Marinone	Lombardia	Como	CO	6855
IT	22070	Guanzate	Lombardia	Como	CO	6856
IT	22070	Cagno	Lombardia	Como	CO	6857
IT	22070	Luisago	Lombardia	Como	CO	6858
IT	22070	Veniano	Lombardia	Como	CO	6859
IT	22070	Montano	Lombardia	Como	CO	6860
IT	22070	Capiago	Lombardia	Como	CO	6861
IT	22070	Intimiano	Lombardia	Como	CO	6862
IT	22070	Casanova Lanza	Lombardia	Como	CO	6863
IT	22070	Portichetto	Lombardia	Como	CO	6864
IT	22070	Capiago Intimiano	Lombardia	Como	CO	6865
IT	22071	Bulgorello	Lombardia	Como	CO	6866
IT	22071	Caslino Al Piano	Lombardia	Como	CO	6867
IT	22071	Cadorago	Lombardia	Como	CO	6868
IT	22072	Cermenate	Lombardia	Como	CO	6869
IT	22073	Andrate	Lombardia	Como	CO	6870
IT	22073	Fino Mornasco	Lombardia	Como	CO	6871
IT	22073	Molinetto	Lombardia	Como	CO	6872
IT	22074	Lomazzo	Lombardia	Como	CO	6873
IT	22074	Manera	Lombardia	Como	CO	6874
IT	22075	Lurate Caccivio	Lombardia	Como	CO	6875
IT	22076	Mozzate	Lombardia	Como	CO	6876
IT	22077	Olgiate Comasco	Lombardia	Como	CO	6877
IT	22078	Turate	Lombardia	Como	CO	6878
IT	22079	Villa Guardia	Lombardia	Como	CO	6879
IT	22100	Camnago Volta	Lombardia	Como	CO	6880
IT	22100	Como	Lombardia	Como	CO	6881
IT	22100	Ponte Chiasso	Lombardia	Como	CO	6882
IT	22100	Camerlata	Lombardia	Como	CO	6883
IT	22100	Albate	Lombardia	Como	CO	6884
IT	22100	Tavernola	Lombardia	Como	CO	6885
IT	22100	Rebbio	Lombardia	Como	CO	6886
IT	22100	Monte Olimpino	Lombardia	Como	CO	6887
IT	22100	Civiglio	Lombardia	Como	CO	6888
IT	22100	Breccia	Lombardia	Como	CO	6889
IT	22100	Lora	Lombardia	Como	CO	6890
IT	26010	Capralba	Lombardia	Cremona	CR	6891
IT	26010	Montodine	Lombardia	Cremona	CR	6892
IT	26010	Azzanello	Lombardia	Cremona	CR	6893
IT	26010	Moscazzano	Lombardia	Cremona	CR	6894
IT	26010	Olmeneta	Lombardia	Cremona	CR	6895
IT	26010	Bagnolo Cremasco	Lombardia	Cremona	CR	6896
IT	26010	Robecco D'Oglio	Lombardia	Cremona	CR	6897
IT	26010	Ripalta Arpina	Lombardia	Cremona	CR	6898
IT	26010	Dovera	Lombardia	Cremona	CR	6899
IT	26010	Vaiano Cremasco	Lombardia	Cremona	CR	6900
IT	26010	Monte Cremasco	Lombardia	Cremona	CR	6901
IT	26010	Capergnanica	Lombardia	Cremona	CR	6902
IT	26010	Castel Gabbiano	Lombardia	Cremona	CR	6903
IT	26010	Pozzaglio	Lombardia	Cremona	CR	6904
IT	26010	Bolzone	Lombardia	Cremona	CR	6905
IT	26010	Corte De' Frati	Lombardia	Cremona	CR	6906
IT	26010	Ripalta Guerina	Lombardia	Cremona	CR	6907
IT	26010	Credera	Lombardia	Cremona	CR	6908
IT	26010	Salvirola	Lombardia	Cremona	CR	6909
IT	26010	Ricengo	Lombardia	Cremona	CR	6910
IT	26010	Izano	Lombardia	Cremona	CR	6911
IT	26010	Chieve	Lombardia	Cremona	CR	6912
IT	26010	Fiesco	Lombardia	Cremona	CR	6913
IT	26010	Casalsigone	Lombardia	Cremona	CR	6914
IT	26010	Pozzaglio Ed Uniti	Lombardia	Cremona	CR	6915
IT	26010	Rubbiano	Lombardia	Cremona	CR	6916
IT	26010	Casale Cremasco Vidolasco	Lombardia	Cremona	CR	6917
IT	26010	Casaletto Ceredano	Lombardia	Cremona	CR	6918
IT	26010	Camisano	Lombardia	Cremona	CR	6919
IT	26010	Casale Cremasco	Lombardia	Cremona	CR	6920
IT	26010	Rovereto	Lombardia	Cremona	CR	6921
IT	26010	Campagnola Cremasca	Lombardia	Cremona	CR	6922
IT	26010	Cremosano	Lombardia	Cremona	CR	6923
IT	26010	Zappello	Lombardia	Cremona	CR	6924
IT	26010	Sergnano	Lombardia	Cremona	CR	6925
IT	26010	Casaletto Vaprio	Lombardia	Cremona	CR	6926
IT	26010	Castelvisconti	Lombardia	Cremona	CR	6927
IT	26010	Ripalta Nuova	Lombardia	Cremona	CR	6928
IT	26010	Offanengo	Lombardia	Cremona	CR	6929
IT	26010	Pianengo	Lombardia	Cremona	CR	6930
IT	26010	Credera Rubbiano	Lombardia	Cremona	CR	6931
IT	26010	Ripalta Cremasca	Lombardia	Cremona	CR	6932
IT	26011	Casalbuttano	Lombardia	Cremona	CR	6933
IT	26011	Casalbuttano Ed Uniti	Lombardia	Cremona	CR	6934
IT	26012	Castelleone	Lombardia	Cremona	CR	6935
IT	26013	Santo Stefano In Vairano	Lombardia	Cremona	CR	6936
IT	26013	Crema	Lombardia	Cremona	CR	6937
IT	26013	Sabbioni	Lombardia	Cremona	CR	6938
IT	26013	Ombriano	Lombardia	Cremona	CR	6939
IT	26013	Santa Maria Della Croce	Lombardia	Cremona	CR	6940
IT	26014	Casaletto Di Sopra	Lombardia	Cremona	CR	6941
IT	26014	Romanengo	Lombardia	Cremona	CR	6942
IT	26015	Soresina	Lombardia	Cremona	CR	6943
IT	26016	Spino D'Adda	Lombardia	Cremona	CR	6944
IT	26017	Trescore Cremasco	Lombardia	Cremona	CR	6945
IT	26017	Pieranica	Lombardia	Cremona	CR	6946
IT	26017	Quintano	Lombardia	Cremona	CR	6947
IT	26017	Torlino Vimercati	Lombardia	Cremona	CR	6948
IT	26018	Trigolo	Lombardia	Cremona	CR	6949
IT	26019	Vailate	Lombardia	Cremona	CR	6950
IT	26020	Gombito	Lombardia	Cremona	CR	6951
IT	26020	Cumignano Sul Naviglio	Lombardia	Cremona	CR	6952
IT	26020	Cignone	Lombardia	Cremona	CR	6953
IT	26020	Crotta D'Adda	Lombardia	Cremona	CR	6954
IT	26020	Cascine Gandini	Lombardia	Cremona	CR	6955
IT	26020	San Bassano	Lombardia	Cremona	CR	6956
IT	26020	Casalmorano	Lombardia	Cremona	CR	6957
IT	26020	Fengo	Lombardia	Cremona	CR	6958
IT	26020	Madignano	Lombardia	Cremona	CR	6959
IT	26020	Cappella Cantone	Lombardia	Cremona	CR	6960
IT	26020	Ticengo	Lombardia	Cremona	CR	6961
IT	26020	Spinadesco	Lombardia	Cremona	CR	6962
IT	26020	Bordolano	Lombardia	Cremona	CR	6963
IT	26020	Formigara	Lombardia	Cremona	CR	6964
IT	26020	Corte De' Cortesi	Lombardia	Cremona	CR	6965
IT	26020	Scannabue	Lombardia	Cremona	CR	6966
IT	26020	Agnadello	Lombardia	Cremona	CR	6967
IT	26020	Acquanegra Cremonese	Lombardia	Cremona	CR	6968
IT	26020	Genivolta	Lombardia	Cremona	CR	6969
IT	26020	Palazzo Pignano	Lombardia	Cremona	CR	6970
IT	26020	Corte De' Cortesi Con Cignone	Lombardia	Cremona	CR	6971
IT	26021	Annicco	Lombardia	Cremona	CR	6972
IT	26021	Barzaniga	Lombardia	Cremona	CR	6973
IT	26022	Castelverde	Lombardia	Cremona	CR	6974
IT	26022	San Martino In Beliseto	Lombardia	Cremona	CR	6975
IT	26022	Costa Sant'Abramo	Lombardia	Cremona	CR	6976
IT	26023	Farfengo	Lombardia	Cremona	CR	6977
IT	26023	Grumello Cremonese	Lombardia	Cremona	CR	6978
IT	26023	Grumello Cremonese Ed Uniti	Lombardia	Cremona	CR	6979
IT	26024	Paderno Ponchielli	Lombardia	Cremona	CR	6980
IT	26025	Pandino	Lombardia	Cremona	CR	6981
IT	26025	Nosadello	Lombardia	Cremona	CR	6982
IT	26026	Pizzighettone	Lombardia	Cremona	CR	6983
IT	26026	Regona	Lombardia	Cremona	CR	6984
IT	26026	Roggione	Lombardia	Cremona	CR	6985
IT	26027	Rivolta D'Adda	Lombardia	Cremona	CR	6986
IT	26028	Sesto Cremonese	Lombardia	Cremona	CR	6987
IT	26028	Casanova Del Morbasco	Lombardia	Cremona	CR	6988
IT	26028	Sesto Ed Uniti	Lombardia	Cremona	CR	6989
IT	26029	Gallignano	Lombardia	Cremona	CR	6990
IT	26029	Soncino	Lombardia	Cremona	CR	6991
IT	26030	Ardole San Marino	Lombardia	Cremona	CR	6992
IT	26030	Volongo	Lombardia	Cremona	CR	6993
IT	26030	Gabbioneta	Lombardia	Cremona	CR	6994
IT	26030	Malagnino	Lombardia	Cremona	CR	6995
IT	26030	Solarolo Rainerio	Lombardia	Cremona	CR	6996
IT	26030	Cicognolo	Lombardia	Cremona	CR	6997
IT	26030	Ca' De' Mari	Lombardia	Cremona	CR	6998
IT	26030	Pessina Cremonese	Lombardia	Cremona	CR	6999
IT	26030	Casteldidone	Lombardia	Cremona	CR	7000
IT	26030	Binanuova	Lombardia	Cremona	CR	7001
IT	26030	Cappella De' Picenardi	Lombardia	Cremona	CR	7002
IT	26030	Spineda	Lombardia	Cremona	CR	7003
IT	26030	Ca' D'Andrea	Lombardia	Cremona	CR	7004
IT	26030	Voltido	Lombardia	Cremona	CR	7005
IT	26030	Tornata	Lombardia	Cremona	CR	7006
IT	26030	Calvatone	Lombardia	Cremona	CR	7007
IT	26030	Gabbioneta Binanuova	Lombardia	Cremona	CR	7008
IT	26030	Gadesco Pieve Delmona	Lombardia	Cremona	CR	7009
IT	26031	Isola Dovarese	Lombardia	Cremona	CR	7010
IT	26032	Ostiano	Lombardia	Cremona	CR	7011
IT	26033	Pieve Terzagni	Lombardia	Cremona	CR	7012
IT	26033	Pescarolo Ed Uniti	Lombardia	Cremona	CR	7013
IT	26033	Pescarolo	Lombardia	Cremona	CR	7014
IT	26034	Piadena	Lombardia	Cremona	CR	7015
IT	26034	Drizzona	Lombardia	Cremona	CR	7016
IT	26035	Pieve San Giacomo	Lombardia	Cremona	CR	7017
IT	26036	Rivarolo Del Re	Lombardia	Cremona	CR	7018
IT	26036	Rivarolo Del Re Ed Uniti	Lombardia	Cremona	CR	7019
IT	26037	San Giovanni In Croce	Lombardia	Cremona	CR	7020
IT	26038	San Lorenzo De' Picenardi	Lombardia	Cremona	CR	7021
IT	26038	Torre De' Picenardi	Lombardia	Cremona	CR	7022
IT	26039	Vescovato	Lombardia	Cremona	CR	7023
IT	26039	Ca' De' Stefani	Lombardia	Cremona	CR	7024
IT	26040	Derovere	Lombardia	Cremona	CR	7025
IT	26040	Torricella Del Pizzo	Lombardia	Cremona	CR	7026
IT	26040	Cella Dati	Lombardia	Cremona	CR	7027
IT	26040	Pieve D'Olmi	Lombardia	Cremona	CR	7028
IT	26040	Martignana Di Po	Lombardia	Cremona	CR	7029
IT	26040	Bonemerse	Lombardia	Cremona	CR	7030
IT	26040	Gussola	Lombardia	Cremona	CR	7031
IT	26040	San Martino Del Lago	Lombardia	Cremona	CR	7032
IT	26040	Scandolara Ravara	Lombardia	Cremona	CR	7033
IT	26040	Castelponzone	Lombardia	Cremona	CR	7034
IT	26040	Gerre De' Caprioli	Lombardia	Cremona	CR	7035
IT	26041	Vicomoscano	Lombardia	Cremona	CR	7036
IT	26041	Vicoboneghisio	Lombardia	Cremona	CR	7037
IT	26041	Quattrocase	Lombardia	Cremona	CR	7038
IT	26041	Casalbellotto	Lombardia	Cremona	CR	7039
IT	26041	Roncadello	Lombardia	Cremona	CR	7040
IT	26041	Casalmaggiore	Lombardia	Cremona	CR	7041
IT	26041	Vicobellignano	Lombardia	Cremona	CR	7042
IT	26041	Agoiolo	Lombardia	Cremona	CR	7043
IT	26042	Cingia De' Botti	Lombardia	Cremona	CR	7044
IT	26043	Dosimo	Lombardia	Cremona	CR	7045
IT	26043	Persico Dosimo	Lombardia	Cremona	CR	7046
IT	26043	Persichello	Lombardia	Cremona	CR	7047
IT	26044	Levata	Lombardia	Cremona	CR	7048
IT	26044	Grontardo	Lombardia	Cremona	CR	7049
IT	26045	Motta Baluffi	Lombardia	Cremona	CR	7050
IT	26046	San Daniele Po	Lombardia	Cremona	CR	7051
IT	26047	Scandolara Ripa D'Oglio	Lombardia	Cremona	CR	7052
IT	26048	Sospiro	Lombardia	Cremona	CR	7053
IT	26048	San Salvatore	Lombardia	Cremona	CR	7054
IT	26049	Stagno Lombardo	Lombardia	Cremona	CR	7055
IT	26100	Migliaro	Lombardia	Cremona	CR	7056
IT	26100	Boschetto	Lombardia	Cremona	CR	7057
IT	26100	Maristella	Lombardia	Cremona	CR	7058
IT	26100	Cremona	Lombardia	Cremona	CR	7059
IT	26100	Cava Tigozzi	Lombardia	Cremona	CR	7060
IT	26100	San Felice	Lombardia	Cremona	CR	7061
IT	23801	Calolziocorte	Lombardia	Lecco	LC	7062
IT	23801	Rossino	Lombardia	Lecco	LC	7063
IT	23802	Carenno	Lombardia	Lecco	LC	7064
IT	23804	Monte Marenzo	Lombardia	Lecco	LC	7065
IT	23805	Erve	Lombardia	Lecco	LC	7066
IT	23806	San Gottardo	Lombardia	Lecco	LC	7067
IT	23806	Valcava	Lombardia	Lecco	LC	7068
IT	23806	Favirano	Lombardia	Lecco	LC	7069
IT	23806	Torre De' Busi	Lombardia	Lecco	LC	7070
IT	23807	Merate	Lombardia	Lecco	LC	7071
IT	23807	Cassina Fra Martino	Lombardia	Lecco	LC	7072
IT	23808	Vercurago	Lombardia	Lecco	LC	7073
IT	23811	Ballabio	Lombardia	Lecco	LC	7074
IT	23811	Morterone	Lombardia	Lecco	LC	7075
IT	23813	Bindo	Lombardia	Lecco	LC	7076
IT	23813	Cortenova	Lombardia	Lecco	LC	7077
IT	23814	Maggio	Lombardia	Lecco	LC	7078
IT	23814	Cremeno	Lombardia	Lecco	LC	7079
IT	23815	Introbio	Lombardia	Lecco	LC	7080
IT	23816	Barzio	Lombardia	Lecco	LC	7081
IT	23817	Cassina Valsassina	Lombardia	Lecco	LC	7082
IT	23817	Moggio	Lombardia	Lecco	LC	7083
IT	23818	Pasturo	Lombardia	Lecco	LC	7084
IT	23819	Cortabbio	Lombardia	Lecco	LC	7085
IT	23819	Primaluna	Lombardia	Lecco	LC	7086
IT	23821	Abbadia Lariana	Lombardia	Lecco	LC	7087
IT	23821	Crebbio	Lombardia	Lecco	LC	7088
IT	23822	Bellano	Lombardia	Lecco	LC	7089
IT	23822	Vestreno	Lombardia	Lecco	LC	7090
IT	23823	Colico	Lombardia	Lecco	LC	7091
IT	23823	Colico Piano	Lombardia	Lecco	LC	7092
IT	23824	Dorio	Lombardia	Lecco	LC	7093
IT	23824	Dervio	Lombardia	Lecco	LC	7094
IT	23825	Esino Lario	Lombardia	Lecco	LC	7095
IT	23826	Mandello Del Lario	Lombardia	Lecco	LC	7096
IT	23827	Lierna	Lombardia	Lecco	LC	7097
IT	23828	Perledo	Lombardia	Lecco	LC	7098
IT	23829	Varenna	Lombardia	Lecco	LC	7099
IT	23829	Fiumelatte	Lombardia	Lecco	LC	7100
IT	23831	Casargo	Lombardia	Lecco	LC	7101
IT	23832	Crandola Valsassina	Lombardia	Lecco	LC	7102
IT	23832	Margno	Lombardia	Lecco	LC	7103
IT	23833	Pagnona	Lombardia	Lecco	LC	7104
IT	23834	Premana	Lombardia	Lecco	LC	7105
IT	23835	Introzzo	Lombardia	Lecco	LC	7106
IT	23835	Sueglio	Lombardia	Lecco	LC	7107
IT	23836	Tremenico	Lombardia	Lecco	LC	7108
IT	23837	Taceno	Lombardia	Lecco	LC	7109
IT	23837	Parlasco	Lombardia	Lecco	LC	7110
IT	23838	Vendrogno	Lombardia	Lecco	LC	7111
IT	23841	Annone Di Brianza	Lombardia	Lecco	LC	7112
IT	23842	Bosisio Parini	Lombardia	Lecco	LC	7113
IT	23843	Dolzago	Lombardia	Lecco	LC	7114
IT	23844	Sirone	Lombardia	Lecco	LC	7115
IT	23845	Costa Masnaga	Lombardia	Lecco	LC	7116
IT	23845	Camisasca	Lombardia	Lecco	LC	7117
IT	23846	Brongio	Lombardia	Lecco	LC	7118
IT	23846	Garbagnate Monastero	Lombardia	Lecco	LC	7119
IT	23847	Luzzana	Lombardia	Lecco	LC	7120
IT	23847	Molteno	Lombardia	Lecco	LC	7121
IT	23848	Ello	Lombardia	Lecco	LC	7122
IT	23848	Oggiono	Lombardia	Lecco	LC	7123
IT	23849	Casletto	Lombardia	Lecco	LC	7124
IT	23849	Rogeno	Lombardia	Lecco	LC	7125
IT	23851	Sala Al Barro	Lombardia	Lecco	LC	7126
IT	23851	Galbiate	Lombardia	Lecco	LC	7127
IT	23851	Vergano Villa	Lombardia	Lecco	LC	7128
IT	23852	Garlate	Lombardia	Lecco	LC	7129
IT	23854	Olginate	Lombardia	Lecco	LC	7130
IT	23855	Pescate	Lombardia	Lecco	LC	7131
IT	23857	Valgreghentino	Lombardia	Lecco	LC	7132
IT	23861	Cesana Brianza	Lombardia	Lecco	LC	7133
IT	23862	Civate	Lombardia	Lecco	LC	7134
IT	23864	Malgrate	Lombardia	Lecco	LC	7135
IT	23865	Limonta	Lombardia	Lecco	LC	7136
IT	23865	Oliveto Lario	Lombardia	Lecco	LC	7137
IT	23865	Onno	Lombardia	Lecco	LC	7138
IT	23867	Suello	Lombardia	Lecco	LC	7139
IT	23868	Caserta	Lombardia	Lecco	LC	7140
IT	23868	Valmadrera	Lombardia	Lecco	LC	7141
IT	23870	Cernusco Lombardone	Lombardia	Lecco	LC	7142
IT	23871	Lomagna	Lombardia	Lecco	LC	7143
IT	23873	Missaglia	Lombardia	Lecco	LC	7144
IT	23873	Maresso	Lombardia	Lecco	LC	7145
IT	23874	Quattro Strade	Lombardia	Lecco	LC	7146
IT	23874	Montevecchia	Lombardia	Lecco	LC	7147
IT	23875	Osnago	Lombardia	Lecco	LC	7148
IT	23876	Monticello Brianza	Lombardia	Lecco	LC	7149
IT	23877	Paderno D'Adda	Lombardia	Lecco	LC	7150
IT	23878	Verderio Superiore	Lombardia	Lecco	LC	7151
IT	23879	Verderio	Lombardia	Lecco	LC	7152
IT	23879	Verderio Inferiore	Lombardia	Lecco	LC	7153
IT	23880	Galgiana	Lombardia	Lecco	LC	7154
IT	23880	Campofiorenzo	Lombardia	Lecco	LC	7155
IT	23880	Rimoldo	Lombardia	Lecco	LC	7156
IT	23880	California	Lombardia	Lecco	LC	7157
IT	23880	Casatenovo	Lombardia	Lecco	LC	7158
IT	23880	Valaperta	Lombardia	Lecco	LC	7159
IT	23880	Rogoredo	Lombardia	Lecco	LC	7160
IT	23881	Airuno	Lombardia	Lecco	LC	7161
IT	23883	Brivio	Lombardia	Lecco	LC	7162
IT	23883	Beverate	Lombardia	Lecco	LC	7163
IT	23884	Castello Di Brianza	Lombardia	Lecco	LC	7164
IT	23884	Cologna	Lombardia	Lecco	LC	7165
IT	23884	Caraverio	Lombardia	Lecco	LC	7166
IT	23885	Calco	Lombardia	Lecco	LC	7167
IT	23885	Arlate	Lombardia	Lecco	LC	7168
IT	23886	Colle Brianza	Lombardia	Lecco	LC	7169
IT	23886	Nava	Lombardia	Lecco	LC	7170
IT	23887	Monticello	Lombardia	Lecco	LC	7171
IT	23887	Olgiate Molgora	Lombardia	Lecco	LC	7172
IT	23887	Canova	Lombardia	Lecco	LC	7173
IT	23888	Perego	Lombardia	Lecco	LC	7174
IT	23888	Rovagnate	Lombardia	Lecco	LC	7175
IT	23888	La Valletta Brianza	Lombardia	Lecco	LC	7176
IT	23889	Santa Maria Hoe'	Lombardia	Lecco	LC	7177
IT	23890	Barzago	Lombardia	Lecco	LC	7178
IT	23891	Barzano'	Lombardia	Lecco	LC	7179
IT	23892	Bulciago	Lombardia	Lecco	LC	7180
IT	23893	Cassago Brianza	Lombardia	Lecco	LC	7181
IT	23894	Cremella	Lombardia	Lecco	LC	7182
IT	23895	Nibionno	Lombardia	Lecco	LC	7183
IT	23895	Tabiago	Lombardia	Lecco	LC	7184
IT	23895	Cibrone	Lombardia	Lecco	LC	7185
IT	23896	Bevera Di Sirtori	Lombardia	Lecco	LC	7186
IT	23896	Sirtori	Lombardia	Lecco	LC	7187
IT	23897	Vigano'	Lombardia	Lecco	LC	7188
IT	23898	Imbersago	Lombardia	Lecco	LC	7189
IT	23899	Robbiate	Lombardia	Lecco	LC	7190
IT	23900	Lecco	Lombardia	Lecco	LC	7191
IT	26811	Boffalora D'Adda	Lombardia	Lodi	LO	7192
IT	26812	Borghetto Lodigiano	Lombardia	Lodi	LO	7193
IT	26812	Casoni	Lombardia	Lodi	LO	7194
IT	26813	Graffignana	Lombardia	Lodi	LO	7195
IT	26814	Livraga	Lombardia	Lodi	LO	7196
IT	26815	Motta Vigana	Lombardia	Lodi	LO	7197
IT	26815	Massalengo	Lombardia	Lodi	LO	7198
IT	26816	Ossago Lodigiano	Lombardia	Lodi	LO	7199
IT	26817	San Martino In Strada	Lombardia	Lodi	LO	7200
IT	26818	Bargano	Lombardia	Lodi	LO	7201
IT	26818	Villanova Del Sillaro	Lombardia	Lodi	LO	7202
IT	26821	Bertonico	Lombardia	Lodi	LO	7203
IT	26822	Brembio	Lombardia	Lodi	LO	7204
IT	26823	Castiglione D'Adda	Lombardia	Lodi	LO	7205
IT	26823	Camairago	Lombardia	Lodi	LO	7206
IT	26824	Cavenago D'Adda	Lombardia	Lodi	LO	7207
IT	26825	Basiasco	Lombardia	Lodi	LO	7208
IT	26825	Mairago	Lombardia	Lodi	LO	7209
IT	26826	Secugnago	Lombardia	Lodi	LO	7210
IT	26827	Terranova Dei Passerini	Lombardia	Lodi	LO	7211
IT	26828	Turano Lodigiano	Lombardia	Lodi	LO	7212
IT	26828	Melegnanello	Lombardia	Lodi	LO	7213
IT	26831	Cologno	Lombardia	Lodi	LO	7214
IT	26831	Casalmaiocco	Lombardia	Lodi	LO	7215
IT	26832	Cervignano D'Adda	Lombardia	Lodi	LO	7216
IT	26832	Galgagnano	Lombardia	Lodi	LO	7217
IT	26833	Comazzo	Lombardia	Lodi	LO	7218
IT	26833	Merlino	Lombardia	Lodi	LO	7219
IT	26834	Cadilana	Lombardia	Lodi	LO	7220
IT	26834	Abbadia Cerreto	Lombardia	Lodi	LO	7221
IT	26834	Terraverde	Lombardia	Lodi	LO	7222
IT	26834	Corte Palasio	Lombardia	Lodi	LO	7223
IT	26835	Crespiatica	Lombardia	Lodi	LO	7224
IT	26836	Montanaso Lombardo	Lombardia	Lodi	LO	7225
IT	26837	Cassino D'Alberi	Lombardia	Lodi	LO	7226
IT	26837	Quartiano	Lombardia	Lodi	LO	7227
IT	26837	Mulazzano	Lombardia	Lodi	LO	7228
IT	26838	Tavazzano	Lombardia	Lodi	LO	7229
IT	26838	Villavesco	Lombardia	Lodi	LO	7230
IT	26838	Tavazzano Con Villavesco	Lombardia	Lodi	LO	7231
IT	26839	Zelo Buon Persico	Lombardia	Lodi	LO	7232
IT	26841	Zorlesco	Lombardia	Lodi	LO	7233
IT	26841	Casalpusterlengo	Lombardia	Lodi	LO	7234
IT	26842	Caselle Landi	Lombardia	Lodi	LO	7235
IT	26842	Cornovecchio	Lombardia	Lodi	LO	7236
IT	26843	Meleti	Lombardia	Lodi	LO	7237
IT	26843	Castelnuovo Bocca D'Adda	Lombardia	Lodi	LO	7238
IT	26843	Maccastorna	Lombardia	Lodi	LO	7239
IT	26844	Cavacurta	Lombardia	Lodi	LO	7240
IT	26845	Codogno	Lombardia	Lodi	LO	7241
IT	26846	Corno Giovine	Lombardia	Lodi	LO	7242
IT	26847	Maleo	Lombardia	Lodi	LO	7243
IT	26848	San Fiorano	Lombardia	Lodi	LO	7244
IT	26849	Santo Stefano Lodigiano	Lombardia	Lodi	LO	7245
IT	26851	Borgo San Giovanni	Lombardia	Lodi	LO	7246
IT	26852	Mairano	Lombardia	Lodi	LO	7247
IT	26852	Casaletto Lodigiano	Lombardia	Lodi	LO	7248
IT	26853	Caselle Lurani	Lombardia	Lodi	LO	7249
IT	26854	Cornegliano Laudense	Lombardia	Lodi	LO	7250
IT	26854	Pieve Fissiraga	Lombardia	Lodi	LO	7251
IT	26854	Muzza Sant'Angelo	Lombardia	Lodi	LO	7252
IT	26855	Lodi Vecchio	Lombardia	Lodi	LO	7253
IT	26856	Senna Lodigiana	Lombardia	Lodi	LO	7254
IT	26856	Mirabello	Lombardia	Lodi	LO	7255
IT	26857	Salerano Sul Lambro	Lombardia	Lodi	LO	7256
IT	26858	Sordio	Lombardia	Lodi	LO	7257
IT	26859	Valera Fratta	Lombardia	Lodi	LO	7258
IT	26861	Fombio	Lombardia	Lodi	LO	7259
IT	26861	Retegno	Lombardia	Lodi	LO	7260
IT	26862	Guardamiglio	Lombardia	Lodi	LO	7261
IT	26863	Orio Litta	Lombardia	Lodi	LO	7262
IT	26864	Ospedaletto Lodigiano	Lombardia	Lodi	LO	7263
IT	26865	San Rocco Al Porto	Lombardia	Lodi	LO	7264
IT	26866	Marudo	Lombardia	Lodi	LO	7265
IT	26866	Castiraga Vidardo	Lombardia	Lodi	LO	7266
IT	26866	Sant'Angelo Lodigiano	Lombardia	Lodi	LO	7267
IT	26866	Vidardo	Lombardia	Lodi	LO	7268
IT	26867	Somaglia	Lombardia	Lodi	LO	7269
IT	26867	San Martino Pizzolano	Lombardia	Lodi	LO	7270
IT	26900	Lodi	Lombardia	Lodi	LO	7271
IT	26900	San Grato	Lombardia	Lodi	LO	7272
IT	20811	Cesano Maderno	Lombardia	Monza e Brianza	MB	7273
IT	20811	Villaggio Snia	Lombardia	Monza e Brianza	MB	7274
IT	20811	Binzago	Lombardia	Monza e Brianza	MB	7275
IT	20811	Cassina Savina	Lombardia	Monza e Brianza	MB	7276
IT	20812	Limbiate	Lombardia	Monza e Brianza	MB	7277
IT	20812	Villaggio Del Sole	Lombardia	Monza e Brianza	MB	7278
IT	20812	Mombello	Lombardia	Monza e Brianza	MB	7279
IT	20812	Villaggio Dei Giovi	Lombardia	Monza e Brianza	MB	7280
IT	20813	Bovisio-Masciago	Lombardia	Monza e Brianza	MB	7281
IT	20813	Bovisio	Lombardia	Monza e Brianza	MB	7282
IT	20813	Masciago	Lombardia	Monza e Brianza	MB	7283
IT	20814	Varedo	Lombardia	Monza e Brianza	MB	7284
IT	20814	Valera	Lombardia	Monza e Brianza	MB	7285
IT	20815	Cogliate	Lombardia	Monza e Brianza	MB	7286
IT	20816	Dal Pozzo	Lombardia	Monza e Brianza	MB	7287
IT	20816	Ceriano Laghetto	Lombardia	Monza e Brianza	MB	7288
IT	20821	Meda	Lombardia	Monza e Brianza	MB	7289
IT	20822	Seveso	Lombardia	Monza e Brianza	MB	7290
IT	20822	Baruccana	Lombardia	Monza e Brianza	MB	7291
IT	20823	Camnago	Lombardia	Monza e Brianza	MB	7292
IT	20823	Lentate Sul Seveso	Lombardia	Monza e Brianza	MB	7293
IT	20823	Cimnago	Lombardia	Monza e Brianza	MB	7294
IT	20824	Lazzate	Lombardia	Monza e Brianza	MB	7295
IT	20825	Barlassina	Lombardia	Monza e Brianza	MB	7296
IT	20826	Cascina Nuova	Lombardia	Monza e Brianza	MB	7297
IT	20826	Misinto	Lombardia	Monza e Brianza	MB	7298
IT	20831	Seregno	Lombardia	Monza e Brianza	MB	7299
IT	20832	Desio	Lombardia	Monza e Brianza	MB	7300
IT	20833	Robbiano Di Giussano	Lombardia	Monza e Brianza	MB	7301
IT	20833	Giussano	Lombardia	Monza e Brianza	MB	7302
IT	20833	Paina	Lombardia	Monza e Brianza	MB	7303
IT	20834	Nova Milanese	Lombardia	Monza e Brianza	MB	7304
IT	20835	Muggio'	Lombardia	Monza e Brianza	MB	7305
IT	20835	Taccona	Lombardia	Monza e Brianza	MB	7306
IT	20836	Fornaci	Lombardia	Monza e Brianza	MB	7307
IT	20836	Capriano	Lombardia	Monza e Brianza	MB	7308
IT	20836	Briosco	Lombardia	Monza e Brianza	MB	7309
IT	20837	Veduggio Con Colzano	Lombardia	Monza e Brianza	MB	7310
IT	20838	Renate	Lombardia	Monza e Brianza	MB	7311
IT	20841	Agliate	Lombardia	Monza e Brianza	MB	7312
IT	20841	Carate Brianza	Lombardia	Monza e Brianza	MB	7313
IT	20842	Zoccorino	Lombardia	Monza e Brianza	MB	7314
IT	20842	Besana In Brianza	Lombardia	Monza e Brianza	MB	7315
IT	20842	Villa Raverio	Lombardia	Monza e Brianza	MB	7316
IT	20843	Verano Brianza	Lombardia	Monza e Brianza	MB	7317
IT	20844	Tregasio	Lombardia	Monza e Brianza	MB	7318
IT	20844	Triuggio	Lombardia	Monza e Brianza	MB	7319
IT	20844	Canonica	Lombardia	Monza e Brianza	MB	7320
IT	20845	Sovico	Lombardia	Monza e Brianza	MB	7321
IT	20846	Macherio	Lombardia	Monza e Brianza	MB	7322
IT	20847	Albiate	Lombardia	Monza e Brianza	MB	7323
IT	20851	Lissone	Lombardia	Monza e Brianza	MB	7324
IT	20851	Santa Margherita	Lombardia	Monza e Brianza	MB	7325
IT	20852	Villasanta	Lombardia	Monza e Brianza	MB	7326
IT	20853	Biassono	Lombardia	Monza e Brianza	MB	7327
IT	20854	Vedano Al Lambro	Lombardia	Monza e Brianza	MB	7328
IT	20855	Peregallo	Lombardia	Monza e Brianza	MB	7329
IT	20855	Lesmo	Lombardia	Monza e Brianza	MB	7330
IT	20856	Correzzana	Lombardia	Monza e Brianza	MB	7331
IT	20857	Camparada	Lombardia	Monza e Brianza	MB	7332
IT	20861	Brugherio	Lombardia	Monza e Brianza	MB	7333
IT	20861	San Damiano	Lombardia	Monza e Brianza	MB	7334
IT	20862	Arcore	Lombardia	Monza e Brianza	MB	7335
IT	20863	Concorezzo	Lombardia	Monza e Brianza	MB	7336
IT	20864	Agrate Brianza	Lombardia	Monza e Brianza	MB	7337
IT	20864	Omate	Lombardia	Monza e Brianza	MB	7338
IT	20865	Usmate Velate	Lombardia	Monza e Brianza	MB	7339
IT	20865	Velate	Lombardia	Monza e Brianza	MB	7340
IT	20866	Carnate	Lombardia	Monza e Brianza	MB	7341
IT	20867	Caponago	Lombardia	Monza e Brianza	MB	7342
IT	20871	Vimercate	Lombardia	Monza e Brianza	MB	7343
IT	20871	Oreno	Lombardia	Monza e Brianza	MB	7344
IT	20871	Velasca	Lombardia	Monza e Brianza	MB	7345
IT	20872	Porto D'Adda	Lombardia	Monza e Brianza	MB	7346
IT	20872	Cornate D'Adda	Lombardia	Monza e Brianza	MB	7347
IT	20872	Colnago	Lombardia	Monza e Brianza	MB	7348
IT	20873	Cavenago Di Brianza	Lombardia	Monza e Brianza	MB	7349
IT	20874	Busnago	Lombardia	Monza e Brianza	MB	7350
IT	20875	Burago Di Molgora	Lombardia	Monza e Brianza	MB	7351
IT	20876	Ornago	Lombardia	Monza e Brianza	MB	7352
IT	20877	Roncello	Lombardia	Monza e Brianza	MB	7353
IT	20881	Bernareggio	Lombardia	Monza e Brianza	MB	7354
IT	20881	Villanova	Lombardia	Monza e Brianza	MB	7355
IT	20882	Bellusco	Lombardia	Monza e Brianza	MB	7356
IT	20883	Mezzago	Lombardia	Monza e Brianza	MB	7357
IT	20884	Sulbiate	Lombardia	Monza e Brianza	MB	7358
IT	20885	Ronco Briantino	Lombardia	Monza e Brianza	MB	7359
IT	20886	Aicurzio	Lombardia	Monza e Brianza	MB	7360
IT	20900	Monza	Lombardia	Monza e Brianza	MB	7361
IT	20900	San Fruttuoso	Lombardia	Monza e Brianza	MB	7362
IT	20010	Pregnana Milanese	Lombardia	Milano	MI	7363
IT	20010	Vanzago	Lombardia	Milano	MI	7364
IT	20010	Santo Stefano Ticino	Lombardia	Milano	MI	7365
IT	20010	Vittuone	Lombardia	Milano	MI	7366
IT	20010	Inveruno	Lombardia	Milano	MI	7367
IT	20010	Buscate	Lombardia	Milano	MI	7368
IT	20010	San Giorgio Su Legnano	Lombardia	Milano	MI	7369
IT	20010	Canegrate	Lombardia	Milano	MI	7370
IT	20010	Marcallo Con Casone	Lombardia	Milano	MI	7371
IT	20010	Casone	Lombardia	Milano	MI	7372
IT	20010	Casorezzo	Lombardia	Milano	MI	7373
IT	20010	Ossona	Lombardia	Milano	MI	7374
IT	20010	Casate	Lombardia	Milano	MI	7375
IT	20010	Boffalora Sopra Ticino	Lombardia	Milano	MI	7376
IT	20010	Pogliano Milanese	Lombardia	Milano	MI	7377
IT	20010	Mesero	Lombardia	Milano	MI	7378
IT	20010	San Pietro All'Olmo	Lombardia	Milano	MI	7379
IT	20010	Bareggio	Lombardia	Milano	MI	7380
IT	20010	Arluno	Lombardia	Milano	MI	7381
IT	20010	Cornaredo	Lombardia	Milano	MI	7382
IT	20010	Rogorotto	Lombardia	Milano	MI	7383
IT	20010	Furato	Lombardia	Milano	MI	7384
IT	20010	Bernate Ticino	Lombardia	Milano	MI	7385
IT	20010	Mantegazza	Lombardia	Milano	MI	7386
IT	20011	Corbetta	Lombardia	Milano	MI	7387
IT	20011	Cerello	Lombardia	Milano	MI	7388
IT	20011	Battuello	Lombardia	Milano	MI	7389
IT	20012	Cuggiono	Lombardia	Milano	MI	7390
IT	20013	Magenta	Lombardia	Milano	MI	7391
IT	20013	Ponte Nuovo	Lombardia	Milano	MI	7392
IT	20014	Nerviano	Lombardia	Milano	MI	7393
IT	20014	Sant'Ilario Milanese	Lombardia	Milano	MI	7394
IT	20015	Villastanza	Lombardia	Milano	MI	7395
IT	20015	Parabiago	Lombardia	Milano	MI	7396
IT	20016	Pero	Lombardia	Milano	MI	7397
IT	20016	Cerchiate	Lombardia	Milano	MI	7398
IT	20017	Passirana	Lombardia	Milano	MI	7399
IT	20017	Rho	Lombardia	Milano	MI	7400
IT	20017	Lucernate	Lombardia	Milano	MI	7401
IT	20017	Mazzo Milanese	Lombardia	Milano	MI	7402
IT	20017	Terrazzano	Lombardia	Milano	MI	7403
IT	20018	Sedriano	Lombardia	Milano	MI	7404
IT	20019	Settimo Milanese	Lombardia	Milano	MI	7405
IT	20019	Vighignolo	Lombardia	Milano	MI	7406
IT	20020	Dairago	Lombardia	Milano	MI	7407
IT	20020	Magnago	Lombardia	Milano	MI	7408
IT	20020	Arese	Lombardia	Milano	MI	7409
IT	20020	Lainate	Lombardia	Milano	MI	7410
IT	20020	Nosate	Lombardia	Milano	MI	7411
IT	20020	Robecchetto Con Induno	Lombardia	Milano	MI	7412
IT	20020	Barbaiana	Lombardia	Milano	MI	7413
IT	20020	Vanzaghello	Lombardia	Milano	MI	7414
IT	20020	Villa Cortese	Lombardia	Milano	MI	7415
IT	20020	Arconate	Lombardia	Milano	MI	7416
IT	20020	Busto Garolfo	Lombardia	Milano	MI	7417
IT	20020	Solaro	Lombardia	Milano	MI	7418
IT	20020	Cesate	Lombardia	Milano	MI	7419
IT	20020	Cascina Nuova Di Misinto	Lombardia	Milano	MI	7420
IT	20020	Bienate	Lombardia	Milano	MI	7421
IT	20020	Villaggio Brollo	Lombardia	Milano	MI	7422
IT	20021	Bollate	Lombardia	Milano	MI	7423
IT	20021	Baranzate	Lombardia	Milano	MI	7424
IT	20021	Cassina Nuova	Lombardia	Milano	MI	7425
IT	20022	Castano Primo	Lombardia	Milano	MI	7426
IT	20023	Cerro Maggiore	Lombardia	Milano	MI	7427
IT	20023	Cantalupo	Lombardia	Milano	MI	7428
IT	20024	Villaggio Garbagnate	Lombardia	Milano	MI	7429
IT	20024	Garbagnate Milanese	Lombardia	Milano	MI	7430
IT	20025	Legnano	Lombardia	Milano	MI	7431
IT	20026	Novate Milanese	Lombardia	Milano	MI	7432
IT	20027	Rescalda	Lombardia	Milano	MI	7433
IT	20027	Rescaldina	Lombardia	Milano	MI	7434
IT	20028	San Vittore Olona	Lombardia	Milano	MI	7435
IT	20029	Turbigo	Lombardia	Milano	MI	7436
IT	20030	Senago	Lombardia	Milano	MI	7437
IT	20032	Cormano	Lombardia	Milano	MI	7438
IT	20032	Brusuglio	Lombardia	Milano	MI	7439
IT	20032	Ospitaletto	Lombardia	Milano	MI	7440
IT	20037	Paderno Dugnano	Lombardia	Milano	MI	7441
IT	20037	Palazzolo Milanese	Lombardia	Milano	MI	7442
IT	20040	Torrazza Dei Mandelli	Lombardia	Milano	MI	7443
IT	20040	Cambiago	Lombardia	Milano	MI	7444
IT	20040	Velate Milanese	Lombardia	Milano	MI	7445
IT	20056	Grezzago	Lombardia	Milano	MI	7446
IT	20056	Trezzo Sull'Adda	Lombardia	Milano	MI	7447
IT	20056	Concesa	Lombardia	Milano	MI	7448
IT	20060	Villa Fornaci	Lombardia	Milano	MI	7449
IT	20060	Albignano	Lombardia	Milano	MI	7450
IT	20060	Cassina De' Pecchi	Lombardia	Milano	MI	7451
IT	20060	Triginto	Lombardia	Milano	MI	7452
IT	20060	Colturano	Lombardia	Milano	MI	7453
IT	20060	Bellinzago Lombardo	Lombardia	Milano	MI	7454
IT	20060	Mombretto	Lombardia	Milano	MI	7455
IT	20060	Bustighera	Lombardia	Milano	MI	7456
IT	20060	Pozzuolo Martesana	Lombardia	Milano	MI	7457
IT	20060	Masate	Lombardia	Milano	MI	7458
IT	20060	Gessate	Lombardia	Milano	MI	7459
IT	20060	Basiano	Lombardia	Milano	MI	7460
IT	20060	Pessano Con Bornago	Lombardia	Milano	MI	7461
IT	20060	Liscate	Lombardia	Milano	MI	7462
IT	20060	Mediglia	Lombardia	Milano	MI	7463
IT	20060	Trecella	Lombardia	Milano	MI	7464
IT	20060	Balbiano	Lombardia	Milano	MI	7465
IT	20060	Trezzano Rosa	Lombardia	Milano	MI	7466
IT	20060	Bussero	Lombardia	Milano	MI	7467
IT	20060	Vignate	Lombardia	Milano	MI	7468
IT	20060	Sant'Agata Martesana	Lombardia	Milano	MI	7469
IT	20060	Pozzo D'Adda	Lombardia	Milano	MI	7470
IT	20060	Truccazzano	Lombardia	Milano	MI	7471
IT	20060	Vigliano	Lombardia	Milano	MI	7472
IT	20060	Bornago	Lombardia	Milano	MI	7473
IT	20060	Bettola Di Pozzo D'Adda	Lombardia	Milano	MI	7474
IT	20060	Albignano D'Adda	Lombardia	Milano	MI	7475
IT	20061	Carugate	Lombardia	Milano	MI	7476
IT	20062	Cassano D'Adda	Lombardia	Milano	MI	7477
IT	20062	Cascine San Pietro	Lombardia	Milano	MI	7478
IT	20062	Groppello D'Adda	Lombardia	Milano	MI	7479
IT	20063	Cernusco Sul Naviglio	Lombardia	Milano	MI	7480
IT	20064	Gorgonzola	Lombardia	Milano	MI	7481
IT	20065	Inzago	Lombardia	Milano	MI	7482
IT	20066	Melzo	Lombardia	Milano	MI	7483
IT	20067	Paullo	Lombardia	Milano	MI	7484
IT	20067	Tribiano	Lombardia	Milano	MI	7485
IT	20068	Linate	Lombardia	Milano	MI	7486
IT	20068	Bellaria	Lombardia	Milano	MI	7487
IT	20068	Mezzate	Lombardia	Milano	MI	7488
IT	20068	Peschiera Borromeo	Lombardia	Milano	MI	7489
IT	20068	Linate Paese	Lombardia	Milano	MI	7490
IT	20068	Zeloforomagno	Lombardia	Milano	MI	7491
IT	20068	San Bovio	Lombardia	Milano	MI	7492
IT	20068	Bettola	Lombardia	Milano	MI	7493
IT	20069	Vaprio D'Adda	Lombardia	Milano	MI	7494
IT	20070	Dresano	Lombardia	Milano	MI	7495
IT	20070	Villa Bissone	Lombardia	Milano	MI	7496
IT	20070	Riozzo	Lombardia	Milano	MI	7497
IT	20070	Vizzolo Predabissi	Lombardia	Milano	MI	7498
IT	20070	Sarmazzano	Lombardia	Milano	MI	7499
IT	20070	San Zenone Al Lambro	Lombardia	Milano	MI	7500
IT	20070	Cerro Al Lambro	Lombardia	Milano	MI	7501
IT	20077	Melegnano	Lombardia	Milano	MI	7502
IT	20078	San Colombano Al Lambro	Lombardia	Milano	MI	7503
IT	20080	Zelo Surrigone	Lombardia	Milano	MI	7504
IT	20080	Moirago	Lombardia	Milano	MI	7505
IT	20080	Basiglio	Lombardia	Milano	MI	7506
IT	20080	Zibido San Giacomo	Lombardia	Milano	MI	7507
IT	20080	Vernate	Lombardia	Milano	MI	7508
IT	20080	Carpiano	Lombardia	Milano	MI	7509
IT	20080	Besate	Lombardia	Milano	MI	7510
IT	20080	Moncucco	Lombardia	Milano	MI	7511
IT	20080	Albairate	Lombardia	Milano	MI	7512
IT	20080	Casarile	Lombardia	Milano	MI	7513
IT	20080	Cisliano	Lombardia	Milano	MI	7514
IT	20080	San Pietro Cusico	Lombardia	Milano	MI	7515
IT	20080	Bubbiano	Lombardia	Milano	MI	7516
IT	20080	Ozzero	Lombardia	Milano	MI	7517
IT	20080	Pasturago	Lombardia	Milano	MI	7518
IT	20080	Calvignasco	Lombardia	Milano	MI	7519
IT	20080	Badile	Lombardia	Milano	MI	7520
IT	20080	Vermezzo	Lombardia	Milano	MI	7521
IT	20081	Cassinetta Di Lugagnano	Lombardia	Milano	MI	7522
IT	20081	Morimondo	Lombardia	Milano	MI	7523
IT	20081	Abbiategrasso	Lombardia	Milano	MI	7524
IT	20082	Noviglio	Lombardia	Milano	MI	7525
IT	20082	Santa Corinna	Lombardia	Milano	MI	7526
IT	20082	Binasco	Lombardia	Milano	MI	7527
IT	20083	Gaggiano	Lombardia	Milano	MI	7528
IT	20083	San Vito	Lombardia	Milano	MI	7529
IT	20083	Vigano	Lombardia	Milano	MI	7530
IT	20084	Lacchiarella	Lombardia	Milano	MI	7531
IT	20085	Locate Di Triulzi	Lombardia	Milano	MI	7532
IT	20086	Motta Visconti	Lombardia	Milano	MI	7533
IT	20087	Castellazzo De' Barzi	Lombardia	Milano	MI	7534
IT	20087	Robecco Sul Naviglio	Lombardia	Milano	MI	7535
IT	20087	Casterno	Lombardia	Milano	MI	7536
IT	20088	Gudo Visconti	Lombardia	Milano	MI	7537
IT	20088	Rosate	Lombardia	Milano	MI	7538
IT	20089	Rozzano	Lombardia	Milano	MI	7539
IT	20089	Quinto De Stampi	Lombardia	Milano	MI	7540
IT	20090	Sporting Mirasole	Lombardia	Milano	MI	7541
IT	20090	Millepini	Lombardia	Milano	MI	7542
IT	20090	Segrate	Lombardia	Milano	MI	7543
IT	20090	Buccinasco	Lombardia	Milano	MI	7544
IT	20090	Lucino	Lombardia	Milano	MI	7545
IT	20090	Novegro	Lombardia	Milano	MI	7546
IT	20090	Noverasco	Lombardia	Milano	MI	7547
IT	20090	Zingone	Lombardia	Milano	MI	7548
IT	20090	San Felice	Lombardia	Milano	MI	7549
IT	20090	Opera	Lombardia	Milano	MI	7550
IT	20090	Fizzonasco	Lombardia	Milano	MI	7551
IT	20090	Tregarezzo	Lombardia	Milano	MI	7552
IT	20090	Rodano	Lombardia	Milano	MI	7553
IT	20090	Romano Banco	Lombardia	Milano	MI	7554
IT	20090	Vimodrone	Lombardia	Milano	MI	7555
IT	20090	Trezzano Sul Naviglio	Lombardia	Milano	MI	7556
IT	20090	Pantigliate	Lombardia	Milano	MI	7557
IT	20090	Linate Aeroporto	Lombardia	Milano	MI	7558
IT	20090	Monzoro	Lombardia	Milano	MI	7559
IT	20090	Settala	Lombardia	Milano	MI	7560
IT	20090	Cusago	Lombardia	Milano	MI	7561
IT	20090	Zingone Di Trezzano Sul Naviglio	Lombardia	Milano	MI	7562
IT	20090	Pieve Emanuele	Lombardia	Milano	MI	7563
IT	20090	Assago	Lombardia	Milano	MI	7564
IT	20090	Caleppio	Lombardia	Milano	MI	7565
IT	20090	Cesano Boscone	Lombardia	Milano	MI	7566
IT	20090	Premenugo	Lombardia	Milano	MI	7567
IT	20091	Bresso	Lombardia	Milano	MI	7568
IT	20092	Cinisello Balsamo	Lombardia	Milano	MI	7569
IT	20093	Cologno Monzese	Lombardia	Milano	MI	7570
IT	20093	San Maurizio Al Lambro	Lombardia	Milano	MI	7571
IT	20094	Corsico	Lombardia	Milano	MI	7572
IT	20095	Cusano Milanino	Lombardia	Milano	MI	7573
IT	20095	Milanino	Lombardia	Milano	MI	7574
IT	20096	Seggiano	Lombardia	Milano	MI	7575
IT	20096	Pioltello	Lombardia	Milano	MI	7576
IT	20096	Limito	Lombardia	Milano	MI	7577
IT	20097	Poasco	Lombardia	Milano	MI	7578
IT	20097	San Donato Milanese	Lombardia	Milano	MI	7579
IT	20097	Metanopoli	Lombardia	Milano	MI	7580
IT	20097	Sorigherio	Lombardia	Milano	MI	7581
IT	20098	Sesto Ulteriano	Lombardia	Milano	MI	7582
IT	20098	San Giuliano Milanese	Lombardia	Milano	MI	7583
IT	20098	Borgo Lombardo	Lombardia	Milano	MI	7584
IT	20099	Sesto San Giovanni	Lombardia	Milano	MI	7585
IT	20121	Milano	Lombardia	Milano	MI	7586
IT	20122	Milano	Lombardia	Milano	MI	7587
IT	20123	Milano	Lombardia	Milano	MI	7588
IT	20124	Milano	Lombardia	Milano	MI	7589
IT	20125	Gorla	Lombardia	Milano	MI	7590
IT	20125	Greco	Lombardia	Milano	MI	7591
IT	20125	Milano	Lombardia	Milano	MI	7592
IT	20125	Precotto	Lombardia	Milano	MI	7593
IT	20126	Milano	Lombardia	Milano	MI	7594
IT	20127	Crescenzago	Lombardia	Milano	MI	7595
IT	20127	Milano	Lombardia	Milano	MI	7596
IT	20128	Milano	Lombardia	Milano	MI	7597
IT	20129	Milano	Lombardia	Milano	MI	7598
IT	20131	Milano	Lombardia	Milano	MI	7599
IT	20132	Milano	Lombardia	Milano	MI	7600
IT	20133	Milano	Lombardia	Milano	MI	7601
IT	20134	Lambrate	Lombardia	Milano	MI	7602
IT	20134	Milano	Lombardia	Milano	MI	7603
IT	20135	Milano	Lombardia	Milano	MI	7604
IT	20136	Milano	Lombardia	Milano	MI	7605
IT	20137	Milano	Lombardia	Milano	MI	7606
IT	20138	Rogoredo	Lombardia	Milano	MI	7607
IT	20138	Milano	Lombardia	Milano	MI	7608
IT	20139	Chiaravalle Milanese	Lombardia	Milano	MI	7609
IT	20139	Milano	Lombardia	Milano	MI	7610
IT	20141	Milano	Lombardia	Milano	MI	7611
IT	20142	Gratosoglio	Lombardia	Milano	MI	7612
IT	20142	Milano	Lombardia	Milano	MI	7613
IT	20143	Barona	Lombardia	Milano	MI	7614
IT	20143	Milano	Lombardia	Milano	MI	7615
IT	20144	Milano	Lombardia	Milano	MI	7616
IT	20145	Milano	Lombardia	Milano	MI	7617
IT	20146	Milano	Lombardia	Milano	MI	7618
IT	20147	Milano	Lombardia	Milano	MI	7619
IT	20148	Milano	Lombardia	Milano	MI	7620
IT	20149	Milano	Lombardia	Milano	MI	7621
IT	20151	Musocco	Lombardia	Milano	MI	7622
IT	20151	Milano	Lombardia	Milano	MI	7623
IT	20152	Baggio	Lombardia	Milano	MI	7624
IT	20152	Milano	Lombardia	Milano	MI	7625
IT	20153	Figino	Lombardia	Milano	MI	7626
IT	20153	Milano	Lombardia	Milano	MI	7627
IT	20153	Trenno	Lombardia	Milano	MI	7628
IT	20154	Milano	Lombardia	Milano	MI	7629
IT	20155	Milano	Lombardia	Milano	MI	7630
IT	20156	Milano	Lombardia	Milano	MI	7631
IT	20157	Quarto Oggiaro	Lombardia	Milano	MI	7632
IT	20157	Milano	Lombardia	Milano	MI	7633
IT	20157	Vialba	Lombardia	Milano	MI	7634
IT	20158	Milano	Lombardia	Milano	MI	7635
IT	20159	Milano	Lombardia	Milano	MI	7636
IT	20161	Bruzzano	Lombardia	Milano	MI	7637
IT	20161	Affori	Lombardia	Milano	MI	7638
IT	20161	Milano	Lombardia	Milano	MI	7639
IT	20162	Niguarda	Lombardia	Milano	MI	7640
IT	20162	Milano	Lombardia	Milano	MI	7641
IT	46010	Levata	Lombardia	Mantova	MN	7642
IT	46010	Marcaria	Lombardia	Mantova	MN	7643
IT	46010	Ospitaletto	Lombardia	Mantova	MN	7644
IT	46010	Grazie	Lombardia	Mantova	MN	7645
IT	46010	Montanara	Lombardia	Mantova	MN	7646
IT	46010	Commessaggio	Lombardia	Mantova	MN	7647
IT	46010	Mariana Mantovana	Lombardia	Mantova	MN	7648
IT	46010	San Martino Dall'Argine	Lombardia	Mantova	MN	7649
IT	46010	Belforte	Lombardia	Mantova	MN	7650
IT	46010	Curtatone	Lombardia	Mantova	MN	7651
IT	46010	Campitello	Lombardia	Mantova	MN	7652
IT	46010	Cesole	Lombardia	Mantova	MN	7653
IT	46010	Canicossa	Lombardia	Mantova	MN	7654
IT	46010	Buscoldo	Lombardia	Mantova	MN	7655
IT	46010	San Michele In Bosco	Lombardia	Mantova	MN	7656
IT	46010	Gazzuolo	Lombardia	Mantova	MN	7657
IT	46010	Villaggio Eremo	Lombardia	Mantova	MN	7658
IT	46010	Casatico	Lombardia	Mantova	MN	7659
IT	46010	Gabbiana	Lombardia	Mantova	MN	7660
IT	46010	Redondesco	Lombardia	Mantova	MN	7661
IT	46010	San Silvestro	Lombardia	Mantova	MN	7662
IT	46011	Mosio	Lombardia	Mantova	MN	7663
IT	46011	Acquanegra Sul Chiese	Lombardia	Mantova	MN	7664
IT	46012	Bozzolo	Lombardia	Mantova	MN	7665
IT	46013	Canneto Sull'Oglio	Lombardia	Mantova	MN	7666
IT	46014	Ospitaletto Mantovano	Lombardia	Mantova	MN	7667
IT	46014	Castellucchio	Lombardia	Mantova	MN	7668
IT	46014	Sarginesco	Lombardia	Mantova	MN	7669
IT	46017	Rivarolo Mantovano	Lombardia	Mantova	MN	7670
IT	46017	Cividale Mantovano	Lombardia	Mantova	MN	7671
IT	46018	Villa Pasquali	Lombardia	Mantova	MN	7672
IT	46018	Breda Cisoni	Lombardia	Mantova	MN	7673
IT	46018	Ponteterra	Lombardia	Mantova	MN	7674
IT	46018	Sabbioneta	Lombardia	Mantova	MN	7675
IT	46019	Buzzoletto	Lombardia	Mantova	MN	7676
IT	46019	Viadana	Lombardia	Mantova	MN	7677
IT	46019	Cogozzo	Lombardia	Mantova	MN	7678
IT	46019	San Matteo Delle Chiaviche	Lombardia	Mantova	MN	7679
IT	46019	Bellaguarda	Lombardia	Mantova	MN	7680
IT	46019	Cizzolo	Lombardia	Mantova	MN	7681
IT	46019	Cicognara	Lombardia	Mantova	MN	7682
IT	46020	Borgofranco Sul Po	Lombardia	Mantova	MN	7683
IT	46020	Magnacavallo	Lombardia	Mantova	MN	7684
IT	46020	Schivenoglia	Lombardia	Mantova	MN	7685
IT	46020	Pieve Di Coriano	Lombardia	Mantova	MN	7686
IT	46020	San Giacomo Delle Segnate	Lombardia	Mantova	MN	7687
IT	46020	Quingentole	Lombardia	Mantova	MN	7688
IT	46020	San Giovanni Del Dosso	Lombardia	Mantova	MN	7689
IT	46020	Motteggiana	Lombardia	Mantova	MN	7690
IT	46020	Pegognaga	Lombardia	Mantova	MN	7691
IT	46020	Villa Saviola	Lombardia	Mantova	MN	7692
IT	46020	Carbonara Di Po	Lombardia	Mantova	MN	7693
IT	46020	Villa Poma	Lombardia	Mantova	MN	7694
IT	46020	Polesine	Lombardia	Mantova	MN	7695
IT	46022	Felonica	Lombardia	Mantova	MN	7696
IT	46023	Palidano	Lombardia	Mantova	MN	7697
IT	46023	Bondeno Di Gonzaga	Lombardia	Mantova	MN	7698
IT	46023	Gonzaga	Lombardia	Mantova	MN	7699
IT	46024	Bondanello	Lombardia	Mantova	MN	7700
IT	46024	Moglia	Lombardia	Mantova	MN	7701
IT	46025	Poggio Rusco	Lombardia	Mantova	MN	7702
IT	46026	Quistello	Lombardia	Mantova	MN	7703
IT	46026	Nuvolato	Lombardia	Mantova	MN	7704
IT	46027	San Benedetto Po	Lombardia	Mantova	MN	7705
IT	46027	Portiolo	Lombardia	Mantova	MN	7706
IT	46027	Mirasole	Lombardia	Mantova	MN	7707
IT	46027	San Siro	Lombardia	Mantova	MN	7708
IT	46028	Moglia Di Sermide	Lombardia	Mantova	MN	7709
IT	46028	Malcantone	Lombardia	Mantova	MN	7710
IT	46028	Santa Croce	Lombardia	Mantova	MN	7711
IT	46028	Caposotto	Lombardia	Mantova	MN	7712
IT	46028	Sermide	Lombardia	Mantova	MN	7713
IT	46029	Tabellano	Lombardia	Mantova	MN	7714
IT	46029	Suzzara	Lombardia	Mantova	MN	7715
IT	46029	Sailetto	Lombardia	Mantova	MN	7716
IT	46029	Riva	Lombardia	Mantova	MN	7717
IT	46029	San Prospero	Lombardia	Mantova	MN	7718
IT	46029	Brusatasso	Lombardia	Mantova	MN	7719
IT	46030	Serravalle A Po	Lombardia	Mantova	MN	7720
IT	46030	Correggioverde	Lombardia	Mantova	MN	7721
IT	46030	Mottella	Lombardia	Mantova	MN	7722
IT	46030	Gazzo	Lombardia	Mantova	MN	7723
IT	46030	Pomponesco	Lombardia	Mantova	MN	7724
IT	46030	Villastrada	Lombardia	Mantova	MN	7725
IT	46030	Sacchetta	Lombardia	Mantova	MN	7726
IT	46030	Dosolo	Lombardia	Mantova	MN	7727
IT	46030	Tripoli	Lombardia	Mantova	MN	7728
IT	46030	Bigarello	Lombardia	Mantova	MN	7729
IT	46030	Ca' Vecchia	Lombardia	Mantova	MN	7730
IT	46030	Sustinente	Lombardia	Mantova	MN	7731
IT	46030	Libiola	Lombardia	Mantova	MN	7732
IT	46030	Villanova De Bellis	Lombardia	Mantova	MN	7733
IT	46030	Stradella	Lombardia	Mantova	MN	7734
IT	46030	San Giorgio Di Mantova	Lombardia	Mantova	MN	7735
IT	46031	Bagnolo San Vito	Lombardia	Mantova	MN	7736
IT	46031	San Biagio	Lombardia	Mantova	MN	7737
IT	46031	San Nicolo' Po	Lombardia	Mantova	MN	7738
IT	46032	Castelbelforte	Lombardia	Mantova	MN	7739
IT	46033	Castel D'Ario	Lombardia	Mantova	MN	7740
IT	46034	Pietole	Lombardia	Mantova	MN	7741
IT	46034	Borgoforte	Lombardia	Mantova	MN	7742
IT	46034	Romanore	Lombardia	Mantova	MN	7743
IT	46034	San Cataldo	Lombardia	Mantova	MN	7744
IT	46034	Cappelletta	Lombardia	Mantova	MN	7745
IT	46034	Borgo Virgilio	Lombardia	Mantova	MN	7746
IT	46034	Boccadiganda	Lombardia	Mantova	MN	7747
IT	46034	Virgilio	Lombardia	Mantova	MN	7748
IT	46034	Cerese	Lombardia	Mantova	MN	7749
IT	46035	Correggioli	Lombardia	Mantova	MN	7750
IT	46035	Ostiglia	Lombardia	Mantova	MN	7751
IT	46036	Revere	Lombardia	Mantova	MN	7752
IT	46037	Villa Garibaldi	Lombardia	Mantova	MN	7753
IT	46037	Governolo	Lombardia	Mantova	MN	7754
IT	46037	Casale	Lombardia	Mantova	MN	7755
IT	46037	Roncoferraro	Lombardia	Mantova	MN	7756
IT	46037	Barbasso	Lombardia	Mantova	MN	7757
IT	46037	Pontemerlano	Lombardia	Mantova	MN	7758
IT	46037	Borgo Castelletto	Lombardia	Mantova	MN	7759
IT	46039	Villimpenta	Lombardia	Mantova	MN	7760
IT	46040	Rivalta Sul Mincio	Lombardia	Mantova	MN	7761
IT	46040	Monzambano	Lombardia	Mantova	MN	7762
IT	46040	Gazoldo Degli Ippoliti	Lombardia	Mantova	MN	7763
IT	46040	Rodigo	Lombardia	Mantova	MN	7764
IT	46040	Casalmoro	Lombardia	Mantova	MN	7765
IT	46040	Cavriana	Lombardia	Mantova	MN	7766
IT	46040	Ponti Sul Mincio	Lombardia	Mantova	MN	7767
IT	46040	Casaloldo	Lombardia	Mantova	MN	7768
IT	46040	Piubega	Lombardia	Mantova	MN	7769
IT	46040	Rivalta	Lombardia	Mantova	MN	7770
IT	46040	Fontanella Grazioli	Lombardia	Mantova	MN	7771
IT	46040	Casalromano	Lombardia	Mantova	MN	7772
IT	46040	Guidizzolo	Lombardia	Mantova	MN	7773
IT	46040	Solferino	Lombardia	Mantova	MN	7774
IT	46040	Ceresara	Lombardia	Mantova	MN	7775
IT	46040	San Fermo	Lombardia	Mantova	MN	7776
IT	46041	Castelnuovo	Lombardia	Mantova	MN	7777
IT	46041	Asola	Lombardia	Mantova	MN	7778
IT	46041	Barchi Di Asola	Lombardia	Mantova	MN	7779
IT	46041	Castelnuovo Asolano	Lombardia	Mantova	MN	7780
IT	46042	Castel Goffredo	Lombardia	Mantova	MN	7781
IT	46043	Gozzolina	Lombardia	Mantova	MN	7782
IT	46043	Castiglione Delle Stiviere	Lombardia	Mantova	MN	7783
IT	46044	Goito	Lombardia	Mantova	MN	7784
IT	46044	Solarolo	Lombardia	Mantova	MN	7785
IT	46044	Cerlongo	Lombardia	Mantova	MN	7786
IT	46045	Pozzolo	Lombardia	Mantova	MN	7787
IT	46045	Marengo	Lombardia	Mantova	MN	7788
IT	46045	Marmirolo	Lombardia	Mantova	MN	7789
IT	46046	Medole	Lombardia	Mantova	MN	7790
IT	46047	Soave Mantovano	Lombardia	Mantova	MN	7791
IT	46047	Porto Mantovano	Lombardia	Mantova	MN	7792
IT	46047	Sant'Antonio	Lombardia	Mantova	MN	7793
IT	46047	Soave	Lombardia	Mantova	MN	7794
IT	46048	Malavicina	Lombardia	Mantova	MN	7795
IT	46048	Castiglione Mantovano	Lombardia	Mantova	MN	7796
IT	46048	Canedole	Lombardia	Mantova	MN	7797
IT	46048	Roverbella	Lombardia	Mantova	MN	7798
IT	46048	Pellaloco	Lombardia	Mantova	MN	7799
IT	46049	Volta Mantovana	Lombardia	Mantova	MN	7800
IT	46049	Cereta	Lombardia	Mantova	MN	7801
IT	46100	Mantova	Lombardia	Mantova	MN	7802
IT	46100	Lunetta	Lombardia	Mantova	MN	7803
IT	46100	Borgovirgiliana	Lombardia	Mantova	MN	7804
IT	46100	Formigosa	Lombardia	Mantova	MN	7805
IT	46100	Frassino Mantovano	Lombardia	Mantova	MN	7806
IT	27010	Camporinaldo	Lombardia	Pavia	PV	7807
IT	27010	Magherno	Lombardia	Pavia	PV	7808
IT	27010	Monticelli Pavese	Lombardia	Pavia	PV	7809
IT	27010	Linarolo	Lombardia	Pavia	PV	7810
IT	27010	Vistarino	Lombardia	Pavia	PV	7811
IT	27010	San Zenone Al Po	Lombardia	Pavia	PV	7812
IT	27010	Miradolo Terme	Lombardia	Pavia	PV	7813
IT	27010	Vigonzone	Lombardia	Pavia	PV	7814
IT	27010	Inverno	Lombardia	Pavia	PV	7815
IT	27010	Filighera	Lombardia	Pavia	PV	7816
IT	27010	Inverno E Monteleone	Lombardia	Pavia	PV	7817
IT	27010	Marzano	Lombardia	Pavia	PV	7818
IT	27010	Bascape'	Lombardia	Pavia	PV	7819
IT	27010	San Leonardo	Lombardia	Pavia	PV	7820
IT	27010	Siziano	Lombardia	Pavia	PV	7821
IT	27010	Guinzano	Lombardia	Pavia	PV	7822
IT	27010	Valle Salimbene	Lombardia	Pavia	PV	7823
IT	27010	Torrevecchia Pia	Lombardia	Pavia	PV	7824
IT	27010	Copiano	Lombardia	Pavia	PV	7825
IT	27010	Giussago	Lombardia	Pavia	PV	7826
IT	27010	San Genesio Ed Uniti	Lombardia	Pavia	PV	7827
IT	27010	Monteleone	Lombardia	Pavia	PV	7828
IT	27010	Spessa	Lombardia	Pavia	PV	7829
IT	27010	San Leonardo Di Linarolo	Lombardia	Pavia	PV	7830
IT	27010	Badia Pavese	Lombardia	Pavia	PV	7831
IT	27010	Cura Carpignano	Lombardia	Pavia	PV	7832
IT	27010	Bornasco	Lombardia	Pavia	PV	7833
IT	27010	Motta San Damiano	Lombardia	Pavia	PV	7834
IT	27010	Borgarello	Lombardia	Pavia	PV	7835
IT	27010	Ceranova	Lombardia	Pavia	PV	7836
IT	27010	Zeccone	Lombardia	Pavia	PV	7837
IT	27010	Albuzzano	Lombardia	Pavia	PV	7838
IT	27010	Santa Cristina E Bissone	Lombardia	Pavia	PV	7839
IT	27010	Giovenzano	Lombardia	Pavia	PV	7840
IT	27010	Gerenzago	Lombardia	Pavia	PV	7841
IT	27010	Roncaro	Lombardia	Pavia	PV	7842
IT	27010	Rognano	Lombardia	Pavia	PV	7843
IT	27010	Costa De' Nobili	Lombardia	Pavia	PV	7844
IT	27010	Turago Bordone	Lombardia	Pavia	PV	7845
IT	27010	Torre D'Arese	Lombardia	Pavia	PV	7846
IT	27010	Vellezzo Bellini	Lombardia	Pavia	PV	7847
IT	27011	Belgioioso	Lombardia	Pavia	PV	7848
IT	27011	Torre De' Negri	Lombardia	Pavia	PV	7849
IT	27012	Certosa Di Pavia	Lombardia	Pavia	PV	7850
IT	27012	Torriano	Lombardia	Pavia	PV	7851
IT	27012	Torre Del Mangano	Lombardia	Pavia	PV	7852
IT	27013	Chignolo Po	Lombardia	Pavia	PV	7853
IT	27013	Lambrinia	Lombardia	Pavia	PV	7854
IT	27014	Genzone	Lombardia	Pavia	PV	7855
IT	27014	Corteolona	Lombardia	Pavia	PV	7856
IT	27015	Landriano	Lombardia	Pavia	PV	7857
IT	27016	Sant'Alessio Con Vialone	Lombardia	Pavia	PV	7858
IT	27016	Lardirago	Lombardia	Pavia	PV	7859
IT	27017	Pieve Porto Morone	Lombardia	Pavia	PV	7860
IT	27017	Zerbo	Lombardia	Pavia	PV	7861
IT	27018	Vidigulfo	Lombardia	Pavia	PV	7862
IT	27019	Villanterio	Lombardia	Pavia	PV	7863
IT	27020	Carbonara Al Ticino	Lombardia	Pavia	PV	7864
IT	27020	Borgo San Siro	Lombardia	Pavia	PV	7865
IT	27020	Albonese	Lombardia	Pavia	PV	7866
IT	27020	Massaua	Lombardia	Pavia	PV	7867
IT	27020	Parona	Lombardia	Pavia	PV	7868
IT	27020	Olevano Di Lomellina	Lombardia	Pavia	PV	7869
IT	27020	Tromello	Lombardia	Pavia	PV	7870
IT	27020	Cergnago	Lombardia	Pavia	PV	7871
IT	27020	Nicorvo	Lombardia	Pavia	PV	7872
IT	27020	Semiana	Lombardia	Pavia	PV	7873
IT	27020	Torre D'Isola	Lombardia	Pavia	PV	7874
IT	27020	Velezzo Lomellina	Lombardia	Pavia	PV	7875
IT	27020	Alagna	Lombardia	Pavia	PV	7876
IT	27020	San Giorgio Di Lomellina	Lombardia	Pavia	PV	7877
IT	27020	Valeggio	Lombardia	Pavia	PV	7878
IT	27020	Trivolzio	Lombardia	Pavia	PV	7879
IT	27020	Marcignago	Lombardia	Pavia	PV	7880
IT	27020	Scaldasole	Lombardia	Pavia	PV	7881
IT	27020	Dorno	Lombardia	Pavia	PV	7882
IT	27020	Valle Lomellina	Lombardia	Pavia	PV	7883
IT	27020	Travaco' Siccomario	Lombardia	Pavia	PV	7884
IT	27020	Sartirana Lomellina	Lombardia	Pavia	PV	7885
IT	27020	Trovo	Lombardia	Pavia	PV	7886
IT	27020	Battuda	Lombardia	Pavia	PV	7887
IT	27020	Gravellona Lomellina	Lombardia	Pavia	PV	7888
IT	27020	Casottole	Lombardia	Pavia	PV	7889
IT	27020	Rotta	Lombardia	Pavia	PV	7890
IT	27020	Zerbolo'	Lombardia	Pavia	PV	7891
IT	27020	Breme	Lombardia	Pavia	PV	7892
IT	27021	Bereguardo	Lombardia	Pavia	PV	7893
IT	27022	Casorate Primo	Lombardia	Pavia	PV	7894
IT	27023	Cassolnovo	Lombardia	Pavia	PV	7895
IT	27024	Cilavegna	Lombardia	Pavia	PV	7896
IT	27025	Gambolo'	Lombardia	Pavia	PV	7897
IT	27026	Garlasco	Lombardia	Pavia	PV	7898
IT	27026	San Biagio	Lombardia	Pavia	PV	7899
IT	27026	Madonna Delle Bozzole	Lombardia	Pavia	PV	7900
IT	27027	Gropello Cairoli	Lombardia	Pavia	PV	7901
IT	27028	Bivio Cava Manara	Lombardia	Pavia	PV	7902
IT	27028	San Martino Siccomario	Lombardia	Pavia	PV	7903
IT	27029	Sforzesca	Lombardia	Pavia	PV	7904
IT	27029	Vigevano	Lombardia	Pavia	PV	7905
IT	27030	Zinasco Vecchio	Lombardia	Pavia	PV	7906
IT	27030	Suardi	Lombardia	Pavia	PV	7907
IT	27030	Zinasco	Lombardia	Pavia	PV	7908
IT	27030	Ottobiano	Lombardia	Pavia	PV	7909
IT	27030	Mezzana Rabattone	Lombardia	Pavia	PV	7910
IT	27030	Confienza	Lombardia	Pavia	PV	7911
IT	27030	Palestro	Lombardia	Pavia	PV	7912
IT	27030	Frascarolo	Lombardia	Pavia	PV	7913
IT	27030	Sairano	Lombardia	Pavia	PV	7914
IT	27030	Villanova D'Ardenghi	Lombardia	Pavia	PV	7915
IT	27030	Langosco	Lombardia	Pavia	PV	7916
IT	27030	Castelnovetto	Lombardia	Pavia	PV	7917
IT	27030	Castellaro De' Giorgi	Lombardia	Pavia	PV	7918
IT	27030	Sant'Angelo Lomellina	Lombardia	Pavia	PV	7919
IT	27030	Zeme	Lombardia	Pavia	PV	7920
IT	27030	Rosasco	Lombardia	Pavia	PV	7921
IT	27030	Pieve Albignola	Lombardia	Pavia	PV	7922
IT	27030	Castello D'Agogna	Lombardia	Pavia	PV	7923
IT	27030	Balossa Bigli	Lombardia	Pavia	PV	7924
IT	27030	Mezzana Bigli	Lombardia	Pavia	PV	7925
IT	27030	Cozzo	Lombardia	Pavia	PV	7926
IT	27030	Zinasco Nuovo	Lombardia	Pavia	PV	7927
IT	27030	Ceretto Lomellina	Lombardia	Pavia	PV	7928
IT	27030	Gambarana	Lombardia	Pavia	PV	7929
IT	27030	Torre Beretti E Castellaro	Lombardia	Pavia	PV	7930
IT	27031	Candia Lomellina	Lombardia	Pavia	PV	7931
IT	27032	Ferrera Erbognone	Lombardia	Pavia	PV	7932
IT	27033	Garbana	Lombardia	Pavia	PV	7933
IT	27034	Galliavola	Lombardia	Pavia	PV	7934
IT	27034	Lomello	Lombardia	Pavia	PV	7935
IT	27035	Mede	Lombardia	Pavia	PV	7936
IT	27035	Villa Biscossi	Lombardia	Pavia	PV	7937
IT	27036	Mortara	Lombardia	Pavia	PV	7938
IT	27037	Pieve Del Cairo	Lombardia	Pavia	PV	7939
IT	27038	Robbio	Lombardia	Pavia	PV	7940
IT	27039	Sannazzaro De' Burgondi	Lombardia	Pavia	PV	7941
IT	27040	Castelletto Po	Lombardia	Pavia	PV	7942
IT	27040	Mezzanino	Lombardia	Pavia	PV	7943
IT	27040	Canevino	Lombardia	Pavia	PV	7944
IT	27040	Bosnasco	Lombardia	Pavia	PV	7945
IT	27040	Borgo Priolo	Lombardia	Pavia	PV	7946
IT	27040	Castana	Lombardia	Pavia	PV	7947
IT	27040	Cigognola	Lombardia	Pavia	PV	7948
IT	27040	Borgoratto Mormorolo	Lombardia	Pavia	PV	7949
IT	27040	Montescano	Lombardia	Pavia	PV	7950
IT	27040	Rea	Lombardia	Pavia	PV	7951
IT	27040	Rovescala	Lombardia	Pavia	PV	7952
IT	27040	Mornico Losana	Lombardia	Pavia	PV	7953
IT	27040	Portalbera	Lombardia	Pavia	PV	7954
IT	27040	Pietra De' Giorgi	Lombardia	Pavia	PV	7955
IT	27040	Casatisma	Lombardia	Pavia	PV	7956
IT	27040	Albaredo Arnaboldi	Lombardia	Pavia	PV	7957
IT	27040	Verrua Po	Lombardia	Pavia	PV	7958
IT	27040	Arena Po	Lombardia	Pavia	PV	7959
IT	27040	Lirio	Lombardia	Pavia	PV	7960
IT	27040	Casenove	Lombardia	Pavia	PV	7961
IT	27040	Mornico	Lombardia	Pavia	PV	7962
IT	27040	Calvignano	Lombardia	Pavia	PV	7963
IT	27040	Pinarolo Po	Lombardia	Pavia	PV	7964
IT	27040	Montalto Pavese	Lombardia	Pavia	PV	7965
IT	27040	Torre Degli Alberi	Lombardia	Pavia	PV	7966
IT	27040	Campospinoso	Lombardia	Pavia	PV	7967
IT	27040	Fortunago	Lombardia	Pavia	PV	7968
IT	27040	San Damiano Al Colle	Lombardia	Pavia	PV	7969
IT	27040	Rocca De' Giorgi	Lombardia	Pavia	PV	7970
IT	27040	Pometo	Lombardia	Pavia	PV	7971
IT	27040	Montu' Beccaria	Lombardia	Pavia	PV	7972
IT	27040	Castelletto Di Branduzzo	Lombardia	Pavia	PV	7973
IT	27040	Ruino	Lombardia	Pavia	PV	7974
IT	27040	Vallescuropasso	Lombardia	Pavia	PV	7975
IT	27040	Tornello	Lombardia	Pavia	PV	7976
IT	27040	Busca	Lombardia	Pavia	PV	7977
IT	27041	Casanova Lonati	Lombardia	Pavia	PV	7978
IT	27041	Barbianello	Lombardia	Pavia	PV	7979
IT	27042	Robecco Pavese	Lombardia	Pavia	PV	7980
IT	27042	Bressana	Lombardia	Pavia	PV	7981
IT	27042	Bottarone	Lombardia	Pavia	PV	7982
IT	27042	Bressana Bottarone	Lombardia	Pavia	PV	7983
IT	27043	Broni	Lombardia	Pavia	PV	7984
IT	27043	San Cipriano Po	Lombardia	Pavia	PV	7985
IT	27044	Canneto	Lombardia	Pavia	PV	7986
IT	27044	Canneto Pavese	Lombardia	Pavia	PV	7987
IT	27045	Casteggio	Lombardia	Pavia	PV	7988
IT	27046	Santa Giuletta	Lombardia	Pavia	PV	7989
IT	27047	Santa Maria Della Versa	Lombardia	Pavia	PV	7990
IT	27047	Golferenzo	Lombardia	Pavia	PV	7991
IT	27047	Montecalvo Versiggia	Lombardia	Pavia	PV	7992
IT	27047	Volpara	Lombardia	Pavia	PV	7993
IT	27048	Sommo	Lombardia	Pavia	PV	7994
IT	27049	Stradella	Lombardia	Pavia	PV	7995
IT	27049	Zenevredo	Lombardia	Pavia	PV	7996
IT	27050	Ghiaie	Lombardia	Pavia	PV	7997
IT	27050	Bagnaria	Lombardia	Pavia	PV	7998
IT	27050	Romagnese	Lombardia	Pavia	PV	7999
IT	27050	Torrazza Coste	Lombardia	Pavia	PV	8000
IT	27050	Casanova Di Destra	Lombardia	Pavia	PV	8001
IT	27050	Retorbido	Lombardia	Pavia	PV	8002
IT	27050	Ponte Nizza	Lombardia	Pavia	PV	8003
IT	27050	Pizzale	Lombardia	Pavia	PV	8004
IT	27050	Fumo	Lombardia	Pavia	PV	8005
IT	27050	Redavalle	Lombardia	Pavia	PV	8006
IT	27050	Bastida Pancarana	Lombardia	Pavia	PV	8007
IT	27050	Oliva Gessi	Lombardia	Pavia	PV	8008
IT	27050	Santa Margherita Di Staffora	Lombardia	Pavia	PV	8009
IT	27050	Menconico	Lombardia	Pavia	PV	8010
IT	27050	Silvano Pietra	Lombardia	Pavia	PV	8011
IT	27050	Corana	Lombardia	Pavia	PV	8012
IT	27050	Cecima	Lombardia	Pavia	PV	8013
IT	27050	Brallo Di Pregola	Lombardia	Pavia	PV	8014
IT	27050	Torricella Verzate	Lombardia	Pavia	PV	8015
IT	27050	Cervesina	Lombardia	Pavia	PV	8016
IT	27050	Collegio	Lombardia	Pavia	PV	8017
IT	27050	Pancarana	Lombardia	Pavia	PV	8018
IT	27050	Corvino San Quirico	Lombardia	Pavia	PV	8019
IT	27050	Codevilla	Lombardia	Pavia	PV	8020
IT	27050	Val Di Nizza	Lombardia	Pavia	PV	8021
IT	27050	Casei Gerola	Lombardia	Pavia	PV	8022
IT	27050	Casei	Lombardia	Pavia	PV	8023
IT	27051	Mezzana Corti	Lombardia	Pavia	PV	8024
IT	27051	Cava Manara	Lombardia	Pavia	PV	8025
IT	27051	Tre Re	Lombardia	Pavia	PV	8026
IT	27052	Montesegale	Lombardia	Pavia	PV	8027
IT	27052	Godiasco	Lombardia	Pavia	PV	8028
IT	27052	Salice Terme	Lombardia	Pavia	PV	8029
IT	27052	Rocca Susella	Lombardia	Pavia	PV	8030
IT	27053	Lungavilla	Lombardia	Pavia	PV	8031
IT	27053	Verretto	Lombardia	Pavia	PV	8032
IT	27054	Montebello Della Battaglia	Lombardia	Pavia	PV	8033
IT	27055	Rivanazzano	Lombardia	Pavia	PV	8034
IT	27056	Cornale	Lombardia	Pavia	PV	8035
IT	27056	Bastida De' Dossi	Lombardia	Pavia	PV	8036
IT	27056	Cornale E Bastida	Lombardia	Pavia	PV	8037
IT	27057	Varzi	Lombardia	Pavia	PV	8038
IT	27057	Pietragavina	Lombardia	Pavia	PV	8039
IT	27058	Oriolo	Lombardia	Pavia	PV	8040
IT	27058	Voghera	Lombardia	Pavia	PV	8041
IT	27059	Zavattarello	Lombardia	Pavia	PV	8042
IT	27100	Pavia	Lombardia	Pavia	PV	8043
IT	27100	Mirabello Di Pavia	Lombardia	Pavia	PV	8044
IT	27100	Ca' Della Terra	Lombardia	Pavia	PV	8045
IT	27100	Fossarmato	Lombardia	Pavia	PV	8046
IT	23010	Cino	Lombardia	Sondrio	SO	8047
IT	23010	Caiolo	Lombardia	Sondrio	SO	8048
IT	23010	Val Masino	Lombardia	Sondrio	SO	8049
IT	23010	Colorina	Lombardia	Sondrio	SO	8050
IT	23010	Mello	Lombardia	Sondrio	SO	8051
IT	23010	Gerola Alta	Lombardia	Sondrio	SO	8052
IT	23010	Bema	Lombardia	Sondrio	SO	8053
IT	23010	Sirta	Lombardia	Sondrio	SO	8054
IT	23010	Forcola	Lombardia	Sondrio	SO	8055
IT	23010	Berbenno Di Valtellina	Lombardia	Sondrio	SO	8056
IT	23010	Cedrasco	Lombardia	Sondrio	SO	8057
IT	23010	Torchione	Lombardia	Sondrio	SO	8058
IT	23010	Rogolo	Lombardia	Sondrio	SO	8059
IT	23010	Postalesio	Lombardia	Sondrio	SO	8060
IT	23010	Dazio	Lombardia	Sondrio	SO	8061
IT	23010	Buglio In Monte	Lombardia	Sondrio	SO	8062
IT	23010	Albosaggia	Lombardia	Sondrio	SO	8063
IT	23010	Cevo	Lombardia	Sondrio	SO	8064
IT	23010	Campo Tartano	Lombardia	Sondrio	SO	8065
IT	23010	Fusine	Lombardia	Sondrio	SO	8066
IT	23010	Rasura	Lombardia	Sondrio	SO	8067
IT	23010	Moia	Lombardia	Sondrio	SO	8068
IT	23010	Villapinta	Lombardia	Sondrio	SO	8069
IT	23010	Tartano	Lombardia	Sondrio	SO	8070
IT	23010	San Martino	Lombardia	Sondrio	SO	8071
IT	23010	Pedesina	Lombardia	Sondrio	SO	8072
IT	23010	Piantedo	Lombardia	Sondrio	SO	8073
IT	23010	Civo	Lombardia	Sondrio	SO	8074
IT	23010	San Martino Val Masino	Lombardia	Sondrio	SO	8075
IT	23010	Cataeggio	Lombardia	Sondrio	SO	8076
IT	23010	San Pietro Di Berbenno	Lombardia	Sondrio	SO	8077
IT	23010	Sant'Antonio Morignone	Lombardia	Sondrio	SO	8078
IT	23010	Pedemonte	Lombardia	Sondrio	SO	8079
IT	23010	Albaredo Per San Marco	Lombardia	Sondrio	SO	8080
IT	23011	Ardenno	Lombardia	Sondrio	SO	8081
IT	23012	Castione Andevenno	Lombardia	Sondrio	SO	8082
IT	23013	Sacco	Lombardia	Sondrio	SO	8083
IT	23013	Regoledo	Lombardia	Sondrio	SO	8084
IT	23013	Cosio Valtellino	Lombardia	Sondrio	SO	8085
IT	23013	Cosio Stazione	Lombardia	Sondrio	SO	8086
IT	23014	Delebio	Lombardia	Sondrio	SO	8087
IT	23014	Andalo Valtellino	Lombardia	Sondrio	SO	8088
IT	23015	Dubino	Lombardia	Sondrio	SO	8089
IT	23015	Nuova Olonio	Lombardia	Sondrio	SO	8090
IT	23016	Mantello	Lombardia	Sondrio	SO	8091
IT	23016	Cercino	Lombardia	Sondrio	SO	8092
IT	23017	Morbegno	Lombardia	Sondrio	SO	8093
IT	23017	Campovico	Lombardia	Sondrio	SO	8094
IT	23018	Talamona	Lombardia	Sondrio	SO	8095
IT	23019	Traona	Lombardia	Sondrio	SO	8096
IT	23020	Caspoggio	Lombardia	Sondrio	SO	8097
IT	23020	Mese	Lombardia	Sondrio	SO	8098
IT	23020	San Cassiano	Lombardia	Sondrio	SO	8099
IT	23020	Boffetto	Lombardia	Sondrio	SO	8100
IT	23020	Prosto	Lombardia	Sondrio	SO	8101
IT	23020	Spriana	Lombardia	Sondrio	SO	8102
IT	23020	Menarola	Lombardia	Sondrio	SO	8103
IT	23020	Gordona	Lombardia	Sondrio	SO	8104
IT	23020	Piuro	Lombardia	Sondrio	SO	8105
IT	23020	Lanzada	Lombardia	Sondrio	SO	8106
IT	23020	Santa Croce Di Piuro	Lombardia	Sondrio	SO	8107
IT	23020	Tresivio	Lombardia	Sondrio	SO	8108
IT	23020	Santa Croce	Lombardia	Sondrio	SO	8109
IT	23020	Verceia	Lombardia	Sondrio	SO	8110
IT	23020	San Giacomo Filippo	Lombardia	Sondrio	SO	8111
IT	23020	Borgonuovo Di Piuro	Lombardia	Sondrio	SO	8112
IT	23020	Montagna In Valtellina	Lombardia	Sondrio	SO	8113
IT	23020	Prata Camportaccio	Lombardia	Sondrio	SO	8114
IT	23020	San Cassiano Valchiavenna	Lombardia	Sondrio	SO	8115
IT	23020	Piateda	Lombardia	Sondrio	SO	8116
IT	23020	Faedo Valtellino	Lombardia	Sondrio	SO	8117
IT	23020	Lirone	Lombardia	Sondrio	SO	8118
IT	23020	Torre Di Santa Maria	Lombardia	Sondrio	SO	8119
IT	23020	Prasomaso	Lombardia	Sondrio	SO	8120
IT	23020	Poggiridenti	Lombardia	Sondrio	SO	8121
IT	23021	Fraciscio	Lombardia	Sondrio	SO	8122
IT	23021	Campodolcino	Lombardia	Sondrio	SO	8123
IT	23022	Chiavenna	Lombardia	Sondrio	SO	8124
IT	23022	Bette	Lombardia	Sondrio	SO	8125
IT	23023	Primolo	Lombardia	Sondrio	SO	8126
IT	23023	Chiareggio	Lombardia	Sondrio	SO	8127
IT	23023	Chiesa In Valmalenco	Lombardia	Sondrio	SO	8128
IT	23024	Isola	Lombardia	Sondrio	SO	8129
IT	23024	Madesimo	Lombardia	Sondrio	SO	8130
IT	23024	Montespluga	Lombardia	Sondrio	SO	8131
IT	23024	Pianazzo	Lombardia	Sondrio	SO	8132
IT	23025	Novate Mezzola	Lombardia	Sondrio	SO	8133
IT	23025	Campo	Lombardia	Sondrio	SO	8134
IT	23026	Arigna	Lombardia	Sondrio	SO	8135
IT	23026	Ponte In Valtellina	Lombardia	Sondrio	SO	8136
IT	23027	Era	Lombardia	Sondrio	SO	8137
IT	23027	Samolaco	Lombardia	Sondrio	SO	8138
IT	23027	Era Samolaco	Lombardia	Sondrio	SO	8139
IT	23027	San Pietro	Lombardia	Sondrio	SO	8140
IT	23027	Somaggia	Lombardia	Sondrio	SO	8141
IT	23027	San Pietro Samolaco	Lombardia	Sondrio	SO	8142
IT	23029	Dogana	Lombardia	Sondrio	SO	8143
IT	23029	Villa Di Chiavenna	Lombardia	Sondrio	SO	8144
IT	23029	Dogana Di Villa Chiavenna	Lombardia	Sondrio	SO	8145
IT	23030	Stazzona	Lombardia	Sondrio	SO	8146
IT	23030	Castionetto	Lombardia	Sondrio	SO	8147
IT	23030	San Nicolo' Di Valfurva	Lombardia	Sondrio	SO	8148
IT	23030	Trepalle	Lombardia	Sondrio	SO	8149
IT	23030	Sernio	Lombardia	Sondrio	SO	8150
IT	23030	Santa Caterina Valfurva	Lombardia	Sondrio	SO	8151
IT	23030	Chiuro	Lombardia	Sondrio	SO	8152
IT	23030	Castello Dell'Acqua	Lombardia	Sondrio	SO	8153
IT	23030	Villa Di Tirano	Lombardia	Sondrio	SO	8154
IT	23030	Valdisotto	Lombardia	Sondrio	SO	8155
IT	23030	Bianzone	Lombardia	Sondrio	SO	8156
IT	23030	Vervio	Lombardia	Sondrio	SO	8157
IT	23030	Cepina Valdisotto	Lombardia	Sondrio	SO	8158
IT	23030	Santa Caterina	Lombardia	Sondrio	SO	8159
IT	23030	Cepina	Lombardia	Sondrio	SO	8160
IT	23030	Tovo Di Sant'Agata	Lombardia	Sondrio	SO	8161
IT	23030	Sant'Antonio	Lombardia	Sondrio	SO	8162
IT	23030	Livigno	Lombardia	Sondrio	SO	8163
IT	23030	Lovero	Lombardia	Sondrio	SO	8164
IT	23030	Valfurva	Lombardia	Sondrio	SO	8165
IT	23030	Piatta	Lombardia	Sondrio	SO	8166
IT	23030	Mazzo Di Valtellina	Lombardia	Sondrio	SO	8167
IT	23031	Aprica	Lombardia	Sondrio	SO	8168
IT	23032	Passo Stelvio	Lombardia	Sondrio	SO	8169
IT	23032	Bormio	Lombardia	Sondrio	SO	8170
IT	23033	Grosio	Lombardia	Sondrio	SO	8171
IT	23033	Tiolo	Lombardia	Sondrio	SO	8172
IT	23033	Ravoledo	Lombardia	Sondrio	SO	8173
IT	23034	Grosotto	Lombardia	Sondrio	SO	8174
IT	23035	Frontale	Lombardia	Sondrio	SO	8175
IT	23035	Le Prese	Lombardia	Sondrio	SO	8176
IT	23035	Pineta Di Sortenna Vallesana	Lombardia	Sondrio	SO	8177
IT	23035	Mondadizza	Lombardia	Sondrio	SO	8178
IT	23035	Pendosso	Lombardia	Sondrio	SO	8179
IT	23035	Sondalo	Lombardia	Sondrio	SO	8180
IT	23035	Pineta Di Sortenna	Lombardia	Sondrio	SO	8181
IT	23035	Abetina Vallesana	Lombardia	Sondrio	SO	8182
IT	23035	Villaggio Sondalo	Lombardia	Sondrio	SO	8183
IT	23036	Teglio	Lombardia	Sondrio	SO	8184
IT	23036	San Giacomo Di Teglio	Lombardia	Sondrio	SO	8185
IT	23036	Tresenda	Lombardia	Sondrio	SO	8186
IT	23036	San Giacomo	Lombardia	Sondrio	SO	8187
IT	23037	Madonna Di Tirano	Lombardia	Sondrio	SO	8188
IT	23037	Tirano	Lombardia	Sondrio	SO	8189
IT	23038	Semogo	Lombardia	Sondrio	SO	8190
IT	23038	Isolaccia	Lombardia	Sondrio	SO	8191
IT	23038	Bagni Nuovi	Lombardia	Sondrio	SO	8192
IT	23038	Valdidentro	Lombardia	Sondrio	SO	8193
IT	23038	Bagni Nuovi Di Bormio	Lombardia	Sondrio	SO	8194
IT	23100	Faedo	Lombardia	Sondrio	SO	8195
IT	23100	Ponchiera	Lombardia	Sondrio	SO	8196
IT	23100	Triangia	Lombardia	Sondrio	SO	8197
IT	23100	Albosaggia	Lombardia	Sondrio	SO	8198
IT	23100	Sant'Anna	Lombardia	Sondrio	SO	8199
IT	23100	Mossini	Lombardia	Sondrio	SO	8200
IT	23100	Sondrio	Lombardia	Sondrio	SO	8201
IT	21010	Besnate	Lombardia	Varese	VA	8202
IT	21030	Grantola	Lombardia	Varese	VA	8203
IT	21010	Tronzano Lago Maggiore	Lombardia	Varese	VA	8204
IT	21010	Germignaga	Lombardia	Varese	VA	8205
IT	21010	Dumenza	Lombardia	Varese	VA	8206
IT	21010	Pino Sulla Sponda Del Lago Maggiore	Lombardia	Varese	VA	8207
IT	21010	Due Cossani	Lombardia	Varese	VA	8208
IT	21010	Montegrino Valtravaglia	Lombardia	Varese	VA	8209
IT	21010	Veddasca	Lombardia	Varese	VA	8210
IT	21010	San Macario	Lombardia	Varese	VA	8211
IT	21010	Ferno	Lombardia	Varese	VA	8212
IT	21010	Castelveccana	Lombardia	Varese	VA	8213
IT	21010	Cardano Al Campo	Lombardia	Varese	VA	8214
IT	21010	Arsago Seprio	Lombardia	Varese	VA	8215
IT	21010	Brezzo Di Bedero	Lombardia	Varese	VA	8216
IT	21010	Nasca	Lombardia	Varese	VA	8217
IT	21010	Agra	Lombardia	Varese	VA	8218
IT	21010	Castello	Lombardia	Varese	VA	8219
IT	21010	Vizzola Ticino	Lombardia	Varese	VA	8220
IT	21010	Muceno	Lombardia	Varese	VA	8221
IT	21010	Porto Valtravaglia	Lombardia	Varese	VA	8222
IT	21010	Domo	Lombardia	Varese	VA	8223
IT	21010	Golasecca	Lombardia	Varese	VA	8224
IT	21010	Curiglia Con Monteviasco	Lombardia	Varese	VA	8225
IT	21010	Ligurno	Lombardia	Varese	VA	8226
IT	21010	Calde'	Lombardia	Varese	VA	8227
IT	21011	Casorate Sempione	Lombardia	Varese	VA	8228
IT	21012	Cassano Magnago	Lombardia	Varese	VA	8229
IT	21013	Gallarate	Lombardia	Varese	VA	8230
IT	21013	Cedrate	Lombardia	Varese	VA	8231
IT	21013	Crenna	Lombardia	Varese	VA	8232
IT	21014	Laveno	Lombardia	Varese	VA	8233
IT	21014	Laveno Mombello	Lombardia	Varese	VA	8234
IT	21014	Mombello	Lombardia	Varese	VA	8235
IT	21015	Lonate Pozzolo	Lombardia	Varese	VA	8236
IT	21015	Tornavento	Lombardia	Varese	VA	8237
IT	21015	Sant'Antonino Ticino	Lombardia	Varese	VA	8238
IT	21016	Luino	Lombardia	Varese	VA	8239
IT	21016	Poppino	Lombardia	Varese	VA	8240
IT	21016	Creva	Lombardia	Varese	VA	8241
IT	21016	Voldomino	Lombardia	Varese	VA	8242
IT	21017	Cascina Costa	Lombardia	Varese	VA	8243
IT	21017	Samarate	Lombardia	Varese	VA	8244
IT	21017	Cascina Elisa	Lombardia	Varese	VA	8245
IT	21017	Verghera	Lombardia	Varese	VA	8246
IT	21018	Osmate	Lombardia	Varese	VA	8247
IT	21018	Lisanza	Lombardia	Varese	VA	8248
IT	21018	Sesto Calende	Lombardia	Varese	VA	8249
IT	21019	Coarezza	Lombardia	Varese	VA	8250
IT	21019	Somma Lombardo	Lombardia	Varese	VA	8251
IT	21019	Maddalena	Lombardia	Varese	VA	8252
IT	21019	Case Nuove	Lombardia	Varese	VA	8253
IT	21019	Malpensa Aeroporto	Lombardia	Varese	VA	8254
IT	21020	Cadrezzate	Lombardia	Varese	VA	8255
IT	21020	Bodio Lomnago	Lombardia	Varese	VA	8256
IT	21020	Daverio	Lombardia	Varese	VA	8257
IT	21020	Brebbia	Lombardia	Varese	VA	8258
IT	21020	Comabbio	Lombardia	Varese	VA	8259
IT	21020	Ranco	Lombardia	Varese	VA	8260
IT	21020	Mornago	Lombardia	Varese	VA	8261
IT	21020	Bodio	Lombardia	Varese	VA	8262
IT	21020	Casale Litta	Lombardia	Varese	VA	8263
IT	21020	Buguggiate	Lombardia	Varese	VA	8264
IT	21020	Brunello	Lombardia	Varese	VA	8265
IT	21020	Villadosia	Lombardia	Varese	VA	8266
IT	21020	Montonate	Lombardia	Varese	VA	8267
IT	21020	Crosio Della Valle	Lombardia	Varese	VA	8268
IT	21020	Bardello	Lombardia	Varese	VA	8269
IT	21020	Malgesso	Lombardia	Varese	VA	8270
IT	21020	Casciago	Lombardia	Varese	VA	8271
IT	21020	Barasso	Lombardia	Varese	VA	8272
IT	21020	Bregano	Lombardia	Varese	VA	8273
IT	21020	Bernate	Lombardia	Varese	VA	8274
IT	21020	Galliate Lombardo	Lombardia	Varese	VA	8275
IT	21020	Cazzago Brabbia	Lombardia	Varese	VA	8276
IT	21020	Inarzo	Lombardia	Varese	VA	8277
IT	21020	Varano Borghi	Lombardia	Varese	VA	8278
IT	21020	Taino	Lombardia	Varese	VA	8279
IT	21020	Ternate	Lombardia	Varese	VA	8280
IT	21020	Luvinate	Lombardia	Varese	VA	8281
IT	21020	Lomnago	Lombardia	Varese	VA	8282
IT	21020	Monvalle	Lombardia	Varese	VA	8283
IT	21020	Crugnola	Lombardia	Varese	VA	8284
IT	21020	Mercallo	Lombardia	Varese	VA	8285
IT	21021	Angera	Lombardia	Varese	VA	8286
IT	21022	Azzate	Lombardia	Varese	VA	8287
IT	21023	Besozzo	Lombardia	Varese	VA	8288
IT	21024	Biandronno	Lombardia	Varese	VA	8289
IT	21025	Comerio	Lombardia	Varese	VA	8290
IT	21026	Oltrona Al Lago	Lombardia	Varese	VA	8291
IT	21026	Gavirate	Lombardia	Varese	VA	8292
IT	21027	Barza	Lombardia	Varese	VA	8293
IT	21027	Ispra	Lombardia	Varese	VA	8294
IT	21027	Ispra Centro Euratom	Lombardia	Varese	VA	8295
IT	21028	Travedona Monate	Lombardia	Varese	VA	8296
IT	21029	Corgeno	Lombardia	Varese	VA	8297
IT	21029	Cimbro	Lombardia	Varese	VA	8298
IT	21029	Cuirone	Lombardia	Varese	VA	8299
IT	21029	Vergiate	Lombardia	Varese	VA	8300
IT	21030	Marzio	Lombardia	Varese	VA	8301
IT	21030	Cremenaga	Lombardia	Varese	VA	8302
IT	21030	Mesenzana	Lombardia	Varese	VA	8303
IT	21030	Orino	Lombardia	Varese	VA	8304
IT	21030	Azzio	Lombardia	Varese	VA	8305
IT	21030	Cuveglio	Lombardia	Varese	VA	8306
IT	21030	Brenta	Lombardia	Varese	VA	8307
IT	21030	Brissago Valtravaglia	Lombardia	Varese	VA	8308
IT	21030	Masciago Primo	Lombardia	Varese	VA	8309
IT	21030	Duno	Lombardia	Varese	VA	8310
IT	21030	Cugliate	Lombardia	Varese	VA	8311
IT	21030	Cuvio	Lombardia	Varese	VA	8312
IT	21030	Marchirolo	Lombardia	Varese	VA	8313
IT	21030	Cugliate Fabiasco	Lombardia	Varese	VA	8314
IT	21030	Rancio Valcuvia	Lombardia	Varese	VA	8315
IT	21030	Ferrera Di Varese	Lombardia	Varese	VA	8316
IT	21030	Fabiasco	Lombardia	Varese	VA	8317
IT	21030	Cassano Valcuvia	Lombardia	Varese	VA	8318
IT	21030	Casalzuigno	Lombardia	Varese	VA	8319
IT	21030	Brinzio	Lombardia	Varese	VA	8320
IT	21030	Castello Cabiaglio	Lombardia	Varese	VA	8321
IT	21031	Cadegliano Viconago	Lombardia	Varese	VA	8322
IT	21031	Cadegliano	Lombardia	Varese	VA	8323
IT	21031	Viconago	Lombardia	Varese	VA	8324
IT	21032	Caravate	Lombardia	Varese	VA	8325
IT	21033	Cittiglio	Lombardia	Varese	VA	8326
IT	21034	Cocquio	Lombardia	Varese	VA	8327
IT	21034	Caldana	Lombardia	Varese	VA	8328
IT	21034	Trevisago	Lombardia	Varese	VA	8329
IT	21034	Cocquio Trevisago	Lombardia	Varese	VA	8330
IT	21035	Cunardo	Lombardia	Varese	VA	8331
IT	21036	Gemonio	Lombardia	Varese	VA	8332
IT	21037	Lavena Ponte Tresa	Lombardia	Varese	VA	8333
IT	21037	Ponte Tresa	Lombardia	Varese	VA	8334
IT	21038	Sangiano	Lombardia	Varese	VA	8335
IT	21038	Leggiuno	Lombardia	Varese	VA	8336
IT	21039	Ghirla	Lombardia	Varese	VA	8337
IT	21039	Valganna	Lombardia	Varese	VA	8338
IT	21039	Bedero Valcuvia	Lombardia	Varese	VA	8339
IT	21039	Ganna	Lombardia	Varese	VA	8340
IT	21040	Origgio	Lombardia	Varese	VA	8341
IT	21040	Gornate Olona	Lombardia	Varese	VA	8342
IT	21040	Venegono Inferiore	Lombardia	Varese	VA	8343
IT	21040	Gerenzano	Lombardia	Varese	VA	8344
IT	21040	Santo Stefano	Lombardia	Varese	VA	8345
IT	21040	Morazzone	Lombardia	Varese	VA	8346
IT	21040	Vedano Olona	Lombardia	Varese	VA	8347
IT	21040	Sumirago	Lombardia	Varese	VA	8348
IT	21040	Cislago	Lombardia	Varese	VA	8349
IT	21040	Carnago	Lombardia	Varese	VA	8350
IT	21040	Oggiona Con Santo Stefano	Lombardia	Varese	VA	8351
IT	21040	Cascine Maggio	Lombardia	Varese	VA	8352
IT	21040	Caronno Varesino	Lombardia	Varese	VA	8353
IT	21040	Oggiona	Lombardia	Varese	VA	8354
IT	21040	Venegono Superiore	Lombardia	Varese	VA	8355
IT	21040	Lozza	Lombardia	Varese	VA	8356
IT	21040	Castronno	Lombardia	Varese	VA	8357
IT	21040	Rovate	Lombardia	Varese	VA	8358
IT	21040	Uboldo	Lombardia	Varese	VA	8359
IT	21040	Massina	Lombardia	Varese	VA	8360
IT	21040	Jerago Con Orago	Lombardia	Varese	VA	8361
IT	21041	Albizzate	Lombardia	Varese	VA	8362
IT	21042	Caronno Pertusella	Lombardia	Varese	VA	8363
IT	21043	Castiglione Olona	Lombardia	Varese	VA	8364
IT	21043	Gornate Superiore	Lombardia	Varese	VA	8365
IT	21044	Cavaria Con Premezzo	Lombardia	Varese	VA	8366
IT	21045	Gazzada Schianno	Lombardia	Varese	VA	8367
IT	21045	Gazzada	Lombardia	Varese	VA	8368
IT	21045	Schianno	Lombardia	Varese	VA	8369
IT	21046	Malnate	Lombardia	Varese	VA	8370
IT	21046	San Salvatore	Lombardia	Varese	VA	8371
IT	21047	Saronno	Lombardia	Varese	VA	8372
IT	21048	Solbiate Arno	Lombardia	Varese	VA	8373
IT	21048	Monte	Lombardia	Varese	VA	8374
IT	21049	Tradate	Lombardia	Varese	VA	8375
IT	21049	Abbiate Guazzone	Lombardia	Varese	VA	8376
IT	21050	Cavagnano	Lombardia	Varese	VA	8377
IT	21050	Cantello	Lombardia	Varese	VA	8378
IT	21050	Clivio	Lombardia	Varese	VA	8379
IT	21050	Gorla Maggiore	Lombardia	Varese	VA	8380
IT	21050	Marnate	Lombardia	Varese	VA	8381
IT	21050	Lonate Ceppino	Lombardia	Varese	VA	8382
IT	21050	Besano	Lombardia	Varese	VA	8383
IT	21050	Cuasso Al Monte	Lombardia	Varese	VA	8384
IT	21050	Gaggiolo	Lombardia	Varese	VA	8385
IT	21050	Brusimpiano	Lombardia	Varese	VA	8386
IT	21050	Porto Ceresio	Lombardia	Varese	VA	8387
IT	21050	Cuasso Al Piano	Lombardia	Varese	VA	8388
IT	21050	Cairate	Lombardia	Varese	VA	8389
IT	21050	Bolladello	Lombardia	Varese	VA	8390
IT	21050	Castelseprio	Lombardia	Varese	VA	8391
IT	21050	Saltrio	Lombardia	Varese	VA	8392
IT	21050	Bisuschio	Lombardia	Varese	VA	8393
IT	21051	Arcisate	Lombardia	Varese	VA	8394
IT	21051	Brenno Useria	Lombardia	Varese	VA	8395
IT	21052	Busto Arsizio	Lombardia	Varese	VA	8396
IT	21052	Borsano	Lombardia	Varese	VA	8397
IT	21052	Sacconago	Lombardia	Varese	VA	8398
IT	21053	Castellanza	Lombardia	Varese	VA	8399
IT	21054	Bergoro	Lombardia	Varese	VA	8400
IT	21054	Fagnano Olona	Lombardia	Varese	VA	8401
IT	21055	Gorla Minore	Lombardia	Varese	VA	8402
IT	21056	Induno Olona	Lombardia	Varese	VA	8403
IT	21057	Olgiate Olona	Lombardia	Varese	VA	8404
IT	21057	Cascina Buon Gesu'	Lombardia	Varese	VA	8405
IT	21058	Solbiate Olona	Lombardia	Varese	VA	8406
IT	21059	Viggiu'	Lombardia	Varese	VA	8407
IT	21059	Baraggia	Lombardia	Varese	VA	8408
IT	21061	Maccagno	Lombardia	Varese	VA	8409
IT	21061	Maccagno Con Pino E Veddasca	Lombardia	Varese	VA	8410
IT	21100	Casbeno	Lombardia	Varese	VA	8411
IT	21100	Capolago	Lombardia	Varese	VA	8412
IT	21100	Calcinate Del Pesce	Lombardia	Varese	VA	8413
IT	21100	Bizzozero	Lombardia	Varese	VA	8414
IT	21100	Rasa Di Velate	Lombardia	Varese	VA	8415
IT	21100	Varese	Lombardia	Varese	VA	8416
IT	21100	Masnago	Lombardia	Varese	VA	8417
IT	21100	Santa Maria Del Monte	Lombardia	Varese	VA	8418
IT	21100	Rasa	Lombardia	Varese	VA	8419
IT	21100	Sant'Ambrogio Olona	Lombardia	Varese	VA	8420
IT	21100	San Fermo	Lombardia	Varese	VA	8421
IT	21100	Cartabbia	Lombardia	Varese	VA	8422
IT	60010	Pianello	Marche	Ancona	AN	8423
IT	60010	Vaccarile	Marche	Ancona	AN	8424
IT	60010	Ostra	Marche	Ancona	AN	8425
IT	60010	Barbara	Marche	Ancona	AN	8426
IT	60010	Casine	Marche	Ancona	AN	8427
IT	60010	Pianello Di Ostra	Marche	Ancona	AN	8428
IT	60010	Ostra Vetere	Marche	Ancona	AN	8429
IT	60010	Castelleone Di Suasa	Marche	Ancona	AN	8430
IT	60010	Ponte Rio Di Monterado	Marche	Ancona	AN	8431
IT	60011	Palazzo	Marche	Ancona	AN	8432
IT	60011	Arcevia	Marche	Ancona	AN	8433
IT	60011	Avacelli	Marche	Ancona	AN	8434
IT	60011	Nidastore	Marche	Ancona	AN	8435
IT	60011	Piticchio	Marche	Ancona	AN	8436
IT	60011	Palazzo D'Arcevia	Marche	Ancona	AN	8437
IT	60011	Montefortino	Marche	Ancona	AN	8438
IT	60011	Castiglioni	Marche	Ancona	AN	8439
IT	60011	Costa D'Arcevia	Marche	Ancona	AN	8440
IT	60011	Castiglioni D'Arcevia	Marche	Ancona	AN	8441
IT	60012	Castel Colonna	Marche	Ancona	AN	8442
IT	60012	Ripe	Marche	Ancona	AN	8443
IT	60012	Ponte Rio	Marche	Ancona	AN	8444
IT	60012	Monterado	Marche	Ancona	AN	8445
IT	60012	Passo Di Ripe	Marche	Ancona	AN	8446
IT	60012	Trecastelli	Marche	Ancona	AN	8447
IT	60012	Brugnetto	Marche	Ancona	AN	8448
IT	60013	Corinaldo	Marche	Ancona	AN	8449
IT	60015	Falconara Marittima	Marche	Ancona	AN	8450
IT	60015	Castelferretti	Marche	Ancona	AN	8451
IT	60015	Falconara Alta	Marche	Ancona	AN	8452
IT	60018	Marina Di Montemarciano	Marche	Ancona	AN	8453
IT	60018	Montemarciano	Marche	Ancona	AN	8454
IT	60018	Lungomare	Marche	Ancona	AN	8455
IT	60019	Senigallia	Marche	Ancona	AN	8456
IT	60019	Vallone	Marche	Ancona	AN	8457
IT	60019	Sant'Angelo	Marche	Ancona	AN	8458
IT	60019	Marzocca Di Senigallia	Marche	Ancona	AN	8459
IT	60019	Scapezzano	Marche	Ancona	AN	8460
IT	60019	Sant'Angelo Di Senigallia	Marche	Ancona	AN	8461
IT	60019	Montignano	Marche	Ancona	AN	8462
IT	60019	Roncitelli	Marche	Ancona	AN	8463
IT	60019	Marzocca	Marche	Ancona	AN	8464
IT	60019	Cesano Di Senigallia	Marche	Ancona	AN	8465
IT	60020	Camerata Picena	Marche	Ancona	AN	8466
IT	60020	Polverigi	Marche	Ancona	AN	8467
IT	60020	Castel D'Emilio	Marche	Ancona	AN	8468
IT	60020	Sirolo	Marche	Ancona	AN	8469
IT	60020	Agugliano	Marche	Ancona	AN	8470
IT	60020	Offagna	Marche	Ancona	AN	8471
IT	60021	Camerano	Marche	Ancona	AN	8472
IT	60021	Aspio Terme	Marche	Ancona	AN	8473
IT	60022	Castelfidardo	Marche	Ancona	AN	8474
IT	60022	San Rocchetto	Marche	Ancona	AN	8475
IT	60022	Acquaviva Villa Musone	Marche	Ancona	AN	8476
IT	60024	Filottrano	Marche	Ancona	AN	8477
IT	60024	Montoro	Marche	Ancona	AN	8478
IT	60025	Loreto Stazione	Marche	Ancona	AN	8479
IT	60025	Villa Musone	Marche	Ancona	AN	8480
IT	60025	Loreto	Marche	Ancona	AN	8481
IT	60026	Marcelli	Marche	Ancona	AN	8482
IT	60026	Numana	Marche	Ancona	AN	8483
IT	60026	Numana Lido	Marche	Ancona	AN	8484
IT	60027	Casenuove	Marche	Ancona	AN	8485
IT	60027	Osimo	Marche	Ancona	AN	8486
IT	60027	Campocavallo	Marche	Ancona	AN	8487
IT	60027	San Biagio	Marche	Ancona	AN	8488
IT	60027	San Sabino	Marche	Ancona	AN	8489
IT	60027	Padiglione	Marche	Ancona	AN	8490
IT	60027	Osimo Stazione	Marche	Ancona	AN	8491
IT	60027	Passatempo	Marche	Ancona	AN	8492
IT	60030	Angeli Di Mergo	Marche	Ancona	AN	8493
IT	60030	Serra De' Conti	Marche	Ancona	AN	8494
IT	60030	Pianello Vallesina	Marche	Ancona	AN	8495
IT	60030	Moie	Marche	Ancona	AN	8496
IT	60030	Angeli	Marche	Ancona	AN	8497
IT	60030	Belvedere Ostrense	Marche	Ancona	AN	8498
IT	60030	Osteria	Marche	Ancona	AN	8499
IT	60030	Castelbellino	Marche	Ancona	AN	8500
IT	60030	San Marcello	Marche	Ancona	AN	8501
IT	60030	Mergo	Marche	Ancona	AN	8502
IT	60030	Rosora	Marche	Ancona	AN	8503
IT	60030	Poggio San Marcello	Marche	Ancona	AN	8504
IT	60030	Santa Maria Nuova	Marche	Ancona	AN	8505
IT	60030	Morro D'Alba	Marche	Ancona	AN	8506
IT	60030	Maiolati Spontini	Marche	Ancona	AN	8507
IT	60030	Collina Santa Maria Nuova	Marche	Ancona	AN	8508
IT	60030	Monsano	Marche	Ancona	AN	8509
IT	60030	Angeli Di Rosora	Marche	Ancona	AN	8510
IT	60030	Monte Roberto	Marche	Ancona	AN	8511
IT	60030	Stazione	Marche	Ancona	AN	8512
IT	60031	Macine	Marche	Ancona	AN	8513
IT	60031	Castelplanio	Marche	Ancona	AN	8514
IT	60031	Castelplanio Stazione	Marche	Ancona	AN	8515
IT	60031	Borgo Loreto	Marche	Ancona	AN	8516
IT	60033	Grancetta	Marche	Ancona	AN	8517
IT	60033	Chiaravalle	Marche	Ancona	AN	8518
IT	60034	Cupramontana	Marche	Ancona	AN	8519
IT	60035	Jesi	Marche	Ancona	AN	8520
IT	60036	Montecarotto	Marche	Ancona	AN	8521
IT	60037	Monte San Vito	Marche	Ancona	AN	8522
IT	60037	Le Cozze	Marche	Ancona	AN	8523
IT	60037	Borghetto	Marche	Ancona	AN	8524
IT	60038	San Paolo Di Jesi	Marche	Ancona	AN	8525
IT	60039	Staffolo	Marche	Ancona	AN	8526
IT	60040	Genga Stazione	Marche	Ancona	AN	8527
IT	60040	Genga	Marche	Ancona	AN	8528
IT	60040	Colleponi	Marche	Ancona	AN	8529
IT	60040	Trinquelli	Marche	Ancona	AN	8530
IT	60040	Colleponi Di Genga	Marche	Ancona	AN	8531
IT	60041	Cabernardi	Marche	Ancona	AN	8532
IT	60041	Monterosso	Marche	Ancona	AN	8533
IT	60041	Perticano	Marche	Ancona	AN	8534
IT	60041	Piano Di Frassineta	Marche	Ancona	AN	8535
IT	60041	Monterosso Stazione	Marche	Ancona	AN	8536
IT	60041	Sassoferrato	Marche	Ancona	AN	8537
IT	60041	Borgo Sassoferrato	Marche	Ancona	AN	8538
IT	60043	Cerreto D'Esi	Marche	Ancona	AN	8539
IT	60044	Collamato	Marche	Ancona	AN	8540
IT	60044	Borgo Tufico	Marche	Ancona	AN	8541
IT	60044	Marischio	Marche	Ancona	AN	8542
IT	60044	San Donato	Marche	Ancona	AN	8543
IT	60044	Melano	Marche	Ancona	AN	8544
IT	60044	Campodonico	Marche	Ancona	AN	8545
IT	60044	Cancelli	Marche	Ancona	AN	8546
IT	60044	Argignano	Marche	Ancona	AN	8547
IT	60044	San Michele	Marche	Ancona	AN	8548
IT	60044	Fabriano	Marche	Ancona	AN	8549
IT	60044	Nebbiano	Marche	Ancona	AN	8550
IT	60044	Sant'Elia	Marche	Ancona	AN	8551
IT	60044	Albacina	Marche	Ancona	AN	8552
IT	60044	Serradica	Marche	Ancona	AN	8553
IT	60044	Castelletta	Marche	Ancona	AN	8554
IT	60044	Rocchetta Di Fabriano	Marche	Ancona	AN	8555
IT	60044	Attiggio	Marche	Ancona	AN	8556
IT	60044	Melano Bastia	Marche	Ancona	AN	8557
IT	60048	Serra San Quirico	Marche	Ancona	AN	8558
IT	60048	Castellaro	Marche	Ancona	AN	8559
IT	60048	Sasso	Marche	Ancona	AN	8560
IT	60048	Domo	Marche	Ancona	AN	8561
IT	60048	Serra San Quirico Stazione	Marche	Ancona	AN	8562
IT	60100	Ancona	Marche	Ancona	AN	8563
IT	60121	Ancona	Marche	Ancona	AN	8564
IT	60122	Ancona	Marche	Ancona	AN	8565
IT	60123	Ancona	Marche	Ancona	AN	8566
IT	60124	Ancona	Marche	Ancona	AN	8567
IT	60125	Ancona	Marche	Ancona	AN	8568
IT	60126	Ancona	Marche	Ancona	AN	8569
IT	60127	Pinocchio	Marche	Ancona	AN	8570
IT	60127	Ancona	Marche	Ancona	AN	8571
IT	60128	Ancona	Marche	Ancona	AN	8572
IT	60129	Poggio	Marche	Ancona	AN	8573
IT	60129	Varano	Marche	Ancona	AN	8574
IT	60129	Pietralacroce	Marche	Ancona	AN	8575
IT	60129	Ancona	Marche	Ancona	AN	8576
IT	60131	Montesicuro	Marche	Ancona	AN	8577
IT	60131	Ancona	Marche	Ancona	AN	8578
IT	63020	Piane Di Falerone	Marche	Ascoli Piceno	AP	8579
IT	63031	Castel Di Lama Stazione	Marche	Ascoli Piceno	AP	8580
IT	63061	Massignano	Marche	Ascoli Piceno	AP	8581
IT	63062	Montefiore Dell'Aso	Marche	Ascoli Piceno	AP	8582
IT	63063	Carassai	Marche	Ascoli Piceno	AP	8583
IT	63064	Cupra Marittima	Marche	Ascoli Piceno	AP	8584
IT	63065	Ripatransone	Marche	Ascoli Piceno	AP	8585
IT	63065	San Savino	Marche	Ascoli Piceno	AP	8586
IT	63066	Grottammare	Marche	Ascoli Piceno	AP	8587
IT	63066	Ischia	Marche	Ascoli Piceno	AP	8588
IT	63067	Cossignano	Marche	Ascoli Piceno	AP	8589
IT	63068	Montalto Delle Marche	Marche	Ascoli Piceno	AP	8590
IT	63068	Patrignone	Marche	Ascoli Piceno	AP	8591
IT	63068	Porchia	Marche	Ascoli Piceno	AP	8592
IT	63069	Montedinove	Marche	Ascoli Piceno	AP	8593
IT	63071	Rotella	Marche	Ascoli Piceno	AP	8594
IT	63071	Castel Di Croce	Marche	Ascoli Piceno	AP	8595
IT	63072	Ripaberarda	Marche	Ascoli Piceno	AP	8596
IT	63072	Castignano	Marche	Ascoli Piceno	AP	8597
IT	63073	Offida	Marche	Ascoli Piceno	AP	8598
IT	63074	San Benedetto Del Tronto	Marche	Ascoli Piceno	AP	8599
IT	63074	Porto D'Ascoli	Marche	Ascoli Piceno	AP	8600
IT	63075	Acquaviva Picena	Marche	Ascoli Piceno	AP	8601
IT	63076	Monteprandone	Marche	Ascoli Piceno	AP	8602
IT	63076	Centobuchi	Marche	Ascoli Piceno	AP	8603
IT	63077	Stella Di Monsampolo	Marche	Ascoli Piceno	AP	8604
IT	63077	Monsampolo Del Tronto	Marche	Ascoli Piceno	AP	8605
IT	63078	Pagliare	Marche	Ascoli Piceno	AP	8606
IT	63078	Spinetoli	Marche	Ascoli Piceno	AP	8607
IT	63079	Villa San Giuseppe	Marche	Ascoli Piceno	AP	8608
IT	63079	Colli Del Tronto	Marche	Ascoli Piceno	AP	8609
IT	63081	San Silvestro	Marche	Ascoli Piceno	AP	8610
IT	63081	Castorano	Marche	Ascoli Piceno	AP	8611
IT	63082	Castel Di Lama	Marche	Ascoli Piceno	AP	8612
IT	63082	Piattoni	Marche	Ascoli Piceno	AP	8613
IT	63082	Villa Sant'Antonio	Marche	Ascoli Piceno	AP	8614
IT	63082	Castel Di Lama Piattoni	Marche	Ascoli Piceno	AP	8615
IT	63083	Appignano Del Tronto	Marche	Ascoli Piceno	AP	8616
IT	63084	Pigna Bassa	Marche	Ascoli Piceno	AP	8617
IT	63084	Villa Pigna	Marche	Ascoli Piceno	AP	8618
IT	63084	Folignano	Marche	Ascoli Piceno	AP	8619
IT	63084	Piane Di Morro	Marche	Ascoli Piceno	AP	8620
IT	63085	Caselle	Marche	Ascoli Piceno	AP	8621
IT	63085	Maltignano	Marche	Ascoli Piceno	AP	8622
IT	63086	Force	Marche	Ascoli Piceno	AP	8623
IT	63087	Croce Di Casale	Marche	Ascoli Piceno	AP	8624
IT	63087	Comunanza	Marche	Ascoli Piceno	AP	8625
IT	63088	Montemonaco	Marche	Ascoli Piceno	AP	8626
IT	63091	Venarotta	Marche	Ascoli Piceno	AP	8627
IT	63092	Palmiano	Marche	Ascoli Piceno	AP	8628
IT	63093	Marsia	Marche	Ascoli Piceno	AP	8629
IT	63093	Agelli	Marche	Ascoli Piceno	AP	8630
IT	63093	Roccafluvione	Marche	Ascoli Piceno	AP	8631
IT	63094	Bisignano	Marche	Ascoli Piceno	AP	8632
IT	63094	Montegallo	Marche	Ascoli Piceno	AP	8633
IT	63095	Acquasanta Terme	Marche	Ascoli Piceno	AP	8634
IT	63095	Tallacano	Marche	Ascoli Piceno	AP	8635
IT	63095	Ponte D'Arli	Marche	Ascoli Piceno	AP	8636
IT	63095	Quintodecimo	Marche	Ascoli Piceno	AP	8637
IT	63095	Pozza Di Acquasanta	Marche	Ascoli Piceno	AP	8638
IT	63095	Paggese	Marche	Ascoli Piceno	AP	8639
IT	63095	San Martino Di Acquasanta	Marche	Ascoli Piceno	AP	8640
IT	63096	Capodacqua	Marche	Ascoli Piceno	AP	8641
IT	63096	Arquata Del Tronto	Marche	Ascoli Piceno	AP	8642
IT	63096	Pretare	Marche	Ascoli Piceno	AP	8643
IT	63096	Pescara Del Tronto	Marche	Ascoli Piceno	AP	8644
IT	63096	Trisungo	Marche	Ascoli Piceno	AP	8645
IT	63096	Spelonga	Marche	Ascoli Piceno	AP	8646
IT	63100	Lisciano Di Colloto	Marche	Ascoli Piceno	AP	8647
IT	63100	Venagrande	Marche	Ascoli Piceno	AP	8648
IT	63100	Piagge	Marche	Ascoli Piceno	AP	8649
IT	63100	Mozzano	Marche	Ascoli Piceno	AP	8650
IT	63100	Campolungo	Marche	Ascoli Piceno	AP	8651
IT	63100	Ascoli Piceno	Marche	Ascoli Piceno	AP	8652
IT	63100	Castel Trosino	Marche	Ascoli Piceno	AP	8653
IT	63100	Lisciano	Marche	Ascoli Piceno	AP	8654
IT	63100	Monticelli	Marche	Ascoli Piceno	AP	8655
IT	63100	Piagge Di Ascoli Piceno	Marche	Ascoli Piceno	AP	8656
IT	63100	Poggio Di Bretta	Marche	Ascoli Piceno	AP	8657
IT	63100	Marino Del Tronto	Marche	Ascoli Piceno	AP	8658
IT	63811	La Luce	Marche	Fermo	FM	8659
IT	63811	Castellano	Marche	Fermo	FM	8660
IT	63811	Sant'Elpidio A Mare	Marche	Fermo	FM	8661
IT	63811	Bivio Cascinare	Marche	Fermo	FM	8662
IT	63811	Cretarola	Marche	Fermo	FM	8663
IT	63811	Casette D'Ete	Marche	Fermo	FM	8664
IT	63811	Cascinare	Marche	Fermo	FM	8665
IT	63812	Montegranaro	Marche	Fermo	FM	8666
IT	63813	Monte Urano	Marche	Fermo	FM	8667
IT	63814	Torre San Patrizio	Marche	Fermo	FM	8668
IT	63815	Monte San Pietrangeli	Marche	Fermo	FM	8669
IT	63816	Francavilla D'Ete	Marche	Fermo	FM	8670
IT	63821	Porto Sant'Elpidio	Marche	Fermo	FM	8671
IT	63822	Porto San Giorgio	Marche	Fermo	FM	8672
IT	63823	Lapedona	Marche	Fermo	FM	8673
IT	63824	Marina Di Altidona	Marche	Fermo	FM	8674
IT	63824	Altidona	Marche	Fermo	FM	8675
IT	63825	Monterubbiano	Marche	Fermo	FM	8676
IT	63825	Rubbianello	Marche	Fermo	FM	8677
IT	63826	Moresco	Marche	Fermo	FM	8678
IT	63827	Pedaso	Marche	Fermo	FM	8679
IT	63828	Campofilone	Marche	Fermo	FM	8680
IT	63831	Contrada Tenna	Marche	Fermo	FM	8681
IT	63831	Rapagnano	Marche	Fermo	FM	8682
IT	63832	Magliano Di Tenna	Marche	Fermo	FM	8683
IT	63833	Piane Di Montegiorgio	Marche	Fermo	FM	8684
IT	63833	Montegiorgio	Marche	Fermo	FM	8685
IT	63833	Alteta	Marche	Fermo	FM	8686
IT	63834	Massa Fermana	Marche	Fermo	FM	8687
IT	63835	Montappone	Marche	Fermo	FM	8688
IT	63836	Monte Vidon Corrado	Marche	Fermo	FM	8689
IT	63837	Piane	Marche	Fermo	FM	8690
IT	63837	Falerone	Marche	Fermo	FM	8691
IT	63838	Belmonte Piceno	Marche	Fermo	FM	8692
IT	63839	Servigliano	Marche	Fermo	FM	8693
IT	63839	Curetta	Marche	Fermo	FM	8694
IT	63841	Monteleone Di Fermo	Marche	Fermo	FM	8695
IT	63842	Monsampietro Morico	Marche	Fermo	FM	8696
IT	63842	Sant'Elpidio Morico	Marche	Fermo	FM	8697
IT	63843	Montottone	Marche	Fermo	FM	8698
IT	63844	Grottazzolina	Marche	Fermo	FM	8699
IT	63845	Capparuccia	Marche	Fermo	FM	8700
IT	63845	Ponzano Di Fermo	Marche	Fermo	FM	8701
IT	63845	Torchiaro	Marche	Fermo	FM	8702
IT	63846	Monte Giberto	Marche	Fermo	FM	8703
IT	63847	Monte Vidon Combatte	Marche	Fermo	FM	8704
IT	63848	Petritoli	Marche	Fermo	FM	8705
IT	63848	Moregnano	Marche	Fermo	FM	8706
IT	63851	Ortezzano	Marche	Fermo	FM	8707
IT	63852	Monte Rinaldo	Marche	Fermo	FM	8708
IT	63853	Montelparo	Marche	Fermo	FM	8709
IT	63854	Santa Vittoria In Matenano	Marche	Fermo	FM	8710
IT	63855	Montefalcone Appennino	Marche	Fermo	FM	8711
IT	63856	Smerillo	Marche	Fermo	FM	8712
IT	63856	San Martino Al Faggio	Marche	Fermo	FM	8713
IT	63857	Amandola	Marche	Fermo	FM	8714
IT	63858	Montefortino	Marche	Fermo	FM	8715
IT	63858	Santa Lucia In Consilvano	Marche	Fermo	FM	8716
IT	63900	Fermo	Marche	Fermo	FM	8717
IT	63900	San Marco	Marche	Fermo	FM	8718
IT	63900	Molini Di Tenna	Marche	Fermo	FM	8719
IT	63900	Salvano	Marche	Fermo	FM	8720
IT	63900	San Tommaso Tre Archi	Marche	Fermo	FM	8721
IT	63900	Torre Di Palme	Marche	Fermo	FM	8722
IT	63900	Campiglione	Marche	Fermo	FM	8723
IT	63900	Capodarco	Marche	Fermo	FM	8724
IT	63900	Caldarette	Marche	Fermo	FM	8725
IT	63900	Marina Palmense	Marche	Fermo	FM	8726
IT	63900	Lido Di Fermo	Marche	Fermo	FM	8727
IT	63900	Ponte Ete	Marche	Fermo	FM	8728
IT	62010	Sambucheto	Marche	Macerata	MC	8729
IT	62010	Morrovalle Stazione	Marche	Macerata	MC	8730
IT	62010	Pollenza	Marche	Macerata	MC	8731
IT	62010	Morrovalle	Marche	Macerata	MC	8732
IT	62010	Trodica	Marche	Macerata	MC	8733
IT	62010	Passo Di Treia	Marche	Macerata	MC	8734
IT	62010	Stazione Morrovalle	Marche	Macerata	MC	8735
IT	62010	Sant'Egidio	Marche	Macerata	MC	8736
IT	62010	Mogliano	Marche	Macerata	MC	8737
IT	62010	Appignano	Marche	Macerata	MC	8738
IT	62010	Chiesanuova	Marche	Macerata	MC	8739
IT	62010	Montelupone	Marche	Macerata	MC	8740
IT	62010	Montecosaro	Marche	Macerata	MC	8741
IT	62010	Treia	Marche	Macerata	MC	8742
IT	62010	Casette Verdini	Marche	Macerata	MC	8743
IT	62010	Pintura	Marche	Macerata	MC	8744
IT	62010	Borgo Stazione	Marche	Macerata	MC	8745
IT	62010	Santa Maria In Selva	Marche	Macerata	MC	8746
IT	62010	Montecosaro Stazione	Marche	Macerata	MC	8747
IT	62010	Urbisaglia	Marche	Macerata	MC	8748
IT	62010	Montecassiano	Marche	Macerata	MC	8749
IT	62010	Montefano	Marche	Macerata	MC	8750
IT	62011	San Vittore	Marche	Macerata	MC	8751
IT	62011	Troviggiano	Marche	Macerata	MC	8752
IT	62011	Grottaccia	Marche	Macerata	MC	8753
IT	62011	Strada	Marche	Macerata	MC	8754
IT	62011	Cingoli	Marche	Macerata	MC	8755
IT	62011	Villa Torre	Marche	Macerata	MC	8756
IT	62011	Torre	Marche	Macerata	MC	8757
IT	62011	Moscosi	Marche	Macerata	MC	8758
IT	62011	Avenale	Marche	Macerata	MC	8759
IT	62011	Villa Moscosi	Marche	Macerata	MC	8760
IT	62012	Santa Maria Apparente	Marche	Macerata	MC	8761
IT	62012	Civitanova Marche Alta	Marche	Macerata	MC	8762
IT	62012	Fontespina	Marche	Macerata	MC	8763
IT	62012	Civitanova Marche	Marche	Macerata	MC	8764
IT	62012	Civitanova Alta	Marche	Macerata	MC	8765
IT	62014	Passo Del Bidollo	Marche	Macerata	MC	8766
IT	62014	Petriolo	Marche	Macerata	MC	8767
IT	62014	Corridonia	Marche	Macerata	MC	8768
IT	62014	Colbuccaro	Marche	Macerata	MC	8769
IT	62014	San Claudio	Marche	Macerata	MC	8770
IT	62015	Villa San Filippo	Marche	Macerata	MC	8771
IT	62015	Monte San Giusto	Marche	Macerata	MC	8772
IT	62017	Porto Recanati	Marche	Macerata	MC	8773
IT	62018	Porto Potenza Picena	Marche	Macerata	MC	8774
IT	62018	Potenza Picena	Marche	Macerata	MC	8775
IT	62019	Recanati	Marche	Macerata	MC	8776
IT	62019	Musone	Marche	Macerata	MC	8777
IT	62020	Sant'Angelo In Pontano	Marche	Macerata	MC	8778
IT	62020	Valcimarra	Marche	Macerata	MC	8779
IT	62020	Penna San Giovanni	Marche	Macerata	MC	8780
IT	62020	Camporotondo Di Fiastrone	Marche	Macerata	MC	8781
IT	62020	Caldarola	Marche	Macerata	MC	8782
IT	62020	Ripe San Ginesio	Marche	Macerata	MC	8783
IT	62020	Colmurano	Marche	Macerata	MC	8784
IT	62020	Monte San Martino	Marche	Macerata	MC	8785
IT	62020	Cessapalombo	Marche	Macerata	MC	8786
IT	62020	Loro Piceno	Marche	Macerata	MC	8787
IT	62020	Serrapetrona	Marche	Macerata	MC	8788
IT	62020	Belforte Del Chienti	Marche	Macerata	MC	8789
IT	62020	Gualdo	Marche	Macerata	MC	8790
IT	62021	Apiro	Marche	Macerata	MC	8791
IT	62021	Frontale	Marche	Macerata	MC	8792
IT	62021	Poggio San Vicino	Marche	Macerata	MC	8793
IT	62022	Castelraimondo	Marche	Macerata	MC	8794
IT	62022	Crispiero	Marche	Macerata	MC	8795
IT	62022	Gagliole	Marche	Macerata	MC	8796
IT	62024	Matelica	Marche	Macerata	MC	8797
IT	62024	Esanatoglia	Marche	Macerata	MC	8798
IT	62024	Colferraio	Marche	Macerata	MC	8799
IT	62025	Pioraco	Marche	Macerata	MC	8800
IT	62025	Fonte Di Brescia	Marche	Macerata	MC	8801
IT	62025	Massa	Marche	Macerata	MC	8802
IT	62025	Sefro	Marche	Macerata	MC	8803
IT	62025	Fiuminata	Marche	Macerata	MC	8804
IT	62025	Seppio	Marche	Macerata	MC	8805
IT	62026	Passo San Ginesio	Marche	Macerata	MC	8806
IT	62026	San Ginesio	Marche	Macerata	MC	8807
IT	62026	Pian Di Pieca	Marche	Macerata	MC	8808
IT	62027	Castel San Pietro	Marche	Macerata	MC	8809
IT	62027	San Severino Marche	Marche	Macerata	MC	8810
IT	62027	Cesolo	Marche	Macerata	MC	8811
IT	62028	Sarnano	Marche	Macerata	MC	8812
IT	62029	Tolentino	Marche	Macerata	MC	8813
IT	62032	San Luca	Marche	Macerata	MC	8814
IT	62032	Camerino	Marche	Macerata	MC	8815
IT	62032	Mergnano San Savino	Marche	Macerata	MC	8816
IT	62032	Polverina	Marche	Macerata	MC	8817
IT	62032	Morro	Marche	Macerata	MC	8818
IT	62032	Mergnano	Marche	Macerata	MC	8819
IT	62034	Muccia	Marche	Macerata	MC	8820
IT	62035	Fiastra	Marche	Macerata	MC	8821
IT	62035	Fiordimonte	Marche	Macerata	MC	8822
IT	62035	Pievebovigliana	Marche	Macerata	MC	8823
IT	62035	Bolognola	Marche	Macerata	MC	8824
IT	62035	Acquacanina	Marche	Macerata	MC	8825
IT	62035	Fiegni	Marche	Macerata	MC	8826
IT	62036	Pieve Torina	Marche	Macerata	MC	8827
IT	62036	Appennino	Marche	Macerata	MC	8828
IT	62036	Pie' Casavecchia	Marche	Macerata	MC	8829
IT	62036	Monte Cavallo	Marche	Macerata	MC	8830
IT	62036	Casavecchia	Marche	Macerata	MC	8831
IT	62038	Cesi	Marche	Macerata	MC	8832
IT	62038	Serravalle Di Chienti	Marche	Macerata	MC	8833
IT	62038	Cesi Di Macerata	Marche	Macerata	MC	8834
IT	62039	Fematre	Marche	Macerata	MC	8835
IT	62039	Ussita	Marche	Macerata	MC	8836
IT	62039	Castelsantangelo Sul Nera	Marche	Macerata	MC	8837
IT	62039	Visso	Marche	Macerata	MC	8838
IT	62100	Macerata	Marche	Macerata	MC	8839
IT	62100	Piediripa	Marche	Macerata	MC	8840
IT	62100	Madonna Del Monte	Marche	Macerata	MC	8841
IT	62100	Villa Potenza	Marche	Macerata	MC	8842
IT	62100	Corridonia Stazione	Marche	Macerata	MC	8843
IT	62100	Sforzacosta	Marche	Macerata	MC	8844
IT	61010	Padiglione	Marche	Pesaro E Urbino	PU	8845
IT	61010	Monte Cerignone	Marche	Pesaro E Urbino	PU	8846
IT	61010	Belvedere Fogliense	Marche	Pesaro E Urbino	PU	8847
IT	61010	Valle Di Teva	Marche	Pesaro E Urbino	PU	8848
IT	61010	Rio Salso	Marche	Pesaro E Urbino	PU	8849
IT	61010	Savignano Montetassi	Marche	Pesaro E Urbino	PU	8850
IT	61010	Case Bernardi	Marche	Pesaro E Urbino	PU	8851
IT	61010	Montegrimano	Marche	Pesaro E Urbino	PU	8852
IT	61010	Tavullia	Marche	Pesaro E Urbino	PU	8853
IT	61010	Montelicciano	Marche	Pesaro E Urbino	PU	8854
IT	61011	Gabicce Mare	Marche	Pesaro E Urbino	PU	8855
IT	61011	Case Badioli	Marche	Pesaro E Urbino	PU	8856
IT	61012	Gradara	Marche	Pesaro E Urbino	PU	8857
IT	61012	Fanano	Marche	Pesaro E Urbino	PU	8858
IT	61013	Valle Sant'Anastasio	Marche	Pesaro E Urbino	PU	8859
IT	61013	Sassofeltrio	Marche	Pesaro E Urbino	PU	8860
IT	61013	Piandicastello	Marche	Pesaro E Urbino	PU	8861
IT	61013	Mercatino Conca	Marche	Pesaro E Urbino	PU	8862
IT	61013	Fratte Di Sassofeltrio	Marche	Pesaro E Urbino	PU	8863
IT	61014	Montecopiolo	Marche	Pesaro E Urbino	PU	8864
IT	61014	Villagrande	Marche	Pesaro E Urbino	PU	8865
IT	61014	Madonna Di Pugliano	Marche	Pesaro E Urbino	PU	8866
IT	61020	Auditore	Marche	Pesaro E Urbino	PU	8867
IT	61020	Montecalvo In Foglia	Marche	Pesaro E Urbino	PU	8868
IT	61020	Petriano	Marche	Pesaro E Urbino	PU	8869
IT	61020	Tavoleto	Marche	Pesaro E Urbino	PU	8870
IT	61020	Borgo Massano	Marche	Pesaro E Urbino	PU	8871
IT	61020	Gallo	Marche	Pesaro E Urbino	PU	8872
IT	61020	Ca' Gallo	Marche	Pesaro E Urbino	PU	8873
IT	61020	Casinina	Marche	Pesaro E Urbino	PU	8874
IT	61020	Gallo Di Petriano	Marche	Pesaro E Urbino	PU	8875
IT	61021	Frontino	Marche	Pesaro E Urbino	PU	8876
IT	61021	Carpegna	Marche	Pesaro E Urbino	PU	8877
IT	61022	Morciola	Marche	Pesaro E Urbino	PU	8878
IT	61022	Colbordolo	Marche	Pesaro E Urbino	PU	8879
IT	61022	Montecchio	Marche	Pesaro E Urbino	PU	8880
IT	61022	Sant'Angelo In Lizzola	Marche	Pesaro E Urbino	PU	8881
IT	61022	Bottega	Marche	Pesaro E Urbino	PU	8882
IT	61022	Vallefoglia	Marche	Pesaro E Urbino	PU	8883
IT	61023	Pietrarubbia	Marche	Pesaro E Urbino	PU	8884
IT	61023	Macerata Feltria	Marche	Pesaro E Urbino	PU	8885
IT	61024	Monteciccardo	Marche	Pesaro E Urbino	PU	8886
IT	61024	Mombaroccio	Marche	Pesaro E Urbino	PU	8887
IT	61025	Osteria Nuova	Marche	Pesaro E Urbino	PU	8888
IT	61025	Montelabbate	Marche	Pesaro E Urbino	PU	8889
IT	61026	Monastero	Marche	Pesaro E Urbino	PU	8890
IT	61026	San Sisto	Marche	Pesaro E Urbino	PU	8891
IT	61026	Lunano	Marche	Pesaro E Urbino	PU	8892
IT	61026	Belforte All'Isauro	Marche	Pesaro E Urbino	PU	8893
IT	61026	Piandimeleto	Marche	Pesaro E Urbino	PU	8894
IT	61028	Caprazzino	Marche	Pesaro E Urbino	PU	8895
IT	61028	Mercatale	Marche	Pesaro E Urbino	PU	8896
IT	61028	Sassocorvaro	Marche	Pesaro E Urbino	PU	8897
IT	61029	Castello Di Cavallino	Marche	Pesaro E Urbino	PU	8898
IT	61029	Schieti	Marche	Pesaro E Urbino	PU	8899
IT	61029	Gadana	Marche	Pesaro E Urbino	PU	8900
IT	61029	Pieve Di Cagna	Marche	Pesaro E Urbino	PU	8901
IT	61029	Trasanni	Marche	Pesaro E Urbino	PU	8902
IT	61029	Via Piana	Marche	Pesaro E Urbino	PU	8903
IT	61029	Urbino	Marche	Pesaro E Urbino	PU	8904
IT	61029	Castelcavallino	Marche	Pesaro E Urbino	PU	8905
IT	61029	Canavaccio	Marche	Pesaro E Urbino	PU	8906
IT	61029	Ponte In Foglia	Marche	Pesaro E Urbino	PU	8907
IT	61030	Lucrezia	Marche	Pesaro E Urbino	PU	8908
IT	61030	Monteguiduccio	Marche	Pesaro E Urbino	PU	8909
IT	61030	Cartoceto	Marche	Pesaro E Urbino	PU	8910
IT	61030	Tavernelle	Marche	Pesaro E Urbino	PU	8911
IT	61030	Villanova	Marche	Pesaro E Urbino	PU	8912
IT	61030	Piagge	Marche	Pesaro E Urbino	PU	8913
IT	61030	Isola Del Piano	Marche	Pesaro E Urbino	PU	8914
IT	61030	San Giorgio Di Pesaro	Marche	Pesaro E Urbino	PU	8915
IT	61030	Montemaggiore Al Metauro	Marche	Pesaro E Urbino	PU	8916
IT	61030	Saltara	Marche	Pesaro E Urbino	PU	8917
IT	61030	Montefelcino	Marche	Pesaro E Urbino	PU	8918
IT	61030	Serrungarina	Marche	Pesaro E Urbino	PU	8919
IT	61030	Calcinelli	Marche	Pesaro E Urbino	PU	8920
IT	61032	Fano	Marche	Pesaro E Urbino	PU	8921
IT	61032	Cuccurano	Marche	Pesaro E Urbino	PU	8922
IT	61032	Bellocchi	Marche	Pesaro E Urbino	PU	8923
IT	61032	Fenile	Marche	Pesaro E Urbino	PU	8924
IT	61033	Fermignano	Marche	Pesaro E Urbino	PU	8925
IT	61034	Fossombrone	Marche	Pesaro E Urbino	PU	8926
IT	61034	Calmazzo	Marche	Pesaro E Urbino	PU	8927
IT	61034	Isola Di Fano	Marche	Pesaro E Urbino	PU	8928
IT	61037	Mondolfo	Marche	Pesaro E Urbino	PU	8929
IT	61037	Centocroci	Marche	Pesaro E Urbino	PU	8930
IT	61037	Marotta	Marche	Pesaro E Urbino	PU	8931
IT	61038	Orciano Di Pesaro	Marche	Pesaro E Urbino	PU	8932
IT	61039	Cerasa	Marche	Pesaro E Urbino	PU	8933
IT	61039	San Costanzo	Marche	Pesaro E Urbino	PU	8934
IT	61040	Monte Porzio	Marche	Pesaro E Urbino	PU	8935
IT	61040	Fratte Rosa	Marche	Pesaro E Urbino	PU	8936
IT	61040	Castelvecchio	Marche	Pesaro E Urbino	PU	8937
IT	61040	Lamoli	Marche	Pesaro E Urbino	PU	8938
IT	61040	San Michele Al Fiume	Marche	Pesaro E Urbino	PU	8939
IT	61040	Frontone	Marche	Pesaro E Urbino	PU	8940
IT	61040	Sant'Andrea Di Suasa	Marche	Pesaro E Urbino	PU	8941
IT	61040	Sorbolongo	Marche	Pesaro E Urbino	PU	8942
IT	61040	Sant'Ippolito	Marche	Pesaro E Urbino	PU	8943
IT	61040	Borgo Pace	Marche	Pesaro E Urbino	PU	8944
IT	61040	Serra Sant'Abbondio	Marche	Pesaro E Urbino	PU	8945
IT	61040	Mercatello Sul Metauro	Marche	Pesaro E Urbino	PU	8946
IT	61040	San Filippo Sul Cesano	Marche	Pesaro E Urbino	PU	8947
IT	61040	Mondavio	Marche	Pesaro E Urbino	PU	8948
IT	61040	Barchi	Marche	Pesaro E Urbino	PU	8949
IT	61041	Acqualagna	Marche	Pesaro E Urbino	PU	8950
IT	61041	Abbadia Di Naro	Marche	Pesaro E Urbino	PU	8951
IT	61041	Bellaria	Marche	Pesaro E Urbino	PU	8952
IT	61041	Furlo	Marche	Pesaro E Urbino	PU	8953
IT	61041	Pole	Marche	Pesaro E Urbino	PU	8954
IT	61041	Petriccio	Marche	Pesaro E Urbino	PU	8955
IT	61042	Serravalle Di Carda	Marche	Pesaro E Urbino	PU	8956
IT	61042	Apecchio	Marche	Pesaro E Urbino	PU	8957
IT	61043	Pianello	Marche	Pesaro E Urbino	PU	8958
IT	61043	Cagli	Marche	Pesaro E Urbino	PU	8959
IT	61043	Secchiano	Marche	Pesaro E Urbino	PU	8960
IT	61043	Smirra	Marche	Pesaro E Urbino	PU	8961
IT	61043	Acquaviva Marche	Marche	Pesaro E Urbino	PU	8962
IT	61044	Pontericcioli	Marche	Pesaro E Urbino	PU	8963
IT	61044	Cantiano	Marche	Pesaro E Urbino	PU	8964
IT	61044	Chiaserna	Marche	Pesaro E Urbino	PU	8965
IT	61045	Monterolo	Marche	Pesaro E Urbino	PU	8966
IT	61045	Bellisio Solfare	Marche	Pesaro E Urbino	PU	8967
IT	61045	Pergola	Marche	Pesaro E Urbino	PU	8968
IT	61046	Piobbico	Marche	Pesaro E Urbino	PU	8969
IT	61047	San Vito Sul Cesano	Marche	Pesaro E Urbino	PU	8970
IT	61047	San Lorenzo In Campo	Marche	Pesaro E Urbino	PU	8971
IT	61048	Sant'Angelo In Vado	Marche	Pesaro E Urbino	PU	8972
IT	61049	Urbania	Marche	Pesaro E Urbino	PU	8973
IT	61049	Muraglione	Marche	Pesaro E Urbino	PU	8974
IT	61100	Villa Ceccolini	Marche	Pesaro E Urbino	PU	8975
IT	61100	Candelara	Marche	Pesaro E Urbino	PU	8976
IT	61100	Novilara	Marche	Pesaro E Urbino	PU	8977
IT	61100	Case Bruciate	Marche	Pesaro E Urbino	PU	8978
IT	61100	Pozzo Alto	Marche	Pesaro E Urbino	PU	8979
IT	61100	Ginestreto	Marche	Pesaro E Urbino	PU	8980
IT	61100	Fiorenzuola Di Focara	Marche	Pesaro E Urbino	PU	8981
IT	61100	Borgo Santa Maria	Marche	Pesaro E Urbino	PU	8982
IT	61100	Pesaro	Marche	Pesaro E Urbino	PU	8983
IT	61100	Montegranaro	Marche	Pesaro E Urbino	PU	8984
IT	61100	Pantano	Marche	Pesaro E Urbino	PU	8985
IT	61100	Ponte Del Colombarone	Marche	Pesaro E Urbino	PU	8986
IT	61100	Santa Maria Delle Fabrecce	Marche	Pesaro E Urbino	PU	8987
IT	61100	Muraglia	Marche	Pesaro E Urbino	PU	8988
IT	61100	Villa San Martino	Marche	Pesaro E Urbino	PU	8989
IT	61100	Soria	Marche	Pesaro E Urbino	PU	8990
IT	61100	Santa Veneranda	Marche	Pesaro E Urbino	PU	8991
IT	61100	San Pietro In Calibano	Marche	Pesaro E Urbino	PU	8992
IT	61100	Cattabrighe	Marche	Pesaro E Urbino	PU	8993
IT	61100	Villa Fastiggi	Marche	Pesaro E Urbino	PU	8994
IT	61121	Pesaro	Marche	Pesaro E Urbino	PU	8995
IT	61122	Pesaro	Marche	Pesaro E Urbino	PU	8996
IT	86010	Oratino	Molise	Campobasso	CB	8997
IT	86010	Castropignano	Molise	Campobasso	CB	8998
IT	86010	Campodipietra	Molise	Campobasso	CB	8999
IT	86010	Cercepiccola	Molise	Campobasso	CB	9000
IT	86010	San Giovanni In Galdo	Molise	Campobasso	CB	9001
IT	86010	Gildone	Molise	Campobasso	CB	9002
IT	86010	San Giuliano Del Sannio	Molise	Campobasso	CB	9003
IT	86010	Roccaspromonte	Molise	Campobasso	CB	9004
IT	86010	Ferrazzano	Molise	Campobasso	CB	9005
IT	86010	Casalciprano	Molise	Campobasso	CB	9006
IT	86010	Mirabello Sannitico	Molise	Campobasso	CB	9007
IT	86010	Tufara	Molise	Campobasso	CB	9008
IT	86010	Busso	Molise	Campobasso	CB	9009
IT	86011	Baranello	Molise	Campobasso	CB	9010
IT	86012	Cercemaggiore	Molise	Campobasso	CB	9011
IT	86013	Gambatesa	Molise	Campobasso	CB	9012
IT	86014	Guardiaregia	Molise	Campobasso	CB	9013
IT	86015	Jelsi	Molise	Campobasso	CB	9014
IT	86016	Riccia	Molise	Campobasso	CB	9015
IT	86017	Sepino	Molise	Campobasso	CB	9016
IT	86018	Toro	Molise	Campobasso	CB	9017
IT	86019	Vinchiaturo	Molise	Campobasso	CB	9018
IT	86020	Molise	Molise	Campobasso	CB	9019
IT	86020	Spinete	Molise	Campobasso	CB	9020
IT	86020	San Biase	Molise	Campobasso	CB	9021
IT	86020	San Polo Matese	Molise	Campobasso	CB	9022
IT	86020	Campochiaro	Molise	Campobasso	CB	9023
IT	86020	Duronia	Molise	Campobasso	CB	9024
IT	86020	Castellino Del Biferno	Molise	Campobasso	CB	9025
IT	86020	Fossalto	Molise	Campobasso	CB	9026
IT	86020	Pietracupa	Molise	Campobasso	CB	9027
IT	86020	Roccavivara	Molise	Campobasso	CB	9028
IT	86020	Colle D'Anchise	Molise	Campobasso	CB	9029
IT	86020	Sant'Angelo Limosano	Molise	Campobasso	CB	9030
IT	86021	Bojano	Molise	Campobasso	CB	9031
IT	86021	Monteverde	Molise	Campobasso	CB	9032
IT	86021	Castellone Di Boiano	Molise	Campobasso	CB	9033
IT	86021	Castellone	Molise	Campobasso	CB	9034
IT	86021	Monteverde Di Boiano	Molise	Campobasso	CB	9035
IT	86022	Limosano	Molise	Campobasso	CB	9036
IT	86023	Montagano	Molise	Campobasso	CB	9037
IT	86024	Petrella Tifernina	Molise	Campobasso	CB	9038
IT	86025	Ripalimosani	Molise	Campobasso	CB	9039
IT	86026	Salcito	Molise	Campobasso	CB	9040
IT	86027	San Massimo	Molise	Campobasso	CB	9041
IT	86028	Torella Del Sannio	Molise	Campobasso	CB	9042
IT	86029	Trivento	Molise	Campobasso	CB	9043
IT	86030	Mafalda	Molise	Campobasso	CB	9044
IT	86030	Matrice	Molise	Campobasso	CB	9045
IT	86030	Lupara	Molise	Campobasso	CB	9046
IT	86030	Guardialfiera	Molise	Campobasso	CB	9047
IT	86030	Montemitro	Molise	Campobasso	CB	9048
IT	86030	Acquaviva Collecroce	Molise	Campobasso	CB	9049
IT	86030	San Felice Del Molise	Molise	Campobasso	CB	9050
IT	86030	Civitacampomarano	Molise	Campobasso	CB	9051
IT	86030	Lucito	Molise	Campobasso	CB	9052
IT	86030	Tavenna	Molise	Campobasso	CB	9053
IT	86030	San Giacomo Degli Schiavoni	Molise	Campobasso	CB	9054
IT	86030	Castelbottaccio	Molise	Campobasso	CB	9055
IT	86031	Castelmauro	Molise	Campobasso	CB	9056
IT	86032	Montecilfone	Molise	Campobasso	CB	9057
IT	86033	Montefalcone Nel Sannio	Molise	Campobasso	CB	9058
IT	86034	Guglionesi	Molise	Campobasso	CB	9059
IT	86035	Larino	Molise	Campobasso	CB	9060
IT	86036	Montenero Di Bisaccia	Molise	Campobasso	CB	9061
IT	86037	Palata	Molise	Campobasso	CB	9062
IT	86038	Petacciato	Molise	Campobasso	CB	9063
IT	86038	Collecalcioni	Molise	Campobasso	CB	9064
IT	86039	Termoli	Molise	Campobasso	CB	9065
IT	86040	Ripabottoni	Molise	Campobasso	CB	9066
IT	86040	Provvidenti	Molise	Campobasso	CB	9067
IT	86040	Monacilioni	Molise	Campobasso	CB	9068
IT	86040	San Giuliano Di Puglia	Molise	Campobasso	CB	9069
IT	86040	Montorio Nei Frentani	Molise	Campobasso	CB	9070
IT	86040	Campolieto	Molise	Campobasso	CB	9071
IT	86040	Montelongo	Molise	Campobasso	CB	9072
IT	86040	Macchia Valfortore	Molise	Campobasso	CB	9073
IT	86040	Rotello	Molise	Campobasso	CB	9074
IT	86040	Morrone Del Sannio	Molise	Campobasso	CB	9075
IT	86040	Ripabottoni Stazione	Molise	Campobasso	CB	9076
IT	86040	Pietracatella	Molise	Campobasso	CB	9077
IT	86041	Bonefro	Molise	Campobasso	CB	9078
IT	86042	Campomarino	Molise	Campobasso	CB	9079
IT	86042	Lido Di Campomarino	Molise	Campobasso	CB	9080
IT	86042	Nuova Cliternia	Molise	Campobasso	CB	9081
IT	86043	Casacalenda	Molise	Campobasso	CB	9082
IT	86044	Colletorto	Molise	Campobasso	CB	9083
IT	86045	Portocannone	Molise	Campobasso	CB	9084
IT	86046	San Martino In Pensilis	Molise	Campobasso	CB	9085
IT	86047	Santa Croce Di Magliano	Molise	Campobasso	CB	9086
IT	86048	Sant'Elia A Pianisi	Molise	Campobasso	CB	9087
IT	86049	Ururi	Molise	Campobasso	CB	9088
IT	86100	Campobasso	Molise	Campobasso	CB	9089
IT	86100	Santo Stefano	Molise	Campobasso	CB	9090
IT	86100	Santo Stefano Di Campobasso	Molise	Campobasso	CB	9091
IT	86070	Fornelli	Molise	Isernia	IS	9092
IT	86070	Macchia D'Isernia	Molise	Isernia	IS	9093
IT	86070	Taverna Ravindola	Molise	Isernia	IS	9094
IT	86070	Sant'Agapito	Molise	Isernia	IS	9095
IT	86070	Castelnuovo Al Volturno	Molise	Isernia	IS	9096
IT	86070	Roccaravindola	Molise	Isernia	IS	9097
IT	86070	Sant'Agapito Scalo	Molise	Isernia	IS	9098
IT	86070	Rocchetta Nuova	Molise	Isernia	IS	9099
IT	86070	Scapoli	Molise	Isernia	IS	9100
IT	86070	Conca Casale	Molise	Isernia	IS	9101
IT	86070	Rocchetta A Volturno	Molise	Isernia	IS	9102
IT	86070	Montaquila	Molise	Isernia	IS	9103
IT	86070	Roccaravindola Stazione	Molise	Isernia	IS	9104
IT	86071	Castel San Vincenzo	Molise	Isernia	IS	9105
IT	86071	Pizzone	Molise	Isernia	IS	9106
IT	86072	Cupone	Molise	Isernia	IS	9107
IT	86072	Cerro Al Volturno	Molise	Isernia	IS	9108
IT	86073	Colli A Volturno	Molise	Isernia	IS	9109
IT	86074	Filignano	Molise	Isernia	IS	9110
IT	86074	Cerasuolo	Molise	Isernia	IS	9111
IT	86075	Monteroduni	Molise	Isernia	IS	9112
IT	86075	Sant'Eusanio	Molise	Isernia	IS	9113
IT	86077	Pozzilli	Molise	Isernia	IS	9114
IT	86077	Santa Maria Oliveto	Molise	Isernia	IS	9115
IT	86078	Roccapipirozzi	Molise	Isernia	IS	9116
IT	86078	Campopino	Molise	Isernia	IS	9117
IT	86078	Pianura	Molise	Isernia	IS	9118
IT	86078	Sesto Campano	Molise	Isernia	IS	9119
IT	86078	Selvotta	Molise	Isernia	IS	9120
IT	86079	Ceppagna	Molise	Isernia	IS	9121
IT	86079	Venafro	Molise	Isernia	IS	9122
IT	86080	Belmonte Del Sannio	Molise	Isernia	IS	9123
IT	86080	Miranda	Molise	Isernia	IS	9124
IT	86080	Castel Del Giudice	Molise	Isernia	IS	9125
IT	86080	Sant'Angelo Del Pesco	Molise	Isernia	IS	9126
IT	86080	Montenero Val Cocchiara	Molise	Isernia	IS	9127
IT	86080	Acquaviva D'Isernia	Molise	Isernia	IS	9128
IT	86080	Castelverrino	Molise	Isernia	IS	9129
IT	86080	Pescopennataro	Molise	Isernia	IS	9130
IT	86080	Roccasicura	Molise	Isernia	IS	9131
IT	86081	Agnone	Molise	Isernia	IS	9132
IT	86081	Villa Canale	Molise	Isernia	IS	9133
IT	86082	Capracotta	Molise	Isernia	IS	9134
IT	86083	Carovilli	Molise	Isernia	IS	9135
IT	86083	Castiglione	Molise	Isernia	IS	9136
IT	86084	Vandra	Molise	Isernia	IS	9137
IT	86084	Forli' Del Sannio	Molise	Isernia	IS	9138
IT	86085	Pietrabbondante	Molise	Isernia	IS	9139
IT	86086	Poggio Sannita	Molise	Isernia	IS	9140
IT	86087	Rionero Sannitico	Molise	Isernia	IS	9141
IT	86088	San Pietro Avellana	Molise	Isernia	IS	9142
IT	86089	Vastogirardi	Molise	Isernia	IS	9143
IT	86089	Villa San Michele	Molise	Isernia	IS	9144
IT	86089	Cerreto	Molise	Isernia	IS	9145
IT	86090	Pettoranello Del Molise	Molise	Isernia	IS	9146
IT	86090	Pastena	Molise	Isernia	IS	9147
IT	86090	Pesche	Molise	Isernia	IS	9148
IT	86090	Castelpizzuto	Molise	Isernia	IS	9149
IT	86090	Longano	Molise	Isernia	IS	9150
IT	86090	Guasto	Molise	Isernia	IS	9151
IT	86090	Indiprete	Molise	Isernia	IS	9152
IT	86090	Castelpetroso	Molise	Isernia	IS	9153
IT	86091	Bagnoli Del Trigno	Molise	Isernia	IS	9154
IT	86092	Roccamandolfi	Molise	Isernia	IS	9155
IT	86092	Cantalupo Nel Sannio	Molise	Isernia	IS	9156
IT	86093	Carpinone	Molise	Isernia	IS	9157
IT	86094	Civitanova Del Sannio	Molise	Isernia	IS	9158
IT	86095	San Pietro In Valle	Molise	Isernia	IS	9159
IT	86095	Frosolone	Molise	Isernia	IS	9160
IT	86095	Sant'Elena Sannita	Molise	Isernia	IS	9161
IT	86096	Santa Maria Del Molise	Molise	Isernia	IS	9162
IT	86096	Incoronata	Molise	Isernia	IS	9163
IT	86096	Macchiagodena	Molise	Isernia	IS	9164
IT	86096	Sant'Angelo In Grotte	Molise	Isernia	IS	9165
IT	86097	Chiauci	Molise	Isernia	IS	9166
IT	86097	Pescolanciano	Molise	Isernia	IS	9167
IT	86097	Sessano Del Molise	Molise	Isernia	IS	9168
IT	86170	Castelromano	Molise	Isernia	IS	9169
IT	86170	Isernia	Molise	Isernia	IS	9170
IT	86170	Miranda	Molise	Isernia	IS	9171
IT	15010	Cremolino	Piemonte	Alessandria	AL	9172
IT	15010	Denice	Piemonte	Alessandria	AL	9173
IT	15010	Gamalero	Piemonte	Alessandria	AL	9174
IT	15010	Montechiaro D'Acqui	Piemonte	Alessandria	AL	9175
IT	15010	Terzo	Piemonte	Alessandria	AL	9176
IT	15010	Prasco	Piemonte	Alessandria	AL	9177
IT	15010	Visone	Piemonte	Alessandria	AL	9178
IT	15010	Ponzone	Piemonte	Alessandria	AL	9179
IT	15010	Morsasco	Piemonte	Alessandria	AL	9180
IT	15010	Cavatore	Piemonte	Alessandria	AL	9181
IT	15010	Montaldo Bormida	Piemonte	Alessandria	AL	9182
IT	15010	Rivalta Bormida	Piemonte	Alessandria	AL	9183
IT	15010	Frascaro	Piemonte	Alessandria	AL	9184
IT	15010	Alice Bel Colle	Piemonte	Alessandria	AL	9185
IT	15010	Orsara Bormida	Piemonte	Alessandria	AL	9186
IT	15010	Pareto	Piemonte	Alessandria	AL	9187
IT	15010	Melazzo	Piemonte	Alessandria	AL	9188
IT	15010	Ponti	Piemonte	Alessandria	AL	9189
IT	15010	Ricaldone	Piemonte	Alessandria	AL	9190
IT	15010	Grognardo	Piemonte	Alessandria	AL	9191
IT	15010	Merana	Piemonte	Alessandria	AL	9192
IT	15010	Morbello	Piemonte	Alessandria	AL	9193
IT	15010	Castelletto D'Erro	Piemonte	Alessandria	AL	9194
IT	15010	Montechiaro Denice	Piemonte	Alessandria	AL	9195
IT	15011	Acqui Terme	Piemonte	Alessandria	AL	9196
IT	15011	Moirano	Piemonte	Alessandria	AL	9197
IT	15012	Bistagno	Piemonte	Alessandria	AL	9198
IT	15013	Borgoratto Alessandrino	Piemonte	Alessandria	AL	9199
IT	15014	Cantalupo	Piemonte	Alessandria	AL	9200
IT	15015	Malvicino	Piemonte	Alessandria	AL	9201
IT	15015	Cartosio	Piemonte	Alessandria	AL	9202
IT	15016	Cassine	Piemonte	Alessandria	AL	9203
IT	15016	Gavonata	Piemonte	Alessandria	AL	9204
IT	15016	Caranzano	Piemonte	Alessandria	AL	9205
IT	15017	Castelnuovo Bormida	Piemonte	Alessandria	AL	9206
IT	15018	Spigno Monferrato	Piemonte	Alessandria	AL	9207
IT	15019	Strevi	Piemonte	Alessandria	AL	9208
IT	15020	Villadeati	Piemonte	Alessandria	AL	9209
IT	15020	Zanco	Piemonte	Alessandria	AL	9210
IT	15020	Ponzano Monferrato	Piemonte	Alessandria	AL	9211
IT	15020	Montalero	Piemonte	Alessandria	AL	9212
IT	15020	Gabiano	Piemonte	Alessandria	AL	9213
IT	15020	Valle Cerrina	Piemonte	Alessandria	AL	9214
IT	15020	Murisengo	Piemonte	Alessandria	AL	9215
IT	15020	Cantavenna	Piemonte	Alessandria	AL	9216
IT	15020	Varengo	Piemonte	Alessandria	AL	9217
IT	15020	Solonghello	Piemonte	Alessandria	AL	9218
IT	15020	San Giorgio	Piemonte	Alessandria	AL	9219
IT	15020	Serralunga Di Crea	Piemonte	Alessandria	AL	9220
IT	15020	Camino	Piemonte	Alessandria	AL	9221
IT	15020	Casalino Di Mombello	Piemonte	Alessandria	AL	9222
IT	15020	Moncestino	Piemonte	Alessandria	AL	9223
IT	15020	Odalengo Grande	Piemonte	Alessandria	AL	9224
IT	15020	Casalbagliano	Piemonte	Alessandria	AL	9225
IT	15020	Odalengo Piccolo	Piemonte	Alessandria	AL	9226
IT	15020	Brusaschetto	Piemonte	Alessandria	AL	9227
IT	15020	San Giorgio Monferrato	Piemonte	Alessandria	AL	9228
IT	15020	Vallegioliti	Piemonte	Alessandria	AL	9229
IT	15020	Villamiroglio	Piemonte	Alessandria	AL	9230
IT	15020	Castelletto Merli	Piemonte	Alessandria	AL	9231
IT	15020	Cereseto	Piemonte	Alessandria	AL	9232
IT	15020	Mombello Monferrato	Piemonte	Alessandria	AL	9233
IT	15020	Castel San Pietro	Piemonte	Alessandria	AL	9234
IT	15020	Pozzengo	Piemonte	Alessandria	AL	9235
IT	15020	Villa Del Foro	Piemonte	Alessandria	AL	9236
IT	15020	Lussello	Piemonte	Alessandria	AL	9237
IT	15020	Cerrina Monferrato	Piemonte	Alessandria	AL	9238
IT	15020	Castel San Pietro Monferrato	Piemonte	Alessandria	AL	9239
IT	15021	Sanico	Piemonte	Alessandria	AL	9240
IT	15021	Cardona	Piemonte	Alessandria	AL	9241
IT	15021	Alfiano Natta	Piemonte	Alessandria	AL	9242
IT	15022	Bergamasco	Piemonte	Alessandria	AL	9243
IT	15023	Felizzano	Piemonte	Alessandria	AL	9244
IT	15024	Masio	Piemonte	Alessandria	AL	9245
IT	15024	Abbazia	Piemonte	Alessandria	AL	9246
IT	15025	Morano Sul Po	Piemonte	Alessandria	AL	9247
IT	15026	Carentino	Piemonte	Alessandria	AL	9248
IT	15026	Oviglio	Piemonte	Alessandria	AL	9249
IT	15027	Pontestura	Piemonte	Alessandria	AL	9250
IT	15028	Quattordio	Piemonte	Alessandria	AL	9251
IT	15028	Piepasso	Piemonte	Alessandria	AL	9252
IT	15029	Solero	Piemonte	Alessandria	AL	9253
IT	15030	Treville	Piemonte	Alessandria	AL	9254
IT	15030	Conzano	Piemonte	Alessandria	AL	9255
IT	15030	Rosignano Monferrato	Piemonte	Alessandria	AL	9256
IT	15030	Camagna Monferrato	Piemonte	Alessandria	AL	9257
IT	15030	Villanova Monferrato	Piemonte	Alessandria	AL	9258
IT	15030	San Martino	Piemonte	Alessandria	AL	9259
IT	15030	Terruggia	Piemonte	Alessandria	AL	9260
IT	15030	Stevani	Piemonte	Alessandria	AL	9261
IT	15030	Olivola	Piemonte	Alessandria	AL	9262
IT	15030	Sala Monferrato	Piemonte	Alessandria	AL	9263
IT	15030	San Maurizio	Piemonte	Alessandria	AL	9264
IT	15030	Coniolo	Piemonte	Alessandria	AL	9265
IT	15031	Balzola	Piemonte	Alessandria	AL	9266
IT	15032	Borgo San Martino	Piemonte	Alessandria	AL	9267
IT	15033	Santa Maria Del Tempio	Piemonte	Alessandria	AL	9268
IT	15033	Terranova	Piemonte	Alessandria	AL	9269
IT	15033	Roncaglia	Piemonte	Alessandria	AL	9270
IT	15033	Terranova Monferrato	Piemonte	Alessandria	AL	9271
IT	15033	Casale Monferrato	Piemonte	Alessandria	AL	9272
IT	15033	San Germano	Piemonte	Alessandria	AL	9273
IT	15033	Popolo	Piemonte	Alessandria	AL	9274
IT	15033	Pozzo Sant'Evasio	Piemonte	Alessandria	AL	9275
IT	15034	Cella Monte	Piemonte	Alessandria	AL	9276
IT	15035	Frassinello Monferrato	Piemonte	Alessandria	AL	9277
IT	15036	Giarole	Piemonte	Alessandria	AL	9278
IT	15038	Ottiglio	Piemonte	Alessandria	AL	9279
IT	15039	Ozzano Monferrato	Piemonte	Alessandria	AL	9280
IT	15040	Pavone D'Alessandria	Piemonte	Alessandria	AL	9281
IT	15040	San Michele	Piemonte	Alessandria	AL	9282
IT	15040	Montecastello	Piemonte	Alessandria	AL	9283
IT	15040	Alluvioni Cambio'	Piemonte	Alessandria	AL	9284
IT	15040	Occimiano	Piemonte	Alessandria	AL	9285
IT	15040	Lu	Piemonte	Alessandria	AL	9286
IT	15040	Pomaro Monferrato	Piemonte	Alessandria	AL	9287
IT	15040	Cuccaro Monferrato	Piemonte	Alessandria	AL	9288
IT	15040	Pietra Marazzi	Piemonte	Alessandria	AL	9289
IT	15040	Mirabello Monferrato	Piemonte	Alessandria	AL	9290
IT	15040	Valle San Bartolomeo	Piemonte	Alessandria	AL	9291
IT	15040	Valmacca	Piemonte	Alessandria	AL	9292
IT	15040	Giardinetto	Piemonte	Alessandria	AL	9293
IT	15040	Grava	Piemonte	Alessandria	AL	9294
IT	15040	Frassineto Po	Piemonte	Alessandria	AL	9295
IT	15040	Bozzole	Piemonte	Alessandria	AL	9296
IT	15040	Rivarone	Piemonte	Alessandria	AL	9297
IT	15040	Ticineto	Piemonte	Alessandria	AL	9298
IT	15040	Piovera	Piemonte	Alessandria	AL	9299
IT	15040	Valmadonna	Piemonte	Alessandria	AL	9300
IT	15040	Pecetto Di Valenza	Piemonte	Alessandria	AL	9301
IT	15040	Castelletto Monferrato	Piemonte	Alessandria	AL	9302
IT	15041	Franchini	Piemonte	Alessandria	AL	9303
IT	15041	Altavilla Monferrato	Piemonte	Alessandria	AL	9304
IT	15042	Fiondi	Piemonte	Alessandria	AL	9305
IT	15042	Mugarone	Piemonte	Alessandria	AL	9306
IT	15042	Bassignana	Piemonte	Alessandria	AL	9307
IT	15043	Fubine	Piemonte	Alessandria	AL	9308
IT	15044	Quargnento	Piemonte	Alessandria	AL	9309
IT	15045	Sale	Piemonte	Alessandria	AL	9310
IT	15046	San Salvatore Monferrato	Piemonte	Alessandria	AL	9311
IT	15048	Monte	Piemonte	Alessandria	AL	9312
IT	15048	Villabella	Piemonte	Alessandria	AL	9313
IT	15048	Valenza	Piemonte	Alessandria	AL	9314
IT	15049	Vignale Monferrato	Piemonte	Alessandria	AL	9315
IT	15050	Sarezzano	Piemonte	Alessandria	AL	9316
IT	15050	Montacuto	Piemonte	Alessandria	AL	9317
IT	15050	Carbonara Scrivia	Piemonte	Alessandria	AL	9318
IT	15050	Isola Sant'Antonio	Piemonte	Alessandria	AL	9319
IT	15050	Guazzora	Piemonte	Alessandria	AL	9320
IT	15050	Montegioco	Piemonte	Alessandria	AL	9321
IT	15050	Pozzol Groppo	Piemonte	Alessandria	AL	9322
IT	15050	Cerreto Grue	Piemonte	Alessandria	AL	9323
IT	15050	Montemarzino	Piemonte	Alessandria	AL	9324
IT	15050	Avolasca	Piemonte	Alessandria	AL	9325
IT	15050	Sant'Agata Fossili	Piemonte	Alessandria	AL	9326
IT	15050	Castellar Guidobono	Piemonte	Alessandria	AL	9327
IT	15050	Villalvernia	Piemonte	Alessandria	AL	9328
IT	15050	Villaromagnano	Piemonte	Alessandria	AL	9329
IT	15050	Berzano Di Tortona	Piemonte	Alessandria	AL	9330
IT	15050	Momperone	Piemonte	Alessandria	AL	9331
IT	15050	Costa Vescovato	Piemonte	Alessandria	AL	9332
IT	15050	Volpeglino	Piemonte	Alessandria	AL	9333
IT	15050	Casasco	Piemonte	Alessandria	AL	9334
IT	15050	Garbagna	Piemonte	Alessandria	AL	9335
IT	15050	Spineto Scrivia	Piemonte	Alessandria	AL	9336
IT	15050	Paderna	Piemonte	Alessandria	AL	9337
IT	15050	Molino Dei Torti	Piemonte	Alessandria	AL	9338
IT	15050	Brignano Frascata	Piemonte	Alessandria	AL	9339
IT	15050	Alzano Scrivia	Piemonte	Alessandria	AL	9340
IT	15051	Castellania	Piemonte	Alessandria	AL	9341
IT	15051	Carezzano	Piemonte	Alessandria	AL	9342
IT	15052	Casalnoceto	Piemonte	Alessandria	AL	9343
IT	15053	Castelnuovo Scrivia	Piemonte	Alessandria	AL	9344
IT	15054	Garadassi	Piemonte	Alessandria	AL	9345
IT	15054	Caldirola	Piemonte	Alessandria	AL	9346
IT	15054	Fabbrica Curone	Piemonte	Alessandria	AL	9347
IT	15055	Pontecurone	Piemonte	Alessandria	AL	9348
IT	15056	Gremiasco	Piemonte	Alessandria	AL	9349
IT	15056	Dernice	Piemonte	Alessandria	AL	9350
IT	15056	San Sebastiano Curone	Piemonte	Alessandria	AL	9351
IT	15057	Rivalta Scrivia	Piemonte	Alessandria	AL	9352
IT	15057	Torre Garofoli	Piemonte	Alessandria	AL	9353
IT	15057	Tortona	Piemonte	Alessandria	AL	9354
IT	15057	Castellar Ponzano	Piemonte	Alessandria	AL	9355
IT	15057	Passalacqua	Piemonte	Alessandria	AL	9356
IT	15058	Viguzzolo	Piemonte	Alessandria	AL	9357
IT	15059	Volpedo	Piemonte	Alessandria	AL	9358
IT	15059	Monleale	Piemonte	Alessandria	AL	9359
IT	15060	Rocchetta Ligure	Piemonte	Alessandria	AL	9360
IT	15060	Grondona	Piemonte	Alessandria	AL	9361
IT	15060	Cantalupo Ligure	Piemonte	Alessandria	AL	9362
IT	15060	Borghetto Di Borbera	Piemonte	Alessandria	AL	9363
IT	15060	Roccaforte Ligure	Piemonte	Alessandria	AL	9364
IT	15060	Cuquello	Piemonte	Alessandria	AL	9365
IT	15060	Silvano D'Orba	Piemonte	Alessandria	AL	9366
IT	15060	San Cristoforo	Piemonte	Alessandria	AL	9367
IT	15060	Bosio	Piemonte	Alessandria	AL	9368
IT	15060	Albera Ligure	Piemonte	Alessandria	AL	9369
IT	15060	Stazzano	Piemonte	Alessandria	AL	9370
IT	15060	Tassarolo	Piemonte	Alessandria	AL	9371
IT	15060	Fraconalto	Piemonte	Alessandria	AL	9372
IT	15060	Francavilla Bisio	Piemonte	Alessandria	AL	9373
IT	15060	Carrosio	Piemonte	Alessandria	AL	9374
IT	15060	Mongiardino Ligure	Piemonte	Alessandria	AL	9375
IT	15060	Parodi Ligure	Piemonte	Alessandria	AL	9376
IT	15060	Vignole Borbera	Piemonte	Alessandria	AL	9377
IT	15060	Sardigliano	Piemonte	Alessandria	AL	9378
IT	15060	Castagnola Di Fraconalto	Piemonte	Alessandria	AL	9379
IT	15060	Castelletto D'Orba	Piemonte	Alessandria	AL	9380
IT	15060	Basaluzzo	Piemonte	Alessandria	AL	9381
IT	15060	Montaldeo	Piemonte	Alessandria	AL	9382
IT	15060	Voltaggio	Piemonte	Alessandria	AL	9383
IT	15060	Pasturana	Piemonte	Alessandria	AL	9384
IT	15060	Castagnola	Piemonte	Alessandria	AL	9385
IT	15060	Cosola Di Cabella	Piemonte	Alessandria	AL	9386
IT	15060	Carrega Ligure	Piemonte	Alessandria	AL	9387
IT	15060	Torre De' Ratti	Piemonte	Alessandria	AL	9388
IT	15060	Persi	Piemonte	Alessandria	AL	9389
IT	15060	Cabella Ligure	Piemonte	Alessandria	AL	9390
IT	15060	Capriata D'Orba	Piemonte	Alessandria	AL	9391
IT	15061	Arquata Scrivia	Piemonte	Alessandria	AL	9392
IT	15062	Pollastra	Piemonte	Alessandria	AL	9393
IT	15062	Bosco Marengo	Piemonte	Alessandria	AL	9394
IT	15062	Donna	Piemonte	Alessandria	AL	9395
IT	15063	Gavazzana	Piemonte	Alessandria	AL	9396
IT	15063	Cassano Spinola	Piemonte	Alessandria	AL	9397
IT	15064	Fresonara	Piemonte	Alessandria	AL	9398
IT	15065	Frugarolo	Piemonte	Alessandria	AL	9399
IT	15066	Gavi	Piemonte	Alessandria	AL	9400
IT	15067	Merella	Piemonte	Alessandria	AL	9401
IT	15067	Novi Ligure	Piemonte	Alessandria	AL	9402
IT	15068	Pozzolo Formigaro	Piemonte	Alessandria	AL	9403
IT	15069	Serravalle Scrivia	Piemonte	Alessandria	AL	9404
IT	15070	Castelspina	Piemonte	Alessandria	AL	9405
IT	15070	Mongiardino	Piemonte	Alessandria	AL	9406
IT	15070	Villa Botteri	Piemonte	Alessandria	AL	9407
IT	15070	Bandita	Piemonte	Alessandria	AL	9408
IT	15070	Lerma	Piemonte	Alessandria	AL	9409
IT	15070	Tagliolo Monferrato	Piemonte	Alessandria	AL	9410
IT	15070	Casaleggio Boiro	Piemonte	Alessandria	AL	9411
IT	15070	Belforte Monferrato	Piemonte	Alessandria	AL	9412
IT	15070	Trisobbio	Piemonte	Alessandria	AL	9413
IT	15070	Cassinelle	Piemonte	Alessandria	AL	9414
IT	15071	Carpeneto	Piemonte	Alessandria	AL	9415
IT	15072	Casal Cermelli	Piemonte	Alessandria	AL	9416
IT	15072	Portanova	Piemonte	Alessandria	AL	9417
IT	15073	Castellazzo Bormida	Piemonte	Alessandria	AL	9418
IT	15074	Molare	Piemonte	Alessandria	AL	9419
IT	15075	Mornese	Piemonte	Alessandria	AL	9420
IT	15076	Ovada	Piemonte	Alessandria	AL	9421
IT	15076	Gnocchetto	Piemonte	Alessandria	AL	9422
IT	15077	Castelferro	Piemonte	Alessandria	AL	9423
IT	15077	Predosa	Piemonte	Alessandria	AL	9424
IT	15078	Rocca Grimalda	Piemonte	Alessandria	AL	9425
IT	15079	Sezzadio	Piemonte	Alessandria	AL	9426
IT	15100	Spinetta Marengo	Piemonte	Alessandria	AL	9427
IT	15100	Lobbi	Piemonte	Alessandria	AL	9428
IT	15100	Castelceriolo	Piemonte	Alessandria	AL	9429
IT	15100	Mandrogne	Piemonte	Alessandria	AL	9430
IT	15100	San Giuliano Nuovo	Piemonte	Alessandria	AL	9431
IT	15100	Alessandria	Piemonte	Alessandria	AL	9432
IT	15100	Cascinagrossa	Piemonte	Alessandria	AL	9433
IT	15100	San Giuliano Vecchio	Piemonte	Alessandria	AL	9434
IT	15100	Orti	Piemonte	Alessandria	AL	9435
IT	15100	Litta Parodi	Piemonte	Alessandria	AL	9436
IT	15100	Cristo	Piemonte	Alessandria	AL	9437
IT	15121	Alessandria	Piemonte	Alessandria	AL	9438
IT	14010	Viale	Piemonte	Asti	AT	9439
IT	14010	Cortazzone	Piemonte	Asti	AT	9440
IT	14010	Cellarengo	Piemonte	Asti	AT	9441
IT	14010	San Matteo	Piemonte	Asti	AT	9442
IT	14010	Celle Enomondo	Piemonte	Asti	AT	9443
IT	14010	Revigliasco D'Asti	Piemonte	Asti	AT	9444
IT	14010	San Paolo Solbrito	Piemonte	Asti	AT	9445
IT	14010	Cisterna D'Asti	Piemonte	Asti	AT	9446
IT	14010	Dusino	Piemonte	Asti	AT	9447
IT	14010	Cantarana	Piemonte	Asti	AT	9448
IT	14010	San Martino Alfieri	Piemonte	Asti	AT	9449
IT	14010	Antignano	Piemonte	Asti	AT	9450
IT	14010	Dusino San Michele	Piemonte	Asti	AT	9451
IT	14010	Montegrosso Di Cinaglio	Piemonte	Asti	AT	9452
IT	14011	Baldichieri D'Asti	Piemonte	Asti	AT	9453
IT	14012	Ferrere	Piemonte	Asti	AT	9454
IT	14013	Castellero	Piemonte	Asti	AT	9455
IT	14013	Monale	Piemonte	Asti	AT	9456
IT	14013	Cortandone	Piemonte	Asti	AT	9457
IT	14014	Montafia	Piemonte	Asti	AT	9458
IT	14014	Capriglio	Piemonte	Asti	AT	9459
IT	14015	San Damiano D'Asti	Piemonte	Asti	AT	9460
IT	14015	San Pietro	Piemonte	Asti	AT	9461
IT	14016	Tigliole	Piemonte	Asti	AT	9462
IT	14016	Pratomorone	Piemonte	Asti	AT	9463
IT	14017	Valfenera	Piemonte	Asti	AT	9464
IT	14018	Roatto	Piemonte	Asti	AT	9465
IT	14018	Villafranca D'Asti	Piemonte	Asti	AT	9466
IT	14018	Maretto	Piemonte	Asti	AT	9467
IT	14019	Villanova D'Asti	Piemonte	Asti	AT	9468
IT	14019	Villanova D'Asti Stazione	Piemonte	Asti	AT	9469
IT	14020	Corsione	Piemonte	Asti	AT	9470
IT	14020	Settime	Piemonte	Asti	AT	9471
IT	14020	Marmorito	Piemonte	Asti	AT	9472
IT	14020	Cortanze	Piemonte	Asti	AT	9473
IT	14020	Pino D'Asti	Piemonte	Asti	AT	9474
IT	14020	Aramengo	Piemonte	Asti	AT	9475
IT	14020	Passerano	Piemonte	Asti	AT	9476
IT	14020	Passerano Marmorito	Piemonte	Asti	AT	9477
IT	14020	Berzano Di San Pietro	Piemonte	Asti	AT	9478
IT	14020	Cinaglio	Piemonte	Asti	AT	9479
IT	14020	Piea	Piemonte	Asti	AT	9480
IT	14020	Villa San Secondo	Piemonte	Asti	AT	9481
IT	14020	Cossombrato	Piemonte	Asti	AT	9482
IT	14020	Schierano	Piemonte	Asti	AT	9483
IT	14020	Soglio	Piemonte	Asti	AT	9484
IT	14020	Robella	Piemonte	Asti	AT	9485
IT	14020	Cerreto D'Asti	Piemonte	Asti	AT	9486
IT	14020	Camerano Casasco	Piemonte	Asti	AT	9487
IT	14020	Serravalle D'Asti	Piemonte	Asti	AT	9488
IT	14021	Buttigliera D'Asti	Piemonte	Asti	AT	9489
IT	14022	Castelnuovo Don Bosco	Piemonte	Asti	AT	9490
IT	14022	Albugnano	Piemonte	Asti	AT	9491
IT	14022	Becchi	Piemonte	Asti	AT	9492
IT	14022	Mondonio San Domenico Savio	Piemonte	Asti	AT	9493
IT	14023	Cocconito	Piemonte	Asti	AT	9494
IT	14023	Moransengo	Piemonte	Asti	AT	9495
IT	14023	Cocconato	Piemonte	Asti	AT	9496
IT	14023	Tonengo	Piemonte	Asti	AT	9497
IT	14023	Cocconito Vignaretto	Piemonte	Asti	AT	9498
IT	14024	Moncucco Torinese	Piemonte	Asti	AT	9499
IT	14025	Chiusano D'Asti	Piemonte	Asti	AT	9500
IT	14025	Montechiaro D'Asti	Piemonte	Asti	AT	9501
IT	14026	Piova' Massaia	Piemonte	Asti	AT	9502
IT	14026	Scandeluzza	Piemonte	Asti	AT	9503
IT	14026	Cunico	Piemonte	Asti	AT	9504
IT	14026	Montiglio	Piemonte	Asti	AT	9505
IT	14026	Colcavagno	Piemonte	Asti	AT	9506
IT	14026	Montiglio Monferrato	Piemonte	Asti	AT	9507
IT	14030	Rocchetta Tanaro	Piemonte	Asti	AT	9508
IT	14030	Azzano D'Asti	Piemonte	Asti	AT	9509
IT	14030	Cerro Tanaro	Piemonte	Asti	AT	9510
IT	14030	Refrancore	Piemonte	Asti	AT	9511
IT	14030	Scurzolengo	Piemonte	Asti	AT	9512
IT	14030	Frinco	Piemonte	Asti	AT	9513
IT	14030	Viarigi	Piemonte	Asti	AT	9514
IT	14030	Montemagno	Piemonte	Asti	AT	9515
IT	14030	Rocca D'Arazzo	Piemonte	Asti	AT	9516
IT	14030	Castagnole Monferrato	Piemonte	Asti	AT	9517
IT	14030	Penango	Piemonte	Asti	AT	9518
IT	14030	Valenzani	Piemonte	Asti	AT	9519
IT	14030	Accorneri	Piemonte	Asti	AT	9520
IT	14031	San Desiderio	Piemonte	Asti	AT	9521
IT	14031	Grana	Piemonte	Asti	AT	9522
IT	14031	Calliano	Piemonte	Asti	AT	9523
IT	14032	Casorzo	Piemonte	Asti	AT	9524
IT	14033	Callianetto	Piemonte	Asti	AT	9525
IT	14033	Castell'Alfero	Piemonte	Asti	AT	9526
IT	14033	Castell'Alfero Stazione	Piemonte	Asti	AT	9527
IT	14034	Castello Di Annone	Piemonte	Asti	AT	9528
IT	14034	Monfallito	Piemonte	Asti	AT	9529
IT	14035	Grazzano Badoglio	Piemonte	Asti	AT	9530
IT	14036	Moncalvo	Piemonte	Asti	AT	9531
IT	14037	Portacomaro	Piemonte	Asti	AT	9532
IT	14037	Migliandolo	Piemonte	Asti	AT	9533
IT	14037	Castiglione D'Asti	Piemonte	Asti	AT	9534
IT	14039	Tonco	Piemonte	Asti	AT	9535
IT	14040	Castelletto Molina	Piemonte	Asti	AT	9536
IT	14040	Vinchio	Piemonte	Asti	AT	9537
IT	14040	Vigliano D'Asti	Piemonte	Asti	AT	9538
IT	14040	Cortiglione	Piemonte	Asti	AT	9539
IT	14040	Maranzana	Piemonte	Asti	AT	9540
IT	14040	Castel Boglione	Piemonte	Asti	AT	9541
IT	14040	Mongardino	Piemonte	Asti	AT	9542
IT	14040	Montabone	Piemonte	Asti	AT	9543
IT	14040	Castelnuovo Calcea	Piemonte	Asti	AT	9544
IT	14040	Belveglio	Piemonte	Asti	AT	9545
IT	14040	Quaranti	Piemonte	Asti	AT	9546
IT	14041	Agliano	Piemonte	Asti	AT	9547
IT	14041	Agliano Terme	Piemonte	Asti	AT	9548
IT	14042	Calamandrana	Piemonte	Asti	AT	9549
IT	14042	Rocchetta Palafea	Piemonte	Asti	AT	9550
IT	14043	Castelnuovo Belbo	Piemonte	Asti	AT	9551
IT	14044	Castel Rocchero	Piemonte	Asti	AT	9552
IT	14044	Fontanile	Piemonte	Asti	AT	9553
IT	14045	Incisa Scapaccino	Piemonte	Asti	AT	9554
IT	14045	Ghiare	Piemonte	Asti	AT	9555
IT	14045	Madonna	Piemonte	Asti	AT	9556
IT	14046	Mombaruzzo	Piemonte	Asti	AT	9557
IT	14046	Bruno	Piemonte	Asti	AT	9558
IT	14046	Bazzana	Piemonte	Asti	AT	9559
IT	14047	Mombercelli	Piemonte	Asti	AT	9560
IT	14048	Montegrosso D'Asti Stazione	Piemonte	Asti	AT	9561
IT	14048	Montegrosso D'Asti	Piemonte	Asti	AT	9562
IT	14048	Montaldo Scarampi	Piemonte	Asti	AT	9563
IT	14049	Vaglio Serra	Piemonte	Asti	AT	9564
IT	14049	Nizza Monferrato	Piemonte	Asti	AT	9565
IT	14050	San Marzano Oliveto	Piemonte	Asti	AT	9566
IT	14050	Serole	Piemonte	Asti	AT	9567
IT	14050	Cassinasco	Piemonte	Asti	AT	9568
IT	14050	Moasca	Piemonte	Asti	AT	9569
IT	14050	Motta Di Costigliole	Piemonte	Asti	AT	9570
IT	14050	Olmo Gentile	Piemonte	Asti	AT	9571
IT	14050	Cessole	Piemonte	Asti	AT	9572
IT	14050	Roccaverano	Piemonte	Asti	AT	9573
IT	14050	Mombaldone	Piemonte	Asti	AT	9574
IT	14051	Loazzolo	Piemonte	Asti	AT	9575
IT	14051	Bubbio	Piemonte	Asti	AT	9576
IT	14052	Calosso	Piemonte	Asti	AT	9577
IT	14053	Canelli	Piemonte	Asti	AT	9578
IT	14053	Sant'Antonio	Piemonte	Asti	AT	9579
IT	14053	Canelli Recapito Gancia	Piemonte	Asti	AT	9580
IT	14053	Sant'Antonio Di Canelli	Piemonte	Asti	AT	9581
IT	14054	Castagnole Delle Lanze	Piemonte	Asti	AT	9582
IT	14054	Coazzolo	Piemonte	Asti	AT	9583
IT	14054	San Bartolomeo Lanze	Piemonte	Asti	AT	9584
IT	14054	Olmo Di Castagnole Lanze	Piemonte	Asti	AT	9585
IT	14054	Olmo	Piemonte	Asti	AT	9586
IT	14055	Boglietto	Piemonte	Asti	AT	9587
IT	14055	Motta	Piemonte	Asti	AT	9588
IT	14055	Costigliole D'Asti	Piemonte	Asti	AT	9589
IT	14057	Isola D'Asti	Piemonte	Asti	AT	9590
IT	14057	Molini D'Isola	Piemonte	Asti	AT	9591
IT	14057	Piano	Piemonte	Asti	AT	9592
IT	14058	Monastero Bormida	Piemonte	Asti	AT	9593
IT	14058	Sessame	Piemonte	Asti	AT	9594
IT	14059	Vesime	Piemonte	Asti	AT	9595
IT	14059	San Giorgio Scarampi	Piemonte	Asti	AT	9596
IT	14100	Vaglierano	Piemonte	Asti	AT	9597
IT	14100	Montemarzo	Piemonte	Asti	AT	9598
IT	14100	Sessant	Piemonte	Asti	AT	9599
IT	14100	Asti	Piemonte	Asti	AT	9600
IT	14100	Casabianca	Piemonte	Asti	AT	9601
IT	14100	San Marzanotto	Piemonte	Asti	AT	9602
IT	14100	Serravalle	Piemonte	Asti	AT	9603
IT	14100	Viatosto	Piemonte	Asti	AT	9604
IT	14100	Quarto D'Asti	Piemonte	Asti	AT	9605
IT	14100	Mombarone	Piemonte	Asti	AT	9606
IT	14100	Castiglione	Piemonte	Asti	AT	9607
IT	14100	Revignano	Piemonte	Asti	AT	9608
IT	14100	Valleandona	Piemonte	Asti	AT	9609
IT	14100	Portacomaro Stazione	Piemonte	Asti	AT	9610
IT	14100	Stazione Di Portacomaro	Piemonte	Asti	AT	9611
IT	14100	Montegrosso	Piemonte	Asti	AT	9612
IT	14100	Valgera	Piemonte	Asti	AT	9613
IT	14100	Variglie	Piemonte	Asti	AT	9614
IT	14100	Valletanaro	Piemonte	Asti	AT	9615
IT	14100	Montemarzo D'Asti	Piemonte	Asti	AT	9616
IT	14100	Poggio D'Asti	Piemonte	Asti	AT	9617
IT	13811	Tavigliano	Piemonte	Biella	BI	9618
IT	13811	Andorno Micca	Piemonte	Biella	BI	9619
IT	13812	Piedicavallo	Piemonte	Biella	BI	9620
IT	13812	Campiglia Cervo	Piemonte	Biella	BI	9621
IT	13812	San Paolo Cervo	Piemonte	Biella	BI	9622
IT	13812	Montesinaro	Piemonte	Biella	BI	9623
IT	13812	Quittengo	Piemonte	Biella	BI	9624
IT	13812	Balma	Piemonte	Biella	BI	9625
IT	13812	Balma Biellese	Piemonte	Biella	BI	9626
IT	13814	Pollone	Piemonte	Biella	BI	9627
IT	13815	Rosazza	Piemonte	Biella	BI	9628
IT	13816	Sagliano Micca	Piemonte	Biella	BI	9629
IT	13816	Miagliano	Piemonte	Biella	BI	9630
IT	13817	Sordevolo	Piemonte	Biella	BI	9631
IT	13818	Tollegno	Piemonte	Biella	BI	9632
IT	13821	Pianezze	Piemonte	Biella	BI	9633
IT	13821	Camandona	Piemonte	Biella	BI	9634
IT	13821	Callabiana	Piemonte	Biella	BI	9635
IT	13822	Mosso	Piemonte	Biella	BI	9636
IT	13822	Pistolesa	Piemonte	Biella	BI	9637
IT	13823	Strona	Piemonte	Biella	BI	9638
IT	13823	Fontanella Ozino	Piemonte	Biella	BI	9639
IT	13824	Veglio	Piemonte	Biella	BI	9640
IT	13825	Valle Mosso	Piemonte	Biella	BI	9641
IT	13825	Crocemosso	Piemonte	Biella	BI	9642
IT	13825	Campore	Piemonte	Biella	BI	9643
IT	13831	Mezzana Mortigliengo	Piemonte	Biella	BI	9644
IT	13833	Portula	Piemonte	Biella	BI	9645
IT	13834	Soprana	Piemonte	Biella	BI	9646
IT	13835	Trivero	Piemonte	Biella	BI	9647
IT	13835	Giardino	Piemonte	Biella	BI	9648
IT	13835	Botto	Piemonte	Biella	BI	9649
IT	13835	Pratrivero	Piemonte	Biella	BI	9650
IT	13835	Bulliana	Piemonte	Biella	BI	9651
IT	13835	Ponzone	Piemonte	Biella	BI	9652
IT	13835	Vico	Piemonte	Biella	BI	9653
IT	13836	Cossato	Piemonte	Biella	BI	9654
IT	13836	Castellengo	Piemonte	Biella	BI	9655
IT	13836	Ponte Guelpa	Piemonte	Biella	BI	9656
IT	13836	Aglietti	Piemonte	Biella	BI	9657
IT	13841	Bioglio	Piemonte	Biella	BI	9658
IT	13841	Selve Marcone	Piemonte	Biella	BI	9659
IT	13843	Vaglio	Piemonte	Biella	BI	9660
IT	13843	Pettinengo	Piemonte	Biella	BI	9661
IT	13844	Piatto	Piemonte	Biella	BI	9662
IT	13844	Ternengo	Piemonte	Biella	BI	9663
IT	13845	Ronco Biellese	Piemonte	Biella	BI	9664
IT	13847	Vallanzengo	Piemonte	Biella	BI	9665
IT	13847	Valle San Nicolao	Piemonte	Biella	BI	9666
IT	13848	Zumaglia	Piemonte	Biella	BI	9667
IT	13851	Castelletto Cervo	Piemonte	Biella	BI	9668
IT	13852	Cerreto Castello	Piemonte	Biella	BI	9669
IT	13853	Capovilla	Piemonte	Biella	BI	9670
IT	13853	Lessona	Piemonte	Biella	BI	9671
IT	13853	Castello	Piemonte	Biella	BI	9672
IT	13853	Crosa	Piemonte	Biella	BI	9673
IT	13854	Quaregna	Piemonte	Biella	BI	9674
IT	13855	Valdengo	Piemonte	Biella	BI	9675
IT	13856	Vigliano Biellese	Piemonte	Biella	BI	9676
IT	13856	Villaggi	Piemonte	Biella	BI	9677
IT	13861	Ailoche	Piemonte	Biella	BI	9678
IT	13862	Brusnengo	Piemonte	Biella	BI	9679
IT	13863	Coggiola	Piemonte	Biella	BI	9680
IT	13864	Caprile	Piemonte	Biella	BI	9681
IT	13864	Crevacuore	Piemonte	Biella	BI	9682
IT	13865	Curino	Piemonte	Biella	BI	9683
IT	13866	Masserano	Piemonte	Biella	BI	9684
IT	13866	Casapinta	Piemonte	Biella	BI	9685
IT	13867	Flecchia	Piemonte	Biella	BI	9686
IT	13867	Pray	Piemonte	Biella	BI	9687
IT	13867	Pianceri Alto	Piemonte	Biella	BI	9688
IT	13868	Villa Del Bosco	Piemonte	Biella	BI	9689
IT	13868	Sostegno	Piemonte	Biella	BI	9690
IT	13871	Benna	Piemonte	Biella	BI	9691
IT	13871	Verrone	Piemonte	Biella	BI	9692
IT	13872	Borriana	Piemonte	Biella	BI	9693
IT	13873	Massazza	Piemonte	Biella	BI	9694
IT	13874	Mottalciata	Piemonte	Biella	BI	9695
IT	13874	Gifflenga	Piemonte	Biella	BI	9696
IT	13875	Ponderano	Piemonte	Biella	BI	9697
IT	13876	Sandigliano	Piemonte	Biella	BI	9698
IT	13877	Villanova Biellese	Piemonte	Biella	BI	9699
IT	13878	Candelo	Piemonte	Biella	BI	9700
IT	13881	Dorzano	Piemonte	Biella	BI	9701
IT	13881	Cavaglia'	Piemonte	Biella	BI	9702
IT	13882	Cerrione	Piemonte	Biella	BI	9703
IT	13882	Magnonevolo	Piemonte	Biella	BI	9704
IT	13882	Vergnasco	Piemonte	Biella	BI	9705
IT	13883	Roppolo	Piemonte	Biella	BI	9706
IT	13884	Sala Biellese	Piemonte	Biella	BI	9707
IT	13884	Torrazzo	Piemonte	Biella	BI	9708
IT	13885	Salussola	Piemonte	Biella	BI	9709
IT	13885	Vigellio	Piemonte	Biella	BI	9710
IT	13885	Brianco	Piemonte	Biella	BI	9711
IT	13886	Viverone	Piemonte	Biella	BI	9712
IT	13887	Zimone	Piemonte	Biella	BI	9713
IT	13887	Magnano	Piemonte	Biella	BI	9714
IT	13888	Zubiena	Piemonte	Biella	BI	9715
IT	13888	Mongrando	Piemonte	Biella	BI	9716
IT	13888	Ceresane	Piemonte	Biella	BI	9717
IT	13888	Curanuova	Piemonte	Biella	BI	9718
IT	13891	Camburzano	Piemonte	Biella	BI	9719
IT	13893	Donato	Piemonte	Biella	BI	9720
IT	13894	Gaglianico	Piemonte	Biella	BI	9721
IT	13895	Muzzano	Piemonte	Biella	BI	9722
IT	13895	Graglia	Piemonte	Biella	BI	9723
IT	13895	Graglia Santuario	Piemonte	Biella	BI	9724
IT	13895	Graglia Bagni	Piemonte	Biella	BI	9725
IT	13896	Netro	Piemonte	Biella	BI	9726
IT	13897	Occhieppo Inferiore	Piemonte	Biella	BI	9727
IT	13898	Occhieppo Superiore	Piemonte	Biella	BI	9728
IT	13899	Pralungo	Piemonte	Biella	BI	9729
IT	13900	Biella	Piemonte	Biella	BI	9730
IT	13900	Oropa	Piemonte	Biella	BI	9731
IT	13900	Chiavazza	Piemonte	Biella	BI	9732
IT	13900	Favaro	Piemonte	Biella	BI	9733
IT	13900	Barazzetto	Piemonte	Biella	BI	9734
IT	13900	Pavignano	Piemonte	Biella	BI	9735
IT	13900	Vandorno	Piemonte	Biella	BI	9736
IT	13900	Cossila	Piemonte	Biella	BI	9737
IT	12010	San Rocco Di Bernezzo	Piemonte	Cuneo	CN	9738
IT	12010	San Defendente	Piemonte	Cuneo	CN	9739
IT	12010	Bersezio	Piemonte	Cuneo	CN	9740
IT	12010	Sant'Anna	Piemonte	Cuneo	CN	9741
IT	12010	Moiola	Piemonte	Cuneo	CN	9742
IT	12010	Valloriate	Piemonte	Cuneo	CN	9743
IT	12010	Vignolo	Piemonte	Cuneo	CN	9744
IT	12010	Roccasparvera	Piemonte	Cuneo	CN	9745
IT	12010	Vinadio	Piemonte	Cuneo	CN	9746
IT	12010	Entracque	Piemonte	Cuneo	CN	9747
IT	12010	Gaiola	Piemonte	Cuneo	CN	9748
IT	12010	Rittana	Piemonte	Cuneo	CN	9749
IT	12010	Aisone	Piemonte	Cuneo	CN	9750
IT	12010	Roaschia	Piemonte	Cuneo	CN	9751
IT	12010	Santa Croce	Piemonte	Cuneo	CN	9752
IT	12010	Valdieri	Piemonte	Cuneo	CN	9753
IT	12010	Sant'Anna Di Valdieri	Piemonte	Cuneo	CN	9754
IT	12010	Pietraporzio	Piemonte	Cuneo	CN	9755
IT	12010	Argentera	Piemonte	Cuneo	CN	9756
IT	12010	Bernezzo	Piemonte	Cuneo	CN	9757
IT	12010	Bagni Di Vinadio	Piemonte	Cuneo	CN	9758
IT	12010	Pianche	Piemonte	Cuneo	CN	9759
IT	12010	Santa Croce Cervasca	Piemonte	Cuneo	CN	9760
IT	12010	Cervasca	Piemonte	Cuneo	CN	9761
IT	12010	Andonno	Piemonte	Cuneo	CN	9762
IT	12010	Sambuco	Piemonte	Cuneo	CN	9763
IT	12011	Martinetto Del Rame	Piemonte	Cuneo	CN	9764
IT	12011	Borgo San Dalmazzo	Piemonte	Cuneo	CN	9765
IT	12011	Aradolo La Bruna	Piemonte	Cuneo	CN	9766
IT	12012	Mellana	Piemonte	Cuneo	CN	9767
IT	12012	San Giacomo	Piemonte	Cuneo	CN	9768
IT	12012	Boves	Piemonte	Cuneo	CN	9769
IT	12012	San Giacomo Di Boves	Piemonte	Cuneo	CN	9770
IT	12012	Rivoira	Piemonte	Cuneo	CN	9771
IT	12012	Fontanelle	Piemonte	Cuneo	CN	9772
IT	12012	Cerati	Piemonte	Cuneo	CN	9773
IT	12013	San Bartolomeo	Piemonte	Cuneo	CN	9774
IT	12013	Chiusa Di Pesio	Piemonte	Cuneo	CN	9775
IT	12014	Demonte	Piemonte	Cuneo	CN	9776
IT	12014	Festiona	Piemonte	Cuneo	CN	9777
IT	12015	Limone Piemonte	Piemonte	Cuneo	CN	9778
IT	12016	Peveragno	Piemonte	Cuneo	CN	9779
IT	12016	San Lorenzo Peveragno	Piemonte	Cuneo	CN	9780
IT	12016	Santa Margherita	Piemonte	Cuneo	CN	9781
IT	12017	Robilante	Piemonte	Cuneo	CN	9782
IT	12018	Brignola Sottana	Piemonte	Cuneo	CN	9783
IT	12018	Roccavione	Piemonte	Cuneo	CN	9784
IT	12018	Brignola	Piemonte	Cuneo	CN	9785
IT	12019	Vernante	Piemonte	Cuneo	CN	9786
IT	12020	Villafalletto	Piemonte	Cuneo	CN	9787
IT	12020	Rore	Piemonte	Cuneo	CN	9788
IT	12020	Brossasco	Piemonte	Cuneo	CN	9789
IT	12020	Villa San Pietro	Piemonte	Cuneo	CN	9790
IT	12020	Vottignasco	Piemonte	Cuneo	CN	9791
IT	12020	Villar San Costanzo	Piemonte	Cuneo	CN	9792
IT	12020	Sampeyre	Piemonte	Cuneo	CN	9793
IT	12020	San Pietro Monterosso	Piemonte	Cuneo	CN	9794
IT	12020	Villar Sampeyre	Piemonte	Cuneo	CN	9795
IT	12020	Valgrana	Piemonte	Cuneo	CN	9796
IT	12020	Stroppo	Piemonte	Cuneo	CN	9797
IT	12020	Marmora	Piemonte	Cuneo	CN	9798
IT	12020	Valmala	Piemonte	Cuneo	CN	9799
IT	12020	Lemma	Piemonte	Cuneo	CN	9800
IT	12020	Roccabruna	Piemonte	Cuneo	CN	9801
IT	12020	Macra	Piemonte	Cuneo	CN	9802
IT	12020	Frassino	Piemonte	Cuneo	CN	9803
IT	12020	Pontechianale	Piemonte	Cuneo	CN	9804
IT	12020	Monterosso Grana	Piemonte	Cuneo	CN	9805
IT	12020	Rossana	Piemonte	Cuneo	CN	9806
IT	12020	Venasca	Piemonte	Cuneo	CN	9807
IT	12020	Tarantasca	Piemonte	Cuneo	CN	9808
IT	12020	Canosio	Piemonte	Cuneo	CN	9809
IT	12020	Elva	Piemonte	Cuneo	CN	9810
IT	12020	Melle	Piemonte	Cuneo	CN	9811
IT	12020	Casteldelfino	Piemonte	Cuneo	CN	9812
IT	12020	Cartignano	Piemonte	Cuneo	CN	9813
IT	12020	Monsola	Piemonte	Cuneo	CN	9814
IT	12020	Castelmagno	Piemonte	Cuneo	CN	9815
IT	12020	Villar	Piemonte	Cuneo	CN	9816
IT	12020	Bellino	Piemonte	Cuneo	CN	9817
IT	12020	Isasca	Piemonte	Cuneo	CN	9818
IT	12020	Celle Di Macra	Piemonte	Cuneo	CN	9819
IT	12021	Acceglio	Piemonte	Cuneo	CN	9820
IT	12022	San Chiaffredo	Piemonte	Cuneo	CN	9821
IT	12022	Busca	Piemonte	Cuneo	CN	9822
IT	12022	Castelletto Busca	Piemonte	Cuneo	CN	9823
IT	12023	Caraglio	Piemonte	Cuneo	CN	9824
IT	12024	Costigliole Saluzzo	Piemonte	Cuneo	CN	9825
IT	12025	Dronero	Piemonte	Cuneo	CN	9826
IT	12025	Montemale Di Cuneo	Piemonte	Cuneo	CN	9827
IT	12026	Piasco	Piemonte	Cuneo	CN	9828
IT	12027	Pradleves	Piemonte	Cuneo	CN	9829
IT	12028	Prazzo	Piemonte	Cuneo	CN	9830
IT	12028	San Michele Prazzo	Piemonte	Cuneo	CN	9831
IT	12029	San Damiano Macra	Piemonte	Cuneo	CN	9832
IT	12029	Lottulo	Piemonte	Cuneo	CN	9833
IT	12030	Villanova Solaro	Piemonte	Cuneo	CN	9834
IT	12030	Caramagna Piemonte	Piemonte	Cuneo	CN	9835
IT	12030	Monasterolo Di Savigliano	Piemonte	Cuneo	CN	9836
IT	12030	Crissolo	Piemonte	Cuneo	CN	9837
IT	12030	Cavallermaggiore	Piemonte	Cuneo	CN	9838
IT	12030	Manta	Piemonte	Cuneo	CN	9839
IT	12030	Murello	Piemonte	Cuneo	CN	9840
IT	12030	Rifreddo Di Saluzzo	Piemonte	Cuneo	CN	9841
IT	12030	Martiniana Po	Piemonte	Cuneo	CN	9842
IT	12030	Casalgrasso	Piemonte	Cuneo	CN	9843
IT	12030	Faule	Piemonte	Cuneo	CN	9844
IT	12030	Madonna Del Pilone	Piemonte	Cuneo	CN	9845
IT	12030	Cavallerleone	Piemonte	Cuneo	CN	9846
IT	12030	Rifreddo	Piemonte	Cuneo	CN	9847
IT	12030	Oncino	Piemonte	Cuneo	CN	9848
IT	12030	Torre San Giorgio	Piemonte	Cuneo	CN	9849
IT	12030	Polonghera	Piemonte	Cuneo	CN	9850
IT	12030	Marene	Piemonte	Cuneo	CN	9851
IT	12030	Carde'	Piemonte	Cuneo	CN	9852
IT	12030	Castellar	Piemonte	Cuneo	CN	9853
IT	12030	Envie	Piemonte	Cuneo	CN	9854
IT	12030	Pagno	Piemonte	Cuneo	CN	9855
IT	12030	Sanfront	Piemonte	Cuneo	CN	9856
IT	12030	Ostana	Piemonte	Cuneo	CN	9857
IT	12030	Ruffia	Piemonte	Cuneo	CN	9858
IT	12030	Lagnasco	Piemonte	Cuneo	CN	9859
IT	12030	Brondello	Piemonte	Cuneo	CN	9860
IT	12030	Scarnafigi	Piemonte	Cuneo	CN	9861
IT	12030	Gambasca	Piemonte	Cuneo	CN	9862
IT	12031	Bagnolo Piemonte	Piemonte	Cuneo	CN	9863
IT	12032	Barge	Piemonte	Cuneo	CN	9864
IT	12032	Galleane	Piemonte	Cuneo	CN	9865
IT	12033	Moretta	Piemonte	Cuneo	CN	9866
IT	12034	Paesana	Piemonte	Cuneo	CN	9867
IT	12035	Racconigi	Piemonte	Cuneo	CN	9868
IT	12036	Staffarda	Piemonte	Cuneo	CN	9869
IT	12036	Revello	Piemonte	Cuneo	CN	9870
IT	12037	Cervignasco	Piemonte	Cuneo	CN	9871
IT	12037	San Lazzaro	Piemonte	Cuneo	CN	9872
IT	12037	Saluzzo	Piemonte	Cuneo	CN	9873
IT	12037	Via Dei Romani	Piemonte	Cuneo	CN	9874
IT	12037	San Lazzaro Saluzzo	Piemonte	Cuneo	CN	9875
IT	12038	Levaldigi	Piemonte	Cuneo	CN	9876
IT	12038	Savigliano	Piemonte	Cuneo	CN	9877
IT	12039	Verzuolo	Piemonte	Cuneo	CN	9878
IT	12039	Falicetto	Piemonte	Cuneo	CN	9879
IT	12039	Villanovetta	Piemonte	Cuneo	CN	9880
IT	12040	Baldissero D'Alba	Piemonte	Cuneo	CN	9881
IT	12040	Salmour	Piemonte	Cuneo	CN	9882
IT	12040	Cervere	Piemonte	Cuneo	CN	9883
IT	12040	Montaldo Roero	Piemonte	Cuneo	CN	9884
IT	12040	Vezza D'Alba	Piemonte	Cuneo	CN	9885
IT	12040	Morozzo	Piemonte	Cuneo	CN	9886
IT	12040	Priocca	Piemonte	Cuneo	CN	9887
IT	12040	Genola	Piemonte	Cuneo	CN	9888
IT	12040	Sant'Albano Stura	Piemonte	Cuneo	CN	9889
IT	12040	Margarita	Piemonte	Cuneo	CN	9890
IT	12040	Govone	Piemonte	Cuneo	CN	9891
IT	12040	Castelletto Stura	Piemonte	Cuneo	CN	9892
IT	12040	Trucchi	Piemonte	Cuneo	CN	9893
IT	12040	Ceresole Alba	Piemonte	Cuneo	CN	9894
IT	12040	Montanera	Piemonte	Cuneo	CN	9895
IT	12040	San Giuseppe	Piemonte	Cuneo	CN	9896
IT	12040	Santo Stefano Roero	Piemonte	Cuneo	CN	9897
IT	12040	Sommariva Perno	Piemonte	Cuneo	CN	9898
IT	12040	San Lorenzo Roero	Piemonte	Cuneo	CN	9899
IT	12040	Canove	Piemonte	Cuneo	CN	9900
IT	12040	Corneliano D'Alba	Piemonte	Cuneo	CN	9901
IT	12040	Piobesi D'Alba	Piemonte	Cuneo	CN	9902
IT	12040	Monteu Roero	Piemonte	Cuneo	CN	9903
IT	12040	Sanfre'	Piemonte	Cuneo	CN	9904
IT	12041	Isola	Piemonte	Cuneo	CN	9905
IT	12041	Bene Vagienna	Piemonte	Cuneo	CN	9906
IT	12041	Isola Di Bene Vagienna	Piemonte	Cuneo	CN	9907
IT	12042	Bra	Piemonte	Cuneo	CN	9908
IT	12042	Pollenzo	Piemonte	Cuneo	CN	9909
IT	12042	Bandito	Piemonte	Cuneo	CN	9910
IT	12043	Valpone	Piemonte	Cuneo	CN	9911
IT	12043	Canale	Piemonte	Cuneo	CN	9912
IT	12044	San Biagio	Piemonte	Cuneo	CN	9913
IT	12044	Roata Chiusani	Piemonte	Cuneo	CN	9914
IT	12044	Centallo	Piemonte	Cuneo	CN	9915
IT	12045	Maddalene	Piemonte	Cuneo	CN	9916
IT	12045	San Vittore	Piemonte	Cuneo	CN	9917
IT	12045	Murazzo	Piemonte	Cuneo	CN	9918
IT	12045	Fossano	Piemonte	Cuneo	CN	9919
IT	12045	Tagliata	Piemonte	Cuneo	CN	9920
IT	12045	Gerbo	Piemonte	Cuneo	CN	9921
IT	12045	San Sebastiano	Piemonte	Cuneo	CN	9922
IT	12045	Piovani	Piemonte	Cuneo	CN	9923
IT	12045	San Sebastiano Della Comunia	Piemonte	Cuneo	CN	9924
IT	12046	Monta'	Piemonte	Cuneo	CN	9925
IT	12046	San Rocco	Piemonte	Cuneo	CN	9926
IT	12046	San Rocco Monta'	Piemonte	Cuneo	CN	9927
IT	12047	Rocca De' Baldi	Piemonte	Cuneo	CN	9928
IT	12047	Crava	Piemonte	Cuneo	CN	9929
IT	12048	Sommariva Del Bosco	Piemonte	Cuneo	CN	9930
IT	12049	Trinita'	Piemonte	Cuneo	CN	9931
IT	12050	Roddino	Piemonte	Cuneo	CN	9932
IT	12050	Sinio	Piemonte	Cuneo	CN	9933
IT	12050	Castelrotto	Piemonte	Cuneo	CN	9934
IT	12050	Vaccheria	Piemonte	Cuneo	CN	9935
IT	12050	Castagnito	Piemonte	Cuneo	CN	9936
IT	12050	Rodello	Piemonte	Cuneo	CN	9937
IT	12050	Arguello	Piemonte	Cuneo	CN	9938
IT	12050	Niella Belbo	Piemonte	Cuneo	CN	9939
IT	12050	Serravalle Langhe	Piemonte	Cuneo	CN	9940
IT	12050	Baraccone	Piemonte	Cuneo	CN	9941
IT	12050	Bosia	Piemonte	Cuneo	CN	9942
IT	12050	Trezzo Tinella	Piemonte	Cuneo	CN	9943
IT	12050	Feisoglio	Piemonte	Cuneo	CN	9944
IT	12050	Cravanzana	Piemonte	Cuneo	CN	9945
IT	12050	Albaretto Della Torre	Piemonte	Cuneo	CN	9946
IT	12050	Camo	Piemonte	Cuneo	CN	9947
IT	12050	Neviglie	Piemonte	Cuneo	CN	9948
IT	12050	Serralunga D'Alba	Piemonte	Cuneo	CN	9949
IT	12050	Benevello	Piemonte	Cuneo	CN	9950
IT	12050	Torre Bormida	Piemonte	Cuneo	CN	9951
IT	12050	Castino	Piemonte	Cuneo	CN	9952
IT	12050	Barbaresco	Piemonte	Cuneo	CN	9953
IT	12050	Treiso	Piemonte	Cuneo	CN	9954
IT	12050	Montelupo Albese	Piemonte	Cuneo	CN	9955
IT	12050	Sant'Antonio	Piemonte	Cuneo	CN	9956
IT	12050	Borgomale	Piemonte	Cuneo	CN	9957
IT	12050	Rocchetta Belbo	Piemonte	Cuneo	CN	9958
IT	12050	Guarene	Piemonte	Cuneo	CN	9959
IT	12050	Sant'Antonio Magliano Alfieri	Piemonte	Cuneo	CN	9960
IT	12050	Castellinaldo	Piemonte	Cuneo	CN	9961
IT	12050	Lequio Berria	Piemonte	Cuneo	CN	9962
IT	12050	Magliano Alfieri	Piemonte	Cuneo	CN	9963
IT	12050	San Benedetto Belbo	Piemonte	Cuneo	CN	9964
IT	12050	Cissone	Piemonte	Cuneo	CN	9965
IT	12050	Cerreto Langhe	Piemonte	Cuneo	CN	9966
IT	12051	Mussotto	Piemonte	Cuneo	CN	9967
IT	12051	Alba	Piemonte	Cuneo	CN	9968
IT	12052	Borgonovo	Piemonte	Cuneo	CN	9969
IT	12052	Neive	Piemonte	Cuneo	CN	9970
IT	12052	Borgonuovo Di Neive	Piemonte	Cuneo	CN	9971
IT	12053	Castiglione Tinella	Piemonte	Cuneo	CN	9972
IT	12053	Santuario Tinella	Piemonte	Cuneo	CN	9973
IT	12054	Cossano Belbo	Piemonte	Cuneo	CN	9974
IT	12054	Santa Libera	Piemonte	Cuneo	CN	9975
IT	12055	Valle Talloria	Piemonte	Cuneo	CN	9976
IT	12055	San Rocco Cherasca	Piemonte	Cuneo	CN	9977
IT	12055	Diano D'Alba	Piemonte	Cuneo	CN	9978
IT	12055	Ricca	Piemonte	Cuneo	CN	9979
IT	12056	Mango	Piemonte	Cuneo	CN	9980
IT	12056	San Donato Di Mango	Piemonte	Cuneo	CN	9981
IT	12056	San Donato	Piemonte	Cuneo	CN	9982
IT	12058	Santo Stefano Belbo	Piemonte	Cuneo	CN	9983
IT	12058	Valdivilla	Piemonte	Cuneo	CN	9984
IT	12060	Castellino Tanaro	Piemonte	Cuneo	CN	9985
IT	12060	Somano	Piemonte	Cuneo	CN	9986
IT	12060	Piozzo	Piemonte	Cuneo	CN	9987
IT	12060	Novello	Piemonte	Cuneo	CN	9988
IT	12060	Rocca Ciglie'	Piemonte	Cuneo	CN	9989
IT	12060	Lequio Tanaro	Piemonte	Cuneo	CN	9990
IT	12060	Igliano	Piemonte	Cuneo	CN	9991
IT	12060	Magliano Alpi	Piemonte	Cuneo	CN	9992
IT	12060	Pocapaglia	Piemonte	Cuneo	CN	9993
IT	12060	Marsaglia	Piemonte	Cuneo	CN	9994
IT	12060	Niella Tanaro	Piemonte	Cuneo	CN	9995
IT	12060	Clavesana	Piemonte	Cuneo	CN	9996
IT	12060	Roddi	Piemonte	Cuneo	CN	9997
IT	12060	Castiglione Falletto	Piemonte	Cuneo	CN	9998
IT	12060	Gallo Di Grinzane	Piemonte	Cuneo	CN	9999
IT	12060	Ciglie'	Piemonte	Cuneo	CN	10000
IT	12060	Madonna Della Neve	Piemonte	Cuneo	CN	10001
IT	12060	Monchiero	Piemonte	Cuneo	CN	10002
IT	12060	Farigliano	Piemonte	Cuneo	CN	10003
IT	12060	Barolo	Piemonte	Cuneo	CN	10004
IT	12060	Bastia Mondovi'	Piemonte	Cuneo	CN	10005
IT	12060	Macellai	Piemonte	Cuneo	CN	10006
IT	12060	Belvedere Langhe	Piemonte	Cuneo	CN	10007
IT	12060	Verduno	Piemonte	Cuneo	CN	10008
IT	12060	Bonvicino	Piemonte	Cuneo	CN	10009
IT	12060	Bossolasco	Piemonte	Cuneo	CN	10010
IT	12060	Murazzano	Piemonte	Cuneo	CN	10011
IT	12060	Grinzane Cavour	Piemonte	Cuneo	CN	10012
IT	12060	Gallo	Piemonte	Cuneo	CN	10013
IT	12060	Magliano Alpi Soprano	Piemonte	Cuneo	CN	10014
IT	12060	Magliano Alpi Sottano	Piemonte	Cuneo	CN	10015
IT	12061	Carru'	Piemonte	Cuneo	CN	10016
IT	12062	Cherasco	Piemonte	Cuneo	CN	10017
IT	12062	Roreto	Piemonte	Cuneo	CN	10018
IT	12062	Bricco Favole	Piemonte	Cuneo	CN	10019
IT	12063	Dogliani	Piemonte	Cuneo	CN	10020
IT	12064	Rivalta	Piemonte	Cuneo	CN	10021
IT	12064	La Morra	Piemonte	Cuneo	CN	10022
IT	12065	Monforte D'Alba	Piemonte	Cuneo	CN	10023
IT	12065	Perno	Piemonte	Cuneo	CN	10024
IT	12066	Borgo	Piemonte	Cuneo	CN	10025
IT	12066	Monticello D'Alba	Piemonte	Cuneo	CN	10026
IT	12068	Narzole	Piemonte	Cuneo	CN	10027
IT	12069	Villa	Piemonte	Cuneo	CN	10028
IT	12069	Cinzano	Piemonte	Cuneo	CN	10029
IT	12069	Santa Vittoria D'Alba	Piemonte	Cuneo	CN	10030
IT	12069	Santa Vittoria D'Alba Cinzano	Piemonte	Cuneo	CN	10031
IT	12070	Pezzolo Valle Uzzone	Piemonte	Cuneo	CN	10032
IT	12070	Castelletto Uzzone	Piemonte	Cuneo	CN	10033
IT	12070	Sale Delle Langhe	Piemonte	Cuneo	CN	10034
IT	12070	Mombarcaro	Piemonte	Cuneo	CN	10035
IT	12070	Viola	Piemonte	Cuneo	CN	10036
IT	12070	Lisio	Piemonte	Cuneo	CN	10037
IT	12070	Gottasecca	Piemonte	Cuneo	CN	10038
IT	12070	Battifollo	Piemonte	Cuneo	CN	10039
IT	12070	Gorzegno	Piemonte	Cuneo	CN	10040
IT	12070	Scaletta Uzzone	Piemonte	Cuneo	CN	10041
IT	12070	Levice	Piemonte	Cuneo	CN	10042
IT	12070	Paroldo	Piemonte	Cuneo	CN	10043
IT	12070	Torresina	Piemonte	Cuneo	CN	10044
IT	12070	Bragioli	Piemonte	Cuneo	CN	10045
IT	12070	Perletto	Piemonte	Cuneo	CN	10046
IT	12070	Montezemolo	Piemonte	Cuneo	CN	10047
IT	12070	Alto	Piemonte	Cuneo	CN	10048
IT	12070	Priola	Piemonte	Cuneo	CN	10049
IT	12070	Mombasiglio	Piemonte	Cuneo	CN	10050
IT	12070	Sale San Giovanni	Piemonte	Cuneo	CN	10051
IT	12070	Nucetto	Piemonte	Cuneo	CN	10052
IT	12070	Scagnello	Piemonte	Cuneo	CN	10053
IT	12070	Priero	Piemonte	Cuneo	CN	10054
IT	12070	Perlo	Piemonte	Cuneo	CN	10055
IT	12070	Caprauna	Piemonte	Cuneo	CN	10056
IT	12070	Castelnuovo Di Ceva	Piemonte	Cuneo	CN	10057
IT	12071	Bagnasco	Piemonte	Cuneo	CN	10058
IT	12072	Camerana	Piemonte	Cuneo	CN	10059
IT	12073	Roascio	Piemonte	Cuneo	CN	10060
IT	12073	Ceva	Piemonte	Cuneo	CN	10061
IT	12074	Cortemilia	Piemonte	Cuneo	CN	10062
IT	12074	Bergolo	Piemonte	Cuneo	CN	10063
IT	12075	Trappa	Piemonte	Cuneo	CN	10064
IT	12075	Garessio	Piemonte	Cuneo	CN	10065
IT	12075	Garessio Borgo Ponte	Piemonte	Cuneo	CN	10066
IT	12075	Garessio Borgo Piave	Piemonte	Cuneo	CN	10067
IT	12075	Cerisola	Piemonte	Cuneo	CN	10068
IT	12076	Lesegno	Piemonte	Cuneo	CN	10069
IT	12077	Monesiglio	Piemonte	Cuneo	CN	10070
IT	12077	Prunetto	Piemonte	Cuneo	CN	10071
IT	12078	Ponte Di Nava	Piemonte	Cuneo	CN	10072
IT	12078	Ormea	Piemonte	Cuneo	CN	10073
IT	12079	Saliceto	Piemonte	Cuneo	CN	10074
IT	12080	Montaldo Di Mondovi'	Piemonte	Cuneo	CN	10075
IT	12080	Monastero Di Vasco	Piemonte	Cuneo	CN	10076
IT	12080	Vicoforte	Piemonte	Cuneo	CN	10077
IT	12080	Monasterolo Casotto	Piemonte	Cuneo	CN	10078
IT	12080	Roburent	Piemonte	Cuneo	CN	10079
IT	12080	Pianfei	Piemonte	Cuneo	CN	10080
IT	12080	Briaglia	Piemonte	Cuneo	CN	10081
IT	12080	Moline	Piemonte	Cuneo	CN	10082
IT	12080	Torre Mondovi'	Piemonte	Cuneo	CN	10083
IT	12080	Santuario Di Vicoforte	Piemonte	Cuneo	CN	10084
IT	12080	San Michele Mondovi'	Piemonte	Cuneo	CN	10085
IT	12080	Pra' Di Roburent	Piemonte	Cuneo	CN	10086
IT	12080	Le Moline	Piemonte	Cuneo	CN	10087
IT	12080	Pra'	Piemonte	Cuneo	CN	10088
IT	12081	Beinette	Piemonte	Cuneo	CN	10089
IT	12082	Fontane	Piemonte	Cuneo	CN	10090
IT	12082	Bossea	Piemonte	Cuneo	CN	10091
IT	12082	Frabosa Soprana	Piemonte	Cuneo	CN	10092
IT	12082	Corsaglia	Piemonte	Cuneo	CN	10093
IT	12083	Gosi	Piemonte	Cuneo	CN	10094
IT	12083	Frabosa Sottana	Piemonte	Cuneo	CN	10095
IT	12083	Gosi Pianvignale	Piemonte	Cuneo	CN	10096
IT	12084	Gratteria	Piemonte	Cuneo	CN	10097
IT	12084	Mondovi'	Piemonte	Cuneo	CN	10098
IT	12084	Breolungi	Piemonte	Cuneo	CN	10099
IT	12084	Pascomonti	Piemonte	Cuneo	CN	10100
IT	12084	Pogliola	Piemonte	Cuneo	CN	10101
IT	12084	Breo	Piemonte	Cuneo	CN	10102
IT	12084	Rifreddo Mondovi'	Piemonte	Cuneo	CN	10103
IT	12084	Sant'Anna Avagnina	Piemonte	Cuneo	CN	10104
IT	12084	Piazza	Piemonte	Cuneo	CN	10105
IT	12087	Pamparato	Piemonte	Cuneo	CN	10106
IT	12087	Valcasotto	Piemonte	Cuneo	CN	10107
IT	12087	Serra Pamparato	Piemonte	Cuneo	CN	10108
IT	12087	Serra	Piemonte	Cuneo	CN	10109
IT	12088	Prea Di Roccaforte	Piemonte	Cuneo	CN	10110
IT	12088	Lurisia	Piemonte	Cuneo	CN	10111
IT	12088	Roccaforte Mondovi'	Piemonte	Cuneo	CN	10112
IT	12088	Prea	Piemonte	Cuneo	CN	10113
IT	12089	Villanova Mondovi'	Piemonte	Cuneo	CN	10114
IT	12100	Madonna Delle Grazie	Piemonte	Cuneo	CN	10115
IT	12100	Ronchi	Piemonte	Cuneo	CN	10116
IT	12100	Roata Rossi	Piemonte	Cuneo	CN	10117
IT	12100	San Pietro Del Gallo	Piemonte	Cuneo	CN	10118
IT	12100	Madonna Dell'Olmo	Piemonte	Cuneo	CN	10119
IT	12100	Borgo San Giuseppe	Piemonte	Cuneo	CN	10120
IT	12100	Spinetta	Piemonte	Cuneo	CN	10121
IT	12100	Cuneo	Piemonte	Cuneo	CN	10122
IT	12100	Passatore	Piemonte	Cuneo	CN	10123
IT	12100	San Benigno	Piemonte	Cuneo	CN	10124
IT	12100	San Rocco Castagnaretta	Piemonte	Cuneo	CN	10125
IT	12100	Borgo Gesso	Piemonte	Cuneo	CN	10126
IT	12100	Confreria	Piemonte	Cuneo	CN	10127
IT	18025	Briga Alta	Piemonte	Cuneo	CN	10128
IT	18025	Piaggia	Piemonte	Cuneo	CN	10129
IT	28010	Pisano	Piemonte	Novara	NO	10130
IT	28010	Sologno	Piemonte	Novara	NO	10131
IT	28010	Gargallo	Piemonte	Novara	NO	10132
IT	28010	Briga Novarese	Piemonte	Novara	NO	10133
IT	28010	Bolzano Novarese	Piemonte	Novara	NO	10134
IT	28010	Barengo	Piemonte	Novara	NO	10135
IT	28010	Divignano	Piemonte	Novara	NO	10136
IT	28010	Colazza	Piemonte	Novara	NO	10137
IT	28010	Nebbiuno	Piemonte	Novara	NO	10138
IT	28010	Cavaglietto	Piemonte	Novara	NO	10139
IT	28010	Veruno	Piemonte	Novara	NO	10140
IT	28010	Bogogno	Piemonte	Novara	NO	10141
IT	28010	Alzo	Piemonte	Novara	NO	10142
IT	28010	Caltignaga	Piemonte	Novara	NO	10143
IT	28010	Pella	Piemonte	Novara	NO	10144
IT	28010	Soriso	Piemonte	Novara	NO	10145
IT	28010	Boca	Piemonte	Novara	NO	10146
IT	28010	Cavallirio	Piemonte	Novara	NO	10147
IT	28010	Miasino	Piemonte	Novara	NO	10148
IT	28010	Ameno	Piemonte	Novara	NO	10149
IT	28010	Vaprio D'Agogna	Piemonte	Novara	NO	10150
IT	28010	Agrate Conturbia	Piemonte	Novara	NO	10151
IT	28010	Fontaneto D'Agogna	Piemonte	Novara	NO	10152
IT	28010	Revislate	Piemonte	Novara	NO	10153
IT	28010	Cavaglio D'Agogna	Piemonte	Novara	NO	10154
IT	28011	Sovazza	Piemonte	Novara	NO	10155
IT	28011	Coiromonte	Piemonte	Novara	NO	10156
IT	28011	Armeno	Piemonte	Novara	NO	10157
IT	28012	Cressa	Piemonte	Novara	NO	10158
IT	28013	Gattico	Piemonte	Novara	NO	10159
IT	28014	Maggiora	Piemonte	Novara	NO	10160
IT	28015	Momo	Piemonte	Novara	NO	10161
IT	28016	Orta San Giulio	Piemonte	Novara	NO	10162
IT	28016	Isola San Giulio	Piemonte	Novara	NO	10163
IT	28016	Orta Novarese	Piemonte	Novara	NO	10164
IT	28017	San Maurizio D'Opaglio	Piemonte	Novara	NO	10165
IT	28019	Suno	Piemonte	Novara	NO	10166
IT	28019	Baraggia	Piemonte	Novara	NO	10167
IT	28021	Santa Cristina Di Borgomanero	Piemonte	Novara	NO	10168
IT	28021	Borgomanero	Piemonte	Novara	NO	10169
IT	28021	San Marco Di Borgomanero	Piemonte	Novara	NO	10170
IT	28021	Vergano Di Borgomanero	Piemonte	Novara	NO	10171
IT	28024	Gozzano	Piemonte	Novara	NO	10172
IT	28028	Pettenasco	Piemonte	Novara	NO	10173
IT	28028	Pratolungo	Piemonte	Novara	NO	10174
IT	28040	Mezzomerico	Piemonte	Novara	NO	10175
IT	28040	Borgo Ticino	Piemonte	Novara	NO	10176
IT	28040	Oleggio Castello	Piemonte	Novara	NO	10177
IT	28040	Massino Visconti	Piemonte	Novara	NO	10178
IT	28040	Dormelletto	Piemonte	Novara	NO	10179
IT	28040	Varallo Pombia	Piemonte	Novara	NO	10180
IT	28040	Marano Ticino	Piemonte	Novara	NO	10181
IT	28040	Lesa	Piemonte	Novara	NO	10182
IT	28040	Paruzzaro	Piemonte	Novara	NO	10183
IT	28041	Dagnente	Piemonte	Novara	NO	10184
IT	28041	Arona	Piemonte	Novara	NO	10185
IT	28041	Mercurago	Piemonte	Novara	NO	10186
IT	28043	Bellinzago Novarese	Piemonte	Novara	NO	10187
IT	28045	Invorio	Piemonte	Novara	NO	10188
IT	28046	Ghevio	Piemonte	Novara	NO	10189
IT	28046	Meina	Piemonte	Novara	NO	10190
IT	28047	Oleggio	Piemonte	Novara	NO	10191
IT	28047	Fornaci	Piemonte	Novara	NO	10192
IT	28050	Pombia	Piemonte	Novara	NO	10193
IT	28053	Castelletto Sopra Ticino	Piemonte	Novara	NO	10194
IT	28060	Vicolungo	Piemonte	Novara	NO	10195
IT	28060	Casalino	Piemonte	Novara	NO	10196
IT	28060	Casalbeltrame	Piemonte	Novara	NO	10197
IT	28060	Nibbia	Piemonte	Novara	NO	10198
IT	28060	Mandello Vitta	Piemonte	Novara	NO	10199
IT	28060	Sozzago	Piemonte	Novara	NO	10200
IT	28060	San Nazzaro Sesia	Piemonte	Novara	NO	10201
IT	28060	San Pietro Mosezzo	Piemonte	Novara	NO	10202
IT	28060	Cureggio	Piemonte	Novara	NO	10203
IT	28060	Casalvolone	Piemonte	Novara	NO	10204
IT	28060	Castellazzo Novarese	Piemonte	Novara	NO	10205
IT	28060	Casaleggio Novara	Piemonte	Novara	NO	10206
IT	28060	Comignago	Piemonte	Novara	NO	10207
IT	28060	Orfengo	Piemonte	Novara	NO	10208
IT	28060	Recetto	Piemonte	Novara	NO	10209
IT	28060	Granozzo Con Monticello	Piemonte	Novara	NO	10210
IT	28060	Granozzo	Piemonte	Novara	NO	10211
IT	28060	Cameriano	Piemonte	Novara	NO	10212
IT	28060	Vinzaglio	Piemonte	Novara	NO	10213
IT	28061	Biandrate	Piemonte	Novara	NO	10214
IT	28062	Cameri	Piemonte	Novara	NO	10215
IT	28062	Cameri Aeronautica	Piemonte	Novara	NO	10216
IT	28064	Sillavengo	Piemonte	Novara	NO	10217
IT	28064	Landiona	Piemonte	Novara	NO	10218
IT	28064	Carpignano Sesia	Piemonte	Novara	NO	10219
IT	28065	Cerano	Piemonte	Novara	NO	10220
IT	28066	Galliate	Piemonte	Novara	NO	10221
IT	28068	Romentino	Piemonte	Novara	NO	10222
IT	28069	Trecate	Piemonte	Novara	NO	10223
IT	28070	Terdobbiate	Piemonte	Novara	NO	10224
IT	28070	Sizzano	Piemonte	Novara	NO	10225
IT	28070	Garbagna Novarese	Piemonte	Novara	NO	10226
IT	28070	Tornaco	Piemonte	Novara	NO	10227
IT	28070	Nibbiola	Piemonte	Novara	NO	10228
IT	28071	Borgolavezzaro	Piemonte	Novara	NO	10229
IT	28072	Briona	Piemonte	Novara	NO	10230
IT	28072	San Bernardino	Piemonte	Novara	NO	10231
IT	28073	Fara Novarese	Piemonte	Novara	NO	10232
IT	28074	Ghemme	Piemonte	Novara	NO	10233
IT	28075	Grignasco	Piemonte	Novara	NO	10234
IT	28076	Pogno	Piemonte	Novara	NO	10235
IT	28077	Prato Sesia	Piemonte	Novara	NO	10236
IT	28078	Romagnano Sesia	Piemonte	Novara	NO	10237
IT	28079	Vespolate	Piemonte	Novara	NO	10238
IT	28100	Torrion Quartara	Piemonte	Novara	NO	10239
IT	28100	Olengo	Piemonte	Novara	NO	10240
IT	28100	Lumellogno	Piemonte	Novara	NO	10241
IT	28100	Novara	Piemonte	Novara	NO	10242
IT	28100	Casalgiate	Piemonte	Novara	NO	10243
IT	28100	Agognate	Piemonte	Novara	NO	10244
IT	28100	Vignale	Piemonte	Novara	NO	10245
IT	28100	Bicocca Di Novara	Piemonte	Novara	NO	10246
IT	28100	Pernate	Piemonte	Novara	NO	10247
IT	28100	Sant'Agabio	Piemonte	Novara	NO	10248
IT	28100	Veveri	Piemonte	Novara	NO	10249
IT	10010	Bairo	Piemonte	Torino	TO	10250
IT	10010	Tavagnasco	Piemonte	Torino	TO	10251
IT	10010	Quincinetto	Piemonte	Torino	TO	10252
IT	10010	Chiaverano	Piemonte	Torino	TO	10253
IT	10010	Cossano Canavese	Piemonte	Torino	TO	10254
IT	10010	Lessolo	Piemonte	Torino	TO	10255
IT	10010	Candia Canavese	Piemonte	Torino	TO	10256
IT	10010	Burolo	Piemonte	Torino	TO	10257
IT	10010	Albiano D'Ivrea	Piemonte	Torino	TO	10258
IT	10010	San Martino Canavese	Piemonte	Torino	TO	10259
IT	10010	Perosa Canavese	Piemonte	Torino	TO	10260
IT	10010	Quagliuzzo	Piemonte	Torino	TO	10261
IT	10010	Loranze'	Piemonte	Torino	TO	10262
IT	10010	Rueglio	Piemonte	Torino	TO	10263
IT	10010	Quassolo	Piemonte	Torino	TO	10264
IT	10010	Azeglio	Piemonte	Torino	TO	10265
IT	10010	Colleretto Giacosa	Piemonte	Torino	TO	10266
IT	10010	Barone Canavese	Piemonte	Torino	TO	10267
IT	10010	Fiorano Canavese	Piemonte	Torino	TO	10268
IT	10010	Salerano Canavese	Piemonte	Torino	TO	10269
IT	10010	Andrate	Piemonte	Torino	TO	10270
IT	10010	Gauna	Piemonte	Torino	TO	10271
IT	10010	Settimo Rottaro	Piemonte	Torino	TO	10272
IT	10010	Piverone	Piemonte	Torino	TO	10273
IT	10010	Palazzo Canavese	Piemonte	Torino	TO	10274
IT	10010	Villate	Piemonte	Torino	TO	10275
IT	10010	Scarmagno	Piemonte	Torino	TO	10276
IT	10010	Calea	Piemonte	Torino	TO	10277
IT	10010	Parella	Piemonte	Torino	TO	10278
IT	10010	Cascinette D'Ivrea	Piemonte	Torino	TO	10279
IT	10010	Torre Canavese	Piemonte	Torino	TO	10280
IT	10010	Alice Superiore	Piemonte	Torino	TO	10281
IT	10010	Banchette	Piemonte	Torino	TO	10282
IT	10010	Masino	Piemonte	Torino	TO	10283
IT	10010	Nomaglio	Piemonte	Torino	TO	10284
IT	10010	Strambinello	Piemonte	Torino	TO	10285
IT	10010	Orio Canavese	Piemonte	Torino	TO	10286
IT	10010	Settimo Vittone	Piemonte	Torino	TO	10287
IT	10010	Caravino	Piemonte	Torino	TO	10288
IT	10010	Carema	Piemonte	Torino	TO	10289
IT	10010	Mercenasco	Piemonte	Torino	TO	10290
IT	10011	Aglie'	Piemonte	Torino	TO	10291
IT	10012	Bollengo	Piemonte	Torino	TO	10292
IT	10013	Baio Dora	Piemonte	Torino	TO	10293
IT	10013	Borgofranco D'Ivrea	Piemonte	Torino	TO	10294
IT	10014	Caluso	Piemonte	Torino	TO	10295
IT	10014	Are'	Piemonte	Torino	TO	10296
IT	10014	Vallo	Piemonte	Torino	TO	10297
IT	10014	Rodallo	Piemonte	Torino	TO	10298
IT	10014	Vallo Di Caluso	Piemonte	Torino	TO	10299
IT	10015	Ivrea	Piemonte	Torino	TO	10300
IT	10015	San Bernardo D'Ivrea	Piemonte	Torino	TO	10301
IT	10015	Torre Balfredo	Piemonte	Torino	TO	10302
IT	10016	Montalto Dora	Piemonte	Torino	TO	10303
IT	10017	Montanaro	Piemonte	Torino	TO	10304
IT	10018	Pavone Canavese	Piemonte	Torino	TO	10305
IT	10019	Cerone	Piemonte	Torino	TO	10306
IT	10019	Strambino	Piemonte	Torino	TO	10307
IT	10019	Carrone	Piemonte	Torino	TO	10308
IT	10020	Cambiano	Piemonte	Torino	TO	10309
IT	10020	Mombello Di Torino	Piemonte	Torino	TO	10310
IT	10020	Monteu Da Po	Piemonte	Torino	TO	10311
IT	10020	Moriondo Torinese	Piemonte	Torino	TO	10312
IT	10020	Baldissero Torinese	Piemonte	Torino	TO	10313
IT	10020	Verrua Savoia	Piemonte	Torino	TO	10314
IT	10020	Andezeno	Piemonte	Torino	TO	10315
IT	10020	Riva Presso Chieri	Piemonte	Torino	TO	10316
IT	10020	Pavarolo	Piemonte	Torino	TO	10317
IT	10020	Montaldo Torinese	Piemonte	Torino	TO	10318
IT	10020	Rivodora	Piemonte	Torino	TO	10319
IT	10020	San Sebastiano Da Po	Piemonte	Torino	TO	10320
IT	10020	Madonna Della Scala	Piemonte	Torino	TO	10321
IT	10020	San Pietro	Piemonte	Torino	TO	10322
IT	10020	Lauriano	Piemonte	Torino	TO	10323
IT	10020	Arignano	Piemonte	Torino	TO	10324
IT	10020	Casalborgone	Piemonte	Torino	TO	10325
IT	10020	Brozolo	Piemonte	Torino	TO	10326
IT	10020	Marcorengo	Piemonte	Torino	TO	10327
IT	10020	Cavagnolo	Piemonte	Torino	TO	10328
IT	10020	Marentino	Piemonte	Torino	TO	10329
IT	10020	Brusasco	Piemonte	Torino	TO	10330
IT	10020	Pecetto Torinese	Piemonte	Torino	TO	10331
IT	10020	Colombaro	Piemonte	Torino	TO	10332
IT	10022	San Michele E Grato	Piemonte	Torino	TO	10333
IT	10022	Carmagnola	Piemonte	Torino	TO	10334
IT	10022	Cavalleri	Piemonte	Torino	TO	10335
IT	10022	San Bernardo Carmagnola	Piemonte	Torino	TO	10336
IT	10022	Fumeri	Piemonte	Torino	TO	10337
IT	10022	Borgo Salsasio	Piemonte	Torino	TO	10338
IT	10023	Pessione	Piemonte	Torino	TO	10339
IT	10023	Chieri	Piemonte	Torino	TO	10340
IT	10024	Barauda	Piemonte	Torino	TO	10341
IT	10024	Tagliaferro	Piemonte	Torino	TO	10342
IT	10024	Colle Della Maddalena	Piemonte	Torino	TO	10343
IT	10024	Revigliasco	Piemonte	Torino	TO	10344
IT	10024	Moncalieri	Piemonte	Torino	TO	10345
IT	10024	Testona	Piemonte	Torino	TO	10346
IT	10024	Borgo San Pietro Di Moncalieri	Piemonte	Torino	TO	10347
IT	10024	Revigliasco Torinese	Piemonte	Torino	TO	10348
IT	10025	Pino Torinese	Piemonte	Torino	TO	10349
IT	10026	Santena	Piemonte	Torino	TO	10350
IT	10028	Trofarello	Piemonte	Torino	TO	10351
IT	10028	Valle Sauglio	Piemonte	Torino	TO	10352
IT	10029	Villastellone	Piemonte	Torino	TO	10353
IT	10030	Villareggia	Piemonte	Torino	TO	10354
IT	10030	Maglione	Piemonte	Torino	TO	10355
IT	10030	Rondissone	Piemonte	Torino	TO	10356
IT	10030	Vestigne'	Piemonte	Torino	TO	10357
IT	10030	Vische	Piemonte	Torino	TO	10358
IT	10030	Tina	Piemonte	Torino	TO	10359
IT	10031	Borgomasino	Piemonte	Torino	TO	10360
IT	10032	Brandizzo	Piemonte	Torino	TO	10361
IT	10034	Chivasso	Piemonte	Torino	TO	10362
IT	10034	Castelrosso	Piemonte	Torino	TO	10363
IT	10034	Torassi	Piemonte	Torino	TO	10364
IT	10034	Boschetto	Piemonte	Torino	TO	10365
IT	10035	Casale	Piemonte	Torino	TO	10366
IT	10035	Tonengo Di Mazze'	Piemonte	Torino	TO	10367
IT	10035	Mazze'	Piemonte	Torino	TO	10368
IT	10036	Settimo Torinese	Piemonte	Torino	TO	10369
IT	10036	Olimpia	Piemonte	Torino	TO	10370
IT	10037	Torrazza Piemonte	Piemonte	Torino	TO	10371
IT	10038	Casabianca	Piemonte	Torino	TO	10372
IT	10038	Verolengo	Piemonte	Torino	TO	10373
IT	10038	Borgo Revel	Piemonte	Torino	TO	10374
IT	10040	Volvera	Piemonte	Torino	TO	10375
IT	10040	Pralormo	Piemonte	Torino	TO	10376
IT	10040	Caprie	Piemonte	Torino	TO	10377
IT	10040	Cumiana	Piemonte	Torino	TO	10378
IT	10040	Rivera	Piemonte	Torino	TO	10379
IT	10040	Zucche	Piemonte	Torino	TO	10380
IT	10040	Villar Dora	Piemonte	Torino	TO	10381
IT	10040	Novaretto	Piemonte	Torino	TO	10382
IT	10040	Val Della Torre	Piemonte	Torino	TO	10383
IT	10040	Montelera	Piemonte	Torino	TO	10384
IT	10040	Osasio	Piemonte	Torino	TO	10385
IT	10040	Rubiana	Piemonte	Torino	TO	10386
IT	10040	La Loggia	Piemonte	Torino	TO	10387
IT	10040	Rivarossa	Piemonte	Torino	TO	10388
IT	10040	Druento	Piemonte	Torino	TO	10389
IT	10040	Lombardore	Piemonte	Torino	TO	10390
IT	10040	Milanere	Piemonte	Torino	TO	10391
IT	10040	Brione	Piemonte	Torino	TO	10392
IT	10040	Gerbole	Piemonte	Torino	TO	10393
IT	10040	Rivalta Di Torino	Piemonte	Torino	TO	10394
IT	10040	San Gillio	Piemonte	Torino	TO	10395
IT	10040	Almese	Piemonte	Torino	TO	10396
IT	10040	Givoletto	Piemonte	Torino	TO	10397
IT	10040	Lombriasco	Piemonte	Torino	TO	10398
IT	10040	Tedeschi	Piemonte	Torino	TO	10399
IT	10040	Piobesi Torinese	Piemonte	Torino	TO	10400
IT	10040	La Cassa	Piemonte	Torino	TO	10401
IT	10040	Bivio Cumiana	Piemonte	Torino	TO	10402
IT	10040	Caselette	Piemonte	Torino	TO	10403
IT	10040	Leini'	Piemonte	Torino	TO	10404
IT	10041	Ceretto Di Carignano	Piemonte	Torino	TO	10405
IT	10041	Carignano	Piemonte	Torino	TO	10406
IT	10041	Ceretto	Piemonte	Torino	TO	10407
IT	10042	Stupinigi	Piemonte	Torino	TO	10408
IT	10042	Nichelino	Piemonte	Torino	TO	10409
IT	10043	Orbassano	Piemonte	Torino	TO	10410
IT	10044	Pianezza	Piemonte	Torino	TO	10411
IT	10045	Piossasco	Piemonte	Torino	TO	10412
IT	10045	Garola	Piemonte	Torino	TO	10413
IT	10046	Poirino	Piemonte	Torino	TO	10414
IT	10046	Favari	Piemonte	Torino	TO	10415
IT	10046	Isolabella	Piemonte	Torino	TO	10416
IT	10046	Marocchi	Piemonte	Torino	TO	10417
IT	10046	Avatanei	Piemonte	Torino	TO	10418
IT	10048	Garino	Piemonte	Torino	TO	10419
IT	10048	Vinovo	Piemonte	Torino	TO	10420
IT	10050	Salbertrand	Piemonte	Torino	TO	10421
IT	10050	Claviere	Piemonte	Torino	TO	10422
IT	10050	Baratte	Piemonte	Torino	TO	10423
IT	10050	Vernetto	Piemonte	Torino	TO	10424
IT	10050	Chiomonte	Piemonte	Torino	TO	10425
IT	10050	Moncenisio	Piemonte	Torino	TO	10426
IT	10050	San Didero	Piemonte	Torino	TO	10427
IT	10050	Chiusa Di San Michele	Piemonte	Torino	TO	10428
IT	10050	Borgone Susa	Piemonte	Torino	TO	10429
IT	10050	Villar Focchiardo	Piemonte	Torino	TO	10430
IT	10050	Meana Di Susa	Piemonte	Torino	TO	10431
IT	10050	Salice D'Ulzio	Piemonte	Torino	TO	10432
IT	10050	Sant'Antonino Di Susa	Piemonte	Torino	TO	10433
IT	10050	Exilles	Piemonte	Torino	TO	10434
IT	10050	San Giorio	Piemonte	Torino	TO	10435
IT	10050	Mattie	Piemonte	Torino	TO	10436
IT	10050	Giaglione	Piemonte	Torino	TO	10437
IT	10050	Venaus	Piemonte	Torino	TO	10438
IT	10050	Chianocco	Piemonte	Torino	TO	10439
IT	10050	Sauze D'Oulx	Piemonte	Torino	TO	10440
IT	10050	Gravere	Piemonte	Torino	TO	10441
IT	10050	Vaie	Piemonte	Torino	TO	10442
IT	10050	Coazze	Piemonte	Torino	TO	10443
IT	10050	Bruzolo	Piemonte	Torino	TO	10444
IT	10050	Novalesa	Piemonte	Torino	TO	10445
IT	10050	Zoie	Piemonte	Torino	TO	10446
IT	10050	San Giorio Di Susa	Piemonte	Torino	TO	10447
IT	10051	Avigliana	Piemonte	Torino	TO	10448
IT	10051	Drubiaglio	Piemonte	Torino	TO	10449
IT	10051	Grangia	Piemonte	Torino	TO	10450
IT	10052	Bardonecchia	Piemonte	Torino	TO	10451
IT	10052	Borgonovo Bardonecchia	Piemonte	Torino	TO	10452
IT	10053	Bussoleno	Piemonte	Torino	TO	10453
IT	10053	Foresto	Piemonte	Torino	TO	10454
IT	10054	Solomiac	Piemonte	Torino	TO	10455
IT	10054	Cesana Torinese	Piemonte	Torino	TO	10456
IT	10054	Sauze Di Cesana	Piemonte	Torino	TO	10457
IT	10054	Bousson	Piemonte	Torino	TO	10458
IT	10055	Condove	Piemonte	Torino	TO	10459
IT	10056	Beaulard	Piemonte	Torino	TO	10460
IT	10056	Oulx	Piemonte	Torino	TO	10461
IT	10057	Sant'Ambrogio Di Torino	Piemonte	Torino	TO	10462
IT	10058	Colle Sestriere	Piemonte	Torino	TO	10463
IT	10058	Sestriere	Piemonte	Torino	TO	10464
IT	10059	San Giuseppe	Piemonte	Torino	TO	10465
IT	10059	Susa	Piemonte	Torino	TO	10466
IT	10059	Mompantero	Piemonte	Torino	TO	10467
IT	10060	Angrogna	Piemonte	Torino	TO	10468
IT	10060	Bricherasio	Piemonte	Torino	TO	10469
IT	10060	Pragelato	Piemonte	Torino	TO	10470
IT	10060	Villar Pellice	Piemonte	Torino	TO	10471
IT	10060	Salza Di Pinerolo	Piemonte	Torino	TO	10472
IT	10060	Massello	Piemonte	Torino	TO	10473
IT	10060	Castagnole Piemonte	Piemonte	Torino	TO	10474
IT	10060	Airasca	Piemonte	Torino	TO	10475
IT	10060	Macello	Piemonte	Torino	TO	10476
IT	10060	Roreto	Piemonte	Torino	TO	10477
IT	10060	Combalere	Piemonte	Torino	TO	10478
IT	10060	Prali	Piemonte	Torino	TO	10479
IT	10060	Porte	Piemonte	Torino	TO	10480
IT	10060	Mentoulles	Piemonte	Torino	TO	10481
IT	10060	Inverso Pinasca	Piemonte	Torino	TO	10482
IT	10060	Riclaretto	Piemonte	Torino	TO	10483
IT	10060	Piscina	Piemonte	Torino	TO	10484
IT	10060	San Pietro Val Lemina	Piemonte	Torino	TO	10485
IT	10060	Cantalupa	Piemonte	Torino	TO	10486
IT	10060	Roletto	Piemonte	Torino	TO	10487
IT	10060	Roure	Piemonte	Torino	TO	10488
IT	10060	Campiglione	Piemonte	Torino	TO	10489
IT	10060	Virle Piemonte	Piemonte	Torino	TO	10490
IT	10060	Pancalieri	Piemonte	Torino	TO	10491
IT	10060	Campiglione Fenile	Piemonte	Torino	TO	10492
IT	10060	Buriasco	Piemonte	Torino	TO	10493
IT	10060	Bobbio Pellice	Piemonte	Torino	TO	10494
IT	10060	Villaretto Chisone	Piemonte	Torino	TO	10495
IT	10060	Garzigliana	Piemonte	Torino	TO	10496
IT	10060	Usseaux	Piemonte	Torino	TO	10497
IT	10060	Fenestrelle	Piemonte	Torino	TO	10498
IT	10060	Perrero	Piemonte	Torino	TO	10499
IT	10060	Osasco	Piemonte	Torino	TO	10500
IT	10060	Lusernetta	Piemonte	Torino	TO	10501
IT	10060	None	Piemonte	Torino	TO	10502
IT	10060	Cercenasco	Piemonte	Torino	TO	10503
IT	10060	Viotto	Piemonte	Torino	TO	10504
IT	10060	Miradolo	Piemonte	Torino	TO	10505
IT	10060	Candiolo	Piemonte	Torino	TO	10506
IT	10060	Dubbione	Piemonte	Torino	TO	10507
IT	10060	Frossasco	Piemonte	Torino	TO	10508
IT	10060	Prarostino	Piemonte	Torino	TO	10509
IT	10060	Bibiana	Piemonte	Torino	TO	10510
IT	10060	Rora'	Piemonte	Torino	TO	10511
IT	10060	Scalenghe	Piemonte	Torino	TO	10512
IT	10060	Villaretto	Piemonte	Torino	TO	10513
IT	10060	San Secondo Di Pinerolo	Piemonte	Torino	TO	10514
IT	10060	Roreto Chisone	Piemonte	Torino	TO	10515
IT	10060	Pra' Catinat	Piemonte	Torino	TO	10516
IT	10060	Castelnuovo	Piemonte	Torino	TO	10517
IT	10060	Castel Del Bosco	Piemonte	Torino	TO	10518
IT	10060	Pinasca	Piemonte	Torino	TO	10519
IT	10061	Cavour	Piemonte	Torino	TO	10520
IT	10062	Luserna	Piemonte	Torino	TO	10521
IT	10062	Airali	Piemonte	Torino	TO	10522
IT	10062	Luserna San Giovanni	Piemonte	Torino	TO	10523
IT	10063	Perosa Argentina	Piemonte	Torino	TO	10524
IT	10063	Pomaretto	Piemonte	Torino	TO	10525
IT	10064	Abbadia Alpina	Piemonte	Torino	TO	10526
IT	10064	Baudenasca	Piemonte	Torino	TO	10527
IT	10064	Riva Di Pinerolo	Piemonte	Torino	TO	10528
IT	10064	Pinerolo	Piemonte	Torino	TO	10529
IT	10065	Pramollo	Piemonte	Torino	TO	10530
IT	10065	San Germano Chisone	Piemonte	Torino	TO	10531
IT	10066	Torre Pellice	Piemonte	Torino	TO	10532
IT	10067	Vigone	Piemonte	Torino	TO	10533
IT	10068	Villafranca Piemonte	Piemonte	Torino	TO	10534
IT	10069	Villar Perosa	Piemonte	Torino	TO	10535
IT	10070	Corio	Piemonte	Torino	TO	10536
IT	10070	Bonzo	Piemonte	Torino	TO	10537
IT	10070	Procaria	Piemonte	Torino	TO	10538
IT	10070	Groscavallo	Piemonte	Torino	TO	10539
IT	10070	Vallo Torinese	Piemonte	Torino	TO	10540
IT	10070	Chialamberto	Piemonte	Torino	TO	10541
IT	10070	Benne	Piemonte	Torino	TO	10542
IT	10070	Col San Giovanni Di Viu'	Piemonte	Torino	TO	10543
IT	10070	Rocca Canavese	Piemonte	Torino	TO	10544
IT	10070	Usseglio	Piemonte	Torino	TO	10545
IT	10070	Viu'	Piemonte	Torino	TO	10546
IT	10070	Fiano	Piemonte	Torino	TO	10547
IT	10070	Robassomero	Piemonte	Torino	TO	10548
IT	10070	San Carlo Canavese	Piemonte	Torino	TO	10549
IT	10070	Traves	Piemonte	Torino	TO	10550
IT	10070	Levone	Piemonte	Torino	TO	10551
IT	10070	Balangero	Piemonte	Torino	TO	10552
IT	10070	Col San Giovanni	Piemonte	Torino	TO	10553
IT	70010	San Pietro	Puglia	Bari	BA	10554
IT	10070	Coassolo Torinese	Piemonte	Torino	TO	10555
IT	10070	Lemie	Piemonte	Torino	TO	10556
IT	10070	Forno Alpi Graie	Piemonte	Torino	TO	10557
IT	10070	Villanova Canavese	Piemonte	Torino	TO	10558
IT	10070	Vauda Canavese Superiore	Piemonte	Torino	TO	10559
IT	10070	Cantoira	Piemonte	Torino	TO	10560
IT	10070	Grosso	Piemonte	Torino	TO	10561
IT	10070	Front	Piemonte	Torino	TO	10562
IT	10070	Ceres	Piemonte	Torino	TO	10563
IT	10070	La Villa	Piemonte	Torino	TO	10564
IT	10070	Monasterolo Torinese	Piemonte	Torino	TO	10565
IT	10070	Germagnano	Piemonte	Torino	TO	10566
IT	10070	Monasterolo	Piemonte	Torino	TO	10567
IT	10070	Barbania	Piemonte	Torino	TO	10568
IT	10070	Cafasse	Piemonte	Torino	TO	10569
IT	10070	Mezzenile	Piemonte	Torino	TO	10570
IT	10070	Monastero Di Lanzo	Piemonte	Torino	TO	10571
IT	10070	Mondrone	Piemonte	Torino	TO	10572
IT	10070	Varisella	Piemonte	Torino	TO	10573
IT	10070	Balme	Piemonte	Torino	TO	10574
IT	10070	Pessinetto	Piemonte	Torino	TO	10575
IT	10070	San Francesco Al Campo	Piemonte	Torino	TO	10576
IT	10070	Vauda Canavese	Piemonte	Torino	TO	10577
IT	10070	Ala Di Stura	Piemonte	Torino	TO	10578
IT	10071	Borgaro Torinese	Piemonte	Torino	TO	10579
IT	10072	Mappano	Piemonte	Torino	TO	10580
IT	10072	Caselle Torinese	Piemonte	Torino	TO	10581
IT	10073	Cirie'	Piemonte	Torino	TO	10582
IT	10073	Devesi	Piemonte	Torino	TO	10583
IT	10074	Lanzo Torinese	Piemonte	Torino	TO	10584
IT	10075	Mathi	Piemonte	Torino	TO	10585
IT	10076	Nole	Piemonte	Torino	TO	10586
IT	10076	San Giovanni	Piemonte	Torino	TO	10587
IT	10077	San Maurizio Canavese	Piemonte	Torino	TO	10588
IT	10077	Malanghero	Piemonte	Torino	TO	10589
IT	10077	Ceretta Di San Maurizio Canavese	Piemonte	Torino	TO	10590
IT	10078	Altessano	Piemonte	Torino	TO	10591
IT	10078	Venaria Reale	Piemonte	Torino	TO	10592
IT	10080	Cintano	Piemonte	Torino	TO	10593
IT	10080	Vidracco	Piemonte	Torino	TO	10594
IT	10080	Oglianico	Piemonte	Torino	TO	10595
IT	10080	Ciconio	Piemonte	Torino	TO	10596
IT	10080	Valprato Soana	Piemonte	Torino	TO	10597
IT	10080	Meugliano	Piemonte	Torino	TO	10598
IT	10080	Pertusio	Piemonte	Torino	TO	10599
IT	10080	Canischio	Piemonte	Torino	TO	10600
IT	10080	Ozegna	Piemonte	Torino	TO	10601
IT	10080	Vistrorio	Piemonte	Torino	TO	10602
IT	10080	Ceresole Reale	Piemonte	Torino	TO	10603
IT	10080	Colleretto Castelnuovo	Piemonte	Torino	TO	10604
IT	10080	Ronco Canavese	Piemonte	Torino	TO	10605
IT	10080	Lugnacco	Piemonte	Torino	TO	10606
IT	10080	Feletto	Piemonte	Torino	TO	10607
IT	10080	Frassinetto	Piemonte	Torino	TO	10608
IT	10080	Sparone	Piemonte	Torino	TO	10609
IT	10080	Pratiglione	Piemonte	Torino	TO	10610
IT	10080	Borgiallo	Piemonte	Torino	TO	10611
IT	10080	Fornolosa	Piemonte	Torino	TO	10612
IT	10080	Issiglio	Piemonte	Torino	TO	10613
IT	10080	Brosso	Piemonte	Torino	TO	10614
IT	10080	Lusiglie'	Piemonte	Torino	TO	10615
IT	10080	Salassa	Piemonte	Torino	TO	10616
IT	10080	Ribordone	Piemonte	Torino	TO	10617
IT	10080	Noasca	Piemonte	Torino	TO	10618
IT	10080	Locana	Piemonte	Torino	TO	10619
IT	10080	Alpette	Piemonte	Torino	TO	10620
IT	10080	Prascorsano	Piemonte	Torino	TO	10621
IT	10080	San Ponso	Piemonte	Torino	TO	10622
IT	10080	Traversella	Piemonte	Torino	TO	10623
IT	10080	Rosone	Piemonte	Torino	TO	10624
IT	10080	Vico Canavese	Piemonte	Torino	TO	10625
IT	10080	San Colombano Belmonte	Piemonte	Torino	TO	10626
IT	10080	Casetti	Piemonte	Torino	TO	10627
IT	10080	Busano	Piemonte	Torino	TO	10628
IT	10080	San Benigno Canavese	Piemonte	Torino	TO	10629
IT	10080	Drusacco	Piemonte	Torino	TO	10630
IT	10080	Chiesanuova	Piemonte	Torino	TO	10631
IT	10080	Rivara	Piemonte	Torino	TO	10632
IT	10080	Ingria	Piemonte	Torino	TO	10633
IT	10080	Pecco	Piemonte	Torino	TO	10634
IT	10080	Bosconero	Piemonte	Torino	TO	10635
IT	10080	Villa Castelnuovo	Piemonte	Torino	TO	10636
IT	10080	Baldissero Canavese	Piemonte	Torino	TO	10637
IT	10080	Trausella	Piemonte	Torino	TO	10638
IT	10080	Castelnuovo Nigra	Piemonte	Torino	TO	10639
IT	10081	Castellamonte	Piemonte	Torino	TO	10640
IT	10081	Muriaglio	Piemonte	Torino	TO	10641
IT	10081	Campo Canavese	Piemonte	Torino	TO	10642
IT	10081	San Giovanni Canavese	Piemonte	Torino	TO	10643
IT	10082	Priacco	Piemonte	Torino	TO	10644
IT	10082	Cuorgne'	Piemonte	Torino	TO	10645
IT	10082	Salto Canavese	Piemonte	Torino	TO	10646
IT	10083	Favria	Piemonte	Torino	TO	10647
IT	10084	Forno Canavese	Piemonte	Torino	TO	10648
IT	10085	Pont Canavese	Piemonte	Torino	TO	10649
IT	10086	Argentera	Piemonte	Torino	TO	10650
IT	10086	Rivarolo Canavese	Piemonte	Torino	TO	10651
IT	10087	Valperga	Piemonte	Torino	TO	10652
IT	10088	Volpiano	Piemonte	Torino	TO	10653
IT	10090	Corbiglia	Piemonte	Torino	TO	10654
IT	10090	Vialfre'	Piemonte	Torino	TO	10655
IT	10090	Montalenghe	Piemonte	Torino	TO	10656
IT	10090	San Bernardino	Piemonte	Torino	TO	10657
IT	10090	Ferriera	Piemonte	Torino	TO	10658
IT	10090	Bussolino	Piemonte	Torino	TO	10659
IT	10090	San Raffaele Cimena	Piemonte	Torino	TO	10660
IT	10090	Cuceglio	Piemonte	Torino	TO	10661
IT	10090	Piana San Raffaele	Piemonte	Torino	TO	10662
IT	10090	Gassino Torinese	Piemonte	Torino	TO	10663
IT	10090	Foglizzo	Piemonte	Torino	TO	10664
IT	10090	Trana	Piemonte	Torino	TO	10665
IT	10090	San Giorgio Canavese	Piemonte	Torino	TO	10666
IT	10090	Villarbasse	Piemonte	Torino	TO	10667
IT	10090	Buttigliera Alta	Piemonte	Torino	TO	10668
IT	10090	Castiglione Torinese	Piemonte	Torino	TO	10669
IT	10090	Villaggio La Quercia	Piemonte	Torino	TO	10670
IT	10090	Romano Canavese	Piemonte	Torino	TO	10671
IT	10090	Cinzano	Piemonte	Torino	TO	10672
IT	10090	Rivalba	Piemonte	Torino	TO	10673
IT	10090	Rosta	Piemonte	Torino	TO	10674
IT	10090	Bruino	Piemonte	Torino	TO	10675
IT	10090	San Giusto Canavese	Piemonte	Torino	TO	10676
IT	10090	Sciolze	Piemonte	Torino	TO	10677
IT	10090	Sangano	Piemonte	Torino	TO	10678
IT	10090	Castagneto Po	Piemonte	Torino	TO	10679
IT	10090	Reano	Piemonte	Torino	TO	10680
IT	10091	Alpignano	Piemonte	Torino	TO	10681
IT	10092	Beinasco	Piemonte	Torino	TO	10682
IT	10092	Borgaretto	Piemonte	Torino	TO	10683
IT	10093	Regina Margherita	Piemonte	Torino	TO	10684
IT	10093	Savonera	Piemonte	Torino	TO	10685
IT	10093	Collegno	Piemonte	Torino	TO	10686
IT	10093	Leumann	Piemonte	Torino	TO	10687
IT	10093	Borgata Paradiso Di Collegno	Piemonte	Torino	TO	10688
IT	10094	Pontepietra	Piemonte	Torino	TO	10689
IT	10094	Selvaggio	Piemonte	Torino	TO	10690
IT	10094	Giaveno	Piemonte	Torino	TO	10691
IT	10094	Valgioie	Piemonte	Torino	TO	10692
IT	10095	Grugliasco	Piemonte	Torino	TO	10693
IT	10095	Lesna	Piemonte	Torino	TO	10694
IT	10095	Gerbido	Piemonte	Torino	TO	10695
IT	10098	Rivoli	Piemonte	Torino	TO	10696
IT	10098	Tetti Neirotti	Piemonte	Torino	TO	10697
IT	10098	Bruere	Piemonte	Torino	TO	10698
IT	10098	Cascine Vica	Piemonte	Torino	TO	10699
IT	10099	San Mauro Torinese	Piemonte	Torino	TO	10700
IT	10100	Torino	Piemonte	Torino	TO	10701
IT	10121	Torino	Piemonte	Torino	TO	10702
IT	10122	Torino	Piemonte	Torino	TO	10703
IT	10123	Torino	Piemonte	Torino	TO	10704
IT	10124	Torino	Piemonte	Torino	TO	10705
IT	10125	Torino	Piemonte	Torino	TO	10706
IT	10126	Torino	Piemonte	Torino	TO	10707
IT	10127	Torino	Piemonte	Torino	TO	10708
IT	10128	Torino	Piemonte	Torino	TO	10709
IT	10129	Torino	Piemonte	Torino	TO	10710
IT	10131	Torino	Piemonte	Torino	TO	10711
IT	10132	Superga	Piemonte	Torino	TO	10712
IT	10132	Torino	Piemonte	Torino	TO	10713
IT	10133	Cavoretto	Piemonte	Torino	TO	10714
IT	10133	Torino	Piemonte	Torino	TO	10715
IT	10134	Torino	Piemonte	Torino	TO	10716
IT	10135	Torino	Piemonte	Torino	TO	10717
IT	10136	Torino	Piemonte	Torino	TO	10718
IT	10137	Torino	Piemonte	Torino	TO	10719
IT	10138	Torino	Piemonte	Torino	TO	10720
IT	10139	Torino	Piemonte	Torino	TO	10721
IT	10141	Torino	Piemonte	Torino	TO	10722
IT	10142	Torino	Piemonte	Torino	TO	10723
IT	10143	Torino	Piemonte	Torino	TO	10724
IT	10144	Torino	Piemonte	Torino	TO	10725
IT	10145	Torino	Piemonte	Torino	TO	10726
IT	10146	Torino	Piemonte	Torino	TO	10727
IT	10147	Torino	Piemonte	Torino	TO	10728
IT	10148	Torino	Piemonte	Torino	TO	10729
IT	10149	Torino	Piemonte	Torino	TO	10730
IT	10151	Torino	Piemonte	Torino	TO	10731
IT	10152	Torino	Piemonte	Torino	TO	10732
IT	10153	Torino	Piemonte	Torino	TO	10733
IT	10154	Torino	Piemonte	Torino	TO	10734
IT	10155	Torino	Piemonte	Torino	TO	10735
IT	10156	Falchera	Piemonte	Torino	TO	10736
IT	10156	Bertolla Barca	Piemonte	Torino	TO	10737
IT	10156	Torino	Piemonte	Torino	TO	10738
IT	28801	Cossogno	Piemonte	Verbano-Cusio-Ossola	VB	10739
IT	28802	Mergozzo	Piemonte	Verbano-Cusio-Ossola	VB	10740
IT	28802	Albo	Piemonte	Verbano-Cusio-Ossola	VB	10741
IT	28803	Cuzzago	Piemonte	Verbano-Cusio-Ossola	VB	10742
IT	28803	Premosello Chiovenda	Piemonte	Verbano-Cusio-Ossola	VB	10743
IT	28804	Bieno	Piemonte	Verbano-Cusio-Ossola	VB	10744
IT	28804	San Bernardino Verbano	Piemonte	Verbano-Cusio-Ossola	VB	10745
IT	28805	Vogogna	Piemonte	Verbano-Cusio-Ossola	VB	10746
IT	28811	Cissano	Piemonte	Verbano-Cusio-Ossola	VB	10747
IT	28811	Arizzano	Piemonte	Verbano-Cusio-Ossola	VB	10748
IT	28811	Cresseglio	Piemonte	Verbano-Cusio-Ossola	VB	10749
IT	28812	Aurano	Piemonte	Verbano-Cusio-Ossola	VB	10750
IT	28813	Bee	Piemonte	Verbano-Cusio-Ossola	VB	10751
IT	28814	Cambiasca	Piemonte	Verbano-Cusio-Ossola	VB	10752
IT	28815	Caprezzo	Piemonte	Verbano-Cusio-Ossola	VB	10753
IT	28816	Intragna	Piemonte	Verbano-Cusio-Ossola	VB	10754
IT	28817	Miazzina	Piemonte	Verbano-Cusio-Ossola	VB	10755
IT	28818	Premeno	Piemonte	Verbano-Cusio-Ossola	VB	10756
IT	28819	Vignone	Piemonte	Verbano-Cusio-Ossola	VB	10757
IT	28821	Cannero Riviera	Piemonte	Verbano-Cusio-Ossola	VB	10758
IT	28822	Cannobio	Piemonte	Verbano-Cusio-Ossola	VB	10759
IT	28823	Ghiffa	Piemonte	Verbano-Cusio-Ossola	VB	10760
IT	28823	Susello	Piemonte	Verbano-Cusio-Ossola	VB	10761
IT	28823	Cargiago	Piemonte	Verbano-Cusio-Ossola	VB	10762
IT	28824	Oggebbio	Piemonte	Verbano-Cusio-Ossola	VB	10763
IT	28824	Gonte	Piemonte	Verbano-Cusio-Ossola	VB	10764
IT	28825	Ponte Di Falmenta	Piemonte	Verbano-Cusio-Ossola	VB	10765
IT	28825	Cavaglio Spoccia	Piemonte	Verbano-Cusio-Ossola	VB	10766
IT	28826	Trarego Viggiona	Piemonte	Verbano-Cusio-Ossola	VB	10767
IT	28827	Falmenta	Piemonte	Verbano-Cusio-Ossola	VB	10768
IT	28827	Cursolo Orasso	Piemonte	Verbano-Cusio-Ossola	VB	10769
IT	28827	Airetta	Piemonte	Verbano-Cusio-Ossola	VB	10770
IT	28828	Gurro	Piemonte	Verbano-Cusio-Ossola	VB	10771
IT	28831	Feriolo	Piemonte	Verbano-Cusio-Ossola	VB	10772
IT	28831	Baveno	Piemonte	Verbano-Cusio-Ossola	VB	10773
IT	28831	Feriolo Baveno	Piemonte	Verbano-Cusio-Ossola	VB	10774
IT	28832	Belgirate	Piemonte	Verbano-Cusio-Ossola	VB	10775
IT	28833	Brovello Carpugnino	Piemonte	Verbano-Cusio-Ossola	VB	10776
IT	28836	Vezzo	Piemonte	Verbano-Cusio-Ossola	VB	10777
IT	28836	Gignese	Piemonte	Verbano-Cusio-Ossola	VB	10778
IT	28838	Stresa	Piemonte	Verbano-Cusio-Ossola	VB	10779
IT	28838	Isola Bella	Piemonte	Verbano-Cusio-Ossola	VB	10780
IT	28838	Magognino	Piemonte	Verbano-Cusio-Ossola	VB	10781
IT	28838	Carciano	Piemonte	Verbano-Cusio-Ossola	VB	10782
IT	28838	Binda	Piemonte	Verbano-Cusio-Ossola	VB	10783
IT	28838	Levo	Piemonte	Verbano-Cusio-Ossola	VB	10784
IT	28841	Antronapiana	Piemonte	Verbano-Cusio-Ossola	VB	10785
IT	28841	Antrona Schieranco	Piemonte	Verbano-Cusio-Ossola	VB	10786
IT	28842	Bognanco	Piemonte	Verbano-Cusio-Ossola	VB	10787
IT	28842	Bognanco Fonti	Piemonte	Verbano-Cusio-Ossola	VB	10788
IT	28842	Fonti	Piemonte	Verbano-Cusio-Ossola	VB	10789
IT	28843	Montescheno	Piemonte	Verbano-Cusio-Ossola	VB	10790
IT	28844	Villadossola	Piemonte	Verbano-Cusio-Ossola	VB	10791
IT	28845	Domodossola	Piemonte	Verbano-Cusio-Ossola	VB	10792
IT	28846	Viganella	Piemonte	Verbano-Cusio-Ossola	VB	10793
IT	28846	Seppiana	Piemonte	Verbano-Cusio-Ossola	VB	10794
IT	28851	Beura	Piemonte	Verbano-Cusio-Ossola	VB	10795
IT	28851	Cuzzego	Piemonte	Verbano-Cusio-Ossola	VB	10796
IT	28851	Beura Cardezza	Piemonte	Verbano-Cusio-Ossola	VB	10797
IT	28852	Craveggia	Piemonte	Verbano-Cusio-Ossola	VB	10798
IT	28852	Vocogno	Piemonte	Verbano-Cusio-Ossola	VB	10799
IT	28853	Druogno	Piemonte	Verbano-Cusio-Ossola	VB	10800
IT	28854	Finero	Piemonte	Verbano-Cusio-Ossola	VB	10801
IT	28854	Malesco	Piemonte	Verbano-Cusio-Ossola	VB	10802
IT	28854	Zornasco	Piemonte	Verbano-Cusio-Ossola	VB	10803
IT	28855	Masera	Piemonte	Verbano-Cusio-Ossola	VB	10804
IT	28856	Re	Piemonte	Verbano-Cusio-Ossola	VB	10805
IT	28856	Villette	Piemonte	Verbano-Cusio-Ossola	VB	10806
IT	28857	Santa Maria Maggiore	Piemonte	Verbano-Cusio-Ossola	VB	10807
IT	28858	Toceno	Piemonte	Verbano-Cusio-Ossola	VB	10808
IT	28859	Trontano	Piemonte	Verbano-Cusio-Ossola	VB	10809
IT	28861	Baceno	Piemonte	Verbano-Cusio-Ossola	VB	10810
IT	28862	Crodo	Piemonte	Verbano-Cusio-Ossola	VB	10811
IT	28863	Formazza	Piemonte	Verbano-Cusio-Ossola	VB	10812
IT	28864	Roldo	Piemonte	Verbano-Cusio-Ossola	VB	10813
IT	28864	Montecrestese	Piemonte	Verbano-Cusio-Ossola	VB	10814
IT	28864	Pontetto	Piemonte	Verbano-Cusio-Ossola	VB	10815
IT	28865	Preglia	Piemonte	Verbano-Cusio-Ossola	VB	10816
IT	28865	Crevoladossola	Piemonte	Verbano-Cusio-Ossola	VB	10817
IT	28866	San Rocco	Piemonte	Verbano-Cusio-Ossola	VB	10818
IT	28866	Premia	Piemonte	Verbano-Cusio-Ossola	VB	10819
IT	28868	Iselle	Piemonte	Verbano-Cusio-Ossola	VB	10820
IT	28868	Trasquera	Piemonte	Verbano-Cusio-Ossola	VB	10821
IT	28868	Varzo	Piemonte	Verbano-Cusio-Ossola	VB	10822
IT	28871	Bannio Anzino	Piemonte	Verbano-Cusio-Ossola	VB	10823
IT	28873	Castiglione	Piemonte	Verbano-Cusio-Ossola	VB	10824
IT	28873	Castiglione D'Ossola	Piemonte	Verbano-Cusio-Ossola	VB	10825
IT	28873	Calasca Castiglione	Piemonte	Verbano-Cusio-Ossola	VB	10826
IT	28875	Ceppo Morelli	Piemonte	Verbano-Cusio-Ossola	VB	10827
IT	28876	Borca Di Macugnaga	Piemonte	Verbano-Cusio-Ossola	VB	10828
IT	28876	Pestarena	Piemonte	Verbano-Cusio-Ossola	VB	10829
IT	28876	Borca	Piemonte	Verbano-Cusio-Ossola	VB	10830
IT	28876	Macugnaga	Piemonte	Verbano-Cusio-Ossola	VB	10831
IT	28877	Ornavasso	Piemonte	Verbano-Cusio-Ossola	VB	10832
IT	28877	Anzola D'Ossola	Piemonte	Verbano-Cusio-Ossola	VB	10833
IT	28879	Vanzone Con San Carlo	Piemonte	Verbano-Cusio-Ossola	VB	10834
IT	28879	San Carlo	Piemonte	Verbano-Cusio-Ossola	VB	10835
IT	28881	Gabbio	Piemonte	Verbano-Cusio-Ossola	VB	10836
IT	28881	Cereda	Piemonte	Verbano-Cusio-Ossola	VB	10837
IT	28881	Casale Corte Cerro	Piemonte	Verbano-Cusio-Ossola	VB	10838
IT	28881	Ramate	Piemonte	Verbano-Cusio-Ossola	VB	10839
IT	28881	Sant'Anna	Piemonte	Verbano-Cusio-Ossola	VB	10840
IT	28881	Gabbio Con Monte Ossolano	Piemonte	Verbano-Cusio-Ossola	VB	10841
IT	28883	Gravellona Toce	Piemonte	Verbano-Cusio-Ossola	VB	10842
IT	28883	Pedemonte	Piemonte	Verbano-Cusio-Ossola	VB	10843
IT	28883	Granerolo	Piemonte	Verbano-Cusio-Ossola	VB	10844
IT	28884	Pallanzeno	Piemonte	Verbano-Cusio-Ossola	VB	10845
IT	28885	Piedimulera	Piemonte	Verbano-Cusio-Ossola	VB	10846
IT	28886	Pieve Vergonte	Piemonte	Verbano-Cusio-Ossola	VB	10847
IT	28887	Germagno	Piemonte	Verbano-Cusio-Ossola	VB	10848
IT	28887	Omegna	Piemonte	Verbano-Cusio-Ossola	VB	10849
IT	28887	Agrano	Piemonte	Verbano-Cusio-Ossola	VB	10850
IT	28887	Bagnella	Piemonte	Verbano-Cusio-Ossola	VB	10851
IT	28887	Cireggio	Piemonte	Verbano-Cusio-Ossola	VB	10852
IT	28887	Crusinallo	Piemonte	Verbano-Cusio-Ossola	VB	10853
IT	28891	Cesara	Piemonte	Verbano-Cusio-Ossola	VB	10854
IT	28891	Nonio	Piemonte	Verbano-Cusio-Ossola	VB	10855
IT	28893	Loreglia	Piemonte	Verbano-Cusio-Ossola	VB	10856
IT	28894	Madonna Del Sasso	Piemonte	Verbano-Cusio-Ossola	VB	10857
IT	28895	Forno Di Omegna	Piemonte	Verbano-Cusio-Ossola	VB	10858
IT	28895	Massiola	Piemonte	Verbano-Cusio-Ossola	VB	10859
IT	28896	Quarna Sotto	Piemonte	Verbano-Cusio-Ossola	VB	10860
IT	28897	Sambughetto	Piemonte	Verbano-Cusio-Ossola	VB	10861
IT	28897	Luzzogno	Piemonte	Verbano-Cusio-Ossola	VB	10862
IT	28897	Fornero	Piemonte	Verbano-Cusio-Ossola	VB	10863
IT	28897	Valstrona	Piemonte	Verbano-Cusio-Ossola	VB	10864
IT	28898	Quarna Sopra	Piemonte	Verbano-Cusio-Ossola	VB	10865
IT	28899	Arola	Piemonte	Verbano-Cusio-Ossola	VB	10866
IT	28922	Verbania	Piemonte	Verbano-Cusio-Ossola	VB	10867
IT	13010	Guardabosone	Piemonte	Vercelli	VC	10868
IT	13010	Pezzana	Piemonte	Vercelli	VC	10869
IT	13010	Stroppiana	Piemonte	Vercelli	VC	10870
IT	13010	Civiasco	Piemonte	Vercelli	VC	10871
IT	13010	Postua	Piemonte	Vercelli	VC	10872
IT	13010	Villata	Piemonte	Vercelli	VC	10873
IT	13010	Motta De' Conti	Piemonte	Vercelli	VC	10874
IT	13010	Caresana	Piemonte	Vercelli	VC	10875
IT	13011	Isolella	Piemonte	Vercelli	VC	10876
IT	13011	Borgosesia	Piemonte	Vercelli	VC	10877
IT	13011	Bettole Sesia	Piemonte	Vercelli	VC	10878
IT	13012	Borgo Vercelli	Piemonte	Vercelli	VC	10879
IT	13012	Prarolo	Piemonte	Vercelli	VC	10880
IT	13017	Quarona	Piemonte	Vercelli	VC	10881
IT	13017	Doccio	Piemonte	Vercelli	VC	10882
IT	13018	Zuccaro	Piemonte	Vercelli	VC	10883
IT	13018	Valduggia	Piemonte	Vercelli	VC	10884
IT	13019	Morca	Piemonte	Vercelli	VC	10885
IT	13019	Valmaggia	Piemonte	Vercelli	VC	10886
IT	13019	Varallo	Piemonte	Vercelli	VC	10887
IT	13019	Roccapietra	Piemonte	Vercelli	VC	10888
IT	13020	Ferrera	Piemonte	Vercelli	VC	10889
IT	13020	Riva Valdobbia	Piemonte	Vercelli	VC	10890
IT	13020	Rimella	Piemonte	Vercelli	VC	10891
IT	13020	Cravagliana	Piemonte	Vercelli	VC	10892
IT	13020	Piode	Piemonte	Vercelli	VC	10893
IT	13020	Ca' Di Ianzo	Piemonte	Vercelli	VC	10894
IT	13020	Mollia	Piemonte	Vercelli	VC	10895
IT	13020	Rossa	Piemonte	Vercelli	VC	10896
IT	13020	Balmuccia	Piemonte	Vercelli	VC	10897
IT	13020	Rassa	Piemonte	Vercelli	VC	10898
IT	13020	Breia	Piemonte	Vercelli	VC	10899
IT	13020	Vocca	Piemonte	Vercelli	VC	10900
IT	13020	Sabbia	Piemonte	Vercelli	VC	10901
IT	13020	Pila	Piemonte	Vercelli	VC	10902
IT	13021	Alagna Valsesia	Piemonte	Vercelli	VC	10903
IT	13022	Boccioleto	Piemonte	Vercelli	VC	10904
IT	13022	Fervento	Piemonte	Vercelli	VC	10905
IT	13023	Campertogno	Piemonte	Vercelli	VC	10906
IT	13024	Cellio	Piemonte	Vercelli	VC	10907
IT	13025	Fobello	Piemonte	Vercelli	VC	10908
IT	13025	Cervatto	Piemonte	Vercelli	VC	10909
IT	13026	Carcoforo	Piemonte	Vercelli	VC	10910
IT	13026	Rima San Giuseppe	Piemonte	Vercelli	VC	10911
IT	13026	Rimasco	Piemonte	Vercelli	VC	10912
IT	13027	Scopa	Piemonte	Vercelli	VC	10913
IT	13028	Scopello	Piemonte	Vercelli	VC	10914
IT	13030	San Giacomo Vercellese	Piemonte	Vercelli	VC	10915
IT	13030	Greggio	Piemonte	Vercelli	VC	10916
IT	13030	Oldenico	Piemonte	Vercelli	VC	10917
IT	13030	Rive	Piemonte	Vercelli	VC	10918
IT	13030	Quinto Vercellese	Piemonte	Vercelli	VC	10919
IT	13030	Casanova Elvo	Piemonte	Vercelli	VC	10920
IT	13030	Villarboit	Piemonte	Vercelli	VC	10921
IT	13030	Albano Vercellese	Piemonte	Vercelli	VC	10922
IT	13030	Ghislarengo	Piemonte	Vercelli	VC	10923
IT	13030	Formigliana	Piemonte	Vercelli	VC	10924
IT	13030	Pertengo	Piemonte	Vercelli	VC	10925
IT	13030	Collobiano	Piemonte	Vercelli	VC	10926
IT	13030	Caresanablot	Piemonte	Vercelli	VC	10927
IT	13031	Arborio	Piemonte	Vercelli	VC	10928
IT	13032	Asigliano Vercellese	Piemonte	Vercelli	VC	10929
IT	13033	Costanzana	Piemonte	Vercelli	VC	10930
IT	13034	Lignana	Piemonte	Vercelli	VC	10931
IT	13034	Desana	Piemonte	Vercelli	VC	10932
IT	13035	Lenta	Piemonte	Vercelli	VC	10933
IT	13036	Ronsecco	Piemonte	Vercelli	VC	10934
IT	13037	Vintebbio	Piemonte	Vercelli	VC	10935
IT	13037	Serravalle Sesia	Piemonte	Vercelli	VC	10936
IT	13037	Bornate Sesia	Piemonte	Vercelli	VC	10937
IT	13038	Tricerro	Piemonte	Vercelli	VC	10938
IT	13039	Trino	Piemonte	Vercelli	VC	10939
IT	13040	Carisio	Piemonte	Vercelli	VC	10940
IT	13040	Balocco	Piemonte	Vercelli	VC	10941
IT	13040	Sant'Antonino	Piemonte	Vercelli	VC	10942
IT	13040	Salasco	Piemonte	Vercelli	VC	10943
IT	13040	Buronzo	Piemonte	Vercelli	VC	10944
IT	13040	Saluggia	Piemonte	Vercelli	VC	10945
IT	13040	Sali Vercellese	Piemonte	Vercelli	VC	10946
IT	13040	Alice Castello	Piemonte	Vercelli	VC	10947
IT	13040	Rovasenda	Piemonte	Vercelli	VC	10948
IT	13040	Moncrivello	Piemonte	Vercelli	VC	10949
IT	13040	Borgo D'Ale	Piemonte	Vercelli	VC	10950
IT	13040	Palazzolo Vercellese	Piemonte	Vercelli	VC	10951
IT	13040	Crova	Piemonte	Vercelli	VC	10952
IT	13040	Fontanetto Po	Piemonte	Vercelli	VC	10953
IT	13040	Fornace Crocicchio	Piemonte	Vercelli	VC	10954
IT	13041	Bianze'	Piemonte	Vercelli	VC	10955
IT	13043	Cigliano	Piemonte	Vercelli	VC	10956
IT	13044	San Genuario	Piemonte	Vercelli	VC	10957
IT	13044	Crescentino	Piemonte	Vercelli	VC	10958
IT	13044	San Silvestro	Piemonte	Vercelli	VC	10959
IT	13045	Lozzolo	Piemonte	Vercelli	VC	10960
IT	13045	Gattinara	Piemonte	Vercelli	VC	10961
IT	13046	Livorno Ferraris	Piemonte	Vercelli	VC	10962
IT	13046	Lamporo	Piemonte	Vercelli	VC	10963
IT	13047	San Germano Vercellese	Piemonte	Vercelli	VC	10964
IT	13047	Olcenengo	Piemonte	Vercelli	VC	10965
IT	13048	Santhia'	Piemonte	Vercelli	VC	10966
IT	13049	Tronzano Vercellese	Piemonte	Vercelli	VC	10967
IT	13060	Sant'Eusebio	Piemonte	Vercelli	VC	10968
IT	13060	Roasio	Piemonte	Vercelli	VC	10969
IT	13060	San Maurizio	Piemonte	Vercelli	VC	10970
IT	13100	Cappuccini	Piemonte	Vercelli	VC	10971
IT	13100	Larizzate	Piemonte	Vercelli	VC	10972
IT	13100	Vercelli	Piemonte	Vercelli	VC	10973
IT	13100	Prarolo	Piemonte	Vercelli	VC	10974
IT	13100	Brarola	Piemonte	Vercelli	VC	10975
IT	13100	Lignana	Piemonte	Vercelli	VC	10976
IT	70010	Adelfia	Puglia	Bari	BA	10977
IT	70010	Adelfia Montrone	Puglia	Bari	BA	10978
IT	70010	Trito	Puglia	Bari	BA	10979
IT	70010	Capurso	Puglia	Bari	BA	10980
IT	70010	Locorotondo	Puglia	Bari	BA	10981
IT	70010	Valenzano	Puglia	Bari	BA	10982
IT	70010	San Marco	Puglia	Bari	BA	10983
IT	70010	Casamassima	Puglia	Bari	BA	10984
IT	70010	Cellamare	Puglia	Bari	BA	10985
IT	70010	Adelfia Canneto	Puglia	Bari	BA	10986
IT	70010	Turi	Puglia	Bari	BA	10987
IT	70010	Sammichele Di Bari	Puglia	Bari	BA	10988
IT	70010	Superga	Puglia	Bari	BA	10989
IT	70011	Alberobello	Puglia	Bari	BA	10990
IT	70011	Coreggia	Puglia	Bari	BA	10991
IT	70013	Castellana Grotte	Puglia	Bari	BA	10992
IT	70014	Conversano	Puglia	Bari	BA	10993
IT	70014	Triggianello	Puglia	Bari	BA	10994
IT	70015	Lamadacqua	Puglia	Bari	BA	10995
IT	70015	Noci	Puglia	Bari	BA	10996
IT	70016	Noicattaro	Puglia	Bari	BA	10997
IT	70016	Parchitello	Puglia	Bari	BA	10998
IT	70016	Parco Scizzo	Puglia	Bari	BA	10999
IT	70017	San Michele In Monte Laureto	Puglia	Bari	BA	11000
IT	70017	Putignano	Puglia	Bari	BA	11001
IT	70017	San Pietro Piturno	Puglia	Bari	BA	11002
IT	70018	Rutigliano	Puglia	Bari	BA	11003
IT	70019	Triggiano	Puglia	Bari	BA	11004
IT	70020	Toritto	Puglia	Bari	BA	11005
IT	70020	Bitetto	Puglia	Bari	BA	11006
IT	70020	Cassano Delle Murge	Puglia	Bari	BA	11007
IT	70020	Poggiorsini	Puglia	Bari	BA	11008
IT	70020	Binetto	Puglia	Bari	BA	11009
IT	70020	Bitritto	Puglia	Bari	BA	11010
IT	70021	Acquaviva Delle Fonti	Puglia	Bari	BA	11011
IT	70022	Altamura	Puglia	Bari	BA	11012
IT	70022	Parisi	Puglia	Bari	BA	11013
IT	70022	Curtaniello	Puglia	Bari	BA	11014
IT	70023	Murgia	Puglia	Bari	BA	11015
IT	70023	Gioia Del Colle	Puglia	Bari	BA	11016
IT	70024	Dolcecanto	Puglia	Bari	BA	11017
IT	70024	Gravina In Puglia	Puglia	Bari	BA	11018
IT	70024	Murgetta	Puglia	Bari	BA	11019
IT	70024	La Murgetta	Puglia	Bari	BA	11020
IT	70025	Grumo Appula	Puglia	Bari	BA	11021
IT	70026	Modugno	Puglia	Bari	BA	11022
IT	70027	Palo Del Colle	Puglia	Bari	BA	11023
IT	70028	Sannicandro Di Bari	Puglia	Bari	BA	11024
IT	70029	Santeramo In Colle	Puglia	Bari	BA	11025
IT	70032	Bitonto	Puglia	Bari	BA	11026
IT	70032	Mariotto	Puglia	Bari	BA	11027
IT	70032	Palombaio	Puglia	Bari	BA	11028
IT	70033	Corato	Puglia	Bari	BA	11029
IT	70037	Ruvo Di Puglia	Puglia	Bari	BA	11030
IT	70038	Terlizzi	Puglia	Bari	BA	11031
IT	70042	Mola Di Bari	Puglia	Bari	BA	11032
IT	70042	Cozze	Puglia	Bari	BA	11033
IT	70042	San Maderno	Puglia	Bari	BA	11034
IT	70043	Monopoli	Puglia	Bari	BA	11035
IT	70043	Sant'Antonio D'Ascula	Puglia	Bari	BA	11036
IT	70043	Lamalunga	Puglia	Bari	BA	11037
IT	70043	Impalata	Puglia	Bari	BA	11038
IT	70043	Antonelli	Puglia	Bari	BA	11039
IT	70043	Gorgofreddo	Puglia	Bari	BA	11040
IT	70043	Santa Lucia	Puglia	Bari	BA	11041
IT	70043	Cozzana	Puglia	Bari	BA	11042
IT	70044	Polignano A Mare	Puglia	Bari	BA	11043
IT	70054	Giovinazzo	Puglia	Bari	BA	11044
IT	70056	Molfetta	Puglia	Bari	BA	11045
IT	70100	Bari	Puglia	Bari	BA	11046
IT	70121	Bari	Puglia	Bari	BA	11047
IT	70122	Bari	Puglia	Bari	BA	11048
IT	70123	San Paolo	Puglia	Bari	BA	11049
IT	70123	Fesca	Puglia	Bari	BA	11050
IT	70123	Bari	Puglia	Bari	BA	11051
IT	70123	San Girolamo	Puglia	Bari	BA	11052
IT	70123	San Francesco Dell'Arena	Puglia	Bari	BA	11053
IT	70123	Stanic	Puglia	Bari	BA	11054
IT	70123	San Cataldo	Puglia	Bari	BA	11055
IT	70124	Bari	Puglia	Bari	BA	11056
IT	70124	Poggio Franco	Puglia	Bari	BA	11057
IT	70124	Picone	Puglia	Bari	BA	11058
IT	70125	Bari	Puglia	Bari	BA	11059
IT	70125	San Pasquale	Puglia	Bari	BA	11060
IT	70125	Carrassi	Puglia	Bari	BA	11061
IT	70126	Torre A Mare	Puglia	Bari	BA	11062
IT	70126	Bari	Puglia	Bari	BA	11063
IT	70126	Japigia	Puglia	Bari	BA	11064
IT	70126	Mungivacca	Puglia	Bari	BA	11065
IT	70127	Santo Spirito	Puglia	Bari	BA	11066
IT	70128	Palese	Puglia	Bari	BA	11067
IT	70129	Ceglie Del Campo	Puglia	Bari	BA	11068
IT	70129	Loseto	Puglia	Bari	BA	11069
IT	70131	Carbonara Di Bari	Puglia	Bari	BA	11070
IT	72012	Carovigno	Puglia	Brindisi	BR	11071
IT	72012	Serranova Di Carovigno	Puglia	Brindisi	BR	11072
IT	72012	Serranova	Puglia	Brindisi	BR	11073
IT	72013	Ceglie Messapica	Puglia	Brindisi	BR	11074
IT	72014	Caranna	Puglia	Brindisi	BR	11075
IT	72014	Cisternino	Puglia	Brindisi	BR	11076
IT	72014	Casalini	Puglia	Brindisi	BR	11077
IT	72015	Savelletri	Puglia	Brindisi	BR	11078
IT	72015	Torre Canne	Puglia	Brindisi	BR	11079
IT	72015	Pezze Di Greco	Puglia	Brindisi	BR	11080
IT	72015	Stazione Di Fasano	Puglia	Brindisi	BR	11081
IT	72015	Fasano	Puglia	Brindisi	BR	11082
IT	72015	Selva	Puglia	Brindisi	BR	11083
IT	72015	Montalbano	Puglia	Brindisi	BR	11084
IT	72015	Lamie Di Olimpie	Puglia	Brindisi	BR	11085
IT	72015	Selva Di Fasano	Puglia	Brindisi	BR	11086
IT	72015	Madonna Pozzo Guacito	Puglia	Brindisi	BR	11087
IT	72015	Marina Di Savelletri	Puglia	Brindisi	BR	11088
IT	72016	Pozzo Guacito	Puglia	Brindisi	BR	11089
IT	72016	Montalbano Di Fasano	Puglia	Brindisi	BR	11090
IT	72017	Ostuni	Puglia	Brindisi	BR	11091
IT	72018	San Michele Salentino	Puglia	Brindisi	BR	11092
IT	72019	San Vito Dei Normanni	Puglia	Brindisi	BR	11093
IT	72020	Torchiarolo	Puglia	Brindisi	BR	11094
IT	72020	Tuturano	Puglia	Brindisi	BR	11095
IT	72020	Cellino San Marco	Puglia	Brindisi	BR	11096
IT	72020	Erchie	Puglia	Brindisi	BR	11097
IT	72021	Capece	Puglia	Brindisi	BR	11098
IT	72021	Francavilla Fontana	Puglia	Brindisi	BR	11099
IT	72021	Capece Bax	Puglia	Brindisi	BR	11100
IT	72022	Latiano	Puglia	Brindisi	BR	11101
IT	72023	Mesagne	Puglia	Brindisi	BR	11102
IT	72024	Oria	Puglia	Brindisi	BR	11103
IT	72024	San Cosimo	Puglia	Brindisi	BR	11104
IT	72024	San Cosimo Alla Macchia	Puglia	Brindisi	BR	11105
IT	72025	San Donaci	Puglia	Brindisi	BR	11106
IT	72026	San Pancrazio Salentino	Puglia	Brindisi	BR	11107
IT	72027	San Pietro Vernotico	Puglia	Brindisi	BR	11108
IT	72028	Torre Santa Susanna	Puglia	Brindisi	BR	11109
IT	72029	Villa Castelli	Puglia	Brindisi	BR	11110
IT	72100	Brindisi	Puglia	Brindisi	BR	11111
IT	72100	Brindisi Casale	Puglia	Brindisi	BR	11112
IT	76011	Bisceglie	Puglia	Barletta-Andria-Trani	BT	11113
IT	76012	Canosa Di Puglia	Puglia	Barletta-Andria-Trani	BT	11114
IT	76012	Loconia	Puglia	Barletta-Andria-Trani	BT	11115
IT	76013	Minervino Murge	Puglia	Barletta-Andria-Trani	BT	11116
IT	76014	Spinazzola	Puglia	Barletta-Andria-Trani	BT	11117
IT	76015	Trinitapoli	Puglia	Barletta-Andria-Trani	BT	11118
IT	76016	Margherita Di Savoia	Puglia	Barletta-Andria-Trani	BT	11119
IT	76017	San Ferdinando Di Puglia	Puglia	Barletta-Andria-Trani	BT	11120
IT	76121	Barletta	Puglia	Barletta-Andria-Trani	BT	11121
IT	76123	Andria	Puglia	Barletta-Andria-Trani	BT	11122
IT	76123	Montegrosso	Puglia	Barletta-Andria-Trani	BT	11123
IT	76125	Trani	Puglia	Barletta-Andria-Trani	BT	11124
IT	71010	Ischitella	Puglia	Foggia	FG	11125
IT	71010	Serracapriola	Puglia	Foggia	FG	11126
IT	71010	Lesina	Puglia	Foggia	FG	11127
IT	71010	San Paolo Di Civitate	Puglia	Foggia	FG	11128
IT	71010	Rignano Garganico	Puglia	Foggia	FG	11129
IT	71010	Chieuti	Puglia	Foggia	FG	11130
IT	71010	Ripalta	Puglia	Foggia	FG	11131
IT	71010	Carpino	Puglia	Foggia	FG	11132
IT	71010	Cagnano Varano	Puglia	Foggia	FG	11133
IT	71010	Poggio Imperiale	Puglia	Foggia	FG	11134
IT	71010	Foce Varano	Puglia	Foggia	FG	11135
IT	71010	Peschici	Puglia	Foggia	FG	11136
IT	71010	Chieuti Scalo	Puglia	Foggia	FG	11137
IT	71010	Difensola	Puglia	Foggia	FG	11138
IT	71011	Apricena	Puglia	Foggia	FG	11139
IT	71012	Rodi Garganico	Puglia	Foggia	FG	11140
IT	71013	San Giovanni Rotondo	Puglia	Foggia	FG	11141
IT	71013	Matine	Puglia	Foggia	FG	11142
IT	71014	San Marco In Lamis	Puglia	Foggia	FG	11143
IT	71014	Borgo Celano	Puglia	Foggia	FG	11144
IT	71015	San Nicandro Garganico	Puglia	Foggia	FG	11145
IT	71016	San Severo	Puglia	Foggia	FG	11146
IT	71017	Torremaggiore	Puglia	Foggia	FG	11147
IT	71017	Petrulli	Puglia	Foggia	FG	11148
IT	71018	Vico Del Gargano	Puglia	Foggia	FG	11149
IT	71018	Umbra	Puglia	Foggia	FG	11150
IT	71018	San Menaio	Puglia	Foggia	FG	11151
IT	71019	Vieste	Puglia	Foggia	FG	11152
IT	71020	Anzano Di Puglia	Puglia	Foggia	FG	11153
IT	71020	Monteleone Di Puglia	Puglia	Foggia	FG	11154
IT	71020	Celle Di San Vito	Puglia	Foggia	FG	11155
IT	71020	Rocchetta Sant'Antonio	Puglia	Foggia	FG	11156
IT	71020	Panni	Puglia	Foggia	FG	11157
IT	71020	Castelluccio Valmaggiore	Puglia	Foggia	FG	11158
IT	71020	Faeto	Puglia	Foggia	FG	11159
IT	71020	Rocchetta Sant'Antonio Stazione	Puglia	Foggia	FG	11160
IT	71021	Accadia	Puglia	Foggia	FG	11161
IT	71022	Ascoli Satriano	Puglia	Foggia	FG	11162
IT	71022	San Carlo	Puglia	Foggia	FG	11163
IT	71022	San Carlo D'Ascoli	Puglia	Foggia	FG	11164
IT	71023	Bovino	Puglia	Foggia	FG	11165
IT	71024	Candela	Puglia	Foggia	FG	11166
IT	71025	Castelluccio Dei Sauri	Puglia	Foggia	FG	11167
IT	71026	Deliceto	Puglia	Foggia	FG	11168
IT	71027	Orsara Di Puglia	Puglia	Foggia	FG	11169
IT	71028	Sant'Agata Di Puglia	Puglia	Foggia	FG	11170
IT	71029	Borgo Giardinetto	Puglia	Foggia	FG	11171
IT	71029	Troia	Puglia	Foggia	FG	11172
IT	71030	Casalvecchio Di Puglia	Puglia	Foggia	FG	11173
IT	71030	Volturino	Puglia	Foggia	FG	11174
IT	71030	Volturara Appula	Puglia	Foggia	FG	11175
IT	71030	Zapponeta	Puglia	Foggia	FG	11176
IT	71030	Carlantino	Puglia	Foggia	FG	11177
IT	71030	Mattinata	Puglia	Foggia	FG	11178
IT	71030	Macchia	Puglia	Foggia	FG	11179
IT	71030	San Marco La Catola	Puglia	Foggia	FG	11180
IT	71030	Motta Montecorvino	Puglia	Foggia	FG	11181
IT	71030	Fonterosa	Puglia	Foggia	FG	11182
IT	71031	Alberona	Puglia	Foggia	FG	11183
IT	71032	Berardinone	Puglia	Foggia	FG	11184
IT	71032	Biccari	Puglia	Foggia	FG	11185
IT	71033	Casalnuovo Monterotaro	Puglia	Foggia	FG	11186
IT	71034	Castelnuovo Della Daunia	Puglia	Foggia	FG	11187
IT	71035	Celenza Valfortore	Puglia	Foggia	FG	11188
IT	71036	Lucera	Puglia	Foggia	FG	11189
IT	71036	Palmori	Puglia	Foggia	FG	11190
IT	71037	Monte Sant'Angelo	Puglia	Foggia	FG	11191
IT	71038	Pietramontecorvino	Puglia	Foggia	FG	11192
IT	71039	Roseto Valfortore	Puglia	Foggia	FG	11193
IT	71040	Ordona	Puglia	Foggia	FG	11194
IT	71040	San Nicola	Puglia	Foggia	FG	11195
IT	71040	Mezzanone	Puglia	Foggia	FG	11196
IT	71040	Borgata Mezzanone	Puglia	Foggia	FG	11197
IT	71040	San Domino	Puglia	Foggia	FG	11198
IT	71040	San Nicola Di Tremiti	Puglia	Foggia	FG	11199
IT	71040	Isole Tremiti	Puglia	Foggia	FG	11200
IT	71041	Carapelle	Puglia	Foggia	FG	11201
IT	71042	Tressanti	Puglia	Foggia	FG	11202
IT	71042	Cerignola	Puglia	Foggia	FG	11203
IT	71042	Borgo Liberta'	Puglia	Foggia	FG	11204
IT	71042	Moschella	Puglia	Foggia	FG	11205
IT	71042	La Moschella	Puglia	Foggia	FG	11206
IT	71042	Borgo Tressanti	Puglia	Foggia	FG	11207
IT	71043	Siponto	Puglia	Foggia	FG	11208
IT	71043	Manfredonia	Puglia	Foggia	FG	11209
IT	71045	Orta Nova	Puglia	Foggia	FG	11210
IT	71047	Stornara	Puglia	Foggia	FG	11211
IT	71048	Stornarella	Puglia	Foggia	FG	11212
IT	71100	Tavernola	Puglia	Foggia	FG	11213
IT	71100	Borgo Incoronata	Puglia	Foggia	FG	11214
IT	71100	Incoronata	Puglia	Foggia	FG	11215
IT	71100	Foggia	Puglia	Foggia	FG	11216
IT	71100	Cervaro	Puglia	Foggia	FG	11217
IT	71100	Arpinova	Puglia	Foggia	FG	11218
IT	71100	Rignano Garganico Scalo	Puglia	Foggia	FG	11219
IT	71100	Segezia	Puglia	Foggia	FG	11220
IT	71100	Borgo Cervaro	Puglia	Foggia	FG	11221
IT	73010	Zollino	Puglia	Lecce	LE	11222
IT	73010	Dragoni	Puglia	Lecce	LE	11223
IT	73010	Torre Lapillo	Puglia	Lecce	LE	11224
IT	73010	Guagnano	Puglia	Lecce	LE	11225
IT	73010	Surbo	Puglia	Lecce	LE	11226
IT	73010	Veglie	Puglia	Lecce	LE	11227
IT	73010	Galugnano	Puglia	Lecce	LE	11228
IT	73010	San Donato Di Lecce	Puglia	Lecce	LE	11229
IT	73010	Arnesano	Puglia	Lecce	LE	11230
IT	73010	Soleto	Puglia	Lecce	LE	11231
IT	73010	Riesci	Puglia	Lecce	LE	11232
IT	73010	Lequile	Puglia	Lecce	LE	11233
IT	73010	Caprarica Di Lecce	Puglia	Lecce	LE	11234
IT	73010	Villa Baldassarri	Puglia	Lecce	LE	11235
IT	73010	San Pietro In Lama	Puglia	Lecce	LE	11236
IT	73010	Sogliano Cavour	Puglia	Lecce	LE	11237
IT	73010	Porto Cesareo	Puglia	Lecce	LE	11238
IT	73010	Sternatia	Puglia	Lecce	LE	11239
IT	73011	Alezio	Puglia	Lecce	LE	11240
IT	73012	Campi Salentina	Puglia	Lecce	LE	11241
IT	73013	Noha	Puglia	Lecce	LE	11242
IT	73013	Santa Barbara	Puglia	Lecce	LE	11243
IT	73013	Galatina	Puglia	Lecce	LE	11244
IT	73013	Collemeto	Puglia	Lecce	LE	11245
IT	73014	Gallipoli	Puglia	Lecce	LE	11246
IT	73015	Salice Salentino	Puglia	Lecce	LE	11247
IT	73016	San Cesario Di Lecce	Puglia	Lecce	LE	11248
IT	73017	Lido Conchiglie	Puglia	Lecce	LE	11249
IT	73017	Chiesanuova	Puglia	Lecce	LE	11250
IT	73017	Sannicola	Puglia	Lecce	LE	11251
IT	73017	San Simone	Puglia	Lecce	LE	11252
IT	73018	Squinzano	Puglia	Lecce	LE	11253
IT	73019	Trepuzzi	Puglia	Lecce	LE	11254
IT	73020	Vitigliano	Puglia	Lecce	LE	11255
IT	73020	San Cassiano	Puglia	Lecce	LE	11256
IT	73020	Nociglia	Puglia	Lecce	LE	11257
IT	73020	Cavallino	Puglia	Lecce	LE	11258
IT	73020	Carpignano Salentino	Puglia	Lecce	LE	11259
IT	73020	Melpignano	Puglia	Lecce	LE	11260
IT	73020	Uggiano La Chiesa	Puglia	Lecce	LE	11261
IT	73020	Santa Cesarea Terme	Puglia	Lecce	LE	11262
IT	73020	Cerfignano	Puglia	Lecce	LE	11263
IT	73020	Cutrofiano	Puglia	Lecce	LE	11264
IT	73020	Cannole	Puglia	Lecce	LE	11265
IT	73020	Scorrano	Puglia	Lecce	LE	11266
IT	73020	Castromediano	Puglia	Lecce	LE	11267
IT	73020	Martignano	Puglia	Lecce	LE	11268
IT	73020	Bagnolo Del Salento	Puglia	Lecce	LE	11269
IT	73020	Palmariggi	Puglia	Lecce	LE	11270
IT	73020	Giurdignano	Puglia	Lecce	LE	11271
IT	73020	Castri Di Lecce	Puglia	Lecce	LE	11272
IT	73020	Botrugno	Puglia	Lecce	LE	11273
IT	73020	Casamassella	Puglia	Lecce	LE	11274
IT	73020	Serrano	Puglia	Lecce	LE	11275
IT	73020	Cursi	Puglia	Lecce	LE	11276
IT	73020	Castrignano De' Greci	Puglia	Lecce	LE	11277
IT	73021	Calimera	Puglia	Lecce	LE	11278
IT	73022	Corigliano D'Otranto	Puglia	Lecce	LE	11279
IT	73023	Merine	Puglia	Lecce	LE	11280
IT	73023	Lizzanello	Puglia	Lecce	LE	11281
IT	73024	Morigino	Puglia	Lecce	LE	11282
IT	73024	Maglie	Puglia	Lecce	LE	11283
IT	73025	Martano	Puglia	Lecce	LE	11284
IT	73026	Rocca Vecchia	Puglia	Lecce	LE	11285
IT	73026	Torre Dell'Orso	Puglia	Lecce	LE	11286
IT	73026	Borgagne	Puglia	Lecce	LE	11287
IT	73026	San Foca	Puglia	Lecce	LE	11288
IT	73026	Roca	Puglia	Lecce	LE	11289
IT	73026	Melendugno	Puglia	Lecce	LE	11290
IT	73027	Minervino Di Lecce	Puglia	Lecce	LE	11291
IT	73027	Cocumola	Puglia	Lecce	LE	11292
IT	73027	Specchia Gallone	Puglia	Lecce	LE	11293
IT	73028	Otranto	Puglia	Lecce	LE	11294
IT	73029	Vernole	Puglia	Lecce	LE	11295
IT	73029	Pisignano	Puglia	Lecce	LE	11296
IT	73029	Vanze	Puglia	Lecce	LE	11297
IT	73029	Acaia	Puglia	Lecce	LE	11298
IT	73029	Acquarica Di Lecce	Puglia	Lecce	LE	11299
IT	73029	Struda'	Puglia	Lecce	LE	11300
IT	73030	Ortelle	Puglia	Lecce	LE	11301
IT	73030	Diso	Puglia	Lecce	LE	11302
IT	73030	Giuggianello	Puglia	Lecce	LE	11303
IT	73030	Sanarica	Puglia	Lecce	LE	11304
IT	73030	Surano	Puglia	Lecce	LE	11305
IT	73030	Vignacastrisi	Puglia	Lecce	LE	11306
IT	73030	Tiggiano	Puglia	Lecce	LE	11307
IT	73030	Marittima	Puglia	Lecce	LE	11308
IT	73030	Castro Marina	Puglia	Lecce	LE	11309
IT	73030	Montesano Salentino	Puglia	Lecce	LE	11310
IT	73031	Alessano	Puglia	Lecce	LE	11311
IT	73031	Montesardo	Puglia	Lecce	LE	11312
IT	73032	Castiglione	Puglia	Lecce	LE	11313
IT	73032	Andrano	Puglia	Lecce	LE	11314
IT	73033	Corsano	Puglia	Lecce	LE	11315
IT	73034	Arigliano	Puglia	Lecce	LE	11316
IT	73034	San Dana	Puglia	Lecce	LE	11317
IT	73034	Gagliano Del Capo	Puglia	Lecce	LE	11318
IT	73035	Miggiano	Puglia	Lecce	LE	11319
IT	73036	Muro Leccese	Puglia	Lecce	LE	11320
IT	73037	Poggiardo	Puglia	Lecce	LE	11321
IT	73037	Vaste	Puglia	Lecce	LE	11322
IT	73038	Spongano	Puglia	Lecce	LE	11323
IT	73039	Lucugnano	Puglia	Lecce	LE	11324
IT	73039	Caprarica Del Capo	Puglia	Lecce	LE	11325
IT	73039	Depressa	Puglia	Lecce	LE	11326
IT	73039	Sant'Eufemia	Puglia	Lecce	LE	11327
IT	73039	Tricase	Puglia	Lecce	LE	11328
IT	73039	Tricase Porto	Puglia	Lecce	LE	11329
IT	73039	Tutino	Puglia	Lecce	LE	11330
IT	73040	Collepasso	Puglia	Lecce	LE	11331
IT	73040	Acquarica Del Capo	Puglia	Lecce	LE	11332
IT	73040	Melissano	Puglia	Lecce	LE	11333
IT	73040	Specchia	Puglia	Lecce	LE	11334
IT	73040	Supersano	Puglia	Lecce	LE	11335
IT	73040	Barbarano Del Capo	Puglia	Lecce	LE	11336
IT	73040	Morciano Di Leuca	Puglia	Lecce	LE	11337
IT	73040	Neviano	Puglia	Lecce	LE	11338
IT	73040	Leuca	Puglia	Lecce	LE	11339
IT	73040	Salignano	Puglia	Lecce	LE	11340
IT	73040	Giuliano Di Lecce	Puglia	Lecce	LE	11341
IT	73040	Castrignano Del Capo	Puglia	Lecce	LE	11342
IT	73040	Aradeo	Puglia	Lecce	LE	11343
IT	73040	Marina Di Leuca	Puglia	Lecce	LE	11344
IT	73040	Alliste	Puglia	Lecce	LE	11345
IT	73040	Felline	Puglia	Lecce	LE	11346
IT	73041	Carmiano	Puglia	Lecce	LE	11347
IT	73041	Magliano	Puglia	Lecce	LE	11348
IT	73042	Casarano	Puglia	Lecce	LE	11349
IT	73043	Copertino	Puglia	Lecce	LE	11350
IT	73044	Galatone	Puglia	Lecce	LE	11351
IT	73045	Leverano	Puglia	Lecce	LE	11352
IT	73046	Matino	Puglia	Lecce	LE	11353
IT	73047	Monteroni Di Lecce	Puglia	Lecce	LE	11354
IT	73048	Nardo'	Puglia	Lecce	LE	11355
IT	73049	Ruffano	Puglia	Lecce	LE	11356
IT	73049	Torrepaduli	Puglia	Lecce	LE	11357
IT	73050	Santa Caterina	Puglia	Lecce	LE	11358
IT	73050	Secli'	Puglia	Lecce	LE	11359
IT	73050	Salve	Puglia	Lecce	LE	11360
IT	73050	Santa Maria Al Bagno	Puglia	Lecce	LE	11361
IT	73050	Santa Chiara Di Nardo'	Puglia	Lecce	LE	11362
IT	73050	Ruggiano	Puglia	Lecce	LE	11363
IT	73050	Villaggio Boncore	Puglia	Lecce	LE	11364
IT	73050	Santa Chiara	Puglia	Lecce	LE	11365
IT	73050	Boncore	Puglia	Lecce	LE	11366
IT	73051	Novoli	Puglia	Lecce	LE	11367
IT	73051	Villa Convento	Puglia	Lecce	LE	11368
IT	73052	Parabita	Puglia	Lecce	LE	11369
IT	73053	Patu'	Puglia	Lecce	LE	11370
IT	73054	Presicce	Puglia	Lecce	LE	11371
IT	73055	Racale	Puglia	Lecce	LE	11372
IT	73056	Taurisano	Puglia	Lecce	LE	11373
IT	73057	Taviano	Puglia	Lecce	LE	11374
IT	73058	Tuglie	Puglia	Lecce	LE	11375
IT	73059	Gemini	Puglia	Lecce	LE	11376
IT	73059	Ugento	Puglia	Lecce	LE	11377
IT	73100	Torre Chianca	Puglia	Lecce	LE	11378
IT	73100	Frigole	Puglia	Lecce	LE	11379
IT	73100	Lecce	Puglia	Lecce	LE	11380
IT	73100	San Cataldo	Puglia	Lecce	LE	11381
IT	74010	Statte	Puglia	Taranto	TA	11382
IT	74011	Case Perrone	Puglia	Taranto	TA	11383
IT	74011	Marina Di Castellaneta	Puglia	Taranto	TA	11384
IT	74011	Castellaneta	Puglia	Taranto	TA	11385
IT	74011	Borgo Perrone	Puglia	Taranto	TA	11386
IT	74012	Crispiano	Puglia	Taranto	TA	11387
IT	74013	Ginosa	Puglia	Taranto	TA	11388
IT	74014	Laterza	Puglia	Taranto	TA	11389
IT	74015	Martina Franca	Puglia	Taranto	TA	11390
IT	74015	San Paolo	Puglia	Taranto	TA	11391
IT	74015	Lanzo Di Martina Franca	Puglia	Taranto	TA	11392
IT	74015	Carpari	Puglia	Taranto	TA	11393
IT	74015	Specchia Tarantina	Puglia	Taranto	TA	11394
IT	74016	Massafra	Puglia	Taranto	TA	11395
IT	74017	San Basilio Mottola	Puglia	Taranto	TA	11396
IT	74017	Mottola	Puglia	Taranto	TA	11397
IT	74018	Palagianello	Puglia	Taranto	TA	11398
IT	74019	Palagiano	Puglia	Taranto	TA	11399
IT	74019	Conca D'Oro	Puglia	Taranto	TA	11400
IT	74020	Avetrana	Puglia	Taranto	TA	11401
IT	74020	San Marzano Di San Giuseppe	Puglia	Taranto	TA	11402
IT	74020	Leporano Marina	Puglia	Taranto	TA	11403
IT	74020	Roccaforzata	Puglia	Taranto	TA	11404
IT	74020	Lizzano	Puglia	Taranto	TA	11405
IT	74020	Leporano	Puglia	Taranto	TA	11406
IT	74020	Faggiano	Puglia	Taranto	TA	11407
IT	74020	Torricella	Puglia	Taranto	TA	11408
IT	74020	Montemesola	Puglia	Taranto	TA	11409
IT	74020	Monteiasi	Puglia	Taranto	TA	11410
IT	74020	Monteparano	Puglia	Taranto	TA	11411
IT	74020	Maruggio	Puglia	Taranto	TA	11412
IT	74021	Carosino	Puglia	Taranto	TA	11413
IT	74022	Fragagnano	Puglia	Taranto	TA	11414
IT	74023	Grottaglie	Puglia	Taranto	TA	11415
IT	74024	San Pietro In Bevagna	Puglia	Taranto	TA	11416
IT	74024	Uggiano Montefusco	Puglia	Taranto	TA	11417
IT	74024	Manduria	Puglia	Taranto	TA	11418
IT	74024	Specchiarica	Puglia	Taranto	TA	11419
IT	74025	Marina Di Ginosa	Puglia	Taranto	TA	11420
IT	74026	Pulsano	Puglia	Taranto	TA	11421
IT	74026	Monti D'Arena	Puglia	Taranto	TA	11422
IT	74026	Lido Silvana	Puglia	Taranto	TA	11423
IT	74026	Bosco Caggione	Puglia	Taranto	TA	11424
IT	74027	San Giorgio Ionico	Puglia	Taranto	TA	11425
IT	74028	Sava	Puglia	Taranto	TA	11426
IT	74100	Paolo Vi	Puglia	Taranto	TA	11427
IT	74100	San Vito Taranto	Puglia	Taranto	TA	11428
IT	74100	Taranto	Puglia	Taranto	TA	11429
IT	74100	Talsano	Puglia	Taranto	TA	11430
IT	74100	Lama	Puglia	Taranto	TA	11431
IT	74121	Taranto	Puglia	Taranto	TA	11432
IT	74122	Taranto	Puglia	Taranto	TA	11433
IT	74123	Taranto	Puglia	Taranto	TA	11434
IT	8030	Serri	Sardegna	Cagliari	CA	11435
IT	8030	Villanova Tulo	Sardegna	Cagliari	CA	11436
IT	8030	Gergei	Sardegna	Cagliari	CA	11437
IT	8030	Lixius	Sardegna	Cagliari	CA	11438
IT	8030	Nurallao	Sardegna	Cagliari	CA	11439
IT	8030	Sadali	Sardegna	Cagliari	CA	11440
IT	8030	Esterzili	Sardegna	Cagliari	CA	11441
IT	8030	Orroli	Sardegna	Cagliari	CA	11442
IT	8030	Seulo	Sardegna	Cagliari	CA	11443
IT	8030	Nuragus	Sardegna	Cagliari	CA	11444
IT	8030	Escolca	Sardegna	Cagliari	CA	11445
IT	8033	Isili	Sardegna	Cagliari	CA	11446
IT	8035	Nurri	Sardegna	Cagliari	CA	11447
IT	8043	Escalaplano	Sardegna	Cagliari	CA	11448
IT	9010	Pula	Sardegna	Cagliari	CA	11449
IT	9010	Uta	Sardegna	Cagliari	CA	11450
IT	9010	Villa San Pietro	Sardegna	Cagliari	CA	11451
IT	9010	Decimoputzu	Sardegna	Cagliari	CA	11452
IT	9010	Siliqua	Sardegna	Cagliari	CA	11453
IT	9010	Villaspeciosa	Sardegna	Cagliari	CA	11454
IT	9010	Forte Village	Sardegna	Cagliari	CA	11455
IT	9010	Vallermosa	Sardegna	Cagliari	CA	11456
IT	9010	Domus De Maria	Sardegna	Cagliari	CA	11457
IT	9012	Capoterra	Sardegna	Cagliari	CA	11458
IT	9012	San Leone	Sardegna	Cagliari	CA	11459
IT	9012	Poggio Dei Pini	Sardegna	Cagliari	CA	11460
IT	9012	La Maddalena	Sardegna	Cagliari	CA	11461
IT	9018	Villa D'Orri	Sardegna	Cagliari	CA	11462
IT	9018	Sarroch	Sardegna	Cagliari	CA	11463
IT	9019	Teulada	Sardegna	Cagliari	CA	11464
IT	9020	Samatzai	Sardegna	Cagliari	CA	11465
IT	9020	Pimentel	Sardegna	Cagliari	CA	11466
IT	9020	Ussana	Sardegna	Cagliari	CA	11467
IT	9023	Monastir	Sardegna	Cagliari	CA	11468
IT	9024	Villagreca	Sardegna	Cagliari	CA	11469
IT	9024	Nuraminis	Sardegna	Cagliari	CA	11470
IT	9026	San Sperate	Sardegna	Cagliari	CA	11471
IT	9028	Sestu	Sardegna	Cagliari	CA	11472
IT	9030	Elmas	Sardegna	Cagliari	CA	11473
IT	9032	Macchiareddu	Sardegna	Cagliari	CA	11474
IT	9032	Assemini	Sardegna	Cagliari	CA	11475
IT	9033	Decimomannu	Sardegna	Cagliari	CA	11476
IT	9034	Villasor	Sardegna	Cagliari	CA	11477
IT	9040	San Basilio	Sardegna	Cagliari	CA	11478
IT	9040	Settimo San Pietro	Sardegna	Cagliari	CA	11479
IT	9040	Castiadas	Sardegna	Cagliari	CA	11480
IT	9040	Maracalagonis	Sardegna	Cagliari	CA	11481
IT	9040	Barrali	Sardegna	Cagliari	CA	11482
IT	9040	Burcei	Sardegna	Cagliari	CA	11483
IT	9040	Silius	Sardegna	Cagliari	CA	11484
IT	9040	Donori'	Sardegna	Cagliari	CA	11485
IT	9040	Guasila	Sardegna	Cagliari	CA	11486
IT	9040	Ortacesus	Sardegna	Cagliari	CA	11487
IT	9040	San Nicolo' Gerrei	Sardegna	Cagliari	CA	11488
IT	9040	Guamaggiore	Sardegna	Cagliari	CA	11489
IT	9040	Siurgus Donigala	Sardegna	Cagliari	CA	11490
IT	9040	Gesico	Sardegna	Cagliari	CA	11491
IT	9040	Sisini	Sardegna	Cagliari	CA	11492
IT	9040	Sant'Andrea Frius	Sardegna	Cagliari	CA	11493
IT	9040	Selegas	Sardegna	Cagliari	CA	11494
IT	9040	Suelli	Sardegna	Cagliari	CA	11495
IT	9040	Ballao	Sardegna	Cagliari	CA	11496
IT	9040	Villaputzu	Sardegna	Cagliari	CA	11497
IT	9040	Serdiana	Sardegna	Cagliari	CA	11498
IT	9040	Goni	Sardegna	Cagliari	CA	11499
IT	9040	San Vito	Sardegna	Cagliari	CA	11500
IT	9040	Senorbi'	Sardegna	Cagliari	CA	11501
IT	9040	Armungia	Sardegna	Cagliari	CA	11502
IT	9040	Arixi	Sardegna	Cagliari	CA	11503
IT	9040	Villasalto	Sardegna	Cagliari	CA	11504
IT	9040	Soleminis	Sardegna	Cagliari	CA	11505
IT	9040	Mandas	Sardegna	Cagliari	CA	11506
IT	9040	Santa Maria	Sardegna	Cagliari	CA	11507
IT	9041	Dolianova	Sardegna	Cagliari	CA	11508
IT	9042	Monserrato	Sardegna	Cagliari	CA	11509
IT	9043	Muravera	Sardegna	Cagliari	CA	11510
IT	9044	Quartucciu	Sardegna	Cagliari	CA	11511
IT	9045	Quartu Sant'Elena	Sardegna	Cagliari	CA	11512
IT	9045	Flumini Di Quartu Sant'Elena	Sardegna	Cagliari	CA	11513
IT	9047	Su Planu	Sardegna	Cagliari	CA	11514
IT	9047	Selargius	Sardegna	Cagliari	CA	11515
IT	9048	Sinnai	Sardegna	Cagliari	CA	11516
IT	9049	Villasimius	Sardegna	Cagliari	CA	11517
IT	9100	Cagliari	Sardegna	Cagliari	CA	11518
IT	9121	Cagliari	Sardegna	Cagliari	CA	11519
IT	9122	Cagliari	Sardegna	Cagliari	CA	11520
IT	9123	Cagliari	Sardegna	Cagliari	CA	11521
IT	9124	Cagliari	Sardegna	Cagliari	CA	11522
IT	9125	Cagliari	Sardegna	Cagliari	CA	11523
IT	9126	Poetto	Sardegna	Cagliari	CA	11524
IT	9126	San Bartolomeo	Sardegna	Cagliari	CA	11525
IT	9126	Cagliari	Sardegna	Cagliari	CA	11526
IT	9126	Cala Mosca	Sardegna	Cagliari	CA	11527
IT	9126	Lazzaretto	Sardegna	Cagliari	CA	11528
IT	9127	Cagliari	Sardegna	Cagliari	CA	11529
IT	9128	Cagliari	Sardegna	Cagliari	CA	11530
IT	9129	Cagliari	Sardegna	Cagliari	CA	11531
IT	9131	Cagliari	Sardegna	Cagliari	CA	11532
IT	9134	Pirri	Sardegna	Cagliari	CA	11533
IT	9134	Cagliari	Sardegna	Cagliari	CA	11534
IT	8010	Birori	Sardegna	Nuoro	NU	11535
IT	8010	Lei	Sardegna	Nuoro	NU	11536
IT	8010	Noragugume	Sardegna	Nuoro	NU	11537
IT	8010	Dualchi	Sardegna	Nuoro	NU	11538
IT	8011	Bolotana	Sardegna	Nuoro	NU	11539
IT	8012	Bortigali	Sardegna	Nuoro	NU	11540
IT	8012	Mulargia	Sardegna	Nuoro	NU	11541
IT	8015	Macomer	Sardegna	Nuoro	NU	11542
IT	8016	Borore	Sardegna	Nuoro	NU	11543
IT	8017	Silanus	Sardegna	Nuoro	NU	11544
IT	8018	Sindia	Sardegna	Nuoro	NU	11545
IT	8020	Onani	Sardegna	Nuoro	NU	11546
IT	8020	Su Cossu	Sardegna	Nuoro	NU	11547
IT	8020	Osidda	Sardegna	Nuoro	NU	11548
IT	8020	San Giovanni	Sardegna	Nuoro	NU	11549
IT	8020	Lula	Sardegna	Nuoro	NU	11550
IT	8020	Brunella	Sardegna	Nuoro	NU	11551
IT	8020	Mamone	Sardegna	Nuoro	NU	11552
IT	8020	Galtelli	Sardegna	Nuoro	NU	11553
IT	8020	Ottana	Sardegna	Nuoro	NU	11554
IT	8020	Irgoli	Sardegna	Nuoro	NU	11555
IT	8020	Su Pradu	Sardegna	Nuoro	NU	11556
IT	8020	Olzai	Sardegna	Nuoro	NU	11557
IT	8020	Torpe'	Sardegna	Nuoro	NU	11558
IT	8020	Sas Murtas	Sardegna	Nuoro	NU	11559
IT	8020	Orotelli	Sardegna	Nuoro	NU	11560
IT	8020	Talava'	Sardegna	Nuoro	NU	11561
IT	8020	Loculi	Sardegna	Nuoro	NU	11562
IT	8020	Gavoi	Sardegna	Nuoro	NU	11563
IT	8020	Oniferi	Sardegna	Nuoro	NU	11564
IT	8020	Posada	Sardegna	Nuoro	NU	11565
IT	8020	Monte Longu	Sardegna	Nuoro	NU	11566
IT	8020	Concas	Sardegna	Nuoro	NU	11567
IT	8020	Sarule	Sardegna	Nuoro	NU	11568
IT	8020	Ollolai	Sardegna	Nuoro	NU	11569
IT	8020	Orune	Sardegna	Nuoro	NU	11570
IT	8020	Onifai	Sardegna	Nuoro	NU	11571
IT	8020	Sa Pala Ruia	Sardegna	Nuoro	NU	11572
IT	8020	Lode'	Sardegna	Nuoro	NU	11573
IT	8020	S'Ena Sa Chitta	Sardegna	Nuoro	NU	11574
IT	8020	Lodine	Sardegna	Nuoro	NU	11575
IT	8020	Ovedi'	Sardegna	Nuoro	NU	11576
IT	8020	Ovodda	Sardegna	Nuoro	NU	11577
IT	8020	Sant'Efisio	Sardegna	Nuoro	NU	11578
IT	8020	Tiana	Sardegna	Nuoro	NU	11579
IT	8020	Berchidda	Sardegna	Nuoro	NU	11580
IT	8021	Bitti	Sardegna	Nuoro	NU	11581
IT	8022	Dorgali	Sardegna	Nuoro	NU	11582
IT	8022	Cala Gonone	Sardegna	Nuoro	NU	11583
IT	8023	Fonni	Sardegna	Nuoro	NU	11584
IT	8024	Mamoiada	Sardegna	Nuoro	NU	11585
IT	8025	Oliena	Sardegna	Nuoro	NU	11586
IT	8025	Su Cologone	Sardegna	Nuoro	NU	11587
IT	8026	Orani	Sardegna	Nuoro	NU	11588
IT	8027	Orgosolo	Sardegna	Nuoro	NU	11589
IT	8028	Orosei	Sardegna	Nuoro	NU	11590
IT	8028	Sas Linnas Siccas	Sardegna	Nuoro	NU	11591
IT	8028	Cala Liberotto	Sardegna	Nuoro	NU	11592
IT	8028	Sos Alinos	Sardegna	Nuoro	NU	11593
IT	8028	Cala Ginepro	Sardegna	Nuoro	NU	11594
IT	8029	La Caletta	Sardegna	Nuoro	NU	11595
IT	8029	Ena Sa Chitta	Sardegna	Nuoro	NU	11596
IT	8029	Overì	Sardegna	Nuoro	NU	11597
IT	8029	Capo Comino	Sardegna	Nuoro	NU	11598
IT	8029	Santa Lucia	Sardegna	Nuoro	NU	11599
IT	8029	Siniscola	Sardegna	Nuoro	NU	11600
IT	8029	Berchida	Sardegna	Nuoro	NU	11601
IT	8029	Sa Perta Ruia	Sardegna	Nuoro	NU	11602
IT	8029	Mandras	Sardegna	Nuoro	NU	11603
IT	8029	Sa Pischera	Sardegna	Nuoro	NU	11604
IT	8029	Sarenargiu	Sardegna	Nuoro	NU	11605
IT	8029	Su Tilio'	Sardegna	Nuoro	NU	11606
IT	8030	Gadoni	Sardegna	Nuoro	NU	11607
IT	8030	Austis	Sardegna	Nuoro	NU	11608
IT	8030	Meana Sardo	Sardegna	Nuoro	NU	11609
IT	8030	Teti	Sardegna	Nuoro	NU	11610
IT	8030	Atzara	Sardegna	Nuoro	NU	11611
IT	8030	Belvi	Sardegna	Nuoro	NU	11612
IT	8031	Aritzo	Sardegna	Nuoro	NU	11613
IT	8031	Gidilau	Sardegna	Nuoro	NU	11614
IT	8032	Desulo	Sardegna	Nuoro	NU	11615
IT	8036	Ortueri	Sardegna	Nuoro	NU	11616
IT	8037	Seui	Sardegna	Nuoro	NU	11617
IT	8038	Sorgono	Sardegna	Nuoro	NU	11618
IT	8039	Tonara	Sardegna	Nuoro	NU	11619
IT	8040	Talana	Sardegna	Nuoro	NU	11620
IT	8040	Elini	Sardegna	Nuoro	NU	11621
IT	8040	Urzulei	Sardegna	Nuoro	NU	11622
IT	8040	Triei	Sardegna	Nuoro	NU	11623
IT	8040	Osini	Sardegna	Nuoro	NU	11624
IT	8040	Ussassai	Sardegna	Nuoro	NU	11625
IT	8040	Ulassai	Sardegna	Nuoro	NU	11626
IT	8040	Loceri	Sardegna	Nuoro	NU	11627
IT	8040	Ardali	Sardegna	Nuoro	NU	11628
IT	8040	Gairo	Sardegna	Nuoro	NU	11629
IT	8040	Arzana	Sardegna	Nuoro	NU	11630
IT	8040	Gairo Sant'Elena	Sardegna	Nuoro	NU	11631
IT	8040	Baunei	Sardegna	Nuoro	NU	11632
IT	8040	Santa Maria Navarrese	Sardegna	Nuoro	NU	11633
IT	8040	Girasole	Sardegna	Nuoro	NU	11634
IT	8040	S'Arridellu	Sardegna	Nuoro	NU	11635
IT	8040	Cardedu	Sardegna	Nuoro	NU	11636
IT	8040	Tancau	Sardegna	Nuoro	NU	11637
IT	8040	Lotzorai	Sardegna	Nuoro	NU	11638
IT	8040	Taquisara	Sardegna	Nuoro	NU	11639
IT	8040	Tancau Sul Mare	Sardegna	Nuoro	NU	11640
IT	8040	Ilbono	Sardegna	Nuoro	NU	11641
IT	8042	Bari Sardo	Sardegna	Nuoro	NU	11642
IT	8044	Jerzu	Sardegna	Nuoro	NU	11643
IT	8045	Lanusei	Sardegna	Nuoro	NU	11644
IT	8046	Perdasdefogu	Sardegna	Nuoro	NU	11645
IT	8047	Tertenia	Sardegna	Nuoro	NU	11646
IT	8047	Migheli	Sardegna	Nuoro	NU	11647
IT	8048	Tortoli'	Sardegna	Nuoro	NU	11648
IT	8048	Su Troccu	Sardegna	Nuoro	NU	11649
IT	8048	Arbatax	Sardegna	Nuoro	NU	11650
IT	8048	Su Pinu	Sardegna	Nuoro	NU	11651
IT	8048	Is Murdegus	Sardegna	Nuoro	NU	11652
IT	8048	Calamoresca	Sardegna	Nuoro	NU	11653
IT	8048	Porto Frailis	Sardegna	Nuoro	NU	11654
IT	8049	Villanova Strisaili	Sardegna	Nuoro	NU	11655
IT	8049	Villagrande Strisaili	Sardegna	Nuoro	NU	11656
IT	8100	Lollove	Sardegna	Nuoro	NU	11657
IT	8100	Manasuddas	Sardegna	Nuoro	NU	11658
IT	8100	Nuoro	Sardegna	Nuoro	NU	11659
IT	8100	Monte Ortobene	Sardegna	Nuoro	NU	11660
IT	8010	Tinnura	Sardegna	Oristano	OR	11661
IT	8010	Flussio	Sardegna	Oristano	OR	11662
IT	8010	Magomadas	Sardegna	Oristano	OR	11663
IT	8010	Suni	Sardegna	Oristano	OR	11664
IT	8010	Sagama	Sardegna	Oristano	OR	11665
IT	8010	Montresta	Sardegna	Oristano	OR	11666
IT	8010	Sa Lumenera	Sardegna	Oristano	OR	11667
IT	8010	Santa Maria	Sardegna	Oristano	OR	11668
IT	8013	Bosa	Sardegna	Oristano	OR	11669
IT	8013	Bosa Marina	Sardegna	Oristano	OR	11670
IT	8013	Turas	Sardegna	Oristano	OR	11671
IT	8019	Modolo	Sardegna	Oristano	OR	11672
IT	8030	Genoni	Sardegna	Oristano	OR	11673
IT	8034	Laconi	Sardegna	Oristano	OR	11674
IT	8034	Traidodini	Sardegna	Oristano	OR	11675
IT	8034	Crastu	Sardegna	Oristano	OR	11676
IT	8034	Santa Sofia	Sardegna	Oristano	OR	11677
IT	8034	Su Lau	Sardegna	Oristano	OR	11678
IT	9070	Narbolia	Sardegna	Oristano	OR	11679
IT	9070	Paulilatino	Sardegna	Oristano	OR	11680
IT	9070	Nurachi	Sardegna	Oristano	OR	11681
IT	9070	Sa Rocca Tunda	Sardegna	Oristano	OR	11682
IT	9070	Riola Sardo	Sardegna	Oristano	OR	11683
IT	9070	Rocca Tunda	Sardegna	Oristano	OR	11684
IT	9070	Pardu Nou	Sardegna	Oristano	OR	11685
IT	9070	Bonarcado	Sardegna	Oristano	OR	11686
IT	9070	Tramatza	Sardegna	Oristano	OR	11687
IT	9070	Milis	Sardegna	Oristano	OR	11688
IT	9070	Seneghe	Sardegna	Oristano	OR	11689
IT	9070	Zeddiani	Sardegna	Oristano	OR	11690
IT	9070	Aidomaggiore	Sardegna	Oristano	OR	11691
IT	9070	Mandriola	Sardegna	Oristano	OR	11692
IT	9070	Baratili San Pietro	Sardegna	Oristano	OR	11693
IT	9070	San Vero Milis	Sardegna	Oristano	OR	11694
IT	9070	Zerfaliu	Sardegna	Oristano	OR	11695
IT	9070	Domusnovas Canales	Sardegna	Oristano	OR	11696
IT	9070	Siamaggiore	Sardegna	Oristano	OR	11697
IT	9070	Putzu Idu	Sardegna	Oristano	OR	11698
IT	9070	Norbello	Sardegna	Oristano	OR	11699
IT	9070	Bauladu	Sardegna	Oristano	OR	11700
IT	9071	Abbasanta	Sardegna	Oristano	OR	11701
IT	9072	Solanas	Sardegna	Oristano	OR	11702
IT	9072	Cabras	Sardegna	Oristano	OR	11703
IT	9073	Santa Caterina	Sardegna	Oristano	OR	11704
IT	9073	S'Archittu	Sardegna	Oristano	OR	11705
IT	9073	Torre Del Pozzo	Sardegna	Oristano	OR	11706
IT	9073	Cuglieri	Sardegna	Oristano	OR	11707
IT	9073	Santa Caterina Di Pittinurri	Sardegna	Oristano	OR	11708
IT	9074	Ghilarza	Sardegna	Oristano	OR	11709
IT	9074	Zuri	Sardegna	Oristano	OR	11710
IT	9075	Santu Lussurgiu	Sardegna	Oristano	OR	11711
IT	9075	San Leonardo	Sardegna	Oristano	OR	11712
IT	9076	Sedilo	Sardegna	Oristano	OR	11713
IT	9077	Solarussa	Sardegna	Oristano	OR	11714
IT	9078	Scano Di Montiferro	Sardegna	Oristano	OR	11715
IT	9078	Sennariolo	Sardegna	Oristano	OR	11716
IT	9079	Tresnuraghes	Sardegna	Oristano	OR	11717
IT	9080	Boroneddu	Sardegna	Oristano	OR	11718
IT	9080	Neoneli	Sardegna	Oristano	OR	11719
IT	9080	Tadasuni	Sardegna	Oristano	OR	11720
IT	9080	Asuni	Sardegna	Oristano	OR	11721
IT	9080	Allai	Sardegna	Oristano	OR	11722
IT	9080	Senis	Sardegna	Oristano	OR	11723
IT	9080	Nughedu Santa Vittoria	Sardegna	Oristano	OR	11724
IT	9080	Assolo	Sardegna	Oristano	OR	11725
IT	9080	Villa Sant'Antonio	Sardegna	Oristano	OR	11726
IT	9080	Bidoni'	Sardegna	Oristano	OR	11727
IT	9080	Siapiccia	Sardegna	Oristano	OR	11728
IT	9080	Sorradile	Sardegna	Oristano	OR	11729
IT	9080	Villaurbana	Sardegna	Oristano	OR	11730
IT	9080	Soddi'	Sardegna	Oristano	OR	11731
IT	9080	Siamanna	Sardegna	Oristano	OR	11732
IT	9080	Sant'Antonio Ruinas	Sardegna	Oristano	OR	11733
IT	9080	Nureci	Sardegna	Oristano	OR	11734
IT	9080	Ula' Tirso	Sardegna	Oristano	OR	11735
IT	9080	Mogorella	Sardegna	Oristano	OR	11736
IT	9081	Ardauli	Sardegna	Oristano	OR	11737
IT	9082	Busachi	Sardegna	Oristano	OR	11738
IT	9083	Fordongianus	Sardegna	Oristano	OR	11739
IT	9084	Villanova Truschedu	Sardegna	Oristano	OR	11740
IT	9085	Ruinas	Sardegna	Oristano	OR	11741
IT	9086	Samugheo	Sardegna	Oristano	OR	11742
IT	9088	Ollastra	Sardegna	Oristano	OR	11743
IT	9088	Simaxis	Sardegna	Oristano	OR	11744
IT	9090	Gonnoscodina	Sardegna	Oristano	OR	11745
IT	9090	Curcuris	Sardegna	Oristano	OR	11746
IT	9090	Villa Verde	Sardegna	Oristano	OR	11747
IT	9090	Tiria	Sardegna	Oristano	OR	11748
IT	9090	Albagiara	Sardegna	Oristano	OR	11749
IT	9090	Gonnosno'	Sardegna	Oristano	OR	11750
IT	9090	Baradili	Sardegna	Oristano	OR	11751
IT	9090	Usellus	Sardegna	Oristano	OR	11752
IT	9090	Morgongiori	Sardegna	Oristano	OR	11753
IT	9090	Masullas	Sardegna	Oristano	OR	11754
IT	9090	Sini	Sardegna	Oristano	OR	11755
IT	9090	Siris	Sardegna	Oristano	OR	11756
IT	9090	Simala	Sardegna	Oristano	OR	11757
IT	9090	Baressa	Sardegna	Oristano	OR	11758
IT	9090	Pau	Sardegna	Oristano	OR	11759
IT	9090	Palmas Arborea	Sardegna	Oristano	OR	11760
IT	9091	Ales	Sardegna	Oristano	OR	11761
IT	9092	Arborea	Sardegna	Oristano	OR	11762
IT	9093	Pompu	Sardegna	Oristano	OR	11763
IT	9093	Gonnostramatza	Sardegna	Oristano	OR	11764
IT	9094	Sant'Anna	Sardegna	Oristano	OR	11765
IT	9094	Marrubiu	Sardegna	Oristano	OR	11766
IT	9095	Mogoro	Sardegna	Oristano	OR	11767
IT	9096	Santa Giusta	Sardegna	Oristano	OR	11768
IT	9097	San Nicolo' D'Arcidano	Sardegna	Oristano	OR	11769
IT	9098	Terralba	Sardegna	Oristano	OR	11770
IT	9098	Tanca Marchese	Sardegna	Oristano	OR	11771
IT	9099	Uras	Sardegna	Oristano	OR	11772
IT	9170	Torre Grande	Sardegna	Oristano	OR	11773
IT	9170	Sili'	Sardegna	Oristano	OR	11774
IT	9170	Oristano	Sardegna	Oristano	OR	11775
IT	9170	Nuraxinieddu	Sardegna	Oristano	OR	11776
IT	9170	Massama	Sardegna	Oristano	OR	11777
IT	9170	Donigala Fenughedu	Sardegna	Oristano	OR	11778
IT	7010	Mara	Sardegna	Sassari	SS	11779
IT	7010	Benetutti	Sardegna	Sassari	SS	11780
IT	7010	Esporlatu	Sardegna	Sassari	SS	11781
IT	7010	Romana	Sardegna	Sassari	SS	11782
IT	7010	Nughedu San Nicolo'	Sardegna	Sassari	SS	11783
IT	7010	Anela	Sardegna	Sassari	SS	11784
IT	7010	Burgos	Sardegna	Sassari	SS	11785
IT	7010	Bultei	Sardegna	Sassari	SS	11786
IT	7010	Nule	Sardegna	Sassari	SS	11787
IT	7010	Tula	Sardegna	Sassari	SS	11788
IT	7010	Ardara	Sardegna	Sassari	SS	11789
IT	7010	Illorai	Sardegna	Sassari	SS	11790
IT	7010	Monteleone Rocca Doria	Sardegna	Sassari	SS	11791
IT	7010	Giave	Sardegna	Sassari	SS	11792
IT	7010	Bottidda	Sardegna	Sassari	SS	11793
IT	7010	Ittireddu	Sardegna	Sassari	SS	11794
IT	7010	Foresta Di Burgos	Sardegna	Sassari	SS	11795
IT	7010	Semestene	Sardegna	Sassari	SS	11796
IT	7010	Cossoine	Sardegna	Sassari	SS	11797
IT	7010	Foresta Burgos	Sardegna	Sassari	SS	11798
IT	7011	Bono	Sardegna	Sassari	SS	11799
IT	7012	Bonorva	Sardegna	Sassari	SS	11800
IT	7012	Rebeccu	Sardegna	Sassari	SS	11801
IT	7012	Santa Lucia	Sardegna	Sassari	SS	11802
IT	7013	Mores	Sardegna	Sassari	SS	11803
IT	7014	San Nicola	Sardegna	Sassari	SS	11804
IT	7014	Ozieri	Sardegna	Sassari	SS	11805
IT	7014	Fraigas	Sardegna	Sassari	SS	11806
IT	7014	Chilivani	Sardegna	Sassari	SS	11807
IT	7014	Vigne	Sardegna	Sassari	SS	11808
IT	7015	Padria	Sardegna	Sassari	SS	11809
IT	7016	Pattada	Sardegna	Sassari	SS	11810
IT	7017	Ploaghe	Sardegna	Sassari	SS	11811
IT	7018	Pozzomaggiore	Sardegna	Sassari	SS	11812
IT	7019	Villanova Monteleone	Sardegna	Sassari	SS	11813
IT	7020	Telti	Sardegna	Sassari	SS	11814
IT	7020	Loiri Porto San Paolo	Sardegna	Sassari	SS	11815
IT	7020	Golfo Aranci	Sardegna	Sassari	SS	11816
IT	7020	Porto San Paolo	Sardegna	Sassari	SS	11817
IT	7020	Ala' Dei Sardi	Sardegna	Sassari	SS	11818
IT	7020	Monti	Sardegna	Sassari	SS	11819
IT	7020	Vaccileddi	Sardegna	Sassari	SS	11820
IT	7020	Palau	Sardegna	Sassari	SS	11821
IT	7020	Luogosanto	Sardegna	Sassari	SS	11822
IT	7020	Aglientu	Sardegna	Sassari	SS	11823
IT	7020	Aggius	Sardegna	Sassari	SS	11824
IT	7020	Padru	Sardegna	Sassari	SS	11825
IT	7020	Budduso'	Sardegna	Sassari	SS	11826
IT	7020	Loiri	Sardegna	Sassari	SS	11827
IT	7020	San Francesco D'Aglientu	Sardegna	Sassari	SS	11828
IT	7020	Su Canale	Sardegna	Sassari	SS	11829
IT	7021	Arzachena	Sardegna	Sassari	SS	11830
IT	7021	Cannigione	Sardegna	Sassari	SS	11831
IT	7021	Porto Cervo	Sardegna	Sassari	SS	11832
IT	7021	Baia Sardinia	Sardegna	Sassari	SS	11833
IT	7021	Cala Di Volpe	Sardegna	Sassari	SS	11834
IT	7021	Capo Ferro	Sardegna	Sassari	SS	11835
IT	7021	Costa Smeralda	Sardegna	Sassari	SS	11836
IT	7021	Pirazzolu	Sardegna	Sassari	SS	11837
IT	7022	Berchidda	Sardegna	Sassari	SS	11838
IT	7023	Calangianus	Sardegna	Sassari	SS	11839
IT	7024	La Maddalena	Sardegna	Sassari	SS	11840
IT	7024	Moneta	Sardegna	Sassari	SS	11841
IT	7024	Isola Di Caprera	Sardegna	Sassari	SS	11842
IT	7025	Luras	Sardegna	Sassari	SS	11843
IT	7026	Berchiddeddu	Sardegna	Sassari	SS	11844
IT	7026	Olbia	Sardegna	Sassari	SS	11845
IT	7026	Porto Rotondo	Sardegna	Sassari	SS	11846
IT	7026	San Pantaleo	Sardegna	Sassari	SS	11847
IT	7027	Oschiri	Sardegna	Sassari	SS	11848
IT	7028	Santa Teresa Gallura	Sardegna	Sassari	SS	11849
IT	7028	San Pasquale	Sardegna	Sassari	SS	11850
IT	7029	Bassacutena	Sardegna	Sassari	SS	11851
IT	7029	Tempio Pausania	Sardegna	Sassari	SS	11852
IT	7029	Nuchis	Sardegna	Sassari	SS	11853
IT	7030	Florinas	Sardegna	Sassari	SS	11854
IT	7030	Viddalba	Sardegna	Sassari	SS	11855
IT	7030	Bortigiadas	Sardegna	Sassari	SS	11856
IT	7030	Sant'Antonio Di Gallura	Sardegna	Sassari	SS	11857
IT	7030	Martis	Sardegna	Sassari	SS	11858
IT	7030	Chiaramonti	Sardegna	Sassari	SS	11859
IT	7030	Laerru	Sardegna	Sassari	SS	11860
IT	7030	Tergu	Sardegna	Sassari	SS	11861
IT	7030	Muros	Sardegna	Sassari	SS	11862
IT	7030	Bulzi	Sardegna	Sassari	SS	11863
IT	7030	Badesi	Sardegna	Sassari	SS	11864
IT	7030	Cargeghe	Sardegna	Sassari	SS	11865
IT	7030	Santa Maria Coghinas	Sardegna	Sassari	SS	11866
IT	7030	Erula	Sardegna	Sassari	SS	11867
IT	7031	Castelsardo	Sardegna	Sassari	SS	11868
IT	7031	Lu Bagnu	Sardegna	Sassari	SS	11869
IT	7032	Nulvi	Sardegna	Sassari	SS	11870
IT	7033	Santa Vittoria	Sardegna	Sassari	SS	11871
IT	7033	Osilo	Sardegna	Sassari	SS	11872
IT	7034	Perfugas	Sardegna	Sassari	SS	11873
IT	7035	Sedini	Sardegna	Sassari	SS	11874
IT	7036	Sennori	Sardegna	Sassari	SS	11875
IT	7037	Sorso	Sardegna	Sassari	SS	11876
IT	7037	Platamona	Sardegna	Sassari	SS	11877
IT	7038	Trinita' D'Agultu E Vignola	Sardegna	Sassari	SS	11878
IT	7038	Lu Colbu	Sardegna	Sassari	SS	11879
IT	7039	La Muddizza	Sardegna	Sassari	SS	11880
IT	7039	Codaruina	Sardegna	Sassari	SS	11881
IT	7039	Valledoria	Sardegna	Sassari	SS	11882
IT	7040	Uri	Sardegna	Sassari	SS	11883
IT	7040	Putifigari	Sardegna	Sassari	SS	11884
IT	7040	Codrongianos	Sardegna	Sassari	SS	11885
IT	7040	Banari	Sardegna	Sassari	SS	11886
IT	7040	Stintino	Sardegna	Sassari	SS	11887
IT	7040	Olmedo	Sardegna	Sassari	SS	11888
IT	7040	Tissi	Sardegna	Sassari	SS	11889
IT	7040	Tottubella	Sardegna	Sassari	SS	11890
IT	7040	Bessude	Sardegna	Sassari	SS	11891
IT	7040	Argentiera	Sardegna	Sassari	SS	11892
IT	7040	Siligo	Sardegna	Sassari	SS	11893
IT	7040	Canaglia	Sardegna	Sassari	SS	11894
IT	7040	Campanedda	Sardegna	Sassari	SS	11895
IT	7040	Rumanedda	Sardegna	Sassari	SS	11896
IT	7040	Borutta	Sardegna	Sassari	SS	11897
IT	7040	Cheremule	Sardegna	Sassari	SS	11898
IT	7040	Palmadula	Sardegna	Sassari	SS	11899
IT	7040	Biancareddu	Sardegna	Sassari	SS	11900
IT	7040	Argentiera Nurra	Sardegna	Sassari	SS	11901
IT	7040	La Corte	Sardegna	Sassari	SS	11902
IT	7041	Alghero	Sardegna	Sassari	SS	11903
IT	7041	Santa Maria La Palma	Sardegna	Sassari	SS	11904
IT	7041	Maristella Porto Conte	Sardegna	Sassari	SS	11905
IT	7041	Tramariglio	Sardegna	Sassari	SS	11906
IT	7041	Fertilia	Sardegna	Sassari	SS	11907
IT	7043	Bonnanaro	Sardegna	Sassari	SS	11908
IT	7044	Ittiri	Sardegna	Sassari	SS	11909
IT	7045	Ossi	Sardegna	Sassari	SS	11910
IT	7046	Asinara Cala D'Oliva	Sardegna	Sassari	SS	11911
IT	7046	Porto Torres	Sardegna	Sassari	SS	11912
IT	7046	Cala Reale	Sardegna	Sassari	SS	11913
IT	7046	Asinara Lazzaretto	Sardegna	Sassari	SS	11914
IT	7047	Thiesi	Sardegna	Sassari	SS	11915
IT	7048	Torralba	Sardegna	Sassari	SS	11916
IT	7049	Usini	Sardegna	Sassari	SS	11917
IT	7100	Li Punti	Sardegna	Sassari	SS	11918
IT	7100	San Giovanni	Sardegna	Sassari	SS	11919
IT	7100	Sassari	Sardegna	Sassari	SS	11920
IT	7100	Ottava	Sardegna	Sassari	SS	11921
IT	7100	La Landrigga	Sardegna	Sassari	SS	11922
IT	7100	Bancali	Sardegna	Sassari	SS	11923
IT	7100	Macciadosa	Sardegna	Sassari	SS	11924
IT	8020	San Silvestro	Sardegna	Sassari	SS	11925
IT	8020	Birgalavo'	Sardegna	Sassari	SS	11926
IT	8020	Lu Lioni	Sardegna	Sassari	SS	11927
IT	8020	Luttuni	Sardegna	Sassari	SS	11928
IT	8020	Monte Petrosu	Sardegna	Sassari	SS	11929
IT	8020	Capo Coda Cavallo	Sardegna	Sassari	SS	11930
IT	8020	Puntaldia	Sardegna	Sassari	SS	11931
IT	8020	Limpiddu	Sardegna	Sassari	SS	11932
IT	8020	Muriscuvo'	Sardegna	Sassari	SS	11933
IT	8020	San Gavino	Sardegna	Sassari	SS	11934
IT	8020	S'Iscala	Sardegna	Sassari	SS	11935
IT	8020	Maiorca	Sardegna	Sassari	SS	11936
IT	8020	Tanaunella	Sardegna	Sassari	SS	11937
IT	8020	San Pietro	Sardegna	Sassari	SS	11938
IT	8020	Straulas	Sardegna	Sassari	SS	11939
IT	8020	Budoni	Sardegna	Sassari	SS	11940
IT	8020	Tamarispa	Sardegna	Sassari	SS	11941
IT	8020	Nuditta	Sardegna	Sassari	SS	11942
IT	8020	San Lorenzo	Sardegna	Sassari	SS	11943
IT	8020	Luddui	Sardegna	Sassari	SS	11944
IT	8020	Berruiles	Sardegna	Sassari	SS	11945
IT	8020	Lu Fraili	Sardegna	Sassari	SS	11946
IT	8020	Badualga	Sardegna	Sassari	SS	11947
IT	8020	Solita'	Sardegna	Sassari	SS	11948
IT	8020	Bircolovo'	Sardegna	Sassari	SS	11949
IT	8020	Agrustos	Sardegna	Sassari	SS	11950
IT	8020	Silimini	Sardegna	Sassari	SS	11951
IT	8020	Lutturai	Sardegna	Sassari	SS	11952
IT	8020	Lu Impostu	Sardegna	Sassari	SS	11953
IT	8020	Schifoni	Sardegna	Sassari	SS	11954
IT	8020	Lu Sitagliacciu	Sardegna	Sassari	SS	11955
IT	8020	Nuragheddu	Sardegna	Sassari	SS	11956
IT	8020	Limpostu	Sardegna	Sassari	SS	11957
IT	8020	Malamori'	Sardegna	Sassari	SS	11958
IT	8020	Lu Cuponeddi	Sardegna	Sassari	SS	11959
IT	8020	Pedra E Cupa	Sardegna	Sassari	SS	11960
IT	8020	La Runcina	Sardegna	Sassari	SS	11961
IT	8020	Lu Ricciu	Sardegna	Sassari	SS	11962
IT	8020	Suaredda	Sardegna	Sassari	SS	11963
IT	8020	Li Teggi	Sardegna	Sassari	SS	11964
IT	8020	Franculacciu	Sardegna	Sassari	SS	11965
IT	8020	La Traversa	Sardegna	Sassari	SS	11966
IT	8020	Stazzu Mesu	Sardegna	Sassari	SS	11967
IT	8020	Strugas	Sardegna	Sassari	SS	11968
IT	8020	Pira Maseda	Sardegna	Sassari	SS	11969
IT	8020	Lu Tintimbaru	Sardegna	Sassari	SS	11970
IT	8020	Pattimedda	Sardegna	Sassari	SS	11971
IT	8020	Terrapadedda	Sardegna	Sassari	SS	11972
IT	8020	Tiridduli	Sardegna	Sassari	SS	11973
IT	8020	Li Mori	Sardegna	Sassari	SS	11974
IT	8020	Budditogliu	Sardegna	Sassari	SS	11975
IT	8020	Lu Muvruneddu	Sardegna	Sassari	SS	11976
IT	8020	Muvruneddi	Sardegna	Sassari	SS	11977
IT	8020	Lotturai	Sardegna	Sassari	SS	11978
IT	8020	Stazzu Bruciatu	Sardegna	Sassari	SS	11979
IT	8020	Ottiolu	Sardegna	Sassari	SS	11980
IT	8020	Su Linalvu	Sardegna	Sassari	SS	11981
IT	8020	Rinaggiu	Sardegna	Sassari	SS	11982
IT	8020	L'Alzoni	Sardegna	Sassari	SS	11983
IT	8020	Sitagliacciu	Sardegna	Sassari	SS	11984
IT	8020	Traversa	Sardegna	Sassari	SS	11985
IT	8020	Lu Titimbaru	Sardegna	Sassari	SS	11986
IT	9010	Riomurtas	Sardegna	Sud Sardegna	SU	11987
IT	9010	Villaperuccio	Sardegna	Sud Sardegna	SU	11988
IT	9010	Portoscuso	Sardegna	Sud Sardegna	SU	11989
IT	9010	Tratalias	Sardegna	Sud Sardegna	SU	11990
IT	9010	Terraseo	Sardegna	Sud Sardegna	SU	11991
IT	9010	Santadi	Sardegna	Sud Sardegna	SU	11992
IT	9010	Matzaccara	Sardegna	Sud Sardegna	SU	11993
IT	9010	Villarios	Sardegna	Sud Sardegna	SU	11994
IT	9010	Paringianu	Sardegna	Sud Sardegna	SU	11995
IT	9010	Masainas	Sardegna	Sud Sardegna	SU	11996
IT	9010	Giba	Sardegna	Sud Sardegna	SU	11997
IT	9010	Narcao	Sardegna	Sud Sardegna	SU	11998
IT	9010	Perdaxius	Sardegna	Sud Sardegna	SU	11999
IT	9010	Fluminimaggiore	Sardegna	Sud Sardegna	SU	12000
IT	9010	Villamassargia	Sardegna	Sud Sardegna	SU	12001
IT	9010	Sant'Anna Arresi	Sardegna	Sud Sardegna	SU	12002
IT	9010	Buggerru	Sardegna	Sud Sardegna	SU	12003
IT	9010	Rosas	Sardegna	Sud Sardegna	SU	12004
IT	9010	Musei	Sardegna	Sud Sardegna	SU	12005
IT	9010	Palmas	Sardegna	Sud Sardegna	SU	12006
IT	9010	Nuraxi Figus	Sardegna	Sud Sardegna	SU	12007
IT	9010	Gonnesa	Sardegna	Sud Sardegna	SU	12008
IT	9010	Nuxis	Sardegna	Sud Sardegna	SU	12009
IT	9010	Piscinas	Sardegna	Sud Sardegna	SU	12010
IT	9010	Is Urigus	Sardegna	Sud Sardegna	SU	12011
IT	9010	Terresoli	Sardegna	Sud Sardegna	SU	12012
IT	9010	San Giovanni Suergiu	Sardegna	Sud Sardegna	SU	12013
IT	9011	Calasetta	Sardegna	Sud Sardegna	SU	12014
IT	9011	Cussorgia	Sardegna	Sud Sardegna	SU	12015
IT	9013	Serbariu	Sardegna	Sud Sardegna	SU	12016
IT	9013	Bacu Abis	Sardegna	Sud Sardegna	SU	12017
IT	9013	Barbusi	Sardegna	Sud Sardegna	SU	12018
IT	9013	Cortoghiana	Sardegna	Sud Sardegna	SU	12019
IT	9013	Sirai	Sardegna	Sud Sardegna	SU	12020
IT	9013	Carbonia	Sardegna	Sud Sardegna	SU	12021
IT	9014	Carloforte	Sardegna	Sud Sardegna	SU	12022
IT	9015	Domusnovas	Sardegna	Sud Sardegna	SU	12023
IT	9016	Bindua	Sardegna	Sud Sardegna	SU	12024
IT	9016	San Benedetto	Sardegna	Sud Sardegna	SU	12025
IT	9016	Nebida	Sardegna	Sud Sardegna	SU	12026
IT	9016	Monteponi	Sardegna	Sud Sardegna	SU	12027
IT	9016	Iglesias	Sardegna	Sud Sardegna	SU	12028
IT	9017	Sant'Antioco	Sardegna	Sud Sardegna	SU	12029
IT	9020	Pauli Arbarei	Sardegna	Sud Sardegna	SU	12030
IT	9020	Genuri	Sardegna	Sud Sardegna	SU	12031
IT	9020	Turri	Sardegna	Sud Sardegna	SU	12032
IT	95040	Libertinia	Sicilia	Catania	CT	12033
IT	9020	Las Plassas	Sardegna	Sud Sardegna	SU	12034
IT	9020	Collinas	Sardegna	Sud Sardegna	SU	12035
IT	9020	Ussaramanna	Sardegna	Sud Sardegna	SU	12036
IT	9020	Villamar	Sardegna	Sud Sardegna	SU	12037
IT	9020	Siddi	Sardegna	Sud Sardegna	SU	12038
IT	9020	Villanovafranca	Sardegna	Sud Sardegna	SU	12039
IT	9020	Villanovaforru	Sardegna	Sud Sardegna	SU	12040
IT	9020	Gesturi	Sardegna	Sud Sardegna	SU	12041
IT	9021	Barumini	Sardegna	Sud Sardegna	SU	12042
IT	9022	Lunamatrona	Sardegna	Sud Sardegna	SU	12043
IT	9025	Sanluri	Sardegna	Sud Sardegna	SU	12044
IT	9025	Sanluri Stato	Sardegna	Sud Sardegna	SU	12045
IT	9027	Serrenti	Sardegna	Sud Sardegna	SU	12046
IT	9029	Tuili	Sardegna	Sud Sardegna	SU	12047
IT	9029	Setzu	Sardegna	Sud Sardegna	SU	12048
IT	9030	Samassi	Sardegna	Sud Sardegna	SU	12049
IT	9030	Pabillonis	Sardegna	Sud Sardegna	SU	12050
IT	9030	Sardara	Sardegna	Sud Sardegna	SU	12051
IT	9030	Montevecchio	Sardegna	Sud Sardegna	SU	12052
IT	9031	Sant'Antonio Di Santadi	Sardegna	Sud Sardegna	SU	12053
IT	9031	Ingurtosu	Sardegna	Sud Sardegna	SU	12054
IT	9031	Arbus	Sardegna	Sud Sardegna	SU	12055
IT	9031	Gennamari	Sardegna	Sud Sardegna	SU	12056
IT	9035	Gonnosfanadiga	Sardegna	Sud Sardegna	SU	12057
IT	9036	Guspini	Sardegna	Sud Sardegna	SU	12058
IT	9037	San Gavino Monreale	Sardegna	Sud Sardegna	SU	12059
IT	9038	Serramanna	Sardegna	Sud Sardegna	SU	12060
IT	9039	Villacidro	Sardegna	Sud Sardegna	SU	12061
IT	9040	Furtei	Sardegna	Sud Sardegna	SU	12062
IT	9040	Segariu	Sardegna	Sud Sardegna	SU	12063
IT	92010	Burgio	Sicilia	Agrigento	AG	12064
IT	92010	Caltabellotta	Sicilia	Agrigento	AG	12065
IT	92010	Lampedusa	Sicilia	Agrigento	AG	12066
IT	92010	Sant'Anna	Sicilia	Agrigento	AG	12067
IT	92010	Montevago	Sicilia	Agrigento	AG	12068
IT	92010	Realmonte	Sicilia	Agrigento	AG	12069
IT	92010	Montallegro	Sicilia	Agrigento	AG	12070
IT	92010	Calamonaci	Sicilia	Agrigento	AG	12071
IT	92010	Bivona	Sicilia	Agrigento	AG	12072
IT	92010	Alessandria Della Rocca	Sicilia	Agrigento	AG	12073
IT	92010	Siculiana	Sicilia	Agrigento	AG	12074
IT	92010	Sant'Anna Di Caltabellotta	Sicilia	Agrigento	AG	12075
IT	92010	Lucca Sicula	Sicilia	Agrigento	AG	12076
IT	92010	Linosa	Sicilia	Agrigento	AG	12077
IT	92010	Joppolo Giancaxio	Sicilia	Agrigento	AG	12078
IT	92010	Lampedusa E Linosa	Sicilia	Agrigento	AG	12079
IT	92011	Cattolica Eraclea	Sicilia	Agrigento	AG	12080
IT	92012	Cianciana	Sicilia	Agrigento	AG	12081
IT	92013	Menfi	Sicilia	Agrigento	AG	12082
IT	92014	Porto Empedocle	Sicilia	Agrigento	AG	12083
IT	92015	Raffadali	Sicilia	Agrigento	AG	12084
IT	92016	Ribera	Sicilia	Agrigento	AG	12085
IT	92016	Borgo Bonsignore	Sicilia	Agrigento	AG	12086
IT	92017	Sambuca Di Sicilia	Sicilia	Agrigento	AG	12087
IT	92018	Santa Margherita Di Belice	Sicilia	Agrigento	AG	12088
IT	92019	Sciacca	Sicilia	Agrigento	AG	12089
IT	92020	Castrofilippo	Sicilia	Agrigento	AG	12090
IT	92020	San Biagio Platani	Sicilia	Agrigento	AG	12091
IT	92020	Santo Stefano Quisquina	Sicilia	Agrigento	AG	12092
IT	92020	Grotte	Sicilia	Agrigento	AG	12093
IT	92020	Racalmuto	Sicilia	Agrigento	AG	12094
IT	92020	Sant'Angelo Muxaro	Sicilia	Agrigento	AG	12095
IT	92020	Santa Elisabetta	Sicilia	Agrigento	AG	12096
IT	92020	Camastra	Sicilia	Agrigento	AG	12097
IT	92020	Villafranca Sicula	Sicilia	Agrigento	AG	12098
IT	92020	Comitini	Sicilia	Agrigento	AG	12099
IT	92020	San Giovanni Gemini	Sicilia	Agrigento	AG	12100
IT	92020	Palma Di Montechiaro	Sicilia	Agrigento	AG	12101
IT	92021	Aragona	Sicilia	Agrigento	AG	12102
IT	92021	Caldare	Sicilia	Agrigento	AG	12103
IT	92022	Borgo Callea	Sicilia	Agrigento	AG	12104
IT	92022	Cammarata	Sicilia	Agrigento	AG	12105
IT	92023	Campobello Di Licata	Sicilia	Agrigento	AG	12106
IT	92024	Canicatti'	Sicilia	Agrigento	AG	12107
IT	92025	Casteltermini	Sicilia	Agrigento	AG	12108
IT	92025	Casteltermini Zolfare	Sicilia	Agrigento	AG	12109
IT	92025	Zolfare	Sicilia	Agrigento	AG	12110
IT	92026	Favara	Sicilia	Agrigento	AG	12111
IT	92027	Licata	Sicilia	Agrigento	AG	12112
IT	92028	Naro	Sicilia	Agrigento	AG	12113
IT	92029	Ravanusa	Sicilia	Agrigento	AG	12114
IT	92029	Campobello Ravanusa Stazione	Sicilia	Agrigento	AG	12115
IT	92100	Giardina Gallotti	Sicilia	Agrigento	AG	12116
IT	92100	Agrigento	Sicilia	Agrigento	AG	12117
IT	92100	San Leone Mose'	Sicilia	Agrigento	AG	12118
IT	92100	Montaperto	Sicilia	Agrigento	AG	12119
IT	92100	Villaggio Mose'	Sicilia	Agrigento	AG	12120
IT	92100	Villaseta	Sicilia	Agrigento	AG	12121
IT	92100	Borgo La Loggia	Sicilia	Agrigento	AG	12122
IT	93010	Resuttano	Sicilia	Caltanissetta	CL	12123
IT	93010	Marianopoli	Sicilia	Caltanissetta	CL	12124
IT	93010	Milena	Sicilia	Caltanissetta	CL	12125
IT	93010	Delia	Sicilia	Caltanissetta	CL	12126
IT	93010	Bompensiere	Sicilia	Caltanissetta	CL	12127
IT	93010	Sutera	Sicilia	Caltanissetta	CL	12128
IT	93010	Montedoro	Sicilia	Caltanissetta	CL	12129
IT	93010	Acquaviva Platani	Sicilia	Caltanissetta	CL	12130
IT	93010	Campofranco	Sicilia	Caltanissetta	CL	12131
IT	93010	Serradifalco	Sicilia	Caltanissetta	CL	12132
IT	93010	Villalba	Sicilia	Caltanissetta	CL	12133
IT	93010	Vallelunga Pratameno	Sicilia	Caltanissetta	CL	12134
IT	93011	Butera	Sicilia	Caltanissetta	CL	12135
IT	93012	Gela	Sicilia	Caltanissetta	CL	12136
IT	93013	Mazzarino	Sicilia	Caltanissetta	CL	12137
IT	93014	Polizzello	Sicilia	Caltanissetta	CL	12138
IT	93014	Mussomeli	Sicilia	Caltanissetta	CL	12139
IT	93015	Niscemi	Sicilia	Caltanissetta	CL	12140
IT	93016	Riesi	Sicilia	Caltanissetta	CL	12141
IT	93017	San Cataldo	Sicilia	Caltanissetta	CL	12142
IT	93018	Santa Caterina Villarmosa	Sicilia	Caltanissetta	CL	12143
IT	93019	Trabia Miniere	Sicilia	Caltanissetta	CL	12144
IT	93019	Sommatino	Sicilia	Caltanissetta	CL	12145
IT	93100	Caltanissetta	Sicilia	Caltanissetta	CL	12146
IT	93100	Borgo Petilia	Sicilia	Caltanissetta	CL	12147
IT	93100	Villaggio Santa Barbara	Sicilia	Caltanissetta	CL	12148
IT	93100	Favarella	Sicilia	Caltanissetta	CL	12149
IT	95010	Santa Venerina	Sicilia	Catania	CT	12150
IT	95010	Milo	Sicilia	Catania	CT	12151
IT	95010	Sant'Alfio	Sicilia	Catania	CT	12152
IT	95010	Fornazzo	Sicilia	Catania	CT	12153
IT	95010	Linera	Sicilia	Catania	CT	12154
IT	95010	Dagala Del Re	Sicilia	Catania	CT	12155
IT	95011	Pasteria	Sicilia	Catania	CT	12156
IT	95011	Calatabiano	Sicilia	Catania	CT	12157
IT	95012	Verzella	Sicilia	Catania	CT	12158
IT	95012	Solicchiata	Sicilia	Catania	CT	12159
IT	95012	Castiglione Di Sicilia	Sicilia	Catania	CT	12160
IT	95012	Mitogio	Sicilia	Catania	CT	12161
IT	95012	Passopisciaro	Sicilia	Catania	CT	12162
IT	95013	Fiumefreddo Di Sicilia	Sicilia	Catania	CT	12163
IT	95014	San Giovanni	Sicilia	Catania	CT	12164
IT	95014	Carruba	Sicilia	Catania	CT	12165
IT	95014	Giarre	Sicilia	Catania	CT	12166
IT	95014	San Leonardello	Sicilia	Catania	CT	12167
IT	95014	Altarello	Sicilia	Catania	CT	12168
IT	95014	Macchia Di Giarre	Sicilia	Catania	CT	12169
IT	95014	Trepunti	Sicilia	Catania	CT	12170
IT	95014	San Giovanni Montebello	Sicilia	Catania	CT	12171
IT	95015	Linguaglossa	Sicilia	Catania	CT	12172
IT	95016	Portosalvo	Sicilia	Catania	CT	12173
IT	95016	Mascali	Sicilia	Catania	CT	12174
IT	95016	Nunziata	Sicilia	Catania	CT	12175
IT	95016	Santa Venera	Sicilia	Catania	CT	12176
IT	95016	Puntalazzo	Sicilia	Catania	CT	12177
IT	95016	Carrabba	Sicilia	Catania	CT	12178
IT	95017	Vena	Sicilia	Catania	CT	12179
IT	95017	Piedimonte Etneo	Sicilia	Catania	CT	12180
IT	95017	Presa	Sicilia	Catania	CT	12181
IT	95018	Riposto	Sicilia	Catania	CT	12182
IT	95018	Torre Archirafi	Sicilia	Catania	CT	12183
IT	95019	Fleri	Sicilia	Catania	CT	12184
IT	95019	Zafferana Etnea	Sicilia	Catania	CT	12185
IT	95019	Sarro	Sicilia	Catania	CT	12186
IT	95019	Pisano Etneo	Sicilia	Catania	CT	12187
IT	95020	Aci Bonaccorsi	Sicilia	Catania	CT	12188
IT	95021	Aci Castello	Sicilia	Catania	CT	12189
IT	95021	Cannizzaro	Sicilia	Catania	CT	12190
IT	95021	Ficarazzi	Sicilia	Catania	CT	12191
IT	95021	Aci Trezza	Sicilia	Catania	CT	12192
IT	95022	San Nicolo'	Sicilia	Catania	CT	12193
IT	95022	Aci Catena	Sicilia	Catania	CT	12194
IT	95022	Nizzeti	Sicilia	Catania	CT	12195
IT	95022	Aci San Filippo	Sicilia	Catania	CT	12196
IT	95022	Eremo Sant'Anna	Sicilia	Catania	CT	12197
IT	95022	Vampolieri	Sicilia	Catania	CT	12198
IT	95024	Acireale	Sicilia	Catania	CT	12199
IT	95024	Santa Tecla Di Acireale	Sicilia	Catania	CT	12200
IT	95024	Stazzo	Sicilia	Catania	CT	12201
IT	95024	Pennisi	Sicilia	Catania	CT	12202
IT	95024	Santa Maria La Scala	Sicilia	Catania	CT	12203
IT	95024	Guardia	Sicilia	Catania	CT	12204
IT	95024	Santa Maria Degli Ammalati	Sicilia	Catania	CT	12205
IT	95024	Scillichenti	Sicilia	Catania	CT	12206
IT	95024	Piano D'Api	Sicilia	Catania	CT	12207
IT	95024	Aci Platani	Sicilia	Catania	CT	12208
IT	95024	Pozzillo	Sicilia	Catania	CT	12209
IT	95024	Mangano	Sicilia	Catania	CT	12210
IT	95025	Lavinaio	Sicilia	Catania	CT	12211
IT	95025	Aci Sant'Antonio	Sicilia	Catania	CT	12212
IT	95025	Santa Maria La Stella	Sicilia	Catania	CT	12213
IT	95025	Monterosso	Sicilia	Catania	CT	12214
IT	95025	Lavina	Sicilia	Catania	CT	12215
IT	95025	Monterosso Etneo	Sicilia	Catania	CT	12216
IT	95027	San Gregorio Di Catania	Sicilia	Catania	CT	12217
IT	95027	Cerza	Sicilia	Catania	CT	12218
IT	95028	Valverde	Sicilia	Catania	CT	12219
IT	95029	Viagrande	Sicilia	Catania	CT	12220
IT	95030	Mascalucia	Sicilia	Catania	CT	12221
IT	95030	Sant'Agata Li Battiati	Sicilia	Catania	CT	12222
IT	95030	Tremestieri Etneo	Sicilia	Catania	CT	12223
IT	95030	Maniace	Sicilia	Catania	CT	12224
IT	95030	Canalicchio	Sicilia	Catania	CT	12225
IT	95030	Nicolosi	Sicilia	Catania	CT	12226
IT	95030	Gravina Di Catania	Sicilia	Catania	CT	12227
IT	95030	San Pietro Clarenza	Sicilia	Catania	CT	12228
IT	95030	Ragalna	Sicilia	Catania	CT	12229
IT	95030	Pedara	Sicilia	Catania	CT	12230
IT	95031	Adrano	Sicilia	Catania	CT	12231
IT	95032	Villaggio Le Ginestre	Sicilia	Catania	CT	12232
IT	95032	Belpasso	Sicilia	Catania	CT	12233
IT	95032	Piano Tavola	Sicilia	Catania	CT	12234
IT	95032	Palazzolo	Sicilia	Catania	CT	12235
IT	95032	Villaggio Del Pino	Sicilia	Catania	CT	12236
IT	95032	Borrello Di Catania	Sicilia	Catania	CT	12237
IT	95033	Biancavilla	Sicilia	Catania	CT	12238
IT	95034	Bronte	Sicilia	Catania	CT	12239
IT	95035	Maletto	Sicilia	Catania	CT	12240
IT	95036	Randazzo	Sicilia	Catania	CT	12241
IT	95036	Calderara	Sicilia	Catania	CT	12242
IT	95037	Trappeto	Sicilia	Catania	CT	12243
IT	95037	San Giovanni La Punta	Sicilia	Catania	CT	12244
IT	95038	Santa Maria Di Licodia	Sicilia	Catania	CT	12245
IT	95039	Trecastagni	Sicilia	Catania	CT	12246
IT	95040	Camporotondo Etneo	Sicilia	Catania	CT	12247
IT	95040	Licodia Eubea	Sicilia	Catania	CT	12248
IT	95040	Mirabella Imbaccari	Sicilia	Catania	CT	12249
IT	95040	Carrubbo	Sicilia	Catania	CT	12250
IT	95040	Giumarra	Sicilia	Catania	CT	12251
IT	95040	Mazzarrone	Sicilia	Catania	CT	12252
IT	95040	San Michele Di Ganzaria	Sicilia	Catania	CT	12253
IT	95040	Ramacca	Sicilia	Catania	CT	12254
IT	95040	Motta Sant'Anastasia	Sicilia	Catania	CT	12255
IT	95040	Cinquegrana	Sicilia	Catania	CT	12256
IT	95040	San Cono	Sicilia	Catania	CT	12257
IT	95040	Raddusa	Sicilia	Catania	CT	12258
IT	95040	Castel Di Iudica	Sicilia	Catania	CT	12259
IT	95041	San Pietro Di Caltagirone	Sicilia	Catania	CT	12260
IT	95041	Granieri	Sicilia	Catania	CT	12261
IT	95041	Caltagirone	Sicilia	Catania	CT	12262
IT	95041	Santo Pietro	Sicilia	Catania	CT	12263
IT	95042	Grammichele	Sicilia	Catania	CT	12264
IT	95043	Militello In Val Di Catania	Sicilia	Catania	CT	12265
IT	95044	Borgo Lupo	Sicilia	Catania	CT	12266
IT	95044	Mineo	Sicilia	Catania	CT	12267
IT	95045	San Nullo	Sicilia	Catania	CT	12268
IT	95045	Misterbianco	Sicilia	Catania	CT	12269
IT	95046	Palagonia	Sicilia	Catania	CT	12270
IT	95047	Sferro	Sicilia	Catania	CT	12271
IT	95047	Paterno'	Sicilia	Catania	CT	12272
IT	95048	Scordia	Sicilia	Catania	CT	12273
IT	95049	Vizzini	Sicilia	Catania	CT	12274
IT	95100	Catania	Sicilia	Catania	CT	12275
IT	95121	Fontanarossa Aereoporto	Sicilia	Catania	CT	12276
IT	95121	Catania	Sicilia	Catania	CT	12277
IT	95121	Zia Lisa	Sicilia	Catania	CT	12278
IT	95121	San Giorgio	Sicilia	Catania	CT	12279
IT	95121	San Giuseppe Alla Rena	Sicilia	Catania	CT	12280
IT	95121	Santa Maria Goretti	Sicilia	Catania	CT	12281
IT	95121	San Teodoro	Sicilia	Catania	CT	12282
IT	95122	Catania	Sicilia	Catania	CT	12283
IT	95122	Nesima Superiore	Sicilia	Catania	CT	12284
IT	95122	Nesima Inferiore	Sicilia	Catania	CT	12285
IT	95122	Acquicella	Sicilia	Catania	CT	12286
IT	95123	Catania	Sicilia	Catania	CT	12287
IT	95123	Cibali	Sicilia	Catania	CT	12288
IT	95123	San Nullo	Sicilia	Catania	CT	12289
IT	95124	Catania	Sicilia	Catania	CT	12290
IT	95125	Canalicchio	Sicilia	Catania	CT	12291
IT	95125	Catania	Sicilia	Catania	CT	12292
IT	95125	Barriera Del Bosco	Sicilia	Catania	CT	12293
IT	95126	Catania	Sicilia	Catania	CT	12294
IT	95126	Ognina	Sicilia	Catania	CT	12295
IT	95127	Catania	Sicilia	Catania	CT	12296
IT	95127	Picanello	Sicilia	Catania	CT	12297
IT	95128	Catania	Sicilia	Catania	CT	12298
IT	95129	Catania	Sicilia	Catania	CT	12299
IT	95131	Catania	Sicilia	Catania	CT	12300
IT	94010	Calascibetta	Sicilia	Enna	EN	12301
IT	94010	San Giorgio	Sicilia	Enna	EN	12302
IT	94010	Cerami	Sicilia	Enna	EN	12303
IT	94010	Aidone	Sicilia	Enna	EN	12304
IT	94010	Assoro	Sicilia	Enna	EN	12305
IT	94010	Sperlinga	Sicilia	Enna	EN	12306
IT	94010	Catenanuova	Sicilia	Enna	EN	12307
IT	94010	Nissoria	Sicilia	Enna	EN	12308
IT	94010	Villapriolo	Sicilia	Enna	EN	12309
IT	94010	Gagliano Castelferrato	Sicilia	Enna	EN	12310
IT	94010	Centuripe	Sicilia	Enna	EN	12311
IT	94010	Cacchiamo	Sicilia	Enna	EN	12312
IT	94010	Villarosa	Sicilia	Enna	EN	12313
IT	94010	Borgo Baccarato	Sicilia	Enna	EN	12314
IT	94011	Agira	Sicilia	Enna	EN	12315
IT	94012	Barrafranca	Sicilia	Enna	EN	12316
IT	94013	Leonforte	Sicilia	Enna	EN	12317
IT	94014	Nicosia	Sicilia	Enna	EN	12318
IT	94014	Villadoro	Sicilia	Enna	EN	12319
IT	94014	San Giacomo	Sicilia	Enna	EN	12320
IT	94015	Piazza Armerina	Sicilia	Enna	EN	12321
IT	94015	Grottacalda	Sicilia	Enna	EN	12322
IT	94016	Pietraperzia	Sicilia	Enna	EN	12323
IT	94017	Regalbuto	Sicilia	Enna	EN	12324
IT	94018	Troina	Sicilia	Enna	EN	12325
IT	94019	Valguarnera Caropepe	Sicilia	Enna	EN	12326
IT	94100	Enna	Sicilia	Enna	EN	12327
IT	94100	Borgo Cascino	Sicilia	Enna	EN	12328
IT	94100	Pergusa	Sicilia	Enna	EN	12329
IT	98020	Ali'	Sicilia	Messina	ME	12330
IT	98020	Rocchenere	Sicilia	Messina	ME	12331
IT	98020	Pagliara	Sicilia	Messina	ME	12332
IT	98020	Mandanici	Sicilia	Messina	ME	12333
IT	98020	Locadi	Sicilia	Messina	ME	12334
IT	98021	Ali' Terme	Sicilia	Messina	ME	12335
IT	98022	Fiumedinisi	Sicilia	Messina	ME	12336
IT	98023	Furci Siculo	Sicilia	Messina	ME	12337
IT	98025	Itala Marina	Sicilia	Messina	ME	12338
IT	98025	Itala	Sicilia	Messina	ME	12339
IT	98026	Nizza Di Sicilia	Sicilia	Messina	ME	12340
IT	98027	Sciglio	Sicilia	Messina	ME	12341
IT	98027	Roccalumera	Sicilia	Messina	ME	12342
IT	98027	Allume	Sicilia	Messina	ME	12343
IT	98028	Misserio	Sicilia	Messina	ME	12344
IT	98028	Santa Teresa Di Riva	Sicilia	Messina	ME	12345
IT	98028	Barracca	Sicilia	Messina	ME	12346
IT	98029	Guidomandri Superiore	Sicilia	Messina	ME	12347
IT	98029	Guidomandri Marina	Sicilia	Messina	ME	12348
IT	98029	Scaletta Zanclea	Sicilia	Messina	ME	12349
IT	98029	Guidomandri	Sicilia	Messina	ME	12350
IT	98030	Gaggi	Sicilia	Messina	ME	12351
IT	98030	Roccella Valdemone	Sicilia	Messina	ME	12352
IT	98030	Moio Alcantara	Sicilia	Messina	ME	12353
IT	98030	Limina	Sicilia	Messina	ME	12354
IT	98030	San Teodoro	Sicilia	Messina	ME	12355
IT	98030	Malvagna	Sicilia	Messina	ME	12356
IT	98030	Floresta	Sicilia	Messina	ME	12357
IT	98030	Motta Camastra	Sicilia	Messina	ME	12358
IT	98030	Gallodoro	Sicilia	Messina	ME	12359
IT	98030	Melia	Sicilia	Messina	ME	12360
IT	98030	Mongiuffi	Sicilia	Messina	ME	12361
IT	98030	Roccafiorita	Sicilia	Messina	ME	12362
IT	98030	Sant'Alessio Siculo	Sicilia	Messina	ME	12363
IT	98030	Mongiuffi Melia	Sicilia	Messina	ME	12364
IT	98030	Santa Domenica Vittoria	Sicilia	Messina	ME	12365
IT	98030	Forza D'Agro'	Sicilia	Messina	ME	12366
IT	98030	Castelmola	Sicilia	Messina	ME	12367
IT	98030	Antillo	Sicilia	Messina	ME	12368
IT	98031	Capizzi	Sicilia	Messina	ME	12369
IT	98032	Misitano Superiore	Sicilia	Messina	ME	12370
IT	98032	Misitano	Sicilia	Messina	ME	12371
IT	98032	Casalvecchio Siculo	Sicilia	Messina	ME	12372
IT	98032	Misitano Inferiore	Sicilia	Messina	ME	12373
IT	98033	Cesaro'	Sicilia	Messina	ME	12374
IT	98034	Francavilla Di Sicilia	Sicilia	Messina	ME	12375
IT	98035	Pallio	Sicilia	Messina	ME	12376
IT	98035	Naxos	Sicilia	Messina	ME	12377
IT	98035	Giardini Naxos	Sicilia	Messina	ME	12378
IT	98036	Graniti	Sicilia	Messina	ME	12379
IT	98037	Letojanni	Sicilia	Messina	ME	12380
IT	98038	Rina	Sicilia	Messina	ME	12381
IT	98038	Savoca	Sicilia	Messina	ME	12382
IT	98039	Mazzeo	Sicilia	Messina	ME	12383
IT	98039	Mazzaro'	Sicilia	Messina	ME	12384
IT	98039	Taormina	Sicilia	Messina	ME	12385
IT	98039	Chianchitta	Sicilia	Messina	ME	12386
IT	98039	Trappitello	Sicilia	Messina	ME	12387
IT	98040	Torregrotta	Sicilia	Messina	ME	12388
IT	98040	Venetico Marina	Sicilia	Messina	ME	12389
IT	98040	Fondachello	Sicilia	Messina	ME	12390
IT	98040	Gualtieri Sicamino'	Sicilia	Messina	ME	12391
IT	98040	Venetico Superiore	Sicilia	Messina	ME	12392
IT	98040	Roccavaldina	Sicilia	Messina	ME	12393
IT	98040	Valdina	Sicilia	Messina	ME	12394
IT	98040	Condro'	Sicilia	Messina	ME	12395
IT	98040	Venetico	Sicilia	Messina	ME	12396
IT	98040	Scala Di Torregrotta	Sicilia	Messina	ME	12397
IT	98040	Meri'	Sicilia	Messina	ME	12398
IT	98040	Soccorso	Sicilia	Messina	ME	12399
IT	98041	Monforte Marina	Sicilia	Messina	ME	12400
IT	98041	Pellegrino	Sicilia	Messina	ME	12401
IT	98041	Monforte San Giorgio	Sicilia	Messina	ME	12402
IT	98042	Pace Del Mela	Sicilia	Messina	ME	12403
IT	98042	Giammoro	Sicilia	Messina	ME	12404
IT	98043	Rometta Marea	Sicilia	Messina	ME	12405
IT	98043	Sant'Andrea	Sicilia	Messina	ME	12406
IT	98043	Rometta	Sicilia	Messina	ME	12407
IT	98043	Gimello	Sicilia	Messina	ME	12408
IT	98044	Olivarella	Sicilia	Messina	ME	12409
IT	98044	San Filippo Del Mela	Sicilia	Messina	ME	12410
IT	98044	Corriolo	Sicilia	Messina	ME	12411
IT	98044	Archi	Sicilia	Messina	ME	12412
IT	98044	Cattafi	Sicilia	Messina	ME	12413
IT	98045	San Pier Niceto	Sicilia	Messina	ME	12414
IT	98045	San Pier Marina	Sicilia	Messina	ME	12415
IT	98046	Santa Lucia Del Mela	Sicilia	Messina	ME	12416
IT	98047	Saponara	Sicilia	Messina	ME	12417
IT	98047	Saponara Marittima	Sicilia	Messina	ME	12418
IT	98047	Scarcelli	Sicilia	Messina	ME	12419
IT	98047	Cavaliere	Sicilia	Messina	ME	12420
IT	98048	San Martino Spadafora	Sicilia	Messina	ME	12421
IT	98048	Spadafora	Sicilia	Messina	ME	12422
IT	98048	San Martino	Sicilia	Messina	ME	12423
IT	98049	Calvaruso	Sicilia	Messina	ME	12424
IT	98049	Serro	Sicilia	Messina	ME	12425
IT	98049	Villafranca Tirrena	Sicilia	Messina	ME	12426
IT	98049	Divieto	Sicilia	Messina	ME	12427
IT	98050	Panarea	Sicilia	Messina	ME	12428
IT	98050	Vulcano Porto	Sicilia	Messina	ME	12429
IT	98050	Pecorini A Mare	Sicilia	Messina	ME	12430
IT	98050	Leni	Sicilia	Messina	ME	12431
IT	98050	Ginostra Di Lipari	Sicilia	Messina	ME	12432
IT	98050	Santa Marina Salina	Sicilia	Messina	ME	12433
IT	98050	Ginostra	Sicilia	Messina	ME	12434
IT	98050	Lingua	Sicilia	Messina	ME	12435
IT	98050	Stromboli	Sicilia	Messina	ME	12436
IT	98050	Malfa	Sicilia	Messina	ME	12437
IT	98050	Fantina	Sicilia	Messina	ME	12438
IT	98050	Evangelisti	Sicilia	Messina	ME	12439
IT	98050	Terme Vigliatore	Sicilia	Messina	ME	12440
IT	98050	Fondachelli Fantina	Sicilia	Messina	ME	12441
IT	98050	Vigliatore	Sicilia	Messina	ME	12442
IT	98050	Vulcano	Sicilia	Messina	ME	12443
IT	98050	Castroreale Terme	Sicilia	Messina	ME	12444
IT	98050	Rubino	Sicilia	Messina	ME	12445
IT	98050	Filicudi Porto	Sicilia	Messina	ME	12446
IT	98050	Filicudi	Sicilia	Messina	ME	12447
IT	98050	Alicudi Porto	Sicilia	Messina	ME	12448
IT	98050	Alicudi	Sicilia	Messina	ME	12449
IT	98051	Sant'Antonio	Sicilia	Messina	ME	12450
IT	98051	La Gala	Sicilia	Messina	ME	12451
IT	98051	San Paolo	Sicilia	Messina	ME	12452
IT	98051	Cannistra'	Sicilia	Messina	ME	12453
IT	98051	Acquaficara	Sicilia	Messina	ME	12454
IT	98051	Gala	Sicilia	Messina	ME	12455
IT	98051	Barcellona Pozzo Di Gotto	Sicilia	Messina	ME	12456
IT	98051	Pozzo Di Gotto	Sicilia	Messina	ME	12457
IT	98051	Porto Salvo	Sicilia	Messina	ME	12458
IT	98051	Caldera'	Sicilia	Messina	ME	12459
IT	98051	Sant'Antonino Convento	Sicilia	Messina	ME	12460
IT	98053	Bafia	Sicilia	Messina	ME	12461
IT	98053	Protonotaro	Sicilia	Messina	ME	12462
IT	98053	Castroreale	Sicilia	Messina	ME	12463
IT	98054	Tonnarella	Sicilia	Messina	ME	12464
IT	98054	Furnari	Sicilia	Messina	ME	12465
IT	98055	Acquacalda	Sicilia	Messina	ME	12466
IT	98055	Canneto Lipari	Sicilia	Messina	ME	12467
IT	98055	Quattropani	Sicilia	Messina	ME	12468
IT	98055	Lipari	Sicilia	Messina	ME	12469
IT	98055	Pianoconte	Sicilia	Messina	ME	12470
IT	98055	Canneto	Sicilia	Messina	ME	12471
IT	98056	Mazzarra' Sant'Andrea	Sicilia	Messina	ME	12472
IT	98057	Milazzo	Sicilia	Messina	ME	12473
IT	98057	San Pietro Di Milazzo	Sicilia	Messina	ME	12474
IT	98057	Santa Marina Di Milazzo	Sicilia	Messina	ME	12475
IT	98058	Novara Di Sicilia	Sicilia	Messina	ME	12476
IT	98058	San Basilio Di Novara Di Sicilia	Sicilia	Messina	ME	12477
IT	98059	Rodi' Milici	Sicilia	Messina	ME	12478
IT	98059	Milici	Sicilia	Messina	ME	12479
IT	98060	Falcone	Sicilia	Messina	ME	12480
IT	98060	Basico'	Sicilia	Messina	ME	12481
IT	98060	Fiumara Di Piraino	Sicilia	Messina	ME	12482
IT	98060	Sant'Angelo Di Brolo	Sicilia	Messina	ME	12483
IT	98060	Tripi	Sicilia	Messina	ME	12484
IT	98060	Gliaca	Sicilia	Messina	ME	12485
IT	98060	Campogrande	Sicilia	Messina	ME	12486
IT	98060	San Silvestro	Sicilia	Messina	ME	12487
IT	98060	Cavallo Pastorio	Sicilia	Messina	ME	12488
IT	98060	Montagnareale	Sicilia	Messina	ME	12489
IT	98060	Santa Maria Lo Piano	Sicilia	Messina	ME	12490
IT	98060	Ucria	Sicilia	Messina	ME	12491
IT	98060	Belvedere	Sicilia	Messina	ME	12492
IT	98060	Oliveri	Sicilia	Messina	ME	12493
IT	98060	Piraino	Sicilia	Messina	ME	12494
IT	98060	Salina'	Sicilia	Messina	ME	12495
IT	98060	San Lorenzitto	Sicilia	Messina	ME	12496
IT	98061	Brolo	Sicilia	Messina	ME	12497
IT	98062	Ficarra	Sicilia	Messina	ME	12498
IT	98063	San Giorgio	Sicilia	Messina	ME	12499
IT	98063	Magaro	Sicilia	Messina	ME	12500
IT	98063	Gioiosa Marea	Sicilia	Messina	ME	12501
IT	98064	Nasidi	Sicilia	Messina	ME	12502
IT	98064	Colla Maffone	Sicilia	Messina	ME	12503
IT	98064	Librizzi	Sicilia	Messina	ME	12504
IT	98065	Braidi	Sicilia	Messina	ME	12505
IT	98065	Montalbano Elicona	Sicilia	Messina	ME	12506
IT	98065	Santa Barbara	Sicilia	Messina	ME	12507
IT	98066	Scala	Sicilia	Messina	ME	12508
IT	98066	Mongiove	Sicilia	Messina	ME	12509
IT	98066	Case Nuove Russo	Sicilia	Messina	ME	12510
IT	98066	Patti	Sicilia	Messina	ME	12511
IT	98066	San Cosimo	Sicilia	Messina	ME	12512
IT	98066	Tindari	Sicilia	Messina	ME	12513
IT	98066	Marina Di Patti	Sicilia	Messina	ME	12514
IT	98067	Zappa	Sicilia	Messina	ME	12515
IT	98067	Raccuja	Sicilia	Messina	ME	12516
IT	98067	Fondachello Di Raccuja	Sicilia	Messina	ME	12517
IT	98068	Fiumara	Sicilia	Messina	ME	12518
IT	98068	San Piero Patti	Sicilia	Messina	ME	12519
IT	98068	Tesoriero	Sicilia	Messina	ME	12520
IT	98069	Sinagra	Sicilia	Messina	ME	12521
IT	98070	Militello Rosmarino	Sicilia	Messina	ME	12522
IT	98070	Motta D'Affermo	Sicilia	Messina	ME	12523
IT	98070	Pettineo	Sicilia	Messina	ME	12524
IT	98070	Acquedolci	Sicilia	Messina	ME	12525
IT	98070	Frazzano'	Sicilia	Messina	ME	12526
IT	98070	Galati Mamertino	Sicilia	Messina	ME	12527
IT	98070	Rocca Di Capri Leone	Sicilia	Messina	ME	12528
IT	98070	Capri Leone	Sicilia	Messina	ME	12529
IT	98070	Alcara Li Fusi	Sicilia	Messina	ME	12530
IT	98070	Longi	Sicilia	Messina	ME	12531
IT	98070	Torremuzza	Sicilia	Messina	ME	12532
IT	98070	Castell'Umberto	Sicilia	Messina	ME	12533
IT	98070	Mirto	Sicilia	Messina	ME	12534
IT	98070	San Basilio	Sicilia	Messina	ME	12535
IT	98070	Castel Di Lucio	Sicilia	Messina	ME	12536
IT	98070	San Marco D'Alunzio	Sicilia	Messina	ME	12537
IT	98070	San Salvatore Di Fitalia	Sicilia	Messina	ME	12538
IT	98070	Sfaranda	Sicilia	Messina	ME	12539
IT	98070	Torrenova	Sicilia	Messina	ME	12540
IT	98070	Reitano	Sicilia	Messina	ME	12541
IT	98071	Capo D'Orlando	Sicilia	Messina	ME	12542
IT	98071	Scafa	Sicilia	Messina	ME	12543
IT	98071	Piana Di Capo D'Orlando	Sicilia	Messina	ME	12544
IT	98072	Marina Di Caronia	Sicilia	Messina	ME	12545
IT	98072	Caronia	Sicilia	Messina	ME	12546
IT	98072	Canneto Di Caronia	Sicilia	Messina	ME	12547
IT	98073	Mistretta	Sicilia	Messina	ME	12548
IT	98074	Malo'	Sicilia	Messina	ME	12549
IT	98074	Cresta	Sicilia	Messina	ME	12550
IT	98074	Naso	Sicilia	Messina	ME	12551
IT	98075	San Fratello	Sicilia	Messina	ME	12552
IT	98076	Vallebruca	Sicilia	Messina	ME	12553
IT	98076	Sant'Agata Di Militello	Sicilia	Messina	ME	12554
IT	98076	Torrecandele	Sicilia	Messina	ME	12555
IT	98077	Santo Stefano Di Camastra	Sicilia	Messina	ME	12556
IT	98078	Sant'Antonino Sciortino	Sicilia	Messina	ME	12557
IT	98078	Moira	Sicilia	Messina	ME	12558
IT	98078	Tortorici	Sicilia	Messina	ME	12559
IT	98078	Grazia	Sicilia	Messina	ME	12560
IT	98078	Sceti	Sicilia	Messina	ME	12561
IT	98078	Ilombati	Sicilia	Messina	ME	12562
IT	98079	Tusa	Sicilia	Messina	ME	12563
IT	98079	Castel Di Tusa	Sicilia	Messina	ME	12564
IT	98100	Messina	Sicilia	Messina	ME	12565
IT	98121	Messina	Sicilia	Messina	ME	12566
IT	98122	Messina	Sicilia	Messina	ME	12567
IT	98123	Messina	Sicilia	Messina	ME	12568
IT	98124	Gazzi	Sicilia	Messina	ME	12569
IT	98124	Messina	Sicilia	Messina	ME	12570
IT	98125	Contesse	Sicilia	Messina	ME	12571
IT	98125	Messina	Sicilia	Messina	ME	12572
IT	98126	Santa Lucia Sopra Contesse	Sicilia	Messina	ME	12573
IT	98126	Messina	Sicilia	Messina	ME	12574
IT	98127	Messina	Sicilia	Messina	ME	12575
IT	98127	Zafferia	Sicilia	Messina	ME	12576
IT	98128	Messina	Sicilia	Messina	ME	12577
IT	98128	Tremestieri	Sicilia	Messina	ME	12578
IT	98129	Larderia	Sicilia	Messina	ME	12579
IT	98129	Messina	Sicilia	Messina	ME	12580
IT	98131	Mili Marina	Sicilia	Messina	ME	12581
IT	98131	Messina	Sicilia	Messina	ME	12582
IT	98132	Mili Marina	Sicilia	Messina	ME	12583
IT	98132	Mili San Marco	Sicilia	Messina	ME	12584
IT	98132	Messina	Sicilia	Messina	ME	12585
IT	98133	Mili Superiore	Sicilia	Messina	ME	12586
IT	98133	Messina	Sicilia	Messina	ME	12587
IT	98134	Galati Marina	Sicilia	Messina	ME	12588
IT	98134	Messina	Sicilia	Messina	ME	12589
IT	98135	Santo Stefano Medio	Sicilia	Messina	ME	12590
IT	98135	Messina	Sicilia	Messina	ME	12591
IT	98135	Santa Margherita	Sicilia	Messina	ME	12592
IT	98136	Messina	Sicilia	Messina	ME	12593
IT	98136	Santo Stefano Medio	Sicilia	Messina	ME	12594
IT	98137	Santo Stefano Di Briga	Sicilia	Messina	ME	12595
IT	98137	Messina	Sicilia	Messina	ME	12596
IT	98138	Pezzolo	Sicilia	Messina	ME	12597
IT	98138	Messina	Sicilia	Messina	ME	12598
IT	98139	Briga	Sicilia	Messina	ME	12599
IT	98139	San Placido Calonero'	Sicilia	Messina	ME	12600
IT	98139	Messina	Sicilia	Messina	ME	12601
IT	98139	Briga Marina	Sicilia	Messina	ME	12602
IT	98141	Messina	Sicilia	Messina	ME	12603
IT	98141	Giampilieri Marina	Sicilia	Messina	ME	12604
IT	98142	Giampilieri	Sicilia	Messina	ME	12605
IT	98142	Messina	Sicilia	Messina	ME	12606
IT	98142	San Filippo Inferiore	Sicilia	Messina	ME	12607
IT	98143	Molino	Sicilia	Messina	ME	12608
IT	98143	Messina	Sicilia	Messina	ME	12609
IT	98143	Altolia	Sicilia	Messina	ME	12610
IT	98144	Messina	Sicilia	Messina	ME	12611
IT	98144	San Filippo	Sicilia	Messina	ME	12612
IT	98145	Bordonaro	Sicilia	Messina	ME	12613
IT	98145	San Filippo	Sicilia	Messina	ME	12614
IT	98145	Messina	Sicilia	Messina	ME	12615
IT	98146	Cumia	Sicilia	Messina	ME	12616
IT	98146	Santo	Sicilia	Messina	ME	12617
IT	98146	Messina	Sicilia	Messina	ME	12618
IT	98147	Messina	Sicilia	Messina	ME	12619
IT	98147	Villaggio Aldisio	Sicilia	Messina	ME	12620
IT	98148	Santo	Sicilia	Messina	ME	12621
IT	98148	Messina	Sicilia	Messina	ME	12622
IT	98149	Camaro	Sicilia	Messina	ME	12623
IT	98149	Cataratti	Sicilia	Messina	ME	12624
IT	98149	Camaro Inferiore	Sicilia	Messina	ME	12625
IT	98149	Messina	Sicilia	Messina	ME	12626
IT	98151	Camaro	Sicilia	Messina	ME	12627
IT	98151	Messina	Sicilia	Messina	ME	12628
IT	98152	Messina	Sicilia	Messina	ME	12629
IT	98152	San Michele	Sicilia	Messina	ME	12630
IT	98152	Scala Ritiro	Sicilia	Messina	ME	12631
IT	98153	Gesso	Sicilia	Messina	ME	12632
IT	98153	Messina	Sicilia	Messina	ME	12633
IT	98154	Salice	Sicilia	Messina	ME	12634
IT	98154	Messina	Sicilia	Messina	ME	12635
IT	98154	Salice Calabro	Sicilia	Messina	ME	12636
IT	98155	Castanea Delle Furie	Sicilia	Messina	ME	12637
IT	98155	Castanea	Sicilia	Messina	ME	12638
IT	98155	Messina	Sicilia	Messina	ME	12639
IT	98156	Massa San Giorgio	Sicilia	Messina	ME	12640
IT	98156	Messina	Sicilia	Messina	ME	12641
IT	98157	Massa San Giovanni	Sicilia	Messina	ME	12642
IT	98157	Massa Santa Lucia	Sicilia	Messina	ME	12643
IT	98157	Messina	Sicilia	Messina	ME	12644
IT	98158	Faro Superiore	Sicilia	Messina	ME	12645
IT	98158	Messina	Sicilia	Messina	ME	12646
IT	98159	Liuzzo Orto	Sicilia	Messina	ME	12647
IT	98159	Messina	Sicilia	Messina	ME	12648
IT	98161	Rodia	Sicilia	Messina	ME	12649
IT	98161	Messina	Sicilia	Messina	ME	12650
IT	98162	San Saba	Sicilia	Messina	ME	12651
IT	98162	Messina	Sicilia	Messina	ME	12652
IT	98163	Sparta'	Sicilia	Messina	ME	12653
IT	98163	Messina	Sicilia	Messina	ME	12654
IT	98164	Torre Faro	Sicilia	Messina	ME	12655
IT	98164	Lido Di Mortelle	Sicilia	Messina	ME	12656
IT	98164	Messina	Sicilia	Messina	ME	12657
IT	98165	Messina	Sicilia	Messina	ME	12658
IT	98165	Ganzirri	Sicilia	Messina	ME	12659
IT	98166	Sant'Agata	Sicilia	Messina	ME	12660
IT	98166	Messina	Sicilia	Messina	ME	12661
IT	98167	Pace	Sicilia	Messina	ME	12662
IT	98167	Messina	Sicilia	Messina	ME	12663
IT	98168	Villaggio Annunziata	Sicilia	Messina	ME	12664
IT	98168	Messina	Sicilia	Messina	ME	12665
IT	98168	Pace	Sicilia	Messina	ME	12666
IT	98168	Contemplazione	Sicilia	Messina	ME	12667
IT	98168	Villaggio Paradiso	Sicilia	Messina	ME	12668
IT	90010	Pollina	Sicilia	Palermo	PA	12669
IT	90010	Isnello	Sicilia	Palermo	PA	12670
IT	90010	Lascari	Sicilia	Palermo	PA	12671
IT	90010	San Mauro Castelverde	Sicilia	Palermo	PA	12672
IT	90010	Cerda	Sicilia	Palermo	PA	12673
IT	90010	Finale	Sicilia	Palermo	PA	12674
IT	90010	Ustica	Sicilia	Palermo	PA	12675
IT	90010	Altavilla Milicia	Sicilia	Palermo	PA	12676
IT	90010	Ficarazzi	Sicilia	Palermo	PA	12677
IT	90010	Geraci Siculo	Sicilia	Palermo	PA	12678
IT	90010	Gratteri	Sicilia	Palermo	PA	12679
IT	90010	Torre Normanna	Sicilia	Palermo	PA	12680
IT	90010	Campofelice Di Roccella	Sicilia	Palermo	PA	12681
IT	90010	Borrello Di San Mauro Castelverde	Sicilia	Palermo	PA	12682
IT	90010	Lascari Scalo	Sicilia	Palermo	PA	12683
IT	90011	Aspra	Sicilia	Palermo	PA	12684
IT	90011	Bagheria	Sicilia	Palermo	PA	12685
IT	90012	Caccamo	Sicilia	Palermo	PA	12686
IT	90012	Sambuchi	Sicilia	Palermo	PA	12687
IT	90012	San Giovanni Li Greci	Sicilia	Palermo	PA	12688
IT	90013	Castelbuono	Sicilia	Palermo	PA	12689
IT	90014	Casteldaccia	Sicilia	Palermo	PA	12690
IT	90015	Sant'Ambrogio	Sicilia	Palermo	PA	12691
IT	90015	Gibilmanna	Sicilia	Palermo	PA	12692
IT	90015	Cefalu'	Sicilia	Palermo	PA	12693
IT	90016	Collesano	Sicilia	Palermo	PA	12694
IT	90017	Porticello	Sicilia	Palermo	PA	12695
IT	90017	Sant'Elia	Sicilia	Palermo	PA	12696
IT	90017	Santa Flavia	Sicilia	Palermo	PA	12697
IT	90018	Termini Imerese	Sicilia	Palermo	PA	12698
IT	90018	Danigarci	Sicilia	Palermo	PA	12699
IT	90019	Trabia	Sicilia	Palermo	PA	12700
IT	90019	San Nicolo' L'Arena	Sicilia	Palermo	PA	12701
IT	90020	Baucina	Sicilia	Palermo	PA	12702
IT	90020	Alimena	Sicilia	Palermo	PA	12703
IT	90020	Montemaggiore Belsito	Sicilia	Palermo	PA	12704
IT	90020	Ventimiglia Di Sicilia	Sicilia	Palermo	PA	12705
IT	90020	Locati	Sicilia	Palermo	PA	12706
IT	90020	Sclafani Bagni	Sicilia	Palermo	PA	12707
IT	90020	Blufi	Sicilia	Palermo	PA	12708
IT	90020	Vicari	Sicilia	Palermo	PA	12709
IT	90020	Sciara	Sicilia	Palermo	PA	12710
IT	90020	Nociazzi	Sicilia	Palermo	PA	12711
IT	90020	Calcarelli	Sicilia	Palermo	PA	12712
IT	90020	Roccapalumba	Sicilia	Palermo	PA	12713
IT	90020	Bompietro	Sicilia	Palermo	PA	12714
IT	90020	Scillato	Sicilia	Palermo	PA	12715
IT	90020	Castellana Sicula	Sicilia	Palermo	PA	12716
IT	90020	Nociazzi Inferiore	Sicilia	Palermo	PA	12717
IT	90020	Regalgioffoli	Sicilia	Palermo	PA	12718
IT	90020	Aliminusa	Sicilia	Palermo	PA	12719
IT	90021	Alia	Sicilia	Palermo	PA	12720
IT	90022	Caltavuturo	Sicilia	Palermo	PA	12721
IT	90023	Ciminna	Sicilia	Palermo	PA	12722
IT	90024	Gangi	Sicilia	Palermo	PA	12723
IT	90025	Lercara Friddi	Sicilia	Palermo	PA	12724
IT	90026	Fasano'	Sicilia	Palermo	PA	12725
IT	90026	Pianello	Sicilia	Palermo	PA	12726
IT	90026	Raffo	Sicilia	Palermo	PA	12727
IT	90026	Petralia Soprana	Sicilia	Palermo	PA	12728
IT	90026	Pianello Di Petralia Sottana	Sicilia	Palermo	PA	12729
IT	90027	Petralia Sottana	Sicilia	Palermo	PA	12730
IT	90028	Polizzi Generosa	Sicilia	Palermo	PA	12731
IT	90029	Valledolmo	Sicilia	Palermo	PA	12732
IT	90030	Giuliana	Sicilia	Palermo	PA	12733
IT	90030	Campofiorito	Sicilia	Palermo	PA	12734
IT	90030	Campofelice Di Fitalia	Sicilia	Palermo	PA	12735
IT	90030	Palazzo Adriano	Sicilia	Palermo	PA	12736
IT	90030	Altofonte	Sicilia	Palermo	PA	12737
IT	90030	Godrano	Sicilia	Palermo	PA	12738
IT	90030	Bolognetta	Sicilia	Palermo	PA	12739
IT	90030	Villafrati	Sicilia	Palermo	PA	12740
IT	90030	Piano Maglio	Sicilia	Palermo	PA	12741
IT	90030	Mezzojuso	Sicilia	Palermo	PA	12742
IT	90030	Blandino	Sicilia	Palermo	PA	12743
IT	90030	Santa Cristina Gela	Sicilia	Palermo	PA	12744
IT	90030	Contessa Entellina	Sicilia	Palermo	PA	12745
IT	90030	Cefala' Diana	Sicilia	Palermo	PA	12746
IT	90030	Castronuovo Di Sicilia	Sicilia	Palermo	PA	12747
IT	90031	Belmonte Mezzagno	Sicilia	Palermo	PA	12748
IT	90032	Bisacquino	Sicilia	Palermo	PA	12749
IT	90033	Chiusa Sclafani	Sicilia	Palermo	PA	12750
IT	90033	San Carlo	Sicilia	Palermo	PA	12751
IT	90034	Corleone	Sicilia	Palermo	PA	12752
IT	90034	Ficuzza	Sicilia	Palermo	PA	12753
IT	90035	Marineo	Sicilia	Palermo	PA	12754
IT	90036	Portella Di Mare	Sicilia	Palermo	PA	12755
IT	90036	Misilmeri	Sicilia	Palermo	PA	12756
IT	90037	Piana Degli Albanesi	Sicilia	Palermo	PA	12757
IT	90038	Filaga	Sicilia	Palermo	PA	12758
IT	90038	Prizzi	Sicilia	Palermo	PA	12759
IT	90039	Villabate	Sicilia	Palermo	PA	12760
IT	90040	San Cipirello	Sicilia	Palermo	PA	12761
IT	90040	Montelepre	Sicilia	Palermo	PA	12762
IT	90040	Grisi'	Sicilia	Palermo	PA	12763
IT	90040	Trappeto	Sicilia	Palermo	PA	12764
IT	90040	Isola Delle Femmine	Sicilia	Palermo	PA	12765
IT	90040	Torretta	Sicilia	Palermo	PA	12766
IT	90040	Giardinello	Sicilia	Palermo	PA	12767
IT	90040	Cortiglia	Sicilia	Palermo	PA	12768
IT	90040	Roccamena	Sicilia	Palermo	PA	12769
IT	90040	Capaci	Sicilia	Palermo	PA	12770
IT	90041	Balestrate	Sicilia	Palermo	PA	12771
IT	90041	Foce	Sicilia	Palermo	PA	12772
IT	90042	Borgetto	Sicilia	Palermo	PA	12773
IT	90043	Camporeale	Sicilia	Palermo	PA	12774
IT	90044	Villagrazia Di Carini	Sicilia	Palermo	PA	12775
IT	90044	Carini	Sicilia	Palermo	PA	12776
IT	90045	Cinisi	Sicilia	Palermo	PA	12777
IT	90045	Punta Raisi Aeroporto	Sicilia	Palermo	PA	12778
IT	90046	Malpasso	Sicilia	Palermo	PA	12779
IT	90046	San Martino Delle Scale	Sicilia	Palermo	PA	12780
IT	90046	Monreale	Sicilia	Palermo	PA	12781
IT	90046	Pioppo	Sicilia	Palermo	PA	12782
IT	90046	Villa Ciambra	Sicilia	Palermo	PA	12783
IT	90046	Poggio San Francesco	Sicilia	Palermo	PA	12784
IT	90047	Partinico	Sicilia	Palermo	PA	12785
IT	90048	San Giuseppe Jato	Sicilia	Palermo	PA	12786
IT	90049	Terrasini	Sicilia	Palermo	PA	12787
IT	90049	Citta' Del Mare	Sicilia	Palermo	PA	12788
IT	90100	Palermo	Sicilia	Palermo	PA	12789
IT	90121	Boccadifalco	Sicilia	Palermo	PA	12790
IT	90121	Palermo	Sicilia	Palermo	PA	12791
IT	90121	In Via Messina Marine	Sicilia	Palermo	PA	12792
IT	90121	In Via Ammiraglio Cristodulo	Sicilia	Palermo	PA	12793
IT	90121	Brancaccio Ciaculli	Sicilia	Palermo	PA	12794
IT	90121	Acqua Dei Corsari	Sicilia	Palermo	PA	12795
IT	90122	Palermo	Sicilia	Palermo	PA	12796
IT	90122	Roccella Guarnaschelli	Sicilia	Palermo	PA	12797
IT	90123	Palermo	Sicilia	Palermo	PA	12798
IT	90123	Settecannoli	Sicilia	Palermo	PA	12799
IT	90124	Palermo	Sicilia	Palermo	PA	12800
IT	90124	In Via Santa Maria Di Gesu'	Sicilia	Palermo	PA	12801
IT	90124	In Via Brancaccio	Sicilia	Palermo	PA	12802
IT	90124	Brancaccio Ciaculli	Sicilia	Palermo	PA	12803
IT	90124	In Via Chiavelli	Sicilia	Palermo	PA	12804
IT	90125	Palermo	Sicilia	Palermo	PA	12805
IT	90125	In Via Aloi	Sicilia	Palermo	PA	12806
IT	90126	Palermo	Sicilia	Palermo	PA	12807
IT	90126	Mezzomonreale Boccadifalco	Sicilia	Palermo	PA	12808
IT	90127	Palermo	Sicilia	Palermo	PA	12809
IT	90128	Palermo	Sicilia	Palermo	PA	12810
IT	90129	Palermo	Sicilia	Palermo	PA	12811
IT	90131	Rocca Monreale	Sicilia	Palermo	PA	12812
IT	90131	Palermo	Sicilia	Palermo	PA	12813
IT	90132	Palermo	Sicilia	Palermo	PA	12814
IT	90133	Tribunali Castellammare	Sicilia	Palermo	PA	12815
IT	90133	Palermo	Sicilia	Palermo	PA	12816
IT	90134	Zisa	Sicilia	Palermo	PA	12817
IT	90134	Palermo	Sicilia	Palermo	PA	12818
IT	90134	In Via Gioiamia	Sicilia	Palermo	PA	12819
IT	90135	Palermo	Sicilia	Palermo	PA	12820
IT	90135	Zisa	Sicilia	Palermo	PA	12821
IT	90136	Palermo	Sicilia	Palermo	PA	12822
IT	90137	Palermo	Sicilia	Palermo	PA	12823
IT	90138	Zisa	Sicilia	Palermo	PA	12824
IT	90138	Palermo	Sicilia	Palermo	PA	12825
IT	90139	Palermo	Sicilia	Palermo	PA	12826
IT	90141	Palermo	Sicilia	Palermo	PA	12827
IT	90142	Montepellegrino	Sicilia	Palermo	PA	12828
IT	90142	Palermo	Sicilia	Palermo	PA	12829
IT	90142	Arenella Vergine Maria	Sicilia	Palermo	PA	12830
IT	90143	Palermo	Sicilia	Palermo	PA	12831
IT	90144	Palermo	Sicilia	Palermo	PA	12832
IT	90145	Palermo	Sicilia	Palermo	PA	12833
IT	90146	Pallavicino	Sicilia	Palermo	PA	12834
IT	90146	Palermo	Sicilia	Palermo	PA	12835
IT	90146	Resuttana San Lorenzo	Sicilia	Palermo	PA	12836
IT	90146	In Via San Nicola	Sicilia	Palermo	PA	12837
IT	90146	San Lorenzo Colli	Sicilia	Palermo	PA	12838
IT	90146	Cruillas	Sicilia	Palermo	PA	12839
IT	90147	Palermo	Sicilia	Palermo	PA	12840
IT	90147	Tommaso Natale Sferracavallo	Sicilia	Palermo	PA	12841
IT	90148	Tommaso Natale	Sicilia	Palermo	PA	12842
IT	90148	Palermo	Sicilia	Palermo	PA	12843
IT	90148	Villagrazia	Sicilia	Palermo	PA	12844
IT	90148	Sferracavallo	Sicilia	Palermo	PA	12845
IT	90149	Palermo	Sicilia	Palermo	PA	12846
IT	90151	Mondello	Sicilia	Palermo	PA	12847
IT	90151	Partanna Mondello	Sicilia	Palermo	PA	12848
IT	90151	Palermo	Sicilia	Palermo	PA	12849
IT	97010	Giarratana	Sicilia	Ragusa	RG	12850
IT	97010	Monterosso Almo	Sicilia	Ragusa	RG	12851
IT	97010	Marina Di Ragusa	Sicilia	Ragusa	RG	12852
IT	97010	Roccazzo	Sicilia	Ragusa	RG	12853
IT	97010	Bellocozzo	Sicilia	Ragusa	RG	12854
IT	97010	Marina Di Modica	Sicilia	Ragusa	RG	12855
IT	97011	Acate	Sicilia	Ragusa	RG	12856
IT	97012	Chiaramonte Gulfi	Sicilia	Ragusa	RG	12857
IT	97013	Pedalino	Sicilia	Ragusa	RG	12858
IT	97013	Comiso	Sicilia	Ragusa	RG	12859
IT	97014	Ispica	Sicilia	Ragusa	RG	12860
IT	97015	Frigintini	Sicilia	Ragusa	RG	12861
IT	97015	Modica	Sicilia	Ragusa	RG	12862
IT	97015	Cava D'Ispica	Sicilia	Ragusa	RG	12863
IT	97015	Rocciola Sorda	Sicilia	Ragusa	RG	12864
IT	97015	Modica Alta	Sicilia	Ragusa	RG	12865
IT	97016	Pozzallo	Sicilia	Ragusa	RG	12866
IT	97017	Santa Croce Camerina	Sicilia	Ragusa	RG	12867
IT	97017	Donnafugata	Sicilia	Ragusa	RG	12868
IT	97018	Sampieri	Sicilia	Ragusa	RG	12869
IT	97018	Scicli	Sicilia	Ragusa	RG	12870
IT	97018	Cava D'Aliga	Sicilia	Ragusa	RG	12871
IT	97018	Jungi	Sicilia	Ragusa	RG	12872
IT	97018	Donnalucata	Sicilia	Ragusa	RG	12873
IT	97019	Vittoria	Sicilia	Ragusa	RG	12874
IT	97019	Scoglitti	Sicilia	Ragusa	RG	12875
IT	97100	Ragusa	Sicilia	Ragusa	RG	12876
IT	97100	Ragusa Ibla	Sicilia	Ragusa	RG	12877
IT	96010	Melilli	Sicilia	Siracusa	SR	12878
IT	96010	Sortino	Sicilia	Siracusa	SR	12879
IT	96010	Solarino	Sicilia	Siracusa	SR	12880
IT	96010	Cassaro	Sicilia	Siracusa	SR	12881
IT	96010	Priolo Gargallo	Sicilia	Siracusa	SR	12882
IT	96010	Villasmundo	Sicilia	Siracusa	SR	12883
IT	96010	Buscemi	Sicilia	Siracusa	SR	12884
IT	96010	Buccheri	Sicilia	Siracusa	SR	12885
IT	96010	Portopalo Di Capo Passero	Sicilia	Siracusa	SR	12886
IT	96010	Ferla	Sicilia	Siracusa	SR	12887
IT	96010	Palazzolo Acreide	Sicilia	Siracusa	SR	12888
IT	96010	Canicattini Bagni	Sicilia	Siracusa	SR	12889
IT	96010	Marina Di Melilli	Sicilia	Siracusa	SR	12890
IT	96010	San Foca'	Sicilia	Siracusa	SR	12891
IT	96010	Rizzolo	Sicilia	Siracusa	SR	12892
IT	96011	Augusta	Sicilia	Siracusa	SR	12893
IT	96011	Brucoli	Sicilia	Siracusa	SR	12894
IT	96012	Avola	Sicilia	Siracusa	SR	12895
IT	96013	Carlentini	Sicilia	Siracusa	SR	12896
IT	96013	Pedagaggi	Sicilia	Siracusa	SR	12897
IT	96013	Borgo Rizza	Sicilia	Siracusa	SR	12898
IT	96014	Floridia	Sicilia	Siracusa	SR	12899
IT	96015	Francofonte	Sicilia	Siracusa	SR	12900
IT	96016	Lentini	Sicilia	Siracusa	SR	12901
IT	96017	Testa Dell'Acqua	Sicilia	Siracusa	SR	12902
IT	96017	San Corrado Di Fuori	Sicilia	Siracusa	SR	12903
IT	96017	Santa Lucia	Sicilia	Siracusa	SR	12904
IT	96017	San Paolo	Sicilia	Siracusa	SR	12905
IT	96017	Noto	Sicilia	Siracusa	SR	12906
IT	96017	San Paolo Di Noto	Sicilia	Siracusa	SR	12907
IT	96017	Castelluccio	Sicilia	Siracusa	SR	12908
IT	96017	Rigolizia	Sicilia	Siracusa	SR	12909
IT	96017	Santa Lucia Di Noto	Sicilia	Siracusa	SR	12910
IT	96018	Pachino	Sicilia	Siracusa	SR	12911
IT	96018	Marzamemi	Sicilia	Siracusa	SR	12912
IT	96019	Rosolini	Sicilia	Siracusa	SR	12913
IT	96100	Belvedere	Sicilia	Siracusa	SR	12914
IT	96100	Siracusa	Sicilia	Siracusa	SR	12915
IT	96100	Cassibile	Sicilia	Siracusa	SR	12916
IT	96100	Belvedere Di Siracusa	Sicilia	Siracusa	SR	12917
IT	96100	Carrozziere	Sicilia	Siracusa	SR	12918
IT	91010	Vita	Sicilia	Trapani	TP	12919
IT	91010	San Vito Lo Capo	Sicilia	Trapani	TP	12920
IT	91010	Marettimo	Sicilia	Trapani	TP	12921
IT	91010	Macari	Sicilia	Trapani	TP	12922
IT	91010	Castelluzzo	Sicilia	Trapani	TP	12923
IT	91011	Alcamo	Sicilia	Trapani	TP	12924
IT	91012	Bruca	Sicilia	Trapani	TP	12925
IT	91012	Buseto Palizzolo	Sicilia	Trapani	TP	12926
IT	91012	Battaglia	Sicilia	Trapani	TP	12927
IT	91013	Calatafimi	Sicilia	Trapani	TP	12928
IT	91013	Sasi	Sicilia	Trapani	TP	12929
IT	91013	Calatafimi Segesta	Sicilia	Trapani	TP	12930
IT	91014	Castellammare Del Golfo	Sicilia	Trapani	TP	12931
IT	91014	Scopello	Sicilia	Trapani	TP	12932
IT	91014	Castello Inici	Sicilia	Trapani	TP	12933
IT	91014	Balata Di Baida	Sicilia	Trapani	TP	12934
IT	91015	Custonaci	Sicilia	Trapani	TP	12935
IT	91015	Purgatorio	Sicilia	Trapani	TP	12936
IT	91015	Sperone Di Custonaci	Sicilia	Trapani	TP	12937
IT	91016	Pizzolungo	Sicilia	Trapani	TP	12938
IT	91016	Casa Santa	Sicilia	Trapani	TP	12939
IT	91016	Napola	Sicilia	Trapani	TP	12940
IT	91016	Rigaletta	Sicilia	Trapani	TP	12941
IT	91016	Erice	Sicilia	Trapani	TP	12942
IT	91016	Ballata	Sicilia	Trapani	TP	12943
IT	91016	San Giuliano Trentapiedi	Sicilia	Trapani	TP	12944
IT	91017	Pantelleria	Sicilia	Trapani	TP	12945
IT	91017	Kamma	Sicilia	Trapani	TP	12946
IT	91017	Pantelleria Aeroporto	Sicilia	Trapani	TP	12947
IT	91017	Scauri Siculo	Sicilia	Trapani	TP	12948
IT	91017	Scauri	Sicilia	Trapani	TP	12949
IT	91018	Filci	Sicilia	Trapani	TP	12950
IT	91018	Ulmi	Sicilia	Trapani	TP	12951
IT	91018	Salemi	Sicilia	Trapani	TP	12952
IT	91018	Gorgazzo	Sicilia	Trapani	TP	12953
IT	91018	San Ciro	Sicilia	Trapani	TP	12954
IT	91019	Bonagia	Sicilia	Trapani	TP	12955
IT	91019	Sant'Andrea Bonagia	Sicilia	Trapani	TP	12956
IT	91019	Chiesanuova	Sicilia	Trapani	TP	12957
IT	91019	Crocci	Sicilia	Trapani	TP	12958
IT	91019	Tonnara Di Bonagia	Sicilia	Trapani	TP	12959
IT	91019	Valderice	Sicilia	Trapani	TP	12960
IT	91019	Crocevie	Sicilia	Trapani	TP	12961
IT	91019	Fico	Sicilia	Trapani	TP	12962
IT	91020	Costiera Di Mazara	Sicilia	Trapani	TP	12963
IT	91020	Poggioreale	Sicilia	Trapani	TP	12964
IT	91020	Petrosino	Sicilia	Trapani	TP	12965
IT	91020	Granitola	Sicilia	Trapani	TP	12966
IT	91020	Salaparuta	Sicilia	Trapani	TP	12967
IT	91021	Campobello Di Mazara	Sicilia	Trapani	TP	12968
IT	91021	Granitola Torretta	Sicilia	Trapani	TP	12969
IT	91021	Tre Fontane	Sicilia	Trapani	TP	12970
IT	91022	Castelvetrano	Sicilia	Trapani	TP	12971
IT	91022	Marinella	Sicilia	Trapani	TP	12972
IT	91022	Triscina	Sicilia	Trapani	TP	12973
IT	91022	Marinella Di Selinunte	Sicilia	Trapani	TP	12974
IT	91023	Favignana	Sicilia	Trapani	TP	12975
IT	91023	Levanzo	Sicilia	Trapani	TP	12976
IT	91024	Villaggio Madonna Delle Grazie	Sicilia	Trapani	TP	12977
IT	91024	Gibellina	Sicilia	Trapani	TP	12978
IT	91025	Strasatti Di Marsala	Sicilia	Trapani	TP	12979
IT	91025	Paolini	Sicilia	Trapani	TP	12980
IT	91025	Marsala	Sicilia	Trapani	TP	12981
IT	91025	Ciavolo	Sicilia	Trapani	TP	12982
IT	91025	Santo Padre Delle Perriere	Sicilia	Trapani	TP	12983
IT	91025	Ragattisi	Sicilia	Trapani	TP	12984
IT	91025	Terrenove Bambina	Sicilia	Trapani	TP	12985
IT	91025	Spagnola	Sicilia	Trapani	TP	12986
IT	91025	Matarocco	Sicilia	Trapani	TP	12987
IT	91025	Ciavolotto	Sicilia	Trapani	TP	12988
IT	91025	Tabaccaro	Sicilia	Trapani	TP	12989
IT	91025	Bufalata	Sicilia	Trapani	TP	12990
IT	91026	Mazara Del Vallo	Sicilia	Trapani	TP	12991
IT	91026	Borgata Costiera	Sicilia	Trapani	TP	12992
IT	91027	Dattilo	Sicilia	Trapani	TP	12993
IT	91027	Paceco	Sicilia	Trapani	TP	12994
IT	91027	Nubia	Sicilia	Trapani	TP	12995
IT	91028	Partanna	Sicilia	Trapani	TP	12996
IT	91029	Santa Ninfa	Sicilia	Trapani	TP	12997
IT	91100	Locogrande	Sicilia	Trapani	TP	12998
IT	91100	Guarrato	Sicilia	Trapani	TP	12999
IT	91100	Xitta	Sicilia	Trapani	TP	13000
IT	91100	Trapani	Sicilia	Trapani	TP	13001
IT	91100	Marausa	Sicilia	Trapani	TP	13002
IT	91100	Rilievo	Sicilia	Trapani	TP	13003
IT	91100	Fulgatore	Sicilia	Trapani	TP	13004
IT	91100	Salinagrande	Sicilia	Trapani	TP	13005
IT	91100	Ummari	Sicilia	Trapani	TP	13006
IT	91100	Borgo Annunziata	Sicilia	Trapani	TP	13007
IT	91100	Birgi Aerostazione	Sicilia	Trapani	TP	13008
IT	91100	Fontanelle Casasanta	Sicilia	Trapani	TP	13009
IT	91100	Marausa Loco Grande	Sicilia	Trapani	TP	13010
IT	91100	San Giuliano Trentapiedi	Sicilia	Trapani	TP	13011
IT	91100	Borgo Fazio	Sicilia	Trapani	TP	13012
IT	52010	Subbiano	Toscana	Arezzo	AR	13013
IT	52010	Ortignano Raggiolo	Toscana	Arezzo	AR	13014
IT	52010	Corsalone	Toscana	Arezzo	AR	13015
IT	52010	Faltona	Toscana	Arezzo	AR	13016
IT	52010	Talla	Toscana	Arezzo	AR	13017
IT	52010	Montemignaio	Toscana	Arezzo	AR	13018
IT	52010	Capolona	Toscana	Arezzo	AR	13019
IT	52010	Biforco	Toscana	Arezzo	AR	13020
IT	52010	Raggiolo	Toscana	Arezzo	AR	13021
IT	52010	Santa Mama	Toscana	Arezzo	AR	13022
IT	52010	Serravalle Di Bibbiena	Toscana	Arezzo	AR	13023
IT	52010	Chitignano	Toscana	Arezzo	AR	13024
IT	52010	La Verna	Toscana	Arezzo	AR	13025
IT	52010	Chiusi Della Verna	Toscana	Arezzo	AR	13026
IT	52010	Ortignano	Toscana	Arezzo	AR	13027
IT	52010	Moggiona Di Poppi	Toscana	Arezzo	AR	13028
IT	52011	Banzena	Toscana	Arezzo	AR	13029
IT	52011	Partina	Toscana	Arezzo	AR	13030
IT	52011	Bibbiena	Toscana	Arezzo	AR	13031
IT	52011	Serravalle	Toscana	Arezzo	AR	13032
IT	52011	Bibbiena Stazione	Toscana	Arezzo	AR	13033
IT	52011	Soci	Toscana	Arezzo	AR	13034
IT	52014	Ponte A Poppi	Toscana	Arezzo	AR	13035
IT	52014	Porrena	Toscana	Arezzo	AR	13036
IT	52014	Quota	Toscana	Arezzo	AR	13037
IT	52014	Poppi	Toscana	Arezzo	AR	13038
IT	52014	Moggiona	Toscana	Arezzo	AR	13039
IT	52014	Badia Prataglia	Toscana	Arezzo	AR	13040
IT	52014	Avena	Toscana	Arezzo	AR	13041
IT	52014	Camaldoli	Toscana	Arezzo	AR	13042
IT	52015	Pratovecchio	Toscana	Arezzo	AR	13043
IT	52015	Pratovecchio Stia	Toscana	Arezzo	AR	13044
IT	52016	Castel Focognano	Toscana	Arezzo	AR	13045
IT	52016	Salutio	Toscana	Arezzo	AR	13046
IT	52016	Rassina	Toscana	Arezzo	AR	13047
IT	52016	Pieve A Socana	Toscana	Arezzo	AR	13048
IT	52017	Papiano	Toscana	Arezzo	AR	13049
IT	52017	Stia	Toscana	Arezzo	AR	13050
IT	50039	Villore	Toscana	Firenze	FI	13051
IT	52018	Castel San Niccolo'	Toscana	Arezzo	AR	13052
IT	52018	Borgo Alla Collina	Toscana	Arezzo	AR	13053
IT	52018	Strada	Toscana	Arezzo	AR	13054
IT	52020	Laterina	Toscana	Arezzo	AR	13055
IT	52020	Cavi	Toscana	Arezzo	AR	13056
IT	52020	Pergine Valdarno	Toscana	Arezzo	AR	13057
IT	52020	Pieve A Presciano	Toscana	Arezzo	AR	13058
IT	52020	Laterina Stazione	Toscana	Arezzo	AR	13059
IT	52020	Castelfranco Di Sopra	Toscana	Arezzo	AR	13060
IT	52020	Ponticino	Toscana	Arezzo	AR	13061
IT	52020	Montalto	Toscana	Arezzo	AR	13062
IT	52020	Casalone	Toscana	Arezzo	AR	13063
IT	52021	Badia Agnano	Toscana	Arezzo	AR	13064
IT	52021	Bucine	Toscana	Arezzo	AR	13065
IT	52021	Ambra	Toscana	Arezzo	AR	13066
IT	52021	Pietraviva	Toscana	Arezzo	AR	13067
IT	52021	Capannole	Toscana	Arezzo	AR	13068
IT	52021	Torre	Toscana	Arezzo	AR	13069
IT	52022	Santa Barbara	Toscana	Arezzo	AR	13070
IT	52022	Vacchereccia	Toscana	Arezzo	AR	13071
IT	52022	Cavriglia	Toscana	Arezzo	AR	13072
IT	52022	Meleto	Toscana	Arezzo	AR	13073
IT	52022	Castelnuovo Dei Sabbioni	Toscana	Arezzo	AR	13074
IT	52022	Montegonzi	Toscana	Arezzo	AR	13075
IT	52022	Monastero	Toscana	Arezzo	AR	13076
IT	52022	Neri	Toscana	Arezzo	AR	13077
IT	52022	San Cipriano	Toscana	Arezzo	AR	13078
IT	52024	San Giustino Valdarno	Toscana	Arezzo	AR	13079
IT	52024	Loro Ciuffenna	Toscana	Arezzo	AR	13080
IT	52025	Montevarchi	Toscana	Arezzo	AR	13081
IT	52025	Mercatale Valdarno	Toscana	Arezzo	AR	13082
IT	52025	Moncioni	Toscana	Arezzo	AR	13083
IT	52025	Levane	Toscana	Arezzo	AR	13084
IT	52026	Faella	Toscana	Arezzo	AR	13085
IT	52026	Castelfranco Piandiscò	Toscana	Arezzo	AR	13086
IT	52026	Pian Di Sco	Toscana	Arezzo	AR	13087
IT	52026	Vaggio	Toscana	Arezzo	AR	13088
IT	52027	San Giovanni Valdarno	Toscana	Arezzo	AR	13089
IT	52028	Penna	Toscana	Arezzo	AR	13090
IT	52028	Madrigale	Toscana	Arezzo	AR	13091
IT	52028	Malva	Toscana	Arezzo	AR	13092
IT	52028	Terranuova Bracciolini	Toscana	Arezzo	AR	13093
IT	52028	Campogialli	Toscana	Arezzo	AR	13094
IT	52028	Ville	Toscana	Arezzo	AR	13095
IT	52029	Castiglion Fibocchi	Toscana	Arezzo	AR	13096
IT	52031	Anghiari	Toscana	Arezzo	AR	13097
IT	52031	San Leo Di Anghiari	Toscana	Arezzo	AR	13098
IT	52032	Badia Tedalda	Toscana	Arezzo	AR	13099
IT	52032	Ca' Raffaello	Toscana	Arezzo	AR	13100
IT	52032	Fresciano	Toscana	Arezzo	AR	13101
IT	52033	Caprese Michelangelo	Toscana	Arezzo	AR	13102
IT	52035	Monterchi	Toscana	Arezzo	AR	13103
IT	52035	Le Ville	Toscana	Arezzo	AR	13104
IT	52036	Pieve Santo Stefano	Toscana	Arezzo	AR	13105
IT	52036	Madonnuccia	Toscana	Arezzo	AR	13106
IT	52037	Santa Fiora	Toscana	Arezzo	AR	13107
IT	52037	Sansepolcro	Toscana	Arezzo	AR	13108
IT	52037	Gricignano	Toscana	Arezzo	AR	13109
IT	52038	Sestino	Toscana	Arezzo	AR	13110
IT	52038	Colcellalto	Toscana	Arezzo	AR	13111
IT	52038	Monterone	Toscana	Arezzo	AR	13112
IT	52041	Badia Al Pino	Toscana	Arezzo	AR	13113
IT	52041	Pieve Al Toppo	Toscana	Arezzo	AR	13114
IT	52041	Civitella In Val Di Chiana	Toscana	Arezzo	AR	13115
IT	52041	Ciggiano	Toscana	Arezzo	AR	13116
IT	52041	Viciomaggio	Toscana	Arezzo	AR	13117
IT	52041	Tegoleto	Toscana	Arezzo	AR	13118
IT	52043	Manciano	Toscana	Arezzo	AR	13119
IT	52043	Montecchio	Toscana	Arezzo	AR	13120
IT	52043	Castiglion Fiorentino	Toscana	Arezzo	AR	13121
IT	52044	Fratta	Toscana	Arezzo	AR	13122
IT	52044	Terontola	Toscana	Arezzo	AR	13123
IT	52044	Santa Caterina Di Cortona	Toscana	Arezzo	AR	13124
IT	52044	Camucia	Toscana	Arezzo	AR	13125
IT	52044	Sant'Andrea Di Sorbello	Toscana	Arezzo	AR	13126
IT	52044	Mercatale	Toscana	Arezzo	AR	13127
IT	52044	Montanare	Toscana	Arezzo	AR	13128
IT	52044	Mercatale Di Cortona	Toscana	Arezzo	AR	13129
IT	52044	Cortona	Toscana	Arezzo	AR	13130
IT	52044	Terontola Stazione	Toscana	Arezzo	AR	13131
IT	52044	Montanare Di Cortona	Toscana	Arezzo	AR	13132
IT	52044	Santa Caterina	Toscana	Arezzo	AR	13133
IT	52044	Centoia	Toscana	Arezzo	AR	13134
IT	52044	Capezzine	Toscana	Arezzo	AR	13135
IT	52045	Foiano Della Chiana	Toscana	Arezzo	AR	13136
IT	52045	Pozzo Della Chiana	Toscana	Arezzo	AR	13137
IT	52046	Lucignano	Toscana	Arezzo	AR	13138
IT	52047	Marciano	Toscana	Arezzo	AR	13139
IT	52047	Cesa	Toscana	Arezzo	AR	13140
IT	52047	Marciano Della Chiana	Toscana	Arezzo	AR	13141
IT	52048	Montagnano	Toscana	Arezzo	AR	13142
IT	52048	Palazzuolo	Toscana	Arezzo	AR	13143
IT	52048	Alberoro	Toscana	Arezzo	AR	13144
IT	52048	Monte San Savino	Toscana	Arezzo	AR	13145
IT	52048	Montagnano Alberoro	Toscana	Arezzo	AR	13146
IT	52100	Battifolle	Toscana	Arezzo	AR	13147
IT	52100	Patrignone	Toscana	Arezzo	AR	13148
IT	52100	Ceciliano	Toscana	Arezzo	AR	13149
IT	52100	Arezzo	Toscana	Arezzo	AR	13150
IT	52100	Ponte Alla Chiassa	Toscana	Arezzo	AR	13151
IT	52100	Puglia	Toscana	Arezzo	AR	13152
IT	52100	Quarata	Toscana	Arezzo	AR	13153
IT	52100	Indicatore	Toscana	Arezzo	AR	13154
IT	52100	Antria	Toscana	Arezzo	AR	13155
IT	52100	Palazzo Del Pero	Toscana	Arezzo	AR	13156
IT	52100	Tregozzano	Toscana	Arezzo	AR	13157
IT	52100	Molin Nuovo	Toscana	Arezzo	AR	13158
IT	52100	Ruscello	Toscana	Arezzo	AR	13159
IT	52100	Staggiano	Toscana	Arezzo	AR	13160
IT	52100	Poggiola	Toscana	Arezzo	AR	13161
IT	52100	Frassineto	Toscana	Arezzo	AR	13162
IT	52100	Rigutino	Toscana	Arezzo	AR	13163
IT	52100	Pratantico	Toscana	Arezzo	AR	13164
IT	52100	Olmo	Toscana	Arezzo	AR	13165
IT	52100	Giovi D'Arezzo	Toscana	Arezzo	AR	13166
IT	52100	San Giuliano D'Arezzo	Toscana	Arezzo	AR	13167
IT	52100	Chiassa	Toscana	Arezzo	AR	13168
IT	52100	Pieve Al Bagnoro	Toscana	Arezzo	AR	13169
IT	52100	Chiassa Superiore	Toscana	Arezzo	AR	13170
IT	50010	Trespiano	Toscana	Firenze	FI	13171
IT	50012	Grassina Ponte A Ema	Toscana	Firenze	FI	13172
IT	50012	Osteria Nuova	Toscana	Firenze	FI	13173
IT	50012	Grassina	Toscana	Firenze	FI	13174
IT	50012	Antella	Toscana	Firenze	FI	13175
IT	50012	Bagno A Ripoli	Toscana	Firenze	FI	13176
IT	50012	Candeli	Toscana	Firenze	FI	13177
IT	50012	Vallina	Toscana	Firenze	FI	13178
IT	50012	Rimaggio	Toscana	Firenze	FI	13179
IT	50013	Campi Bisenzio	Toscana	Firenze	FI	13180
IT	50013	Capalle	Toscana	Firenze	FI	13181
IT	50013	San Donnino	Toscana	Firenze	FI	13182
IT	50013	Sant'Angelo	Toscana	Firenze	FI	13183
IT	50013	Il Rosi	Toscana	Firenze	FI	13184
IT	50013	San Piero A Ponti	Toscana	Firenze	FI	13185
IT	50013	Sant'Angelo A Lecore	Toscana	Firenze	FI	13186
IT	50013	San Donnino Di Campi	Toscana	Firenze	FI	13187
IT	50014	Pian Di Mugnone	Toscana	Firenze	FI	13188
IT	50014	Fiesole	Toscana	Firenze	FI	13189
IT	50014	Caldine	Toscana	Firenze	FI	13190
IT	50014	San Domenico Di Fiesole	Toscana	Firenze	FI	13191
IT	50018	Casellina	Toscana	Firenze	FI	13192
IT	50018	San Martino Alla Palma	Toscana	Firenze	FI	13193
IT	50018	San Vincenzo A Torri	Toscana	Firenze	FI	13194
IT	50018	Scandicci	Toscana	Firenze	FI	13195
IT	50018	Le Bagnese San Giusto	Toscana	Firenze	FI	13196
IT	50018	Badia A Settimo	Toscana	Firenze	FI	13197
IT	50019	Sesto Fiorentino	Toscana	Firenze	FI	13198
IT	50019	Osmannoro	Toscana	Firenze	FI	13199
IT	50019	Colonnata	Toscana	Firenze	FI	13200
IT	50019	Ponte A Giogoli	Toscana	Firenze	FI	13201
IT	50019	Querceto	Toscana	Firenze	FI	13202
IT	50019	Quinto	Toscana	Firenze	FI	13203
IT	50020	Mercatale Val Di Pesa	Toscana	Firenze	FI	13204
IT	50021	Marcialla	Toscana	Firenze	FI	13205
IT	50021	Barberino Val D'Elsa	Toscana	Firenze	FI	13206
IT	50021	Vico D'Elsa	Toscana	Firenze	FI	13207
IT	50022	Greve In Chianti	Toscana	Firenze	FI	13208
IT	50022	Lamole	Toscana	Firenze	FI	13209
IT	50022	San Polo In Chianti	Toscana	Firenze	FI	13210
IT	50022	Panzano	Toscana	Firenze	FI	13211
IT	50022	Lucolena	Toscana	Firenze	FI	13212
IT	50023	Impruneta	Toscana	Firenze	FI	13213
IT	50023	Monte Oriolo	Toscana	Firenze	FI	13214
IT	50023	Bottai	Toscana	Firenze	FI	13215
IT	50023	Tavarnuzze	Toscana	Firenze	FI	13216
IT	50023	Pozzolatico	Toscana	Firenze	FI	13217
IT	50025	Lucardo	Toscana	Firenze	FI	13218
IT	50025	San Quirico In Collina	Toscana	Firenze	FI	13219
IT	50025	Montespertoli	Toscana	Firenze	FI	13220
IT	50025	Baccaiano	Toscana	Firenze	FI	13221
IT	50025	Martignana	Toscana	Firenze	FI	13222
IT	50025	Montagnana Val Di Pesa	Toscana	Firenze	FI	13223
IT	50026	Romola	Toscana	Firenze	FI	13224
IT	50026	Spedaletto	Toscana	Firenze	FI	13225
IT	50026	Montefiridolfi	Toscana	Firenze	FI	13226
IT	50026	Mercatale	Toscana	Firenze	FI	13227
IT	50026	Cerbaia	Toscana	Firenze	FI	13228
IT	50026	San Casciano In Val Di Pesa	Toscana	Firenze	FI	13229
IT	50026	San Pancrazio	Toscana	Firenze	FI	13230
IT	50027	Passo Dei Pecorai	Toscana	Firenze	FI	13231
IT	50027	Strada In Chianti	Toscana	Firenze	FI	13232
IT	50027	Chiocchio	Toscana	Firenze	FI	13233
IT	50028	San Donato In Poggio	Toscana	Firenze	FI	13234
IT	50028	Sambuca	Toscana	Firenze	FI	13235
IT	50028	Tavarnelle Val Di Pesa	Toscana	Firenze	FI	13236
IT	50028	Sambuca Val Di Pesa	Toscana	Firenze	FI	13237
IT	50031	Galliano	Toscana	Firenze	FI	13238
IT	50031	Montecarelli	Toscana	Firenze	FI	13239
IT	50031	Cavallina	Toscana	Firenze	FI	13240
IT	50031	Gagliano Di Mugello	Toscana	Firenze	FI	13241
IT	50031	Barberino Di Mugello	Toscana	Firenze	FI	13242
IT	50031	Cafaggiolo	Toscana	Firenze	FI	13243
IT	50032	Panicaglia	Toscana	Firenze	FI	13244
IT	50032	Luco Mugello	Toscana	Firenze	FI	13245
IT	50032	Polcanto	Toscana	Firenze	FI	13246
IT	50032	Ronta	Toscana	Firenze	FI	13247
IT	50032	Borgo San Lorenzo	Toscana	Firenze	FI	13248
IT	50033	Filigare	Toscana	Firenze	FI	13249
IT	50033	Coniale	Toscana	Firenze	FI	13250
IT	50033	Rifredo	Toscana	Firenze	FI	13251
IT	50033	Firenzuola	Toscana	Firenze	FI	13252
IT	50033	Covigliaio	Toscana	Firenze	FI	13253
IT	50033	Pietramala	Toscana	Firenze	FI	13254
IT	50033	Bruscoli	Toscana	Firenze	FI	13255
IT	50033	Traversa	Toscana	Firenze	FI	13256
IT	50033	Cornacchiaia	Toscana	Firenze	FI	13257
IT	50033	Piancaldoli	Toscana	Firenze	FI	13258
IT	50034	Casaglia	Toscana	Firenze	FI	13259
IT	50034	Marradi	Toscana	Firenze	FI	13260
IT	50034	Lutirano	Toscana	Firenze	FI	13261
IT	50034	Crespino Del Lamone	Toscana	Firenze	FI	13262
IT	50035	Palazzuolo Sul Senio	Toscana	Firenze	FI	13263
IT	50035	Misileo	Toscana	Firenze	FI	13264
IT	50036	Vaglia	Toscana	Firenze	FI	13265
IT	50036	Fontebuona	Toscana	Firenze	FI	13266
IT	50036	Bivigliano	Toscana	Firenze	FI	13267
IT	50036	Pratolino	Toscana	Firenze	FI	13268
IT	50037	San Piero A Sieve	Toscana	Firenze	FI	13269
IT	50038	Scarperia E San Piero	Toscana	Firenze	FI	13270
IT	50038	Scarperia	Toscana	Firenze	FI	13271
IT	50038	Sant'Agata Mugello	Toscana	Firenze	FI	13272
IT	50038	Sant'Agata	Toscana	Firenze	FI	13273
IT	50039	Cistio	Toscana	Firenze	FI	13274
IT	50039	Vicchio	Toscana	Firenze	FI	13275
IT	50039	Rupecanina	Toscana	Firenze	FI	13276
IT	50039	Gattaia	Toscana	Firenze	FI	13277
IT	50041	Calenzano	Toscana	Firenze	FI	13278
IT	50041	Croci Di Calenzano	Toscana	Firenze	FI	13279
IT	50041	Le Croci	Toscana	Firenze	FI	13280
IT	50041	Carraia	Toscana	Firenze	FI	13281
IT	50041	Settimello	Toscana	Firenze	FI	13282
IT	50050	San Zio	Toscana	Firenze	FI	13283
IT	50050	Cerreto Guidi	Toscana	Firenze	FI	13284
IT	50050	Gambassi Terme	Toscana	Firenze	FI	13285
IT	50050	Montaione	Toscana	Firenze	FI	13286
IT	50050	Capraia E Limite	Toscana	Firenze	FI	13287
IT	50050	Badia A Cerreto	Toscana	Firenze	FI	13288
IT	50050	Capraia	Toscana	Firenze	FI	13289
IT	50050	Gavena	Toscana	Firenze	FI	13290
IT	50050	Varna	Toscana	Firenze	FI	13291
IT	50050	Lazzeretto	Toscana	Firenze	FI	13292
IT	50050	Bassa	Toscana	Firenze	FI	13293
IT	50050	Il Castagno	Toscana	Firenze	FI	13294
IT	50050	Stabbia	Toscana	Firenze	FI	13295
IT	50050	Limite Sull'Arno	Toscana	Firenze	FI	13296
IT	50050	Pieve A Ripoli	Toscana	Firenze	FI	13297
IT	50050	Il Castagno Val D'Elsa	Toscana	Firenze	FI	13298
IT	50050	Ponte Di Masino	Toscana	Firenze	FI	13299
IT	50051	Cambiano	Toscana	Firenze	FI	13300
IT	50051	Granaiolo	Toscana	Firenze	FI	13301
IT	50051	Castelnuovo D'Elsa	Toscana	Firenze	FI	13302
IT	50051	Castelfiorentino	Toscana	Firenze	FI	13303
IT	50051	Petrazzi	Toscana	Firenze	FI	13304
IT	50051	Dogana	Toscana	Firenze	FI	13305
IT	50052	Certaldo	Toscana	Firenze	FI	13306
IT	50052	Fiano	Toscana	Firenze	FI	13307
IT	50053	Empoli	Toscana	Firenze	FI	13308
IT	50053	Brusciana	Toscana	Firenze	FI	13309
IT	50053	Marcignana	Toscana	Firenze	FI	13310
IT	50053	Sant'Andrea	Toscana	Firenze	FI	13311
IT	50053	Ponte A Elsa	Toscana	Firenze	FI	13312
IT	50053	Monterappoli	Toscana	Firenze	FI	13313
IT	50053	Fontanella	Toscana	Firenze	FI	13314
IT	50053	Case Nuove	Toscana	Firenze	FI	13315
IT	50053	Osteria Bianca	Toscana	Firenze	FI	13316
IT	50054	Fucecchio	Toscana	Firenze	FI	13317
IT	50054	Massarella	Toscana	Firenze	FI	13318
IT	50054	Ponte A Cappiano	Toscana	Firenze	FI	13319
IT	50054	San Pierino	Toscana	Firenze	FI	13320
IT	50054	Torre	Toscana	Firenze	FI	13321
IT	50054	La Torre	Toscana	Firenze	FI	13322
IT	50054	Galleno	Toscana	Firenze	FI	13323
IT	50054	Querce	Toscana	Firenze	FI	13324
IT	50054	Le Botteghe	Toscana	Firenze	FI	13325
IT	50055	Ginestra Fiorentina	Toscana	Firenze	FI	13326
IT	50055	Malmantile	Toscana	Firenze	FI	13327
IT	50055	Lastra A Signa	Toscana	Firenze	FI	13328
IT	50055	Ponte A Signa	Toscana	Firenze	FI	13329
IT	50055	Brucianesi	Toscana	Firenze	FI	13330
IT	50055	Porto Di Mezzo	Toscana	Firenze	FI	13331
IT	50056	Montelupo Fiorentino	Toscana	Firenze	FI	13332
IT	50056	Samminiatello	Toscana	Firenze	FI	13333
IT	50056	Ambrogiana	Toscana	Firenze	FI	13334
IT	50056	Sammontana	Toscana	Firenze	FI	13335
IT	50056	Fibbiana	Toscana	Firenze	FI	13336
IT	50058	Signa	Toscana	Firenze	FI	13337
IT	50058	San Mauro A Signa	Toscana	Firenze	FI	13338
IT	50058	San Mauro	Toscana	Firenze	FI	13339
IT	50059	Vitolini	Toscana	Firenze	FI	13340
IT	50059	Vinci	Toscana	Firenze	FI	13341
IT	50059	Sovigliana	Toscana	Firenze	FI	13342
IT	50059	San Pantaleo	Toscana	Firenze	FI	13343
IT	50059	Spicchio	Toscana	Firenze	FI	13344
IT	50059	Orbignano	Toscana	Firenze	FI	13345
IT	50059	Sant'Amato	Toscana	Firenze	FI	13346
IT	50060	Pelago	Toscana	Firenze	FI	13347
IT	50060	San Godenzo	Toscana	Firenze	FI	13348
IT	50060	Londa	Toscana	Firenze	FI	13349
IT	50060	Diacceto	Toscana	Firenze	FI	13350
IT	50060	Consuma	Toscana	Firenze	FI	13351
IT	50060	Borselli	Toscana	Firenze	FI	13352
IT	50061	Compiobbi	Toscana	Firenze	FI	13353
IT	50062	Dicomano	Toscana	Firenze	FI	13354
IT	50062	Sandetole	Toscana	Firenze	FI	13355
IT	50063	Figline Valdarno	Toscana	Firenze	FI	13356
IT	50063	Figline E Incisa Valdarno	Toscana	Firenze	FI	13357
IT	50064	Incisa In Val D'Arno	Toscana	Firenze	FI	13358
IT	50064	Loppiano	Toscana	Firenze	FI	13359
IT	50065	Molino Del Piano	Toscana	Firenze	FI	13360
IT	50065	Sieci	Toscana	Firenze	FI	13361
IT	50065	Pontassieve	Toscana	Firenze	FI	13362
IT	50065	Santa Brigida	Toscana	Firenze	FI	13363
IT	50065	Montebonello	Toscana	Firenze	FI	13364
IT	50066	Vallombrosa	Toscana	Firenze	FI	13365
IT	50066	Sant'Ellero	Toscana	Firenze	FI	13366
IT	50066	Reggello	Toscana	Firenze	FI	13367
IT	50066	Saltino	Toscana	Firenze	FI	13368
IT	50066	Leccio	Toscana	Firenze	FI	13369
IT	50066	Borgo A Cascia	Toscana	Firenze	FI	13370
IT	50066	San Donato Fronzano	Toscana	Firenze	FI	13371
IT	50066	Cascia	Toscana	Firenze	FI	13372
IT	50066	Pietrapiana	Toscana	Firenze	FI	13373
IT	50066	Tosi	Toscana	Firenze	FI	13374
IT	50066	Donnini	Toscana	Firenze	FI	13375
IT	50066	Matassino	Toscana	Firenze	FI	13376
IT	50066	Cancelli	Toscana	Firenze	FI	13377
IT	50066	Vaggio	Toscana	Firenze	FI	13378
IT	50067	Troghi	Toscana	Firenze	FI	13379
IT	50067	Rignano Sull'Arno	Toscana	Firenze	FI	13380
IT	50067	San Donato In Collina	Toscana	Firenze	FI	13381
IT	50067	Rosano	Toscana	Firenze	FI	13382
IT	50068	Rufina	Toscana	Firenze	FI	13383
IT	50068	Pomino	Toscana	Firenze	FI	13384
IT	50068	Contea	Toscana	Firenze	FI	13385
IT	50100	Firenze	Toscana	Firenze	FI	13386
IT	50121	Firenze	Toscana	Firenze	FI	13387
IT	50122	Firenze	Toscana	Firenze	FI	13388
IT	50123	Firenze	Toscana	Firenze	FI	13389
IT	50124	Galluzzo	Toscana	Firenze	FI	13390
IT	50124	Firenze	Toscana	Firenze	FI	13391
IT	50125	Arcetri	Toscana	Firenze	FI	13392
IT	50125	Firenze	Toscana	Firenze	FI	13393
IT	50125	Poggio Imperiale	Toscana	Firenze	FI	13394
IT	50125	San Felice A Ema	Toscana	Firenze	FI	13395
IT	50126	Ponte A Ema	Toscana	Firenze	FI	13396
IT	50126	Firenze	Toscana	Firenze	FI	13397
IT	50126	Sorgane	Toscana	Firenze	FI	13398
IT	50126	Badia A Ripoli	Toscana	Firenze	FI	13399
IT	50126	Bandino	Toscana	Firenze	FI	13400
IT	50126	Pieve A Ripoli	Toscana	Firenze	FI	13401
IT	50127	Firenze	Toscana	Firenze	FI	13402
IT	50127	Novoli	Toscana	Firenze	FI	13403
IT	50129	Firenze	Toscana	Firenze	FI	13404
IT	50131	Firenze	Toscana	Firenze	FI	13405
IT	50132	Firenze	Toscana	Firenze	FI	13406
IT	50133	Firenze	Toscana	Firenze	FI	13407
IT	50134	Careggi	Toscana	Firenze	FI	13408
IT	50134	Firenze	Toscana	Firenze	FI	13409
IT	50135	Coverciano	Toscana	Firenze	FI	13410
IT	50135	Montalbano	Toscana	Firenze	FI	13411
IT	50135	Firenze	Toscana	Firenze	FI	13412
IT	50135	Settignano	Toscana	Firenze	FI	13413
IT	50136	Firenze	Toscana	Firenze	FI	13414
IT	50136	Rovezzano	Toscana	Firenze	FI	13415
IT	50136	Varlungo	Toscana	Firenze	FI	13416
IT	50137	Firenze	Toscana	Firenze	FI	13417
IT	50139	Firenze	Toscana	Firenze	FI	13418
IT	50141	Castello	Toscana	Firenze	FI	13419
IT	50141	Firenze	Toscana	Firenze	FI	13420
IT	50141	Rifredi	Toscana	Firenze	FI	13421
IT	50142	Mantignano	Toscana	Firenze	FI	13422
IT	50142	Firenze	Toscana	Firenze	FI	13423
IT	50142	Isolotto	Toscana	Firenze	FI	13424
IT	50143	Firenze	Toscana	Firenze	FI	13425
IT	50144	Firenze	Toscana	Firenze	FI	13426
IT	50145	Brozzi	Toscana	Firenze	FI	13427
IT	50145	Firenze	Toscana	Firenze	FI	13428
IT	50145	Peretola	Toscana	Firenze	FI	13429
IT	58010	Castell'Ottieri	Toscana	Grosseto	GR	13430
IT	58010	Montorio	Toscana	Grosseto	GR	13431
IT	58010	Albinia	Toscana	Grosseto	GR	13432
IT	58010	San Valentino	Toscana	Grosseto	GR	13433
IT	58010	San Quirico	Toscana	Grosseto	GR	13434
IT	58010	Montebuono	Toscana	Grosseto	GR	13435
IT	58010	Sorano	Toscana	Grosseto	GR	13436
IT	58010	Sovana	Toscana	Grosseto	GR	13437
IT	58010	Elmo	Toscana	Grosseto	GR	13438
IT	58010	Pratolungo	Toscana	Grosseto	GR	13439
IT	58010	Montevitozzo	Toscana	Grosseto	GR	13440
IT	58010	San Giovanni Delle Contee	Toscana	Grosseto	GR	13441
IT	58011	Borgo Carige	Toscana	Grosseto	GR	13442
IT	58011	Capalbio	Toscana	Grosseto	GR	13443
IT	58011	Chiarone	Toscana	Grosseto	GR	13444
IT	58011	Capalbio Stazione	Toscana	Grosseto	GR	13445
IT	58012	Giglio Porto	Toscana	Grosseto	GR	13446
IT	58012	Isola Del Giglio	Toscana	Grosseto	GR	13447
IT	58012	Giglio Campese	Toscana	Grosseto	GR	13448
IT	58012	Giglio Castello	Toscana	Grosseto	GR	13449
IT	58012	Campese	Toscana	Grosseto	GR	13450
IT	58014	San Martino Sul Fiora	Toscana	Grosseto	GR	13451
IT	58014	Marsiliana	Toscana	Grosseto	GR	13452
IT	58014	Poggio Murella	Toscana	Grosseto	GR	13453
IT	58014	Manciano	Toscana	Grosseto	GR	13454
IT	58014	Montemerano	Toscana	Grosseto	GR	13455
IT	58014	Poggio Capanne	Toscana	Grosseto	GR	13456
IT	58014	Saturnia	Toscana	Grosseto	GR	13457
IT	58014	Poderi Di Montemerano	Toscana	Grosseto	GR	13458
IT	58015	Talamone	Toscana	Grosseto	GR	13459
IT	58015	Orbetello Scalo	Toscana	Grosseto	GR	13460
IT	58015	Orbetello	Toscana	Grosseto	GR	13461
IT	58015	Fonteblanda	Toscana	Grosseto	GR	13462
IT	58015	Polverosa	Toscana	Grosseto	GR	13463
IT	58015	Santa Liberata	Toscana	Grosseto	GR	13464
IT	58015	Orbetello Stazione	Toscana	Grosseto	GR	13465
IT	58017	Casone	Toscana	Grosseto	GR	13466
IT	58017	Pitigliano	Toscana	Grosseto	GR	13467
IT	58017	Il Casone	Toscana	Grosseto	GR	13468
IT	58018	Porto Ercole	Toscana	Grosseto	GR	13469
IT	58019	Giannutri	Toscana	Grosseto	GR	13470
IT	58019	Porto Santo Stefano	Toscana	Grosseto	GR	13471
IT	58019	Monte Argentario	Toscana	Grosseto	GR	13472
IT	58020	Scarlino Scalo	Toscana	Grosseto	GR	13473
IT	58020	Puntone	Toscana	Grosseto	GR	13474
IT	58020	Scarlino	Toscana	Grosseto	GR	13475
IT	58020	Scarlino Stazione	Toscana	Grosseto	GR	13476
IT	58022	Prato Ranieri	Toscana	Grosseto	GR	13477
IT	58022	Follonica	Toscana	Grosseto	GR	13478
IT	58023	Giuncarico	Toscana	Grosseto	GR	13479
IT	58023	Bivio Di Ravi	Toscana	Grosseto	GR	13480
IT	58023	Miniera	Toscana	Grosseto	GR	13481
IT	58023	Filare	Toscana	Grosseto	GR	13482
IT	58023	Castel Di Pietra	Toscana	Grosseto	GR	13483
IT	58023	Boschetto	Toscana	Grosseto	GR	13484
IT	58023	Gavorrano	Toscana	Grosseto	GR	13485
IT	58023	Caldana	Toscana	Grosseto	GR	13486
IT	58023	Ravi	Toscana	Grosseto	GR	13487
IT	58023	Grilli	Toscana	Grosseto	GR	13488
IT	58023	Bagno Di Gavorrano	Toscana	Grosseto	GR	13489
IT	58023	Potassa	Toscana	Grosseto	GR	13490
IT	58024	Capanne	Toscana	Grosseto	GR	13491
IT	58024	Tatti	Toscana	Grosseto	GR	13492
IT	58024	Niccioleta	Toscana	Grosseto	GR	13493
IT	58024	Montebamboli	Toscana	Grosseto	GR	13494
IT	58024	Capanne Vecchie	Toscana	Grosseto	GR	13495
IT	58024	Massa Marittima	Toscana	Grosseto	GR	13496
IT	58024	Ghirlanda	Toscana	Grosseto	GR	13497
IT	58024	Prata	Toscana	Grosseto	GR	13498
IT	58024	Valpiana	Toscana	Grosseto	GR	13499
IT	58025	Monterotondo Marittimo	Toscana	Grosseto	GR	13500
IT	58025	Frassine	Toscana	Grosseto	GR	13501
IT	58025	Lago Boracifero	Toscana	Grosseto	GR	13502
IT	58026	Montieri	Toscana	Grosseto	GR	13503
IT	58026	Boccheggiano	Toscana	Grosseto	GR	13504
IT	58026	Gerfalco	Toscana	Grosseto	GR	13505
IT	58026	Travale	Toscana	Grosseto	GR	13506
IT	58027	Montemassi	Toscana	Grosseto	GR	13507
IT	58027	Ribolla	Toscana	Grosseto	GR	13508
IT	58031	Zancona	Toscana	Grosseto	GR	13509
IT	58031	Bagnoli	Toscana	Grosseto	GR	13510
IT	58031	Montelaterone	Toscana	Grosseto	GR	13511
IT	58031	Arcidosso	Toscana	Grosseto	GR	13512
IT	58031	Stribugliano	Toscana	Grosseto	GR	13513
IT	58031	Salaiola	Toscana	Grosseto	GR	13514
IT	58033	Montegiovi	Toscana	Grosseto	GR	13515
IT	58033	Castel Del Piano	Toscana	Grosseto	GR	13516
IT	58033	Montenero	Toscana	Grosseto	GR	13517
IT	58034	Selvena	Toscana	Grosseto	GR	13518
IT	58034	Castell'Azzara	Toscana	Grosseto	GR	13519
IT	58036	Sticciano	Toscana	Grosseto	GR	13520
IT	58036	Sticciano Scalo	Toscana	Grosseto	GR	13521
IT	58036	Torniella	Toscana	Grosseto	GR	13522
IT	58036	Sassofortino	Toscana	Grosseto	GR	13523
IT	58036	Roccastrada	Toscana	Grosseto	GR	13524
IT	58036	Roccatederighi	Toscana	Grosseto	GR	13525
IT	58036	Sticciano Stazione	Toscana	Grosseto	GR	13526
IT	58037	Bagnolo	Toscana	Grosseto	GR	13527
IT	58037	Santa Fiora	Toscana	Grosseto	GR	13528
IT	58037	Bagnore	Toscana	Grosseto	GR	13529
IT	58037	Selva	Toscana	Grosseto	GR	13530
IT	58037	Marroneto	Toscana	Grosseto	GR	13531
IT	58038	Seggiano	Toscana	Grosseto	GR	13532
IT	58042	Campagnatico	Toscana	Grosseto	GR	13533
IT	58042	Arcille Di Campagnatico	Toscana	Grosseto	GR	13534
IT	58042	Montorsaio	Toscana	Grosseto	GR	13535
IT	58042	Arcille	Toscana	Grosseto	GR	13536
IT	58043	Castiglione Della Pescaia	Toscana	Grosseto	GR	13537
IT	58043	Tirli	Toscana	Grosseto	GR	13538
IT	58043	Buriano	Toscana	Grosseto	GR	13539
IT	58043	Vetulonia	Toscana	Grosseto	GR	13540
IT	58043	Punta Ala	Toscana	Grosseto	GR	13541
IT	58043	Riva Del Sole	Toscana	Grosseto	GR	13542
IT	58044	Cinigiano	Toscana	Grosseto	GR	13543
IT	58044	Sasso D'Ombrone	Toscana	Grosseto	GR	13544
IT	58044	Castiglioncello Bandini	Toscana	Grosseto	GR	13545
IT	58044	Monticello Amiata	Toscana	Grosseto	GR	13546
IT	58044	Monticello Dell'Amiata	Toscana	Grosseto	GR	13547
IT	58045	Casale Di Pari	Toscana	Grosseto	GR	13548
IT	58045	Pari	Toscana	Grosseto	GR	13549
IT	58045	Civitella Marittima	Toscana	Grosseto	GR	13550
IT	58045	Monte Antico	Toscana	Grosseto	GR	13551
IT	58045	Paganico	Toscana	Grosseto	GR	13552
IT	58045	Stazione Di Monte Antico	Toscana	Grosseto	GR	13553
IT	58045	Civitella Paganico	Toscana	Grosseto	GR	13554
IT	58045	Monte Antico Scalo	Toscana	Grosseto	GR	13555
IT	58051	Magliano In Toscana	Toscana	Grosseto	GR	13556
IT	58051	Pereta	Toscana	Grosseto	GR	13557
IT	58051	Montiano	Toscana	Grosseto	GR	13558
IT	58053	Santa Caterina	Toscana	Grosseto	GR	13559
IT	58053	Roccalbegna	Toscana	Grosseto	GR	13560
IT	58053	Triana	Toscana	Grosseto	GR	13561
IT	58053	Vallerona	Toscana	Grosseto	GR	13562
IT	58053	Cana	Toscana	Grosseto	GR	13563
IT	58054	Baccinello	Toscana	Grosseto	GR	13564
IT	58054	Murci	Toscana	Grosseto	GR	13565
IT	58054	Poggioferro	Toscana	Grosseto	GR	13566
IT	58054	Pancole	Toscana	Grosseto	GR	13567
IT	58054	Preselle	Toscana	Grosseto	GR	13568
IT	58054	Pomonte	Toscana	Grosseto	GR	13569
IT	58054	Polveraia	Toscana	Grosseto	GR	13570
IT	58054	Scansano	Toscana	Grosseto	GR	13571
IT	58054	Montorgiali	Toscana	Grosseto	GR	13572
IT	58054	Preselle Sergardi	Toscana	Grosseto	GR	13573
IT	58055	Semproniano	Toscana	Grosseto	GR	13574
IT	58055	Petricci	Toscana	Grosseto	GR	13575
IT	58055	Catabbio	Toscana	Grosseto	GR	13576
IT	58055	Cellena	Toscana	Grosseto	GR	13577
IT	58100	Montepescali	Toscana	Grosseto	GR	13578
IT	58100	Batignano	Toscana	Grosseto	GR	13579
IT	58100	Grosseto	Toscana	Grosseto	GR	13580
IT	58100	Braccagni	Toscana	Grosseto	GR	13581
IT	58100	Alberese	Toscana	Grosseto	GR	13582
IT	58100	Roselle Terme	Toscana	Grosseto	GR	13583
IT	58100	Santa Maria Di Rispescia	Toscana	Grosseto	GR	13584
IT	58100	Bagno Roselle	Toscana	Grosseto	GR	13585
IT	58100	Rispescia	Toscana	Grosseto	GR	13586
IT	58100	Montepescali Stazione	Toscana	Grosseto	GR	13587
IT	58100	Le Stiacciole	Toscana	Grosseto	GR	13588
IT	58100	Marina Di Grosseto	Toscana	Grosseto	GR	13589
IT	58100	Istia D'Ombrone	Toscana	Grosseto	GR	13590
IT	57014	Vicarello	Toscana	Livorno	LI	13591
IT	57014	Crocino San Giusto	Toscana	Livorno	LI	13592
IT	57014	Parrana San Giusto	Toscana	Livorno	LI	13593
IT	57014	Parrana San Martino	Toscana	Livorno	LI	13594
IT	57014	Collesalvetti	Toscana	Livorno	LI	13595
IT	57014	Colognole	Toscana	Livorno	LI	13596
IT	57014	Crocino	Toscana	Livorno	LI	13597
IT	57014	Castell'Anselmo	Toscana	Livorno	LI	13598
IT	57016	Rosignano Marittimo	Toscana	Livorno	LI	13599
IT	57016	Castiglioncello	Toscana	Livorno	LI	13600
IT	57016	Nibbiaia	Toscana	Livorno	LI	13601
IT	57016	Rosignano Solvay	Toscana	Livorno	LI	13602
IT	57016	Vada	Toscana	Livorno	LI	13603
IT	57016	Gabbro	Toscana	Livorno	LI	13604
IT	57016	Caletta Di Castiglioncello	Toscana	Livorno	LI	13605
IT	57016	Castelnuovo Misericordia	Toscana	Livorno	LI	13606
IT	57017	Guasticce	Toscana	Livorno	LI	13607
IT	57017	Nugola	Toscana	Livorno	LI	13608
IT	57017	Nugola Nuova	Toscana	Livorno	LI	13609
IT	57017	Stagno	Toscana	Livorno	LI	13610
IT	57020	Bibbona	Toscana	Livorno	LI	13611
IT	57020	Sassetta	Toscana	Livorno	LI	13612
IT	57020	La California	Toscana	Livorno	LI	13613
IT	57021	Campiglia Marittima Stazione	Toscana	Livorno	LI	13614
IT	57021	Campiglia Marittima	Toscana	Livorno	LI	13615
IT	57021	Venturina	Toscana	Livorno	LI	13616
IT	57021	Stazione Di Campiglia Marittima	Toscana	Livorno	LI	13617
IT	57022	Bolgheri	Toscana	Livorno	LI	13618
IT	57022	Marina Di Castagneto	Toscana	Livorno	LI	13619
IT	57022	Donoratico	Toscana	Livorno	LI	13620
IT	57022	Marina Di Castagneto Carducci	Toscana	Livorno	LI	13621
IT	57022	San Guido	Toscana	Livorno	LI	13622
IT	57022	Castagneto Carducci	Toscana	Livorno	LI	13623
IT	57023	Cecina	Toscana	Livorno	LI	13624
IT	57023	Cecina Marina	Toscana	Livorno	LI	13625
IT	57023	San Pietro In Palazzi	Toscana	Livorno	LI	13626
IT	57025	Riotorto	Toscana	Livorno	LI	13627
IT	57025	Populonia	Toscana	Livorno	LI	13628
IT	57025	Vignale Riotorto	Toscana	Livorno	LI	13629
IT	57025	Colmata	Toscana	Livorno	LI	13630
IT	57025	Piombino	Toscana	Livorno	LI	13631
IT	57025	Cotone	Toscana	Livorno	LI	13632
IT	57025	Colmata Fiorentina Di Piombino	Toscana	Livorno	LI	13633
IT	57025	Torre Mozza	Toscana	Livorno	LI	13634
IT	57025	Portovecchio	Toscana	Livorno	LI	13635
IT	57027	San Vincenzo	Toscana	Livorno	LI	13636
IT	57027	San Carlo	Toscana	Livorno	LI	13637
IT	57028	Montioni	Toscana	Livorno	LI	13638
IT	57028	Suvereto	Toscana	Livorno	LI	13639
IT	57030	Procchio	Toscana	Livorno	LI	13640
IT	57030	Marciana	Toscana	Livorno	LI	13641
IT	57030	Poggio	Toscana	Livorno	LI	13642
IT	57030	Pomonte	Toscana	Livorno	LI	13643
IT	57031	Capoliveri	Toscana	Livorno	LI	13644
IT	57032	Capraia Isola	Toscana	Livorno	LI	13645
IT	57033	Marciana Marina	Toscana	Livorno	LI	13646
IT	57034	La Pila	Toscana	Livorno	LI	13647
IT	57034	Marina Di Campo	Toscana	Livorno	LI	13648
IT	57034	San Piero In Campo	Toscana	Livorno	LI	13649
IT	57034	Sant'Ilario	Toscana	Livorno	LI	13650
IT	57034	Campo Nell'Elba	Toscana	Livorno	LI	13651
IT	57034	Pianosa	Toscana	Livorno	LI	13652
IT	57034	Seccheto	Toscana	Livorno	LI	13653
IT	57034	Cavoli	Toscana	Livorno	LI	13654
IT	57034	Pianosa Isola	Toscana	Livorno	LI	13655
IT	57036	Porto Azzurro	Toscana	Livorno	LI	13656
IT	57037	San Giovanni	Toscana	Livorno	LI	13657
IT	57037	Carpani	Toscana	Livorno	LI	13658
IT	57037	Portoferraio	Toscana	Livorno	LI	13659
IT	57037	Magazzini	Toscana	Livorno	LI	13660
IT	57038	Cavo	Toscana	Livorno	LI	13661
IT	57038	Rio Marina	Toscana	Livorno	LI	13662
IT	57039	Rio Nell'Elba	Toscana	Livorno	LI	13663
IT	57100	Livorno	Toscana	Livorno	LI	13664
IT	57121	Livorno	Toscana	Livorno	LI	13665
IT	57122	Livorno	Toscana	Livorno	LI	13666
IT	57123	Livorno	Toscana	Livorno	LI	13667
IT	57124	Salviano	Toscana	Livorno	LI	13668
IT	57124	Valle Benedetta	Toscana	Livorno	LI	13669
IT	57124	Livorno	Toscana	Livorno	LI	13670
IT	57125	Livorno	Toscana	Livorno	LI	13671
IT	57126	Livorno	Toscana	Livorno	LI	13672
IT	57127	Livorno	Toscana	Livorno	LI	13673
IT	57128	Ardenza	Toscana	Livorno	LI	13674
IT	57128	Antignano	Toscana	Livorno	LI	13675
IT	57128	Montenero	Toscana	Livorno	LI	13676
IT	57128	Livorno	Toscana	Livorno	LI	13677
IT	55010	Lappato	Toscana	Lucca	LU	13678
IT	55010	Gragnano	Toscana	Lucca	LU	13679
IT	55010	San Gennaro	Toscana	Lucca	LU	13680
IT	55010	Camigliano Santa Gemma	Toscana	Lucca	LU	13681
IT	55011	Spianate	Toscana	Lucca	LU	13682
IT	55011	Marginone	Toscana	Lucca	LU	13683
IT	55011	Badia Pozzeveri	Toscana	Lucca	LU	13684
IT	55011	Altopascio	Toscana	Lucca	LU	13685
IT	55012	Capannori	Toscana	Lucca	LU	13686
IT	55012	Pieve San Paolo	Toscana	Lucca	LU	13687
IT	55012	Zone	Toscana	Lucca	LU	13688
IT	55012	Lunata	Toscana	Lucca	LU	13689
IT	55013	Lammari	Toscana	Lucca	LU	13690
IT	55014	Marlia	Toscana	Lucca	LU	13691
IT	55015	San Salvatore Di Montecarlo	Toscana	Lucca	LU	13692
IT	55015	San Salvatore	Toscana	Lucca	LU	13693
IT	55015	Montecarlo	Toscana	Lucca	LU	13694
IT	55015	Turchetto	Toscana	Lucca	LU	13695
IT	55016	Porcari	Toscana	Lucca	LU	13696
IT	55018	San Colombano	Toscana	Lucca	LU	13697
IT	55018	Segromigno In Piano	Toscana	Lucca	LU	13698
IT	55018	Matraia	Toscana	Lucca	LU	13699
IT	55018	Segromigno In Monte	Toscana	Lucca	LU	13700
IT	55019	Pracando	Toscana	Lucca	LU	13701
IT	55019	Botticino	Toscana	Lucca	LU	13702
IT	55019	Villa Basilica	Toscana	Lucca	LU	13703
IT	55020	Vergemoli	Toscana	Lucca	LU	13704
IT	55020	Fornovolasco	Toscana	Lucca	LU	13705
IT	55020	Fosciandora	Toscana	Lucca	LU	13706
IT	55020	San Pellegrinetto	Toscana	Lucca	LU	13707
IT	55020	Molazzana	Toscana	Lucca	LU	13708
IT	55020	Sassi	Toscana	Lucca	LU	13709
IT	55021	Fabbriche Di Vallico	Toscana	Lucca	LU	13710
IT	55021	Fabbriche Di Vergemoli	Toscana	Lucca	LU	13711
IT	55022	Bagni Di Lucca	Toscana	Lucca	LU	13712
IT	55022	Isola	Toscana	Lucca	LU	13713
IT	55022	Benabbio	Toscana	Lucca	LU	13714
IT	55022	Lucchio	Toscana	Lucca	LU	13715
IT	55022	Montefegatesi	Toscana	Lucca	LU	13716
IT	55022	Bagni Di Lucca Ponte	Toscana	Lucca	LU	13717
IT	55022	Pieve Di Controne	Toscana	Lucca	LU	13718
IT	55022	Bagni Di Lucca Villa	Toscana	Lucca	LU	13719
IT	55022	Casabasciana	Toscana	Lucca	LU	13720
IT	55022	San Cassiano	Toscana	Lucca	LU	13721
IT	55022	Scesta	Toscana	Lucca	LU	13722
IT	55022	Fornoli	Toscana	Lucca	LU	13723
IT	55022	Ponte A Serraglio	Toscana	Lucca	LU	13724
IT	55022	San Cassiano Di Controni	Toscana	Lucca	LU	13725
IT	55023	Borgo A Mozzano	Toscana	Lucca	LU	13726
IT	55023	Diecimo	Toscana	Lucca	LU	13727
IT	55023	Valdottavo	Toscana	Lucca	LU	13728
IT	55023	Corsagna	Toscana	Lucca	LU	13729
IT	55023	Anchiano	Toscana	Lucca	LU	13730
IT	55023	Chifenti	Toscana	Lucca	LU	13731
IT	55023	Gioviano	Toscana	Lucca	LU	13732
IT	55025	Coreglia Antelminelli	Toscana	Lucca	LU	13733
IT	55025	Ghivizzano	Toscana	Lucca	LU	13734
IT	55025	Tereglio	Toscana	Lucca	LU	13735
IT	55025	Calavorno	Toscana	Lucca	LU	13736
IT	55025	Piano Di Coreglia	Toscana	Lucca	LU	13737
IT	55027	Fiattone	Toscana	Lucca	LU	13738
IT	55027	Trassilico	Toscana	Lucca	LU	13739
IT	55027	Turritecava	Toscana	Lucca	LU	13740
IT	55027	Gallicano	Toscana	Lucca	LU	13741
IT	55030	Corfino	Toscana	Lucca	LU	13742
IT	55030	Vagli Sotto	Toscana	Lucca	LU	13743
IT	55030	Careggine	Toscana	Lucca	LU	13744
IT	55030	Magliano	Toscana	Lucca	LU	13745
IT	55030	Villa Collemandina	Toscana	Lucca	LU	13746
IT	55030	Vagli Sopra	Toscana	Lucca	LU	13747
IT	55031	Poggio	Toscana	Lucca	LU	13748
IT	55031	Filicaia	Toscana	Lucca	LU	13749
IT	55031	Camporgiano	Toscana	Lucca	LU	13750
IT	55031	Poggio Garfagnana	Toscana	Lucca	LU	13751
IT	55032	Palleroso	Toscana	Lucca	LU	13752
IT	55032	Castelnuovo Di Garfagnana	Toscana	Lucca	LU	13753
IT	55033	Chiozza	Toscana	Lucca	LU	13754
IT	55033	Valbona	Toscana	Lucca	LU	13755
IT	55033	Castiglione Di Garfagnana	Toscana	Lucca	LU	13756
IT	55033	Cerageto	Toscana	Lucca	LU	13757
IT	55033	San Pellegrino	Toscana	Lucca	LU	13758
IT	55034	Gramolazzo	Toscana	Lucca	LU	13759
IT	55034	Minucciano	Toscana	Lucca	LU	13760
IT	55034	Pieve San Lorenzo	Toscana	Lucca	LU	13761
IT	55034	Gorfigliano	Toscana	Lucca	LU	13762
IT	55034	Casone Carpinelli	Toscana	Lucca	LU	13763
IT	55034	Carpinelli	Toscana	Lucca	LU	13764
IT	55035	San Michele	Toscana	Lucca	LU	13765
IT	55035	Piazza Al Serchio	Toscana	Lucca	LU	13766
IT	55035	Sant'Anastasio	Toscana	Lucca	LU	13767
IT	55036	Pieve Fosciana	Toscana	Lucca	LU	13768
IT	55038	San Romano In Garfagnana	Toscana	Lucca	LU	13769
IT	55039	Sillano Giuncugnano	Toscana	Lucca	LU	13770
IT	55039	Sillano	Toscana	Lucca	LU	13771
IT	55039	Giuncugnano	Toscana	Lucca	LU	13772
IT	55040	Terrinca	Toscana	Lucca	LU	13773
IT	55040	Ruosina	Toscana	Lucca	LU	13774
IT	55040	Pontestazzemese	Toscana	Lucca	LU	13775
IT	55040	Stazzema	Toscana	Lucca	LU	13776
IT	55041	Lido Di Camaiore	Toscana	Lucca	LU	13777
IT	55041	Pedona	Toscana	Lucca	LU	13778
IT	55041	Camaiore	Toscana	Lucca	LU	13779
IT	55041	Capezzano Pianore	Toscana	Lucca	LU	13780
IT	55041	Casoli	Toscana	Lucca	LU	13781
IT	55041	Valpromaro	Toscana	Lucca	LU	13782
IT	55041	Nocchi	Toscana	Lucca	LU	13783
IT	55041	Pieve	Toscana	Lucca	LU	13784
IT	55041	Montebello	Toscana	Lucca	LU	13785
IT	55041	Vado	Toscana	Lucca	LU	13786
IT	55041	Montemagno	Toscana	Lucca	LU	13787
IT	55042	Forte Dei Marmi	Toscana	Lucca	LU	13788
IT	55045	Pietrasanta	Toscana	Lucca	LU	13789
IT	55045	Fiumetto	Toscana	Lucca	LU	13790
IT	55045	Capezzano	Toscana	Lucca	LU	13791
IT	55045	Vallecchia	Toscana	Lucca	LU	13792
IT	55045	Tonfano	Toscana	Lucca	LU	13793
IT	55045	Marina Di Pietrasanta	Toscana	Lucca	LU	13794
IT	55045	Capriglia	Toscana	Lucca	LU	13795
IT	55045	Focette	Toscana	Lucca	LU	13796
IT	55045	Valdicastello Carducci	Toscana	Lucca	LU	13797
IT	55045	Capezzano Monte	Toscana	Lucca	LU	13798
IT	55045	Crociale	Toscana	Lucca	LU	13799
IT	55045	Strettoia	Toscana	Lucca	LU	13800
IT	55047	Seravezza	Toscana	Lucca	LU	13801
IT	55047	Azzano	Toscana	Lucca	LU	13802
IT	55047	Riomagno	Toscana	Lucca	LU	13803
IT	55047	Pozzi	Toscana	Lucca	LU	13804
IT	55047	Basati	Toscana	Lucca	LU	13805
IT	55047	Ripa	Toscana	Lucca	LU	13806
IT	55047	Ponterosso	Toscana	Lucca	LU	13807
IT	55047	Querceta	Toscana	Lucca	LU	13808
IT	55049	Torre Del Lago Puccini	Toscana	Lucca	LU	13809
IT	55049	Viareggio	Toscana	Lucca	LU	13810
IT	55051	Castelvecchio Pascoli	Toscana	Lucca	LU	13811
IT	55051	Mologno	Toscana	Lucca	LU	13812
IT	55051	Filecchio	Toscana	Lucca	LU	13813
IT	55051	Ponte All'Ania	Toscana	Lucca	LU	13814
IT	55051	Sommocolonia	Toscana	Lucca	LU	13815
IT	55051	Barga	Toscana	Lucca	LU	13816
IT	55051	Fornaci Di Barga	Toscana	Lucca	LU	13817
IT	55051	Tiglio	Toscana	Lucca	LU	13818
IT	55051	Sommacolonia	Toscana	Lucca	LU	13819
IT	55054	Quiesa	Toscana	Lucca	LU	13820
IT	55054	Massarosa	Toscana	Lucca	LU	13821
IT	55054	Pieve A Elici	Toscana	Lucca	LU	13822
IT	55054	Piano Di Mommio	Toscana	Lucca	LU	13823
IT	55054	Gualdo	Toscana	Lucca	LU	13824
IT	55054	Stiava	Toscana	Lucca	LU	13825
IT	55054	Corsanico	Toscana	Lucca	LU	13826
IT	55054	Bozzano	Toscana	Lucca	LU	13827
IT	55054	Gualdo Di Massarosa	Toscana	Lucca	LU	13828
IT	55060	Vorno	Toscana	Lucca	LU	13829
IT	55060	Palagnana	Toscana	Lucca	LU	13830
IT	55060	Massa Macinaia	Toscana	Lucca	LU	13831
IT	55060	Guamo	Toscana	Lucca	LU	13832
IT	55060	Badia Cantignano	Toscana	Lucca	LU	13833
IT	55061	San Ginese	Toscana	Lucca	LU	13834
IT	55061	Carraia	Toscana	Lucca	LU	13835
IT	55062	Pieve Di Compito	Toscana	Lucca	LU	13836
IT	55062	Colle Di Compito	Toscana	Lucca	LU	13837
IT	55062	Ruota	Toscana	Lucca	LU	13838
IT	55064	Pescaglia	Toscana	Lucca	LU	13839
IT	55064	Villa A Roggio	Toscana	Lucca	LU	13840
IT	55064	Pascoso	Toscana	Lucca	LU	13841
IT	55064	Piegaio Basso	Toscana	Lucca	LU	13842
IT	55064	San Martino In Freddana	Toscana	Lucca	LU	13843
IT	55064	Loppeglia	Toscana	Lucca	LU	13844
IT	55064	San Rocco In Turrite	Toscana	Lucca	LU	13845
IT	55064	Piegaio	Toscana	Lucca	LU	13846
IT	55100	Saltocchio	Toscana	Lucca	LU	13847
IT	55100	Mutigliano	Toscana	Lucca	LU	13848
IT	55100	Fagnano	Toscana	Lucca	LU	13849
IT	55100	San Concordio Di Moriano	Toscana	Lucca	LU	13850
IT	55100	Lucca	Toscana	Lucca	LU	13851
IT	55100	Nozzano	Toscana	Lucca	LU	13852
IT	55100	Cerasomma	Toscana	Lucca	LU	13853
IT	55100	Piaggione	Toscana	Lucca	LU	13854
IT	55100	Ponte San Pietro	Toscana	Lucca	LU	13855
IT	55100	San Lorenzo Di Moriano	Toscana	Lucca	LU	13856
IT	55100	Montuolo	Toscana	Lucca	LU	13857
IT	55100	Massa Pisana	Toscana	Lucca	LU	13858
IT	55100	Picciorana	Toscana	Lucca	LU	13859
IT	55100	Monte San Quirico	Toscana	Lucca	LU	13860
IT	55100	San Pietro A Vico	Toscana	Lucca	LU	13861
IT	55100	Ponte A Moriano	Toscana	Lucca	LU	13862
IT	55100	Maggiano	Toscana	Lucca	LU	13863
IT	55100	Santa Maria Del Giudice	Toscana	Lucca	LU	13864
IT	55100	Ponte Del Giglio	Toscana	Lucca	LU	13865
IT	55100	Pontetetto	Toscana	Lucca	LU	13866
IT	55100	Gattaiola	Toscana	Lucca	LU	13867
IT	55100	Vinchiana	Toscana	Lucca	LU	13868
IT	54010	Podenzana	Toscana	Massa-Carrara	MS	13869
IT	54010	Montedivalli	Toscana	Massa-Carrara	MS	13870
IT	54011	Bibola	Toscana	Massa-Carrara	MS	13871
IT	54011	Bigliolo	Toscana	Massa-Carrara	MS	13872
IT	54011	Caprigliola	Toscana	Massa-Carrara	MS	13873
IT	54011	Albiano Magra	Toscana	Massa-Carrara	MS	13874
IT	54011	Pallerone	Toscana	Massa-Carrara	MS	13875
IT	54011	Serricciolo	Toscana	Massa-Carrara	MS	13876
IT	54011	Quercia	Toscana	Massa-Carrara	MS	13877
IT	54011	Aulla	Toscana	Massa-Carrara	MS	13878
IT	54012	Tresana	Toscana	Massa-Carrara	MS	13879
IT	54012	Barbarasco	Toscana	Massa-Carrara	MS	13880
IT	54012	Villa Di Tresana	Toscana	Massa-Carrara	MS	13881
IT	54013	Rometta	Toscana	Massa-Carrara	MS	13882
IT	54013	Agnino	Toscana	Massa-Carrara	MS	13883
IT	54013	Tenerano	Toscana	Massa-Carrara	MS	13884
IT	54013	Sassalbo	Toscana	Massa-Carrara	MS	13885
IT	54013	Gragnola	Toscana	Massa-Carrara	MS	13886
IT	54013	Vinca	Toscana	Massa-Carrara	MS	13887
IT	54013	Soliera	Toscana	Massa-Carrara	MS	13888
IT	54013	Colla	Toscana	Massa-Carrara	MS	13889
IT	54013	Campiglione	Toscana	Massa-Carrara	MS	13890
IT	54013	Gassano	Toscana	Massa-Carrara	MS	13891
IT	54013	Moncigoli	Toscana	Massa-Carrara	MS	13892
IT	54013	San Terenzo Monti	Toscana	Massa-Carrara	MS	13893
IT	54013	Fivizzano	Toscana	Massa-Carrara	MS	13894
IT	54013	Ceserano	Toscana	Massa-Carrara	MS	13895
IT	54013	Monzone	Toscana	Massa-Carrara	MS	13896
IT	54013	Soliera Apuana	Toscana	Massa-Carrara	MS	13897
IT	54013	Rometta Apuana	Toscana	Massa-Carrara	MS	13898
IT	54014	Equi	Toscana	Massa-Carrara	MS	13899
IT	54014	Equi Terme	Toscana	Massa-Carrara	MS	13900
IT	54014	Codiponte	Toscana	Massa-Carrara	MS	13901
IT	54014	Casola In Lunigiana	Toscana	Massa-Carrara	MS	13902
IT	54014	Regnano	Toscana	Massa-Carrara	MS	13903
IT	54015	Crespiano	Toscana	Massa-Carrara	MS	13904
IT	54015	Comano	Toscana	Massa-Carrara	MS	13905
IT	54016	Licciana Nardi	Toscana	Massa-Carrara	MS	13906
IT	54016	Terrarossa	Toscana	Massa-Carrara	MS	13907
IT	54016	Monti	Toscana	Massa-Carrara	MS	13908
IT	54016	Monti Di Licciana	Toscana	Massa-Carrara	MS	13909
IT	54016	Tavernelle	Toscana	Massa-Carrara	MS	13910
IT	54021	Bagnone	Toscana	Massa-Carrara	MS	13911
IT	54021	Corlaga	Toscana	Massa-Carrara	MS	13912
IT	54021	Gabbiana	Toscana	Massa-Carrara	MS	13913
IT	54021	Treschietto	Toscana	Massa-Carrara	MS	13914
IT	54023	Ponticello	Toscana	Massa-Carrara	MS	13915
IT	54023	Scorcetoli	Toscana	Massa-Carrara	MS	13916
IT	54023	Filattiera	Toscana	Massa-Carrara	MS	13917
IT	54023	Cantiere	Toscana	Massa-Carrara	MS	13918
IT	54026	Arpiola	Toscana	Massa-Carrara	MS	13919
IT	54026	Groppoli	Toscana	Massa-Carrara	MS	13920
IT	54026	Montereggio Di Mulazzo	Toscana	Massa-Carrara	MS	13921
IT	54026	Mulazzo	Toscana	Massa-Carrara	MS	13922
IT	54026	Montereggio	Toscana	Massa-Carrara	MS	13923
IT	54027	Vignola	Toscana	Massa-Carrara	MS	13924
IT	54027	Pontremoli	Toscana	Massa-Carrara	MS	13925
IT	54027	Traverde	Toscana	Massa-Carrara	MS	13926
IT	54027	Molinello	Toscana	Massa-Carrara	MS	13927
IT	54027	Cervara	Toscana	Massa-Carrara	MS	13928
IT	54027	Guinadi	Toscana	Massa-Carrara	MS	13929
IT	54027	Grondola	Toscana	Massa-Carrara	MS	13930
IT	54028	Merizzo	Toscana	Massa-Carrara	MS	13931
IT	54028	Villafranca In Lunigiana	Toscana	Massa-Carrara	MS	13932
IT	54028	Filetto	Toscana	Massa-Carrara	MS	13933
IT	54028	Virgoletta	Toscana	Massa-Carrara	MS	13934
IT	54029	Chiesa Di Rossano	Toscana	Massa-Carrara	MS	13935
IT	54029	Zeri	Toscana	Massa-Carrara	MS	13936
IT	54033	Miseglia	Toscana	Massa-Carrara	MS	13937
IT	54033	Gragnana	Toscana	Massa-Carrara	MS	13938
IT	54033	Avenza	Toscana	Massa-Carrara	MS	13939
IT	54033	Torano	Toscana	Massa-Carrara	MS	13940
IT	54033	Castelpoggio	Toscana	Massa-Carrara	MS	13941
IT	54033	Codena	Toscana	Massa-Carrara	MS	13942
IT	54033	Sorgnano	Toscana	Massa-Carrara	MS	13943
IT	54033	Colonnata	Toscana	Massa-Carrara	MS	13944
IT	54033	Carrara	Toscana	Massa-Carrara	MS	13945
IT	54033	Marina Di Carrara	Toscana	Massa-Carrara	MS	13946
IT	54033	Fossone	Toscana	Massa-Carrara	MS	13947
IT	54033	Bedizzano	Toscana	Massa-Carrara	MS	13948
IT	54033	Bergiola	Toscana	Massa-Carrara	MS	13949
IT	54033	Fontia	Toscana	Massa-Carrara	MS	13950
IT	54033	Fossola	Toscana	Massa-Carrara	MS	13951
IT	54035	Marciaso	Toscana	Massa-Carrara	MS	13952
IT	54035	Fosdinovo	Toscana	Massa-Carrara	MS	13953
IT	54035	Melara	Toscana	Massa-Carrara	MS	13954
IT	54035	Caniparola	Toscana	Massa-Carrara	MS	13955
IT	54035	Borghetto	Toscana	Massa-Carrara	MS	13956
IT	54035	Tendola	Toscana	Massa-Carrara	MS	13957
IT	54038	Cinquale	Toscana	Massa-Carrara	MS	13958
IT	54038	San Vito	Toscana	Massa-Carrara	MS	13959
IT	54038	Montignoso	Toscana	Massa-Carrara	MS	13960
IT	54038	Prato Capanne	Toscana	Massa-Carrara	MS	13961
IT	54038	Cerreto	Toscana	Massa-Carrara	MS	13962
IT	54100	Turano	Toscana	Massa-Carrara	MS	13963
IT	54100	Canevara	Toscana	Massa-Carrara	MS	13964
IT	54100	Massa	Toscana	Massa-Carrara	MS	13965
IT	54100	Mirteto	Toscana	Massa-Carrara	MS	13966
IT	54100	Ronchi	Toscana	Massa-Carrara	MS	13967
IT	54100	Marina Di Massa	Toscana	Massa-Carrara	MS	13968
IT	54100	Casette	Toscana	Massa-Carrara	MS	13969
IT	54100	Quercioli	Toscana	Massa-Carrara	MS	13970
IT	54100	Altagnana	Toscana	Massa-Carrara	MS	13971
IT	54100	Forno	Toscana	Massa-Carrara	MS	13972
IT	56010	Arena Metato	Toscana	Pisa	PI	13973
IT	56010	Vicopisano	Toscana	Pisa	PI	13974
IT	56010	Mezzana	Toscana	Pisa	PI	13975
IT	56010	Caprona	Toscana	Pisa	PI	13976
IT	56010	Uliveto Terme	Toscana	Pisa	PI	13977
IT	56010	Campo	Toscana	Pisa	PI	13978
IT	56010	Cucigliana	Toscana	Pisa	PI	13979
IT	56010	San Giovanni Alla Vena	Toscana	Pisa	PI	13980
IT	56011	Gabella	Toscana	Pisa	PI	13981
IT	56011	Montemagno	Toscana	Pisa	PI	13982
IT	56011	Calci	Toscana	Pisa	PI	13983
IT	56011	Castelmaggiore	Toscana	Pisa	PI	13984
IT	56012	Fornacette	Toscana	Pisa	PI	13985
IT	56012	Calcinaia	Toscana	Pisa	PI	13986
IT	56017	Pontasserchio	Toscana	Pisa	PI	13987
IT	56017	Ripafratta	Toscana	Pisa	PI	13988
IT	56017	Gello	Toscana	Pisa	PI	13989
IT	56017	San Giuliano Terme	Toscana	Pisa	PI	13990
IT	56017	Agnano	Toscana	Pisa	PI	13991
IT	56017	Arena	Toscana	Pisa	PI	13992
IT	56017	Asciano	Toscana	Pisa	PI	13993
IT	56017	Rigoli	Toscana	Pisa	PI	13994
IT	56017	Pappiana	Toscana	Pisa	PI	13995
IT	56017	Ghezzano	Toscana	Pisa	PI	13996
IT	56017	Molina Di Quosa	Toscana	Pisa	PI	13997
IT	56019	Nodica	Toscana	Pisa	PI	13998
IT	56019	Filettole	Toscana	Pisa	PI	13999
IT	56019	Avane	Toscana	Pisa	PI	14000
IT	56019	Migliarino	Toscana	Pisa	PI	14001
IT	56019	Vecchiano	Toscana	Pisa	PI	14002
IT	56020	Montopoli In Val D'Arno	Toscana	Pisa	PI	14003
IT	56020	Castel Del Bosco	Toscana	Pisa	PI	14004
IT	56020	Montopoli	Toscana	Pisa	PI	14005
IT	56020	Cerretti	Toscana	Pisa	PI	14006
IT	56020	Marti	Toscana	Pisa	PI	14007
IT	56020	San Romano	Toscana	Pisa	PI	14008
IT	56020	Capanne	Toscana	Pisa	PI	14009
IT	56020	Montecalvoli	Toscana	Pisa	PI	14010
IT	56020	Santa Maria A Monte	Toscana	Pisa	PI	14011
IT	56021	San Casciano	Toscana	Pisa	PI	14012
IT	56021	Latignano	Toscana	Pisa	PI	14013
IT	56021	San Benedetto A Settimo	Toscana	Pisa	PI	14014
IT	56021	San Lorenzo A Pagnatico	Toscana	Pisa	PI	14015
IT	56021	Cascina	Toscana	Pisa	PI	14016
IT	56021	Marciana	Toscana	Pisa	PI	14017
IT	56021	San Frediano A Settimo	Toscana	Pisa	PI	14018
IT	56022	Villa Campanile	Toscana	Pisa	PI	14019
IT	56022	Castelfranco Di Sotto	Toscana	Pisa	PI	14020
IT	56022	Orentano	Toscana	Pisa	PI	14021
IT	56023	Navacchio	Toscana	Pisa	PI	14022
IT	56023	Ripoli	Toscana	Pisa	PI	14023
IT	56023	Musigliano	Toscana	Pisa	PI	14024
IT	56023	San Lorenzo Alle Corti	Toscana	Pisa	PI	14025
IT	56023	Montione	Toscana	Pisa	PI	14026
IT	56024	Corazzano	Toscana	Pisa	PI	14027
IT	56024	La Serra	Toscana	Pisa	PI	14028
IT	56024	Ponte A Egola	Toscana	Pisa	PI	14029
IT	56025	Santa Lucia	Toscana	Pisa	PI	14030
IT	56025	Pontedera	Toscana	Pisa	PI	14031
IT	56025	Il Romito	Toscana	Pisa	PI	14032
IT	56025	La Rotta	Toscana	Pisa	PI	14033
IT	56025	Montecastello	Toscana	Pisa	PI	14034
IT	56025	Treggiaia	Toscana	Pisa	PI	14035
IT	56025	La Borra	Toscana	Pisa	PI	14036
IT	56028	San Miniato	Toscana	Pisa	PI	14037
IT	56028	Ponte A Elsa	Toscana	Pisa	PI	14038
IT	56028	San Miniato Basso	Toscana	Pisa	PI	14039
IT	56028	Isola	Toscana	Pisa	PI	14040
IT	56028	La Scala	Toscana	Pisa	PI	14041
IT	56029	Santa Croce Sull'Arno	Toscana	Pisa	PI	14042
IT	56029	Staffoli	Toscana	Pisa	PI	14043
IT	56030	Orciatico	Toscana	Pisa	PI	14044
IT	56030	Selvatelle	Toscana	Pisa	PI	14045
IT	56030	Soiana	Toscana	Pisa	PI	14046
IT	56030	Lajatico	Toscana	Pisa	PI	14047
IT	56030	Terricciola	Toscana	Pisa	PI	14048
IT	56030	Morrona	Toscana	Pisa	PI	14049
IT	56031	Quattro Strade	Toscana	Pisa	PI	14050
IT	56031	Bientina	Toscana	Pisa	PI	14051
IT	56032	La Croce	Toscana	Pisa	PI	14052
IT	56032	Cascine	Toscana	Pisa	PI	14053
IT	56032	Buti	Toscana	Pisa	PI	14054
IT	56033	Capannoli	Toscana	Pisa	PI	14055
IT	56033	San Pietro Belvedere	Toscana	Pisa	PI	14056
IT	56034	Chianni	Toscana	Pisa	PI	14057
IT	56034	Casciana Terme	Toscana	Pisa	PI	14058
IT	56034	Rivalto	Toscana	Pisa	PI	14059
IT	56035	Lavaiano	Toscana	Pisa	PI	14060
IT	56035	Cevoli	Toscana	Pisa	PI	14061
IT	56035	Lari	Toscana	Pisa	PI	14062
IT	56035	Usigliano	Toscana	Pisa	PI	14063
IT	56035	Le Casine	Toscana	Pisa	PI	14064
IT	56035	Casciana Alta	Toscana	Pisa	PI	14065
IT	56035	Perignano	Toscana	Pisa	PI	14066
IT	56035	Casciana Terme Lari	Toscana	Pisa	PI	14067
IT	56035	Spinelli	Toscana	Pisa	PI	14068
IT	56036	Montefoscoli	Toscana	Pisa	PI	14069
IT	56036	Villa Saletta	Toscana	Pisa	PI	14070
IT	56036	Forcoli	Toscana	Pisa	PI	14071
IT	56036	Alica	Toscana	Pisa	PI	14072
IT	56036	Partino	Toscana	Pisa	PI	14073
IT	56036	Palaia	Toscana	Pisa	PI	14074
IT	56037	Ghizzano Di Peccioli	Toscana	Pisa	PI	14075
IT	56037	Fabbrica	Toscana	Pisa	PI	14076
IT	56037	Peccioli	Toscana	Pisa	PI	14077
IT	56037	Fabbrica Di Peccioli	Toscana	Pisa	PI	14078
IT	56037	Legoli	Toscana	Pisa	PI	14079
IT	56037	Ghizzano	Toscana	Pisa	PI	14080
IT	56038	Ponsacco	Toscana	Pisa	PI	14081
IT	56038	Giardino	Toscana	Pisa	PI	14082
IT	56040	Guardistallo	Toscana	Pisa	PI	14083
IT	56040	Montescudaio	Toscana	Pisa	PI	14084
IT	56040	Castello Di Querceto	Toscana	Pisa	PI	14085
IT	56040	Casino Di Terra	Toscana	Pisa	PI	14086
IT	56040	Casale Marittimo	Toscana	Pisa	PI	14087
IT	56040	Sassa	Toscana	Pisa	PI	14088
IT	56040	Cenaia	Toscana	Pisa	PI	14089
IT	56040	Ponteginori	Toscana	Pisa	PI	14090
IT	56040	Orciano Pisano	Toscana	Pisa	PI	14091
IT	56040	Monteverdi Marittimo	Toscana	Pisa	PI	14092
IT	56040	Crespina	Toscana	Pisa	PI	14093
IT	56040	Pastina	Toscana	Pisa	PI	14094
IT	56040	Canneto	Toscana	Pisa	PI	14095
IT	56040	Castellina Marittima	Toscana	Pisa	PI	14096
IT	56040	Le Badie	Toscana	Pisa	PI	14097
IT	56040	Canneto Di Monteverdi	Toscana	Pisa	PI	14098
IT	56040	Pomaia	Toscana	Pisa	PI	14099
IT	56040	Santa Luce	Toscana	Pisa	PI	14100
IT	56040	Montecatini Val Di Cecina	Toscana	Pisa	PI	14101
IT	56040	Pieve Di Santa Luce	Toscana	Pisa	PI	14102
IT	56041	Sasso Pisano	Toscana	Pisa	PI	14103
IT	56041	Castelnuovo Di Val Di Cecina	Toscana	Pisa	PI	14104
IT	56041	Montecastelli Pisano	Toscana	Pisa	PI	14105
IT	56042	Lorenzana	Toscana	Pisa	PI	14106
IT	56042	Crespina Lorenzana	Toscana	Pisa	PI	14107
IT	56043	Fauglia	Toscana	Pisa	PI	14108
IT	56043	Luciana	Toscana	Pisa	PI	14109
IT	56044	Serrazzano	Toscana	Pisa	PI	14110
IT	56044	Lustignano	Toscana	Pisa	PI	14111
IT	56044	Larderello	Toscana	Pisa	PI	14112
IT	56044	Montecerboli	Toscana	Pisa	PI	14113
IT	56045	Montegemoli	Toscana	Pisa	PI	14114
IT	56045	San Dalmazio	Toscana	Pisa	PI	14115
IT	56045	Libbiano	Toscana	Pisa	PI	14116
IT	56045	Micciano	Toscana	Pisa	PI	14117
IT	56045	Pomarance	Toscana	Pisa	PI	14118
IT	56046	Riparbella	Toscana	Pisa	PI	14119
IT	56048	Pignano	Toscana	Pisa	PI	14120
IT	56048	Saline	Toscana	Pisa	PI	14121
IT	56048	Villamagna	Toscana	Pisa	PI	14122
IT	56048	Mazzolla	Toscana	Pisa	PI	14123
IT	56048	Saline Di Volterra	Toscana	Pisa	PI	14124
IT	56048	Volterra	Toscana	Pisa	PI	14125
IT	56048	Ulignano	Toscana	Pisa	PI	14126
IT	56100	Pisa	Toscana	Pisa	PI	14127
IT	56121	Putignano	Toscana	Pisa	PI	14128
IT	56121	Coltano	Toscana	Pisa	PI	14129
IT	56121	Riglione	Toscana	Pisa	PI	14130
IT	56121	Pisa	Toscana	Pisa	PI	14131
IT	56122	San Piero A Grado	Toscana	Pisa	PI	14132
IT	56122	Pisa	Toscana	Pisa	PI	14133
IT	56123	Pisa	Toscana	Pisa	PI	14134
IT	56124	Pisa	Toscana	Pisa	PI	14135
IT	56125	Pisa	Toscana	Pisa	PI	14136
IT	56126	Pisa	Toscana	Pisa	PI	14137
IT	56127	Pisa	Toscana	Pisa	PI	14138
IT	56128	Pisa	Toscana	Pisa	PI	14139
IT	59011	Bacchereto	Toscana	Prato	PO	14140
IT	59011	Seano	Toscana	Prato	PO	14141
IT	59013	Fornacelle	Toscana	Prato	PO	14142
IT	59013	Montemurlo	Toscana	Prato	PO	14143
IT	59013	Oste	Toscana	Prato	PO	14144
IT	59015	Carmignano	Toscana	Prato	PO	14145
IT	59015	Poggio Alla Malva	Toscana	Prato	PO	14146
IT	59015	Artimino	Toscana	Prato	PO	14147
IT	59015	Comeana	Toscana	Prato	PO	14148
IT	59015	La Serra	Toscana	Prato	PO	14149
IT	59016	Poggio A Caiano	Toscana	Prato	PO	14150
IT	59016	Poggetto	Toscana	Prato	PO	14151
IT	59021	La Briglia	Toscana	Prato	PO	14152
IT	59021	Schignano	Toscana	Prato	PO	14153
IT	59021	Vaiano	Toscana	Prato	PO	14154
IT	59024	Mercatale	Toscana	Prato	PO	14155
IT	59024	Cavarzano	Toscana	Prato	PO	14156
IT	59024	San Quirico	Toscana	Prato	PO	14157
IT	59024	Mercatale Vernio	Toscana	Prato	PO	14158
IT	59024	Vernio	Toscana	Prato	PO	14159
IT	59024	San Quirico Di Vernio	Toscana	Prato	PO	14160
IT	59025	Luicciana	Toscana	Prato	PO	14161
IT	59025	Carmignanello	Toscana	Prato	PO	14162
IT	59025	Il Fabbro	Toscana	Prato	PO	14163
IT	59025	Usella	Toscana	Prato	PO	14164
IT	59025	Cantagallo	Toscana	Prato	PO	14165
IT	59026	Montepiano	Toscana	Prato	PO	14166
IT	59100	Santa Lucia	Toscana	Prato	PO	14167
IT	59100	Figline Di Prato	Toscana	Prato	PO	14168
IT	59100	La Querce	Toscana	Prato	PO	14169
IT	59100	Cafaggio	Toscana	Prato	PO	14170
IT	59100	Tavola	Toscana	Prato	PO	14171
IT	59100	Prato	Toscana	Prato	PO	14172
IT	59100	Santa Maria A Colonica	Toscana	Prato	PO	14173
IT	59100	Maliseti	Toscana	Prato	PO	14174
IT	59100	Viaccia	Toscana	Prato	PO	14175
IT	59100	San Giorgio A Colonica	Toscana	Prato	PO	14176
IT	59100	Narnali	Toscana	Prato	PO	14177
IT	59100	Paperino	Toscana	Prato	PO	14178
IT	59100	Iolo	Toscana	Prato	PO	14179
IT	59100	Coiano	Toscana	Prato	PO	14180
IT	59100	Galciana	Toscana	Prato	PO	14181
IT	59100	Mezzana	Toscana	Prato	PO	14182
IT	51010	Casore Del Monte	Toscana	Pistoia	PT	14183
IT	51010	Forone	Toscana	Pistoia	PT	14184
IT	51010	Massa E Cozzile	Toscana	Pistoia	PT	14185
IT	51010	Momigno	Toscana	Pistoia	PT	14186
IT	51010	Marliana	Toscana	Pistoia	PT	14187
IT	51010	Avaglio	Toscana	Pistoia	PT	14188
IT	51010	Montagnana	Toscana	Pistoia	PT	14189
IT	51010	Traversagna	Toscana	Pistoia	PT	14190
IT	51010	Uzzano	Toscana	Pistoia	PT	14191
IT	51010	Serra Pistoiese	Toscana	Pistoia	PT	14192
IT	51010	Margine Coperta	Toscana	Pistoia	PT	14193
IT	51010	Santa Lucia	Toscana	Pistoia	PT	14194
IT	51010	Santa Lucia Uzzanese	Toscana	Pistoia	PT	14195
IT	51011	Borgo A Buggiano	Toscana	Pistoia	PT	14196
IT	51011	Buggiano	Toscana	Pistoia	PT	14197
IT	51012	Collodi	Toscana	Pistoia	PT	14198
IT	51012	Veneri	Toscana	Pistoia	PT	14199
IT	51012	Castellare Di Pescia	Toscana	Pistoia	PT	14200
IT	51012	Ponte All'Abate	Toscana	Pistoia	PT	14201
IT	51013	Chiesanuova	Toscana	Pistoia	PT	14202
IT	51013	Chiesina Uzzanese	Toscana	Pistoia	PT	14203
IT	51013	Chiesanuova Uzzanese	Toscana	Pistoia	PT	14204
IT	51015	Pozzarello	Toscana	Pistoia	PT	14205
IT	51015	Montevettolini	Toscana	Pistoia	PT	14206
IT	51015	Monsummano Terme	Toscana	Pistoia	PT	14207
IT	51015	Pazzera	Toscana	Pistoia	PT	14208
IT	51015	Cintolese	Toscana	Pistoia	PT	14209
IT	51015	Grotta Giusti	Toscana	Pistoia	PT	14210
IT	51015	Uggia	Toscana	Pistoia	PT	14211
IT	51016	Montecatini Terme	Toscana	Pistoia	PT	14212
IT	51016	Nievole	Toscana	Pistoia	PT	14213
IT	51016	Montecatini Alto	Toscana	Pistoia	PT	14214
IT	51016	Montecatini Val Di Nievole	Toscana	Pistoia	PT	14215
IT	51017	San Quirico	Toscana	Pistoia	PT	14216
IT	51017	Vellano	Toscana	Pistoia	PT	14217
IT	51017	Pontito	Toscana	Pistoia	PT	14218
IT	51017	Pietrabuona	Toscana	Pistoia	PT	14219
IT	51017	Castelvecchio Di Vellano	Toscana	Pistoia	PT	14220
IT	51017	Castelvecchio	Toscana	Pistoia	PT	14221
IT	51017	Pescia	Toscana	Pistoia	PT	14222
IT	51017	San Quirico Valleriana	Toscana	Pistoia	PT	14223
IT	51018	Pieve A Nievole	Toscana	Pistoia	PT	14224
IT	51019	Anchione	Toscana	Pistoia	PT	14225
IT	51019	Ponte Buggianese	Toscana	Pistoia	PT	14226
IT	51020	Frassignoni	Toscana	Pistoia	PT	14227
IT	51020	San Pellegrino	Toscana	Pistoia	PT	14228
IT	51020	Treppio	Toscana	Pistoia	PT	14229
IT	51020	Torri	Toscana	Pistoia	PT	14230
IT	51020	Popiglio	Toscana	Pistoia	PT	14231
IT	51020	Calamecca	Toscana	Pistoia	PT	14232
IT	51020	Prunetta	Toscana	Pistoia	PT	14233
IT	51020	Castello	Toscana	Pistoia	PT	14234
IT	51020	Sambuca Pistoiese	Toscana	Pistoia	PT	14235
IT	51020	La Lima	Toscana	Pistoia	PT	14236
IT	51020	Crespole	Toscana	Pistoia	PT	14237
IT	51020	Prataccio	Toscana	Pistoia	PT	14238
IT	51020	Piteglio	Toscana	Pistoia	PT	14239
IT	51020	Collina	Toscana	Pistoia	PT	14240
IT	51020	Pavana	Toscana	Pistoia	PT	14241
IT	51020	San Pellegrino Al Cassero	Toscana	Pistoia	PT	14242
IT	51020	Pavana Pistoiese	Toscana	Pistoia	PT	14243
IT	51021	Le Regine	Toscana	Pistoia	PT	14244
IT	51021	Abetone	Toscana	Pistoia	PT	14245
IT	51024	Cutigliano	Toscana	Pistoia	PT	14246
IT	51024	Pian Degli Ontani	Toscana	Pistoia	PT	14247
IT	51024	Pianosinatico	Toscana	Pistoia	PT	14248
IT	51028	Limestre	Toscana	Pistoia	PT	14249
IT	51028	San Marcello Pistoiese	Toscana	Pistoia	PT	14250
IT	51028	Gavinana	Toscana	Pistoia	PT	14251
IT	51028	Maresca	Toscana	Pistoia	PT	14252
IT	51028	Pontepetri	Toscana	Pistoia	PT	14253
IT	51028	Campo Tizzoro	Toscana	Pistoia	PT	14254
IT	51028	Lizzano Pistoiese	Toscana	Pistoia	PT	14255
IT	51028	Mammiano	Toscana	Pistoia	PT	14256
IT	51028	Limestre Pistoiese	Toscana	Pistoia	PT	14257
IT	51028	Bardalone	Toscana	Pistoia	PT	14258
IT	51030	Montagnana Pistoiese	Toscana	Pistoia	PT	14259
IT	51031	Agliana	Toscana	Pistoia	PT	14260
IT	51031	San Michele	Toscana	Pistoia	PT	14261
IT	51031	San Piero	Toscana	Pistoia	PT	14262
IT	51034	Ponte Di Serravalle	Toscana	Pistoia	PT	14263
IT	51034	Serravalle Pistoiese	Toscana	Pistoia	PT	14264
IT	51034	Stazione Masotti	Toscana	Pistoia	PT	14265
IT	51034	Casalguidi	Toscana	Pistoia	PT	14266
IT	51035	San Baronto	Toscana	Pistoia	PT	14267
IT	51035	Lamporecchio	Toscana	Pistoia	PT	14268
IT	51035	Porciano	Toscana	Pistoia	PT	14269
IT	51035	Orbignano	Toscana	Pistoia	PT	14270
IT	51035	Mastromarco	Toscana	Pistoia	PT	14271
IT	51036	San Rocco	Toscana	Pistoia	PT	14272
IT	51036	Larciano	Toscana	Pistoia	PT	14273
IT	51036	Castelmartini	Toscana	Pistoia	PT	14274
IT	51037	Stazione Di Montale	Toscana	Pistoia	PT	14275
IT	51037	Montale	Toscana	Pistoia	PT	14276
IT	51037	Tobbiana	Toscana	Pistoia	PT	14277
IT	51037	Fognano	Toscana	Pistoia	PT	14278
IT	51037	Fognano Di Montale	Toscana	Pistoia	PT	14279
IT	51039	Santonuovo	Toscana	Pistoia	PT	14280
IT	51039	Montemagno Di Quarrata	Toscana	Pistoia	PT	14281
IT	51039	Montemagno	Toscana	Pistoia	PT	14282
IT	51039	Catena	Toscana	Pistoia	PT	14283
IT	51039	Tizzana	Toscana	Pistoia	PT	14284
IT	51039	Olmi	Toscana	Pistoia	PT	14285
IT	51039	Quarrata	Toscana	Pistoia	PT	14286
IT	51039	Ferruccia	Toscana	Pistoia	PT	14287
IT	51100	Villa Di Baggio	Toscana	Pistoia	PT	14288
IT	51100	Ponzano	Toscana	Pistoia	PT	14289
IT	51100	Corbezzi	Toscana	Pistoia	PT	14290
IT	51100	Le Grazie	Toscana	Pistoia	PT	14291
IT	51100	Villa Baggio	Toscana	Pistoia	PT	14292
IT	51100	Bottegone	Toscana	Pistoia	PT	14293
IT	51100	Saturnana	Toscana	Pistoia	PT	14294
IT	51100	Orsigna	Toscana	Pistoia	PT	14295
IT	51100	Pontelungo	Toscana	Pistoia	PT	14296
IT	51100	Grazie	Toscana	Pistoia	PT	14297
IT	51100	Pistoia	Toscana	Pistoia	PT	14298
IT	51100	Cireglio	Toscana	Pistoia	PT	14299
IT	51100	Sammomme'	Toscana	Pistoia	PT	14300
IT	51100	San Felice	Toscana	Pistoia	PT	14301
IT	51100	Capostrada	Toscana	Pistoia	PT	14302
IT	51100	Piazza	Toscana	Pistoia	PT	14303
IT	51100	Santomato	Toscana	Pistoia	PT	14304
IT	51100	Valdibrana	Toscana	Pistoia	PT	14305
IT	51100	Masiano	Toscana	Pistoia	PT	14306
IT	51100	Pracchia	Toscana	Pistoia	PT	14307
IT	51100	Chiazzano	Toscana	Pistoia	PT	14308
IT	51100	Piteccio	Toscana	Pistoia	PT	14309
IT	51100	Candeglia	Toscana	Pistoia	PT	14310
IT	51100	Piastre	Toscana	Pistoia	PT	14311
IT	53011	Fonterutoli	Toscana	Siena	SI	14312
IT	53011	Castellina In Chianti	Toscana	Siena	SI	14313
IT	53012	Chiusdino	Toscana	Siena	SI	14314
IT	53012	Ciciano	Toscana	Siena	SI	14315
IT	53012	Montalcinello	Toscana	Siena	SI	14316
IT	53012	Frosini	Toscana	Siena	SI	14317
IT	53013	Nusenna	Toscana	Siena	SI	14318
IT	53013	Lecchi	Toscana	Siena	SI	14319
IT	53013	Gaiole In Chianti	Toscana	Siena	SI	14320
IT	53013	Monti	Toscana	Siena	SI	14321
IT	53013	Ama	Toscana	Siena	SI	14322
IT	53013	Castagnoli	Toscana	Siena	SI	14323
IT	53014	Monteroni D'Arbia	Toscana	Siena	SI	14324
IT	53014	Ponte A Tressa	Toscana	Siena	SI	14325
IT	53014	Lucignano D'Arbia	Toscana	Siena	SI	14326
IT	53014	Ville Di Corsano	Toscana	Siena	SI	14327
IT	53014	Corsano	Toscana	Siena	SI	14328
IT	53014	Ponte D'Arbia	Toscana	Siena	SI	14329
IT	53015	San Lorenzo A Merse	Toscana	Siena	SI	14330
IT	53015	Scalvaia	Toscana	Siena	SI	14331
IT	53015	Monticiano	Toscana	Siena	SI	14332
IT	53015	Tocchi	Toscana	Siena	SI	14333
IT	53015	Iesa	Toscana	Siena	SI	14334
IT	53016	Murlo	Toscana	Siena	SI	14335
IT	53016	Casciano	Toscana	Siena	SI	14336
IT	53016	Vescovado	Toscana	Siena	SI	14337
IT	53017	Radda In Chianti	Toscana	Siena	SI	14338
IT	53017	Lucarelli	Toscana	Siena	SI	14339
IT	53018	Sovicille	Toscana	Siena	SI	14340
IT	53018	Rosia	Toscana	Siena	SI	14341
IT	53018	San Rocco A Pilli	Toscana	Siena	SI	14342
IT	53019	Pianella	Toscana	Siena	SI	14343
IT	53019	Monteaperti	Toscana	Siena	SI	14344
IT	53019	Castelnuovo Berardenga	Toscana	Siena	SI	14345
IT	53019	Quercegrossa	Toscana	Siena	SI	14346
IT	53019	Vagliagli	Toscana	Siena	SI	14347
IT	53019	Ponte A Bozzone	Toscana	Siena	SI	14348
IT	53019	Casetta	Toscana	Siena	SI	14349
IT	53019	San Gusme'	Toscana	Siena	SI	14350
IT	53020	Montisi	Toscana	Siena	SI	14351
IT	53020	San Giovanni D'Asso	Toscana	Siena	SI	14352
IT	53020	Castelmuzio	Toscana	Siena	SI	14353
IT	53020	Petroio	Toscana	Siena	SI	14354
IT	53020	Trequanda	Toscana	Siena	SI	14355
IT	53021	Abbadia San Salvatore	Toscana	Siena	SI	14356
IT	53022	Buonconvento	Toscana	Siena	SI	14357
IT	53023	Castiglione D'Orcia	Toscana	Siena	SI	14358
IT	53023	Bagni Di San Filippo	Toscana	Siena	SI	14359
IT	53023	Gallina	Toscana	Siena	SI	14360
IT	53023	Campiglia D'Orcia	Toscana	Siena	SI	14361
IT	53023	Vivo D'Orcia	Toscana	Siena	SI	14362
IT	53023	Bagni San Filippo	Toscana	Siena	SI	14363
IT	53024	Sant'Angelo In Colle	Toscana	Siena	SI	14364
IT	53024	Castelnuovo Dell'Abate	Toscana	Siena	SI	14365
IT	53024	Monte Amiata	Toscana	Siena	SI	14366
IT	53024	Montalcino	Toscana	Siena	SI	14367
IT	53024	Torrenieri	Toscana	Siena	SI	14368
IT	53025	Saragiolo	Toscana	Siena	SI	14369
IT	53025	Piancastagnaio	Toscana	Siena	SI	14370
IT	53026	Monticchiello	Toscana	Siena	SI	14371
IT	53026	Pienza	Toscana	Siena	SI	14372
IT	53027	Bagno Vignoni	Toscana	Siena	SI	14373
IT	53027	San Quirico D'Orcia	Toscana	Siena	SI	14374
IT	53030	Radicondoli	Toscana	Siena	SI	14375
IT	53030	Belforte	Toscana	Siena	SI	14376
IT	53030	Anqua	Toscana	Siena	SI	14377
IT	53030	Castel San Gimignano	Toscana	Siena	SI	14378
IT	53030	Castel San Giminiano	Toscana	Siena	SI	14379
IT	53031	Monteguidi	Toscana	Siena	SI	14380
IT	53031	Pievescola	Toscana	Siena	SI	14381
IT	53031	Casole D'Elsa	Toscana	Siena	SI	14382
IT	53034	Gracciano Di Colle Val D'Elsa	Toscana	Siena	SI	14383
IT	53034	Colle Di Val D'Elsa	Toscana	Siena	SI	14384
IT	53034	Quartaia	Toscana	Siena	SI	14385
IT	53034	Campiglia	Toscana	Siena	SI	14386
IT	53035	Tognazza	Toscana	Siena	SI	14387
IT	53035	Castellina Scalo	Toscana	Siena	SI	14388
IT	53035	San Martino	Toscana	Siena	SI	14389
IT	53035	Badesse	Toscana	Siena	SI	14390
IT	53035	Belverde	Toscana	Siena	SI	14391
IT	53035	Strove	Toscana	Siena	SI	14392
IT	53035	Uopini	Toscana	Siena	SI	14393
IT	53035	Monteriggioni	Toscana	Siena	SI	14394
IT	53035	Castellina In Chianti Stazione	Toscana	Siena	SI	14395
IT	53036	Bellavista	Toscana	Siena	SI	14396
IT	53036	Poggibonsi	Toscana	Siena	SI	14397
IT	53036	Staggia	Toscana	Siena	SI	14398
IT	53037	San Gimignano	Toscana	Siena	SI	14399
IT	53037	Ulignano	Toscana	Siena	SI	14400
IT	53037	Badia A Elmi	Toscana	Siena	SI	14401
IT	53040	Cetona	Toscana	Siena	SI	14402
IT	53040	Celle Sul Rigo	Toscana	Siena	SI	14403
IT	53040	Contignano	Toscana	Siena	SI	14404
IT	53040	San Casciano Dei Bagni	Toscana	Siena	SI	14405
IT	53040	Piazze	Toscana	Siena	SI	14406
IT	53040	Palazzone	Toscana	Siena	SI	14407
IT	53040	Rapolano Terme	Toscana	Siena	SI	14408
IT	53040	Radicofani	Toscana	Siena	SI	14409
IT	53040	Serre Di Rapolano	Toscana	Siena	SI	14410
IT	53041	Chiusure	Toscana	Siena	SI	14411
IT	53041	Asciano	Toscana	Siena	SI	14412
IT	53041	Arbia	Toscana	Siena	SI	14413
IT	53041	Monte Oliveto Maggiore	Toscana	Siena	SI	14414
IT	53041	Monte Sante Marie	Toscana	Siena	SI	14415
IT	53042	Chianciano Terme	Toscana	Siena	SI	14416
IT	53043	Chiusi	Toscana	Siena	SI	14417
IT	53043	Chiusi Scalo	Toscana	Siena	SI	14418
IT	53043	Chiusi Stazione	Toscana	Siena	SI	14419
IT	53043	Montallese	Toscana	Siena	SI	14420
IT	53045	Acquaviva	Toscana	Siena	SI	14421
IT	53045	Sant'Albino	Toscana	Siena	SI	14422
IT	53045	Montepulciano Stazione	Toscana	Siena	SI	14423
IT	53045	Montepulciano	Toscana	Siena	SI	14424
IT	53045	Abbadia Di Montepulciano	Toscana	Siena	SI	14425
IT	53045	Abbadia	Toscana	Siena	SI	14426
IT	53045	Valiano	Toscana	Siena	SI	14427
IT	53045	Gracciano	Toscana	Siena	SI	14428
IT	53047	Sarteano	Toscana	Siena	SI	14429
IT	53048	Bettolle	Toscana	Siena	SI	14430
IT	53048	Rigomagno	Toscana	Siena	SI	14431
IT	53048	Sinalunga	Toscana	Siena	SI	14432
IT	53048	Scrofiano	Toscana	Siena	SI	14433
IT	53048	Rigaiolo	Toscana	Siena	SI	14434
IT	53048	Guazzino	Toscana	Siena	SI	14435
IT	53048	Pieve Di Sinalunga	Toscana	Siena	SI	14436
IT	53049	Torrita Stazione	Toscana	Siena	SI	14437
IT	53049	Torrita Di Siena	Toscana	Siena	SI	14438
IT	53049	Montefollonico	Toscana	Siena	SI	14439
IT	53100	Sant'Andrea A Montecchio	Toscana	Siena	SI	14440
IT	53100	Costalpino	Toscana	Siena	SI	14441
IT	53100	Coroncina	Toscana	Siena	SI	14442
IT	53100	Isola D'Arbia	Toscana	Siena	SI	14443
IT	53100	Taverne D'Arbia	Toscana	Siena	SI	14444
IT	53100	Siena	Toscana	Siena	SI	14445
IT	53100	Malafrasca	Toscana	Siena	SI	14446
IT	53100	Ponte Al Bozzone	Toscana	Siena	SI	14447
IT	39010	Prissiano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14448
IT	39010	St. Pankraz	Trentino-Alto Adige	Bolzano-Bozen	BZ	14449
IT	39010	Gargazon	Trentino-Alto Adige	Bolzano-Bozen	BZ	14450
IT	39010	Andrian	Trentino-Alto Adige	Bolzano-Bozen	BZ	14451
IT	39010	San Martino In Passiria	Trentino-Alto Adige	Bolzano-Bozen	BZ	14452
IT	39010	Hafling	Trentino-Alto Adige	Bolzano-Bozen	BZ	14453
IT	39010	Rifiano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14454
IT	39010	San Pancrazio	Trentino-Alto Adige	Bolzano-Bozen	BZ	14455
IT	39010	Gargazzone	Trentino-Alto Adige	Bolzano-Bozen	BZ	14456
IT	39010	Walten	Trentino-Alto Adige	Bolzano-Bozen	BZ	14457
IT	39010	St. Martin in Passeier	Trentino-Alto Adige	Bolzano-Bozen	BZ	14458
IT	39010	Senale	Trentino-Alto Adige	Bolzano-Bozen	BZ	14459
IT	39010	Cermes	Trentino-Alto Adige	Bolzano-Bozen	BZ	14460
IT	39010	Nals	Trentino-Alto Adige	Bolzano-Bozen	BZ	14461
IT	39010	Sant'Orsola In Passiria	Trentino-Alto Adige	Bolzano-Bozen	BZ	14462
IT	39010	Unsere liebe Frau i. W.	Trentino-Alto Adige	Bolzano-Bozen	BZ	14463
IT	39010	Caines	Trentino-Alto Adige	Bolzano-Bozen	BZ	14464
IT	39010	Andriano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14465
IT	39010	Frangart	Trentino-Alto Adige	Bolzano-Bozen	BZ	14466
IT	39010	Avelengo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14467
IT	39010	Tscherms	Trentino-Alto Adige	Bolzano-Bozen	BZ	14468
IT	39010	Tisens	Trentino-Alto Adige	Bolzano-Bozen	BZ	14469
IT	39010	Meltina	Trentino-Alto Adige	Bolzano-Bozen	BZ	14470
IT	39010	Verano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14471
IT	39010	Unsere Liebe Frau Im Wald	Trentino-Alto Adige	Bolzano-Bozen	BZ	14472
IT	39010	Mölten	Trentino-Alto Adige	Bolzano-Bozen	BZ	14473
IT	39010	Saltusio	Trentino-Alto Adige	Bolzano-Bozen	BZ	14474
IT	39010	Nalles	Trentino-Alto Adige	Bolzano-Bozen	BZ	14475
IT	39010	Vöran	Trentino-Alto Adige	Bolzano-Bozen	BZ	14476
IT	39010	Gfeis	Trentino-Alto Adige	Bolzano-Bozen	BZ	14477
IT	39010	Saltaus	Trentino-Alto Adige	Bolzano-Bozen	BZ	14478
IT	39010	Tesimo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14479
IT	39010	Prissia	Trentino-Alto Adige	Bolzano-Bozen	BZ	14480
IT	39010	Sinich	Trentino-Alto Adige	Bolzano-Bozen	BZ	14481
IT	39010	San Felice Val Di Non	Trentino-Alto Adige	Bolzano-Bozen	BZ	14482
IT	39010	Pawigl	Trentino-Alto Adige	Bolzano-Bozen	BZ	14483
IT	39010	Senale San Felice	Trentino-Alto Adige	Bolzano-Bozen	BZ	14484
IT	39010	Riffian	Trentino-Alto Adige	Bolzano-Bozen	BZ	14485
IT	39010	Sigmundskron	Trentino-Alto Adige	Bolzano-Bozen	BZ	14486
IT	39010	Grissian	Trentino-Alto Adige	Bolzano-Bozen	BZ	14487
IT	39010	Schlaneid	Trentino-Alto Adige	Bolzano-Bozen	BZ	14488
IT	39010	Pfelders	Trentino-Alto Adige	Bolzano-Bozen	BZ	14489
IT	39010	St. Nikolaus/Ulten	Trentino-Alto Adige	Bolzano-Bozen	BZ	14490
IT	39010	St. Gertraud	Trentino-Alto Adige	Bolzano-Bozen	BZ	14491
IT	39010	St. Felix	Trentino-Alto Adige	Bolzano-Bozen	BZ	14492
IT	39010	Gfrill	Trentino-Alto Adige	Bolzano-Bozen	BZ	14493
IT	39010	Vilpian	Trentino-Alto Adige	Bolzano-Bozen	BZ	14494
IT	39010	St. Helena	Trentino-Alto Adige	Bolzano-Bozen	BZ	14495
IT	39010	Platzers	Trentino-Alto Adige	Bolzano-Bozen	BZ	14496
IT	39010	Vernue	Trentino-Alto Adige	Bolzano-Bozen	BZ	14497
IT	39010	Kuens	Trentino-Alto Adige	Bolzano-Bozen	BZ	14498
IT	39010	Verschneid	Trentino-Alto Adige	Bolzano-Bozen	BZ	14499
IT	39010	San Felice	Trentino-Alto Adige	Bolzano-Bozen	BZ	14500
IT	39011	Pavicolo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14501
IT	39011	Lana	Trentino-Alto Adige	Bolzano-Bozen	BZ	14502
IT	39011	Monte San Vigilio	Trentino-Alto Adige	Bolzano-Bozen	BZ	14503
IT	39011	Völlan	Trentino-Alto Adige	Bolzano-Bozen	BZ	14504
IT	39011	Vigiljoc	Trentino-Alto Adige	Bolzano-Bozen	BZ	14505
IT	39011	Pawig	Trentino-Alto Adige	Bolzano-Bozen	BZ	14506
IT	39012	Meran	Trentino-Alto Adige	Bolzano-Bozen	BZ	14507
IT	39012	Untermais	Trentino-Alto Adige	Bolzano-Bozen	BZ	14508
IT	39012	Sinigo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14509
IT	39012	Gratsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14510
IT	39012	Merano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14511
IT	39012	Meran Sinic	Trentino-Alto Adige	Bolzano-Bozen	BZ	14512
IT	39012	Obermais	Trentino-Alto Adige	Bolzano-Bozen	BZ	14513
IT	39012	Sinic	Trentino-Alto Adige	Bolzano-Bozen	BZ	14514
IT	39012	Borgo Vittoria	Trentino-Alto Adige	Bolzano-Bozen	BZ	14515
IT	39013	Stuls	Trentino-Alto Adige	Bolzano-Bozen	BZ	14516
IT	39013	Platt	Trentino-Alto Adige	Bolzano-Bozen	BZ	14517
IT	39013	Moso In Passiria	Trentino-Alto Adige	Bolzano-Bozen	BZ	14518
IT	39013	Ulfas	Trentino-Alto Adige	Bolzano-Bozen	BZ	14519
IT	39013	Moos	Trentino-Alto Adige	Bolzano-Bozen	BZ	14520
IT	39013	Rabenstein	Trentino-Alto Adige	Bolzano-Bozen	BZ	14521
IT	39013	Pfelder	Trentino-Alto Adige	Bolzano-Bozen	BZ	14522
IT	39013	Plan In Passiria	Trentino-Alto Adige	Bolzano-Bozen	BZ	14523
IT	39014	Postal	Trentino-Alto Adige	Bolzano-Bozen	BZ	14524
IT	39014	Burgstall	Trentino-Alto Adige	Bolzano-Bozen	BZ	14525
IT	39015	Valtina	Trentino-Alto Adige	Bolzano-Bozen	BZ	14526
IT	39015	Windegg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14527
IT	39015	Schweinsteg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14528
IT	39015	St. Leonhard in Pass.	Trentino-Alto Adige	Bolzano-Bozen	BZ	14529
IT	39015	San Leonardo In Passiria	Trentino-Alto Adige	Bolzano-Bozen	BZ	14530
IT	39015	Walte	Trentino-Alto Adige	Bolzano-Bozen	BZ	14531
IT	39015	Sant'Orsola	Trentino-Alto Adige	Bolzano-Bozen	BZ	14532
IT	39016	Santa Gertrude	Trentino-Alto Adige	Bolzano-Bozen	BZ	14533
IT	39016	St. Moritz/Ulten	Trentino-Alto Adige	Bolzano-Bozen	BZ	14534
IT	39016	San Nicolo'	Trentino-Alto Adige	Bolzano-Bozen	BZ	14535
IT	39016	Santa Geltrude In Ultimo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14536
IT	39016	St. Walburg/Ulten	Trentino-Alto Adige	Bolzano-Bozen	BZ	14537
IT	39016	Kuppelwies	Trentino-Alto Adige	Bolzano-Bozen	BZ	14538
IT	39016	Ultimo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14539
IT	39016	St.Nikolau	Trentino-Alto Adige	Bolzano-Bozen	BZ	14540
IT	39016	Santa Valburga	Trentino-Alto Adige	Bolzano-Bozen	BZ	14541
IT	39016	San Nicolo' Ultimo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14542
IT	39016	Santa Valburga Ultimo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14543
IT	39016	St.Walburg Ulte	Trentino-Alto Adige	Bolzano-Bozen	BZ	14544
IT	39017	Videgg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14545
IT	39017	Scena	Trentino-Alto Adige	Bolzano-Bozen	BZ	14546
IT	39017	Tall	Trentino-Alto Adige	Bolzano-Bozen	BZ	14547
IT	39017	Verdins	Trentino-Alto Adige	Bolzano-Bozen	BZ	14548
IT	39017	Schenna	Trentino-Alto Adige	Bolzano-Bozen	BZ	14549
IT	39018	Terlano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14550
IT	39018	Vilpiano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14551
IT	39018	Settequerce	Trentino-Alto Adige	Bolzano-Bozen	BZ	14552
IT	39018	Terlan	Trentino-Alto Adige	Bolzano-Bozen	BZ	14553
IT	39018	Siebeneich	Trentino-Alto Adige	Bolzano-Bozen	BZ	14554
IT	39018	Vilpia	Trentino-Alto Adige	Bolzano-Bozen	BZ	14555
IT	39019	Tirolo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14556
IT	39019	Tirol	Trentino-Alto Adige	Bolzano-Bozen	BZ	14557
IT	39020	Schluderns	Trentino-Alto Adige	Bolzano-Bozen	BZ	14558
IT	39020	Pedroß	Trentino-Alto Adige	Bolzano-Bozen	BZ	14559
IT	39020	Morter	Trentino-Alto Adige	Bolzano-Bozen	BZ	14560
IT	39020	Tschengls	Trentino-Alto Adige	Bolzano-Bozen	BZ	14561
IT	39020	Montefranco	Trentino-Alto Adige	Bolzano-Bozen	BZ	14562
IT	39020	Rabla'	Trentino-Alto Adige	Bolzano-Bozen	BZ	14563
IT	39020	Vernagt	Trentino-Alto Adige	Bolzano-Bozen	BZ	14564
IT	39020	Glorenza	Trentino-Alto Adige	Bolzano-Bozen	BZ	14565
IT	39020	Sluderno	Trentino-Alto Adige	Bolzano-Bozen	BZ	14566
IT	39020	Martell	Trentino-Alto Adige	Bolzano-Bozen	BZ	14567
IT	39020	Lichtenberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14568
IT	39020	Rabland	Trentino-Alto Adige	Bolzano-Bozen	BZ	14569
IT	39020	Marling	Trentino-Alto Adige	Bolzano-Bozen	BZ	14570
IT	39020	Glurns	Trentino-Alto Adige	Bolzano-Bozen	BZ	14571
IT	39020	Trafoi	Trentino-Alto Adige	Bolzano-Bozen	BZ	14572
IT	39020	Partschins	Trentino-Alto Adige	Bolzano-Bozen	BZ	14573
IT	39020	Gand/Martell	Trentino-Alto Adige	Bolzano-Bozen	BZ	14574
IT	39020	Gomagoi	Trentino-Alto Adige	Bolzano-Bozen	BZ	14575
IT	39020	Marlengo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14576
IT	39020	Hinterkirch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14577
IT	39020	Santa Caterina	Trentino-Alto Adige	Bolzano-Bozen	BZ	14578
IT	39020	Parcines	Trentino-Alto Adige	Bolzano-Bozen	BZ	14579
IT	39020	Senales	Trentino-Alto Adige	Bolzano-Bozen	BZ	14580
IT	39020	Rifair	Trentino-Alto Adige	Bolzano-Bozen	BZ	14581
IT	39020	Montefranco In Venosta	Trentino-Alto Adige	Bolzano-Bozen	BZ	14582
IT	39020	Tanas	Trentino-Alto Adige	Bolzano-Bozen	BZ	14583
IT	39020	Madonna	Trentino-Alto Adige	Bolzano-Bozen	BZ	14584
IT	39020	Stilfs	Trentino-Alto Adige	Bolzano-Bozen	BZ	14585
IT	39020	Goldrain	Trentino-Alto Adige	Bolzano-Bozen	BZ	14586
IT	39020	Castelbello	Trentino-Alto Adige	Bolzano-Bozen	BZ	14587
IT	39020	Martello	Trentino-Alto Adige	Bolzano-Bozen	BZ	14588
IT	39020	Tarsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14589
IT	39020	Marein	Trentino-Alto Adige	Bolzano-Bozen	BZ	14590
IT	39020	Tubre	Trentino-Alto Adige	Bolzano-Bozen	BZ	14591
IT	39020	Unser Fra	Trentino-Alto Adige	Bolzano-Bozen	BZ	14592
IT	39020	Ciardes	Trentino-Alto Adige	Bolzano-Bozen	BZ	14593
IT	39020	Karthaus	Trentino-Alto Adige	Bolzano-Bozen	BZ	14594
IT	39020	Tol	Trentino-Alto Adige	Bolzano-Bozen	BZ	14595
IT	39020	Tel	Trentino-Alto Adige	Bolzano-Bozen	BZ	14596
IT	39020	Castelbello Ciardes	Trentino-Alto Adige	Bolzano-Bozen	BZ	14597
IT	39020	Eyrs	Trentino-Alto Adige	Bolzano-Bozen	BZ	14598
IT	39020	Kastelbell	Trentino-Alto Adige	Bolzano-Bozen	BZ	14599
IT	39020	Staben	Trentino-Alto Adige	Bolzano-Bozen	BZ	14600
IT	39020	Katharinaberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14601
IT	39020	Taufers i. Münstertal	Trentino-Alto Adige	Bolzano-Bozen	BZ	14602
IT	39020	Tschars	Trentino-Alto Adige	Bolzano-Bozen	BZ	14603
IT	39020	Plawenn	Trentino-Alto Adige	Bolzano-Bozen	BZ	14604
IT	39020	Freiberg Vinschga	Trentino-Alto Adige	Bolzano-Bozen	BZ	14605
IT	39020	Töll	Trentino-Alto Adige	Bolzano-Bozen	BZ	14606
IT	39020	Gries	Trentino-Alto Adige	Bolzano-Bozen	BZ	14607
IT	39020	Melag	Trentino-Alto Adige	Bolzano-Bozen	BZ	14608
IT	39020	Planeil	Trentino-Alto Adige	Bolzano-Bozen	BZ	14609
IT	39020	St. Valentin a. d. H.	Trentino-Alto Adige	Bolzano-Bozen	BZ	14610
IT	39020	Laatsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14611
IT	39020	Graun/Vinschg.	Trentino-Alto Adige	Bolzano-Bozen	BZ	14612
IT	39020	Matsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14613
IT	39020	Tabland	Trentino-Alto Adige	Bolzano-Bozen	BZ	14614
IT	39020	Unsere Frau i. Schnals	Trentino-Alto Adige	Bolzano-Bozen	BZ	14615
IT	39020	Freiberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14616
IT	39020	Tartsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14617
IT	39021	Tarres	Trentino-Alto Adige	Bolzano-Bozen	BZ	14618
IT	39021	Coldrano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14619
IT	39021	Latsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14620
IT	39021	Morter	Trentino-Alto Adige	Bolzano-Bozen	BZ	14621
IT	39021	Morte	Trentino-Alto Adige	Bolzano-Bozen	BZ	14622
IT	39021	Laces	Trentino-Alto Adige	Bolzano-Bozen	BZ	14623
IT	39021	St. Martin am Kofl	Trentino-Alto Adige	Bolzano-Bozen	BZ	14624
IT	39021	Tarsc	Trentino-Alto Adige	Bolzano-Bozen	BZ	14625
IT	39021	Goldrai	Trentino-Alto Adige	Bolzano-Bozen	BZ	14626
IT	39022	Algund	Trentino-Alto Adige	Bolzano-Bozen	BZ	14627
IT	39022	Vellau	Trentino-Alto Adige	Bolzano-Bozen	BZ	14628
IT	39022	Plars	Trentino-Alto Adige	Bolzano-Bozen	BZ	14629
IT	39022	Lagundo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14630
IT	39022	Oberplars	Trentino-Alto Adige	Bolzano-Bozen	BZ	14631
IT	39022	Aschbach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14632
IT	39023	Tschengel	Trentino-Alto Adige	Bolzano-Bozen	BZ	14633
IT	39023	Allitz	Trentino-Alto Adige	Bolzano-Bozen	BZ	14634
IT	39023	Lasa	Trentino-Alto Adige	Bolzano-Bozen	BZ	14635
IT	39023	Tana	Trentino-Alto Adige	Bolzano-Bozen	BZ	14636
IT	39023	Oris	Trentino-Alto Adige	Bolzano-Bozen	BZ	14637
IT	39023	Eyr	Trentino-Alto Adige	Bolzano-Bozen	BZ	14638
IT	39023	Cengles	Trentino-Alto Adige	Bolzano-Bozen	BZ	14639
IT	39023	Laas	Trentino-Alto Adige	Bolzano-Bozen	BZ	14640
IT	39023	Tanas	Trentino-Alto Adige	Bolzano-Bozen	BZ	14641
IT	39023	Tarnell	Trentino-Alto Adige	Bolzano-Bozen	BZ	14642
IT	39024	Laatsc	Trentino-Alto Adige	Bolzano-Bozen	BZ	14643
IT	39024	Burgusio	Trentino-Alto Adige	Bolzano-Bozen	BZ	14644
IT	39024	Tartsc	Trentino-Alto Adige	Bolzano-Bozen	BZ	14645
IT	39024	Schlinig	Trentino-Alto Adige	Bolzano-Bozen	BZ	14646
IT	39024	Planei	Trentino-Alto Adige	Bolzano-Bozen	BZ	14647
IT	39024	Marienberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14648
IT	39024	Matsc	Trentino-Alto Adige	Bolzano-Bozen	BZ	14649
IT	39024	Burgeis	Trentino-Alto Adige	Bolzano-Bozen	BZ	14650
IT	39024	Malles Venosta	Trentino-Alto Adige	Bolzano-Bozen	BZ	14651
IT	39024	Planol	Trentino-Alto Adige	Bolzano-Bozen	BZ	14652
IT	39024	Mals	Trentino-Alto Adige	Bolzano-Bozen	BZ	14653
IT	39024	Schleis	Trentino-Alto Adige	Bolzano-Bozen	BZ	14654
IT	39024	Laudes	Trentino-Alto Adige	Bolzano-Bozen	BZ	14655
IT	39024	Tarces	Trentino-Alto Adige	Bolzano-Bozen	BZ	14656
IT	39024	Mazia	Trentino-Alto Adige	Bolzano-Bozen	BZ	14657
IT	39025	Plaus	Trentino-Alto Adige	Bolzano-Bozen	BZ	14658
IT	39025	Naturns	Trentino-Alto Adige	Bolzano-Bozen	BZ	14659
IT	39025	Stava	Trentino-Alto Adige	Bolzano-Bozen	BZ	14660
IT	39025	Naturno	Trentino-Alto Adige	Bolzano-Bozen	BZ	14661
IT	39025	Stabe	Trentino-Alto Adige	Bolzano-Bozen	BZ	14662
IT	39026	Montechiaro	Trentino-Alto Adige	Bolzano-Bozen	BZ	14663
IT	39026	Prato Allo Stelvio	Trentino-Alto Adige	Bolzano-Bozen	BZ	14664
IT	39026	Agums	Trentino-Alto Adige	Bolzano-Bozen	BZ	14665
IT	39026	Prad	Trentino-Alto Adige	Bolzano-Bozen	BZ	14666
IT	39026	Lichtenber	Trentino-Alto Adige	Bolzano-Bozen	BZ	14667
IT	39027	San Valentino Alla Muta	Trentino-Alto Adige	Bolzano-Bozen	BZ	14668
IT	39027	Curon Venosta	Trentino-Alto Adige	Bolzano-Bozen	BZ	14669
IT	39027	Resia	Trentino-Alto Adige	Bolzano-Bozen	BZ	14670
IT	39027	Reschen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14671
IT	39028	Schlanders	Trentino-Alto Adige	Bolzano-Bozen	BZ	14672
IT	39028	Covelano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14673
IT	39028	Silandro	Trentino-Alto Adige	Bolzano-Bozen	BZ	14674
IT	39028	Vezzano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14675
IT	39028	Kortsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14676
IT	39028	Goefla	Trentino-Alto Adige	Bolzano-Bozen	BZ	14677
IT	39028	Göflan	Trentino-Alto Adige	Bolzano-Bozen	BZ	14678
IT	39028	Vezzan	Trentino-Alto Adige	Bolzano-Bozen	BZ	14679
IT	39028	Talatsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14680
IT	39029	Stelvio	Trentino-Alto Adige	Bolzano-Bozen	BZ	14681
IT	39029	Solda	Trentino-Alto Adige	Bolzano-Bozen	BZ	14682
IT	39029	Gomagoi	Trentino-Alto Adige	Bolzano-Bozen	BZ	14683
IT	39029	Trafoi	Trentino-Alto Adige	Bolzano-Bozen	BZ	14684
IT	39029	Trafo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14685
IT	39029	Sulden	Trentino-Alto Adige	Bolzano-Bozen	BZ	14686
IT	39029	Gomago	Trentino-Alto Adige	Bolzano-Bozen	BZ	14687
IT	39030	Luttach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14688
IT	39030	Santa Maddalena	Trentino-Alto Adige	Bolzano-Bozen	BZ	14689
IT	39030	Rodeneck	Trentino-Alto Adige	Bolzano-Bozen	BZ	14690
IT	39030	San Martino In Casies	Trentino-Alto Adige	Bolzano-Bozen	BZ	14691
IT	39030	Lutago	Trentino-Alto Adige	Bolzano-Bozen	BZ	14692
IT	39030	Valdaora Di Sotto	Trentino-Alto Adige	Bolzano-Bozen	BZ	14693
IT	39030	Margen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14694
IT	39030	Platten	Trentino-Alto Adige	Bolzano-Bozen	BZ	14695
IT	39030	Pichl	Trentino-Alto Adige	Bolzano-Bozen	BZ	14696
IT	39030	Anterselva Di Mezzo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14697
IT	39030	Terento	Trentino-Alto Adige	Bolzano-Bozen	BZ	14698
IT	39030	Hofern	Trentino-Alto Adige	Bolzano-Bozen	BZ	14699
IT	39030	Tesselberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14700
IT	39030	Antholz	Trentino-Alto Adige	Bolzano-Bozen	BZ	14701
IT	39030	Terenten	Trentino-Alto Adige	Bolzano-Bozen	BZ	14702
IT	39030	St. Lorenzen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14703
IT	39030	Rasun Di Sopra	Trentino-Alto Adige	Bolzano-Bozen	BZ	14704
IT	39030	Braies	Trentino-Alto Adige	Bolzano-Bozen	BZ	14705
IT	39030	San Sigismondo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14706
IT	6019	Calzolaro	Umbria	Perugia	PG	14707
IT	39030	San Vigilio	Trentino-Alto Adige	Bolzano-Bozen	BZ	14708
IT	39030	St. Sigmund	Trentino-Alto Adige	Bolzano-Bozen	BZ	14709
IT	39030	Vandoies Di Sopra	Trentino-Alto Adige	Bolzano-Bozen	BZ	14710
IT	39030	Cadipietra	Trentino-Alto Adige	Bolzano-Bozen	BZ	14711
IT	39030	San Lorenzo Di Sebato	Trentino-Alto Adige	Bolzano-Bozen	BZ	14712
IT	39030	Longega	Trentino-Alto Adige	Bolzano-Bozen	BZ	14713
IT	39030	Piccolino	Trentino-Alto Adige	Bolzano-Bozen	BZ	14714
IT	39030	Prags	Trentino-Alto Adige	Bolzano-Bozen	BZ	14715
IT	39030	Lappach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14716
IT	39030	Gais	Trentino-Alto Adige	Bolzano-Bozen	BZ	14717
IT	39030	San Martino In Badia	Trentino-Alto Adige	Bolzano-Bozen	BZ	14718
IT	39030	Welschellen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14719
IT	39030	Perca	Trentino-Alto Adige	Bolzano-Bozen	BZ	14720
IT	39030	Pfunders	Trentino-Alto Adige	Bolzano-Bozen	BZ	14721
IT	39030	Vallarga	Trentino-Alto Adige	Bolzano-Bozen	BZ	14722
IT	39030	Valdaora Di Mezzo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14723
IT	39030	Selva Dei Molini	Trentino-Alto Adige	Bolzano-Bozen	BZ	14724
IT	39030	Uttenheim	Trentino-Alto Adige	Bolzano-Bozen	BZ	14725
IT	39030	Marebbe	Trentino-Alto Adige	Bolzano-Bozen	BZ	14726
IT	39030	Olang	Trentino-Alto Adige	Bolzano-Bozen	BZ	14727
IT	39030	Percha	Trentino-Alto Adige	Bolzano-Bozen	BZ	14728
IT	39030	St.Vigi	Trentino-Alto Adige	Bolzano-Bozen	BZ	14729
IT	39030	St. Martin in Thurn/S. Martin de Tor	Trentino-Alto Adige	Bolzano-Bozen	BZ	14730
IT	39030	Valdaora	Trentino-Alto Adige	Bolzano-Bozen	BZ	14731
IT	39030	Mühlwald	Trentino-Alto Adige	Bolzano-Bozen	BZ	14732
IT	39030	Fundres	Trentino-Alto Adige	Bolzano-Bozen	BZ	14733
IT	39030	St.Jakob In Ahrnta	Trentino-Alto Adige	Bolzano-Bozen	BZ	14734
IT	39030	Sexten	Trentino-Alto Adige	Bolzano-Bozen	BZ	14735
IT	39030	Unterplanken	Trentino-Alto Adige	Bolzano-Bozen	BZ	14736
IT	39030	Villa Ottone	Trentino-Alto Adige	Bolzano-Bozen	BZ	14737
IT	39030	Montal	Trentino-Alto Adige	Bolzano-Bozen	BZ	14738
IT	39030	Sesto	Trentino-Alto Adige	Bolzano-Bozen	BZ	14739
IT	39030	Niedervintl	Trentino-Alto Adige	Bolzano-Bozen	BZ	14740
IT	39030	Weißenbach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14741
IT	39030	Predoi	Trentino-Alto Adige	Bolzano-Bozen	BZ	14742
IT	39030	Casteldarne	Trentino-Alto Adige	Bolzano-Bozen	BZ	14743
IT	39030	San Giacomo In Valle Aurina	Trentino-Alto Adige	Bolzano-Bozen	BZ	14744
IT	39030	Rein	Trentino-Alto Adige	Bolzano-Bozen	BZ	14745
IT	39030	Vandoies Di Sotto	Trentino-Alto Adige	Bolzano-Bozen	BZ	14746
IT	39030	Kiens	Trentino-Alto Adige	Bolzano-Bozen	BZ	14747
IT	39030	Prettau	Trentino-Alto Adige	Bolzano-Bozen	BZ	14748
IT	39030	San Giuseppe	Trentino-Alto Adige	Bolzano-Bozen	BZ	14749
IT	39030	Ahornach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14750
IT	39030	Ehrenburg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14751
IT	39030	Longiaru'	Trentino-Alto Adige	Bolzano-Bozen	BZ	14752
IT	39030	Falzes	Trentino-Alto Adige	Bolzano-Bozen	BZ	14753
IT	39030	Wielenberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14754
IT	39030	Rasun Di Sotto	Trentino-Alto Adige	Bolzano-Bozen	BZ	14755
IT	39030	St.Johann In Ahrnta	Trentino-Alto Adige	Bolzano-Bozen	BZ	14756
IT	39030	Chienes	Trentino-Alto Adige	Bolzano-Bozen	BZ	14757
IT	39030	St. Vigil i. Enneberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14758
IT	39030	Pfalzen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14759
IT	39030	San Giovanni In Valle Aurina	Trentino-Alto Adige	Bolzano-Bozen	BZ	14760
IT	39030	Nasen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14761
IT	39030	Obervintl	Trentino-Alto Adige	Bolzano-Bozen	BZ	14762
IT	39030	Ahrntal	Trentino-Alto Adige	Bolzano-Bozen	BZ	14763
IT	39030	Valle Aurina	Trentino-Alto Adige	Bolzano-Bozen	BZ	14764
IT	39030	Onach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14765
IT	39030	Steinhaus	Trentino-Alto Adige	Bolzano-Bozen	BZ	14766
IT	39030	Wengen/La Val	Trentino-Alto Adige	Bolzano-Bozen	BZ	14767
IT	39030	Mitterolang	Trentino-Alto Adige	Bolzano-Bozen	BZ	14768
IT	39030	St. Magdalena i. G.	Trentino-Alto Adige	Bolzano-Bozen	BZ	14769
IT	39030	Valle Di Casies	Trentino-Alto Adige	Bolzano-Bozen	BZ	14770
IT	39030	Ellen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14771
IT	39030	Zwischenwasser	Trentino-Alto Adige	Bolzano-Bozen	BZ	14772
IT	39030	St. Martin in Gsies	Trentino-Alto Adige	Bolzano-Bozen	BZ	14773
IT	39030	La Valle	Trentino-Alto Adige	Bolzano-Bozen	BZ	14774
IT	39030	Kampill	Trentino-Alto Adige	Bolzano-Bozen	BZ	14775
IT	39030	Pikolein	Trentino-Alto Adige	Bolzano-Bozen	BZ	14776
IT	39030	Greinwalden	Trentino-Alto Adige	Bolzano-Bozen	BZ	14777
IT	39030	St.Magdalen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14778
IT	39030	Oberolang	Trentino-Alto Adige	Bolzano-Bozen	BZ	14779
IT	39030	Niederolang	Trentino-Alto Adige	Bolzano-Bozen	BZ	14780
IT	39030	Mühlbach b. Gais	Trentino-Alto Adige	Bolzano-Bozen	BZ	14781
IT	39030	St. Kassia	Trentino-Alto Adige	Bolzano-Bozen	BZ	14782
IT	39030	Issing	Trentino-Alto Adige	Bolzano-Bozen	BZ	14783
IT	39030	Pederoa	Trentino-Alto Adige	Bolzano-Bozen	BZ	14784
IT	39030	St. Jakob in Ahrn	Trentino-Alto Adige	Bolzano-Bozen	BZ	14785
IT	39030	Pedero	Trentino-Alto Adige	Bolzano-Bozen	BZ	14786
IT	39030	Mühlen/Pfalzen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14787
IT	39030	Weitental	Trentino-Alto Adige	Bolzano-Bozen	BZ	14788
IT	39030	Saalen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14789
IT	39030	Moo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14790
IT	39030	Vintl	Trentino-Alto Adige	Bolzano-Bozen	BZ	14791
IT	39030	St.Sigmun	Trentino-Alto Adige	Bolzano-Bozen	BZ	14792
IT	39030	Untergsies	Trentino-Alto Adige	Bolzano-Bozen	BZ	14793
IT	39030	St.Martin Gsie	Trentino-Alto Adige	Bolzano-Bozen	BZ	14794
IT	39030	Stefansdorf	Trentino-Alto Adige	Bolzano-Bozen	BZ	14795
IT	39030	Rasun Anterselva	Trentino-Alto Adige	Bolzano-Bozen	BZ	14796
IT	39030	Oberwielenbach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14797
IT	39030	Campil	Trentino-Alto Adige	Bolzano-Bozen	BZ	14798
IT	6019	Niccone	Umbria	Perugia	PG	14799
IT	39030	Pflaurenz	Trentino-Alto Adige	Bolzano-Bozen	BZ	14800
IT	39030	Oberrasen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14801
IT	39030	St. Veit in Prags	Trentino-Alto Adige	Bolzano-Bozen	BZ	14802
IT	39030	Vandoies	Trentino-Alto Adige	Bolzano-Bozen	BZ	14803
IT	39030	St. Walburg i. Antholz	Trentino-Alto Adige	Bolzano-Bozen	BZ	14804
IT	39030	Niederrasen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14805
IT	39030	Enneberg/Mareo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14806
IT	39030	St. Johann in Ahrn	Trentino-Alto Adige	Bolzano-Bozen	BZ	14807
IT	39030	Kolfuschg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14808
IT	39030	Untermoi	Trentino-Alto Adige	Bolzano-Bozen	BZ	14809
IT	39030	Untervintl	Trentino-Alto Adige	Bolzano-Bozen	BZ	14810
IT	39030	Kurfar	Trentino-Alto Adige	Bolzano-Bozen	BZ	14811
IT	39030	Geiselsberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14812
IT	39030	Kasern	Trentino-Alto Adige	Bolzano-Bozen	BZ	14813
IT	39030	St. Peter in Ahrn	Trentino-Alto Adige	Bolzano-Bozen	BZ	14814
IT	39031	Luns	Trentino-Alto Adige	Bolzano-Bozen	BZ	14815
IT	39031	Dietenheim	Trentino-Alto Adige	Bolzano-Bozen	BZ	14816
IT	39031	Riscone	Trentino-Alto Adige	Bolzano-Bozen	BZ	14817
IT	39031	Aufhofen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14818
IT	39031	Reischach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14819
IT	39031	St. Georgen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14820
IT	39031	Teodone	Trentino-Alto Adige	Bolzano-Bozen	BZ	14821
IT	39031	Bruneck	Trentino-Alto Adige	Bolzano-Bozen	BZ	14822
IT	39031	Stegen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14823
IT	39031	Brunico	Trentino-Alto Adige	Bolzano-Bozen	BZ	14824
IT	39032	Riva Di Tures	Trentino-Alto Adige	Bolzano-Bozen	BZ	14825
IT	39032	Molini Di Tures	Trentino-Alto Adige	Bolzano-Bozen	BZ	14826
IT	39032	Acereto	Trentino-Alto Adige	Bolzano-Bozen	BZ	14827
IT	39032	Kematen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14828
IT	39032	Sand in Taufers	Trentino-Alto Adige	Bolzano-Bozen	BZ	14829
IT	39032	Moehlen In Taufer	Trentino-Alto Adige	Bolzano-Bozen	BZ	14830
IT	39032	Campo Tures	Trentino-Alto Adige	Bolzano-Bozen	BZ	14831
IT	39032	Mühlen i. Taufers	Trentino-Alto Adige	Bolzano-Bozen	BZ	14832
IT	39032	Ahornac	Trentino-Alto Adige	Bolzano-Bozen	BZ	14833
IT	39032	Taufers/Ahrntal	Trentino-Alto Adige	Bolzano-Bozen	BZ	14834
IT	39033	Corvara	Trentino-Alto Adige	Bolzano-Bozen	BZ	14835
IT	39033	Colfosco	Trentino-Alto Adige	Bolzano-Bozen	BZ	14836
IT	39033	Kolfusch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14837
IT	39033	Corvara In Badia	Trentino-Alto Adige	Bolzano-Bozen	BZ	14838
IT	39034	Wahlen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14839
IT	39034	Aufkirchen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14840
IT	39034	Toblach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14841
IT	39034	Dobbiaco	Trentino-Alto Adige	Bolzano-Bozen	BZ	14842
IT	39035	Tesido	Trentino-Alto Adige	Bolzano-Bozen	BZ	14843
IT	39035	Monguelfo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14844
IT	39035	Taisten	Trentino-Alto Adige	Bolzano-Bozen	BZ	14845
IT	39035	Welsberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14846
IT	39036	Stern	Trentino-Alto Adige	Bolzano-Bozen	BZ	14847
IT	39036	Badia	Trentino-Alto Adige	Bolzano-Bozen	BZ	14848
IT	39036	La Villa	Trentino-Alto Adige	Bolzano-Bozen	BZ	14849
IT	39036	Pedraces	Trentino-Alto Adige	Bolzano-Bozen	BZ	14850
IT	39036	St. Kassian	Trentino-Alto Adige	Bolzano-Bozen	BZ	14851
IT	39036	Abtei/Badia	Trentino-Alto Adige	Bolzano-Bozen	BZ	14852
IT	39036	San Cassiano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14853
IT	39036	Pedrace	Trentino-Alto Adige	Bolzano-Bozen	BZ	14854
IT	39037	Rodengo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14855
IT	39037	Mühlbach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14856
IT	39037	Rio Di Pusteria	Trentino-Alto Adige	Bolzano-Bozen	BZ	14857
IT	39037	Spinges	Trentino-Alto Adige	Bolzano-Bozen	BZ	14858
IT	39037	Vals	Trentino-Alto Adige	Bolzano-Bozen	BZ	14859
IT	39037	Meransen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14860
IT	39038	San Candido	Trentino-Alto Adige	Bolzano-Bozen	BZ	14861
IT	39038	Winnebach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14862
IT	39038	Vierschach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14863
IT	39039	Villabassa	Trentino-Alto Adige	Bolzano-Bozen	BZ	14864
IT	39039	Niederdorf	Trentino-Alto Adige	Bolzano-Bozen	BZ	14865
IT	39040	Sciaves	Trentino-Alto Adige	Bolzano-Bozen	BZ	14866
IT	39040	Pruno	Trentino-Alto Adige	Bolzano-Bozen	BZ	14867
IT	39040	Stanghe	Trentino-Alto Adige	Bolzano-Bozen	BZ	14868
IT	39040	Castelrotto	Trentino-Alto Adige	Bolzano-Bozen	BZ	14869
IT	39040	Ponte Gardena	Trentino-Alto Adige	Bolzano-Bozen	BZ	14870
IT	39040	Campodazzo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14871
IT	39040	Truden	Trentino-Alto Adige	Bolzano-Bozen	BZ	14872
IT	39040	Kastelruth	Trentino-Alto Adige	Bolzano-Bozen	BZ	14873
IT	39040	Mareit	Trentino-Alto Adige	Bolzano-Bozen	BZ	14874
IT	39040	Varna	Trentino-Alto Adige	Bolzano-Bozen	BZ	14875
IT	39040	Trodena	Trentino-Alto Adige	Bolzano-Bozen	BZ	14876
IT	39040	Albions	Trentino-Alto Adige	Bolzano-Bozen	BZ	14877
IT	39040	Anterivo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14878
IT	39040	Vahrn	Trentino-Alto Adige	Bolzano-Bozen	BZ	14879
IT	39040	Novacella	Trentino-Alto Adige	Bolzano-Bozen	BZ	14880
IT	39040	Proves	Trentino-Alto Adige	Bolzano-Bozen	BZ	14881
IT	39040	Mareta	Trentino-Alto Adige	Bolzano-Bozen	BZ	14882
IT	39040	Trens	Trentino-Alto Adige	Bolzano-Bozen	BZ	14883
IT	39040	Campo Di Trens	Trentino-Alto Adige	Bolzano-Bozen	BZ	14884
IT	39040	Olmi	Trentino-Alto Adige	Bolzano-Bozen	BZ	14885
IT	39040	Neustift	Trentino-Alto Adige	Bolzano-Bozen	BZ	14886
IT	39040	Kurtatsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14887
IT	39040	Altrei	Trentino-Alto Adige	Bolzano-Bozen	BZ	14888
IT	39040	Viums	Trentino-Alto Adige	Bolzano-Bozen	BZ	14889
IT	39040	Waidbruck	Trentino-Alto Adige	Bolzano-Bozen	BZ	14890
IT	39040	Buchholz	Trentino-Alto Adige	Bolzano-Bozen	BZ	14891
IT	39040	Cortina Sulla Strada Del Vino	Trentino-Alto Adige	Bolzano-Bozen	BZ	14892
IT	39040	Rungg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14893
IT	39040	Freienfeld	Trentino-Alto Adige	Bolzano-Bozen	BZ	14894
IT	39040	Cortaccia Sulla Strada Del Vino	Trentino-Alto Adige	Bolzano-Bozen	BZ	14895
IT	39040	Kurtinig	Trentino-Alto Adige	Bolzano-Bozen	BZ	14896
IT	39040	Afers	Trentino-Alto Adige	Bolzano-Bozen	BZ	14897
IT	39040	Laurein	Trentino-Alto Adige	Bolzano-Bozen	BZ	14898
IT	39040	Naz Sciaves	Trentino-Alto Adige	Bolzano-Bozen	BZ	14899
IT	39040	Lauregno	Trentino-Alto Adige	Bolzano-Bozen	BZ	14900
IT	39040	Mauls	Trentino-Alto Adige	Bolzano-Bozen	BZ	14901
IT	39040	Leone Santa Elisabetta	Trentino-Alto Adige	Bolzano-Bozen	BZ	14902
IT	39040	Mules	Trentino-Alto Adige	Bolzano-Bozen	BZ	14903
IT	39040	San Pietro	Trentino-Alto Adige	Bolzano-Bozen	BZ	14904
IT	39040	Tramin	Trentino-Alto Adige	Bolzano-Bozen	BZ	14905
IT	39040	Gossensaß	Trentino-Alto Adige	Bolzano-Bozen	BZ	14906
IT	39040	Villandro	Trentino-Alto Adige	Bolzano-Bozen	BZ	14907
IT	39040	Pfitsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14908
IT	39040	San Lugano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14909
IT	39040	Casateia	Trentino-Alto Adige	Bolzano-Bozen	BZ	14910
IT	39040	Rasa	Trentino-Alto Adige	Bolzano-Bozen	BZ	14911
IT	39040	Villanders	Trentino-Alto Adige	Bolzano-Bozen	BZ	14912
IT	39040	Seis am Schlern	Trentino-Alto Adige	Bolzano-Bozen	BZ	14913
IT	39040	Velturno	Trentino-Alto Adige	Bolzano-Bozen	BZ	14914
IT	39040	Siusi	Trentino-Alto Adige	Bolzano-Bozen	BZ	14915
IT	39040	Cauria	Trentino-Alto Adige	Bolzano-Bozen	BZ	14916
IT	39040	Luson	Trentino-Alto Adige	Bolzano-Bozen	BZ	14917
IT	39040	Stilves	Trentino-Alto Adige	Bolzano-Bozen	BZ	14918
IT	39040	Salurn	Trentino-Alto Adige	Bolzano-Bozen	BZ	14919
IT	39040	Ora	Trentino-Alto Adige	Bolzano-Bozen	BZ	14920
IT	39040	Penon	Trentino-Alto Adige	Bolzano-Bozen	BZ	14921
IT	39040	Lüsen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14922
IT	39040	Magre' Sulla Strada Del Vino	Trentino-Alto Adige	Bolzano-Bozen	BZ	14923
IT	39040	Aldino	Trentino-Alto Adige	Bolzano-Bozen	BZ	14924
IT	39040	Alpe Di Siusi	Trentino-Alto Adige	Bolzano-Bozen	BZ	14925
IT	39040	Ridnaun	Trentino-Alto Adige	Bolzano-Bozen	BZ	14926
IT	39040	Salorno	Trentino-Alto Adige	Bolzano-Bozen	BZ	14927
IT	39040	Auer	Trentino-Alto Adige	Bolzano-Bozen	BZ	14928
IT	39040	Barbian	Trentino-Alto Adige	Bolzano-Bozen	BZ	14929
IT	39040	Lajen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14930
IT	39040	Schabs	Trentino-Alto Adige	Bolzano-Bozen	BZ	14931
IT	39040	Ridanna	Trentino-Alto Adige	Bolzano-Bozen	BZ	14932
IT	39040	Feldthurns	Trentino-Alto Adige	Bolzano-Bozen	BZ	14933
IT	39040	Laion	Trentino-Alto Adige	Bolzano-Bozen	BZ	14934
IT	39040	Laag	Trentino-Alto Adige	Bolzano-Bozen	BZ	14935
IT	39040	Redagno	Trentino-Alto Adige	Bolzano-Bozen	BZ	14936
IT	39040	Petersberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	14937
IT	39040	Ratschings	Trentino-Alto Adige	Bolzano-Bozen	BZ	14938
IT	39040	St. Peter b. Lajen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14939
IT	39040	Barbiano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14940
IT	39040	Racines	Trentino-Alto Adige	Bolzano-Bozen	BZ	14941
IT	39040	Gastei	Trentino-Alto Adige	Bolzano-Bozen	BZ	14942
IT	39040	Margreid	Trentino-Alto Adige	Bolzano-Bozen	BZ	14943
IT	39040	Pruno Di Stilves	Trentino-Alto Adige	Bolzano-Bozen	BZ	14944
IT	39040	Spiluck	Trentino-Alto Adige	Bolzano-Bozen	BZ	14945
IT	39040	St.Peter Laje	Trentino-Alto Adige	Bolzano-Bozen	BZ	14946
IT	39040	Schrambach	Trentino-Alto Adige	Bolzano-Bozen	BZ	14947
IT	39040	Valgiovo	Trentino-Alto Adige	Bolzano-Bozen	BZ	14948
IT	39040	St. Moritz b. Villanders	Trentino-Alto Adige	Bolzano-Bozen	BZ	14949
IT	39040	Raa	Trentino-Alto Adige	Bolzano-Bozen	BZ	14950
IT	39040	Pinzon	Trentino-Alto Adige	Bolzano-Bozen	BZ	14951
IT	39040	Kaltenbrunn	Trentino-Alto Adige	Bolzano-Bozen	BZ	14952
IT	39040	Gschnon	Trentino-Alto Adige	Bolzano-Bozen	BZ	14953
IT	39040	Stange	Trentino-Alto Adige	Bolzano-Bozen	BZ	14954
IT	39040	Telfes	Trentino-Alto Adige	Bolzano-Bozen	BZ	14955
IT	39040	St.Pete	Trentino-Alto Adige	Bolzano-Bozen	BZ	14956
IT	39040	St. Leonhard	Trentino-Alto Adige	Bolzano-Bozen	BZ	14957
IT	39040	Hole	Trentino-Alto Adige	Bolzano-Bozen	BZ	14958
IT	39040	Glen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14959
IT	39040	Jaufental	Trentino-Alto Adige	Bolzano-Bozen	BZ	14960
IT	39040	Aldein	Trentino-Alto Adige	Bolzano-Bozen	BZ	14961
IT	39040	Termeno Sulla Strada Del Vino	Trentino-Alto Adige	Bolzano-Bozen	BZ	14962
IT	39040	Mühlen/Truden	Trentino-Alto Adige	Bolzano-Bozen	BZ	14963
IT	39040	Seis Am Schler	Trentino-Alto Adige	Bolzano-Bozen	BZ	14964
IT	39040	Freins	Trentino-Alto Adige	Bolzano-Bozen	BZ	14965
IT	39040	San Pietro Laion	Trentino-Alto Adige	Bolzano-Bozen	BZ	14966
IT	39040	Tschövas	Trentino-Alto Adige	Bolzano-Bozen	BZ	14967
IT	39040	Montagna	Trentino-Alto Adige	Bolzano-Bozen	BZ	14968
IT	39040	Schalders	Trentino-Alto Adige	Bolzano-Bozen	BZ	14969
IT	39040	Radein	Trentino-Alto Adige	Bolzano-Bozen	BZ	14970
IT	39040	Tanürz	Trentino-Alto Adige	Bolzano-Bozen	BZ	14971
IT	39040	Loewenviertel Elisabethsiedlun	Trentino-Alto Adige	Bolzano-Bozen	BZ	14972
IT	39040	Proveis	Trentino-Alto Adige	Bolzano-Bozen	BZ	14973
IT	39040	Seiser Al	Trentino-Alto Adige	Bolzano-Bozen	BZ	14974
IT	39040	Pflersch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14975
IT	39040	Atzwang	Trentino-Alto Adige	Bolzano-Bozen	BZ	14976
IT	39040	Innerpfitsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	14977
IT	39040	St.Lugan	Trentino-Alto Adige	Bolzano-Bozen	BZ	14978
IT	39040	S. Lugano	Trentino-Alto Adige	Bolzano-Bozen	BZ	14979
IT	39040	Natz	Trentino-Alto Adige	Bolzano-Bozen	BZ	14980
IT	39040	St. Michael/Kastelr.	Trentino-Alto Adige	Bolzano-Bozen	BZ	14981
IT	39040	Stilfes	Trentino-Alto Adige	Bolzano-Bozen	BZ	14982
IT	39040	Weißenstein	Trentino-Alto Adige	Bolzano-Bozen	BZ	14983
IT	39040	Gfrill/Unterland	Trentino-Alto Adige	Bolzano-Bozen	BZ	14984
IT	39040	Klerant	Trentino-Alto Adige	Bolzano-Bozen	BZ	14985
IT	39040	Funes	Trentino-Alto Adige	Bolzano-Bozen	BZ	14986
IT	39040	Schmuders	Trentino-Alto Adige	Bolzano-Bozen	BZ	14987
IT	39040	Fontanefredde	Trentino-Alto Adige	Bolzano-Bozen	BZ	14988
IT	39040	Kollmann	Trentino-Alto Adige	Bolzano-Bozen	BZ	14989
IT	39040	Elzenbaum	Trentino-Alto Adige	Bolzano-Bozen	BZ	14990
IT	39040	Entiklar	Trentino-Alto Adige	Bolzano-Bozen	BZ	14991
IT	39040	Montan	Trentino-Alto Adige	Bolzano-Bozen	BZ	14992
IT	39040	Garn	Trentino-Alto Adige	Bolzano-Bozen	BZ	14993
IT	39040	Hohlen	Trentino-Alto Adige	Bolzano-Bozen	BZ	14994
IT	39040	Flitt	Trentino-Alto Adige	Bolzano-Bozen	BZ	14995
IT	39040	Naz	Trentino-Alto Adige	Bolzano-Bozen	BZ	14996
IT	39040	Graun/Unterl.	Trentino-Alto Adige	Bolzano-Bozen	BZ	14997
IT	39040	Söll	Trentino-Alto Adige	Bolzano-Bozen	BZ	14998
IT	39040	Pfulters	Trentino-Alto Adige	Bolzano-Bozen	BZ	14999
IT	39040	Villnöß	Trentino-Alto Adige	Bolzano-Bozen	BZ	15000
IT	39040	Schnauders	Trentino-Alto Adige	Bolzano-Bozen	BZ	15001
IT	39040	St. Oswald	Trentino-Alto Adige	Bolzano-Bozen	BZ	15002
IT	39040	Fennberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	15003
IT	39040	Tagusens	Trentino-Alto Adige	Bolzano-Bozen	BZ	15004
IT	39040	Flans	Trentino-Alto Adige	Bolzano-Bozen	BZ	15005
IT	39040	St. Andrä_	Trentino-Alto Adige	Bolzano-Bozen	BZ	15006
IT	39041	Colle Isarco	Trentino-Alto Adige	Bolzano-Bozen	BZ	15007
IT	39041	Brenner	Trentino-Alto Adige	Bolzano-Bozen	BZ	15008
IT	39041	Gossensas	Trentino-Alto Adige	Bolzano-Bozen	BZ	15009
IT	39041	Brennero	Trentino-Alto Adige	Bolzano-Bozen	BZ	15010
IT	39042	Elvas	Trentino-Alto Adige	Bolzano-Bozen	BZ	15011
IT	39042	Sant'Andrea In Monte	Trentino-Alto Adige	Bolzano-Bozen	BZ	15012
IT	39042	Afer	Trentino-Alto Adige	Bolzano-Bozen	BZ	15013
IT	39042	Neustift	Trentino-Alto Adige	Bolzano-Bozen	BZ	15014
IT	39042	Milland	Trentino-Alto Adige	Bolzano-Bozen	BZ	15015
IT	39042	Albes	Trentino-Alto Adige	Bolzano-Bozen	BZ	15016
IT	39042	Eores	Trentino-Alto Adige	Bolzano-Bozen	BZ	15017
IT	39042	Pinzagen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15018
IT	39042	St.Andr	Trentino-Alto Adige	Bolzano-Bozen	BZ	15019
IT	39042	Tils	Trentino-Alto Adige	Bolzano-Bozen	BZ	15020
IT	39042	Albeins	Trentino-Alto Adige	Bolzano-Bozen	BZ	15021
IT	39042	Karnol	Trentino-Alto Adige	Bolzano-Bozen	BZ	15022
IT	39042	Tschötsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	15023
IT	39042	Sarns	Trentino-Alto Adige	Bolzano-Bozen	BZ	15024
IT	39042	Zinggen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15025
IT	39042	Bressanone	Trentino-Alto Adige	Bolzano-Bozen	BZ	15026
IT	39042	Brixen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15027
IT	39042	Mellaun	Trentino-Alto Adige	Bolzano-Bozen	BZ	15028
IT	39043	Gufidaun	Trentino-Alto Adige	Bolzano-Bozen	BZ	15029
IT	39043	Chiusa	Trentino-Alto Adige	Bolzano-Bozen	BZ	15030
IT	39043	Latzfons	Trentino-Alto Adige	Bolzano-Bozen	BZ	15031
IT	39043	Gudon	Trentino-Alto Adige	Bolzano-Bozen	BZ	15032
IT	39043	Lazfons	Trentino-Alto Adige	Bolzano-Bozen	BZ	15033
IT	39043	Teis	Trentino-Alto Adige	Bolzano-Bozen	BZ	15034
IT	39043	Klausen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15035
IT	39043	Verdings	Trentino-Alto Adige	Bolzano-Bozen	BZ	15036
IT	39044	Neumarkt	Trentino-Alto Adige	Bolzano-Bozen	BZ	15037
IT	39044	Laghetti	Trentino-Alto Adige	Bolzano-Bozen	BZ	15038
IT	39044	Egna	Trentino-Alto Adige	Bolzano-Bozen	BZ	15039
IT	39044	Mazon	Trentino-Alto Adige	Bolzano-Bozen	BZ	15040
IT	39045	Fortezza	Trentino-Alto Adige	Bolzano-Bozen	BZ	15041
IT	39045	Mittewald	Trentino-Alto Adige	Bolzano-Bozen	BZ	15042
IT	39045	Franzensfeste	Trentino-Alto Adige	Bolzano-Bozen	BZ	15043
IT	39045	Grasstein	Trentino-Alto Adige	Bolzano-Bozen	BZ	15044
IT	39045	Oberau	Trentino-Alto Adige	Bolzano-Bozen	BZ	15045
IT	39046	Ortisei	Trentino-Alto Adige	Bolzano-Bozen	BZ	15046
IT	39046	Pufels	Trentino-Alto Adige	Bolzano-Bozen	BZ	15047
IT	39046	St. Ulrich/Urtijei	Trentino-Alto Adige	Bolzano-Bozen	BZ	15048
IT	39046	St. Jakob	Trentino-Alto Adige	Bolzano-Bozen	BZ	15049
IT	39047	Santa Cristina Val Gardena	Trentino-Alto Adige	Bolzano-Bozen	BZ	15050
IT	39047	St. Christina/S. Crestina -Gherdeina	Trentino-Alto Adige	Bolzano-Bozen	BZ	15051
IT	39048	Selva	Trentino-Alto Adige	Bolzano-Bozen	BZ	15052
IT	39048	Wolkenstein/Selva	Trentino-Alto Adige	Bolzano-Bozen	BZ	15053
IT	39048	Selva Di Val Gardena	Trentino-Alto Adige	Bolzano-Bozen	BZ	15054
IT	39049	Thuins	Trentino-Alto Adige	Bolzano-Bozen	BZ	15055
IT	39049	Sterzing	Trentino-Alto Adige	Bolzano-Bozen	BZ	15056
IT	39049	Kematen/Pfitsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	15057
IT	39049	Prati	Trentino-Alto Adige	Bolzano-Bozen	BZ	15058
IT	39049	Wiesen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15059
IT	39049	Stazione	Trentino-Alto Adige	Bolzano-Bozen	BZ	15060
IT	39049	Vipiteno	Trentino-Alto Adige	Bolzano-Bozen	BZ	15061
IT	39049	Ried	Trentino-Alto Adige	Bolzano-Bozen	BZ	15062
IT	39049	Flains	Trentino-Alto Adige	Bolzano-Bozen	BZ	15063
IT	39049	Val Di Vizze	Trentino-Alto Adige	Bolzano-Bozen	BZ	15064
IT	39049	Tschöfs	Trentino-Alto Adige	Bolzano-Bozen	BZ	15065
IT	39049	Bahnho	Trentino-Alto Adige	Bolzano-Bozen	BZ	15066
IT	39049	Steckholz	Trentino-Alto Adige	Bolzano-Bozen	BZ	15067
IT	39050	St. Pauls/Eppan	Trentino-Alto Adige	Bolzano-Bozen	BZ	15068
IT	39050	Unterglaning	Trentino-Alto Adige	Bolzano-Bozen	BZ	15069
IT	39050	Aica Di Fie'	Trentino-Alto Adige	Bolzano-Bozen	BZ	15070
IT	39050	Afing	Trentino-Alto Adige	Bolzano-Bozen	BZ	15071
IT	39050	San Paolo	Trentino-Alto Adige	Bolzano-Bozen	BZ	15072
IT	39050	Blumau	Trentino-Alto Adige	Bolzano-Bozen	BZ	15073
IT	39050	Jenesien	Trentino-Alto Adige	Bolzano-Bozen	BZ	15074
IT	39050	Cologna Di Sotto	Trentino-Alto Adige	Bolzano-Bozen	BZ	15075
IT	39050	Valas	Trentino-Alto Adige	Bolzano-Bozen	BZ	15076
IT	39050	Unterinn	Trentino-Alto Adige	Bolzano-Bozen	BZ	15077
IT	39050	St.Pauls	Trentino-Alto Adige	Bolzano-Bozen	BZ	15078
IT	39050	Girlan	Trentino-Alto Adige	Bolzano-Bozen	BZ	15079
IT	39050	San Genesio Atesino	Trentino-Alto Adige	Bolzano-Bozen	BZ	15080
IT	39050	Avigna	Trentino-Alto Adige	Bolzano-Bozen	BZ	15081
IT	39050	Karneid	Trentino-Alto Adige	Bolzano-Bozen	BZ	15082
IT	39050	Steinegg	Trentino-Alto Adige	Bolzano-Bozen	BZ	15083
IT	39050	Flaas	Trentino-Alto Adige	Bolzano-Bozen	BZ	15084
IT	39050	Petersberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	15085
IT	39050	Deutschnofen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15086
IT	39050	Raut	Trentino-Alto Adige	Bolzano-Bozen	BZ	15087
IT	39050	Untereggen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15088
IT	39050	Eggen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15089
IT	39050	Birchabruck	Trentino-Alto Adige	Bolzano-Bozen	BZ	15090
IT	39050	Monte San Pietro	Trentino-Alto Adige	Bolzano-Bozen	BZ	15091
IT	39050	Nova Ponente	Trentino-Alto Adige	Bolzano-Bozen	BZ	15092
IT	39050	Ponte Nova	Trentino-Alto Adige	Bolzano-Bozen	BZ	15093
IT	39050	Steinmannwald	Trentino-Alto Adige	Bolzano-Bozen	BZ	15094
IT	39050	St. Konstantin	Trentino-Alto Adige	Bolzano-Bozen	BZ	15095
IT	39050	Innichen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15096
IT	39050	San Nicolo' D'Ega	Trentino-Alto Adige	Bolzano-Bozen	BZ	15097
IT	39050	Perdonig	Trentino-Alto Adige	Bolzano-Bozen	BZ	15098
IT	39050	Tiers	Trentino-Alto Adige	Bolzano-Bozen	BZ	15099
IT	39050	Völser Aicha	Trentino-Alto Adige	Bolzano-Bozen	BZ	15100
IT	39050	Fie' Allo Sciliar	Trentino-Alto Adige	Bolzano-Bozen	BZ	15101
IT	39050	St. Justina/Eppan	Trentino-Alto Adige	Bolzano-Bozen	BZ	15102
IT	39050	Tires	Trentino-Alto Adige	Bolzano-Bozen	BZ	15103
IT	39050	Ums	Trentino-Alto Adige	Bolzano-Bozen	BZ	15104
IT	39050	Völs am Schlern	Trentino-Alto Adige	Bolzano-Bozen	BZ	15105
IT	39050	St. Nikolaus i. Eggen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15106
IT	39050	Missian	Trentino-Alto Adige	Bolzano-Bozen	BZ	15107
IT	39050	Unterrain/Eppan	Trentino-Alto Adige	Bolzano-Bozen	BZ	15108
IT	39050	Wangen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15109
IT	39050	Seit	Trentino-Alto Adige	Bolzano-Bozen	BZ	15110
IT	39050	Breien	Trentino-Alto Adige	Bolzano-Bozen	BZ	15111
IT	39050	Lengstein	Trentino-Alto Adige	Bolzano-Bozen	BZ	15112
IT	39050	Prösels	Trentino-Alto Adige	Bolzano-Bozen	BZ	15113
IT	39050	Gummer	Trentino-Alto Adige	Bolzano-Bozen	BZ	15114
IT	39050	St. Jakob/Bozen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15115
IT	39050	Oberinn	Trentino-Alto Adige	Bolzano-Bozen	BZ	15116
IT	39051	Branzoll	Trentino-Alto Adige	Bolzano-Bozen	BZ	15117
IT	39051	Vadena	Trentino-Alto Adige	Bolzano-Bozen	BZ	15118
IT	39051	Bronzolo	Trentino-Alto Adige	Bolzano-Bozen	BZ	15119
IT	39051	Pfatten	Trentino-Alto Adige	Bolzano-Bozen	BZ	15120
IT	39052	Kaltern	Trentino-Alto Adige	Bolzano-Bozen	BZ	15121
IT	39052	Mitterdorf	Trentino-Alto Adige	Bolzano-Bozen	BZ	15122
IT	39052	Caldaro Sulla Strada Del Vino	Trentino-Alto Adige	Bolzano-Bozen	BZ	15123
IT	39052	St. Nikolaus/Kaltern	Trentino-Alto Adige	Bolzano-Bozen	BZ	15124
IT	39052	St. Josef am See	Trentino-Alto Adige	Bolzano-Bozen	BZ	15125
IT	39052	Altenburg	Trentino-Alto Adige	Bolzano-Bozen	BZ	15126
IT	39052	Unterplanitzing	Trentino-Alto Adige	Bolzano-Bozen	BZ	15127
IT	39052	St. Anton	Trentino-Alto Adige	Bolzano-Bozen	BZ	15128
IT	39052	Oberplanitzing	Trentino-Alto Adige	Bolzano-Bozen	BZ	15129
IT	39053	Cornedo All'Isarco	Trentino-Alto Adige	Bolzano-Bozen	BZ	15130
IT	39053	Kardaun	Trentino-Alto Adige	Bolzano-Bozen	BZ	15131
IT	39053	Cardano	Trentino-Alto Adige	Bolzano-Bozen	BZ	15132
IT	39053	Collepietra	Trentino-Alto Adige	Bolzano-Bozen	BZ	15133
IT	39053	San Valentino In Campo	Trentino-Alto Adige	Bolzano-Bozen	BZ	15134
IT	39053	Bluma	Trentino-Alto Adige	Bolzano-Bozen	BZ	15135
IT	39053	Prato All'Isarco	Trentino-Alto Adige	Bolzano-Bozen	BZ	15136
IT	39053	Gumme	Trentino-Alto Adige	Bolzano-Bozen	BZ	15137
IT	39053	Kardaun/Bozen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15138
IT	39053	Steineg	Trentino-Alto Adige	Bolzano-Bozen	BZ	15139
IT	39053	Eggenta	Trentino-Alto Adige	Bolzano-Bozen	BZ	15140
IT	39053	Contrada Val D'Ega	Trentino-Alto Adige	Bolzano-Bozen	BZ	15141
IT	39054	Auna Inferiore	Trentino-Alto Adige	Bolzano-Bozen	BZ	15142
IT	39054	Soprabolzano	Trentino-Alto Adige	Bolzano-Bozen	BZ	15143
IT	39054	Auna Di Sopra	Trentino-Alto Adige	Bolzano-Bozen	BZ	15144
IT	39054	Lengmoos	Trentino-Alto Adige	Bolzano-Bozen	BZ	15145
IT	39054	Klobenstein	Trentino-Alto Adige	Bolzano-Bozen	BZ	15146
IT	39054	Gissmann	Trentino-Alto Adige	Bolzano-Bozen	BZ	15147
IT	39054	Ritten	Trentino-Alto Adige	Bolzano-Bozen	BZ	15148
IT	39054	Vanga	Trentino-Alto Adige	Bolzano-Bozen	BZ	15149
IT	39054	Collalbo	Trentino-Alto Adige	Bolzano-Bozen	BZ	15150
IT	39054	Lengstein Am Ritte	Trentino-Alto Adige	Bolzano-Bozen	BZ	15151
IT	39054	Wange	Trentino-Alto Adige	Bolzano-Bozen	BZ	15152
IT	39054	Renon	Trentino-Alto Adige	Bolzano-Bozen	BZ	15153
IT	39054	Unterin	Trentino-Alto Adige	Bolzano-Bozen	BZ	15154
IT	39054	Oberi	Trentino-Alto Adige	Bolzano-Bozen	BZ	15155
IT	39054	Oberboze	Trentino-Alto Adige	Bolzano-Bozen	BZ	15156
IT	39054	Sant'Ottilia In Renon	Trentino-Alto Adige	Bolzano-Bozen	BZ	15157
IT	39055	Leifers	Trentino-Alto Adige	Bolzano-Bozen	BZ	15158
IT	39055	Pineta	Trentino-Alto Adige	Bolzano-Bozen	BZ	15159
IT	39055	Laives	Trentino-Alto Adige	Bolzano-Bozen	BZ	15160
IT	39055	La Costa Di Laives	Trentino-Alto Adige	Bolzano-Bozen	BZ	15161
IT	39055	Seit Bei Leifer	Trentino-Alto Adige	Bolzano-Bozen	BZ	15162
IT	39055	San Giacomo	Trentino-Alto Adige	Bolzano-Bozen	BZ	15163
IT	39055	La Costa	Trentino-Alto Adige	Bolzano-Bozen	BZ	15164
IT	39055	St.Jakob Bei Boze	Trentino-Alto Adige	Bolzano-Bozen	BZ	15165
IT	39055	San Giacomo Di Laives	Trentino-Alto Adige	Bolzano-Bozen	BZ	15166
IT	39056	Welschnofen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15167
IT	39056	Karersee	Trentino-Alto Adige	Bolzano-Bozen	BZ	15168
IT	39056	Carezza	Trentino-Alto Adige	Bolzano-Bozen	BZ	15169
IT	39056	Nova Levante	Trentino-Alto Adige	Bolzano-Bozen	BZ	15170
IT	6047	Todiano	Umbria	Perugia	PG	15171
IT	39056	Carezza Al Lago	Trentino-Alto Adige	Bolzano-Bozen	BZ	15172
IT	39057	St. Michael/Eppan	Trentino-Alto Adige	Bolzano-Bozen	BZ	15173
IT	39057	San Michele	Trentino-Alto Adige	Bolzano-Bozen	BZ	15174
IT	39057	Cornaiano	Trentino-Alto Adige	Bolzano-Bozen	BZ	15175
IT	39057	Eppan	Trentino-Alto Adige	Bolzano-Bozen	BZ	15176
IT	39057	Frangarto	Trentino-Alto Adige	Bolzano-Bozen	BZ	15177
IT	39057	Girla	Trentino-Alto Adige	Bolzano-Bozen	BZ	15178
IT	39057	San Michele Appiano	Trentino-Alto Adige	Bolzano-Bozen	BZ	15179
IT	39057	Montiggl	Trentino-Alto Adige	Bolzano-Bozen	BZ	15180
IT	39057	Frangar	Trentino-Alto Adige	Bolzano-Bozen	BZ	15181
IT	39057	Appiano Sulla Strada Del Vino	Trentino-Alto Adige	Bolzano-Bozen	BZ	15182
IT	39058	Pens	Trentino-Alto Adige	Bolzano-Bozen	BZ	15183
IT	39058	Campolasta	Trentino-Alto Adige	Bolzano-Bozen	BZ	15184
IT	39058	Villa	Trentino-Alto Adige	Bolzano-Bozen	BZ	15185
IT	39058	Aberstückl	Trentino-Alto Adige	Bolzano-Bozen	BZ	15186
IT	39058	Sarnthein	Trentino-Alto Adige	Bolzano-Bozen	BZ	15187
IT	39058	Durnholz	Trentino-Alto Adige	Bolzano-Bozen	BZ	15188
IT	39058	Sarentino	Trentino-Alto Adige	Bolzano-Bozen	BZ	15189
IT	39058	Weißenbach/Sarntal	Trentino-Alto Adige	Bolzano-Bozen	BZ	15190
IT	39058	Asten	Trentino-Alto Adige	Bolzano-Bozen	BZ	15191
IT	39058	Reinswald	Trentino-Alto Adige	Bolzano-Bozen	BZ	15192
IT	39058	Bundschen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15193
IT	39058	Riedelsberg	Trentino-Alto Adige	Bolzano-Bozen	BZ	15194
IT	39058	Astfeld-Nordheim	Trentino-Alto Adige	Bolzano-Bozen	BZ	15195
IT	39058	Nordhei	Trentino-Alto Adige	Bolzano-Bozen	BZ	15196
IT	39059	Wolfsgruben	Trentino-Alto Adige	Bolzano-Bozen	BZ	15197
IT	39059	Oberbozen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15198
IT	39100	Bozen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15199
IT	39100	Oberau/Bozen	Trentino-Alto Adige	Bolzano-Bozen	BZ	15200
IT	39100	Bolzano	Trentino-Alto Adige	Bolzano-Bozen	BZ	15201
IT	39100	Kampenn	Trentino-Alto Adige	Bolzano-Bozen	BZ	15202
IT	39100	Glaning	Trentino-Alto Adige	Bolzano-Bozen	BZ	15203
IT	39100	Rentsch	Trentino-Alto Adige	Bolzano-Bozen	BZ	15204
IT	39100	Sigmundskro	Trentino-Alto Adige	Bolzano-Bozen	BZ	15205
IT	39100	Signat	Trentino-Alto Adige	Bolzano-Bozen	BZ	15206
IT	39100	Castelfirmiano	Trentino-Alto Adige	Bolzano-Bozen	BZ	15207
IT	38010	Nave San Rocco	Trentino-Alto Adige	Trento	TN	15208
IT	38010	Sanzeno	Trentino-Alto Adige	Trento	TN	15209
IT	38010	Fai Della Paganella	Trentino-Alto Adige	Trento	TN	15210
IT	38010	Andalo	Trentino-Alto Adige	Trento	TN	15211
IT	38010	Faedo	Trentino-Alto Adige	Trento	TN	15212
IT	38010	Dambel	Trentino-Alto Adige	Trento	TN	15213
IT	38010	Romeno	Trentino-Alto Adige	Trento	TN	15214
IT	38010	Vigo Di Ton	Trentino-Alto Adige	Trento	TN	15215
IT	38010	Campodenno	Trentino-Alto Adige	Trento	TN	15216
IT	38010	Casez	Trentino-Alto Adige	Trento	TN	15217
IT	38010	Ronzone	Trentino-Alto Adige	Trento	TN	15218
IT	38010	Sporminore	Trentino-Alto Adige	Trento	TN	15219
IT	38010	Cavedago	Trentino-Alto Adige	Trento	TN	15220
IT	38010	Malgolo	Trentino-Alto Adige	Trento	TN	15221
IT	38010	San Michele All'Adige	Trentino-Alto Adige	Trento	TN	15222
IT	38010	Ruffre'	Trentino-Alto Adige	Trento	TN	15223
IT	38010	San Romedio	Trentino-Alto Adige	Trento	TN	15224
IT	38010	Vigo Anaunia	Trentino-Alto Adige	Trento	TN	15225
IT	38010	Spormaggiore	Trentino-Alto Adige	Trento	TN	15226
IT	38010	Banco	Trentino-Alto Adige	Trento	TN	15227
IT	38010	Sfruz	Trentino-Alto Adige	Trento	TN	15228
IT	38010	Denno	Trentino-Alto Adige	Trento	TN	15229
IT	38010	Cima Paganella	Trentino-Alto Adige	Trento	TN	15230
IT	38010	Zambana	Trentino-Alto Adige	Trento	TN	15231
IT	38010	Tavon	Trentino-Alto Adige	Trento	TN	15232
IT	38010	Ton	Trentino-Alto Adige	Trento	TN	15233
IT	38011	Amblar	Trentino-Alto Adige	Trento	TN	15234
IT	38011	Cavareno	Trentino-Alto Adige	Trento	TN	15235
IT	38011	Seio	Trentino-Alto Adige	Trento	TN	15236
IT	38011	Don	Trentino-Alto Adige	Trento	TN	15237
IT	38011	Sarnonico	Trentino-Alto Adige	Trento	TN	15238
IT	38012	Coredo	Trentino-Alto Adige	Trento	TN	15239
IT	38012	Mollaro	Trentino-Alto Adige	Trento	TN	15240
IT	38012	Smarano	Trentino-Alto Adige	Trento	TN	15241
IT	38012	Vervò	Trentino-Alto Adige	Trento	TN	15242
IT	38012	Dermulo	Trentino-Alto Adige	Trento	TN	15243
IT	38012	Taio	Trentino-Alto Adige	Trento	TN	15244
IT	38012	Tres	Trentino-Alto Adige	Trento	TN	15245
IT	38012	Segno	Trentino-Alto Adige	Trento	TN	15246
IT	38012	Predaia	Trentino-Alto Adige	Trento	TN	15247
IT	38013	Malosco	Trentino-Alto Adige	Trento	TN	15248
IT	38013	Vasio	Trentino-Alto Adige	Trento	TN	15249
IT	38013	Tret	Trentino-Alto Adige	Trento	TN	15250
IT	38013	Fondo	Trentino-Alto Adige	Trento	TN	15251
IT	38015	Lavis	Trentino-Alto Adige	Trento	TN	15252
IT	38015	Pressano	Trentino-Alto Adige	Trento	TN	15253
IT	38015	Nave San Felice	Trentino-Alto Adige	Trento	TN	15254
IT	38016	Mezzocorona	Trentino-Alto Adige	Trento	TN	15255
IT	38017	Mezzolombardo	Trentino-Alto Adige	Trento	TN	15256
IT	38018	Molveno	Trentino-Alto Adige	Trento	TN	15257
IT	38019	Tuenno	Trentino-Alto Adige	Trento	TN	15258
IT	38019	Nanno	Trentino-Alto Adige	Trento	TN	15259
IT	38019	Tassullo	Trentino-Alto Adige	Trento	TN	15260
IT	38020	Mestriago	Trentino-Alto Adige	Trento	TN	15261
IT	38020	Pracorno	Trentino-Alto Adige	Trento	TN	15262
IT	38020	Castelfondo	Trentino-Alto Adige	Trento	TN	15263
IT	38020	Mocenigo	Trentino-Alto Adige	Trento	TN	15264
IT	38020	Marcena	Trentino-Alto Adige	Trento	TN	15265
IT	38020	Pellizzano	Trentino-Alto Adige	Trento	TN	15266
IT	38020	Cis	Trentino-Alto Adige	Trento	TN	15267
IT	38020	Rumo	Trentino-Alto Adige	Trento	TN	15268
IT	38020	Mezzana	Trentino-Alto Adige	Trento	TN	15269
IT	38020	Bresimo	Trentino-Alto Adige	Trento	TN	15270
IT	38020	Commezzadura	Trentino-Alto Adige	Trento	TN	15271
IT	38020	Deggiano	Trentino-Alto Adige	Trento	TN	15272
IT	38020	Cloz	Trentino-Alto Adige	Trento	TN	15273
IT	38020	Rabbi	Trentino-Alto Adige	Trento	TN	15274
IT	38021	Brez	Trentino-Alto Adige	Trento	TN	15275
IT	38022	Bozzana	Trentino-Alto Adige	Trento	TN	15276
IT	38022	Caldes	Trentino-Alto Adige	Trento	TN	15277
IT	38022	Cavizzana	Trentino-Alto Adige	Trento	TN	15278
IT	38023	Cles	Trentino-Alto Adige	Trento	TN	15279
IT	38023	Caltron	Trentino-Alto Adige	Trento	TN	15280
IT	38023	Mechel	Trentino-Alto Adige	Trento	TN	15281
IT	38024	Peio	Trentino-Alto Adige	Trento	TN	15282
IT	38024	Cogolo In Val Di Pejo	Trentino-Alto Adige	Trento	TN	15283
IT	38024	Celledizzo	Trentino-Alto Adige	Trento	TN	15284
IT	38024	Celedizzo	Trentino-Alto Adige	Trento	TN	15285
IT	38024	Cogolo	Trentino-Alto Adige	Trento	TN	15286
IT	38025	Dimaro	Trentino-Alto Adige	Trento	TN	15287
IT	38025	Monclassico	Trentino-Alto Adige	Trento	TN	15288
IT	38026	Fucine Di Ossana	Trentino-Alto Adige	Trento	TN	15289
IT	38026	Ossana	Trentino-Alto Adige	Trento	TN	15290
IT	38026	Cusiano	Trentino-Alto Adige	Trento	TN	15291
IT	38026	Fucine	Trentino-Alto Adige	Trento	TN	15292
IT	38027	Terzolas	Trentino-Alto Adige	Trento	TN	15293
IT	38027	Male'	Trentino-Alto Adige	Trento	TN	15294
IT	38027	Croviana	Trentino-Alto Adige	Trento	TN	15295
IT	38028	Cagno'	Trentino-Alto Adige	Trento	TN	15296
IT	38028	Tregiovo	Trentino-Alto Adige	Trento	TN	15297
IT	38028	Revo'	Trentino-Alto Adige	Trento	TN	15298
IT	38028	Romallo	Trentino-Alto Adige	Trento	TN	15299
IT	38029	Fraviano	Trentino-Alto Adige	Trento	TN	15300
IT	38029	Passo Del Tonale	Trentino-Alto Adige	Trento	TN	15301
IT	38029	Vermiglio	Trentino-Alto Adige	Trento	TN	15302
IT	38030	Ziano Di Fiemme	Trentino-Alto Adige	Trento	TN	15303
IT	38030	Capriana	Trentino-Alto Adige	Trento	TN	15304
IT	38030	Campestrin	Trentino-Alto Adige	Trento	TN	15305
IT	38030	Molina	Trentino-Alto Adige	Trento	TN	15306
IT	38030	Rovere' Della Luna	Trentino-Alto Adige	Trento	TN	15307
IT	38030	Varena	Trentino-Alto Adige	Trento	TN	15308
IT	38030	Panchia'	Trentino-Alto Adige	Trento	TN	15309
IT	38030	Castello Molina Di Fiemme	Trentino-Alto Adige	Trento	TN	15310
IT	38030	Stramentizzo	Trentino-Alto Adige	Trento	TN	15311
IT	38030	Mazzin	Trentino-Alto Adige	Trento	TN	15312
IT	38030	Daiano	Trentino-Alto Adige	Trento	TN	15313
IT	38030	Verla	Trentino-Alto Adige	Trento	TN	15314
IT	38030	Soraga	Trentino-Alto Adige	Trento	TN	15315
IT	38030	Giovo	Trentino-Alto Adige	Trento	TN	15316
IT	38030	Stramentizzo Nuovo	Trentino-Alto Adige	Trento	TN	15317
IT	38030	Castello Di Fiemme	Trentino-Alto Adige	Trento	TN	15318
IT	38030	Palu'	Trentino-Alto Adige	Trento	TN	15319
IT	38030	Molina Di Fiemme	Trentino-Alto Adige	Trento	TN	15320
IT	38031	Campitello Di Fassa	Trentino-Alto Adige	Trento	TN	15321
IT	38032	Penia	Trentino-Alto Adige	Trento	TN	15322
IT	38032	Canazei	Trentino-Alto Adige	Trento	TN	15323
IT	38032	Alba Di Canazei	Trentino-Alto Adige	Trento	TN	15324
IT	38032	Sass Pordoi	Trentino-Alto Adige	Trento	TN	15325
IT	38033	Masi Di Cavalese	Trentino-Alto Adige	Trento	TN	15326
IT	38033	Carano	Trentino-Alto Adige	Trento	TN	15327
IT	38033	Cavalese	Trentino-Alto Adige	Trento	TN	15328
IT	38034	Lisignago	Trentino-Alto Adige	Trento	TN	15329
IT	38034	Cembra	Trentino-Alto Adige	Trento	TN	15330
IT	38035	Moena	Trentino-Alto Adige	Trento	TN	15331
IT	38035	Forno	Trentino-Alto Adige	Trento	TN	15332
IT	38035	Forno Di Fiemme	Trentino-Alto Adige	Trento	TN	15333
IT	38036	Pozza Di Fassa	Trentino-Alto Adige	Trento	TN	15334
IT	38036	Pera Di Fassa	Trentino-Alto Adige	Trento	TN	15335
IT	38036	Pera	Trentino-Alto Adige	Trento	TN	15336
IT	38037	Predazzo	Trentino-Alto Adige	Trento	TN	15337
IT	38037	Passo Rolle	Trentino-Alto Adige	Trento	TN	15338
IT	38037	Bellamonte	Trentino-Alto Adige	Trento	TN	15339
IT	38037	Paneveggio	Trentino-Alto Adige	Trento	TN	15340
IT	38038	Tesero	Trentino-Alto Adige	Trento	TN	15341
IT	38039	Costalunga	Trentino-Alto Adige	Trento	TN	15342
IT	38039	Vigo Di Fassa	Trentino-Alto Adige	Trento	TN	15343
IT	38039	Passo Costalunga	Trentino-Alto Adige	Trento	TN	15344
IT	38040	Fornace	Trentino-Alto Adige	Trento	TN	15345
IT	38040	Lona	Trentino-Alto Adige	Trento	TN	15346
IT	38040	Lases	Trentino-Alto Adige	Trento	TN	15347
IT	38040	Valfloriana	Trentino-Alto Adige	Trento	TN	15348
IT	38040	Ravina	Trentino-Alto Adige	Trento	TN	15349
IT	38040	Luserna	Trentino-Alto Adige	Trento	TN	15350
IT	38040	Lona Lases	Trentino-Alto Adige	Trento	TN	15351
IT	38041	Albiano	Trentino-Alto Adige	Trento	TN	15352
IT	38042	Campolongo	Trentino-Alto Adige	Trento	TN	15353
IT	38042	Montagnaga	Trentino-Alto Adige	Trento	TN	15354
IT	38042	Baselga Di Pine'	Trentino-Alto Adige	Trento	TN	15355
IT	38042	Faida Di Pine'	Trentino-Alto Adige	Trento	TN	15356
IT	38042	Rizzolaga	Trentino-Alto Adige	Trento	TN	15357
IT	38042	Faida	Trentino-Alto Adige	Trento	TN	15358
IT	38042	San Mauro	Trentino-Alto Adige	Trento	TN	15359
IT	38043	Regnana	Trentino-Alto Adige	Trento	TN	15360
IT	38043	Brusago	Trentino-Alto Adige	Trento	TN	15361
IT	38043	Bedollo	Trentino-Alto Adige	Trento	TN	15362
IT	38045	Civezzano	Trentino-Alto Adige	Trento	TN	15363
IT	38045	Seregnano	Trentino-Alto Adige	Trento	TN	15364
IT	38046	Cappella	Trentino-Alto Adige	Trento	TN	15365
IT	38046	Gionghi	Trentino-Alto Adige	Trento	TN	15366
IT	38046	Lavarone	Trentino-Alto Adige	Trento	TN	15367
IT	38046	Lavarone Cappella	Trentino-Alto Adige	Trento	TN	15368
IT	38047	Sevignano	Trentino-Alto Adige	Trento	TN	15369
IT	38047	Segonzano	Trentino-Alto Adige	Trento	TN	15370
IT	38047	Quaras	Trentino-Alto Adige	Trento	TN	15371
IT	38047	Valcava	Trentino-Alto Adige	Trento	TN	15372
IT	38048	Sover	Trentino-Alto Adige	Trento	TN	15373
IT	38049	Bosentino	Trentino-Alto Adige	Trento	TN	15374
IT	38049	Centa San Nicolo'	Trentino-Alto Adige	Trento	TN	15375
IT	38049	Vigolo Vattaro	Trentino-Alto Adige	Trento	TN	15376
IT	38049	Migazzone	Trentino-Alto Adige	Trento	TN	15377
IT	38049	Vattaro	Trentino-Alto Adige	Trento	TN	15378
IT	38050	Telve Di Sopra	Trentino-Alto Adige	Trento	TN	15379
IT	38050	Imer	Trentino-Alto Adige	Trento	TN	15380
IT	38050	Scurelle	Trentino-Alto Adige	Trento	TN	15381
IT	38050	Fierozzo	Trentino-Alto Adige	Trento	TN	15382
IT	38050	Prade	Trentino-Alto Adige	Trento	TN	15383
IT	38050	Ronchi Valsugana	Trentino-Alto Adige	Trento	TN	15384
IT	38050	Novaledo	Trentino-Alto Adige	Trento	TN	15385
IT	38050	Castelnuovo	Trentino-Alto Adige	Trento	TN	15386
IT	38050	Calceranica Al Lago	Trentino-Alto Adige	Trento	TN	15387
IT	38050	Telve	Trentino-Alto Adige	Trento	TN	15388
IT	38050	Bieno	Trentino-Alto Adige	Trento	TN	15389
IT	38050	Caoria	Trentino-Alto Adige	Trento	TN	15390
IT	38050	Roncegno	Trentino-Alto Adige	Trento	TN	15391
IT	38050	Palu' Del Fersina	Trentino-Alto Adige	Trento	TN	15392
IT	38050	Carzano	Trentino-Alto Adige	Trento	TN	15393
IT	38050	Mezzano	Trentino-Alto Adige	Trento	TN	15394
IT	38050	Frassilongo	Trentino-Alto Adige	Trento	TN	15395
IT	38050	Tenna	Trentino-Alto Adige	Trento	TN	15396
IT	38050	Telve Di Valsugana	Trentino-Alto Adige	Trento	TN	15397
IT	38050	Torcegno	Trentino-Alto Adige	Trento	TN	15398
IT	38050	Marter	Trentino-Alto Adige	Trento	TN	15399
IT	38050	Cinte Tesino	Trentino-Alto Adige	Trento	TN	15400
IT	38050	Pieve Tesino	Trentino-Alto Adige	Trento	TN	15401
IT	38050	Sant'Orsola Terme	Trentino-Alto Adige	Trento	TN	15402
IT	38050	Sagron Mis	Trentino-Alto Adige	Trento	TN	15403
IT	38050	San Francesco	Trentino-Alto Adige	Trento	TN	15404
IT	38050	Canal San Bovo	Trentino-Alto Adige	Trento	TN	15405
IT	38050	Monte Di Mezzo	Trentino-Alto Adige	Trento	TN	15406
IT	38050	Ospedaletto	Trentino-Alto Adige	Trento	TN	15407
IT	38050	Gobbera	Trentino-Alto Adige	Trento	TN	15408
IT	38050	Santa Brigida	Trentino-Alto Adige	Trento	TN	15409
IT	38051	Borgo	Trentino-Alto Adige	Trento	TN	15410
IT	38051	Olle	Trentino-Alto Adige	Trento	TN	15411
IT	38051	Borgo Valsugana	Trentino-Alto Adige	Trento	TN	15412
IT	38052	Caldonazzo	Trentino-Alto Adige	Trento	TN	15413
IT	38053	Castello Tesino	Trentino-Alto Adige	Trento	TN	15414
IT	38054	San Martino Di Castrozza	Trentino-Alto Adige	Trento	TN	15415
IT	38054	Transacqua	Trentino-Alto Adige	Trento	TN	15416
IT	38054	Fiera Di Primiero	Trentino-Alto Adige	Trento	TN	15417
IT	38054	Siror	Trentino-Alto Adige	Trento	TN	15418
IT	38054	Tonadico	Trentino-Alto Adige	Trento	TN	15419
IT	38055	Tezze	Trentino-Alto Adige	Trento	TN	15420
IT	38055	Tezze Val Sugana	Trentino-Alto Adige	Trento	TN	15421
IT	38055	Selva Di Grigno	Trentino-Alto Adige	Trento	TN	15422
IT	38055	Grigno	Trentino-Alto Adige	Trento	TN	15423
IT	38055	Selva	Trentino-Alto Adige	Trento	TN	15424
IT	38056	Barco	Trentino-Alto Adige	Trento	TN	15425
IT	38056	Levico Terme	Trentino-Alto Adige	Trento	TN	15426
IT	38057	Serso	Trentino-Alto Adige	Trento	TN	15427
IT	38057	Vignola	Trentino-Alto Adige	Trento	TN	15428
IT	38057	Susa'	Trentino-Alto Adige	Trento	TN	15429
IT	38057	Viarago	Trentino-Alto Adige	Trento	TN	15430
IT	38057	Canzolino	Trentino-Alto Adige	Trento	TN	15431
IT	38057	Costasavina	Trentino-Alto Adige	Trento	TN	15432
IT	38057	Canezza	Trentino-Alto Adige	Trento	TN	15433
IT	38057	Pergine Valsugana	Trentino-Alto Adige	Trento	TN	15434
IT	38057	Vigalzano	Trentino-Alto Adige	Trento	TN	15435
IT	38057	Falesina	Trentino-Alto Adige	Trento	TN	15436
IT	38057	Madrano	Trentino-Alto Adige	Trento	TN	15437
IT	38057	Canale	Trentino-Alto Adige	Trento	TN	15438
IT	38057	Roncogno	Trentino-Alto Adige	Trento	TN	15439
IT	38057	San Cristoforo	Trentino-Alto Adige	Trento	TN	15440
IT	38057	San Cristoforo Al Lago	Trentino-Alto Adige	Trento	TN	15441
IT	38057	Vignola Falesina	Trentino-Alto Adige	Trento	TN	15442
IT	38057	Ischia Trentina	Trentino-Alto Adige	Trento	TN	15443
IT	38059	Spera	Trentino-Alto Adige	Trento	TN	15444
IT	38059	Samone	Trentino-Alto Adige	Trento	TN	15445
IT	38059	Strigno	Trentino-Alto Adige	Trento	TN	15446
IT	38059	Villa Agnedo	Trentino-Alto Adige	Trento	TN	15447
IT	38059	Agnedo	Trentino-Alto Adige	Trento	TN	15448
IT	38059	Ivano Fracena	Trentino-Alto Adige	Trento	TN	15449
IT	38060	Volano	Trentino-Alto Adige	Trento	TN	15450
IT	38060	Cornale'	Trentino-Alto Adige	Trento	TN	15451
IT	38060	Nomi	Trentino-Alto Adige	Trento	TN	15452
IT	38060	Nogaredo	Trentino-Alto Adige	Trento	TN	15453
IT	38060	Anghebeni	Trentino-Alto Adige	Trento	TN	15454
IT	38060	Cologna	Trentino-Alto Adige	Trento	TN	15455
IT	38060	Tenno	Trentino-Alto Adige	Trento	TN	15456
IT	38060	Aldeno	Trentino-Alto Adige	Trento	TN	15457
IT	38060	Anghebeni Di Vallarsa	Trentino-Alto Adige	Trento	TN	15458
IT	38060	Pieve Di Ledro	Trentino-Alto Adige	Trento	TN	15459
IT	38060	Villa Lagarina	Trentino-Alto Adige	Trento	TN	15460
IT	38060	Bezzecca	Trentino-Alto Adige	Trento	TN	15461
IT	38060	Isera	Trentino-Alto Adige	Trento	TN	15462
IT	38060	Valmorbia	Trentino-Alto Adige	Trento	TN	15463
IT	38060	Valduga	Trentino-Alto Adige	Trento	TN	15464
IT	38060	Gavazzo Nuova	Trentino-Alto Adige	Trento	TN	15465
IT	38060	Vallarsa	Trentino-Alto Adige	Trento	TN	15466
IT	38060	Castione	Trentino-Alto Adige	Trento	TN	15467
IT	38060	Besenello	Trentino-Alto Adige	Trento	TN	15468
IT	38060	Pomarolo	Trentino-Alto Adige	Trento	TN	15469
IT	38060	Raossi Di Vallarsa	Trentino-Alto Adige	Trento	TN	15470
IT	38060	Tiarno Di Sotto	Trentino-Alto Adige	Trento	TN	15471
IT	38060	Ronzo Chienis	Trentino-Alto Adige	Trento	TN	15472
IT	38060	Tiarno Di Sopra	Trentino-Alto Adige	Trento	TN	15473
IT	38060	Pedersano	Trentino-Alto Adige	Trento	TN	15474
IT	38060	Concei	Trentino-Alto Adige	Trento	TN	15475
IT	38060	Romagnano	Trentino-Alto Adige	Trento	TN	15476
IT	38060	Terragnolo	Trentino-Alto Adige	Trento	TN	15477
IT	38060	Ronzo	Trentino-Alto Adige	Trento	TN	15478
IT	38060	Crosano	Trentino-Alto Adige	Trento	TN	15479
IT	38060	Pregasina	Trentino-Alto Adige	Trento	TN	15480
IT	38060	Castellano	Trentino-Alto Adige	Trento	TN	15481
IT	38060	Cimone	Trentino-Alto Adige	Trento	TN	15482
IT	38060	Brentonico	Trentino-Alto Adige	Trento	TN	15483
IT	38060	Garniga Terme	Trentino-Alto Adige	Trento	TN	15484
IT	38060	Raossi	Trentino-Alto Adige	Trento	TN	15485
IT	38060	Riva Di Vallarsa	Trentino-Alto Adige	Trento	TN	15486
IT	38060	Molina Di Ledro	Trentino-Alto Adige	Trento	TN	15487
IT	38060	Chienis	Trentino-Alto Adige	Trento	TN	15488
IT	38060	Corte	Trentino-Alto Adige	Trento	TN	15489
IT	38061	Ala	Trentino-Alto Adige	Trento	TN	15490
IT	38061	Pilcante	Trentino-Alto Adige	Trento	TN	15491
IT	38061	Santa Margherita	Trentino-Alto Adige	Trento	TN	15492
IT	38061	Chizzola	Trentino-Alto Adige	Trento	TN	15493
IT	38061	Serravalle	Trentino-Alto Adige	Trento	TN	15494
IT	38061	Serravalle All'Adige	Trentino-Alto Adige	Trento	TN	15495
IT	38061	Sega Dei Lessini	Trentino-Alto Adige	Trento	TN	15496
IT	38062	Bolognano	Trentino-Alto Adige	Trento	TN	15497
IT	38062	San Giorgio	Trentino-Alto Adige	Trento	TN	15498
IT	38062	Oltresarca	Trentino-Alto Adige	Trento	TN	15499
IT	38062	Vignole	Trentino-Alto Adige	Trento	TN	15500
IT	38062	Arco	Trentino-Alto Adige	Trento	TN	15501
IT	38063	Sabbionara	Trentino-Alto Adige	Trento	TN	15502
IT	38063	Avio	Trentino-Alto Adige	Trento	TN	15503
IT	38063	Borghetto All'Adige	Trentino-Alto Adige	Trento	TN	15504
IT	38064	Serrada	Trentino-Alto Adige	Trento	TN	15505
IT	38064	San Sebastiano	Trentino-Alto Adige	Trento	TN	15506
IT	38064	Folgaria	Trentino-Alto Adige	Trento	TN	15507
IT	38064	Mezzomonte Di Sopra	Trentino-Alto Adige	Trento	TN	15508
IT	38064	Mezzomonte Di Sotto	Trentino-Alto Adige	Trento	TN	15509
IT	38064	Carbonare Di Folgaria	Trentino-Alto Adige	Trento	TN	15510
IT	38064	Serrada Di Folgaria	Trentino-Alto Adige	Trento	TN	15511
IT	38064	Nosellari	Trentino-Alto Adige	Trento	TN	15512
IT	38064	Mezzomonte	Trentino-Alto Adige	Trento	TN	15513
IT	38064	Carbonare	Trentino-Alto Adige	Trento	TN	15514
IT	38065	Mori	Trentino-Alto Adige	Trento	TN	15515
IT	38065	Pannone	Trentino-Alto Adige	Trento	TN	15516
IT	38065	Manzano	Trentino-Alto Adige	Trento	TN	15517
IT	38065	Besagno	Trentino-Alto Adige	Trento	TN	15518
IT	38065	Sano	Trentino-Alto Adige	Trento	TN	15519
IT	38065	Valle San Felice	Trentino-Alto Adige	Trento	TN	15520
IT	38066	Riva Del Garda	Trentino-Alto Adige	Trento	TN	15521
IT	38066	Varone	Trentino-Alto Adige	Trento	TN	15522
IT	38067	Mezzolago	Trentino-Alto Adige	Trento	TN	15523
IT	38067	Ledro	Trentino-Alto Adige	Trento	TN	15524
IT	38067	Biacesa Di Ledro	Trentino-Alto Adige	Trento	TN	15525
IT	38068	Trambileno	Trentino-Alto Adige	Trento	TN	15526
IT	38068	Borgo Sacco	Trentino-Alto Adige	Trento	TN	15527
IT	38068	Lizzanella	Trentino-Alto Adige	Trento	TN	15528
IT	38068	Rovereto	Trentino-Alto Adige	Trento	TN	15529
IT	38068	Marco	Trentino-Alto Adige	Trento	TN	15530
IT	38068	Mori Ferrovia	Trentino-Alto Adige	Trento	TN	15531
IT	38069	Torbole	Trentino-Alto Adige	Trento	TN	15532
IT	38069	Nago Torbole	Trentino-Alto Adige	Trento	TN	15533
IT	38069	Nago	Trentino-Alto Adige	Trento	TN	15534
IT	38070	Villa Banale	Trentino-Alto Adige	Trento	TN	15535
IT	38070	Tavodo	Trentino-Alto Adige	Trento	TN	15536
IT	38070	Stenico	Trentino-Alto Adige	Trento	TN	15537
IT	38070	Lomaso	Trentino-Alto Adige	Trento	TN	15538
IT	38071	Bleggio Superiore	Trentino-Alto Adige	Trento	TN	15539
IT	38071	Bivedo	Trentino-Alto Adige	Trento	TN	15540
IT	38071	Bleggio Inferiore	Trentino-Alto Adige	Trento	TN	15541
IT	38071	Larido	Trentino-Alto Adige	Trento	TN	15542
IT	38071	Marazzone	Trentino-Alto Adige	Trento	TN	15543
IT	38073	Vigo	Trentino-Alto Adige	Trento	TN	15544
IT	38073	Stravino	Trentino-Alto Adige	Trento	TN	15545
IT	38073	Cavedine	Trentino-Alto Adige	Trento	TN	15546
IT	38073	Vigo Cavedine	Trentino-Alto Adige	Trento	TN	15547
IT	38074	Pietramurata	Trentino-Alto Adige	Trento	TN	15548
IT	38074	Dro	Trentino-Alto Adige	Trento	TN	15549
IT	38074	Drena	Trentino-Alto Adige	Trento	TN	15550
IT	38074	Ceniga	Trentino-Alto Adige	Trento	TN	15551
IT	38075	Fiave'	Trentino-Alto Adige	Trento	TN	15552
IT	38075	Ballino	Trentino-Alto Adige	Trento	TN	15553
IT	38076	Lasino	Trentino-Alto Adige	Trento	TN	15554
IT	38076	Calavino	Trentino-Alto Adige	Trento	TN	15555
IT	38076	Castel Madruzzo	Trentino-Alto Adige	Trento	TN	15556
IT	38076	Sarche	Trentino-Alto Adige	Trento	TN	15557
IT	38076	Madruzzo	Trentino-Alto Adige	Trento	TN	15558
IT	38077	Vigo Lomaso	Trentino-Alto Adige	Trento	TN	15559
IT	38077	Lundo	Trentino-Alto Adige	Trento	TN	15560
IT	38077	Ponte Arche	Trentino-Alto Adige	Trento	TN	15561
IT	38077	Bagni Di Comano	Trentino-Alto Adige	Trento	TN	15562
IT	38077	Comano Terme	Trentino-Alto Adige	Trento	TN	15563
IT	38078	Dorsino	Trentino-Alto Adige	Trento	TN	15564
IT	38078	Moline	Trentino-Alto Adige	Trento	TN	15565
IT	38078	San Lorenzo In Banale	Trentino-Alto Adige	Trento	TN	15566
IT	38078	San Lorenzo Dorsino	Trentino-Alto Adige	Trento	TN	15567
IT	38078	Moline Di Banale	Trentino-Alto Adige	Trento	TN	15568
IT	38079	Zuclo	Trentino-Alto Adige	Trento	TN	15569
IT	38079	Saone	Trentino-Alto Adige	Trento	TN	15570
IT	38079	Tione Di Trento	Trentino-Alto Adige	Trento	TN	15571
IT	38079	Bolbeno	Trentino-Alto Adige	Trento	TN	15572
IT	38079	Pelugo	Trentino-Alto Adige	Trento	TN	15573
IT	38080	Caderzone	Trentino-Alto Adige	Trento	TN	15574
IT	38080	Bondone	Trentino-Alto Adige	Trento	TN	15575
IT	38080	Baitoni	Trentino-Alto Adige	Trento	TN	15576
IT	38080	Bocenago	Trentino-Alto Adige	Trento	TN	15577
IT	38080	Strembo	Trentino-Alto Adige	Trento	TN	15578
IT	38080	Iavre' Vigo Rendena	Trentino-Alto Adige	Trento	TN	15579
IT	38080	Carisolo	Trentino-Alto Adige	Trento	TN	15580
IT	38082	Castel Condino	Trentino-Alto Adige	Trento	TN	15581
IT	38083	Brione	Trentino-Alto Adige	Trento	TN	15582
IT	38083	Cimego	Trentino-Alto Adige	Trento	TN	15583
IT	38083	Condino	Trentino-Alto Adige	Trento	TN	15584
IT	38085	Prezzo	Trentino-Alto Adige	Trento	TN	15585
IT	38085	Creto	Trentino-Alto Adige	Trento	TN	15586
IT	38085	Pieve Di Bono	Trentino-Alto Adige	Trento	TN	15587
IT	38086	Madonna Di Campiglio	Trentino-Alto Adige	Trento	TN	15588
IT	38086	Giustino	Trentino-Alto Adige	Trento	TN	15589
IT	38086	Massimeno	Trentino-Alto Adige	Trento	TN	15590
IT	38086	Pinzolo	Trentino-Alto Adige	Trento	TN	15591
IT	38086	Sant'Antonio Di Mavignola	Trentino-Alto Adige	Trento	TN	15592
IT	38087	Roncone	Trentino-Alto Adige	Trento	TN	15593
IT	38087	Lardaro	Trentino-Alto Adige	Trento	TN	15594
IT	38087	Bondo	Trentino-Alto Adige	Trento	TN	15595
IT	38087	Breguzzo	Trentino-Alto Adige	Trento	TN	15596
IT	38088	Spiazzo Rendena	Trentino-Alto Adige	Trento	TN	15597
IT	38088	Spiazzo	Trentino-Alto Adige	Trento	TN	15598
IT	38089	Darzo	Trentino-Alto Adige	Trento	TN	15599
IT	38089	Storo	Trentino-Alto Adige	Trento	TN	15600
IT	38089	Lodrone	Trentino-Alto Adige	Trento	TN	15601
IT	38091	Bersone	Trentino-Alto Adige	Trento	TN	15602
IT	38091	Daone	Trentino-Alto Adige	Trento	TN	15603
IT	38091	Praso	Trentino-Alto Adige	Trento	TN	15604
IT	38091	Valdaone	Trentino-Alto Adige	Trento	TN	15605
IT	38092	Grauno	Trentino-Alto Adige	Trento	TN	15606
IT	38092	Grumes	Trentino-Alto Adige	Trento	TN	15607
IT	38092	Valda	Trentino-Alto Adige	Trento	TN	15608
IT	38092	Faver	Trentino-Alto Adige	Trento	TN	15609
IT	38093	Terres	Trentino-Alto Adige	Trento	TN	15610
IT	38093	Flavon	Trentino-Alto Adige	Trento	TN	15611
IT	38093	Cunevo	Trentino-Alto Adige	Trento	TN	15612
IT	38094	Vigo Rendena	Trentino-Alto Adige	Trento	TN	15613
IT	38094	Iavre'	Trentino-Alto Adige	Trento	TN	15614
IT	38094	Villa Rendena	Trentino-Alto Adige	Trento	TN	15615
IT	38094	Verdesina	Trentino-Alto Adige	Trento	TN	15616
IT	38094	Dare'	Trentino-Alto Adige	Trento	TN	15617
IT	38095	Preore	Trentino-Alto Adige	Trento	TN	15618
IT	38095	Ragoli	Trentino-Alto Adige	Trento	TN	15619
IT	38095	Montagne	Trentino-Alto Adige	Trento	TN	15620
IT	38096	Ranzo	Trentino-Alto Adige	Trento	TN	15621
IT	38096	Terlago	Trentino-Alto Adige	Trento	TN	15622
IT	38096	Vezzano	Trentino-Alto Adige	Trento	TN	15623
IT	38096	Margone	Trentino-Alto Adige	Trento	TN	15624
IT	38096	Padergnone	Trentino-Alto Adige	Trento	TN	15625
IT	38100	Povo	Trentino-Alto Adige	Trento	TN	15626
IT	38100	Sopramonte	Trentino-Alto Adige	Trento	TN	15627
IT	38100	Baselga Del Bondone	Trentino-Alto Adige	Trento	TN	15628
IT	38100	Cognola	Trentino-Alto Adige	Trento	TN	15629
IT	38100	Villamontagna	Trentino-Alto Adige	Trento	TN	15630
IT	38100	Mattarello	Trentino-Alto Adige	Trento	TN	15631
IT	38100	Vigolo Baselga	Trentino-Alto Adige	Trento	TN	15632
IT	38100	Sardagna	Trentino-Alto Adige	Trento	TN	15633
IT	38100	Valsorda	Trentino-Alto Adige	Trento	TN	15634
IT	38100	Vaneze	Trentino-Alto Adige	Trento	TN	15635
IT	38100	Cadine	Trentino-Alto Adige	Trento	TN	15636
IT	38100	Gardolo	Trentino-Alto Adige	Trento	TN	15637
IT	38100	Montevaccino	Trentino-Alto Adige	Trento	TN	15638
IT	38100	Baselga Di Vezzano	Trentino-Alto Adige	Trento	TN	15639
IT	38100	Vela	Trentino-Alto Adige	Trento	TN	15640
IT	38100	Gardolo Di Mezzo	Trentino-Alto Adige	Trento	TN	15641
IT	38100	Trento	Trentino-Alto Adige	Trento	TN	15642
IT	38100	Martignano	Trentino-Alto Adige	Trento	TN	15643
IT	38100	Villazzano	Trentino-Alto Adige	Trento	TN	15644
IT	38100	Vigo Meano	Trentino-Alto Adige	Trento	TN	15645
IT	38100	Meano	Trentino-Alto Adige	Trento	TN	15646
IT	38100	Vaneze Di Bondone	Trentino-Alto Adige	Trento	TN	15647
IT	38121	Trento	Trentino-Alto Adige	Trento	TN	15648
IT	6010	Monte Santa Maria Tiberina	Umbria	Perugia	PG	15649
IT	6010	Citerna	Umbria	Perugia	PG	15650
IT	6010	Fighille	Umbria	Perugia	PG	15651
IT	6010	Lippiano	Umbria	Perugia	PG	15652
IT	6012	Cinquemiglia	Umbria	Perugia	PG	15653
IT	6012	Lerchi	Umbria	Perugia	PG	15654
IT	6012	Citta' Di Castello	Umbria	Perugia	PG	15655
IT	6012	San Secondo	Umbria	Perugia	PG	15656
IT	6012	San Maiano	Umbria	Perugia	PG	15657
IT	6012	Promano	Umbria	Perugia	PG	15658
IT	6012	Muccignano	Umbria	Perugia	PG	15659
IT	6012	Piosina	Umbria	Perugia	PG	15660
IT	6012	Fraccano	Umbria	Perugia	PG	15661
IT	6012	Cerbara	Umbria	Perugia	PG	15662
IT	6012	Riosecco	Umbria	Perugia	PG	15663
IT	6012	Morra	Umbria	Perugia	PG	15664
IT	6014	Montone	Umbria	Perugia	PG	15665
IT	6016	Selci	Umbria	Perugia	PG	15666
IT	6016	San Giustino	Umbria	Perugia	PG	15667
IT	6016	Lama	Umbria	Perugia	PG	15668
IT	6018	Petroia	Umbria	Perugia	PG	15669
IT	6018	Lugnano	Umbria	Perugia	PG	15670
IT	6018	Badia Petroia	Umbria	Perugia	PG	15671
IT	6018	San Leo Bastia	Umbria	Perugia	PG	15672
IT	6018	Petrelle	Umbria	Perugia	PG	15673
IT	6018	Lugnano Citta' Di Castello	Umbria	Perugia	PG	15674
IT	6018	Pistrino	Umbria	Perugia	PG	15675
IT	6018	Trestina	Umbria	Perugia	PG	15676
IT	6019	Montecastelli	Umbria	Perugia	PG	15677
IT	6019	Preggio	Umbria	Perugia	PG	15678
IT	6019	Verna	Umbria	Perugia	PG	15679
IT	6019	Umbertide	Umbria	Perugia	PG	15680
IT	6019	Pierantonio	Umbria	Perugia	PG	15681
IT	6019	Montecastelli Umbro	Umbria	Perugia	PG	15682
IT	6020	Branca	Umbria	Perugia	PG	15683
IT	6020	Torre Dei Calzolari	Umbria	Perugia	PG	15684
IT	6021	Villa Col Dei Canali	Umbria	Perugia	PG	15685
IT	6021	Costacciaro	Umbria	Perugia	PG	15686
IT	6021	Villa Col De' Canali	Umbria	Perugia	PG	15687
IT	6022	Purello	Umbria	Perugia	PG	15688
IT	6022	Fossato Di Vico	Umbria	Perugia	PG	15689
IT	6022	Osteria Del Gatto	Umbria	Perugia	PG	15690
IT	6022	Fossato Di Vico Stazione	Umbria	Perugia	PG	15691
IT	6023	Gualdo Tadino	Umbria	Perugia	PG	15692
IT	6023	Morano Madonnuccia	Umbria	Perugia	PG	15693
IT	6023	San Pellegrino	Umbria	Perugia	PG	15694
IT	6023	Pieve Di Compresseto	Umbria	Perugia	PG	15695
IT	6023	Cerqueto	Umbria	Perugia	PG	15696
IT	6023	San Pellegrino Di Gualdo Tadino	Umbria	Perugia	PG	15697
IT	6023	Morano	Umbria	Perugia	PG	15698
IT	6024	San Benedetto Vecchio	Umbria	Perugia	PG	15699
IT	6024	Camporeggiano	Umbria	Perugia	PG	15700
IT	6024	Ponte D'Assi	Umbria	Perugia	PG	15701
IT	6024	Casamorcia	Umbria	Perugia	PG	15702
IT	6024	Stazione Di Padule	Umbria	Perugia	PG	15703
IT	6024	Mocaiana	Umbria	Perugia	PG	15704
IT	6024	Colpalombo	Umbria	Perugia	PG	15705
IT	6024	Gubbio	Umbria	Perugia	PG	15706
IT	6024	Cipolleto	Umbria	Perugia	PG	15707
IT	6024	Padule	Umbria	Perugia	PG	15708
IT	6024	Scritto	Umbria	Perugia	PG	15709
IT	6024	Torre Calzolari	Umbria	Perugia	PG	15710
IT	6024	Caicambiucci	Umbria	Perugia	PG	15711
IT	6024	Semonte	Umbria	Perugia	PG	15712
IT	6024	Mocaiana Stazione	Umbria	Perugia	PG	15713
IT	6025	Molinaccio	Umbria	Perugia	PG	15714
IT	6025	Gaifana	Umbria	Perugia	PG	15715
IT	6025	Nocera Umbra	Umbria	Perugia	PG	15716
IT	6026	Pietralunga	Umbria	Perugia	PG	15717
IT	6027	Pascelupo	Umbria	Perugia	PG	15718
IT	6027	Isola Fossara	Umbria	Perugia	PG	15719
IT	6027	Scheggia	Umbria	Perugia	PG	15720
IT	6027	Scheggia E Pascelupo	Umbria	Perugia	PG	15721
IT	6028	Sigillo	Umbria	Perugia	PG	15722
IT	6029	Casa Castalda	Umbria	Perugia	PG	15723
IT	6029	Valfabbrica	Umbria	Perugia	PG	15724
IT	6030	Sellano	Umbria	Perugia	PG	15725
IT	6030	Bastardo	Umbria	Perugia	PG	15726
IT	6030	Valtopina	Umbria	Perugia	PG	15727
IT	6030	Giano Dell'Umbria	Umbria	Perugia	PG	15728
IT	6030	Cammoro	Umbria	Perugia	PG	15729
IT	6030	Orsano E Cammoro	Umbria	Perugia	PG	15730
IT	6031	Cantalupo	Umbria	Perugia	PG	15731
IT	6031	Bevagna	Umbria	Perugia	PG	15732
IT	6033	Cannara	Umbria	Perugia	PG	15733
IT	6034	Colfiorito	Umbria	Perugia	PG	15734
IT	6034	Rasiglia	Umbria	Perugia	PG	15735
IT	6034	Capodacqua	Umbria	Perugia	PG	15736
IT	6034	Scafali	Umbria	Perugia	PG	15737
IT	6034	Uppello	Umbria	Perugia	PG	15738
IT	6034	Foligno	Umbria	Perugia	PG	15739
IT	6034	Annifo	Umbria	Perugia	PG	15740
IT	6034	Casenove	Umbria	Perugia	PG	15741
IT	6034	Verchiano	Umbria	Perugia	PG	15742
IT	6034	Sant'Eraclio	Umbria	Perugia	PG	15743
IT	6034	Scopoli	Umbria	Perugia	PG	15744
IT	6034	Scanzano	Umbria	Perugia	PG	15745
IT	6034	Pale	Umbria	Perugia	PG	15746
IT	6034	Pieve Fanonica	Umbria	Perugia	PG	15747
IT	6034	Belfiore	Umbria	Perugia	PG	15748
IT	6034	San Giovanni Profiamma	Umbria	Perugia	PG	15749
IT	6034	Fiamenga	Umbria	Perugia	PG	15750
IT	6034	Sterpete	Umbria	Perugia	PG	15751
IT	6034	Perticani	Umbria	Perugia	PG	15752
IT	6035	Gualdo Cattaneo	Umbria	Perugia	PG	15753
IT	6035	San Terenziano	Umbria	Perugia	PG	15754
IT	6035	Pozzo	Umbria	Perugia	PG	15755
IT	6035	Marcellano	Umbria	Perugia	PG	15756
IT	6035	Collesecco	Umbria	Perugia	PG	15757
IT	6035	Pozzo Di Gualdo Cattaneo	Umbria	Perugia	PG	15758
IT	6036	Montefalco	Umbria	Perugia	PG	15759
IT	6036	Madonna Della Stella	Umbria	Perugia	PG	15760
IT	6036	San Marco Di Montefalco	Umbria	Perugia	PG	15761
IT	6038	Spello	Umbria	Perugia	PG	15762
IT	6038	Capitan Loreto	Umbria	Perugia	PG	15763
IT	6039	Matigge	Umbria	Perugia	PG	15764
IT	6039	Cannaiola	Umbria	Perugia	PG	15765
IT	6039	Trevi	Umbria	Perugia	PG	15766
IT	6039	Santa Maria In Valle	Umbria	Perugia	PG	15767
IT	6039	Li Celli	Umbria	Perugia	PG	15768
IT	6039	Borgo Di Trevi	Umbria	Perugia	PG	15769
IT	6040	Sant'Anatolia Di Narco	Umbria	Perugia	PG	15770
IT	6040	Poggiodomo	Umbria	Perugia	PG	15771
IT	6040	Vallo Di Nera	Umbria	Perugia	PG	15772
IT	6040	Piedipaterno Sul Nera	Umbria	Perugia	PG	15773
IT	6040	Piedipaterno	Umbria	Perugia	PG	15774
IT	6040	Ceselli	Umbria	Perugia	PG	15775
IT	6040	Scheggino	Umbria	Perugia	PG	15776
IT	6041	Borgo Cerreto	Umbria	Perugia	PG	15777
IT	6041	Triponzo	Umbria	Perugia	PG	15778
IT	6041	Bugiano	Umbria	Perugia	PG	15779
IT	6041	Cerreto Di Spoleto	Umbria	Perugia	PG	15780
IT	6042	Campello Sul Clitunno	Umbria	Perugia	PG	15781
IT	6043	Cascia	Umbria	Perugia	PG	15782
IT	6043	Maltignano Di Cascia	Umbria	Perugia	PG	15783
IT	6043	Chiavano	Umbria	Perugia	PG	15784
IT	6044	Bruna	Umbria	Perugia	PG	15785
IT	6044	Castel Ritaldi	Umbria	Perugia	PG	15786
IT	6045	Monteleone Di Spoleto	Umbria	Perugia	PG	15787
IT	6046	Savelli Di Norcia	Umbria	Perugia	PG	15788
IT	6046	San Pellegrino Di Norcia	Umbria	Perugia	PG	15789
IT	6046	Serravalle	Umbria	Perugia	PG	15790
IT	6046	Castelluccio	Umbria	Perugia	PG	15791
IT	6046	Ancarano	Umbria	Perugia	PG	15792
IT	6046	Norcia	Umbria	Perugia	PG	15793
IT	6046	Agriano	Umbria	Perugia	PG	15794
IT	6046	Serravalle Di Norcia	Umbria	Perugia	PG	15795
IT	6047	Piedivalle	Umbria	Perugia	PG	15796
IT	6047	Preci	Umbria	Perugia	PG	15797
IT	6047	Abeto	Umbria	Perugia	PG	15798
IT	6047	Roccanolfi	Umbria	Perugia	PG	15799
IT	6047	Belforte	Umbria	Perugia	PG	15800
IT	6047	Casali Belforte	Umbria	Perugia	PG	15801
IT	6049	Montemartano	Umbria	Perugia	PG	15802
IT	6049	San Martino In Trignano	Umbria	Perugia	PG	15803
IT	6049	Maiano	Umbria	Perugia	PG	15804
IT	6049	Cortaccione	Umbria	Perugia	PG	15805
IT	6049	San Brizio	Umbria	Perugia	PG	15806
IT	6049	Sant'Angelo In Mercole	Umbria	Perugia	PG	15807
IT	6049	San Giacomo	Umbria	Perugia	PG	15808
IT	6049	Morgnano	Umbria	Perugia	PG	15809
IT	6049	Eggi	Umbria	Perugia	PG	15810
IT	6049	Baiano Di Spoleto	Umbria	Perugia	PG	15811
IT	6049	Strettura	Umbria	Perugia	PG	15812
IT	6049	Madonna Di Baiano	Umbria	Perugia	PG	15813
IT	6049	Beroide	Umbria	Perugia	PG	15814
IT	6049	San Giovanni Di Baiano	Umbria	Perugia	PG	15815
IT	6049	Spoleto	Umbria	Perugia	PG	15816
IT	6049	Terzo La Pieve	Umbria	Perugia	PG	15817
IT	6049	Bazzano Inferiore	Umbria	Perugia	PG	15818
IT	6049	San Giacomo Di Spoleto	Umbria	Perugia	PG	15819
IT	6050	Piedicolle	Umbria	Perugia	PG	15820
IT	6050	Collazzone	Umbria	Perugia	PG	15821
IT	6050	Casalalta	Umbria	Perugia	PG	15822
IT	6050	Collepepe	Umbria	Perugia	PG	15823
IT	6051	Ripabianca	Umbria	Perugia	PG	15824
IT	6051	Casalina	Umbria	Perugia	PG	15825
IT	6053	San Nicolo' Di Celle	Umbria	Perugia	PG	15826
IT	6053	Sant'Angelo Di Celle	Umbria	Perugia	PG	15827
IT	6053	Deruta	Umbria	Perugia	PG	15828
IT	6053	Ponte Nuovo	Umbria	Perugia	PG	15829
IT	6053	San Niccolo' Di Celle	Umbria	Perugia	PG	15830
IT	6054	Fratta Todina	Umbria	Perugia	PG	15831
IT	6055	Papiano	Umbria	Perugia	PG	15832
IT	6055	San Valentino Della Collina	Umbria	Perugia	PG	15833
IT	6055	Marsciano	Umbria	Perugia	PG	15834
IT	6055	San Valentino	Umbria	Perugia	PG	15835
IT	6056	Massa Martana	Umbria	Perugia	PG	15836
IT	6056	Viepri	Umbria	Perugia	PG	15837
IT	6056	Villa San Faustino	Umbria	Perugia	PG	15838
IT	6056	Colpetrazzo	Umbria	Perugia	PG	15839
IT	6057	Monte Castello Di Vibio	Umbria	Perugia	PG	15840
IT	6059	Montenero Di Todi	Umbria	Perugia	PG	15841
IT	6059	Collevalenza	Umbria	Perugia	PG	15842
IT	6059	Ilci	Umbria	Perugia	PG	15843
IT	6059	Izzalini	Umbria	Perugia	PG	15844
IT	6059	Pian Di San Martino	Umbria	Perugia	PG	15845
IT	6059	Montenero	Umbria	Perugia	PG	15846
IT	6059	Todi	Umbria	Perugia	PG	15847
IT	6059	Pantalla	Umbria	Perugia	PG	15848
IT	6059	Pontecuti	Umbria	Perugia	PG	15849
IT	6059	Monticello	Umbria	Perugia	PG	15850
IT	6059	Camerata	Umbria	Perugia	PG	15851
IT	6059	Canonica	Umbria	Perugia	PG	15852
IT	6059	Ponterio	Umbria	Perugia	PG	15853
IT	6060	Lisciano Niccone	Umbria	Perugia	PG	15854
IT	6060	Villastrada Umbra	Umbria	Perugia	PG	15855
IT	6060	Paciano	Umbria	Perugia	PG	15856
IT	6061	Sanfatucchio	Umbria	Perugia	PG	15857
IT	6061	Castiglione Del Lago	Umbria	Perugia	PG	15858
IT	6061	Macchie	Umbria	Perugia	PG	15859
IT	6061	Porto	Umbria	Perugia	PG	15860
IT	6061	Panicarola	Umbria	Perugia	PG	15861
IT	6061	Pozzuolo	Umbria	Perugia	PG	15862
IT	6061	Gioiella	Umbria	Perugia	PG	15863
IT	6061	Villastrada	Umbria	Perugia	PG	15864
IT	6061	Petrignano Del Lago	Umbria	Perugia	PG	15865
IT	6062	Moiano	Umbria	Perugia	PG	15866
IT	6062	Po Bandino	Umbria	Perugia	PG	15867
IT	6062	Salci	Umbria	Perugia	PG	15868
IT	6062	Citta' Della Pieve	Umbria	Perugia	PG	15869
IT	6062	Ponticelli Citta' Della Pieve	Umbria	Perugia	PG	15870
IT	6062	Ponticelli	Umbria	Perugia	PG	15871
IT	6063	Sant'Arcangelo	Umbria	Perugia	PG	15872
IT	6063	Villa	Umbria	Perugia	PG	15873
IT	6063	Soccorso	Umbria	Perugia	PG	15874
IT	6063	San Feliciano	Umbria	Perugia	PG	15875
IT	6063	San Savino	Umbria	Perugia	PG	15876
IT	6063	Magione	Umbria	Perugia	PG	15877
IT	6063	Agello	Umbria	Perugia	PG	15878
IT	6063	Sant'Arcangelo Di Magione	Umbria	Perugia	PG	15879
IT	6064	Panicale	Umbria	Perugia	PG	15880
IT	6065	Castel Rigone	Umbria	Perugia	PG	15881
IT	6065	Passignano Sul Trasimeno	Umbria	Perugia	PG	15882
IT	6066	Castiglion Fosco	Umbria	Perugia	PG	15883
IT	6066	Pietrafitta	Umbria	Perugia	PG	15884
IT	6066	Piegaro	Umbria	Perugia	PG	15885
IT	6068	Tavernelle	Umbria	Perugia	PG	15886
IT	6069	Tuoro Sul Trasimeno	Umbria	Perugia	PG	15887
IT	6069	Isola Maggiore	Umbria	Perugia	PG	15888
IT	6069	Borghetto Di Tuoro	Umbria	Perugia	PG	15889
IT	6070	San Mariano	Umbria	Perugia	PG	15890
IT	6070	Ellera	Umbria	Perugia	PG	15891
IT	6070	Ellera Umbra	Umbria	Perugia	PG	15892
IT	6072	Castiglione Della Valle	Umbria	Perugia	PG	15893
IT	6072	Migliano	Umbria	Perugia	PG	15894
IT	6072	Mercatello	Umbria	Perugia	PG	15895
IT	6072	Badiola	Umbria	Perugia	PG	15896
IT	6072	Spina	Umbria	Perugia	PG	15897
IT	6072	Compignano	Umbria	Perugia	PG	15898
IT	6072	Pieve Caina	Umbria	Perugia	PG	15899
IT	6072	San Biagio Della Valle	Umbria	Perugia	PG	15900
IT	6073	Mantignana	Umbria	Perugia	PG	15901
IT	6073	Corciano	Umbria	Perugia	PG	15902
IT	6081	Castelnuovo	Umbria	Perugia	PG	15903
IT	6081	San Vitale	Umbria	Perugia	PG	15904
IT	6081	Assisi	Umbria	Perugia	PG	15905
IT	6081	Palazzo	Umbria	Perugia	PG	15906
IT	6081	Torchiagina	Umbria	Perugia	PG	15907
IT	6081	Petrignano	Umbria	Perugia	PG	15908
IT	6081	Santa Maria Degli Angeli	Umbria	Perugia	PG	15909
IT	6081	Rivotorto	Umbria	Perugia	PG	15910
IT	6081	Petrignano D'Assisi	Umbria	Perugia	PG	15911
IT	6081	Tordandrea	Umbria	Perugia	PG	15912
IT	6081	Viole Di Assisi	Umbria	Perugia	PG	15913
IT	6081	Assisi Santuario	Umbria	Perugia	PG	15914
IT	6081	Castelnuovo D'Assisi	Umbria	Perugia	PG	15915
IT	6081	Palazzo D'Assisi	Umbria	Perugia	PG	15916
IT	6083	Ospedalicchio	Umbria	Perugia	PG	15917
IT	6083	Costano	Umbria	Perugia	PG	15918
IT	6083	Ospedalicchio Di Bastia Umbra	Umbria	Perugia	PG	15919
IT	6083	Bastia	Umbria	Perugia	PG	15920
IT	6084	Bettona	Umbria	Perugia	PG	15921
IT	6084	Passaggio	Umbria	Perugia	PG	15922
IT	6084	Passaggio Di Bettona	Umbria	Perugia	PG	15923
IT	6089	Torgiano	Umbria	Perugia	PG	15924
IT	6089	Ponte Nuovo	Umbria	Perugia	PG	15925
IT	6089	Fornaci	Umbria	Perugia	PG	15926
IT	6089	Brufa	Umbria	Perugia	PG	15927
IT	6100	Perugia	Umbria	Perugia	PG	15928
IT	6121	Perugia	Umbria	Perugia	PG	15929
IT	6122	Perugia	Umbria	Perugia	PG	15930
IT	6123	Perugia	Umbria	Perugia	PG	15931
IT	6124	Perugia Stazione	Umbria	Perugia	PG	15932
IT	6124	Perugia	Umbria	Perugia	PG	15933
IT	6125	Perugia	Umbria	Perugia	PG	15934
IT	6126	Montebello	Umbria	Perugia	PG	15935
IT	6126	Perugia	Umbria	Perugia	PG	15936
IT	6126	Montecorneo	Umbria	Perugia	PG	15937
IT	6127	Ferro Di Cavallo	Umbria	Perugia	PG	15938
IT	6127	Perugia	Umbria	Perugia	PG	15939
IT	6128	Ponte Della Pietra	Umbria	Perugia	PG	15940
IT	6128	Perugia	Umbria	Perugia	PG	15941
IT	6129	Prepo	Umbria	Perugia	PG	15942
IT	6129	Perugia	Umbria	Perugia	PG	15943
IT	6131	San Marco	Umbria	Perugia	PG	15944
IT	6131	Perugia	Umbria	Perugia	PG	15945
IT	6132	San Sisto	Umbria	Perugia	PG	15946
IT	6132	Perugia	Umbria	Perugia	PG	15947
IT	6134	Perugia	Umbria	Perugia	PG	15948
IT	5010	San Vito In Monte	Umbria	Terni	TR	15949
IT	5010	Porano	Umbria	Terni	TR	15950
IT	5010	Collelungo	Umbria	Terni	TR	15951
IT	5010	Parrano	Umbria	Terni	TR	15952
IT	5010	Ospedaletto	Umbria	Terni	TR	15953
IT	5010	Poggio Aquilone	Umbria	Terni	TR	15954
IT	5010	Pornello	Umbria	Terni	TR	15955
IT	5010	Montegabbione	Umbria	Terni	TR	15956
IT	5010	San Venanzo	Umbria	Terni	TR	15957
IT	5010	Ripalvella	Umbria	Terni	TR	15958
IT	5011	Allerona	Umbria	Terni	TR	15959
IT	5011	Allerona Stazione	Umbria	Terni	TR	15960
IT	5011	Stazione Di Allerona	Umbria	Terni	TR	15961
IT	5012	Attigliano	Umbria	Terni	TR	15962
IT	5013	Castel Giorgio	Umbria	Terni	TR	15963
IT	5014	Monterubiaglio	Umbria	Terni	TR	15964
IT	5014	Pianlungo	Umbria	Terni	TR	15965
IT	5014	Castel Viscardo	Umbria	Terni	TR	15966
IT	5015	Fabro Scalo	Umbria	Terni	TR	15967
IT	5015	Fabro	Umbria	Terni	TR	15968
IT	5015	Carnaiola	Umbria	Terni	TR	15969
IT	5016	Ficulle	Umbria	Terni	TR	15970
IT	5016	Sala	Umbria	Terni	TR	15971
IT	5017	Santa Maria	Umbria	Terni	TR	15972
IT	5017	Monteleone D'Orvieto	Umbria	Terni	TR	15973
IT	5018	Ciconia	Umbria	Terni	TR	15974
IT	5018	Morrano Nuovo	Umbria	Terni	TR	15975
IT	5018	Prodo	Umbria	Terni	TR	15976
IT	5018	Orvieto Scalo	Umbria	Terni	TR	15977
IT	5018	Corbara	Umbria	Terni	TR	15978
IT	5018	Orvieto Stazione	Umbria	Terni	TR	15979
IT	5018	Orvieto	Umbria	Terni	TR	15980
IT	5018	Canale Nuovo	Umbria	Terni	TR	15981
IT	5018	Gabelletta	Umbria	Terni	TR	15982
IT	5018	Sferracavallo	Umbria	Terni	TR	15983
IT	5018	Canale Vecchio	Umbria	Terni	TR	15984
IT	5018	Sugano	Umbria	Terni	TR	15985
IT	5018	Canale	Umbria	Terni	TR	15986
IT	5018	Titignano	Umbria	Terni	TR	15987
IT	5018	Morrano Vecchio	Umbria	Terni	TR	15988
IT	5018	Morrano	Umbria	Terni	TR	15989
IT	5020	Montecchio	Umbria	Terni	TR	15990
IT	5020	Sismano	Umbria	Terni	TR	15991
IT	5020	Tenaglie	Umbria	Terni	TR	15992
IT	5020	Dunarobba	Umbria	Terni	TR	15993
IT	5020	Santa Restituta	Umbria	Terni	TR	15994
IT	5020	Lugnano In Teverina	Umbria	Terni	TR	15995
IT	5020	Avigliano Umbro	Umbria	Terni	TR	15996
IT	5020	Melezzole	Umbria	Terni	TR	15997
IT	5020	Alviano	Umbria	Terni	TR	15998
IT	5021	Acquasparta	Umbria	Terni	TR	15999
IT	5021	Casigliano	Umbria	Terni	TR	16000
IT	5021	Portaria	Umbria	Terni	TR	16001
IT	5022	Amelia	Umbria	Terni	TR	16002
IT	5022	Macchie	Umbria	Terni	TR	16003
IT	5022	Porchiano	Umbria	Terni	TR	16004
IT	5022	Montecampano	Umbria	Terni	TR	16005
IT	5022	Fornole	Umbria	Terni	TR	16006
IT	5022	Porchiano Del Monte	Umbria	Terni	TR	16007
IT	5023	Civitella Del Lago	Umbria	Terni	TR	16008
IT	5023	Acqualoreto	Umbria	Terni	TR	16009
IT	5023	Morre	Umbria	Terni	TR	16010
IT	5023	Baschi	Umbria	Terni	TR	16011
IT	5024	Giove	Umbria	Terni	TR	16012
IT	5025	Guardea	Umbria	Terni	TR	16013
IT	5026	Quadrelli	Umbria	Terni	TR	16014
IT	5026	Casteltodino	Umbria	Terni	TR	16015
IT	5026	Montecastrilli	Umbria	Terni	TR	16016
IT	5026	Castel Dell'Aquila	Umbria	Terni	TR	16017
IT	5026	Collesecco	Umbria	Terni	TR	16018
IT	5026	Farnetta	Umbria	Terni	TR	16019
IT	5028	Penna In Teverina	Umbria	Terni	TR	16020
IT	5029	San Gemini	Umbria	Terni	TR	16021
IT	5030	Montefranco	Umbria	Terni	TR	16022
IT	5030	Otricoli	Umbria	Terni	TR	16023
IT	5030	Fontechiaruccia	Umbria	Terni	TR	16024
IT	5030	Polino	Umbria	Terni	TR	16025
IT	5030	Poggio Di Otricoli	Umbria	Terni	TR	16026
IT	5031	Casteldilago	Umbria	Terni	TR	16027
IT	5031	Arrone	Umbria	Terni	TR	16028
IT	5031	Buonacquisto	Umbria	Terni	TR	16029
IT	5032	Santa Maria Della Neve	Umbria	Terni	TR	16030
IT	5032	Calvi Dell'Umbria	Umbria	Terni	TR	16031
IT	5034	Ferentillo	Umbria	Terni	TR	16032
IT	5035	San Vito	Umbria	Terni	TR	16033
IT	5035	Narni	Umbria	Terni	TR	16034
IT	5035	Vigne Di Narni	Umbria	Terni	TR	16035
IT	5035	Montoro	Umbria	Terni	TR	16036
IT	5035	Stifone	Umbria	Terni	TR	16037
IT	5035	Taizzano	Umbria	Terni	TR	16038
IT	5035	Capitone	Umbria	Terni	TR	16039
IT	5035	Testaccio	Umbria	Terni	TR	16040
IT	5035	Ponte San Lorenzo	Umbria	Terni	TR	16041
IT	5035	Borgaria Di Narni	Umbria	Terni	TR	16042
IT	5035	Gualdo	Umbria	Terni	TR	16043
IT	5035	Sant'Urbano	Umbria	Terni	TR	16044
IT	5035	Gualdo Di Narni	Umbria	Terni	TR	16045
IT	5035	Borgaria	Umbria	Terni	TR	16046
IT	5035	Narni Scalo	Umbria	Terni	TR	16047
IT	5035	Nera Montoro	Umbria	Terni	TR	16048
IT	5035	Itieli	Umbria	Terni	TR	16049
IT	5035	San Liberato	Umbria	Terni	TR	16050
IT	5035	Vigne	Umbria	Terni	TR	16051
IT	5035	Schifanoia	Umbria	Terni	TR	16052
IT	5035	Narni Stazione	Umbria	Terni	TR	16053
IT	5039	Stroncone	Umbria	Terni	TR	16054
IT	5100	Miranda	Umbria	Terni	TR	16055
IT	5100	Papigno	Umbria	Terni	TR	16056
IT	5100	Cesi	Umbria	Terni	TR	16057
IT	5100	Collestatte	Umbria	Terni	TR	16058
IT	5100	Marmore	Umbria	Terni	TR	16059
IT	5100	Torreorsina	Umbria	Terni	TR	16060
IT	5100	Terni	Umbria	Terni	TR	16061
IT	5100	Rocca San Zenone	Umbria	Terni	TR	16062
IT	5100	Cesi Di Terni	Umbria	Terni	TR	16063
IT	5100	Battiferro	Umbria	Terni	TR	16064
IT	5100	Cecalocco	Umbria	Terni	TR	16065
IT	5100	Piediluco	Umbria	Terni	TR	16066
IT	5100	Collescipoli	Umbria	Terni	TR	16067
IT	5100	Giuncano	Umbria	Terni	TR	16068
IT	5100	Gabelletta Di Cesi	Umbria	Terni	TR	16069
IT	5100	Giuncano Scalo	Umbria	Terni	TR	16070
IT	5100	Collestatte Piano	Umbria	Terni	TR	16071
IT	5100	Valenza	Umbria	Terni	TR	16072
IT	11010	Allein	Valle D'Aosta	Valle D'Aosta	AO	16073
IT	11010	Valpelline	Valle D'Aosta	Valle D'Aosta	AO	16074
IT	11010	Vieyes	Valle D'Aosta	Valle D'Aosta	AO	16075
IT	11010	Saint Maurice	Valle D'Aosta	Valle D'Aosta	AO	16076
IT	11010	Gignod	Valle D'Aosta	Valle D'Aosta	AO	16077
IT	11010	Pre' Saint Didier	Valle D'Aosta	Valle D'Aosta	AO	16078
IT	11010	Montan	Valle D'Aosta	Valle D'Aosta	AO	16079
IT	11010	La Cretaz	Valle D'Aosta	Valle D'Aosta	AO	16080
IT	11010	Runaz	Valle D'Aosta	Valle D'Aosta	AO	16081
IT	11010	Valgrisenche	Valle D'Aosta	Valle D'Aosta	AO	16082
IT	11010	Ollomont	Valle D'Aosta	Valle D'Aosta	AO	16083
IT	11010	Introd	Valle D'Aosta	Valle D'Aosta	AO	16084
IT	11010	Aymavilles	Valle D'Aosta	Valle D'Aosta	AO	16085
IT	11010	Saint Nicolas	Valle D'Aosta	Valle D'Aosta	AO	16086
IT	11010	Verrand	Valle D'Aosta	Valle D'Aosta	AO	16087
IT	11010	Plan D'Introd	Valle D'Aosta	Valle D'Aosta	AO	16088
IT	11010	Oyace	Valle D'Aosta	Valle D'Aosta	AO	16089
IT	11010	Doues	Valle D'Aosta	Valle D'Aosta	AO	16090
IT	11010	Arensod	Valle D'Aosta	Valle D'Aosta	AO	16091
IT	11010	Avise	Valle D'Aosta	Valle D'Aosta	AO	16092
IT	11010	Angelin	Valle D'Aosta	Valle D'Aosta	AO	16093
IT	11010	Bionaz	Valle D'Aosta	Valle D'Aosta	AO	16094
IT	11010	Bosses	Valle D'Aosta	Valle D'Aosta	AO	16095
IT	11010	Roisan	Valle D'Aosta	Valle D'Aosta	AO	16096
IT	11010	Rhemes Notre Dame	Valle D'Aosta	Valle D'Aosta	AO	16097
IT	11010	Valsavarenche	Valle D'Aosta	Valle D'Aosta	AO	16098
IT	11010	Saint Pierre	Valle D'Aosta	Valle D'Aosta	AO	16099
IT	11010	Chesallet	Valle D'Aosta	Valle D'Aosta	AO	16100
IT	11010	Chesallet Sarre	Valle D'Aosta	Valle D'Aosta	AO	16101
IT	11010	Rhemes Saint Georges	Valle D'Aosta	Valle D'Aosta	AO	16102
IT	11010	Sarre	Valle D'Aosta	Valle D'Aosta	AO	16103
IT	11010	Saint Rhemy En Bosses	Valle D'Aosta	Valle D'Aosta	AO	16104
IT	11011	Arvier	Valle D'Aosta	Valle D'Aosta	AO	16105
IT	11011	Planaval	Valle D'Aosta	Valle D'Aosta	AO	16106
IT	11011	Leverogne	Valle D'Aosta	Valle D'Aosta	AO	16107
IT	11012	Cogne	Valle D'Aosta	Valle D'Aosta	AO	16108
IT	11012	Epinel	Valle D'Aosta	Valle D'Aosta	AO	16109
IT	11012	Gimillian	Valle D'Aosta	Valle D'Aosta	AO	16110
IT	11013	La Saxe	Valle D'Aosta	Valle D'Aosta	AO	16111
IT	11013	Dolonne	Valle D'Aosta	Valle D'Aosta	AO	16112
IT	11013	Entreves	Valle D'Aosta	Valle D'Aosta	AO	16113
IT	11013	Courmayeur	Valle D'Aosta	Valle D'Aosta	AO	16114
IT	11014	Etroubles	Valle D'Aosta	Valle D'Aosta	AO	16115
IT	11014	Saint Oyen	Valle D'Aosta	Valle D'Aosta	AO	16116
IT	11015	Derby	Valle D'Aosta	Valle D'Aosta	AO	16117
IT	11015	La Salle	Valle D'Aosta	Valle D'Aosta	AO	16118
IT	11016	La Thuile	Valle D'Aosta	Valle D'Aosta	AO	16119
IT	11017	Morgex	Valle D'Aosta	Valle D'Aosta	AO	16120
IT	11018	Villeneuve	Valle D'Aosta	Valle D'Aosta	AO	16121
IT	11020	Champdepraz	Valle D'Aosta	Valle D'Aosta	AO	16122
IT	11020	Gressan	Valle D'Aosta	Valle D'Aosta	AO	16123
IT	11020	Ayas	Valle D'Aosta	Valle D'Aosta	AO	16124
IT	11020	Etabloz	Valle D'Aosta	Valle D'Aosta	AO	16125
IT	11020	Grand Villa	Valle D'Aosta	Valle D'Aosta	AO	16126
IT	11020	Gaby	Valle D'Aosta	Valle D'Aosta	AO	16127
IT	11020	Vert	Valle D'Aosta	Valle D'Aosta	AO	16128
IT	11020	Brissogne	Valle D'Aosta	Valle D'Aosta	AO	16129
IT	11020	Issogne	Valle D'Aosta	Valle D'Aosta	AO	16130
IT	11020	La Place	Valle D'Aosta	Valle D'Aosta	AO	16131
IT	11020	Lignod	Valle D'Aosta	Valle D'Aosta	AO	16132
IT	11020	Antagnod	Valle D'Aosta	Valle D'Aosta	AO	16133
IT	11020	Torgnon	Valle D'Aosta	Valle D'Aosta	AO	16134
IT	11020	Pont Suaz	Valle D'Aosta	Valle D'Aosta	AO	16135
IT	11020	Issime	Valle D'Aosta	Valle D'Aosta	AO	16136
IT	11020	Blavy Nus	Valle D'Aosta	Valle D'Aosta	AO	16137
IT	11020	Perloz	Valle D'Aosta	Valle D'Aosta	AO	16138
IT	11020	Blavy	Valle D'Aosta	Valle D'Aosta	AO	16139
IT	11020	Pollein	Valle D'Aosta	Valle D'Aosta	AO	16140
IT	11020	Donnas	Valle D'Aosta	Valle D'Aosta	AO	16141
IT	11020	Champorcher	Valle D'Aosta	Valle D'Aosta	AO	16142
IT	11020	Emarese	Valle D'Aosta	Valle D'Aosta	AO	16143
IT	11020	Barme	Valle D'Aosta	Valle D'Aosta	AO	16144
IT	11020	Chamois	Valle D'Aosta	Valle D'Aosta	AO	16145
IT	11020	Montjovet	Valle D'Aosta	Valle D'Aosta	AO	16146
IT	11020	Lillianes	Valle D'Aosta	Valle D'Aosta	AO	16147
IT	11020	Fenis	Valle D'Aosta	Valle D'Aosta	AO	16148
IT	11020	Verrayes	Valle D'Aosta	Valle D'Aosta	AO	16149
IT	11020	Neyran	Valle D'Aosta	Valle D'Aosta	AO	16150
IT	11020	Champoluc	Valle D'Aosta	Valle D'Aosta	AO	16151
IT	11020	Villefranche	Valle D'Aosta	Valle D'Aosta	AO	16152
IT	11020	Ville Sur Nus	Valle D'Aosta	Valle D'Aosta	AO	16153
IT	11020	Fiernaz	Valle D'Aosta	Valle D'Aosta	AO	16154
IT	11020	Plan Felinaz	Valle D'Aosta	Valle D'Aosta	AO	16155
IT	11020	Grand Vert	Valle D'Aosta	Valle D'Aosta	AO	16156
IT	11020	Quart	Valle D'Aosta	Valle D'Aosta	AO	16157
IT	11020	Chez Croiset	Valle D'Aosta	Valle D'Aosta	AO	16158
IT	11020	Mongnod	Valle D'Aosta	Valle D'Aosta	AO	16159
IT	11020	Chef Lieu	Valle D'Aosta	Valle D'Aosta	AO	16160
IT	11020	Periasc	Valle D'Aosta	Valle D'Aosta	AO	16161
IT	11020	Jovencan	Valle D'Aosta	Valle D'Aosta	AO	16162
IT	11020	Bard	Valle D'Aosta	Valle D'Aosta	AO	16163
IT	11020	Arnad	Valle D'Aosta	Valle D'Aosta	AO	16164
IT	11020	La Magdeleine	Valle D'Aosta	Valle D'Aosta	AO	16165
IT	11020	Challand Saint Victor	Valle D'Aosta	Valle D'Aosta	AO	16166
IT	11020	Villair	Valle D'Aosta	Valle D'Aosta	AO	16167
IT	11020	Charvensod	Valle D'Aosta	Valle D'Aosta	AO	16168
IT	11020	Hone	Valle D'Aosta	Valle D'Aosta	AO	16169
IT	11020	Fontainemore	Valle D'Aosta	Valle D'Aosta	AO	16170
IT	11020	Grand Villa Cravon	Valle D'Aosta	Valle D'Aosta	AO	16171
IT	11020	Saint Marcel	Valle D'Aosta	Valle D'Aosta	AO	16172
IT	11020	Nus	Valle D'Aosta	Valle D'Aosta	AO	16173
IT	11020	Buisson	Valle D'Aosta	Valle D'Aosta	AO	16174
IT	11020	Saint Christophe	Valle D'Aosta	Valle D'Aosta	AO	16175
IT	11020	Challand Saint Anselme	Valle D'Aosta	Valle D'Aosta	AO	16176
IT	11020	Pontboset	Valle D'Aosta	Valle D'Aosta	AO	16177
IT	11020	Antey Saint Andre'	Valle D'Aosta	Valle D'Aosta	AO	16178
IT	11020	Gressoney La Trinite'	Valle D'Aosta	Valle D'Aosta	AO	16179
IT	11020	Saint Barthelemy	Valle D'Aosta	Valle D'Aosta	AO	16180
IT	11020	Peroulaz	Valle D'Aosta	Valle D'Aosta	AO	16181
IT	11020	Ville	Valle D'Aosta	Valle D'Aosta	AO	16182
IT	11021	Breuil	Valle D'Aosta	Valle D'Aosta	AO	16183
IT	11021	Cervinia	Valle D'Aosta	Valle D'Aosta	AO	16184
IT	11021	Breuil Cervinia	Valle D'Aosta	Valle D'Aosta	AO	16185
IT	11022	Brusson	Valle D'Aosta	Valle D'Aosta	AO	16186
IT	11022	Extrepieraz	Valle D'Aosta	Valle D'Aosta	AO	16187
IT	11022	Arcesaz	Valle D'Aosta	Valle D'Aosta	AO	16188
IT	11023	Chambave	Valle D'Aosta	Valle D'Aosta	AO	16189
IT	11023	Saint Denis	Valle D'Aosta	Valle D'Aosta	AO	16190
IT	11024	Ussel	Valle D'Aosta	Valle D'Aosta	AO	16191
IT	11024	Chatillon	Valle D'Aosta	Valle D'Aosta	AO	16192
IT	11024	Lassolaz	Valle D'Aosta	Valle D'Aosta	AO	16193
IT	11024	Pontey	Valle D'Aosta	Valle D'Aosta	AO	16194
IT	11025	Gressoney Saint Jean	Valle D'Aosta	Valle D'Aosta	AO	16195
IT	11026	Pont Saint Martin	Valle D'Aosta	Valle D'Aosta	AO	16196
IT	11027	Moron	Valle D'Aosta	Valle D'Aosta	AO	16197
IT	11027	Saint Vincent	Valle D'Aosta	Valle D'Aosta	AO	16198
IT	11028	Valtournenche	Valle D'Aosta	Valle D'Aosta	AO	16199
IT	11028	Paquier	Valle D'Aosta	Valle D'Aosta	AO	16200
IT	11029	Verres	Valle D'Aosta	Valle D'Aosta	AO	16201
IT	11029	Glair	Valle D'Aosta	Valle D'Aosta	AO	16202
IT	11100	Aosta	Valle D'Aosta	Valle D'Aosta	AO	16203
IT	11100	Arpuilles	Valle D'Aosta	Valle D'Aosta	AO	16204
IT	11100	Porossan	Valle D'Aosta	Valle D'Aosta	AO	16205
IT	11100	Signayes	Valle D'Aosta	Valle D'Aosta	AO	16206
IT	11100	Roisan	Valle D'Aosta	Valle D'Aosta	AO	16207
IT	11100	Excenex	Valle D'Aosta	Valle D'Aosta	AO	16208
IT	32010	Perarolo Di Cadore	Veneto	Belluno	BL	16209
IT	32010	Zoppe' Di Cadore	Veneto	Belluno	BL	16210
IT	32010	Tignes	Veneto	Belluno	BL	16211
IT	32010	Tambre	Veneto	Belluno	BL	16212
IT	32010	Chies D'Alpago	Veneto	Belluno	BL	16213
IT	32010	Garna	Veneto	Belluno	BL	16214
IT	32010	Lamosano	Veneto	Belluno	BL	16215
IT	32010	Castello Lavazzo	Veneto	Belluno	BL	16216
IT	32010	Podenzoi	Veneto	Belluno	BL	16217
IT	32010	Soverzene	Veneto	Belluno	BL	16218
IT	32010	Codissago	Veneto	Belluno	BL	16219
IT	32010	Pecol	Veneto	Belluno	BL	16220
IT	32010	Mareson	Veneto	Belluno	BL	16221
IT	32010	Zoldo Alto	Veneto	Belluno	BL	16222
IT	32010	Termine	Veneto	Belluno	BL	16223
IT	32010	Ospitale Di Cadore	Veneto	Belluno	BL	16224
IT	32010	Pieve D'Alpago	Veneto	Belluno	BL	16225
IT	32010	Termine Di Cadore	Veneto	Belluno	BL	16226
IT	32012	Dont Di Zoldo	Veneto	Belluno	BL	16227
IT	32012	Forno Di Zoldo	Veneto	Belluno	BL	16228
IT	32012	Dozza Di Zoldo	Veneto	Belluno	BL	16229
IT	32012	Dont	Veneto	Belluno	BL	16230
IT	32013	Fortogna	Veneto	Belluno	BL	16231
IT	32013	Igne	Veneto	Belluno	BL	16232
IT	32013	Longarone	Veneto	Belluno	BL	16233
IT	32014	Casan	Veneto	Belluno	BL	16234
IT	32014	Paiane	Veneto	Belluno	BL	16235
IT	32014	Soccher	Veneto	Belluno	BL	16236
IT	32014	Cadola	Veneto	Belluno	BL	16237
IT	32014	Polpet	Veneto	Belluno	BL	16238
IT	32014	La Secca	Veneto	Belluno	BL	16239
IT	32014	Ponte Nelle Alpi	Veneto	Belluno	BL	16240
IT	32014	Col Di Cugnan	Veneto	Belluno	BL	16241
IT	32015	Puos D'Alpago	Veneto	Belluno	BL	16242
IT	32015	Cornei	Veneto	Belluno	BL	16243
IT	32043	Verocai	Veneto	Belluno	BL	16244
IT	32016	Farra D'Alpago	Veneto	Belluno	BL	16245
IT	32016	Spert	Veneto	Belluno	BL	16246
IT	32016	Santa Croce	Veneto	Belluno	BL	16247
IT	32016	Santa Croce Del Lago	Veneto	Belluno	BL	16248
IT	32020	La Valle Agordina	Veneto	Belluno	BL	16249
IT	32020	Gosaldo	Veneto	Belluno	BL	16250
IT	32020	Livinallongo Del Col Di Lana	Veneto	Belluno	BL	16251
IT	32020	Frassene'	Veneto	Belluno	BL	16252
IT	32020	Tiser	Veneto	Belluno	BL	16253
IT	32020	Colle Santa Lucia	Veneto	Belluno	BL	16254
IT	32020	Arabba	Veneto	Belluno	BL	16255
IT	32020	Rivamonte Agordino	Veneto	Belluno	BL	16256
IT	32020	Villapiana	Veneto	Belluno	BL	16257
IT	32020	Ronchena	Veneto	Belluno	BL	16258
IT	32020	Canale D'Agordo	Veneto	Belluno	BL	16259
IT	32020	Avoscan	Veneto	Belluno	BL	16260
IT	32020	Voltago Agordino	Veneto	Belluno	BL	16261
IT	32020	Pie' Falcade	Veneto	Belluno	BL	16262
IT	32020	Selva Di Cadore	Veneto	Belluno	BL	16263
IT	32020	Dussoi	Veneto	Belluno	BL	16264
IT	32020	Vallada Agordina	Veneto	Belluno	BL	16265
IT	32020	Cencenighe Agordino	Veneto	Belluno	BL	16266
IT	32020	Limana	Veneto	Belluno	BL	16267
IT	32020	San Tomaso Agordino	Veneto	Belluno	BL	16268
IT	32020	Caviola	Veneto	Belluno	BL	16269
IT	32020	Falcade	Veneto	Belluno	BL	16270
IT	32020	Lentiai	Veneto	Belluno	BL	16271
IT	32021	Agordo	Veneto	Belluno	BL	16272
IT	32022	Caprile	Veneto	Belluno	BL	16273
IT	32022	Alleghe	Veneto	Belluno	BL	16274
IT	32023	Rocca Pietore	Veneto	Belluno	BL	16275
IT	32023	Santa Maria Delle Grazie	Veneto	Belluno	BL	16276
IT	32023	Laste Di Rocca Pietore	Veneto	Belluno	BL	16277
IT	32026	Mel	Veneto	Belluno	BL	16278
IT	32026	Villa Di Villa	Veneto	Belluno	BL	16279
IT	32027	Taibon Agordino	Veneto	Belluno	BL	16280
IT	32028	Sant'Antonio Tortal	Veneto	Belluno	BL	16281
IT	32028	Trichiana	Veneto	Belluno	BL	16282
IT	32030	Mellame	Veneto	Belluno	BL	16283
IT	32030	Sovramonte	Veneto	Belluno	BL	16284
IT	32030	Rocca	Veneto	Belluno	BL	16285
IT	32030	Sorriva	Veneto	Belluno	BL	16286
IT	32030	Paderno	Veneto	Belluno	BL	16287
IT	32030	Soranzen	Veneto	Belluno	BL	16288
IT	32030	Fonzaso	Veneto	Belluno	BL	16289
IT	32030	Arsie'	Veneto	Belluno	BL	16290
IT	32030	Rocca D'Arsie'	Veneto	Belluno	BL	16291
IT	32030	Cesiomaggiore	Veneto	Belluno	BL	16292
IT	32030	Seren Del Grappa	Veneto	Belluno	BL	16293
IT	32030	Busche	Veneto	Belluno	BL	16294
IT	32030	San Gregorio Nelle Alpi	Veneto	Belluno	BL	16295
IT	32030	Arten	Veneto	Belluno	BL	16296
IT	32030	Fastro	Veneto	Belluno	BL	16297
IT	32031	Colmirano	Veneto	Belluno	BL	16298
IT	32031	Fener	Veneto	Belluno	BL	16299
IT	32031	Alano Di Piave	Veneto	Belluno	BL	16300
IT	32032	Villapaiera	Veneto	Belluno	BL	16301
IT	32032	Anzu'	Veneto	Belluno	BL	16302
IT	32032	Mugnai	Veneto	Belluno	BL	16303
IT	32032	Tomo	Veneto	Belluno	BL	16304
IT	32032	Foen	Veneto	Belluno	BL	16305
IT	32032	Villabruna	Veneto	Belluno	BL	16306
IT	32032	Feltre	Veneto	Belluno	BL	16307
IT	32032	Umin	Veneto	Belluno	BL	16308
IT	32033	Lamon	Veneto	Belluno	BL	16309
IT	32033	Arina	Veneto	Belluno	BL	16310
IT	32034	Norcen	Veneto	Belluno	BL	16311
IT	32034	Facen	Veneto	Belluno	BL	16312
IT	32034	Pedavena	Veneto	Belluno	BL	16313
IT	32034	Travagola	Veneto	Belluno	BL	16314
IT	32035	Meano	Veneto	Belluno	BL	16315
IT	32035	Santa Giustina	Veneto	Belluno	BL	16316
IT	32035	Formegan	Veneto	Belluno	BL	16317
IT	32036	Bribano	Veneto	Belluno	BL	16318
IT	32036	Sedico	Veneto	Belluno	BL	16319
IT	32036	Mas	Veneto	Belluno	BL	16320
IT	32036	Roe Alte	Veneto	Belluno	BL	16321
IT	32037	Mis	Veneto	Belluno	BL	16322
IT	32037	Sospirolo	Veneto	Belluno	BL	16323
IT	32038	Quero	Veneto	Belluno	BL	16324
IT	32038	Vas	Veneto	Belluno	BL	16325
IT	32038	Quero Vas	Veneto	Belluno	BL	16326
IT	32040	Domegge Di Cadore	Veneto	Belluno	BL	16327
IT	32040	Vodo Cadore	Veneto	Belluno	BL	16328
IT	32040	Danta Di Cadore	Veneto	Belluno	BL	16329
IT	32040	Costalta	Veneto	Belluno	BL	16330
IT	32040	San Pietro Di Cadore	Veneto	Belluno	BL	16331
IT	32040	Padola	Veneto	Belluno	BL	16332
IT	32040	Dosoledo	Veneto	Belluno	BL	16333
IT	32040	Cibiana Di Cadore	Veneto	Belluno	BL	16334
IT	32040	Lozzo Di Cadore	Veneto	Belluno	BL	16335
IT	32040	Villapiccola	Veneto	Belluno	BL	16336
IT	32040	Vigo Di Cadore	Veneto	Belluno	BL	16337
IT	32040	Pelos	Veneto	Belluno	BL	16338
IT	32040	Villaggio Turistico Di Borca Di Cadore	Veneto	Belluno	BL	16339
IT	32040	Masarie'	Veneto	Belluno	BL	16340
IT	32040	Valle Di Cadore	Veneto	Belluno	BL	16341
IT	32040	Laggio Di Cadore	Veneto	Belluno	BL	16342
IT	32040	Presenaio	Veneto	Belluno	BL	16343
IT	32040	Pelos Di Cadore	Veneto	Belluno	BL	16344
IT	32040	Lorenzago Di Cadore	Veneto	Belluno	BL	16345
IT	32040	Venas	Veneto	Belluno	BL	16346
IT	32040	San Nicolo' Di Comelico	Veneto	Belluno	BL	16347
IT	32040	Comelico Superiore	Veneto	Belluno	BL	16348
IT	32040	Casamazzagno	Veneto	Belluno	BL	16349
IT	32040	Candide	Veneto	Belluno	BL	16350
IT	32040	Borca Di Cadore	Veneto	Belluno	BL	16351
IT	32040	Vallesella	Veneto	Belluno	BL	16352
IT	32041	Reane	Veneto	Belluno	BL	16353
IT	32041	Giralba	Veneto	Belluno	BL	16354
IT	32041	Misurina	Veneto	Belluno	BL	16355
IT	32041	Auronzo Di Cadore	Veneto	Belluno	BL	16356
IT	32042	Calalzo Di Cadore	Veneto	Belluno	BL	16357
IT	32043	Cortina D'Ampezzo	Veneto	Belluno	BL	16358
IT	32043	Acquabona	Veneto	Belluno	BL	16359
IT	32043	Zuel	Veneto	Belluno	BL	16360
IT	32044	Pieve Di Cadore	Veneto	Belluno	BL	16361
IT	32044	Pozzale	Veneto	Belluno	BL	16362
IT	32044	Sottocastello	Veneto	Belluno	BL	16363
IT	32044	Tai Di Cadore	Veneto	Belluno	BL	16364
IT	32045	Campolongo Di Cadore	Veneto	Belluno	BL	16365
IT	32045	Santo Stefano Di Cadore	Veneto	Belluno	BL	16366
IT	32045	Costalissoio	Veneto	Belluno	BL	16367
IT	32046	Chiapuzza	Veneto	Belluno	BL	16368
IT	32046	San Vito Di Cadore	Veneto	Belluno	BL	16369
IT	32047	Sappada	Veneto	Belluno	BL	16370
IT	32047	Granvilla	Veneto	Belluno	BL	16371
IT	32100	Salce	Veneto	Belluno	BL	16372
IT	32100	Levego	Veneto	Belluno	BL	16373
IT	32100	Bolzano Di Belluno	Veneto	Belluno	BL	16374
IT	32100	Caleipo	Veneto	Belluno	BL	16375
IT	32100	Visome	Veneto	Belluno	BL	16376
IT	32100	Castion	Veneto	Belluno	BL	16377
IT	32100	Sossai	Veneto	Belluno	BL	16378
IT	32100	Antole	Veneto	Belluno	BL	16379
IT	32100	Tisoi	Veneto	Belluno	BL	16380
IT	32100	Safforze	Veneto	Belluno	BL	16381
IT	32100	Bes	Veneto	Belluno	BL	16382
IT	32100	Belluno	Veneto	Belluno	BL	16383
IT	32100	Sois	Veneto	Belluno	BL	16384
IT	32100	Fiammoi	Veneto	Belluno	BL	16385
IT	35010	Sant'Ambrogio	Veneto	Padova	PD	16386
IT	35010	Fossalta	Veneto	Padova	PD	16387
IT	35010	Campodoro	Veneto	Padova	PD	16388
IT	35010	Abbazia Pisani	Veneto	Padova	PD	16389
IT	35010	Arsego	Veneto	Padova	PD	16390
IT	35010	Pieve Di Curtarolo	Veneto	Padova	PD	16391
IT	35010	Cavino	Veneto	Padova	PD	16392
IT	35010	Vigonza	Veneto	Padova	PD	16393
IT	35010	San Pietro In Gu	Veneto	Padova	PD	16394
IT	35010	Ponterotto	Veneto	Padova	PD	16395
IT	35010	Pionca	Veneto	Padova	PD	16396
IT	35010	Carmignano Di Brenta	Veneto	Padova	PD	16397
IT	35010	Grantorto	Veneto	Padova	PD	16398
IT	35010	Codiverno	Veneto	Padova	PD	16399
IT	35010	Curtarolo	Veneto	Padova	PD	16400
IT	35010	Ca' Baglioni	Veneto	Padova	PD	16401
IT	35010	Gazzo	Veneto	Padova	PD	16402
IT	35010	Campo San Martino	Veneto	Padova	PD	16403
IT	35010	Fossalta Di Trebaseleghe	Veneto	Padova	PD	16404
IT	35010	Trebaseleghe	Veneto	Padova	PD	16405
IT	35010	Borgoricco	Veneto	Padova	PD	16406
IT	35010	Pieve	Veneto	Padova	PD	16407
IT	35010	San Giorgio Delle Pertiche	Veneto	Padova	PD	16408
IT	35010	San Michele Delle Badesse	Veneto	Padova	PD	16409
IT	35010	Villa Del Conte	Veneto	Padova	PD	16410
IT	35010	Marsango	Veneto	Padova	PD	16411
IT	35010	San Vito	Veneto	Padova	PD	16412
IT	35010	Fratte	Veneto	Padova	PD	16413
IT	35010	Camazzole	Veneto	Padova	PD	16414
IT	35010	Saletto Di Vigodarzere	Veneto	Padova	PD	16415
IT	35010	Taggi'	Veneto	Padova	PD	16416
IT	35010	Loreggiola	Veneto	Padova	PD	16417
IT	35010	Villafranca Padovana	Veneto	Padova	PD	16418
IT	35010	Loreggia	Veneto	Padova	PD	16419
IT	35010	Perarolo	Veneto	Padova	PD	16420
IT	35010	Villanova	Veneto	Padova	PD	16421
IT	35010	Massanzago	Veneto	Padova	PD	16422
IT	35010	Cadoneghe	Veneto	Padova	PD	16423
IT	35010	Santa Maria Di Non	Veneto	Padova	PD	16424
IT	35010	Vigodarzere	Veneto	Padova	PD	16425
IT	35010	Silvelle	Veneto	Padova	PD	16426
IT	35010	Tavo	Veneto	Padova	PD	16427
IT	35010	San Giorgio In Bosco	Veneto	Padova	PD	16428
IT	35010	Limena	Veneto	Padova	PD	16429
IT	35010	Santa Giustina In Colle	Veneto	Padova	PD	16430
IT	35010	Ronchi Di Campanile	Veneto	Padova	PD	16431
IT	35010	Villanova Di Camposampiero	Veneto	Padova	PD	16432
IT	35010	Mejaniga	Veneto	Padova	PD	16433
IT	35010	Terraglione	Veneto	Padova	PD	16434
IT	35011	Campodarsego	Veneto	Padova	PD	16435
IT	35011	Sant'Andrea Di Campodarsego	Veneto	Padova	PD	16436
IT	35012	Camposampiero	Veneto	Padova	PD	16437
IT	35012	Rustega	Veneto	Padova	PD	16438
IT	35013	Cittadella	Veneto	Padova	PD	16439
IT	35013	Santa Croce Bigolina	Veneto	Padova	PD	16440
IT	35013	Laghi	Veneto	Padova	PD	16441
IT	35014	Fontaniva	Veneto	Padova	PD	16442
IT	35015	Galliera Veneta	Veneto	Padova	PD	16443
IT	35016	Piazzola Sul Brenta	Veneto	Padova	PD	16444
IT	35016	Presina	Veneto	Padova	PD	16445
IT	35016	Tremignon	Veneto	Padova	PD	16446
IT	35016	Vaccarino	Veneto	Padova	PD	16447
IT	35017	Levada	Veneto	Padova	PD	16448
IT	35017	Piombino Dese	Veneto	Padova	PD	16449
IT	35017	Torreselle	Veneto	Padova	PD	16450
IT	35017	Ronchi	Veneto	Padova	PD	16451
IT	35018	San Martino Di Lupari	Veneto	Padova	PD	16452
IT	35019	Onara	Veneto	Padova	PD	16453
IT	35019	Tombolo	Veneto	Padova	PD	16454
IT	35020	Polverara	Veneto	Padova	PD	16455
IT	35020	Campagnola	Veneto	Padova	PD	16456
IT	35020	Arre	Veneto	Padova	PD	16457
IT	35020	Candiana	Veneto	Padova	PD	16458
IT	35020	Due Carrare	Veneto	Padova	PD	16459
IT	35020	Tribano	Veneto	Padova	PD	16460
IT	35020	Carrara San Giorgio	Veneto	Padova	PD	16461
IT	35020	Sant'Angelo Di Piove Di Sacco	Veneto	Padova	PD	16462
IT	35020	Casalserugo	Veneto	Padova	PD	16463
IT	35020	Saonara	Veneto	Padova	PD	16464
IT	35020	Villatora	Veneto	Padova	PD	16465
IT	35020	Arzercavalli	Veneto	Padova	PD	16466
IT	35020	Terradura	Veneto	Padova	PD	16467
IT	35020	Cive'	Veneto	Padova	PD	16468
IT	35020	Pozzonovo	Veneto	Padova	PD	16469
IT	35020	Albignasego	Veneto	Padova	PD	16470
IT	35020	Arzergrande	Veneto	Padova	PD	16471
IT	35020	Codevigo	Veneto	Padova	PD	16472
IT	35020	San Pietro Viminario	Veneto	Padova	PD	16473
IT	35020	Brugine	Veneto	Padova	PD	16474
IT	35020	Casone	Veneto	Padova	PD	16475
IT	35020	Pernumia	Veneto	Padova	PD	16476
IT	35020	Bertipaglia	Veneto	Padova	PD	16477
IT	35020	Legnaro	Veneto	Padova	PD	16478
IT	35020	Ponte San Nicolo'	Veneto	Padova	PD	16479
IT	35020	Masera' Di Padova	Veneto	Padova	PD	16480
IT	35020	Conche	Veneto	Padova	PD	16481
IT	35020	Sant'Agostino	Veneto	Padova	PD	16482
IT	35020	Correzzola	Veneto	Padova	PD	16483
IT	35020	Terrassa Padovana	Veneto	Padova	PD	16484
IT	35020	Carrara Santo Stefano	Veneto	Padova	PD	16485
IT	35020	Mandriola	Veneto	Padova	PD	16486
IT	35020	Vallonga	Veneto	Padova	PD	16487
IT	35020	Roncaglia	Veneto	Padova	PD	16488
IT	35020	Conche Di Codevigo	Veneto	Padova	PD	16489
IT	35020	Vigorovea	Veneto	Padova	PD	16490
IT	35021	Agna	Veneto	Padova	PD	16491
IT	35022	Borgoforte	Veneto	Padova	PD	16492
IT	35022	Anguillara Veneta	Veneto	Padova	PD	16493
IT	35023	San Siro	Veneto	Padova	PD	16494
IT	35023	Bagnoli Di Sopra	Veneto	Padova	PD	16495
IT	35023	Le Casette	Veneto	Padova	PD	16496
IT	35024	Bovolenta	Veneto	Padova	PD	16497
IT	35025	Cartura	Veneto	Padova	PD	16498
IT	35025	Cagnola	Veneto	Padova	PD	16499
IT	35026	Conselve	Veneto	Padova	PD	16500
IT	35027	Oltre Brenta	Veneto	Padova	PD	16501
IT	35027	Noventa Padovana	Veneto	Padova	PD	16502
IT	35028	Corte	Veneto	Padova	PD	16503
IT	35028	Piovega	Veneto	Padova	PD	16504
IT	35028	Piove Di Sacco	Veneto	Padova	PD	16505
IT	35028	Arzerello	Veneto	Padova	PD	16506
IT	35029	Pontelongo	Veneto	Padova	PD	16507
IT	35030	Cervarese Santa Croce	Veneto	Padova	PD	16508
IT	35030	Galzignano	Veneto	Padova	PD	16509
IT	35030	Vo' Vecchio	Veneto	Padova	PD	16510
IT	35030	Baone	Veneto	Padova	PD	16511
IT	35030	Saccolongo	Veneto	Padova	PD	16512
IT	35030	Caselle Di Selvazzano Dentro	Veneto	Padova	PD	16513
IT	35030	Feriole	Veneto	Padova	PD	16514
IT	35030	Tencarola	Veneto	Padova	PD	16515
IT	35030	Selvazzano Dentro	Veneto	Padova	PD	16516
IT	35030	Bastia	Veneto	Padova	PD	16517
IT	35030	Cinto Euganeo	Veneto	Padova	PD	16518
IT	35030	Veggiano	Veneto	Padova	PD	16519
IT	35030	Caselle	Veneto	Padova	PD	16520
IT	35030	Montemerlo	Veneto	Padova	PD	16521
IT	35030	Rubano	Veneto	Padova	PD	16522
IT	35030	Rivadolmo	Veneto	Padova	PD	16523
IT	35030	Rovolon	Veneto	Padova	PD	16524
IT	35030	Valsanzibio	Veneto	Padova	PD	16525
IT	35030	Galzignano Terme	Veneto	Padova	PD	16526
IT	35030	Bosco	Veneto	Padova	PD	16527
IT	35030	Sarmeola	Veneto	Padova	PD	16528
IT	35030	Bastia Di Rovolon	Veneto	Padova	PD	16529
IT	35030	Vo'	Veneto	Padova	PD	16530
IT	35030	Fossona	Veneto	Padova	PD	16531
IT	35030	Villaguattera	Veneto	Padova	PD	16532
IT	35031	Monteortone	Veneto	Padova	PD	16533
IT	35031	Abano Terme	Veneto	Padova	PD	16534
IT	35032	Arqua' Petrarca	Veneto	Padova	PD	16535
IT	35034	Lozzo Atestino	Veneto	Padova	PD	16536
IT	35034	Lanzetta	Veneto	Padova	PD	16537
IT	35035	Mestrino	Veneto	Padova	PD	16538
IT	35035	Arlesega	Veneto	Padova	PD	16539
IT	35036	Montegrotto Terme	Veneto	Padova	PD	16540
IT	35037	San Biagio	Veneto	Padova	PD	16541
IT	35037	Villa Di Teolo	Veneto	Padova	PD	16542
IT	35037	Teolo	Veneto	Padova	PD	16543
IT	35037	Villa	Veneto	Padova	PD	16544
IT	35037	Treponti	Veneto	Padova	PD	16545
IT	35037	Bresseo	Veneto	Padova	PD	16546
IT	35038	Torreglia	Veneto	Padova	PD	16547
IT	35040	Megliadino San Vitale	Veneto	Padova	PD	16548
IT	35040	Sant'Elena	Veneto	Padova	PD	16549
IT	35040	Castelbaldo	Veneto	Padova	PD	16550
IT	35040	Bresega	Veneto	Padova	PD	16551
IT	35040	Carmignano	Veneto	Padova	PD	16552
IT	35040	Santa Margherita D'Adige	Veneto	Padova	PD	16553
IT	35040	Merlara	Veneto	Padova	PD	16554
IT	35040	Sant'Urbano	Veneto	Padova	PD	16555
IT	35040	Valli Mocenighe	Veneto	Padova	PD	16556
IT	35040	Carceri	Veneto	Padova	PD	16557
IT	35040	Megliadino San Fidenzio	Veneto	Padova	PD	16558
IT	35040	Urbana	Veneto	Padova	PD	16559
IT	35040	Villa Estense	Veneto	Padova	PD	16560
IT	35040	Masi	Veneto	Padova	PD	16561
IT	35040	Barbona	Veneto	Padova	PD	16562
IT	35040	Colombare	Veneto	Padova	PD	16563
IT	35040	Ca' Morosini	Veneto	Padova	PD	16564
IT	35040	San Fidenzio	Veneto	Padova	PD	16565
IT	35040	Piacenza D'Adige	Veneto	Padova	PD	16566
IT	35040	Vescovana	Veneto	Padova	PD	16567
IT	35040	Granze	Veneto	Padova	PD	16568
IT	35040	Vighizzolo D'Este	Veneto	Padova	PD	16569
IT	35040	Valli Moceniche	Veneto	Padova	PD	16570
IT	35040	Casale Di Scodosia	Veneto	Padova	PD	16571
IT	35040	Ponso	Veneto	Padova	PD	16572
IT	35040	Boara Pisani	Veneto	Padova	PD	16573
IT	35041	Battaglia Terme	Veneto	Padova	PD	16574
IT	35042	Este	Veneto	Padova	PD	16575
IT	35042	Pilastro	Veneto	Padova	PD	16576
IT	35042	Deserto	Veneto	Padova	PD	16577
IT	35043	Costa Calcinara	Veneto	Padova	PD	16578
IT	35043	San Cosma	Veneto	Padova	PD	16579
IT	35043	Monselice	Veneto	Padova	PD	16580
IT	35044	Montagnana	Veneto	Padova	PD	16581
IT	35045	Ospedaletto Euganeo	Veneto	Padova	PD	16582
IT	35046	Saletto	Veneto	Padova	PD	16583
IT	35047	Solesino	Veneto	Padova	PD	16584
IT	35048	Pisana	Veneto	Padova	PD	16585
IT	35048	Ponte Gorzone	Veneto	Padova	PD	16586
IT	35048	Stanghella	Veneto	Padova	PD	16587
IT	35100	Padova	Veneto	Padova	PD	16588
IT	35121	Padova	Veneto	Padova	PD	16589
IT	35122	Padova	Veneto	Padova	PD	16590
IT	35123	Padova	Veneto	Padova	PD	16591
IT	35124	Salboro	Veneto	Padova	PD	16592
IT	35124	Padova	Veneto	Padova	PD	16593
IT	35125	Guizza	Veneto	Padova	PD	16594
IT	35125	Padova	Veneto	Padova	PD	16595
IT	35126	Padova	Veneto	Padova	PD	16596
IT	35127	Terranegra	Veneto	Padova	PD	16597
IT	35127	Camin	Veneto	Padova	PD	16598
IT	35127	Padova	Veneto	Padova	PD	16599
IT	35128	Padova	Veneto	Padova	PD	16600
IT	35129	Ponte Di Brenta	Veneto	Padova	PD	16601
IT	35129	Padova	Veneto	Padova	PD	16602
IT	35129	Mortise	Veneto	Padova	PD	16603
IT	35131	Padova	Veneto	Padova	PD	16604
IT	35132	Padova	Veneto	Padova	PD	16605
IT	35133	Padova	Veneto	Padova	PD	16606
IT	35134	Padova	Veneto	Padova	PD	16607
IT	35135	Padova	Veneto	Padova	PD	16608
IT	35136	Padova	Veneto	Padova	PD	16609
IT	35137	Padova	Veneto	Padova	PD	16610
IT	35138	Monta'	Veneto	Padova	PD	16611
IT	35138	Padova	Veneto	Padova	PD	16612
IT	35139	Padova	Veneto	Padova	PD	16613
IT	35141	Padova	Veneto	Padova	PD	16614
IT	35142	Mandria	Veneto	Padova	PD	16615
IT	35142	Padova	Veneto	Padova	PD	16616
IT	35143	Brusegana	Veneto	Padova	PD	16617
IT	35143	Padova	Veneto	Padova	PD	16618
IT	45010	Rosolina	Veneto	Rovigo	RO	16619
IT	45010	Lama Pezzoli	Veneto	Rovigo	RO	16620
IT	45010	Pettorazza Grimani	Veneto	Rovigo	RO	16621
IT	45010	Canale	Veneto	Rovigo	RO	16622
IT	45010	Villadose	Veneto	Rovigo	RO	16623
IT	45010	Papozze	Veneto	Rovigo	RO	16624
IT	45010	Rosolina Mare	Veneto	Rovigo	RO	16625
IT	45010	Gavello	Veneto	Rovigo	RO	16626
IT	45010	Braglia	Veneto	Rovigo	RO	16627
IT	45010	Ceregnano	Veneto	Rovigo	RO	16628
IT	45010	Lama Polesine	Veneto	Rovigo	RO	16629
IT	45011	Passetto	Veneto	Rovigo	RO	16630
IT	45011	Cavanella Po	Veneto	Rovigo	RO	16631
IT	45011	Cavedon	Veneto	Rovigo	RO	16632
IT	45011	Fasana Polesine	Veneto	Rovigo	RO	16633
IT	45011	Bottrighe	Veneto	Rovigo	RO	16634
IT	45011	Adria	Veneto	Rovigo	RO	16635
IT	45011	Baricetta	Veneto	Rovigo	RO	16636
IT	45011	Fasana	Veneto	Rovigo	RO	16637
IT	45011	Piantamelon	Veneto	Rovigo	RO	16638
IT	45011	Valliera	Veneto	Rovigo	RO	16639
IT	45011	Ca' Emo	Veneto	Rovigo	RO	16640
IT	45011	Bellombra	Veneto	Rovigo	RO	16641
IT	45012	Santa Maria In Punta	Veneto	Rovigo	RO	16642
IT	45012	Grillara	Veneto	Rovigo	RO	16643
IT	45012	Ariano	Veneto	Rovigo	RO	16644
IT	45012	Piano	Veneto	Rovigo	RO	16645
IT	45012	San Basilio	Veneto	Rovigo	RO	16646
IT	45012	Riva'	Veneto	Rovigo	RO	16647
IT	45012	Crociara	Veneto	Rovigo	RO	16648
IT	45012	Ariano Nel Polesine	Veneto	Rovigo	RO	16649
IT	45014	Donada	Veneto	Rovigo	RO	16650
IT	45014	Villaregia	Veneto	Rovigo	RO	16651
IT	45014	Porto Viro	Veneto	Rovigo	RO	16652
IT	45014	Contarina	Veneto	Rovigo	RO	16653
IT	45015	Corbola	Veneto	Rovigo	RO	16654
IT	45017	Loreo	Veneto	Rovigo	RO	16655
IT	45018	Gnocca	Veneto	Rovigo	RO	16656
IT	45018	Ca' Dolfin	Veneto	Rovigo	RO	16657
IT	45018	Ca' Venier	Veneto	Rovigo	RO	16658
IT	45018	Scardovari	Veneto	Rovigo	RO	16659
IT	45018	Tolle	Veneto	Rovigo	RO	16660
IT	45018	Ca' Zuliani	Veneto	Rovigo	RO	16661
IT	45018	Boccasette	Veneto	Rovigo	RO	16662
IT	45018	Donzella	Veneto	Rovigo	RO	16663
IT	45018	Bonelli	Veneto	Rovigo	RO	16664
IT	45018	Ca' Tiepolo	Veneto	Rovigo	RO	16665
IT	45018	Porto Tolle	Veneto	Rovigo	RO	16666
IT	45018	Ivica	Veneto	Rovigo	RO	16667
IT	45019	Mazzorno	Veneto	Rovigo	RO	16668
IT	45019	Ca' Vendramin	Veneto	Rovigo	RO	16669
IT	45019	Polesinello	Veneto	Rovigo	RO	16670
IT	45019	Taglio Di Po	Veneto	Rovigo	RO	16671
IT	45019	Mazzorno Destro	Veneto	Rovigo	RO	16672
IT	45020	Canda	Veneto	Rovigo	RO	16673
IT	45020	Baruchella	Veneto	Rovigo	RO	16674
IT	45020	Cavazzana	Veneto	Rovigo	RO	16675
IT	45020	Zelo	Veneto	Rovigo	RO	16676
IT	45020	Giacciano Con Baruchella	Veneto	Rovigo	RO	16677
IT	45020	Lusia	Veneto	Rovigo	RO	16678
IT	45020	San Bellino	Veneto	Rovigo	RO	16679
IT	45020	Pincara	Veneto	Rovigo	RO	16680
IT	45020	Castelguglielmo	Veneto	Rovigo	RO	16681
IT	45020	Ca Morosini	Veneto	Rovigo	RO	16682
IT	45020	Villanova Del Ghebbo	Veneto	Rovigo	RO	16683
IT	45021	Salvaterra	Veneto	Rovigo	RO	16684
IT	45021	Villa D'Adige	Veneto	Rovigo	RO	16685
IT	45021	Colombano	Veneto	Rovigo	RO	16686
IT	45021	Badia Polesine	Veneto	Rovigo	RO	16687
IT	45022	Bagnolo Di Po	Veneto	Rovigo	RO	16688
IT	45023	Costa Di Rovigo	Veneto	Rovigo	RO	16689
IT	45024	Fiesso Umbertiano	Veneto	Rovigo	RO	16690
IT	45025	Fratta Polesine	Veneto	Rovigo	RO	16691
IT	45026	Barbuglio	Veneto	Rovigo	RO	16692
IT	45026	Lendinara	Veneto	Rovigo	RO	16693
IT	45026	Ramodipalo	Veneto	Rovigo	RO	16694
IT	45026	Saguedo	Veneto	Rovigo	RO	16695
IT	45026	Ramodipalo Rasa	Veneto	Rovigo	RO	16696
IT	45027	Trecenta	Veneto	Rovigo	RO	16697
IT	45027	Sariano	Veneto	Rovigo	RO	16698
IT	45027	Pissatola	Veneto	Rovigo	RO	16699
IT	45030	Beverare	Veneto	Rovigo	RO	16700
IT	45030	Gaiba	Veneto	Rovigo	RO	16701
IT	45030	Occhiobello	Veneto	Rovigo	RO	16702
IT	45030	Frassinelle Polesine	Veneto	Rovigo	RO	16703
IT	45030	Crespino	Veneto	Rovigo	RO	16704
IT	45030	Villamarzana	Veneto	Rovigo	RO	16705
IT	45030	Chiesa	Veneto	Rovigo	RO	16706
IT	45030	San Pietro Polesine	Veneto	Rovigo	RO	16707
IT	45030	Ceneselli	Veneto	Rovigo	RO	16708
IT	45030	Santa Maria Maddalena	Veneto	Rovigo	RO	16709
IT	45030	Salara	Veneto	Rovigo	RO	16710
IT	45030	San Martino Di Venezze	Veneto	Rovigo	RO	16711
IT	45030	Guarda Veneta	Veneto	Rovigo	RO	16712
IT	45030	Pontecchio Polesine	Veneto	Rovigo	RO	16713
IT	45030	Calto	Veneto	Rovigo	RO	16714
IT	45030	Castelnovo Bariano	Veneto	Rovigo	RO	16715
IT	45030	Trona Di Sopra	Veneto	Rovigo	RO	16716
IT	45030	Villanova Marchesana	Veneto	Rovigo	RO	16717
IT	45031	Arqua' Polesine	Veneto	Rovigo	RO	16718
IT	45031	Corne'	Veneto	Rovigo	RO	16719
IT	45032	Bergantino	Veneto	Rovigo	RO	16720
IT	45033	Bosaro	Veneto	Rovigo	RO	16721
IT	45034	Canaro	Veneto	Rovigo	RO	16722
IT	45034	Paviole	Veneto	Rovigo	RO	16723
IT	45035	Castelmassa	Veneto	Rovigo	RO	16724
IT	45036	Ficarolo	Veneto	Rovigo	RO	16725
IT	45037	Santo Stefano	Veneto	Rovigo	RO	16726
IT	45037	Melara	Veneto	Rovigo	RO	16727
IT	45038	Raccano	Veneto	Rovigo	RO	16728
IT	45038	Polesella	Veneto	Rovigo	RO	16729
IT	45039	Sabbioni	Veneto	Rovigo	RO	16730
IT	45039	Stienta	Veneto	Rovigo	RO	16731
IT	45039	Zampine	Veneto	Rovigo	RO	16732
IT	45100	Rovigo	Veneto	Rovigo	RO	16733
IT	45100	Boara Polesine	Veneto	Rovigo	RO	16734
IT	45100	Mardimago	Veneto	Rovigo	RO	16735
IT	45100	Grignano Polesine	Veneto	Rovigo	RO	16736
IT	45100	Concadirame	Veneto	Rovigo	RO	16737
IT	45100	Roverdicre'	Veneto	Rovigo	RO	16738
IT	45100	Granzette	Veneto	Rovigo	RO	16739
IT	45100	Sant'Apollinare	Veneto	Rovigo	RO	16740
IT	45100	Cantonazzo	Veneto	Rovigo	RO	16741
IT	45100	Buso Sarzano	Veneto	Rovigo	RO	16742
IT	45100	Borsea	Veneto	Rovigo	RO	16743
IT	45100	Sant'Apollinare Con Selva	Veneto	Rovigo	RO	16744
IT	31010	Osigo	Veneto	Treviso	TV	16745
IT	31010	Moriago Della Battaglia	Veneto	Treviso	TV	16746
IT	31010	Mareno Di Piave	Veneto	Treviso	TV	16747
IT	31010	Godega Di Sant'Urbano	Veneto	Treviso	TV	16748
IT	31010	Farra Di Soligo	Veneto	Treviso	TV	16749
IT	31010	Cimadolmo	Veneto	Treviso	TV	16750
IT	31010	Monfumo	Veneto	Treviso	TV	16751
IT	31010	Mosnigo	Veneto	Treviso	TV	16752
IT	31010	San Michele Di Piave	Veneto	Treviso	TV	16753
IT	31010	Col San Martino	Veneto	Treviso	TV	16754
IT	31010	Priula	Veneto	Treviso	TV	16755
IT	31010	Bibano	Veneto	Treviso	TV	16756
IT	31010	Colfosco	Veneto	Treviso	TV	16757
IT	31010	Pianzano	Veneto	Treviso	TV	16758
IT	31010	Santa Maria Del Piave	Veneto	Treviso	TV	16759
IT	31010	Fregona	Veneto	Treviso	TV	16760
IT	31010	Crespignaga	Veneto	Treviso	TV	16761
IT	31010	Santa Maria Di Piave	Veneto	Treviso	TV	16762
IT	31010	Orsago	Veneto	Treviso	TV	16763
IT	31010	Maser	Veneto	Treviso	TV	16764
IT	31010	Soligo	Veneto	Treviso	TV	16765
IT	31010	One'	Veneto	Treviso	TV	16766
IT	31010	Muliparte	Veneto	Treviso	TV	16767
IT	31010	Fonte Alto	Veneto	Treviso	TV	16768
IT	31010	Ponte Della Priula	Veneto	Treviso	TV	16769
IT	31010	Fonte	Veneto	Treviso	TV	16770
IT	31011	Pagnano	Veneto	Treviso	TV	16771
IT	31011	Villa D'Asolo	Veneto	Treviso	TV	16772
IT	31011	Asolo	Veneto	Treviso	TV	16773
IT	31011	Casella D'Asolo	Veneto	Treviso	TV	16774
IT	31012	Cappella Maggiore	Veneto	Treviso	TV	16775
IT	31012	Anzano	Veneto	Treviso	TV	16776
IT	31013	Roverbasso	Veneto	Treviso	TV	16777
IT	31013	Codogne'	Veneto	Treviso	TV	16778
IT	31013	Cimetta	Veneto	Treviso	TV	16779
IT	31014	Colle Umberto	Veneto	Treviso	TV	16780
IT	31014	San Martino Di Colle Umberto	Veneto	Treviso	TV	16781
IT	31014	San Martino	Veneto	Treviso	TV	16782
IT	31015	Scomigo	Veneto	Treviso	TV	16783
IT	31015	Collalbrigo	Veneto	Treviso	TV	16784
IT	31015	Conegliano	Veneto	Treviso	TV	16785
IT	31016	Cordignano	Veneto	Treviso	TV	16786
IT	31016	Villa Di Villa	Veneto	Treviso	TV	16787
IT	31017	Crespano Del Grappa	Veneto	Treviso	TV	16788
IT	31017	Paderno Del Grappa	Veneto	Treviso	TV	16789
IT	31018	Albina	Veneto	Treviso	TV	16790
IT	31018	Campomolino	Veneto	Treviso	TV	16791
IT	31018	Gaiarine	Veneto	Treviso	TV	16792
IT	31018	Francenigo	Veneto	Treviso	TV	16793
IT	31020	Lancenigo	Veneto	Treviso	TV	16794
IT	31020	Lago	Veneto	Treviso	TV	16795
IT	31020	Falze' Di Piave	Veneto	Treviso	TV	16796
IT	31020	Tarzo	Veneto	Treviso	TV	16797
IT	31020	Zoppe'	Veneto	Treviso	TV	16798
IT	31020	Cosniga	Veneto	Treviso	TV	16799
IT	31020	Fossamerlo	Veneto	Treviso	TV	16800
IT	31020	Sernaglia Della Battaglia	Veneto	Treviso	TV	16801
IT	31020	San Pietro Di Feletto	Veneto	Treviso	TV	16802
IT	31020	San Fior Di Sotto	Veneto	Treviso	TV	16803
IT	31020	Castello Roganzuolo	Veneto	Treviso	TV	16804
IT	31020	Rua	Veneto	Treviso	TV	16805
IT	31020	San Polo Di Piave	Veneto	Treviso	TV	16806
IT	31020	Liedolo	Veneto	Treviso	TV	16807
IT	31020	San Fior	Veneto	Treviso	TV	16808
IT	31020	Villorba	Veneto	Treviso	TV	16809
IT	31020	Ca' Rainati	Veneto	Treviso	TV	16810
IT	31020	Bagnolo	Veneto	Treviso	TV	16811
IT	31020	San Zenone Degli Ezzelini	Veneto	Treviso	TV	16812
IT	31020	Refrontolo	Veneto	Treviso	TV	16813
IT	31020	Revine	Veneto	Treviso	TV	16814
IT	31020	Vidor	Veneto	Treviso	TV	16815
IT	31020	San Fior Di Sopra	Veneto	Treviso	TV	16816
IT	31020	Corbanese	Veneto	Treviso	TV	16817
IT	31020	San Vendemiano	Veneto	Treviso	TV	16818
IT	31020	Revine Lago	Veneto	Treviso	TV	16819
IT	31021	Marocco	Veneto	Treviso	TV	16820
IT	31021	Bonisiolo	Veneto	Treviso	TV	16821
IT	31021	Campocroce	Veneto	Treviso	TV	16822
IT	31021	Mogliano Veneto	Veneto	Treviso	TV	16823
IT	31021	Zerman	Veneto	Treviso	TV	16824
IT	31022	Preganziol	Veneto	Treviso	TV	16825
IT	31022	Sambughe	Veneto	Treviso	TV	16826
IT	31022	San Trovaso	Veneto	Treviso	TV	16827
IT	31022	Borgo Verde	Veneto	Treviso	TV	16828
IT	31022	Frescada	Veneto	Treviso	TV	16829
IT	31023	Castelminio	Veneto	Treviso	TV	16830
IT	31023	San Marco	Veneto	Treviso	TV	16831
IT	31023	Resana	Veneto	Treviso	TV	16832
IT	31024	Ormelle	Veneto	Treviso	TV	16833
IT	31024	Roncadelle	Veneto	Treviso	TV	16834
IT	31025	Santa Lucia Di Piave	Veneto	Treviso	TV	16835
IT	31026	Montaner	Veneto	Treviso	TV	16836
IT	31026	Sarmede	Veneto	Treviso	TV	16837
IT	31027	Visnadello	Veneto	Treviso	TV	16838
IT	31027	Spresiano	Veneto	Treviso	TV	16839
IT	31027	Lovadina	Veneto	Treviso	TV	16840
IT	31028	Tezze	Veneto	Treviso	TV	16841
IT	31028	Visna'	Veneto	Treviso	TV	16842
IT	31028	Vazzola	Veneto	Treviso	TV	16843
IT	31029	Fadalto	Veneto	Treviso	TV	16844
IT	31029	Cozzuolo	Veneto	Treviso	TV	16845
IT	31029	Vittorio Veneto	Veneto	Treviso	TV	16846
IT	31029	Carpesica	Veneto	Treviso	TV	16847
IT	31029	Nove	Veneto	Treviso	TV	16848
IT	31029	San Floriano	Veneto	Treviso	TV	16849
IT	31029	San Giacomo Di Veglia	Veneto	Treviso	TV	16850
IT	31030	San Vito Di Altivole	Veneto	Treviso	TV	16851
IT	31030	Saletto	Veneto	Treviso	TV	16852
IT	31030	Mignagola	Veneto	Treviso	TV	16853
IT	31030	Dosson	Veneto	Treviso	TV	16854
IT	31030	Valla'	Veneto	Treviso	TV	16855
IT	31030	Altivole	Veneto	Treviso	TV	16856
IT	31030	Borso Del Grappa	Veneto	Treviso	TV	16857
IT	31030	Casier	Veneto	Treviso	TV	16858
IT	31030	Vacil	Veneto	Treviso	TV	16859
IT	31030	Carbonera	Veneto	Treviso	TV	16860
IT	31030	Arcade	Veneto	Treviso	TV	16861
IT	31030	Cison Di Valmarino	Veneto	Treviso	TV	16862
IT	31030	Caselle Di Altivole	Veneto	Treviso	TV	16863
IT	31030	Castelcucco	Veneto	Treviso	TV	16864
IT	31030	Pero	Veneto	Treviso	TV	16865
IT	31030	Breda Di Piave	Veneto	Treviso	TV	16866
IT	31030	Sant'Eulalia	Veneto	Treviso	TV	16867
IT	31030	San Bartolomeo	Veneto	Treviso	TV	16868
IT	31030	Tovena	Veneto	Treviso	TV	16869
IT	31030	Castello Di Godego	Veneto	Treviso	TV	16870
IT	31030	Semonzo	Veneto	Treviso	TV	16871
IT	31031	Caerano Di San Marco	Veneto	Treviso	TV	16872
IT	31032	Conscio	Veneto	Treviso	TV	16873
IT	31032	Casale Sul Sile	Veneto	Treviso	TV	16874
IT	31032	Lughignano	Veneto	Treviso	TV	16875
IT	31033	Castelfranco Veneto	Veneto	Treviso	TV	16876
IT	31033	Salvatronda	Veneto	Treviso	TV	16877
IT	31033	Villarazzo	Veneto	Treviso	TV	16878
IT	31033	Sant'Andrea	Veneto	Treviso	TV	16879
IT	31033	Salvarosa	Veneto	Treviso	TV	16880
IT	31034	Cavaso Del Tomba	Veneto	Treviso	TV	16881
IT	31035	Crocetta Del Montello	Veneto	Treviso	TV	16882
IT	31035	Ciano	Veneto	Treviso	TV	16883
IT	31035	Ciano Del Montello	Veneto	Treviso	TV	16884
IT	31036	Istrana	Veneto	Treviso	TV	16885
IT	31036	Ospedaletto	Veneto	Treviso	TV	16886
IT	31036	Pezzan	Veneto	Treviso	TV	16887
IT	31036	Sala	Veneto	Treviso	TV	16888
IT	31037	Bessica	Veneto	Treviso	TV	16889
IT	31037	Ramon Campagna	Veneto	Treviso	TV	16890
IT	31037	Loria	Veneto	Treviso	TV	16891
IT	31037	Castione	Veneto	Treviso	TV	16892
IT	31038	Castagnole	Veneto	Treviso	TV	16893
IT	31038	Paese	Veneto	Treviso	TV	16894
IT	31038	Padernello	Veneto	Treviso	TV	16895
IT	31038	Postioma	Veneto	Treviso	TV	16896
IT	31038	Porcellengo	Veneto	Treviso	TV	16897
IT	31039	Poggiana	Veneto	Treviso	TV	16898
IT	31039	Riese Pio X	Veneto	Treviso	TV	16899
IT	31039	Spineda	Veneto	Treviso	TV	16900
IT	31040	Meduna Di Livenza	Veneto	Treviso	TV	16901
IT	31040	Cessalto	Veneto	Treviso	TV	16902
IT	31040	Gorgo Al Monticano	Veneto	Treviso	TV	16903
IT	31040	Campo Di Pietra	Veneto	Treviso	TV	16904
IT	31040	Segusino	Veneto	Treviso	TV	16905
IT	31040	Bavaria	Veneto	Treviso	TV	16906
IT	31040	Selva Del Montello	Veneto	Treviso	TV	16907
IT	31040	Giavera Del Montello	Veneto	Treviso	TV	16908
IT	31040	Onigo	Veneto	Treviso	TV	16909
IT	31040	Santi Angeli	Veneto	Treviso	TV	16910
IT	31040	Mansue'	Veneto	Treviso	TV	16911
IT	31040	Covolo	Veneto	Treviso	TV	16912
IT	31040	Portobuffole'	Veneto	Treviso	TV	16913
IT	31040	Salgareda	Veneto	Treviso	TV	16914
IT	31040	Chiarano	Veneto	Treviso	TV	16915
IT	31040	Trevignano	Veneto	Treviso	TV	16916
IT	31040	Fossalta Maggiore	Veneto	Treviso	TV	16917
IT	31040	Campo Di Pietra Di Salgareda	Veneto	Treviso	TV	16918
IT	31040	Nervesa Della Battaglia	Veneto	Treviso	TV	16919
IT	31040	Volpago Del Montello	Veneto	Treviso	TV	16920
IT	31040	Venegazzu'	Veneto	Treviso	TV	16921
IT	31040	Santi Angeli Del Montello	Veneto	Treviso	TV	16922
IT	31040	Falze'	Veneto	Treviso	TV	16923
IT	31040	Musano	Veneto	Treviso	TV	16924
IT	31040	Signoressa	Veneto	Treviso	TV	16925
IT	31040	Musano Di Trevignano	Veneto	Treviso	TV	16926
IT	31040	Cusignana	Veneto	Treviso	TV	16927
IT	31040	Pederobba	Veneto	Treviso	TV	16928
IT	31041	Cornuda	Veneto	Treviso	TV	16929
IT	31042	Fagare'	Veneto	Treviso	TV	16930
IT	31042	Fagare' Della Battaglia	Veneto	Treviso	TV	16931
IT	31043	Fontanelle	Veneto	Treviso	TV	16932
IT	31043	Lutrano	Veneto	Treviso	TV	16933
IT	31044	Montebelluna	Veneto	Treviso	TV	16934
IT	31044	Biadene	Veneto	Treviso	TV	16935
IT	31045	Motta Di Livenza	Veneto	Treviso	TV	16936
IT	31046	Piavon	Veneto	Treviso	TV	16937
IT	31046	Oderzo	Veneto	Treviso	TV	16938
IT	31046	Rustigne'	Veneto	Treviso	TV	16939
IT	31046	Fae'	Veneto	Treviso	TV	16940
IT	31047	Ponte Di Piave	Veneto	Treviso	TV	16941
IT	31047	Levada	Veneto	Treviso	TV	16942
IT	31047	Negrisia	Veneto	Treviso	TV	16943
IT	31048	San Biagio Di Callalta	Veneto	Treviso	TV	16944
IT	31048	Cavrie	Veneto	Treviso	TV	16945
IT	31048	Olmi Di Treviso	Veneto	Treviso	TV	16946
IT	31048	Spercenigo	Veneto	Treviso	TV	16947
IT	31048	Olmi	Veneto	Treviso	TV	16948
IT	31049	Pianezze	Veneto	Treviso	TV	16949
IT	31049	Guia	Veneto	Treviso	TV	16950
IT	31049	Santo Stefano	Veneto	Treviso	TV	16951
IT	31049	Bigolino	Veneto	Treviso	TV	16952
IT	31049	Valdobbiadene	Veneto	Treviso	TV	16953
IT	31049	San Pietro Di Barbozza	Veneto	Treviso	TV	16954
IT	31049	San Vito Di Valdobbiadene	Veneto	Treviso	TV	16955
IT	31050	Barcon	Veneto	Treviso	TV	16956
IT	31050	Morgano	Veneto	Treviso	TV	16957
IT	31050	Santandra'	Veneto	Treviso	TV	16958
IT	31050	Cavasagra Di Vedelago	Veneto	Treviso	TV	16959
IT	31050	Carpenedo	Veneto	Treviso	TV	16960
IT	31050	Combai	Veneto	Treviso	TV	16961
IT	31050	Monastier Di Treviso	Veneto	Treviso	TV	16962
IT	31050	Fanzolo	Veneto	Treviso	TV	16963
IT	31050	Zenson Di Piave	Veneto	Treviso	TV	16964
IT	31050	Vascon	Veneto	Treviso	TV	16965
IT	31050	Cavasagra	Veneto	Treviso	TV	16966
IT	31050	Vedelago	Veneto	Treviso	TV	16967
IT	31050	Badoere	Veneto	Treviso	TV	16968
IT	31050	Fossalunga	Veneto	Treviso	TV	16969
IT	31050	Povegliano	Veneto	Treviso	TV	16970
IT	31050	Miane	Veneto	Treviso	TV	16971
IT	31050	Casacorba	Veneto	Treviso	TV	16972
IT	31050	Ponzano Veneto	Veneto	Treviso	TV	16973
IT	31050	Camalo'	Veneto	Treviso	TV	16974
IT	31050	Albaredo	Veneto	Treviso	TV	16975
IT	31050	Premaor	Veneto	Treviso	TV	16976
IT	31051	Pedeguarda	Veneto	Treviso	TV	16977
IT	31051	Follina	Veneto	Treviso	TV	16978
IT	31051	Valmareno	Veneto	Treviso	TV	16979
IT	31052	Candelu'	Veneto	Treviso	TV	16980
IT	31052	Varago	Veneto	Treviso	TV	16981
IT	31052	Maserada Sul Piave	Veneto	Treviso	TV	16982
IT	31053	Barbisano	Veneto	Treviso	TV	16983
IT	31053	Pieve Di Soligo	Veneto	Treviso	TV	16984
IT	31053	Solighetto	Veneto	Treviso	TV	16985
IT	31054	Possagno	Veneto	Treviso	TV	16986
IT	31055	Quinto Di Treviso	Veneto	Treviso	TV	16987
IT	31055	Santa Cristina	Veneto	Treviso	TV	16988
IT	31056	San Cipriano	Veneto	Treviso	TV	16989
IT	31056	Biancade	Veneto	Treviso	TV	16990
IT	31056	Musestre	Veneto	Treviso	TV	16991
IT	31056	Roncade	Veneto	Treviso	TV	16992
IT	31057	Sant'Elena	Veneto	Treviso	TV	16993
IT	31057	Cendon	Veneto	Treviso	TV	16994
IT	31057	Silea	Veneto	Treviso	TV	16995
IT	31058	Susegana	Veneto	Treviso	TV	16996
IT	31059	Scandolara	Veneto	Treviso	TV	16997
IT	31059	Sant'Alberto	Veneto	Treviso	TV	16998
IT	31059	Zero Branco	Veneto	Treviso	TV	16999
IT	31100	Canizzano	Veneto	Treviso	TV	17000
IT	31100	Treviso	Veneto	Treviso	TV	17001
IT	31100	Monigo	Veneto	Treviso	TV	17002
IT	31100	Fiera	Veneto	Treviso	TV	17003
IT	31100	Santa Maria Della Rovere	Veneto	Treviso	TV	17004
IT	31100	Selvana Bassa	Veneto	Treviso	TV	17005
IT	30010	Lova	Veneto	Venezia	VE	17006
IT	30010	Pegolotte	Veneto	Venezia	VE	17007
IT	30010	Camponogara	Veneto	Venezia	VE	17008
IT	30010	Campagna Lupia	Veneto	Venezia	VE	17009
IT	30010	Lughetto	Veneto	Venezia	VE	17010
IT	30010	Cantarana	Veneto	Venezia	VE	17011
IT	30010	Cona	Veneto	Venezia	VE	17012
IT	30010	Bojon	Veneto	Venezia	VE	17013
IT	30010	Campolongo Maggiore	Veneto	Venezia	VE	17014
IT	30010	Liettoli	Veneto	Venezia	VE	17015
IT	30013	Cavallino	Veneto	Venezia	VE	17016
IT	30013	Ca' Ballarin	Veneto	Venezia	VE	17017
IT	30013	Treporti	Veneto	Venezia	VE	17018
IT	30013	Ca' Pasquali	Veneto	Venezia	VE	17019
IT	30013	Ca' Savio	Veneto	Venezia	VE	17020
IT	30013	Cavallino Treporti	Veneto	Venezia	VE	17021
IT	30014	Villaggio Busonera	Veneto	Venezia	VE	17022
IT	30014	Cavarzere	Veneto	Venezia	VE	17023
IT	30014	San Pietro Di Cavarzere	Veneto	Venezia	VE	17024
IT	30014	Rottanova Di Cavarzere	Veneto	Venezia	VE	17025
IT	30014	Boscochiaro	Veneto	Venezia	VE	17026
IT	30014	Rottanova	Veneto	Venezia	VE	17027
IT	30014	San Pietro	Veneto	Venezia	VE	17028
IT	30015	Chioggia	Veneto	Venezia	VE	17029
IT	30015	Cavanella D'Adige	Veneto	Venezia	VE	17030
IT	30015	Sottomarina	Veneto	Venezia	VE	17031
IT	30015	Valli	Veneto	Venezia	VE	17032
IT	30015	Ca' Bianca	Veneto	Venezia	VE	17033
IT	30015	Sant'Anna Di Chioggia	Veneto	Venezia	VE	17034
IT	30015	Sant'Anna	Veneto	Venezia	VE	17035
IT	30016	Iesolo	Veneto	Venezia	VE	17036
IT	30016	Lido Di Iesolo	Veneto	Venezia	VE	17037
IT	30020	Losson Della Battaglia	Veneto	Venezia	VE	17038
IT	30020	Pramaggiore	Veneto	Venezia	VE	17039
IT	30020	Eraclea Mare	Veneto	Venezia	VE	17040
IT	30020	Giai	Veneto	Venezia	VE	17041
IT	30020	Gruaro	Veneto	Venezia	VE	17042
IT	30020	Belfiore	Veneto	Venezia	VE	17043
IT	30020	Loncon	Veneto	Venezia	VE	17044
IT	30020	Fossalta Di Piave	Veneto	Venezia	VE	17045
IT	30020	Stretti	Veneto	Venezia	VE	17046
IT	30020	Noventa Di Piave	Veneto	Venezia	VE	17047
IT	30020	Quarto D'Altino	Veneto	Venezia	VE	17048
IT	30020	Stretti Di Eraclea	Veneto	Venezia	VE	17049
IT	30020	San Liberale	Veneto	Venezia	VE	17050
IT	30020	Torre Di Fine	Veneto	Venezia	VE	17051
IT	30020	Gaggio	Veneto	Venezia	VE	17052
IT	30020	Eraclea	Veneto	Venezia	VE	17053
IT	30020	Pramaggiore Blessaglia	Veneto	Venezia	VE	17054
IT	30020	Bagnara	Veneto	Venezia	VE	17055
IT	30020	Cinto Caomaggiore	Veneto	Venezia	VE	17056
IT	30020	Annone Veneto	Veneto	Venezia	VE	17057
IT	30020	Ponte Crepaldo	Veneto	Venezia	VE	17058
IT	30020	Torre Di Mosto	Veneto	Venezia	VE	17059
IT	30020	Marcon	Veneto	Venezia	VE	17060
IT	30020	Portegrandi	Veneto	Venezia	VE	17061
IT	30020	Meolo	Veneto	Venezia	VE	17062
IT	30021	Caorle	Veneto	Venezia	VE	17063
IT	30021	Porto Santa Margherita	Veneto	Venezia	VE	17064
IT	30021	San Gaetano	Veneto	Venezia	VE	17065
IT	30021	San Giorgio Di Livenza	Veneto	Venezia	VE	17066
IT	30021	Ca' Corniani	Veneto	Venezia	VE	17067
IT	30022	Ceggia	Veneto	Venezia	VE	17068
IT	30023	Concordia Sagittaria	Veneto	Venezia	VE	17069
IT	30023	Sindacale	Veneto	Venezia	VE	17070
IT	30024	Croce	Veneto	Venezia	VE	17071
IT	30024	Musile Di Piave	Veneto	Venezia	VE	17072
IT	30025	Fratta	Veneto	Venezia	VE	17073
IT	30025	Cintello	Veneto	Venezia	VE	17074
IT	30025	Teglio Veneto	Veneto	Venezia	VE	17075
IT	30025	Villanova Santa Margherita	Veneto	Venezia	VE	17076
IT	30025	Fossalta Di Portogruaro	Veneto	Venezia	VE	17077
IT	30026	Lugugnana	Veneto	Venezia	VE	17078
IT	30026	Portogruaro	Veneto	Venezia	VE	17079
IT	30026	Pradipozzo	Veneto	Venezia	VE	17080
IT	30026	Summaga	Veneto	Venezia	VE	17081
IT	30027	Calvecchia	Veneto	Venezia	VE	17082
IT	30027	Passarella	Veneto	Venezia	VE	17083
IT	30027	San Dona' Di Piave	Veneto	Venezia	VE	17084
IT	30028	Bibione Pineda	Veneto	Venezia	VE	17085
IT	30028	San Giorgio Al Tagliamento	Veneto	Venezia	VE	17086
IT	30028	Bibione	Veneto	Venezia	VE	17087
IT	30028	Cesarolo	Veneto	Venezia	VE	17088
IT	30028	Pozzi	Veneto	Venezia	VE	17089
IT	30028	Pozzi San Michele Tagliamento	Veneto	Venezia	VE	17090
IT	30028	San Michele Al Tagliamento	Veneto	Venezia	VE	17091
IT	30029	La Salute Di Livenza	Veneto	Venezia	VE	17092
IT	30029	Corbolone	Veneto	Venezia	VE	17093
IT	30029	Santo Stino Di Livenza	Veneto	Venezia	VE	17094
IT	30030	Martellago	Veneto	Venezia	VE	17095
IT	30030	Cazzago Di Pianiga	Veneto	Venezia	VE	17096
IT	30030	Tombelle	Veneto	Venezia	VE	17097
IT	30030	Maerne	Veneto	Venezia	VE	17098
IT	30030	Fosso'	Veneto	Venezia	VE	17099
IT	30030	Olmo	Veneto	Venezia	VE	17100
IT	30030	Sandon	Veneto	Venezia	VE	17101
IT	30030	Galta	Veneto	Venezia	VE	17102
IT	30030	Pianiga	Veneto	Venezia	VE	17103
IT	30030	Salzano	Veneto	Venezia	VE	17104
IT	30030	Robegano	Veneto	Venezia	VE	17105
IT	30030	Cazzago	Veneto	Venezia	VE	17106
IT	30030	Vigonovo	Veneto	Venezia	VE	17107
IT	30030	Olmo Di Martellago	Veneto	Venezia	VE	17108
IT	30031	Arino	Veneto	Venezia	VE	17109
IT	30031	Dolo	Veneto	Venezia	VE	17110
IT	30031	Sambruson	Veneto	Venezia	VE	17111
IT	30032	Fiesso D'Artico	Veneto	Venezia	VE	17112
IT	30033	Noale	Veneto	Venezia	VE	17113
IT	30033	Moniego Di Noale	Veneto	Venezia	VE	17114
IT	30033	Cappelletta	Veneto	Venezia	VE	17115
IT	30033	Moniego	Veneto	Venezia	VE	17116
IT	30034	Mira Taglio	Veneto	Venezia	VE	17117
IT	30034	Oriago	Veneto	Venezia	VE	17118
IT	30034	Mira	Veneto	Venezia	VE	17119
IT	30034	Marano	Veneto	Venezia	VE	17120
IT	30034	Borbiago	Veneto	Venezia	VE	17121
IT	30034	Marano Veneziano	Veneto	Venezia	VE	17122
IT	30034	Gambarare	Veneto	Venezia	VE	17123
IT	30034	Mira Porte	Veneto	Venezia	VE	17124
IT	30035	Ballo'	Veneto	Venezia	VE	17125
IT	30035	Vetrego	Veneto	Venezia	VE	17126
IT	30035	Scaltenigo	Veneto	Venezia	VE	17127
IT	30035	Zianigo	Veneto	Venezia	VE	17128
IT	30035	Mirano	Veneto	Venezia	VE	17129
IT	30036	Sant'Angelo	Veneto	Venezia	VE	17130
IT	30036	Veternigo	Veneto	Venezia	VE	17131
IT	30036	Santa Maria Di Sala	Veneto	Venezia	VE	17132
IT	30036	Stigliano	Veneto	Venezia	VE	17133
IT	30036	Caltana	Veneto	Venezia	VE	17134
IT	30037	Scorze'	Veneto	Venezia	VE	17135
IT	30037	Peseggia	Veneto	Venezia	VE	17136
IT	30037	Rio San Martino	Veneto	Venezia	VE	17137
IT	30038	Fornase	Veneto	Venezia	VE	17138
IT	30038	Spinea	Veneto	Venezia	VE	17139
IT	30038	Orgnano	Veneto	Venezia	VE	17140
IT	30039	Paluello	Veneto	Venezia	VE	17141
IT	30039	Stra	Veneto	Venezia	VE	17142
IT	30039	San Pietro Di Stra'	Veneto	Venezia	VE	17143
IT	30100	Venezia	Veneto	Venezia	VE	17144
IT	30121	Cannaregio	Veneto	Venezia	VE	17145
IT	30121	Venezia	Veneto	Venezia	VE	17146
IT	30122	Castello	Veneto	Venezia	VE	17147
IT	30122	Sant'Elena	Veneto	Venezia	VE	17148
IT	30122	Venezia	Veneto	Venezia	VE	17149
IT	30123	Dorsoduro	Veneto	Venezia	VE	17150
IT	30123	Venezia	Veneto	Venezia	VE	17151
IT	30124	San Marco	Veneto	Venezia	VE	17152
IT	30124	Venezia	Veneto	Venezia	VE	17153
IT	30125	San Polo	Veneto	Venezia	VE	17154
IT	30125	Venezia	Veneto	Venezia	VE	17155
IT	30126	Alberoni	Veneto	Venezia	VE	17156
IT	30126	San Pietro In Volta	Veneto	Venezia	VE	17157
IT	30126	Malamocco	Veneto	Venezia	VE	17158
IT	30126	Lido	Veneto	Venezia	VE	17159
IT	30126	Vianelli	Veneto	Venezia	VE	17160
IT	30126	Venezia	Veneto	Venezia	VE	17161
IT	30126	Portosecco	Veneto	Venezia	VE	17162
IT	30126	Zennari	Veneto	Venezia	VE	17163
IT	30126	Lido Di Venezia	Veneto	Venezia	VE	17164
IT	30126	Busetti	Veneto	Venezia	VE	17165
IT	30126	Scarpa	Veneto	Venezia	VE	17166
IT	30131	Venezia	Veneto	Venezia	VE	17167
IT	30132	Sant'Elena	Veneto	Venezia	VE	17168
IT	30132	Venezia	Veneto	Venezia	VE	17169
IT	30133	Giudecca	Veneto	Venezia	VE	17170
IT	30133	Sacca Fisola	Veneto	Venezia	VE	17171
IT	30133	Venezia	Veneto	Venezia	VE	17172
IT	30135	Santa Croce	Veneto	Venezia	VE	17173
IT	30135	Venezia	Veneto	Venezia	VE	17174
IT	30141	Murano	Veneto	Venezia	VE	17175
IT	30141	Venezia	Veneto	Venezia	VE	17176
IT	30142	Mazzorbo	Veneto	Venezia	VE	17177
IT	30142	San Martino Destra	Veneto	Venezia	VE	17178
IT	30142	Burano	Veneto	Venezia	VE	17179
IT	30142	San Mauro	Veneto	Venezia	VE	17180
IT	30142	Giudecca Di Burano	Veneto	Venezia	VE	17181
IT	30142	Terranova	Veneto	Venezia	VE	17182
IT	30142	San Martino Sinistra	Veneto	Venezia	VE	17183
IT	30170	Venezia Mestre	Veneto	Venezia	VE	17184
IT	30171	Mestre	Veneto	Venezia	VE	17185
IT	30172	Mestre	Veneto	Venezia	VE	17186
IT	30173	Campalto	Veneto	Venezia	VE	17187
IT	30173	Venezia	Veneto	Venezia	VE	17188
IT	30173	Villaggio San Marco	Veneto	Venezia	VE	17189
IT	30173	Mestre	Veneto	Venezia	VE	17190
IT	30174	Zelarino	Veneto	Venezia	VE	17191
IT	30174	Gazzera	Veneto	Venezia	VE	17192
IT	30174	Mestre	Veneto	Venezia	VE	17193
IT	30175	Marghera	Veneto	Venezia	VE	17194
IT	30175	Carpenedo	Veneto	Venezia	VE	17195
IT	30175	Ca' Emiliani	Veneto	Venezia	VE	17196
IT	30175	Mestre	Veneto	Venezia	VE	17197
IT	36010	Posina	Veneto	Vicenza	VI	17198
IT	36010	Cesuna	Veneto	Vicenza	VI	17199
IT	36010	Vigardolo	Veneto	Vicenza	VI	17200
IT	36010	Chiuppano	Veneto	Vicenza	VI	17201
IT	36010	Seghe Di Velo	Veneto	Vicenza	VI	17202
IT	36010	Camporovere	Veneto	Vicenza	VI	17203
IT	36010	Mezzaselva Di Roana	Veneto	Vicenza	VI	17204
IT	36010	Velo	Veneto	Vicenza	VI	17205
IT	36010	Cavazzale	Veneto	Vicenza	VI	17206
IT	36010	Foza	Veneto	Vicenza	VI	17207
IT	36010	Tresche' Conca	Veneto	Vicenza	VI	17208
IT	36010	Seghe	Veneto	Vicenza	VI	17209
IT	36010	Zane'	Veneto	Vicenza	VI	17210
IT	36010	Roana	Veneto	Vicenza	VI	17211
IT	36010	Velo D'Astico	Veneto	Vicenza	VI	17212
IT	36010	Cogollo Del Cengio	Veneto	Vicenza	VI	17213
IT	36010	Canove Di Roana	Veneto	Vicenza	VI	17214
IT	36010	Laghi	Veneto	Vicenza	VI	17215
IT	36010	Carre'	Veneto	Vicenza	VI	17216
IT	36010	Monticello Conte Otto	Veneto	Vicenza	VI	17217
IT	36010	Rotzo	Veneto	Vicenza	VI	17218
IT	36011	Arsiero	Veneto	Vicenza	VI	17219
IT	36011	Castana	Veneto	Vicenza	VI	17220
IT	36012	Asiago	Veneto	Vicenza	VI	17221
IT	36012	Rigoni	Veneto	Vicenza	VI	17222
IT	36012	Sasso	Veneto	Vicenza	VI	17223
IT	36012	Rodeghieri	Veneto	Vicenza	VI	17224
IT	36013	Piovene Rocchette	Veneto	Vicenza	VI	17225
IT	36014	Santorso	Veneto	Vicenza	VI	17226
IT	36015	Monte Magre'	Veneto	Vicenza	VI	17227
IT	36015	Giavenale	Veneto	Vicenza	VI	17228
IT	36015	Magre' Di Schio	Veneto	Vicenza	VI	17229
IT	36015	Schio	Veneto	Vicenza	VI	17230
IT	36015	Tretto	Veneto	Vicenza	VI	17231
IT	36015	Sant'Ulderico	Veneto	Vicenza	VI	17232
IT	36015	Sant'Ulderico Di Tretto	Veneto	Vicenza	VI	17233
IT	36016	Rozzampia	Veneto	Vicenza	VI	17234
IT	36016	Thiene	Veneto	Vicenza	VI	17235
IT	36020	Carpane'	Veneto	Vicenza	VI	17236
IT	36020	Albettone	Veneto	Vicenza	VI	17237
IT	36020	Ponte Di Castegnero	Veneto	Vicenza	VI	17238
IT	36020	Campiglia Dei Berici	Veneto	Vicenza	VI	17239
IT	36020	Asigliano Veneto	Veneto	Vicenza	VI	17240
IT	36020	Castegnero	Veneto	Vicenza	VI	17241
IT	36020	Pove Del Grappa	Veneto	Vicenza	VI	17242
IT	36020	Solagna	Veneto	Vicenza	VI	17243
IT	36020	Villaganzerla	Veneto	Vicenza	VI	17244
IT	36020	Zovencedo	Veneto	Vicenza	VI	17245
IT	36020	Campolongo Sul Brenta	Veneto	Vicenza	VI	17246
IT	36020	San Marino	Veneto	Vicenza	VI	17247
IT	36020	Valstagna	Veneto	Vicenza	VI	17248
IT	36020	San Nazario	Veneto	Vicenza	VI	17249
IT	36020	Agugliaro	Veneto	Vicenza	VI	17250
IT	36020	Primolano	Veneto	Vicenza	VI	17251
IT	36020	Cismon Del Grappa	Veneto	Vicenza	VI	17252
IT	36021	Villaga	Veneto	Vicenza	VI	17253
IT	36021	Ponte Di Barbarano	Veneto	Vicenza	VI	17254
IT	36021	Barbarano Vicentino	Veneto	Vicenza	VI	17255
IT	36022	Cassola	Veneto	Vicenza	VI	17256
IT	36022	San Giuseppe	Veneto	Vicenza	VI	17257
IT	36022	San Zeno	Veneto	Vicenza	VI	17258
IT	36022	San Giuseppe Di Cassola	Veneto	Vicenza	VI	17259
IT	36023	Bugano	Veneto	Vicenza	VI	17260
IT	36023	Lumignano	Veneto	Vicenza	VI	17261
IT	36023	Longare	Veneto	Vicenza	VI	17262
IT	36024	Nanto	Veneto	Vicenza	VI	17263
IT	36024	Mossano	Veneto	Vicenza	VI	17264
IT	36024	Ponte Di Nanto	Veneto	Vicenza	VI	17265
IT	36025	Noventa Vicentina	Veneto	Vicenza	VI	17266
IT	36026	Cagnano	Veneto	Vicenza	VI	17267
IT	36026	Poiana Maggiore	Veneto	Vicenza	VI	17268
IT	36027	Rosa'	Veneto	Vicenza	VI	17269
IT	36028	Rossano Veneto	Veneto	Vicenza	VI	17270
IT	36030	Monte Di Malo	Veneto	Vicenza	VI	17271
IT	36030	Caldogno	Veneto	Vicenza	VI	17272
IT	36030	Preara	Veneto	Vicenza	VI	17273
IT	36030	Centrale	Veneto	Vicenza	VI	17274
IT	36030	Calvene	Veneto	Vicenza	VI	17275
IT	36030	Leva'	Veneto	Vicenza	VI	17276
IT	36030	San Giorgio Di Perlena	Veneto	Vicenza	VI	17277
IT	36030	Costabissara	Veneto	Vicenza	VI	17278
IT	36030	Montecchio Precalcino	Veneto	Vicenza	VI	17279
IT	36030	Priabona	Veneto	Vicenza	VI	17280
IT	36030	Sant'Antonio	Veneto	Vicenza	VI	17281
IT	36030	Valli Del Pasubio	Veneto	Vicenza	VI	17282
IT	36030	Lugo Di Vicenza	Veneto	Vicenza	VI	17283
IT	36030	San Vito Di Leguzzano	Veneto	Vicenza	VI	17284
IT	36030	Grumolo Pedemonte	Veneto	Vicenza	VI	17285
IT	36030	Villaverla	Veneto	Vicenza	VI	17286
IT	36030	Motta	Veneto	Vicenza	VI	17287
IT	36030	Caltrano	Veneto	Vicenza	VI	17288
IT	36030	Staro	Veneto	Vicenza	VI	17289
IT	36030	Zugliano	Veneto	Vicenza	VI	17290
IT	36030	Novoledo	Veneto	Vicenza	VI	17291
IT	36030	Sarcedo	Veneto	Vicenza	VI	17292
IT	36030	Rettorgole	Veneto	Vicenza	VI	17293
IT	36030	Fara Vicentino	Veneto	Vicenza	VI	17294
IT	36030	Sant'Antonio Valli	Veneto	Vicenza	VI	17295
IT	36030	Leva' Di Montecchio Precalcino	Veneto	Vicenza	VI	17296
IT	36030	Cresole	Veneto	Vicenza	VI	17297
IT	36031	Dueville	Veneto	Vicenza	VI	17298
IT	36031	Povolaro	Veneto	Vicenza	VI	17299
IT	36032	Gallio	Veneto	Vicenza	VI	17300
IT	36033	Castelnovo	Veneto	Vicenza	VI	17301
IT	36033	Isola Vicentina	Veneto	Vicenza	VI	17302
IT	36034	Malo	Veneto	Vicenza	VI	17303
IT	36034	San Tomio	Veneto	Vicenza	VI	17304
IT	36035	Marano Vicentino	Veneto	Vicenza	VI	17305
IT	36036	Torrebelvicino	Veneto	Vicenza	VI	17306
IT	36036	Pievebelvicino	Veneto	Vicenza	VI	17307
IT	36040	Vo'	Veneto	Vicenza	VI	17308
IT	36040	Torri Di Quartesolo	Veneto	Vicenza	VI	17309
IT	36040	Meledo	Veneto	Vicenza	VI	17310
IT	36040	Barcarola	Veneto	Vicenza	VI	17311
IT	36040	Sossano	Veneto	Vicenza	VI	17312
IT	36040	Poiana Di Granfion	Veneto	Vicenza	VI	17313
IT	36040	San Pietro Valdastico	Veneto	Vicenza	VI	17314
IT	36040	Grumolo Delle Abbadesse	Veneto	Vicenza	VI	17315
IT	36040	Lastebasse	Veneto	Vicenza	VI	17316
IT	36040	Casotto	Veneto	Vicenza	VI	17317
IT	36040	Marola	Veneto	Vicenza	VI	17318
IT	36040	Lerino	Veneto	Vicenza	VI	17319
IT	36040	Salcedo	Veneto	Vicenza	VI	17320
IT	36040	Pedescala	Veneto	Vicenza	VI	17321
IT	36040	Pederiva	Veneto	Vicenza	VI	17322
IT	36040	Brendola	Veneto	Vicenza	VI	17323
IT	36040	San Germano Dei Berici	Veneto	Vicenza	VI	17324
IT	36040	Monticello Di Fara	Veneto	Vicenza	VI	17325
IT	36040	Orgiano	Veneto	Vicenza	VI	17326
IT	36040	Tonezza Del Cimone	Veneto	Vicenza	VI	17327
IT	36040	Grancona	Veneto	Vicenza	VI	17328
IT	36040	Pedemonte	Veneto	Vicenza	VI	17329
IT	36040	Sarego	Veneto	Vicenza	VI	17330
IT	36040	Valdastico	Veneto	Vicenza	VI	17331
IT	36040	Grisignano Di Zocco	Veneto	Vicenza	VI	17332
IT	36040	Laverda	Veneto	Vicenza	VI	17333
IT	36042	Breganze	Veneto	Vicenza	VI	17334
IT	36042	Mirabella	Veneto	Vicenza	VI	17335
IT	36042	Maragnole	Veneto	Vicenza	VI	17336
IT	36043	Camisano Vicentino	Veneto	Vicenza	VI	17337
IT	36045	Bagnolo	Veneto	Vicenza	VI	17338
IT	36045	Lonigo	Veneto	Vicenza	VI	17339
IT	36045	Alonte	Veneto	Vicenza	VI	17340
IT	36045	Bagnolo Di Lonigo	Veneto	Vicenza	VI	17341
IT	36045	Almisano	Veneto	Vicenza	VI	17342
IT	36046	Lusiana	Veneto	Vicenza	VI	17343
IT	36046	Santa Caterina	Veneto	Vicenza	VI	17344
IT	36047	Montegalda	Veneto	Vicenza	VI	17345
IT	36047	Montegaldella	Veneto	Vicenza	VI	17346
IT	36050	Quinto Vicentino	Veneto	Vicenza	VI	17347
IT	36050	Friola	Veneto	Vicenza	VI	17348
IT	36050	Lisiera	Veneto	Vicenza	VI	17349
IT	36050	Zermeghedo	Veneto	Vicenza	VI	17350
IT	36050	Gambugliano	Veneto	Vicenza	VI	17351
IT	36050	Sovizzo	Veneto	Vicenza	VI	17352
IT	36050	Bolzano Vicentino	Veneto	Vicenza	VI	17353
IT	36050	Ospedaletto	Veneto	Vicenza	VI	17354
IT	36050	Villaggio Montegrappa	Veneto	Vicenza	VI	17355
IT	36050	Cartigliano	Veneto	Vicenza	VI	17356
IT	36050	Poianella	Veneto	Vicenza	VI	17357
IT	36050	Monteviale	Veneto	Vicenza	VI	17358
IT	36050	Montorso Vicentino	Veneto	Vicenza	VI	17359
IT	36050	Pozzoleone	Veneto	Vicenza	VI	17360
IT	36050	Bressanvido	Veneto	Vicenza	VI	17361
IT	36050	Lanze'	Veneto	Vicenza	VI	17362
IT	36051	Creazzo	Veneto	Vicenza	VI	17363
IT	36051	Olmo	Veneto	Vicenza	VI	17364
IT	36052	Stoner	Veneto	Vicenza	VI	17365
IT	36052	Enego	Veneto	Vicenza	VI	17366
IT	36053	Gambellara	Veneto	Vicenza	VI	17367
IT	36054	Montebello Vicentino	Veneto	Vicenza	VI	17368
IT	36055	Nove	Veneto	Vicenza	VI	17369
IT	36056	Belvedere	Veneto	Vicenza	VI	17370
IT	36056	Tezze Sul Brenta	Veneto	Vicenza	VI	17371
IT	36057	Pianezze Del Lago	Veneto	Vicenza	VI	17372
IT	36057	Tormeno	Veneto	Vicenza	VI	17373
IT	36057	Arcugnano	Veneto	Vicenza	VI	17374
IT	36057	Nogarazza	Veneto	Vicenza	VI	17375
IT	36057	Torri D'Arcugnano	Veneto	Vicenza	VI	17376
IT	36060	Pianezze	Veneto	Vicenza	VI	17377
IT	36060	Longa	Veneto	Vicenza	VI	17378
IT	36060	Schiavon	Veneto	Vicenza	VI	17379
IT	36060	Molvena	Veneto	Vicenza	VI	17380
IT	36060	Villa Di Molvena	Veneto	Vicenza	VI	17381
IT	36060	Romano D'Ezzelino	Veneto	Vicenza	VI	17382
IT	36060	Fellette Di Romano D'Ezzellino	Veneto	Vicenza	VI	17383
IT	36060	Fellette	Veneto	Vicenza	VI	17384
IT	36060	Spin	Veneto	Vicenza	VI	17385
IT	36061	Bassano Del Grappa	Veneto	Vicenza	VI	17386
IT	36061	Valrovina	Veneto	Vicenza	VI	17387
IT	36061	Campese	Veneto	Vicenza	VI	17388
IT	36062	Fontanelle	Veneto	Vicenza	VI	17389
IT	36062	Conco	Veneto	Vicenza	VI	17390
IT	36063	Marostica	Veneto	Vicenza	VI	17391
IT	36063	Crosara	Veneto	Vicenza	VI	17392
IT	36063	Vallonara	Veneto	Vicenza	VI	17393
IT	36063	Valle San Floriano	Veneto	Vicenza	VI	17394
IT	36064	Villaraspa	Veneto	Vicenza	VI	17395
IT	36064	Mason Vicentino	Veneto	Vicenza	VI	17396
IT	36065	Mussolente	Veneto	Vicenza	VI	17397
IT	36065	Casoni	Veneto	Vicenza	VI	17398
IT	36066	Sandrigo	Veneto	Vicenza	VI	17399
IT	36070	San Pietro Mussolino	Veneto	Vicenza	VI	17400
IT	36070	Crespadoro	Veneto	Vicenza	VI	17401
IT	36070	Castelgomberto	Veneto	Vicenza	VI	17402
IT	36070	Nogarole Vicentino	Veneto	Vicenza	VI	17403
IT	36070	Molino Di Altissimo	Veneto	Vicenza	VI	17404
IT	36070	San Pietro Vecchio	Veneto	Vicenza	VI	17405
IT	36070	Brogliano	Veneto	Vicenza	VI	17406
IT	36070	Lovara	Veneto	Vicenza	VI	17407
IT	36070	Altissimo	Veneto	Vicenza	VI	17408
IT	36070	Ferrazza	Veneto	Vicenza	VI	17409
IT	36070	Trissino	Veneto	Vicenza	VI	17410
IT	36070	Molino	Veneto	Vicenza	VI	17411
IT	36071	Arzignano	Veneto	Vicenza	VI	17412
IT	36071	Pugnello	Veneto	Vicenza	VI	17413
IT	36071	Tezze	Veneto	Vicenza	VI	17414
IT	36072	Chiampo	Veneto	Vicenza	VI	17415
IT	36073	Cereda	Veneto	Vicenza	VI	17416
IT	36073	Cornedo Vicentino	Veneto	Vicenza	VI	17417
IT	36075	Sant'Urbano	Veneto	Vicenza	VI	17418
IT	36075	Alte Di Montecchio Maggiore	Veneto	Vicenza	VI	17419
IT	36075	Alte Ceccato	Veneto	Vicenza	VI	17420
IT	36075	Montecchio Maggiore	Veneto	Vicenza	VI	17421
IT	36076	Recoaro Terme	Veneto	Vicenza	VI	17422
IT	36076	Rovegliana	Veneto	Vicenza	VI	17423
IT	36077	Valmarana	Veneto	Vicenza	VI	17424
IT	36077	Altavilla Vicentina	Veneto	Vicenza	VI	17425
IT	36077	Tavernelle Vicentina	Veneto	Vicenza	VI	17426
IT	36078	Castelvecchio	Veneto	Vicenza	VI	17427
IT	36078	Valdagno	Veneto	Vicenza	VI	17428
IT	36078	Piana	Veneto	Vicenza	VI	17429
IT	36078	Novale	Veneto	Vicenza	VI	17430
IT	36078	San Quirico	Veneto	Vicenza	VI	17431
IT	36078	Maglio Di Sopra	Veneto	Vicenza	VI	17432
IT	36100	Anconetta	Veneto	Vicenza	VI	17433
IT	36100	Setteca'	Veneto	Vicenza	VI	17434
IT	36100	Longara	Veneto	Vicenza	VI	17435
IT	36100	Campedello	Veneto	Vicenza	VI	17436
IT	36100	Vicenza	Veneto	Vicenza	VI	17437
IT	36100	Polegge	Veneto	Vicenza	VI	17438
IT	37010	Piovezzano	Veneto	Verona	VR	17439
IT	37010	Sega Di Cavaion	Veneto	Verona	VR	17440
IT	37010	Albare' Stazione	Veneto	Verona	VR	17441
IT	37010	Castion Veronese	Veneto	Verona	VR	17442
IT	37010	Torri Del Benaco	Veneto	Verona	VR	17443
IT	37010	Affi	Veneto	Verona	VR	17444
IT	37010	Cavaion Veronese	Veneto	Verona	VR	17445
IT	37010	Pastrengo	Veneto	Verona	VR	17446
IT	37010	Castelletto Di Brenzone	Veneto	Verona	VR	17447
IT	37010	Costermano	Veneto	Verona	VR	17448
IT	37010	San Zeno Di Montagna	Veneto	Verona	VR	17449
IT	37010	San Zeno	Veneto	Verona	VR	17450
IT	37010	Brenzone	Veneto	Verona	VR	17451
IT	37010	Albare'	Veneto	Verona	VR	17452
IT	37010	Sega	Veneto	Verona	VR	17453
IT	37010	Magugnano	Veneto	Verona	VR	17454
IT	37010	Rivoli Veronese	Veneto	Verona	VR	17455
IT	37011	Bardolino	Veneto	Verona	VR	17456
IT	37011	Cisano	Veneto	Verona	VR	17457
IT	37011	Calmasino	Veneto	Verona	VR	17458
IT	37012	Bussolengo	Veneto	Verona	VR	17459
IT	37012	San Vito Al Mantico	Veneto	Verona	VR	17460
IT	37013	Spiazzi	Veneto	Verona	VR	17461
IT	37013	Pesina	Veneto	Verona	VR	17462
IT	37013	Caprino Veronese	Veneto	Verona	VR	17463
IT	37013	Boi	Veneto	Verona	VR	17464
IT	37014	Castelnuovo Del Garda	Veneto	Verona	VR	17465
IT	37014	Oliosi	Veneto	Verona	VR	17466
IT	37014	Sandra'	Veneto	Verona	VR	17467
IT	37014	Cavalcaselle	Veneto	Verona	VR	17468
IT	37015	Gargagnago	Veneto	Verona	VR	17469
IT	37015	Monte	Veneto	Verona	VR	17470
IT	37015	Domegliara	Veneto	Verona	VR	17471
IT	37015	Sant'Ambrogio Di Valpolicella	Veneto	Verona	VR	17472
IT	37016	Garda	Veneto	Verona	VR	17473
IT	37017	Pacengo	Veneto	Verona	VR	17474
IT	37017	Lazise	Veneto	Verona	VR	17475
IT	37017	Cola'	Veneto	Verona	VR	17476
IT	37017	Cola' Di Lazise	Veneto	Verona	VR	17477
IT	37018	Cassone	Veneto	Verona	VR	17478
IT	37018	Malcesine	Veneto	Verona	VR	17479
IT	37019	Peschiera Del Garda	Veneto	Verona	VR	17480
IT	37019	San Benedetto Di Lugana	Veneto	Verona	VR	17481
IT	37020	Cerro Veronese	Veneto	Verona	VR	17482
IT	37020	Brentino Belluno	Veneto	Verona	VR	17483
IT	37020	Ferrara Di Monte Baldo	Veneto	Verona	VR	17484
IT	37020	Volargne	Veneto	Verona	VR	17485
IT	37020	Prun	Veneto	Verona	VR	17486
IT	37020	Marano Di Valpolicella	Veneto	Verona	VR	17487
IT	37020	Peri	Veneto	Verona	VR	17488
IT	37020	Belluno Veronese	Veneto	Verona	VR	17489
IT	37020	Sant'Anna D'Alfaedo	Veneto	Verona	VR	17490
IT	37020	Rivalta	Veneto	Verona	VR	17491
IT	37020	Erbezzo	Veneto	Verona	VR	17492
IT	37020	Dolce'	Veneto	Verona	VR	17493
IT	37020	Fosse	Veneto	Verona	VR	17494
IT	37020	Fane	Veneto	Verona	VR	17495
IT	37020	Valgatara	Veneto	Verona	VR	17496
IT	37020	Cerna	Veneto	Verona	VR	17497
IT	37021	Bosco Chiesanuova	Veneto	Verona	VR	17498
IT	37021	Lughezzano	Veneto	Verona	VR	17499
IT	37021	Corbiolo	Veneto	Verona	VR	17500
IT	37022	Cavalo	Veneto	Verona	VR	17501
IT	37022	Breonio	Veneto	Verona	VR	17502
IT	37022	Fumane	Veneto	Verona	VR	17503
IT	37023	Romagnano	Veneto	Verona	VR	17504
IT	37023	Grezzana	Veneto	Verona	VR	17505
IT	37023	Stallavena	Veneto	Verona	VR	17506
IT	37023	Azzago	Veneto	Verona	VR	17507
IT	37023	Lugo Di Grezzana	Veneto	Verona	VR	17508
IT	37024	Negrar	Veneto	Verona	VR	17509
IT	37024	Arbizzano	Veneto	Verona	VR	17510
IT	37024	Arbizzano Di Valpolicella	Veneto	Verona	VR	17511
IT	37024	Santa Maria Di Negrar	Veneto	Verona	VR	17512
IT	37026	Pescantina	Veneto	Verona	VR	17513
IT	37026	Ospedaletto	Veneto	Verona	VR	17514
IT	37026	Settimo	Veneto	Verona	VR	17515
IT	37028	Rovere' Veronese	Veneto	Verona	VR	17516
IT	37029	Pedemonte	Veneto	Verona	VR	17517
IT	37029	Negarine	Veneto	Verona	VR	17518
IT	37029	San Pietro In Cariano	Veneto	Verona	VR	17519
IT	37029	San Floriano	Veneto	Verona	VR	17520
IT	37029	Corrubbio	Veneto	Verona	VR	17521
IT	37029	Bure	Veneto	Verona	VR	17522
IT	37030	San Rocco Di Piegara	Veneto	Verona	VR	17523
IT	37030	Cazzano Di Tramigna	Veneto	Verona	VR	17524
IT	37030	San Mauro Di Saline	Veneto	Verona	VR	17525
IT	37030	Vago	Veneto	Verona	VR	17526
IT	37030	San Bortolo	Veneto	Verona	VR	17527
IT	37030	Stra'	Veneto	Verona	VR	17528
IT	37030	Montecchia Di Crosara	Veneto	Verona	VR	17529
IT	37030	Velo Veronese	Veneto	Verona	VR	17530
IT	37030	San Pietro	Veneto	Verona	VR	17531
IT	37030	Ronca'	Veneto	Verona	VR	17532
IT	37030	Terrossa	Veneto	Verona	VR	17533
IT	37030	San Vittore	Veneto	Verona	VR	17534
IT	37030	Montanara	Veneto	Verona	VR	17535
IT	37030	Mezzane Di Sotto	Veneto	Verona	VR	17536
IT	37030	San Briccio	Veneto	Verona	VR	17537
IT	37030	Badia Calavena	Veneto	Verona	VR	17538
IT	37030	Vestenanova	Veneto	Verona	VR	17539
IT	37030	Lavagno	Veneto	Verona	VR	17540
IT	37030	Colognola Ai Colli	Veneto	Verona	VR	17541
IT	37030	Selva Di Progno	Veneto	Verona	VR	17542
IT	37031	Cellore	Veneto	Verona	VR	17543
IT	37031	Illasi	Veneto	Verona	VR	17544
IT	37032	Costalunga	Veneto	Verona	VR	17545
IT	37032	Monteforte D'Alpone	Veneto	Verona	VR	17546
IT	37032	Brognoligo	Veneto	Verona	VR	17547
IT	37035	San Giovanni Ilarione	Veneto	Verona	VR	17548
IT	37036	San Martino Buon Albergo	Veneto	Verona	VR	17549
IT	37036	Marcellise	Veneto	Verona	VR	17550
IT	37036	Ferrazze	Veneto	Verona	VR	17551
IT	37036	Mambrotta	Veneto	Verona	VR	17552
IT	37038	Soave	Veneto	Verona	VR	17553
IT	37038	Castelletto	Veneto	Verona	VR	17554
IT	37039	Tregnago	Veneto	Verona	VR	17555
IT	37039	Centro	Veneto	Verona	VR	17556
IT	37039	Cogollo	Veneto	Verona	VR	17557
IT	37040	Gazzolo	Veneto	Verona	VR	17558
IT	37040	Terrazzo	Veneto	Verona	VR	17559
IT	37040	Orti	Veneto	Verona	VR	17560
IT	37040	Marega	Veneto	Verona	VR	17561
IT	37040	Zimella	Veneto	Verona	VR	17562
IT	37040	Bonavigo	Veneto	Verona	VR	17563
IT	37040	Bevilacqua	Veneto	Verona	VR	17564
IT	37040	Santo Stefano Di Zimella	Veneto	Verona	VR	17565
IT	37040	Boschi Sant'Anna	Veneto	Verona	VR	17566
IT	37040	Begosso	Veneto	Verona	VR	17567
IT	37040	Pressana	Veneto	Verona	VR	17568
IT	37040	Caselle	Veneto	Verona	VR	17569
IT	37040	Roveredo Di Gua'	Veneto	Verona	VR	17570
IT	37040	San Gregorio Di Veronella	Veneto	Verona	VR	17571
IT	37040	Arcole	Veneto	Verona	VR	17572
IT	37040	Veronella	Veneto	Verona	VR	17573
IT	37040	Santo Stefano	Veneto	Verona	VR	17574
IT	37040	San Gregorio	Veneto	Verona	VR	17575
IT	37040	Sabbion	Veneto	Verona	VR	17576
IT	37041	Albaredo D'Adige	Veneto	Verona	VR	17577
IT	37041	Presina	Veneto	Verona	VR	17578
IT	37041	Michellorie	Veneto	Verona	VR	17579
IT	37041	Coriano Veronese	Veneto	Verona	VR	17580
IT	37042	Caldierino	Veneto	Verona	VR	17581
IT	37042	Caldiero	Veneto	Verona	VR	17582
IT	37043	Mena' Vallestrema	Veneto	Verona	VR	17583
IT	37043	Castagnaro	Veneto	Verona	VR	17584
IT	37043	Mena'	Veneto	Verona	VR	17585
IT	37044	San Sebastiano	Veneto	Verona	VR	17586
IT	37044	Sule'	Veneto	Verona	VR	17587
IT	37044	Baldaria	Veneto	Verona	VR	17588
IT	37044	Cologna Veneta	Veneto	Verona	VR	17589
IT	37045	San Pietro Di Legnago	Veneto	Verona	VR	17590
IT	37045	Casette	Veneto	Verona	VR	17591
IT	37045	Legnago	Veneto	Verona	VR	17592
IT	37045	Gallese	Veneto	Verona	VR	17593
IT	37045	Vangadizza	Veneto	Verona	VR	17594
IT	37045	Terranegra	Veneto	Verona	VR	17595
IT	37046	Minerbe	Veneto	Verona	VR	17596
IT	37047	Villabella	Veneto	Verona	VR	17597
IT	37047	Prova	Veneto	Verona	VR	17598
IT	37047	Locara	Veneto	Verona	VR	17599
IT	37047	San Bonifacio	Veneto	Verona	VR	17600
IT	37049	Spinimbecco	Veneto	Verona	VR	17601
IT	37049	Villa Bartolomea	Veneto	Verona	VR	17602
IT	37049	Carpi Di Villa Bartolomea	Veneto	Verona	VR	17603
IT	37050	Vallese	Veneto	Verona	VR	17604
IT	37050	Isola Rizza	Veneto	Verona	VR	17605
IT	37050	Roverchiaretta	Veneto	Verona	VR	17606
IT	37050	Palu'	Veneto	Verona	VR	17607
IT	37050	Ca' Degli Oppi	Veneto	Verona	VR	17608
IT	37050	San Pietro Di Morubio	Veneto	Verona	VR	17609
IT	37050	Belfiore	Veneto	Verona	VR	17610
IT	37050	Bonavicina	Veneto	Verona	VR	17611
IT	37050	Oppeano	Veneto	Verona	VR	17612
IT	37050	Angiari	Veneto	Verona	VR	17613
IT	37050	Piazza	Veneto	Verona	VR	17614
IT	37050	Roverchiara	Veneto	Verona	VR	17615
IT	37050	Concamarise	Veneto	Verona	VR	17616
IT	37051	Bovolone	Veneto	Verona	VR	17617
IT	37051	Villafontana	Veneto	Verona	VR	17618
IT	37052	Casaleone	Veneto	Verona	VR	17619
IT	37053	Cerea	Veneto	Verona	VR	17620
IT	37053	Asparetto	Veneto	Verona	VR	17621
IT	37053	Cherubine	Veneto	Verona	VR	17622
IT	37054	Nogara	Veneto	Verona	VR	17623
IT	37055	Ronco All'Adige	Veneto	Verona	VR	17624
IT	37055	Tombazosana	Veneto	Verona	VR	17625
IT	37055	Albaro	Veneto	Verona	VR	17626
IT	37056	Bionde	Veneto	Verona	VR	17627
IT	37056	Valmorsel	Veneto	Verona	VR	17628
IT	37056	Engazza'	Veneto	Verona	VR	17629
IT	37056	Salizzole	Veneto	Verona	VR	17630
IT	37056	Crosarol	Veneto	Verona	VR	17631
IT	37057	San Giovanni Lupatoto	Veneto	Verona	VR	17632
IT	37057	Raldon	Veneto	Verona	VR	17633
IT	37057	Pozzo Camacici	Veneto	Verona	VR	17634
IT	37058	Sanguinetto	Veneto	Verona	VR	17635
IT	37059	Perzacco	Veneto	Verona	VR	17636
IT	37059	Volon	Veneto	Verona	VR	17637
IT	37059	Zevio	Veneto	Verona	VR	17638
IT	37059	Campagnola	Veneto	Verona	VR	17639
IT	37059	Santa Maria Di Zevio	Veneto	Verona	VR	17640
IT	37060	San Pietro In Valle	Veneto	Verona	VR	17641
IT	37060	Bagnolo	Veneto	Verona	VR	17642
IT	37060	Gazzo Veronese	Veneto	Verona	VR	17643
IT	37060	Sorga'	Veneto	Verona	VR	17644
IT	37060	Pradelle	Veneto	Verona	VR	17645
IT	37060	Azzano	Veneto	Verona	VR	17646
IT	37060	Buttapietra	Veneto	Verona	VR	17647
IT	37060	Beccacivetta	Veneto	Verona	VR	17648
IT	37060	Roncoleva'	Veneto	Verona	VR	17649
IT	37060	Maccacari	Veneto	Verona	VR	17650
IT	37060	Palazzolo	Veneto	Verona	VR	17651
IT	37060	Bovo	Veneto	Verona	VR	17652
IT	37060	Lugagnano	Veneto	Verona	VR	17653
IT	37060	Erbe'	Veneto	Verona	VR	17654
IT	37060	Mozzecane	Veneto	Verona	VR	17655
IT	37060	Sona	Veneto	Verona	VR	17656
IT	37060	Marchesino	Veneto	Verona	VR	17657
IT	37060	Trevenzuolo	Veneto	Verona	VR	17658
IT	37060	Roncanova	Veneto	Verona	VR	17659
IT	37060	Bonferraro	Veneto	Verona	VR	17660
IT	37060	San Giorgio In Salici	Veneto	Verona	VR	17661
IT	37060	Nogarole Rocca	Veneto	Verona	VR	17662
IT	37060	Castel D'Azzano	Veneto	Verona	VR	17663
IT	37060	Correzzo	Veneto	Verona	VR	17664
IT	37060	Pontepossero	Veneto	Verona	VR	17665
IT	37062	Dossobuono	Veneto	Verona	VR	17666
IT	37062	Alpo	Veneto	Verona	VR	17667
IT	37063	Tarmassia	Veneto	Verona	VR	17668
IT	37063	Isola Della Scala	Veneto	Verona	VR	17669
IT	37063	Pellegrina	Veneto	Verona	VR	17670
IT	37064	Povegliano Veronese	Veneto	Verona	VR	17671
IT	37066	Custoza	Veneto	Verona	VR	17672
IT	37066	Caselle Di Sommacampagna	Veneto	Verona	VR	17673
IT	37066	Sommacampagna	Veneto	Verona	VR	17674
IT	37067	Salionze	Veneto	Verona	VR	17675
IT	37067	Valeggio Sul Mincio	Veneto	Verona	VR	17676
IT	37068	Vigasio	Veneto	Verona	VR	17677
IT	37068	Forette	Veneto	Verona	VR	17678
IT	37068	Isolalta	Veneto	Verona	VR	17679
IT	37069	Villafranca Di Verona	Veneto	Verona	VR	17680
IT	37069	Rosegaferro	Veneto	Verona	VR	17681
IT	37069	Pizzoletta	Veneto	Verona	VR	17682
IT	37069	Caluri	Veneto	Verona	VR	17683
IT	37069	Quaderni	Veneto	Verona	VR	17684
IT	37100	Verona	Veneto	Verona	VR	17685
IT	37121	Verona	Veneto	Verona	VR	17686
IT	37122	Verona	Veneto	Verona	VR	17687
IT	37123	Verona	Veneto	Verona	VR	17688
IT	37124	Verona	Veneto	Verona	VR	17689
IT	37125	Quinzano	Veneto	Verona	VR	17690
IT	37125	Verona	Veneto	Verona	VR	17691
IT	37126	Verona	Veneto	Verona	VR	17692
IT	37127	Avesa	Veneto	Verona	VR	17693
IT	37127	Verona	Veneto	Verona	VR	17694
IT	37128	Verona	Veneto	Verona	VR	17695
IT	37129	Verona	Veneto	Verona	VR	17696
IT	37131	Verona	Veneto	Verona	VR	17697
IT	37132	San Michele Extra	Veneto	Verona	VR	17698
IT	37132	Verona	Veneto	Verona	VR	17699
IT	37133	Verona	Veneto	Verona	VR	17700
IT	37134	Verona	Veneto	Verona	VR	17701
IT	37135	Verona	Veneto	Verona	VR	17702
IT	37136	Verona	Veneto	Verona	VR	17703
IT	37137	Verona	Veneto	Verona	VR	17704
IT	37138	Verona	Veneto	Verona	VR	17705
IT	37139	Chievo	Veneto	Verona	VR	17706
IT	37139	San Massimo All'Adige	Veneto	Verona	VR	17707
IT	37139	Verona	Veneto	Verona	VR	17708
IT	37142	Verona	Veneto	Verona	VR	17709
IT	67010	Barete	Abruzzo	L'Aquila	AQ	17710
IT	67012	San Giovanni	Abruzzo	L'Aquila	AQ	17711
IT	67012	Cagnano Amiterno	Abruzzo	L'Aquila	AQ	17712
IT	67013	Mascioni	Abruzzo	L'Aquila	AQ	17713
IT	67013	Campotosto	Abruzzo	L'Aquila	AQ	17714
IT	67013	Poggio Cancelli	Abruzzo	L'Aquila	AQ	17715
IT	67013	Ortolano	Abruzzo	L'Aquila	AQ	17716
IT	67014	Capitignano	Abruzzo	L'Aquila	AQ	17717
IT	67015	San Giovanni Paganica	Abruzzo	L'Aquila	AQ	17718
IT	67015	Montereale	Abruzzo	L'Aquila	AQ	17719
IT	67015	Ville Di Fano	Abruzzo	L'Aquila	AQ	17720
IT	67015	Aringo	Abruzzo	L'Aquila	AQ	17721
IT	67015	Marana	Abruzzo	L'Aquila	AQ	17722
IT	67015	Cesaproba	Abruzzo	L'Aquila	AQ	17723
IT	67015	Marana Di Montereale	Abruzzo	L'Aquila	AQ	17724
IT	67017	San Lorenzo Di Pizzoli	Abruzzo	L'Aquila	AQ	17725
IT	67017	Marruci	Abruzzo	L'Aquila	AQ	17726
IT	67017	Pizzoli	Abruzzo	L'Aquila	AQ	17727
IT	67019	Sella Di Corno	Abruzzo	L'Aquila	AQ	17728
IT	67019	Vigliano	Abruzzo	L'Aquila	AQ	17729
IT	67019	Scoppito	Abruzzo	L'Aquila	AQ	17730
IT	67020	Caporciano	Abruzzo	L'Aquila	AQ	17731
IT	67020	Castelnuovo	Abruzzo	L'Aquila	AQ	17732
IT	67020	Sant'Eusanio Forconese	Abruzzo	L'Aquila	AQ	17733
IT	67020	Tussio	Abruzzo	L'Aquila	AQ	17734
IT	67020	Santo Stefano Di Sessanio	Abruzzo	L'Aquila	AQ	17735
IT	67020	Carrufo	Abruzzo	L'Aquila	AQ	17736
IT	67020	Castelnuovo Di San Pio Delle Camere	Abruzzo	L'Aquila	AQ	17737
IT	67020	Fontecchio	Abruzzo	L'Aquila	AQ	17738
IT	67020	Molina Aterno	Abruzzo	L'Aquila	AQ	17739
IT	67020	Civitaretenga	Abruzzo	L'Aquila	AQ	17740
IT	67020	Villa Sant'Angelo	Abruzzo	L'Aquila	AQ	17741
IT	67020	Villa Santa Lucia Degli Abruzzi	Abruzzo	L'Aquila	AQ	17742
IT	67020	Collepietro	Abruzzo	L'Aquila	AQ	17743
IT	67020	Calascio	Abruzzo	L'Aquila	AQ	17744
IT	67020	Gagliano Aterno	Abruzzo	L'Aquila	AQ	17745
IT	67020	Beffi	Abruzzo	L'Aquila	AQ	17746
IT	67020	San Pio Delle Camere	Abruzzo	L'Aquila	AQ	17747
IT	67020	Roccapreturo	Abruzzo	L'Aquila	AQ	17748
IT	67020	Carapelle Calvisio	Abruzzo	L'Aquila	AQ	17749
IT	67020	Castel Di Ieri	Abruzzo	L'Aquila	AQ	17750
IT	67020	Fossa	Abruzzo	L'Aquila	AQ	17751
IT	67020	Acciano	Abruzzo	L'Aquila	AQ	17752
IT	67020	Tione Degli Abruzzi	Abruzzo	L'Aquila	AQ	17753
IT	67020	San Benedetto In Perillis	Abruzzo	L'Aquila	AQ	17754
IT	67020	Fagnano Alto	Abruzzo	L'Aquila	AQ	17755
IT	67020	Prata D'Ansidonia	Abruzzo	L'Aquila	AQ	17756
IT	67020	Goriano Valli	Abruzzo	L'Aquila	AQ	17757
IT	67020	Castelvecchio Calvisio	Abruzzo	L'Aquila	AQ	17758
IT	67020	Navelli	Abruzzo	L'Aquila	AQ	17759
IT	67021	Barisciano	Abruzzo	L'Aquila	AQ	17760
IT	67021	Picenze	Abruzzo	L'Aquila	AQ	17761
IT	67022	Capestrano	Abruzzo	L'Aquila	AQ	17762
IT	67023	Castel Del Monte	Abruzzo	L'Aquila	AQ	17763
IT	67024	Castelvecchio Subequo	Abruzzo	L'Aquila	AQ	17764
IT	67025	Ofena	Abruzzo	L'Aquila	AQ	17765
IT	67026	Poggio Picenze	Abruzzo	L'Aquila	AQ	17766
IT	67027	Raiano	Abruzzo	L'Aquila	AQ	17767
IT	67028	San Demetrio Ne' Vestini	Abruzzo	L'Aquila	AQ	17768
IT	67029	Secinaro	Abruzzo	L'Aquila	AQ	17769
IT	67030	Barrea	Abruzzo	L'Aquila	AQ	17770
IT	67030	Roccacasale	Abruzzo	L'Aquila	AQ	17771
IT	67030	Goriano Sicoli	Abruzzo	L'Aquila	AQ	17772
IT	67030	Campo Di Fano	Abruzzo	L'Aquila	AQ	17773
IT	67030	Rocca Pia	Abruzzo	L'Aquila	AQ	17774
IT	67030	Villetta Barrea	Abruzzo	L'Aquila	AQ	17775
IT	67030	Torre Dei Nolfi	Abruzzo	L'Aquila	AQ	17776
IT	67030	Cocullo	Abruzzo	L'Aquila	AQ	17777
IT	67030	Alfedena	Abruzzo	L'Aquila	AQ	17778
IT	67030	Cansano	Abruzzo	L'Aquila	AQ	17779
IT	67030	Introdacqua	Abruzzo	L'Aquila	AQ	17780
IT	67030	Scontrone	Abruzzo	L'Aquila	AQ	17781
IT	67030	Corfinio	Abruzzo	L'Aquila	AQ	17782
IT	67030	Campo Di Giove	Abruzzo	L'Aquila	AQ	17783
IT	67030	Opi	Abruzzo	L'Aquila	AQ	17784
IT	67030	Pacentro	Abruzzo	L'Aquila	AQ	17785
IT	67030	Villalago	Abruzzo	L'Aquila	AQ	17786
IT	67030	Prezza	Abruzzo	L'Aquila	AQ	17787
IT	67030	Civitella Alfedena	Abruzzo	L'Aquila	AQ	17788
IT	67030	Anversa Degli Abruzzi	Abruzzo	L'Aquila	AQ	17789
IT	67030	Castrovalva	Abruzzo	L'Aquila	AQ	17790
IT	67030	Villa Scontrone	Abruzzo	L'Aquila	AQ	17791
IT	67030	Ateleta	Abruzzo	L'Aquila	AQ	17792
IT	67030	Vittorito	Abruzzo	L'Aquila	AQ	17793
IT	67030	Bugnara	Abruzzo	L'Aquila	AQ	17794
IT	67031	Roccacinquemiglia	Abruzzo	L'Aquila	AQ	17795
IT	67031	Castel Di Sangro	Abruzzo	L'Aquila	AQ	17796
IT	67032	Pescasseroli	Abruzzo	L'Aquila	AQ	17797
IT	67033	Pescocostanzo	Abruzzo	L'Aquila	AQ	17798
IT	67034	Pettorano Sul Gizio	Abruzzo	L'Aquila	AQ	17799
IT	67035	Pratola Peligna	Abruzzo	L'Aquila	AQ	17800
IT	67035	Bagnaturo	Abruzzo	L'Aquila	AQ	17801
IT	67036	Rivisondoli	Abruzzo	L'Aquila	AQ	17802
IT	67037	Aremogna	Abruzzo	L'Aquila	AQ	17803
IT	67037	Pietransieri	Abruzzo	L'Aquila	AQ	17804
IT	67037	Roccaraso	Abruzzo	L'Aquila	AQ	17805
IT	67038	Frattura	Abruzzo	L'Aquila	AQ	17806
IT	67038	Scanno	Abruzzo	L'Aquila	AQ	17807
IT	67038	Frattura Di Scanno	Abruzzo	L'Aquila	AQ	17808
IT	67039	Cavate	Abruzzo	L'Aquila	AQ	17809
IT	67039	Albanese	Abruzzo	L'Aquila	AQ	17810
IT	67039	Torrone Di Sulmona	Abruzzo	L'Aquila	AQ	17811
IT	67039	Marane	Abruzzo	L'Aquila	AQ	17812
IT	67039	Torrone	Abruzzo	L'Aquila	AQ	17813
IT	67039	Abazia Di Sulmona	Abruzzo	L'Aquila	AQ	17814
IT	67039	Sulmona	Abruzzo	L'Aquila	AQ	17815
IT	67039	Arabona	Abruzzo	L'Aquila	AQ	17816
IT	67040	Collarmele	Abruzzo	L'Aquila	AQ	17817
IT	67040	San Martino D'Ocre	Abruzzo	L'Aquila	AQ	17818
IT	67040	Ocre	Abruzzo	L'Aquila	AQ	17819
IT	67041	Aielli	Abruzzo	L'Aquila	AQ	17820
IT	67041	Aielli Stazione	Abruzzo	L'Aquila	AQ	17821
IT	67043	Celano	Abruzzo	L'Aquila	AQ	17822
IT	67044	Cerchio	Abruzzo	L'Aquila	AQ	17823
IT	67045	Casamaina Di Lucoli	Abruzzo	L'Aquila	AQ	17824
IT	67045	Lucoli	Abruzzo	L'Aquila	AQ	17825
IT	67045	Casamaina	Abruzzo	L'Aquila	AQ	17826
IT	67045	Ville Di Lucoli	Abruzzo	L'Aquila	AQ	17827
IT	67046	Ovindoli	Abruzzo	L'Aquila	AQ	17828
IT	67046	Santo Iona	Abruzzo	L'Aquila	AQ	17829
IT	67046	San Potito	Abruzzo	L'Aquila	AQ	17830
IT	67047	Rocca Di Cambio	Abruzzo	L'Aquila	AQ	17831
IT	67048	Rovere Di Rocca Di Mezzo	Abruzzo	L'Aquila	AQ	17832
IT	67048	Rocca Di Mezzo	Abruzzo	L'Aquila	AQ	17833
IT	67048	Rovere	Abruzzo	L'Aquila	AQ	17834
IT	67049	San Nicola Di Tornimparte	Abruzzo	L'Aquila	AQ	17835
IT	67049	Rocca Santo Stefano Di Tornimparte	Abruzzo	L'Aquila	AQ	17836
IT	67049	Tornimparte	Abruzzo	L'Aquila	AQ	17837
IT	67049	Rocca Santo Stefano	Abruzzo	L'Aquila	AQ	17838
IT	67049	San Nicola	Abruzzo	L'Aquila	AQ	17839
IT	67049	Villagrande	Abruzzo	L'Aquila	AQ	17840
IT	67050	San Sebastiano	Abruzzo	L'Aquila	AQ	17841
IT	67050	Massa D'Albe	Abruzzo	L'Aquila	AQ	17842
IT	67050	Bisegna	Abruzzo	L'Aquila	AQ	17843
IT	67050	Villavallelonga	Abruzzo	L'Aquila	AQ	17844
IT	67050	Pagliara	Abruzzo	L'Aquila	AQ	17845
IT	67050	Canistro Inferiore	Abruzzo	L'Aquila	AQ	17846
IT	67050	San Vincenzo Valle Roveto	Abruzzo	L'Aquila	AQ	17847
IT	67050	Morino	Abruzzo	L'Aquila	AQ	17848
IT	67050	Roccavivi	Abruzzo	L'Aquila	AQ	17849
IT	67050	Grancia	Abruzzo	L'Aquila	AQ	17850
IT	67050	Pero Dei Santi	Abruzzo	L'Aquila	AQ	17851
IT	67050	Castellafiume	Abruzzo	L'Aquila	AQ	17852
IT	67050	San Vincenzo Vecchio	Abruzzo	L'Aquila	AQ	17853
IT	67050	Ortona Dei Marsi	Abruzzo	L'Aquila	AQ	17854
IT	67050	Rendinara	Abruzzo	L'Aquila	AQ	17855
IT	67050	Canistro Superiore	Abruzzo	L'Aquila	AQ	17856
IT	67050	San Vincenzo Valle Roveto Superiore	Abruzzo	L'Aquila	AQ	17857
IT	67050	Forme	Abruzzo	L'Aquila	AQ	17858
IT	67050	Canistro	Abruzzo	L'Aquila	AQ	17859
IT	67050	Collelongo	Abruzzo	L'Aquila	AQ	17860
IT	67050	Albe	Abruzzo	L'Aquila	AQ	17861
IT	67050	Castronovo	Abruzzo	L'Aquila	AQ	17862
IT	67050	Lecce Nei Marsi	Abruzzo	L'Aquila	AQ	17863
IT	67050	Ortucchio	Abruzzo	L'Aquila	AQ	17864
IT	67050	Corona	Abruzzo	L'Aquila	AQ	17865
IT	67050	Carrito	Abruzzo	L'Aquila	AQ	17866
IT	67050	Pagliara Dei Marsi	Abruzzo	L'Aquila	AQ	17867
IT	67050	Civita D'Antino	Abruzzo	L'Aquila	AQ	17868
IT	67051	Paterno	Abruzzo	L'Aquila	AQ	17869
IT	67051	Antrosano	Abruzzo	L'Aquila	AQ	17870
IT	67051	San Pelino	Abruzzo	L'Aquila	AQ	17871
IT	67051	Avezzano	Abruzzo	L'Aquila	AQ	17872
IT	67051	Cese	Abruzzo	L'Aquila	AQ	17873
IT	67051	Santuario Di Pietracquaria	Abruzzo	L'Aquila	AQ	17874
IT	67052	Balsorano Nuovo	Abruzzo	L'Aquila	AQ	17875
IT	67052	Balsorano	Abruzzo	L'Aquila	AQ	17876
IT	67052	Ridotti	Abruzzo	L'Aquila	AQ	17877
IT	67052	Ridotti Di Balsorano	Abruzzo	L'Aquila	AQ	17878
IT	67053	Pescocanale	Abruzzo	L'Aquila	AQ	17879
IT	67053	Pescocanale Di Capistrello	Abruzzo	L'Aquila	AQ	17880
IT	67053	Capistrello	Abruzzo	L'Aquila	AQ	17881
IT	67053	Corcumello	Abruzzo	L'Aquila	AQ	17882
IT	67054	Civitella Roveto	Abruzzo	L'Aquila	AQ	17883
IT	67054	Meta	Abruzzo	L'Aquila	AQ	17884
IT	67055	Gioia Dei Marsi	Abruzzo	L'Aquila	AQ	17885
IT	67055	Casali D'Aschi	Abruzzo	L'Aquila	AQ	17886
IT	67056	Luco Dei Marsi	Abruzzo	L'Aquila	AQ	17887
IT	67057	Venere	Abruzzo	L'Aquila	AQ	17888
IT	67057	Pescina	Abruzzo	L'Aquila	AQ	17889
IT	67058	San Benedetto Dei Marsi	Abruzzo	L'Aquila	AQ	17890
IT	67059	Trasacco	Abruzzo	L'Aquila	AQ	17891
IT	67060	Cappadocia	Abruzzo	L'Aquila	AQ	17892
IT	67060	Petrella Liri	Abruzzo	L'Aquila	AQ	17893
IT	67060	Verrecchie	Abruzzo	L'Aquila	AQ	17894
IT	67061	Colli Di Montebove	Abruzzo	L'Aquila	AQ	17895
IT	67061	Montesabinese	Abruzzo	L'Aquila	AQ	17896
IT	67061	Pietrasecca	Abruzzo	L'Aquila	AQ	17897
IT	67061	Villa Romana	Abruzzo	L'Aquila	AQ	17898
IT	67061	Carsoli	Abruzzo	L'Aquila	AQ	17899
IT	67061	Tufo Di Carsoli	Abruzzo	L'Aquila	AQ	17900
IT	67061	Poggio Cinolfo	Abruzzo	L'Aquila	AQ	17901
IT	67062	Rosciolo	Abruzzo	L'Aquila	AQ	17902
IT	67062	Marano Dei Marsi	Abruzzo	L'Aquila	AQ	17903
IT	67062	Rosciolo Dei Marsi	Abruzzo	L'Aquila	AQ	17904
IT	67062	Magliano De' Marsi	Abruzzo	L'Aquila	AQ	17905
IT	67063	Oricola	Abruzzo	L'Aquila	AQ	17906
IT	67063	Civita	Abruzzo	L'Aquila	AQ	17907
IT	67064	Pereto	Abruzzo	L'Aquila	AQ	17908
IT	67066	Rocca Di Botte	Abruzzo	L'Aquila	AQ	17909
IT	67067	Sante Marie	Abruzzo	L'Aquila	AQ	17910
IT	67067	Scanzano	Abruzzo	L'Aquila	AQ	17911
IT	67067	Santo Stefano Di Sante Marie	Abruzzo	L'Aquila	AQ	17912
IT	67067	Santo Stefano	Abruzzo	L'Aquila	AQ	17913
IT	67068	Cappelle Dei Marsi	Abruzzo	L'Aquila	AQ	17914
IT	67068	Scurcola Marsicana	Abruzzo	L'Aquila	AQ	17915
IT	67068	Cappelle	Abruzzo	L'Aquila	AQ	17916
IT	67069	San Donato	Abruzzo	L'Aquila	AQ	17917
IT	67069	Tagliacozzo	Abruzzo	L'Aquila	AQ	17918
IT	67069	San Donato Di Tagliacozzo	Abruzzo	L'Aquila	AQ	17919
IT	67069	Villa San Sebastiano	Abruzzo	L'Aquila	AQ	17920
IT	67069	Poggio Filippo	Abruzzo	L'Aquila	AQ	17921
IT	67069	Sorbo Di Tagliacozzo	Abruzzo	L'Aquila	AQ	17922
IT	67069	Gallo Di Tagliacozzo	Abruzzo	L'Aquila	AQ	17923
IT	67069	Sorbo	Abruzzo	L'Aquila	AQ	17924
IT	67069	Tremonti	Abruzzo	L'Aquila	AQ	17925
IT	67069	Poggetello	Abruzzo	L'Aquila	AQ	17926
IT	67069	Roccacerro	Abruzzo	L'Aquila	AQ	17927
IT	67069	Gallo	Abruzzo	L'Aquila	AQ	17928
IT	67069	Poggetello Di Tagliacozzo	Abruzzo	L'Aquila	AQ	17929
IT	67100	San Gregorio	Abruzzo	L'Aquila	AQ	17930
IT	67100	San Vittorino	Abruzzo	L'Aquila	AQ	17931
IT	67100	Bagno	Abruzzo	L'Aquila	AQ	17932
IT	67100	Onna	Abruzzo	L'Aquila	AQ	17933
IT	67100	L'Aquila	Abruzzo	L'Aquila	AQ	17934
IT	67100	Sassa	Abruzzo	L'Aquila	AQ	17935
IT	67100	Colle Brincioni	Abruzzo	L'Aquila	AQ	17936
IT	67100	Pianola	Abruzzo	L'Aquila	AQ	17937
IT	67100	Campo Imperatore	Abruzzo	L'Aquila	AQ	17938
IT	67100	Camarda	Abruzzo	L'Aquila	AQ	17939
IT	67100	San Vittorino Amiterno	Abruzzo	L'Aquila	AQ	17940
IT	67100	Forcella	Abruzzo	L'Aquila	AQ	17941
IT	67100	Bazzano	Abruzzo	L'Aquila	AQ	17942
IT	67100	Santi	Abruzzo	L'Aquila	AQ	17943
IT	67100	Paganica	Abruzzo	L'Aquila	AQ	17944
IT	67100	Monticchio	Abruzzo	L'Aquila	AQ	17945
IT	67100	Arischia	Abruzzo	L'Aquila	AQ	17946
IT	67100	San Benedetto	Abruzzo	L'Aquila	AQ	17947
IT	67100	Colle Di Roio	Abruzzo	L'Aquila	AQ	17948
IT	67100	Poggio Di Roio	Abruzzo	L'Aquila	AQ	17949
IT	67100	Pile	Abruzzo	L'Aquila	AQ	17950
IT	67100	Pagliare	Abruzzo	L'Aquila	AQ	17951
IT	67100	Preturo	Abruzzo	L'Aquila	AQ	17952
IT	67100	Collebrincioni	Abruzzo	L'Aquila	AQ	17953
IT	67100	Tempera	Abruzzo	L'Aquila	AQ	17954
IT	67100	Coppito	Abruzzo	L'Aquila	AQ	17955
IT	67100	Assergi	Abruzzo	L'Aquila	AQ	17956
IT	67100	Aragno	Abruzzo	L'Aquila	AQ	17957
IT	67100	Roio Piano	Abruzzo	L'Aquila	AQ	17958
IT	66010	Montenerodomo	Abruzzo	Chieti	CH	17959
IT	66010	Miglianico	Abruzzo	Chieti	CH	17960
IT	66010	Villamagna	Abruzzo	Chieti	CH	17961
IT	66010	Terranova	Abruzzo	Chieti	CH	17962
IT	66010	Ripa Teatina	Abruzzo	Chieti	CH	17963
IT	66010	San Martino Sulla Marrucina	Abruzzo	Chieti	CH	17964
IT	66010	Pretoro	Abruzzo	Chieti	CH	17965
IT	66010	Vacri	Abruzzo	Chieti	CH	17966
IT	66010	Torrevecchia Teatina	Abruzzo	Chieti	CH	17967
IT	66010	Fara Filiorum Petri	Abruzzo	Chieti	CH	17968
IT	66010	Castelferrato	Abruzzo	Chieti	CH	17969
IT	66010	Roccamontepiano	Abruzzo	Chieti	CH	17970
IT	66010	Giuliano Teatino	Abruzzo	Chieti	CH	17971
IT	66010	Tollo	Abruzzo	Chieti	CH	17972
IT	66010	Pennapiedimonte	Abruzzo	Chieti	CH	17973
IT	66010	San Rocco	Abruzzo	Chieti	CH	17974
IT	66010	Colledimacine	Abruzzo	Chieti	CH	17975
IT	66010	Lettopalena	Abruzzo	Chieti	CH	17976
IT	66010	Rapino	Abruzzo	Chieti	CH	17977
IT	66010	Casacanditella	Abruzzo	Chieti	CH	17978
IT	66010	Ari	Abruzzo	Chieti	CH	17979
IT	66010	Gessopalena	Abruzzo	Chieti	CH	17980
IT	66010	Palombaro	Abruzzo	Chieti	CH	17981
IT	66010	Lama Dei Peligni	Abruzzo	Chieti	CH	17982
IT	66010	Canosa Sannita	Abruzzo	Chieti	CH	17983
IT	66010	Semivicoli	Abruzzo	Chieti	CH	17984
IT	66010	Civitella Messer Raimondo	Abruzzo	Chieti	CH	17985
IT	66010	San Pietro	Abruzzo	Chieti	CH	17986
IT	66011	Bucchianico	Abruzzo	Chieti	CH	17987
IT	66011	Colle Sant'Antonio	Abruzzo	Chieti	CH	17988
IT	66012	Casalincontrada	Abruzzo	Chieti	CH	17989
IT	66014	Crecchio	Abruzzo	Chieti	CH	17990
IT	66014	Villa Tucci	Abruzzo	Chieti	CH	17991
IT	66015	Fara San Martino	Abruzzo	Chieti	CH	17992
IT	66016	Comino	Abruzzo	Chieti	CH	17993
IT	66016	Piano Delle Fonti	Abruzzo	Chieti	CH	17994
IT	66016	Villa San Vincenzo	Abruzzo	Chieti	CH	17995
IT	66016	Caporosso	Abruzzo	Chieti	CH	17996
IT	66016	Guardiagrele	Abruzzo	Chieti	CH	17997
IT	66017	Palena	Abruzzo	Chieti	CH	17998
IT	66018	Taranta Peligna	Abruzzo	Chieti	CH	17999
IT	66019	Fallascoso	Abruzzo	Chieti	CH	18000
IT	66019	Torricella Peligna	Abruzzo	Chieti	CH	18001
IT	66020	Paglieta	Abruzzo	Chieti	CH	18002
IT	66020	Sant'Egidio	Abruzzo	Chieti	CH	18003
IT	66020	Sambuceto	Abruzzo	Chieti	CH	18004
IT	66020	Villalfonsina	Abruzzo	Chieti	CH	18005
IT	66020	Scerni	Abruzzo	Chieti	CH	18006
IT	66020	Pollutri	Abruzzo	Chieti	CH	18007
IT	66020	Torino Di Sangro	Abruzzo	Chieti	CH	18008
IT	66020	San Giacomo Di Scerni	Abruzzo	Chieti	CH	18009
IT	66020	San Giovanni Teatino	Abruzzo	Chieti	CH	18010
IT	66020	Rocca San Giovanni	Abruzzo	Chieti	CH	18011
IT	66020	Torino Di Sangro Stazione	Abruzzo	Chieti	CH	18012
IT	66021	Miracoli	Abruzzo	Chieti	CH	18013
IT	66021	Casalbordino Stazione	Abruzzo	Chieti	CH	18014
IT	66021	Casalbordino	Abruzzo	Chieti	CH	18015
IT	66022	Fossacesia	Abruzzo	Chieti	CH	18016
IT	66022	Scorciosa	Abruzzo	Chieti	CH	18017
IT	66022	Villascorciosa	Abruzzo	Chieti	CH	18018
IT	66022	Fossacesia Marina	Abruzzo	Chieti	CH	18019
IT	66023	Francavilla Al Mare	Abruzzo	Chieti	CH	18020
IT	66023	Francavilla Al Mare Rione Foro	Abruzzo	Chieti	CH	18021
IT	66026	Ortona	Abruzzo	Chieti	CH	18022
IT	66026	Villa Caldari	Abruzzo	Chieti	CH	18023
IT	66026	San Leonardo	Abruzzo	Chieti	CH	18024
IT	66026	Villa San Nicola	Abruzzo	Chieti	CH	18025
IT	66026	Villa Grande	Abruzzo	Chieti	CH	18026
IT	66026	Ortona Foro	Abruzzo	Chieti	CH	18027
IT	66026	Villa San Leonardo	Abruzzo	Chieti	CH	18028
IT	66026	San Nicola	Abruzzo	Chieti	CH	18029
IT	66026	Ortona Porto	Abruzzo	Chieti	CH	18030
IT	66030	Mozzagrogna	Abruzzo	Chieti	CH	18031
IT	66030	Villa Romagnoli	Abruzzo	Chieti	CH	18032
IT	66030	Montazzoli	Abruzzo	Chieti	CH	18033
IT	66030	Santa Maria Imbaro	Abruzzo	Chieti	CH	18034
IT	66030	Poggiofiorito	Abruzzo	Chieti	CH	18035
IT	66030	Treglio	Abruzzo	Chieti	CH	18036
IT	66030	Arielli	Abruzzo	Chieti	CH	18037
IT	66030	Frisa	Abruzzo	Chieti	CH	18038
IT	66030	Filetto	Abruzzo	Chieti	CH	18039
IT	66030	Carpineto Sinello	Abruzzo	Chieti	CH	18040
IT	66030	Guastameroli	Abruzzo	Chieti	CH	18041
IT	66031	Casalanguida	Abruzzo	Chieti	CH	18042
IT	66032	Castel Frentano	Abruzzo	Chieti	CH	18043
IT	66033	Castiglione Messer Marino	Abruzzo	Chieti	CH	18044
IT	66034	Lanciano	Abruzzo	Chieti	CH	18045
IT	66034	Madonna Del Carmine	Abruzzo	Chieti	CH	18046
IT	66034	Rizzacorno	Abruzzo	Chieti	CH	18047
IT	66034	Villa Elce	Abruzzo	Chieti	CH	18048
IT	66034	Nasuti	Abruzzo	Chieti	CH	18049
IT	66034	Sant'Amato	Abruzzo	Chieti	CH	18050
IT	66036	Orsogna	Abruzzo	Chieti	CH	18051
IT	66037	Sant'Eusanio Del Sangro	Abruzzo	Chieti	CH	18052
IT	66038	Marina Di San Vito	Abruzzo	Chieti	CH	18053
IT	66038	Sant'Apollinare Chietino	Abruzzo	Chieti	CH	18054
IT	66038	San Vito Chietino	Abruzzo	Chieti	CH	18055
IT	66040	Civitaluparella	Abruzzo	Chieti	CH	18056
IT	66040	Quadri	Abruzzo	Chieti	CH	18057
IT	66040	Montelapiano	Abruzzo	Chieti	CH	18058
IT	66040	Perano	Abruzzo	Chieti	CH	18059
IT	66040	Gamberale	Abruzzo	Chieti	CH	18060
IT	66040	Castelguidone	Abruzzo	Chieti	CH	18061
IT	66040	Roio Del Sangro	Abruzzo	Chieti	CH	18062
IT	66040	Pennadomo	Abruzzo	Chieti	CH	18063
IT	66040	Giuliopoli	Abruzzo	Chieti	CH	18064
IT	66040	Colledimezzo	Abruzzo	Chieti	CH	18065
IT	66040	Montebello Sul Sangro	Abruzzo	Chieti	CH	18066
IT	66040	Monteferrante	Abruzzo	Chieti	CH	18067
IT	66040	Selva	Abruzzo	Chieti	CH	18068
IT	66040	Fallo	Abruzzo	Chieti	CH	18069
IT	66040	Buonanotte	Abruzzo	Chieti	CH	18070
IT	66040	Roccascalegna	Abruzzo	Chieti	CH	18071
IT	66040	Rosello	Abruzzo	Chieti	CH	18072
IT	66040	Borrello	Abruzzo	Chieti	CH	18073
IT	66040	Selva Di Altino	Abruzzo	Chieti	CH	18074
IT	66040	Altino	Abruzzo	Chieti	CH	18075
IT	66040	Pietraferrazzana	Abruzzo	Chieti	CH	18076
IT	66040	Pizzoferrato	Abruzzo	Chieti	CH	18077
IT	66041	Piazzano Di Atessa	Abruzzo	Chieti	CH	18078
IT	66041	Piana La Fara	Abruzzo	Chieti	CH	18079
IT	66041	Atessa	Abruzzo	Chieti	CH	18080
IT	66041	Piazzano	Abruzzo	Chieti	CH	18081
IT	66041	Monte Marcone	Abruzzo	Chieti	CH	18082
IT	66042	Bomba	Abruzzo	Chieti	CH	18083
IT	66043	Selva Piana	Abruzzo	Chieti	CH	18084
IT	66043	Casoli	Abruzzo	Chieti	CH	18085
IT	66044	Archi	Abruzzo	Chieti	CH	18086
IT	66044	Piane D'Archi	Abruzzo	Chieti	CH	18087
IT	66045	Schiavi Di Abruzzo	Abruzzo	Chieti	CH	18088
IT	66045	Taverna Di Schiavi Di Abruzzo	Abruzzo	Chieti	CH	18089
IT	66046	Tornareccio	Abruzzo	Chieti	CH	18090
IT	66046	San Giovanni	Abruzzo	Chieti	CH	18091
IT	66047	Villa Santa Maria	Abruzzo	Chieti	CH	18092
IT	66050	Palmoli	Abruzzo	Chieti	CH	18093
IT	66050	Carunchio	Abruzzo	Chieti	CH	18094
IT	66050	Monteodorisio	Abruzzo	Chieti	CH	18095
IT	66050	Torrebruna	Abruzzo	Chieti	CH	18096
IT	66050	Fresagrandinaria	Abruzzo	Chieti	CH	18097
IT	66050	San Giovanni Lipioni	Abruzzo	Chieti	CH	18098
IT	66050	Celenza Sul Trigno	Abruzzo	Chieti	CH	18099
IT	66050	Liscia	Abruzzo	Chieti	CH	18100
IT	66050	Olmi	Abruzzo	Chieti	CH	18101
IT	66050	Dogliola	Abruzzo	Chieti	CH	18102
IT	66050	Roccaspinalveti	Abruzzo	Chieti	CH	18103
IT	66050	San Salvo	Abruzzo	Chieti	CH	18104
IT	66050	Furci	Abruzzo	Chieti	CH	18105
IT	66050	San Salvo Marina	Abruzzo	Chieti	CH	18106
IT	66050	Fraine	Abruzzo	Chieti	CH	18107
IT	66050	Tufillo	Abruzzo	Chieti	CH	18108
IT	66050	Lentella	Abruzzo	Chieti	CH	18109
IT	66050	San Buono	Abruzzo	Chieti	CH	18110
IT	66050	Guilmi	Abruzzo	Chieti	CH	18111
IT	66050	Guardiabruna	Abruzzo	Chieti	CH	18112
IT	66051	Cupello	Abruzzo	Chieti	CH	18113
IT	66052	Gissi	Abruzzo	Chieti	CH	18114
IT	66054	San Lorenzo Di Vasto	Abruzzo	Chieti	CH	18115
IT	66054	Vasto	Abruzzo	Chieti	CH	18116
IT	66054	Marina Di Vasto	Abruzzo	Chieti	CH	18117
IT	66054	Incoronata Di Vasto	Abruzzo	Chieti	CH	18118
IT	66054	Vasto Marina	Abruzzo	Chieti	CH	18119
IT	66100	Chieti	Abruzzo	Chieti	CH	18120
IT	66100	Brecciarola	Abruzzo	Chieti	CH	18121
IT	66100	Chieti Scalo	Abruzzo	Chieti	CH	18122
IT	66100	Chieti Stazione	Abruzzo	Chieti	CH	18123
IT	66100	Tricalle	Abruzzo	Chieti	CH	18124
IT	65010	Picciano	Abruzzo	Pescara	PE	18125
IT	65010	Moscufo	Abruzzo	Pescara	PE	18126
IT	65010	Piccianello	Abruzzo	Pescara	PE	18127
IT	65010	Farindola	Abruzzo	Pescara	PE	18128
IT	65010	Nocciano	Abruzzo	Pescara	PE	18129
IT	65010	Villa Raspa	Abruzzo	Pescara	PE	18130
IT	65010	Brittoli	Abruzzo	Pescara	PE	18131
IT	65010	Vestea	Abruzzo	Pescara	PE	18132
IT	65010	Santa Lucia Di Collecorvino	Abruzzo	Pescara	PE	18133
IT	65010	Caprara D'Abruzzo	Abruzzo	Pescara	PE	18134
IT	65010	Civitaquana	Abruzzo	Pescara	PE	18135
IT	65010	Barberi	Abruzzo	Pescara	PE	18136
IT	65010	Elice	Abruzzo	Pescara	PE	18137
IT	65010	Montebello Di Bertona	Abruzzo	Pescara	PE	18138
IT	65010	Collecorvino	Abruzzo	Pescara	PE	18139
IT	65010	Santa Teresa	Abruzzo	Pescara	PE	18140
IT	65010	Carpineto Della Nora	Abruzzo	Pescara	PE	18141
IT	65010	Cappelle Sul Tavo	Abruzzo	Pescara	PE	18142
IT	65010	Vicoli	Abruzzo	Pescara	PE	18143
IT	65010	Civitella Casanova	Abruzzo	Pescara	PE	18144
IT	65010	Santa Lucia	Abruzzo	Pescara	PE	18145
IT	65010	Villa Celiera	Abruzzo	Pescara	PE	18146
IT	65010	Spoltore	Abruzzo	Pescara	PE	18147
IT	65010	Congiunti	Abruzzo	Pescara	PE	18148
IT	65011	Catignano	Abruzzo	Pescara	PE	18149
IT	65012	Villanova	Abruzzo	Pescara	PE	18150
IT	65012	Vallemare Di Cepagatti	Abruzzo	Pescara	PE	18151
IT	65012	Villareia	Abruzzo	Pescara	PE	18152
IT	65012	Cepagatti	Abruzzo	Pescara	PE	18153
IT	65012	Vallemare	Abruzzo	Pescara	PE	18154
IT	65013	Marina	Abruzzo	Pescara	PE	18155
IT	65013	San Martino Bassa	Abruzzo	Pescara	PE	18156
IT	65013	Villa Cipresso	Abruzzo	Pescara	PE	18157
IT	65013	Citta' Sant'Angelo	Abruzzo	Pescara	PE	18158
IT	65014	Loreto Aprutino	Abruzzo	Pescara	PE	18159
IT	65015	Montesilvano Marina	Abruzzo	Pescara	PE	18160
IT	65015	Montesilvano Colle	Abruzzo	Pescara	PE	18161
IT	65015	Villa Carmine	Abruzzo	Pescara	PE	18162
IT	65015	Montesilvano Spiaggia	Abruzzo	Pescara	PE	18163
IT	65015	Montesilvano	Abruzzo	Pescara	PE	18164
IT	65017	Penne	Abruzzo	Pescara	PE	18165
IT	65017	Roccafinadamo	Abruzzo	Pescara	PE	18166
IT	65019	Castellana	Abruzzo	Pescara	PE	18167
IT	65019	Pianella	Abruzzo	Pescara	PE	18168
IT	65019	Cerratina	Abruzzo	Pescara	PE	18169
IT	65020	Salle	Abruzzo	Pescara	PE	18170
IT	65020	Ticchione	Abruzzo	Pescara	PE	18171
IT	65020	Alanno	Abruzzo	Pescara	PE	18172
IT	65020	Lettomanoppello	Abruzzo	Pescara	PE	18173
IT	65020	Roccamorice	Abruzzo	Pescara	PE	18174
IT	65020	Castiglione A Casauria	Abruzzo	Pescara	PE	18175
IT	65020	Turrivalignani	Abruzzo	Pescara	PE	18176
IT	65020	Alanno Scalo	Abruzzo	Pescara	PE	18177
IT	65020	Sant'Eufemia A Maiella	Abruzzo	Pescara	PE	18178
IT	65020	Musellaro	Abruzzo	Pescara	PE	18179
IT	65020	Rosciano	Abruzzo	Pescara	PE	18180
IT	65020	Abbateggio	Abruzzo	Pescara	PE	18181
IT	65020	Pietranico	Abruzzo	Pescara	PE	18182
IT	65020	Cugnoli	Abruzzo	Pescara	PE	18183
IT	65020	Villa Badessa	Abruzzo	Pescara	PE	18184
IT	65020	Bolognano	Abruzzo	Pescara	PE	18185
IT	65020	Corvara	Abruzzo	Pescara	PE	18186
IT	65020	Pescosansonesco	Abruzzo	Pescara	PE	18187
IT	65020	Villa Oliveti	Abruzzo	Pescara	PE	18188
IT	65020	Villa San Giovanni	Abruzzo	Pescara	PE	18189
IT	65020	San Valentino In Abruzzo Citeriore	Abruzzo	Pescara	PE	18190
IT	65020	Pesconuovo	Abruzzo	Pescara	PE	18191
IT	65020	Piano D'Orta	Abruzzo	Pescara	PE	18192
IT	65020	Alanno Stazione	Abruzzo	Pescara	PE	18193
IT	65022	Bussi Sul Tirino	Abruzzo	Pescara	PE	18194
IT	65022	Bussi Officine	Abruzzo	Pescara	PE	18195
IT	65023	Caramanico Terme	Abruzzo	Pescara	PE	18196
IT	65023	San Tommaso	Abruzzo	Pescara	PE	18197
IT	65024	Ripacorbaria	Abruzzo	Pescara	PE	18198
IT	65024	Manoppello	Abruzzo	Pescara	PE	18199
IT	65024	Manoppello Scalo	Abruzzo	Pescara	PE	18200
IT	65024	Manoppello Stazione	Abruzzo	Pescara	PE	18201
IT	65025	Serramonacesca	Abruzzo	Pescara	PE	18202
IT	65026	Popoli	Abruzzo	Pescara	PE	18203
IT	65027	Scafa	Abruzzo	Pescara	PE	18204
IT	65027	Decontra	Abruzzo	Pescara	PE	18205
IT	65028	Tocco Da Casauria	Abruzzo	Pescara	PE	18206
IT	65029	Torre De' Passeri	Abruzzo	Pescara	PE	18207
IT	65100	Pescara	Abruzzo	Pescara	PE	18208
IT	65121	Pescara	Abruzzo	Pescara	PE	18209
IT	65122	Pescara	Abruzzo	Pescara	PE	18210
IT	65123	Pescara	Abruzzo	Pescara	PE	18211
IT	65124	Pescara	Abruzzo	Pescara	PE	18212
IT	65125	Pescara Colli	Abruzzo	Pescara	PE	18213
IT	65125	Pescara	Abruzzo	Pescara	PE	18214
IT	65126	Pescara	Abruzzo	Pescara	PE	18215
IT	65127	Pescara	Abruzzo	Pescara	PE	18216
IT	65128	Pescara	Abruzzo	Pescara	PE	18217
IT	65129	Pineta Di Pescara	Abruzzo	Pescara	PE	18218
IT	65129	Pescara	Abruzzo	Pescara	PE	18219
IT	65131	Fontanelle	Abruzzo	Pescara	PE	18220
IT	65132	San Silvestro	Abruzzo	Pescara	PE	18221
IT	65132	Pescara	Abruzzo	Pescara	PE	18222
IT	64010	Torano Nuovo	Abruzzo	Teramo	TE	18223
IT	64010	Colonnella	Abruzzo	Teramo	TE	18224
IT	64010	Ancarano	Abruzzo	Teramo	TE	18225
IT	64010	Villa Lempa	Abruzzo	Teramo	TE	18226
IT	64010	Valle Castellana	Abruzzo	Teramo	TE	18227
IT	64010	Torricella Sicura	Abruzzo	Teramo	TE	18228
IT	64010	Rocca Santa Maria	Abruzzo	Teramo	TE	18229
IT	64010	Rocche Di Civitella	Abruzzo	Teramo	TE	18230
IT	64010	Civitella Del Tronto	Abruzzo	Teramo	TE	18231
IT	64010	Pascellata	Abruzzo	Teramo	TE	18232
IT	64010	Villa Passo	Abruzzo	Teramo	TE	18233
IT	64010	Cerqueto Del Tronto	Abruzzo	Teramo	TE	18234
IT	64010	Villa Favale	Abruzzo	Teramo	TE	18235
IT	64010	San Vito	Abruzzo	Teramo	TE	18236
IT	64010	Cesano	Abruzzo	Teramo	TE	18237
IT	64010	Santo Stefano	Abruzzo	Teramo	TE	18238
IT	64010	Pietralta	Abruzzo	Teramo	TE	18239
IT	64010	Leofara	Abruzzo	Teramo	TE	18240
IT	64010	Santo Stefano Di Torricella Sicura	Abruzzo	Teramo	TE	18241
IT	64010	Ioanella	Abruzzo	Teramo	TE	18242
IT	64010	Ponzano	Abruzzo	Teramo	TE	18243
IT	64010	Controguerra	Abruzzo	Teramo	TE	18244
IT	64010	Ripe Civitella Del Tronto	Abruzzo	Teramo	TE	18245
IT	64011	Alba Adriatica	Abruzzo	Teramo	TE	18246
IT	64012	Paterno	Abruzzo	Teramo	TE	18247
IT	64012	Sant'Onofrio	Abruzzo	Teramo	TE	18248
IT	64012	Garrufo Di Campli	Abruzzo	Teramo	TE	18249
IT	64012	Campli	Abruzzo	Teramo	TE	18250
IT	64012	Campovalano	Abruzzo	Teramo	TE	18251
IT	64012	Piancarani	Abruzzo	Teramo	TE	18252
IT	64012	Villa Paterno	Abruzzo	Teramo	TE	18253
IT	64013	Corropoli	Abruzzo	Teramo	TE	18254
IT	64014	Villa Rosa	Abruzzo	Teramo	TE	18255
IT	64014	Martinsicuro	Abruzzo	Teramo	TE	18256
IT	64014	Villa Rosa Di Martinsicuro	Abruzzo	Teramo	TE	18257
IT	64015	Nereto	Abruzzo	Teramo	TE	18258
IT	64016	Sant'Egidio Alla Vibrata	Abruzzo	Teramo	TE	18259
IT	64016	Faraone Nuovo	Abruzzo	Teramo	TE	18260
IT	64016	Villa Mattoni	Abruzzo	Teramo	TE	18261
IT	64016	Faraone	Abruzzo	Teramo	TE	18262
IT	64016	Paolantonio	Abruzzo	Teramo	TE	18263
IT	64018	Tortoreto Lido	Abruzzo	Teramo	TE	18264
IT	64018	Tortoreto	Abruzzo	Teramo	TE	18265
IT	64018	Salino	Abruzzo	Teramo	TE	18266
IT	64020	Canzano	Abruzzo	Teramo	TE	18267
IT	64020	Castellalto	Abruzzo	Teramo	TE	18268
IT	64020	Pagliare	Abruzzo	Teramo	TE	18269
IT	64020	Castelbasso	Abruzzo	Teramo	TE	18270
IT	64020	Bellante	Abruzzo	Teramo	TE	18271
IT	64020	Morro D'Oro	Abruzzo	Teramo	TE	18272
IT	64020	Castelnuovo Vomano	Abruzzo	Teramo	TE	18273
IT	64020	Valle Canzano	Abruzzo	Teramo	TE	18274
IT	64020	Casemolino	Abruzzo	Teramo	TE	18275
IT	64020	Petriccione	Abruzzo	Teramo	TE	18276
IT	64020	Bellante Stazione	Abruzzo	Teramo	TE	18277
IT	64020	Villa Zaccheo	Abruzzo	Teramo	TE	18278
IT	64020	Ripattoni	Abruzzo	Teramo	TE	18279
IT	64020	Zaccheo	Abruzzo	Teramo	TE	18280
IT	64021	Colleranesco	Abruzzo	Teramo	TE	18281
IT	64021	Giulianova	Abruzzo	Teramo	TE	18282
IT	64021	Giulianova Spiaggia	Abruzzo	Teramo	TE	18283
IT	64023	Montone	Abruzzo	Teramo	TE	18284
IT	64023	Mosciano Sant'Angelo	Abruzzo	Teramo	TE	18285
IT	64023	Notaresco Stazione	Abruzzo	Teramo	TE	18286
IT	64024	Pianura Vomano	Abruzzo	Teramo	TE	18287
IT	64024	Guardia Vomano	Abruzzo	Teramo	TE	18288
IT	64024	Notaresco	Abruzzo	Teramo	TE	18289
IT	64025	Scerne	Abruzzo	Teramo	TE	18290
IT	64025	Borgo Santa Maria Immacolata	Abruzzo	Teramo	TE	18291
IT	64025	Scerne Di Pineto	Abruzzo	Teramo	TE	18292
IT	64025	Mutignano	Abruzzo	Teramo	TE	18293
IT	64025	Pineto	Abruzzo	Teramo	TE	18294
IT	64026	Cologna Spiaggia	Abruzzo	Teramo	TE	18295
IT	64026	Roseto Degli Abruzzi	Abruzzo	Teramo	TE	18296
IT	64026	San Giovanni	Abruzzo	Teramo	TE	18297
IT	64026	Santa Lucia Di Roseto Degli Abruzzi	Abruzzo	Teramo	TE	18298
IT	64026	Cologna	Abruzzo	Teramo	TE	18299
IT	64026	Montepagano	Abruzzo	Teramo	TE	18300
IT	64026	Cologna Paese	Abruzzo	Teramo	TE	18301
IT	64026	Santa Lucia	Abruzzo	Teramo	TE	18302
IT	64027	Garrufo	Abruzzo	Teramo	TE	18303
IT	64027	Poggio Morello	Abruzzo	Teramo	TE	18304
IT	64027	Sant'Omero	Abruzzo	Teramo	TE	18305
IT	64028	Pianacce	Abruzzo	Teramo	TE	18306
IT	64028	Silvi Marina	Abruzzo	Teramo	TE	18307
IT	64028	San Silvestro	Abruzzo	Teramo	TE	18308
IT	64028	Silvi	Abruzzo	Teramo	TE	18309
IT	64030	Castel Castagna	Abruzzo	Teramo	TE	18310
IT	64030	Villa Bozza	Abruzzo	Teramo	TE	18311
IT	64030	Basciano	Abruzzo	Teramo	TE	18312
IT	64030	Montefino	Abruzzo	Teramo	TE	18313
IT	64031	Arsita	Abruzzo	Teramo	TE	18314
IT	64032	Fontanelle	Abruzzo	Teramo	TE	18315
IT	64032	Atri	Abruzzo	Teramo	TE	18316
IT	64032	Casoli Di Atri	Abruzzo	Teramo	TE	18317
IT	64032	Treciminiere	Abruzzo	Teramo	TE	18318
IT	64032	Santa Margherita	Abruzzo	Teramo	TE	18319
IT	64032	Santa Margherita Di Atri	Abruzzo	Teramo	TE	18320
IT	64032	Casoli	Abruzzo	Teramo	TE	18321
IT	64032	San Giacomo	Abruzzo	Teramo	TE	18322
IT	64032	San Giacomo D'Atri	Abruzzo	Teramo	TE	18323
IT	64033	Bisenti	Abruzzo	Teramo	TE	18324
IT	64034	Castiglione Messer Raimondo	Abruzzo	Teramo	TE	18325
IT	64034	Appignano	Abruzzo	Teramo	TE	18326
IT	64035	Castilenti	Abruzzo	Teramo	TE	18327
IT	64035	Villa San Romualdo	Abruzzo	Teramo	TE	18328
IT	64036	Scorrano	Abruzzo	Teramo	TE	18329
IT	64036	Cellino Attanasio	Abruzzo	Teramo	TE	18330
IT	64037	Montegualtieri	Abruzzo	Teramo	TE	18331
IT	64037	Cermignano	Abruzzo	Teramo	TE	18332
IT	64037	Poggio Delle Rose	Abruzzo	Teramo	TE	18333
IT	64039	Val Vomano	Abruzzo	Teramo	TE	18334
IT	64039	Penna Sant'Andrea	Abruzzo	Teramo	TE	18335
IT	64040	Cortino	Abruzzo	Teramo	TE	18336
IT	64040	Padula	Abruzzo	Teramo	TE	18337
IT	64040	Pagliaroli	Abruzzo	Teramo	TE	18338
IT	64041	Colledoro	Abruzzo	Teramo	TE	18339
IT	64041	Castelli	Abruzzo	Teramo	TE	18340
IT	64042	Ornano Grande	Abruzzo	Teramo	TE	18341
IT	64042	Colledara	Abruzzo	Teramo	TE	18342
IT	64042	Villa Petto	Abruzzo	Teramo	TE	18343
IT	64043	Cesacastina	Abruzzo	Teramo	TE	18344
IT	64043	Cervaro	Abruzzo	Teramo	TE	18345
IT	64043	Nerito	Abruzzo	Teramo	TE	18346
IT	64043	Poggio Umbricchio	Abruzzo	Teramo	TE	18347
IT	64043	San Giorgio	Abruzzo	Teramo	TE	18348
IT	64043	Crognaleto	Abruzzo	Teramo	TE	18349
IT	64043	Macchia Vomano	Abruzzo	Teramo	TE	18350
IT	64043	Tottea	Abruzzo	Teramo	TE	18351
IT	64043	San Giorgio Di Crognaleto	Abruzzo	Teramo	TE	18352
IT	64044	Cerqueto	Abruzzo	Teramo	TE	18353
IT	64044	Fano Adriano	Abruzzo	Teramo	TE	18354
IT	64045	Cerchiara	Abruzzo	Teramo	TE	18355
IT	64045	San Gabriele Dell'Addolorata	Abruzzo	Teramo	TE	18356
IT	64045	Isola Del Gran Sasso D'Italia	Abruzzo	Teramo	TE	18357
IT	64045	Forca Di Valle	Abruzzo	Teramo	TE	18358
IT	64045	Fano A Corno	Abruzzo	Teramo	TE	18359
IT	64046	Collevecchio Di Montorio	Abruzzo	Teramo	TE	18360
IT	64046	Montorio Al Vomano	Abruzzo	Teramo	TE	18361
IT	64046	Cusciano	Abruzzo	Teramo	TE	18362
IT	64046	Leognano	Abruzzo	Teramo	TE	18363
IT	64047	Intermesoli	Abruzzo	Teramo	TE	18364
IT	64047	Pietracamela	Abruzzo	Teramo	TE	18365
IT	64049	Azzinano	Abruzzo	Teramo	TE	18366
IT	64049	Tossicia	Abruzzo	Teramo	TE	18367
IT	64049	Chiarino	Abruzzo	Teramo	TE	18368
IT	64100	Spiano	Abruzzo	Teramo	TE	18369
IT	64100	Sant'Atto	Abruzzo	Teramo	TE	18370
IT	64100	Frondarola	Abruzzo	Teramo	TE	18371
IT	64100	Tordinia	Abruzzo	Teramo	TE	18372
IT	64100	Villa Vomano	Abruzzo	Teramo	TE	18373
IT	64100	Valle San Giovanni	Abruzzo	Teramo	TE	18374
IT	64100	San Nicolo' A Tordino	Abruzzo	Teramo	TE	18375
IT	64100	Miano	Abruzzo	Teramo	TE	18376
IT	64100	Poggio San Vittorino	Abruzzo	Teramo	TE	18377
IT	64100	Piano D'Accio	Abruzzo	Teramo	TE	18378
IT	64100	Villa Ripa	Abruzzo	Teramo	TE	18379
IT	64100	Teramo	Abruzzo	Teramo	TE	18380
IT	64100	Castagneto	Abruzzo	Teramo	TE	18381
IT	64100	Colleminuccio	Abruzzo	Teramo	TE	18382
IT	64100	Forcella	Abruzzo	Teramo	TE	18383
IT	64100	Varano	Abruzzo	Teramo	TE	18384
IT	64100	Colle Santa Maria	Abruzzo	Teramo	TE	18385
IT	64100	Colleatterrato Alto	Abruzzo	Teramo	TE	18386
IT	64100	Nepezzano	Abruzzo	Teramo	TE	18387
IT	64100	Cartecchio	Abruzzo	Teramo	TE	18388
\.


--
-- TOC entry 2928 (class 0 OID 24967)
-- Dependencies: 209
-- Data for Name: recensione; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recensione (testo, stelle, codrecensione, codbusiness, codutente) FROM stdin;
Hotel in ottima posizione vicino ai parcheggi e alla stazione. Personale simpatico e molto accogliente, ti coccolano e ti fanno sentire come a casa. Bellissimo e molto curato l'arredamento. Ottimo rapporto qualità/prezzo.	5	19	14	6
Questa è stata la nostra prima notte in Italia ed era un po' calda di notte. È necessario chiedere al personale di abbassare la temperatura nella camera. Stavo cercando di controllo e in camera, cosa che non era aiutare fresco, ma le camere erano molto belle e pulite. Il personale dell'hotel era molto cordiale e disponibile. Questa è stata una buona posizione per noi, perché non era così turistica. Abbiamo fatto colazione fuori in giardino. Molto bello. Avrei dato 5 stelle se l'avessi saputo di chiedere alla reception per l'aria.	3	20	14	7
Il blu del mare, l’azzurro del cielo, il verde delle palme, il Castello Aragonese stampato di fronte, il calore delle piscine, la gentilezza del personale, la bontà dei ricci.\nAd Ischia il paradiso esiste e bisogna ritornarci.\nUno dei posti più chic , eleganti e rilassanti dell’isola. Provare per credere!	5	21	15	6
Sarà stata una giornata no? leggendo le recensioni le mie aspettative erano sicuramente alte e purtroppo ne sono rimasta delusa, ho mangiato un pacchero al tonno che non sono neanche riuscita a finire (il tonno era quasi del tutto assente e la salsa di pomodoro non incontrava affatto il mio gusto), il fritto di pesce era in realtà un discreto fritto di verdure con diversi gusci vuoti fritti. Il ristorante è carino ed il personale gentile, ma sinceramente la cucina non è stata di mio gradimento.	2	22	19	6
L'acquario di Genova è un'eccellenza.\nGli animali sono ben curati e per quanto io detesti le gabbie, gli zoo, i circhi, devo ammettere che qui alcune specie vivono protette e al sicuro , è un modo per far conoscere alle persone il mondo marino che è fantastico.	5	23	17	6
Ho scoperto questo grazioso localino, piccolo ma ben curato che offre la possibilità di degustare prodotti tipici pugliesi di altissima qualità. Lo staff poi è gentilissimo e disponibile. Lo consiglio.	4	24	18	6
Prodotti tipici di alta qualita'..x chi ha voglia di mangiare qualcosa di diverso..da provare assolutamente! Super consigliato!	4	25	18	7
Ideale se avete bambini.\nPotrebbe essere reso molto più interessante e magari qualche vasca potrebbe essere tenuta meglio.\nIl prezzo è troppo alto ma per fortuna si può prendere con i punti dell'esselunga.\nPer una giornata diversa è l ideale.	3	26	17	7
Ho soggiornato con la mia famiglia 3 notti presso questa bellissima struttura della quale non posso che dare un’ottima valutazione complessiva. La struttura e’ molto ben tenuta, il mare ed il panorama sono spettacolari, la qualità della colazione, del pranzo e della cena davvero notevoli.\nIl personale molto gentile e disponibile.\nConsiglio vivamente per chi vuole vivere qualche giorno di relax e tranquillità immerso nella natura e negli scenari mozzafiato ischitani.	4	27	15	7
Cena assolutamente da fare ! Finalmente non un ristorante turistico dove stanno fuori dalla porta ad invitarti ad entrare anzi! Proprio questo ci ha portato a sceglierlo e ne è valsa la pena perché abbiamo mangiato benissimo al giusto prezzo!! Personale alla mano e gentile ..	4	28	19	7
\.


--
-- TOC entry 2922 (class 0 OID 24857)
-- Dependencies: 203
-- Data for Name: utente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.utente (codutente, username, nome, cognome, email, datadinascita, password, immagine, codiceverifica, frontedocumento, retrodocumento) FROM stdin;
5	admin	Mauro	Guida	maur.guida@studenti.unina.it	1999-06-18	TestPW	\N	\N	https://i.ytimg.com/vi/GCXLLw1X25M/hqdefault.jpg	https://1.bp.blogspot.com/-lcmj9rV0Gm8/UbEEcBKf6BI/AAAAAAAAADc/GQaQUiVxqp0/s1600/img_0001smudged.jpg
6	Utente1	Utente	Utente	da.faicchia@studenti.unina.it	1990-01-19	TestPW	\N	\N	\N	\N
7	Utente2	Utente	Utente	mauro.guida.369@outlook.com	1990-01-20	TestPW	\N	\N	\N	\N
8	Utente3	Utente	Utente	davidepiofaicchia@gmail.com	1990-01-05	TestPW	\N	\N	\N	\N
\.


--
-- TOC entry 2941 (class 0 OID 0)
-- Dependencies: 204
-- Name: business_codbusiness_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.business_codbusiness_seq', 19, true);


--
-- TOC entry 2942 (class 0 OID 0)
-- Dependencies: 212
-- Name: mappa_codmappa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mappa_codmappa_seq', 18388, true);


--
-- TOC entry 2943 (class 0 OID 0)
-- Dependencies: 208
-- Name: recensione_codrecensione_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.recensione_codrecensione_seq', 28, true);


--
-- TOC entry 2944 (class 0 OID 0)
-- Dependencies: 202
-- Name: utente_codutente_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.utente_codutente_seq', 8, true);


--
-- TOC entry 2774 (class 2606 OID 24896)
-- Name: business business_partitaiva_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business
    ADD CONSTRAINT business_partitaiva_key UNIQUE (partitaiva);


--
-- TOC entry 2776 (class 2606 OID 24894)
-- Name: business business_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business
    ADD CONSTRAINT business_pkey PRIMARY KEY (codbusiness);


--
-- TOC entry 2778 (class 2606 OID 25014)
-- Name: immagineproprieta immagineunica; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.immagineproprieta
    ADD CONSTRAINT immagineunica UNIQUE (url, codbusiness);


--
-- TOC entry 2786 (class 2606 OID 25071)
-- Name: mappa mappa_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mappa
    ADD CONSTRAINT mappa_pkey PRIMARY KEY (codmappa);


--
-- TOC entry 2780 (class 2606 OID 25012)
-- Name: associazioneraffinazione raffinazioneunica; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.associazioneraffinazione
    ADD CONSTRAINT raffinazioneunica UNIQUE (codbusiness, raffinazione);


--
-- TOC entry 2782 (class 2606 OID 24976)
-- Name: recensione recensione_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recensione
    ADD CONSTRAINT recensione_pkey PRIMARY KEY (codrecensione);


--
-- TOC entry 2784 (class 2606 OID 25010)
-- Name: recensione recensioneunicautenteluogo; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recensione
    ADD CONSTRAINT recensioneunicautenteluogo UNIQUE (codbusiness, codutente);


--
-- TOC entry 2768 (class 2606 OID 24874)
-- Name: utente utente_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utente
    ADD CONSTRAINT utente_email_key UNIQUE (email);


--
-- TOC entry 2770 (class 2606 OID 24870)
-- Name: utente utente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utente
    ADD CONSTRAINT utente_pkey PRIMARY KEY (codutente);


--
-- TOC entry 2772 (class 2606 OID 24872)
-- Name: utente utente_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.utente
    ADD CONSTRAINT utente_username_key UNIQUE (username);


--
-- TOC entry 2794 (class 2620 OID 25086)
-- Name: recensione calcolanuovamediadopoinserimentorecensione; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER calcolanuovamediadopoinserimentorecensione AFTER INSERT ON public.recensione FOR EACH ROW EXECUTE FUNCTION public.aggiornamediastelle();


--
-- TOC entry 2790 (class 2606 OID 24960)
-- Name: associazioneraffinazione associazioneraffinazione_codbusiness_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.associazioneraffinazione
    ADD CONSTRAINT associazioneraffinazione_codbusiness_fkey FOREIGN KEY (codbusiness) REFERENCES public.business(codbusiness) ON DELETE CASCADE;


--
-- TOC entry 2788 (class 2606 OID 25076)
-- Name: business business_codmappa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business
    ADD CONSTRAINT business_codmappa_fkey FOREIGN KEY (codmappa) REFERENCES public.mappa(codmappa);


--
-- TOC entry 2787 (class 2606 OID 24897)
-- Name: business business_codutente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business
    ADD CONSTRAINT business_codutente_fkey FOREIGN KEY (codutente) REFERENCES public.utente(codutente) ON DELETE CASCADE;


--
-- TOC entry 2789 (class 2606 OID 24908)
-- Name: immagineproprieta immagineproprieta_codbusiness_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.immagineproprieta
    ADD CONSTRAINT immagineproprieta_codbusiness_fkey FOREIGN KEY (codbusiness) REFERENCES public.business(codbusiness) ON DELETE CASCADE;


--
-- TOC entry 2793 (class 2606 OID 24993)
-- Name: immaginerecensione immaginerecensione_codrecensione_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.immaginerecensione
    ADD CONSTRAINT immaginerecensione_codrecensione_fkey FOREIGN KEY (codrecensione) REFERENCES public.recensione(codrecensione) ON DELETE CASCADE;


--
-- TOC entry 2791 (class 2606 OID 24977)
-- Name: recensione recensione_codbusiness_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recensione
    ADD CONSTRAINT recensione_codbusiness_fkey FOREIGN KEY (codbusiness) REFERENCES public.business(codbusiness) ON DELETE CASCADE;


--
-- TOC entry 2792 (class 2606 OID 24982)
-- Name: recensione recensione_codutente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recensione
    ADD CONSTRAINT recensione_codutente_fkey FOREIGN KEY (codutente) REFERENCES public.utente(codutente) ON DELETE CASCADE;


-- Completed on 2020-05-18 17:39:57

--
-- PostgreSQL database dump complete
--

