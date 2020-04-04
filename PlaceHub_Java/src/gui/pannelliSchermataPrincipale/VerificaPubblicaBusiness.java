package gui.pannelliSchermataPrincipale;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.JLabel;
import java.awt.Font;
import javax.swing.SwingConstants;
import javax.swing.border.LineBorder;

import gestione.Controller;

import javax.swing.ImageIcon;
import javax.swing.JButton;

import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.JTextField;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

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
	private JLabel testoErroreCodiceVerifica;
	private JLabel testoMessaggioMail;
	
	private JLabel testoDocumentoCaricatoFronte;
	private JLabel testoDocumentoCaricatoRetro;
	
	private Controller ctrl;
	
	public VerificaPubblicaBusiness(Controller Ctrl) {
		this.ctrl = Ctrl;
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		
		generaTestoTrascinaImmagini();
		generaCampoDocumentoFronte();
		generaCampoDocumentoRetro();
		generaCampoCodiceVerifica();
		generaBottoneInviaCodiceVerifica();
		generaBottoneAvanti();
		
		generaTestoErroreCodiceVerifica();
		generaTestoErroreInvioEmail();
		
		generaTestoDocumentoCaricatoFronte();
		generaTestoDocumentoCaricatoRetro();
	}

	private void generaTestoDocumentoCaricatoRetro() {
		testoDocumentoCaricatoRetro = new JLabel("Documento caricato");
		testoDocumentoCaricatoRetro.setHorizontalAlignment(SwingConstants.CENTER);
		testoDocumentoCaricatoRetro.setFont(new Font("Roboto", Font.PLAIN, 15));
		testoDocumentoCaricatoRetro.setForeground(new Color(54,128,0));
		testoDocumentoCaricatoRetro.setVisible(false);
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addComponent(testoTrascinaImmagini, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(162)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(37)
							.addComponent(immagineDocumentoFronte))
						.addComponent(testoDocumentoCaricatoFronte, GroupLayout.DEFAULT_SIZE, 198, Short.MAX_VALUE))
					.addGap(140)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(testoDocumentoCaricatoRetro, GroupLayout.DEFAULT_SIZE, 198, Short.MAX_VALUE)
						.addGroup(Alignment.TRAILING, groupLayout.createSequentialGroup()
							.addGap(40)
							.addComponent(immagineDocumentoRetro)
							.addGap(30)))
					.addGap(152))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(162)
					.addComponent(testoDocumentoFronte, GroupLayout.DEFAULT_SIZE, 198, Short.MAX_VALUE)
					.addGap(154)
					.addComponent(testoDocumentoRetro, GroupLayout.DEFAULT_SIZE, 186, Short.MAX_VALUE)
					.addGap(150))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(242)
					.addComponent(bottoneInviaCodiceVerifica, GroupLayout.PREFERRED_SIZE, 365, Short.MAX_VALUE)
					.addGap(243))
				.addComponent(testoMessaggioMail, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(342)
					.addComponent(testoCodiceVerifica, GroupLayout.DEFAULT_SIZE, 166, Short.MAX_VALUE)
					.addGap(342))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(342)
					.addComponent(textFieldCodiceVerifica, GroupLayout.DEFAULT_SIZE, 166, Short.MAX_VALUE)
					.addGap(342))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(342)
					.addComponent(lineaCodiceVerifica, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(342))
				.addComponent(testoErroreCodiceVerifica, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(355)
					.addComponent(bottoneAvanti, GroupLayout.PREFERRED_SIZE, 140, Short.MAX_VALUE)
					.addGap(355))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(12)
					.addComponent(testoTrascinaImmagini, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
					.addGap(28)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(20)
							.addComponent(immagineDocumentoFronte))
						.addComponent(testoDocumentoCaricatoFronte, GroupLayout.PREFERRED_SIZE, 25, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoDocumentoCaricatoRetro, GroupLayout.PREFERRED_SIZE, 25, GroupLayout.PREFERRED_SIZE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(20)
							.addComponent(immagineDocumentoRetro)))
					.addGap(13)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(testoDocumentoFronte, GroupLayout.PREFERRED_SIZE, 29, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoDocumentoRetro, GroupLayout.PREFERRED_SIZE, 29, GroupLayout.PREFERRED_SIZE))
					.addGap(40)
					.addComponent(bottoneInviaCodiceVerifica, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)
					.addGap(11)
					.addComponent(testoMessaggioMail, GroupLayout.PREFERRED_SIZE, 31, GroupLayout.PREFERRED_SIZE)
					.addGap(11)
					.addComponent(testoCodiceVerifica, GroupLayout.PREFERRED_SIZE, 25, GroupLayout.PREFERRED_SIZE)
					.addGap(12)
					.addComponent(textFieldCodiceVerifica, GroupLayout.PREFERRED_SIZE, 29, GroupLayout.PREFERRED_SIZE)
					.addGap(2)
					.addComponent(lineaCodiceVerifica)
					.addGap(18)
					.addComponent(testoErroreCodiceVerifica, GroupLayout.PREFERRED_SIZE, 18, GroupLayout.PREFERRED_SIZE)
					.addGap(12)
					.addComponent(bottoneAvanti, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE))
		);
		setLayout(groupLayout);
	}

	private void generaTestoDocumentoCaricatoFronte() {
		testoDocumentoCaricatoFronte = new JLabel("Documento caricato");
		testoDocumentoCaricatoFronte.setHorizontalAlignment(SwingConstants.CENTER);
		testoDocumentoCaricatoFronte.setFont(new Font("Roboto", Font.PLAIN, 15));
		testoDocumentoCaricatoFronte.setForeground(new Color(54,128,0));
		testoDocumentoCaricatoFronte.setVisible(false);
	}

	private void generaTestoErroreCodiceVerifica() {
		testoErroreCodiceVerifica = new JLabel("Codice non valido");
		testoErroreCodiceVerifica.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreCodiceVerifica.setForeground(Color.RED);
		testoErroreCodiceVerifica.setFont(new Font("Roboto", Font.PLAIN, 17));
		testoErroreCodiceVerifica.setVisible(false);
	}
	
	private void generaTestoErroreInvioEmail() {
		testoMessaggioMail = new JLabel("Feedback errore-conferma email");
		testoMessaggioMail.setHorizontalAlignment(SwingConstants.CENTER);
		testoMessaggioMail.setForeground(Color.RED);
		testoMessaggioMail.setFont(new Font("Roboto", Font.PLAIN, 17));
		testoMessaggioMail.setVisible(false);
	}

	private void generaCampoDocumentoRetro() {
		immagineDocumentoRetro = new JLabel("");
		immagineDocumentoRetro.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				if(immagineDocumentoRetro.isEnabled()) {
					resettaVisibilitaErrori();
					if (ctrl.caricaDocumentoRetroInBuffer()==null) {
						testoDocumentoCaricatoRetro.setVisible(false);
						bottoneInviaCodiceVerifica.setEnabled(false);
					}else {
						testoDocumentoCaricatoRetro.setVisible(true);
						abilitaBottoneInviaCodiceVerifica();
					}
				}
			}
		});
		immagineDocumentoRetro.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/immagineDocumento.png")));
		
		testoDocumentoRetro = new JLabel("Documento Retro");
		testoDocumentoRetro.setFont(new Font("Roboto", Font.PLAIN, 23));
	}

	private void generaCampoDocumentoFronte() {
		immagineDocumentoFronte = new JLabel("");
		immagineDocumentoFronte.setFont(new Font("Roboto", Font.PLAIN, 15));
		immagineDocumentoFronte.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
			   if(immagineDocumentoFronte.isEnabled()) {
				   resettaVisibilitaErrori();
				   if( ctrl.caricaDocumentoFronteInBuffer() == null ) {
					  testoDocumentoCaricatoFronte.setVisible(false);
					  bottoneInviaCodiceVerifica.setEnabled(false);
				   }else {
					   testoDocumentoCaricatoFronte.setVisible(true);
					   abilitaBottoneInviaCodiceVerifica();
				   }
			   }
			}
		});
		immagineDocumentoFronte.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/immagineDocumento.png")));
		
		testoDocumentoFronte = new JLabel("Documento Fronte");
		testoDocumentoFronte.setFont(new Font("Roboto", Font.PLAIN, 23));
	}

	private void generaTestoTrascinaImmagini() {
		testoTrascinaImmagini = new JLabel("Trascina sulle icone i documenti richiesti");
		testoTrascinaImmagini.setHorizontalAlignment(SwingConstants.CENTER);
		testoTrascinaImmagini.setFont(new Font("Roboto", Font.PLAIN, 24));
	}

	private void generaCampoCodiceVerifica() {
		testoCodiceVerifica = new JLabel("Codice Verifica");
		testoCodiceVerifica.setFont(new Font("Roboto", Font.PLAIN, 24));
		
		textFieldCodiceVerifica = new JTextField();
		textFieldCodiceVerifica.setHorizontalAlignment(SwingConstants.CENTER);
		textFieldCodiceVerifica.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldCodiceVerifica.setBackground(new Color(255,255,255));
		textFieldCodiceVerifica.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldCodiceVerifica.setColumns(10);
		
		lineaCodiceVerifica = new JLabel("");
		lineaCodiceVerifica.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/lineaCodiceVerifica.png")));
	}

	private void generaBottoneAvanti() {
		bottoneAvanti = new JButton("");
		bottoneAvanti.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				ctrl.controllaCodiceVerificaECaricaDocumentiVerificaPubblicaBusiness(textFieldCodiceVerifica.getText());
			}
		});
		bottoneAvanti.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/AvantiButton.png")));
		bottoneAvanti.setOpaque(false);
		bottoneAvanti.setContentAreaFilled(false);
		bottoneAvanti.setBorderPainted(false);
		bottoneAvanti.setEnabled(false);
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
	}

	private void generaBottoneInviaCodiceVerifica() {
		bottoneInviaCodiceVerifica = new JButton("");
		bottoneInviaCodiceVerifica.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/bottoneInviaCodiceVerifica.png")));
		bottoneInviaCodiceVerifica.setOpaque(false);
		bottoneInviaCodiceVerifica.setBorderPainted(false);
		bottoneInviaCodiceVerifica.setContentAreaFilled(false);
		bottoneInviaCodiceVerifica.setEnabled(false);
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
		bottoneInviaCodiceVerifica.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				ctrl.inviaCodiceVerificaVerificaPubblicaBusiness();
				bottoneAvanti.setEnabled(true);
			}
		});
	}
	
	
	//METODI
	
	private void abilitaBottoneInviaCodiceVerifica() {
		if(testoDocumentoCaricatoFronte.isVisible() && testoDocumentoCaricatoRetro.isVisible())
				bottoneInviaCodiceVerifica.setEnabled(true);
	}
	
	public void resettaVisibilitaErrori() {
		testoErroreCodiceVerifica.setVisible(false);
		testoMessaggioMail.setVisible(false);
	}
	
	
	public void mostraErroreCodiceVerifica() {
		testoErroreCodiceVerifica.setVisible(true);
	}
	
	public void mostraErroreEmail() {
		testoMessaggioMail.setText("Non e' stato possibile inviarti alcuna email. Riprova!");
		testoMessaggioMail.setForeground(Color.RED);
		testoMessaggioMail.setFont(new Font("Roboto", Font.PLAIN, 17));
		testoMessaggioMail.setVisible(true);
	}
	
	public void mostraEmailInviata() {
		testoMessaggioMail.setText("Email inviata con successo!");
		testoMessaggioMail.setForeground(new Color(64,151,0));
		testoMessaggioMail.setFont(new Font("Roboto", Font.PLAIN, 17));
		testoMessaggioMail.setVisible(true);
	}
	
	public void disabilitaCaricaDocumento() {
		immagineDocumentoFronte.setEnabled(false);
		immagineDocumentoRetro.setEnabled(false);
	}
}
