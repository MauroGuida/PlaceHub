package gui.pannelliSchermataPrincipale;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.JLabel;
import java.awt.Font;
import javax.swing.SwingConstants;
import javax.swing.border.LineBorder;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.JTextField;

public class VerificaPubblicaBusiness extends JPanel {
	private static final long serialVersionUID = 1L;
	private JTextField textFieldCodiceVerifica;
	private JButton bottoneInviaCodiceVerifica;
	private JButton bottoneAvanti;
	private JLabel testoCodiceVerifica;
	private JLabel lineaCodiceVerifica;
	private JLabel testoTrascinaImmagini;
	private JLabel immagineDocumentoFronte;
	private JLabel immagineDocumentoRetro;
	private JLabel testoDocumentoFronte;
	private JLabel testoDocumentoRetro;
	private JLabel testoErroreInserisciDocumenti;
	private JLabel testoErroreCodiceVerifica;
	
	public VerificaPubblicaBusiness() {
		setLayout(null);
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		
		generaTestoTrascinaImmagini();
		generaCampoDocumentoFronte();
		generaCampoDocumentoRetro();
		generaCampoCodiceVerifica();
		generaBottoneInviaCodiceVerifica();
		generaBottoneAvanti();
		
		generaTestoErroreInserisciDocumenti();
		generaTestoErroreCodiceVerifica();
		

	}

	private void generaTestoErroreCodiceVerifica() {
		testoErroreCodiceVerifica = new JLabel("Codice non valido");
		testoErroreCodiceVerifica.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreCodiceVerifica.setForeground(Color.RED);
		testoErroreCodiceVerifica.setFont(new Font("Roboto", Font.PLAIN, 17));
		testoErroreCodiceVerifica.setBounds(0, 500, 850, 18);
		testoErroreCodiceVerifica.setVisible(false);
		add(testoErroreCodiceVerifica);
	}

	private void generaTestoErroreInserisciDocumenti() {
		testoErroreInserisciDocumenti = new JLabel("Inserisci i documenti richiesti");
		testoErroreInserisciDocumenti.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreInserisciDocumenti.setForeground(Color.RED);
		testoErroreInserisciDocumenti.setFont(new Font("Roboto", Font.PLAIN, 17));
		testoErroreInserisciDocumenti.setBounds(0, 280, 850, 18);
		testoErroreInserisciDocumenti.setVisible(false);
		add(testoErroreInserisciDocumenti);
	}

	private void generaCampoDocumentoRetro() {
		immagineDocumentoRetro = new JLabel("");
		immagineDocumentoRetro.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/immagineDocumento.png")));
		immagineDocumentoRetro.setBounds(540, 100, 128, 128);
		add(immagineDocumentoRetro);
		
		testoDocumentoRetro = new JLabel("Documento Retro");
		testoDocumentoRetro.setFont(new Font("Roboto", Font.PLAIN, 23));
		testoDocumentoRetro.setBounds(514, 241, 186, 29);
		add(testoDocumentoRetro);
	}

	private void generaCampoDocumentoFronte() {
		immagineDocumentoFronte = new JLabel("");
		immagineDocumentoFronte.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/immagineDocumento.png")));
		immagineDocumentoFronte.setBounds(199, 100, 128, 128);
		add(immagineDocumentoFronte);
		
		testoDocumentoFronte = new JLabel("Documento Fronte");
		testoDocumentoFronte.setFont(new Font("Roboto", Font.PLAIN, 23));
		testoDocumentoFronte.setBounds(162, 241, 198, 29);
		add(testoDocumentoFronte);
	}

	private void generaTestoTrascinaImmagini() {
		testoTrascinaImmagini = new JLabel("Trascina sulle icone i documenti richiesti");
		testoTrascinaImmagini.setHorizontalAlignment(SwingConstants.CENTER);
		testoTrascinaImmagini.setFont(new Font("Roboto", Font.PLAIN, 24));
		testoTrascinaImmagini.setBounds(0, 12, 850, 40);
		add(testoTrascinaImmagini);
	}

	private void generaCampoCodiceVerifica() {
		testoCodiceVerifica = new JLabel("Codice Verifica");
		testoCodiceVerifica.setFont(new Font("Roboto", Font.PLAIN, 24));
		testoCodiceVerifica.setBounds(342, 413, 166, 25);
		add(testoCodiceVerifica);
		
		textFieldCodiceVerifica = new JTextField();
		textFieldCodiceVerifica.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldCodiceVerifica.setBounds(342, 450, 166, 29);
		textFieldCodiceVerifica.setBackground(new Color(255,255,255));
		textFieldCodiceVerifica.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldCodiceVerifica.setColumns(10);
		add(textFieldCodiceVerifica);
		
		lineaCodiceVerifica = new JLabel("");
		lineaCodiceVerifica.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/lineaCodiceVerifica.png")));
		lineaCodiceVerifica.setBounds(342, 481, 166, 1);
		add(lineaCodiceVerifica);
	}

	private void generaBottoneAvanti() {
		bottoneAvanti = new JButton("");
		bottoneAvanti.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/AvantiButton.png")));
		bottoneAvanti.setBounds(355, 530, 140, 50);
		bottoneAvanti.setOpaque(false);
		bottoneAvanti.setContentAreaFilled(false);
		bottoneAvanti.setBorderPainted(false);
		bottoneAvanti.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneAvanti.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/AvantiButtonFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneAvanti.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/AvantiButton.png")));
			}
		});
		add(bottoneAvanti);
	}

	private void generaBottoneInviaCodiceVerifica() {
		bottoneInviaCodiceVerifica = new JButton("");
		bottoneInviaCodiceVerifica.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/bottoneInviaCodiceVerifica.png")));
		bottoneInviaCodiceVerifica.setBounds(242, 310, 365, 50);
		bottoneInviaCodiceVerifica.setOpaque(false);
		bottoneInviaCodiceVerifica.setBorderPainted(false);
		bottoneInviaCodiceVerifica.setContentAreaFilled(false);
		bottoneInviaCodiceVerifica.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneInviaCodiceVerifica.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/bottoneInviaCodiceVerificaFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneInviaCodiceVerifica.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/bottoneInviaCodiceVerifica.png")));
			}
		});
		add(bottoneInviaCodiceVerifica);
	}
}