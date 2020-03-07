CREATE TABLE User(
  Nome VARCHAR(50) NOT NULL,
  Cognome VARCHAR(50) NOT NULL,
  Email VARCHAR(100) NOT NULL,
  DataDiNascita date NOT NULL,
  codUser SERIAL PRIMARY KEY,
  Password VARCHAR(100) NOT NULL,
  Immagine VARCHAR(1000) NOT NULL,
  Attivita? bool NOT NULL DEFAULT 0
);

CREATE TABLE Verifica(
  FronteDocumento VARCHAR(1000) NOT NULL,
  RetroDocumento VARCHAR(1000) NOT NULL
);

CREATE TABLE Recensione(
  Testo VARCHAR(2000) NOT NULL,
  Stelle INTEGER NOT NULL,
  CodRecensione SERIAL PRIMARY KEY,
  CodAttività INTEGER FOREIGN KEY REFERENCES Attività(codAttivita),
  CodUser INTEGER FOREIGN KEY REFERENCES User(codUser)
);

CREATE TABLE ImmagineRecensione(
  Url VARCHAR(1000) NOT NULL,
  codRecensione INTEGER FOREIGN KEY REFERENCES Recensione(CodRecensione)
);

CREATE TABLE Attività(
  codAttivita SERIAL PRIMARY KEY,
  Nome VARCHAR(50) NOT NULL,
  Indirizzo VARCHAR(100) NOT NULL,
  PartitaIVA VARCHAR(100) NOT NULL,
  Tipo ENUM ('Ristorante','Intrattenimento','Alloggio'),
  Descrizione VARCHAR(2000) NOT NULL,
  codUser INTEGER FOREIGN KEY REFERENCES User(codUser)
);

CREATE TABLE ImmagineProprietà(
  Url VARCHAR(1000) PRIMARY KEY,
  codAttivita INTEGER FOREIGN KEY REFERENCES Attività(codAttivita)
);

CREATE TABLE Tag(
  parola VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Associazione_Tag(
  codAttivita INTEGER FOREIGN KEY REFERENCES Attività(codAttivita),
  parola VARCHAR(50) FOREIGN KEY REFERENCES Tag(parola)
);

CREATE TABLE RaffinazioneTipo(
  raffinazione ENUM ('Bar','Braceria','Pizzeria',
					           'Paninoteca','Hotel','Casa Vacanze',
					           'Cinema','ParcoGiochi','Museo','Shopping','Piscina') PRIMARY KEY
);

CREATE TABLE Associazione_Tipo(
  codAttivita INTEGER FOREIGN KEY REFERENCES Attività(codAttivita),
  raffinazione ENUM ('Bar','Braceria','Pizzeria',
					           'Paninoteca','Hotel','Casa Vacanze',
					           'Cinema','ParcoGiochi','Museo','Shopping','Piscina')
					           FOREIGN KEY REFERENCES RaffinazioneTipo(raffinazione)
);
