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
  FronteDocumento VARCHAR(1000) NOT NULL,
  RetroDocumento VARCHAR(1000) NOT NULL
);

ALTER TABLE Utente ADD CONSTRAINT LunghezzaPassword CHECK(length(Password)>=6);

CREATE TABLE Recensione(
  Testo VARCHAR(2000) NOT NULL,
  Stelle INTEGER NOT NULL,
  CodRecensione SERIAL PRIMARY KEY,
  CodBusiness INTEGER FOREIGN KEY REFERENCES Business(codBusiness) ON DELETE CASCADE,
  CodUtente INTEGER FOREIGN KEY REFERENCES Utente(codUtente) ON DELETE CASCADE
);

CREATE TABLE ImmagineRecensione(
  Url VARCHAR(1000) NOT NULL,
  codRecensione INTEGER FOREIGN KEY REFERENCES Recensione(CodRecensione) ON DELETE CASCADE
);

CREATE TABLE Business(
  codBusiness SERIAL PRIMARY KEY,
  Nome VARCHAR(50) NOT NULL,
  Indirizzo VARCHAR(100) NOT NULL,
  PartitaIVA VARCHAR(100) NOT NULL,
  Tipo ENUM ('Ristorante','Intrattenimento','Alloggio'),
  Descrizione VARCHAR(2000) NOT NULL,
  codUtente INTEGER FOREIGN KEY REFERENCES Utente(codUtente) ON DELETE CASCADE
);

CREATE TABLE ImmagineProprietà(
  Url VARCHAR(1000) PRIMARY KEY,
  codBusiness INTEGER FOREIGN KEY REFERENCES Business(codBusiness) ON DELETE CASCADE
);

CREATE TABLE RaffinazioneTipo(
  raffinazione ENUM ('Bar','Braceria','Pizzeria',
					           'Paninoteca','Hotel','Casa Vacanze',
					           'Cinema','ParcoGiochi','Museo','Shopping','Piscina') PRIMARY KEY
);

CREATE TABLE Associazione_Tipo(
  codBusiness INTEGER FOREIGN KEY REFERENCES Business(codBusiness) ON DELETE CASCADE,
  raffinazione ENUM ('Bar','Braceria','Pizzeria',
					           'Paninoteca','Hotel','Casa Vacanze',
					           'Cinema','ParcoGiochi','Museo','Shopping','Piscina')
					           FOREIGN KEY REFERENCES RaffinazioneTipo(raffinazione)
);
