package res;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class InvioEmail {
	public void inviaEmail(String Email, String Oggetto, String Corpo) {
		final String username = "placehub@gmx.com";
        final String password = "35GQUwr!";

        Properties props = new Properties();
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", "mail.gmx.com");
        props.put("mail.smtp.port", "25");

        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
          });

        try {

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("placehub@gmx.com"));
            message.setRecipients(Message.RecipientType.TO,
                InternetAddress.parse(Email));
            message.setSubject(Oggetto);
            message.setText(Corpo);

            Transport.send(message);

            System.out.println("Done");

        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
	}
}
