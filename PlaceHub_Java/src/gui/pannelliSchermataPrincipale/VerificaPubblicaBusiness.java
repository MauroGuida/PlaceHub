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
import java.awt.BorderLayout;
import net.miginfocom.swing.MigLayout;
import java.awt.Component;
import javax.swing.Box;

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
	private JPanel pannelloErroreCodiceNonValido;
	private Component verticalGlue;
	private Component verticalGlue_1;
	
	public VerificaPubblicaBusiness(Controller Ctrl) {
		this.ctrl = Ctrl;
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		
		JPanel pannelloInfo = new JPanel();
		pannelloInfo.setBackground(Color.WHITE);
		
		
		testoDocumentoFronte = new JLabel("Documento Fronte");
		testoDocumentoFronte.setHorizontalAlignment(SwingConstants.CENTER);
		testoDocumentoFronte.setFont(new Font("Roboto", Font.PLAIN, 23));
		immagineDocumentoFronte = new JLabel("");
		immagineDocumentoFronte.setHorizontalAlignment(SwingConstants.CENTER);
		immagineDocumentoFronte.setFont(new Font("Roboto", Font.PLAIN, 15));
		immagineDocumentoFronte.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/immagineDocumento.png")));
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
		
		
		
		testoDocumentoRetro = new JLabel("Documento Retro");
		testoDocumentoRetro.setHorizontalAlignment(SwingConstants.CENTER);
		testoDocumentoRetro.setFont(new Font("Roboto", Font.PLAIN, 23));
		immagineDocumentoRetro = new JLabel("");
		immagineDocumentoRetro.setHorizontalAlignment(SwingConstants.CENTER);
		immagineDocumentoRetro.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/immagineDocumento.png")));
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
		
		
		
		
		bottoneInviaCodiceVerifica = new JButton("");
		bottoneInviaCodiceVerifica.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/bottoneInviaCodiceVerifica.png")));
		bottoneInviaCodiceVerifica.setOpaque(false);
		bottoneInviaCodiceVerifica.setBorderPainted(false);
		bottoneInviaCodiceVerifica.setContentAreaFilled(false);
		bottoneInviaCodiceVerifica.setEnabled(false);
		
		
		
		testoCodiceVerifica = new JLabel("Codice Verifica");
		testoCodiceVerifica.setHorizontalAlignment(SwingConstants.CENTER);
		testoCodiceVerifica.setFont(new Font("Roboto", Font.PLAIN, 24));
		
		textFieldCodiceVerifica = new JTextField();
		textFieldCodiceVerifica.setHorizontalAlignment(SwingConstants.CENTER);
		textFieldCodiceVerifica.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldCodiceVerifica.setBackground(new Color(255,255,255));
		textFieldCodiceVerifica.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldCodiceVerifica.setColumns(10);
		
		lineaCodiceVerifica = new JLabel("");
		lineaCodiceVerifica.setHorizontalAlignment(SwingConstants.CENTER);
		lineaCodiceVerifica.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/lineaCodiceVerifica.png")));
		
		
		
		
		bottoneAvanti = new JButton("");
		bottoneAvanti.setIcon(new ImageIcon(VerificaPubblicaBusiness.class.getResource("/Icone/AvantiButton.png")));
		bottoneAvanti.setOpaque(false);
		bottoneAvanti.setContentAreaFilled(false);
		bottoneAvanti.setBorderPainted(false);
		bottoneAvanti.setEnabled(false);
		bottoneAvanti.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				ctrl.controllaCodiceVerificaECaricaDocumentiVerificaPubblicaBusiness(textFieldCodiceVerifica.getText());
			}
		});
		
		
		JPanel pannelloDocumentoFronteCaricato = new JPanel();
		pannelloDocumentoFronteCaricato.setBackground(Color.WHITE);
		testoDocumentoCaricatoFronte = new JLabel("Documento caricato");
		testoDocumentoCaricatoFronte.setHorizontalAlignment(SwingConstants.CENTER);
		testoDocumentoCaricatoFronte.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoDocumentoCaricatoFronte.setForeground(new Color(54,128,0));
		testoDocumentoCaricatoFronte.setVisible(false);
		pannelloDocumentoFronteCaricato.setLayout(new BorderLayout(0, 0));
		pannelloDocumentoFronteCaricato.add(testoDocumentoCaricatoFronte);
		
		
		JPanel pannelloDocumentoRetroCaricato = new JPanel();
		pannelloDocumentoRetroCaricato.setBackground(Color.WHITE);
		testoDocumentoCaricatoRetro = new JLabel("Documento caricato");
		testoDocumentoCaricatoRetro.setHorizontalAlignment(SwingConstants.CENTER);
		testoDocumentoCaricatoRetro.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoDocumentoCaricatoRetro.setForeground(new Color(54,128,0));
		testoDocumentoCaricatoRetro.setVisible(false);
		pannelloDocumentoRetroCaricato.setLayout(new BorderLayout(0, 0));
		pannelloDocumentoRetroCaricato.add(testoDocumentoCaricatoRetro);
		
		
		
		
		testoTrascinaImmagini = new JLabel("Trascina sulle icone i documenti richiesti");
		testoTrascinaImmagini.setHorizontalAlignment(SwingConstants.CENTER);
		testoTrascinaImmagini.setFont(new Font("Roboto", Font.PLAIN, 24));
		
		
		JPanel pannelloFeedback = new JPanel();
		pannelloFeedback.setBackground(Color.WHITE);
		testoMessaggioMail = new JLabel("Feedback errore-conferma email");
		testoMessaggioMail.setHorizontalAlignment(SwingConstants.CENTER);
		testoMessaggioMail.setForeground(Color.RED);
		testoMessaggioMail.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		pannelloErroreCodiceNonValido = new JPanel();
		pannelloErroreCodiceNonValido.setBackground(Color.WHITE);
		testoErroreCodiceVerifica = new JLabel("Codice non valido");
		testoErroreCodiceVerifica.setHorizontalAlignment(SwingConstants.CENTER);
		testoErroreCodiceVerifica.setForeground(Color.RED);
		testoErroreCodiceVerifica.setFont(new Font("Roboto", Font.PLAIN, 20));
		
		GroupLayout gl_pannelloInfo = new GroupLayout(pannelloInfo);
		gl_pannelloInfo.setHorizontalGroup(
			gl_pannelloInfo.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pannelloInfo.createSequentialGroup()
					.addGap(139)
					.addComponent(pannelloDocumentoFronteCaricato, GroupLayout.DEFAULT_SIZE, 258, Short.MAX_VALUE)
					.addGap(84)
					.addComponent(pannelloDocumentoRetroCaricato, GroupLayout.DEFAULT_SIZE, 258, Short.MAX_VALUE)
					.addGap(111))
				.addGroup(gl_pannelloInfo.createSequentialGroup()
					.addGap(199)
					.addComponent(immagineDocumentoFronte, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(213)
					.addComponent(immagineDocumentoRetro, GroupLayout.DEFAULT_SIZE, 128, Short.MAX_VALUE)
					.addGap(182))
				.addGroup(gl_pannelloInfo.createSequentialGroup()
					.addGap(162)
					.addComponent(testoDocumentoFronte, GroupLayout.DEFAULT_SIZE, 198, Short.MAX_VALUE)
					.addGap(154)
					.addComponent(testoDocumentoRetro, GroupLayout.DEFAULT_SIZE, 186, Short.MAX_VALUE)
					.addGap(150))
				.addGroup(gl_pannelloInfo.createSequentialGroup()
					.addGap(242)
					.addComponent(bottoneInviaCodiceVerifica, GroupLayout.PREFERRED_SIZE, 365, Short.MAX_VALUE)
					.addGap(243))
				.addComponent(pannelloFeedback, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
				.addGroup(gl_pannelloInfo.createSequentialGroup()
					.addGap(342)
					.addComponent(textFieldCodiceVerifica, GroupLayout.DEFAULT_SIZE, 166, Short.MAX_VALUE)
					.addGap(342))
				.addGroup(gl_pannelloInfo.createSequentialGroup()
					.addGap(342)
					.addComponent(lineaCodiceVerifica, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(342))
				.addComponent(pannelloErroreCodiceNonValido, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
				.addGroup(gl_pannelloInfo.createSequentialGroup()
					.addGap(355)
					.addComponent(bottoneAvanti, GroupLayout.PREFERRED_SIZE, 140, Short.MAX_VALUE)
					.addGap(355))
				.addComponent(testoCodiceVerifica, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
		);
		gl_pannelloInfo.setVerticalGroup(
			gl_pannelloInfo.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pannelloInfo.createSequentialGroup()
					.addGroup(gl_pannelloInfo.createParallelGroup(Alignment.LEADING)
						.addComponent(pannelloDocumentoFronteCaricato, GroupLayout.PREFERRED_SIZE, 39, GroupLayout.PREFERRED_SIZE)
						.addComponent(pannelloDocumentoRetroCaricato, GroupLayout.PREFERRED_SIZE, 39, GroupLayout.PREFERRED_SIZE))
					.addGap(1)
					.addGroup(gl_pannelloInfo.createParallelGroup(Alignment.LEADING)
						.addComponent(immagineDocumentoFronte)
						.addComponent(immagineDocumentoRetro))
					.addGap(2)
					.addGroup(gl_pannelloInfo.createParallelGroup(Alignment.LEADING)
						.addComponent(testoDocumentoFronte, GroupLayout.PREFERRED_SIZE, 29, GroupLayout.PREFERRED_SIZE)
						.addComponent(testoDocumentoRetro, GroupLayout.PREFERRED_SIZE, 29, GroupLayout.PREFERRED_SIZE))
					.addGap(31)
					.addComponent(bottoneInviaCodiceVerifica, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)
					.addGap(8)
					.addComponent(pannelloFeedback, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
					.addGap(22)
					.addComponent(testoCodiceVerifica, GroupLayout.PREFERRED_SIZE, 25, GroupLayout.PREFERRED_SIZE)
					.addGap(5)
					.addComponent(textFieldCodiceVerifica, GroupLayout.PREFERRED_SIZE, 29, GroupLayout.PREFERRED_SIZE)
					.addGap(3)
					.addComponent(lineaCodiceVerifica)
					.addGap(12)
					.addComponent(pannelloErroreCodiceNonValido, GroupLayout.PREFERRED_SIZE, 30, GroupLayout.PREFERRED_SIZE)
					.addGap(5)
					.addComponent(bottoneAvanti, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE))
		);
		pannelloInfo.setLayout(gl_pannelloInfo);
		
		
		
		pannelloFeedback.setLayout(new BorderLayout(0, 0));
		pannelloFeedback.add(testoMessaggioMail);
		pannelloErroreCodiceNonValido.setLayout(new BorderLayout(0, 0));
		pannelloErroreCodiceNonValido.add(testoErroreCodiceVerifica);
		
		
		setLayout(new MigLayout("", "[grow,fill]", "[grow][center][grow,center][grow]"));
		
		verticalGlue = Box.createVerticalGlue();
		add(verticalGlue, "cell 0 0, growy");
		
		add(testoTrascinaImmagini, "cell 0 1,alignx center,aligny bottom");
		add(pannelloInfo, "cell 0 2, align center");
		
		verticalGlue_1 = Box.createVerticalGlue();
		add(verticalGlue_1, "cell 0 3, growy");
		
		
		testoErroreCodiceVerifica.setVisible(false);
		testoMessaggioMail.setVisible(false);
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
		testoMessaggioMail.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoMessaggioMail.setVisible(true);
	}
	
	public void mostraEmailInviata() {
		testoMessaggioMail.setText("Email inviata con successo!");
		testoMessaggioMail.setForeground(new Color(64,151,0));
		testoMessaggioMail.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoMessaggioMail.setVisible(true);
	}
	
	public void disabilitaCaricaDocumento() {
		immagineDocumentoFronte.setEnabled(false);
		immagineDocumentoRetro.setEnabled(false);
	}
}
