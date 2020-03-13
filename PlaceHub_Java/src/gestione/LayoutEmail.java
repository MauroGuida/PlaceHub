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
				"			<center>Se dovessi aver ricevuto questa mail per errore allora controlla il tuo account!</center>\r\n" + 
				"		</p>\r\n" + 
				"		<p>\r\n" + 
				"			<center>Il tuo codice di verifica: " + codiceVerifica + "</center>\r\n" + 
				"		</p>\r\n" + 
				"	</body>\r\n" + 
				"</html>";
	}
}
