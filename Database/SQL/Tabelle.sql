CREATE TABLE Utente(
  codUtente SERIAL PRIMARY KEY,

  Username VARCHAR(50) NOT NULL UNIQUE,
  Nome VARCHAR(50) NOT NULL,
  Cognome VARCHAR(50) NOT NULL,
  Email VARCHAR(100) NOT NULL UNIQUE CHECK(Email LIKE '_%@%.__%'),
  DataDiNascita date NOT NULL,
  Password VARCHAR(100) NOT NULL,

  Immagine VARCHAR(1000) DEFAULT NULL,
  codiceVerifica VARCHAR(10) DEFAULT NULL,

  FronteDocumento VARCHAR(1000) DEFAULT NULL,
  RetroDocumento VARCHAR(1000) DEFAULT NULL
);

CREATE TABLE Mappa(
    Stato VARCHAR(5),
    CAP VARCHAR(7),
    Comune VARCHAR(100),
    Regione VARCHAR(100),
    Provincia VARCHAR(100),
    SiglaProvincia VARCHAR(5),
    codMappa SERIAL PRIMARY KEY
);

CREATE TYPE tipoBusiness AS ENUM ('Attrazione', 'Alloggio', 'Ristorante');
CREATE TABLE Business(
  codBusiness SERIAL PRIMARY KEY,
  Nome VARCHAR(50) NOT NULL,
  Indirizzo VARCHAR(100) NOT NULL,
  PartitaIVA VARCHAR(100) NOT NULL UNIQUE,
  tipo tipoBusiness NOT NULL,
  Descrizione VARCHAR(2000) NOT NULL,
  Stelle NUMERIC DEFAULT NULL CHECK((Stelle BETWEEN 1 AND 5) OR Stelle IS NULL),
  Telefono VARCHAR(10) NOT NULL,
  codUtente INTEGER REFERENCES Utente(codUtente) ON DELETE CASCADE,
  codMappa INTEGER REFERENCES Mappa(codMappa)
);

CREATE TABLE ImmagineProprieta(
  Url VARCHAR(1000),
  codBusiness INTEGER REFERENCES Business(codBusiness) ON DELETE CASCADE
);

CREATE TYPE tipoRaffinazione AS ENUM ('Pizzeria', 'Braceria', 'FastFood',
				      'Paninoteca', 'Osteria', 'TavolaCalda',
				      'Taverna', 'Trattoria', 'Pesce',
				      'Cinema', 'Shopping','Monumento',
				      'Museo', 'ParcoGiochi', 'Piscina',
				      'Lounge', 'Hotel', 'Bed&Breakfast',
				      'Ostello', 'CasaVacanze' ,'Residence');

CREATE TABLE AssociazioneRaffinazione(
  codBusiness INTEGER REFERENCES Business(codBusiness) ON DELETE CASCADE,
  raffinazione tipoRaffinazione
);

CREATE TABLE Recensione(
  Testo VARCHAR(2000) NOT NULL,
  Stelle NUMERIC NOT NULL CHECK(Stelle BETWEEN 1 AND 5),
  CodRecensione SERIAL PRIMARY KEY,
  CodBusiness INTEGER REFERENCES Business(codBusiness) ON DELETE CASCADE,
  CodUtente INTEGER REFERENCES Utente(codUtente) ON DELETE CASCADE
);

CREATE TABLE ImmagineRecensione(
  Url VARCHAR(1000) NOT NULL,
  codRecensione INTEGER REFERENCES Recensione(CodRecensione) ON DELETE CASCADE
);
