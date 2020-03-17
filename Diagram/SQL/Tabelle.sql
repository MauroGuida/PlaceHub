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

  Business bool NOT NULL DEFAULT '0',
  FronteDocumento VARCHAR(1000) DEFAULT NULL,
  RetroDocumento VARCHAR(1000) DEFAULT NULL
);

CREATE TYPE tipoBusiness AS ENUM ('Attrazione', 'Alloggio', 'Ristorante');
CREATE TABLE Business(
  codBusiness SERIAL PRIMARY KEY,
  Nome VARCHAR(50) NOT NULL,
  Indirizzo VARCHAR(100) NOT NULL,
  PartitaIVA VARCHAR(100) NOT NULL,
  tipo tipoBusiness NOT NULL,
  Descrizione VARCHAR(2000) NOT NULL,
  codUtente INTEGER REFERENCES Utente(codUtente) ON DELETE CASCADE
);

CREATE TABLE ImmagineProprietà(
  Url VARCHAR(1000) PRIMARY KEY,
  codBusiness INTEGER REFERENCES Business(codBusiness) ON DELETE CASCADE
);

CREATE TYPE tipoRaffinazione AS ENUM ('Bar','Braceria','Pizzeria','Paninoteca','Hotel','Casa Vacanze',               					  						'Cinema','ParcoGiochi','Museo','Shopping','Piscina');
CREATE TABLE Raffinazione(
   nomeRaffinazione tipoRaffinazione PRIMARY KEY
);

CREATE TABLE AssociazioneRaffinazione(
  codBusiness INTEGER REFERENCES Business(codBusiness) ON DELETE CASCADE,
  raffinazione tipoRaffinazione REFERENCES Raffinazione(nomeRaffinazione)
);

CREATE TABLE Recensione(
  Testo VARCHAR(2000) NOT NULL,
  Stelle INTEGER NOT NULL,
  CodRecensione SERIAL PRIMARY KEY,
  CodBusiness INTEGER REFERENCES Business(codBusiness) ON DELETE CASCADE,
  CodUtente INTEGER REFERENCES Utente(codUtente) ON DELETE CASCADE
);

CREATE TABLE ImmagineRecensione(
  Url VARCHAR(1000) NOT NULL,
  codRecensione INTEGER REFERENCES Recensione(CodRecensione) ON DELETE CASCADE
);



