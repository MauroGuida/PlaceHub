package gestione;

public class LayoutEmail {
	public String corpoEmailReimpostaPassword(String codiceVerifica) {
		return "<!doctype html>\r\n" + 
				"<html>\r\n" + 
				"	<head>\r\n" + 
				"		<title>PlaceHub</title>\r\n" + 
				"	</head>\r\n" + 
				"	<body>\r\n" + 
				"		<p>\r\n" + 
				"			<center>\r\n" + 
				"				<img src=\"https://i.ibb.co/YdXbkqH/PlaceHub.png\" width=\"480\" height=\"270\" alt=\"Logo\">\r\n" + 
				"			</center>\r\n" + 
				"		</p>\r\n" + 
				"		<p>\r\n" + 
				"			<center><b>Grazie per aver usato i nostri servizi!</b></center>\r\n" +
				"			<h>\r\n</h>" +
				"			<center>Se non hai richesto tu di ricevere questa email controlla il tuo account!</center>\r\n" + 
				"		</p>\r\n" + 
				"		<p>\r\n" + 
				"			<center>Il tuo codice di verifica: " + codiceVerifica + "</center>\r\n" + 
				"		</p>\r\n" + 
				"	</body>\r\n" + 
				"</html>";
	}
	
	public String corpoEmailVerificaDocumenti(String codiceVerifica) {
		return "<!doctype html>\r\n" + 
				"<html>\r\n" + 
				"	<head>\r\n" + 
				"		<title>PlaceHub</title>\r\n" + 
				"	</head>\r\n" + 
				"	<body>\r\n" + 
				"		<p>\r\n" + 
				"			<center>\r\n" + 
				"				<img src=\"https://i.ibb.co/YdXbkqH/PlaceHub.png\" width=\"480\" height=\"270\" alt=\"Logo\">\r\n" + 
				"			</center>\r\n" + 
				"		</p>\r\n" + 
				"		<p>\r\n" + 
				"			<center><b>Grazie per aver usato i nostri servizi!</b></center>\r\n" +
				"			<h>\r\n</h>" +
				"			<h><center>Abbiamo ricevuto i tuoi documenti e ci riserviamo il diritto di sospendere il tuo account in caso di dichiarazione mendace.</center></h>" +
				"			<center>Se non hai richesto tu di ricevere questa email controlla il tuo account!</center>\r\n" + 
				"		</p>\r\n" + 
				"		<p>\r\n" + 
				"			<center>Il tuo codice di verifica: " + codiceVerifica + "</center>\r\n" + 
				"		</p>\r\n" + 
				"	</body>\r\n" + 
				"</html>";
	}
	
	public String corpoEmailBenvenutoRegistrazione(String username) {
		return "<!doctype html>\r\n" + 
				"<html>\r\n" + 
				"	<head>\r\n" + 
				"		<title>PlaceHub</title>\r\n" + 
				"	</head>\r\n" + 
				"	<body>\r\n" + 
				"		<p>\r\n" + 
				"			<center>\r\n" + 
				"				<img src=\"https://i.ibb.co/YdXbkqH/PlaceHub.png\" width=\"480\" height=\"270\" alt=\"Logo\">\r\n" + 
				"			</center>\r\n" + 
				"		</p>\r\n" + 
				"		<p>\r\n" + 
				"			<center><b>Grazie per averci scelti</b></center>\r\n" +
				"			<h>\r\n</h>" +
				"			<center>Il tuo account e' adesso attivo, da ora potrai vedere e recensire centinaia di posti sulla nosta APP!</center>\r\n" +
				"		</p>\r\n" + 
				"		<p>\r\n" + 
				"			<center>Non ci resta che augurarti una buona navigazione, <b>" + username + "!</b></center>\r\n" + 
				"		</p>\r\n" + 
				"	</body>\r\n" + 
				"</html>";
	}
}
