package gui;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.border.LineBorder;

import gestione.Controller;
import res.DatePicker;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Font;

import javax.swing.JButton;

import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.awt.event.ActionEvent;
import javax.swing.ImageIcon;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.geom.RoundRectangle2D;
import java.util.Timer;
import java.util.TimerTask;

import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JPasswordField;
import javax.swing.SwingConstants;
import java.awt.event.KeyAdapter;

public class SchermataAccesso extends JFrame {
	private static final long serialVersionUID = 1L;
	
	private Controller ctrl;
	
	private JPanel pannelloInferiore;
	private JLabel immaginiSinistra;
	
	private JPanel pannelloBottoni;
	private JButton bottoneMinimizza;
	private JButton bottoneEsci;
	
	private JPanel pannelloLogin;
	private JButton bottoneAccediLogin;
	private JLabel testoPasswordDimenticataLogin;
	private JLabel testoReimpostaPasswordLogin;
	private JLabel testoCreaAccountLogin;
	private JLabel testoRegistratiLogin;
	private JLabel placehubLogoLogin;
	private JLabel testoUsernamePannelloLogin;
	private JTextField textFieldUsernameLogin;
	private JPasswordField passwordFieldPasswordLogin;
	private JLabel lineaUsernameLogin;
	private JLabel lineaPasswordLogin;
	
	private int coordinataX;
	private int coordinataY;
	
	private JPanel pannelloRegistrazione;
	private JButton bottoneRegistrazione;
	private JLabel testoHaiUnAccountRegistrazione;
	private JLabel testoAccediRegistrazione;
	private JLabel testoUsernamePannelloRegistrazione;
	private JTextField textFieldUsernameRegistrazione;
	private JLabel lineaUsernameRegistrazione;
	private JLabel testoNomeRegistrazione;
	private JTextField textFieldNomeRegistrazione;
	private JLabel lineaNomeRegistrazione;
	private JLabel testoCognomeRegistrazione;
	private JTextField textFieldCognomeRegistrazione;
	private JLabel lineaCognomeRegistrazione;
	private JLabel testoDataNascitaRegistrazione;
	private JTextField textFieldDataNascitaRegistrazione;
	private JLabel lineaDataNascitaRegistrazione;
	private JLabel testoEmailRegistrazione;
	private JTextField textFieldEmailRegistrazione;
	private JLabel lineaEmailRegistrazione;
	private JLabel testoPasswordRegistrazione;
	private JPasswordField passwordFieldRegistrazione;
	private JLabel lineaPasswordRegistrazione;
	
	private JPanel pannelloReimpostaPassword1;
	private JLabel testoEmailReimpostaPassword1;
	private JTextField textFieldEmailReimpostaPassword1;
	private JLabel lineaEmailReimpostaPassword1;
	private JButton bottoneInviaCodiceReimpostaPassword1;
	private JButton bottoneTornaIndietroReimpostaPassword1;
	private JLabel labelComunicazioneUtenteReimpostaPassword1;
	
	private JPanel pannelloReimpostaPassword2;
	private JButton bottoneConfermaReimpostaPassword2;
	private JButton bottoneTornaIndietroReimpostaPassword2;
	private JLabel testoCodiceVerificaReimpostaPassword2;
	private JTextField textFieldCodiceVerificaReimpostaPassword2;
	private JLabel lineaCodiceVerificaReimpostaPassword2;
	private JLabel testoNuovaPasswordReimpostaPassword2;
	private JPasswordField passwordFieldNuovaPasswordReimpostaPassword2;
	private JLabel lineaNuovaPasswordReimpostaPassword2;
	private JLabel testoConfermaNuovaPasswordReimpostaPassword2;
	private JPasswordField passwordFieldConfermaNuovaPasswordReimpostaPassword2;
	private JLabel lineaConfermaNuovaPasswordReimpostaPassword2;
	private JLabel labelComunicazioneUtenteReimpostaPassword2;
	private JLabel labelMessaggioErroreReimpostaPassword2;
	
	private JLabel errorePasswordUsernameLogin;
	private JLabel notificaErroreCampiVuotiOConfermaRegistrazione;
	private JLabel erroreUsernameNonDisponibileRegistrazione;
	private JLabel erroreEmailNonValidaOInUsoRegistrazione;
	private JLabel errorePasswordNonValidaRegistrazione;
	
	public SchermataAccesso(Controller Ctrl) {
		this.ctrl=Ctrl;
		
		layoutGeneraleFinestra();
		
		generaPannelloBackground();
		
		generaPannelloBottoni();
		
		generaPannelloLogin();
		
		generaPannelloRegistrazione();
		
		generaPannelloReimpostaPassword1();
		
		generaPannelloReimpostaPassword2();
	}
	
	private void layoutGeneraleFinestra() {
		setLocationRelativeTo(null);
		setUndecorated(true);
		setShape(new RoundRectangle2D.Double(15, 0, 1100, 650, 30, 30));
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		setSize(1100,650);
		
		gestioneRiposizionamentoFinestra();
	}
	
	private void gestioneRiposizionamentoFinestra() {
        addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                coordinataX = e.getX();
                coordinataY = e.getY();
                setCursor(new Cursor(Cursor.HAND_CURSOR));
            }
            @Override
			public void mouseReleased(MouseEvent e) {
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
        });
        addMouseMotionListener(new MouseAdapter() {
            @Override
            public void mouseDragged(MouseEvent e) {
                setLocation(e.getXOnScreen()- coordinataX,e.getYOnScreen()-coordinataY);
            }
        });
    }
	
	private void generaPannelloBackground() {
		pannelloInferiore = new JPanel();
		pannelloInferiore.setBackground(Color.GRAY);
		pannelloInferiore.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(pannelloInferiore);
		pannelloInferiore.setLayout(null);
		
		immaginiSinistra = new JLabel("");
		immaginiSinistra.setHorizontalAlignment(SwingConstants.CENTER);
		immaginiSinistra.setBounds(0, 0, 550, 650);
		pannelloInferiore.add(immaginiSinistra);
		
		gestioneRotazioneImmagini();
	}
	
	private void gestioneRotazioneImmagini() {
		Timer timer = new Timer();
		timer.scheduleAtFixedRate(new TimerTask() {
			private int i=1;
			  @Override
			  public void run() {
					immaginiSinistra.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/immagini/"+ i +".png")));
					if(i<3)
						i++;
					else
						i=1;
			  }
		}, 0, 5000);
	}

	private void generaPannelloReimpostaPassword2() {
		pannelloReimpostaPassword2 = new JPanel();
		pannelloReimpostaPassword2.setBackground(Color.WHITE);
		pannelloReimpostaPassword2.setBounds(550, 0, 550, 650);
		pannelloInferiore.add(pannelloReimpostaPassword2);
		pannelloReimpostaPassword2.setLayout(null);
		pannelloReimpostaPassword2.setVisible(false);
		
		labelComunicazioneUtenteReimpostaPassword2 = new JLabel("<html><center><p><b>Inserire il codice ricevuto via Email</b></p>"
				+ "<p>\n</p>"
				+ "<p><font size=\"4\"><i>Nel caso non si dovesse ricevere un'Email entro 10 minuti si prega di"
				+ "controllare l'indirizzo inserito e riprovare!</i></font></p></center></html>");
		labelComunicazioneUtenteReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 16));
		labelComunicazioneUtenteReimpostaPassword2.setBounds(80, 62, 383, 117);
		pannelloReimpostaPassword2.add(labelComunicazioneUtenteReimpostaPassword2);
		
		generaBottoneConfermaReimpostaPassword2();
		generaBottoneIndietroReimpostaPassword2();
		generaFieldCodiceVerificaReimpostaPassword2();
		generaFieldNuovaPasswordReimpostaPassword2();
		generaFieldConfermaNuovaPasswordReimpostaPassword2();
		generaLabelMessaggioErrore();
	}

	private void generaLabelMessaggioErrore() {
		labelMessaggioErroreReimpostaPassword2 = new JLabel("Le password non corrispondono!");
		labelMessaggioErroreReimpostaPassword2.setVisible(false);
		labelMessaggioErroreReimpostaPassword2.setHorizontalAlignment(SwingConstants.CENTER);
		labelMessaggioErroreReimpostaPassword2.setForeground(Color.RED);
		labelMessaggioErroreReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 16));
		labelMessaggioErroreReimpostaPassword2.setBounds(80, 442, 383, 32);
		pannelloReimpostaPassword2.add(labelMessaggioErroreReimpostaPassword2);
	}

	private void generaFieldConfermaNuovaPasswordReimpostaPassword2() {
		testoConfermaNuovaPasswordReimpostaPassword2 = new JLabel("");
		testoConfermaNuovaPasswordReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ConfermaNuovaPassword.png")));
		testoConfermaNuovaPasswordReimpostaPassword2.setBounds(80, 370, 250, 20);
		pannelloReimpostaPassword2.add(testoConfermaNuovaPasswordReimpostaPassword2);
		
		passwordFieldConfermaNuovaPasswordReimpostaPassword2 = new JPasswordField();
		passwordFieldConfermaNuovaPasswordReimpostaPassword2.setBounds(80, 398, 383, 32);
		passwordFieldConfermaNuovaPasswordReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 17));
		passwordFieldConfermaNuovaPasswordReimpostaPassword2.setBackground(new Color(255,255,255));
		passwordFieldConfermaNuovaPasswordReimpostaPassword2.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloReimpostaPassword2.add(passwordFieldConfermaNuovaPasswordReimpostaPassword2);
		
		lineaConfermaNuovaPasswordReimpostaPassword2 = new JLabel("");
		lineaConfermaNuovaPasswordReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaConfermaNuovaPasswordReimpostaPassword2.setBounds(80, 430, 383, 1);
		pannelloReimpostaPassword2.add(lineaConfermaNuovaPasswordReimpostaPassword2);
	}

	private void generaFieldNuovaPasswordReimpostaPassword2() {
		testoNuovaPasswordReimpostaPassword2 = new JLabel("");
		testoNuovaPasswordReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Nuova Password.png")));
		testoNuovaPasswordReimpostaPassword2.setBounds(80, 280, 185, 20);
		pannelloReimpostaPassword2.add(testoNuovaPasswordReimpostaPassword2);
		
		passwordFieldNuovaPasswordReimpostaPassword2 = new JPasswordField();
		passwordFieldNuovaPasswordReimpostaPassword2.setBounds(80, 308, 383, 32);
		passwordFieldNuovaPasswordReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 17));
		passwordFieldNuovaPasswordReimpostaPassword2.setBackground(new Color(255,255,255));
		passwordFieldNuovaPasswordReimpostaPassword2.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloReimpostaPassword2.add(passwordFieldNuovaPasswordReimpostaPassword2);
		
		lineaNuovaPasswordReimpostaPassword2 = new JLabel("");
		lineaNuovaPasswordReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaNuovaPasswordReimpostaPassword2.setBounds(80, 340, 383, 1);
		pannelloReimpostaPassword2.add(lineaNuovaPasswordReimpostaPassword2);
	}

	private void generaFieldCodiceVerificaReimpostaPassword2() {
		testoCodiceVerificaReimpostaPassword2 = new JLabel("");
		testoCodiceVerificaReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/CodiceVerifica.png")));
		testoCodiceVerificaReimpostaPassword2.setBounds(80, 190, 140, 20);
		pannelloReimpostaPassword2.add(testoCodiceVerificaReimpostaPassword2);
		
		textFieldCodiceVerificaReimpostaPassword2 = new JTextField();
		textFieldCodiceVerificaReimpostaPassword2.setBounds(80, 218, 383, 32);
		textFieldCodiceVerificaReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldCodiceVerificaReimpostaPassword2.setBackground(new Color(255,255,255));
		textFieldCodiceVerificaReimpostaPassword2.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloReimpostaPassword2.add(textFieldCodiceVerificaReimpostaPassword2);
		textFieldCodiceVerificaReimpostaPassword2.setColumns(10);
		
		lineaCodiceVerificaReimpostaPassword2 = new JLabel("");
		lineaCodiceVerificaReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaCodiceVerificaReimpostaPassword2.setBounds(80, 250, 383, 1);
		pannelloReimpostaPassword2.add(lineaCodiceVerificaReimpostaPassword2);
	}
	
	public void generaPannelloReimpostaPassword1() {
		pannelloReimpostaPassword1 = new JPanel();
		pannelloReimpostaPassword1.setBackground(Color.WHITE);
		pannelloReimpostaPassword1.setBounds(550, 0, 550, 650);
		pannelloInferiore.add(pannelloReimpostaPassword1);
		pannelloReimpostaPassword1.setLayout(null);
		pannelloReimpostaPassword1.setVisible(false);
		
		generaFieldEmailReimpostaPassword1();
		generaBottoneInviaCodiceReimpostaPassword1();
		generaBottoneIndietroReimpostaPassword1();
		generaLabelComunicazioneUtenteReimpostaPassword1();
	}

	public void generaLabelComunicazioneUtenteReimpostaPassword1() {
		labelComunicazioneUtenteReimpostaPassword1 = new JLabel("<html><p>Si prega di inserire l'indirizzo Email di registrazione per consentirci di verificare l'account.</p>"
				+ "\n"
				+ "<p><center><b>Riceverai via email un codice di verifica entro 10 minuti.</b></center></p></html>");
		labelComunicazioneUtenteReimpostaPassword1.setVerticalAlignment(SwingConstants.TOP);
		labelComunicazioneUtenteReimpostaPassword1.setFont(new Font("Roboto", Font.PLAIN, 16));
		labelComunicazioneUtenteReimpostaPassword1.setBounds(80, 100, 383, 114);
		pannelloReimpostaPassword1.add(labelComunicazioneUtenteReimpostaPassword1);
	}
	
	private void generaBottoneIndietroReimpostaPassword1() {
		bottoneTornaIndietroReimpostaPassword1 = new JButton("");
		bottoneTornaIndietroReimpostaPassword1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				pannelloLogin.setVisible(true);
				pannelloReimpostaPassword1.setVisible(false);
			}
		});
		bottoneTornaIndietroReimpostaPassword1.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/arrow.png")));
		bottoneTornaIndietroReimpostaPassword1.setBounds(12, 595, 43, 43);
		bottoneTornaIndietroReimpostaPassword1.setOpaque(false);
		bottoneTornaIndietroReimpostaPassword1.setContentAreaFilled(false);
		bottoneTornaIndietroReimpostaPassword1.setBorderPainted(false);
		pannelloReimpostaPassword1.add(bottoneTornaIndietroReimpostaPassword1);
	}

	public void generaBottoneInviaCodiceReimpostaPassword1() {
		bottoneInviaCodiceReimpostaPassword1 = new JButton("");
		bottoneInviaCodiceReimpostaPassword1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				pannelloReimpostaPassword1.setVisible(false);
				pannelloReimpostaPassword2.setVisible(true);
				
				invioCodiceReimpostaPassword(textFieldEmailReimpostaPassword1.getText());
			}
		});
		bottoneInviaCodiceReimpostaPassword1.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneInviaCodiceReimpostaPassword1.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneInviaCodiceFocus.png")));
				setCursor(new Cursor(Cursor.HAND_CURSOR));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneInviaCodiceReimpostaPassword1.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneInviaCodice.png")));
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
		});
		
		bottoneInviaCodiceReimpostaPassword1.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneInviaCodice.png")));
		bottoneInviaCodiceReimpostaPassword1.setBounds(132, 420, 280, 48);
		bottoneInviaCodiceReimpostaPassword1.setOpaque(false);
		bottoneInviaCodiceReimpostaPassword1.setBorderPainted(false);
		bottoneInviaCodiceReimpostaPassword1.setContentAreaFilled(false);
		pannelloReimpostaPassword1.add(bottoneInviaCodiceReimpostaPassword1);
	}

	private void generaFieldEmailReimpostaPassword1() {
		testoEmailReimpostaPassword1 = new JLabel("");
		testoEmailReimpostaPassword1.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoEmail.png")));
		testoEmailReimpostaPassword1.setBounds(80, 262, 140, 20);
		pannelloReimpostaPassword1.add(testoEmailReimpostaPassword1);
		
		textFieldEmailReimpostaPassword1 = new JTextField();
		textFieldEmailReimpostaPassword1.setBounds(80, 290, 383, 32);
		textFieldEmailReimpostaPassword1.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldEmailReimpostaPassword1.setBackground(new Color(255,255,255));
		textFieldEmailReimpostaPassword1.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloReimpostaPassword1.add(textFieldEmailReimpostaPassword1);
		textFieldEmailReimpostaPassword1.setColumns(10);
		
		lineaEmailReimpostaPassword1 = new JLabel("");
		lineaEmailReimpostaPassword1.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaEmailReimpostaPassword1.setBounds(80, 322, 383, 1);
		pannelloReimpostaPassword1.add(lineaEmailReimpostaPassword1);
	}

	private void generaBottoneIndietroReimpostaPassword2() {
		bottoneTornaIndietroReimpostaPassword2 = new JButton("");
		bottoneTornaIndietroReimpostaPassword2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				pannelloLogin.setVisible(true);
				pannelloReimpostaPassword2.setVisible(false);
			}
		});
		bottoneTornaIndietroReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/arrow.png")));
		bottoneTornaIndietroReimpostaPassword2.setBounds(12, 595, 43, 43);
		bottoneTornaIndietroReimpostaPassword2.setOpaque(false);
		bottoneTornaIndietroReimpostaPassword2.setContentAreaFilled(false);
		bottoneTornaIndietroReimpostaPassword2.setBorderPainted(false);
		pannelloReimpostaPassword2.add(bottoneTornaIndietroReimpostaPassword2);
	}

	private void generaBottoneConfermaReimpostaPassword2() {
		bottoneConfermaReimpostaPassword2 = new JButton("");
		bottoneConfermaReimpostaPassword2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				confermaNuovaPasswordReimpostaPassword();
			}
		});
		bottoneConfermaReimpostaPassword2.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneConfermaReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneConfermaFocus.png")));
				setCursor(new Cursor(Cursor.HAND_CURSOR));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneConfermaReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneConferma.png")));
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
		});
		
		bottoneConfermaReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneConferma.png")));
		bottoneConfermaReimpostaPassword2.setBounds(132, 506, 280, 48);
		bottoneConfermaReimpostaPassword2.setOpaque(false);
		bottoneConfermaReimpostaPassword2.setBorderPainted(false);
		bottoneConfermaReimpostaPassword2.setContentAreaFilled(false);
		pannelloReimpostaPassword2.add(bottoneConfermaReimpostaPassword2);
	}

	private void generaPannelloLogin() {
		pannelloLogin = new JPanel();
		pannelloLogin.setBackground(Color.WHITE);
		pannelloLogin.setBounds(550, 0, 550, 650);
		pannelloInferiore.add(pannelloLogin);
		pannelloLogin.setLayout(null);
		
		//Piazza il logo
		placehubLogoLogin = new JLabel("");
		placehubLogoLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/placehubLogo.png")));
		placehubLogoLogin.setBounds(177, 50, 197, 152);
		pannelloLogin.add(placehubLogoLogin);
		
		generaBottoneAccediLogin();
		gerenaTestoPasswordDimenticataLogin();
		generaTestoRegistratiLogin();
		generaFieldUsernameLogin();
		generaFieldPasswordLogin();
		generaTestoErroreUsernameOPasswordLogin();
	}

	private void generaTestoErroreUsernameOPasswordLogin() {
		errorePasswordUsernameLogin = new JLabel("Username o Password errati!");
		errorePasswordUsernameLogin.setHorizontalAlignment(SwingConstants.CENTER);
		errorePasswordUsernameLogin.setForeground(Color.RED);
		errorePasswordUsernameLogin.setFont(new Font("Roboto", Font.PLAIN, 16));
		errorePasswordUsernameLogin.setBounds(80, 410, 383, 26);
		errorePasswordUsernameLogin.setVisible(false);
		pannelloLogin.add(errorePasswordUsernameLogin);
	}

	private void generaFieldPasswordLogin() {
		JLabel testoPasswordLogin = new JLabel("");
		testoPasswordLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Password.png")));
		testoPasswordLogin.setBounds(80, 325, 111, 16);
		pannelloLogin.add(testoPasswordLogin);
		
		passwordFieldPasswordLogin = new JPasswordField();
		passwordFieldPasswordLogin.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if(e.getKeyCode() == KeyEvent.VK_ENTER) {
				      eseguiLogin();
				   }
			}
		});
		passwordFieldPasswordLogin.setBounds(80, 353, 383, 32);
		passwordFieldPasswordLogin.setBackground(new Color(255,255,255));
		passwordFieldPasswordLogin.setBorder(new LineBorder(new Color(255,255,255),1));
		passwordFieldPasswordLogin.setFont(new Font("Roboto", Font.PLAIN, 17));
		pannelloLogin.add(passwordFieldPasswordLogin);
		
		lineaPasswordLogin = new JLabel("");
		lineaPasswordLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaPasswordLogin.setBounds(80, 386, 383, 1);
		pannelloLogin.add(lineaPasswordLogin);
		
	}

	private void generaFieldUsernameLogin() {
		testoUsernamePannelloLogin = new JLabel("");
		testoUsernamePannelloLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Username.png")));
		testoUsernamePannelloLogin.setBounds(80, 219, 111, 16);
		pannelloLogin.add(testoUsernamePannelloLogin);
		
		textFieldUsernameLogin = new JTextField();
		textFieldUsernameLogin.setBounds(80, 247, 383, 32);
		textFieldUsernameLogin.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldUsernameLogin.setBackground(new Color(255,255,255));
		textFieldUsernameLogin.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloLogin.add(textFieldUsernameLogin);
		textFieldUsernameLogin.setColumns(10);
		
		lineaUsernameLogin = new JLabel("");
		lineaUsernameLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaUsernameLogin.setBounds(80, 280, 383, 1);
		pannelloLogin.add(lineaUsernameLogin);
	}

	private void generaTestoRegistratiLogin() {
		testoRegistratiLogin = new JLabel("");
		testoRegistratiLogin.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				testoRegistratiLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/RegistratiFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				testoRegistratiLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Registrati.png")));
			}
			@Override
			public void mousePressed(MouseEvent e) {
				pannelloLogin.setVisible(false);
				pannelloRegistrazione.setVisible(true);
			}
		});
		testoRegistratiLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Registrati.png")));
		testoRegistratiLogin.setBounds(310, 542, 83, 26);
		pannelloLogin.add(testoRegistratiLogin);
		
		testoCreaAccountLogin = new JLabel("");
		testoCreaAccountLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/creaAccount.png")));
		testoCreaAccountLogin.setBounds(119, 540, 185, 26);
		pannelloLogin.add(testoCreaAccountLogin);
	}

	private void gerenaTestoPasswordDimenticataLogin() {
		testoPasswordDimenticataLogin = new JLabel("");
		testoPasswordDimenticataLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/haiDimenticatolaPassword.png")));
		testoPasswordDimenticataLogin.setBounds(39, 578, 265, 26);
		pannelloLogin.add(testoPasswordDimenticataLogin);
		
		testoReimpostaPasswordLogin = new JLabel("");
		testoReimpostaPasswordLogin.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				testoReimpostaPasswordLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ReimpostaPasswordFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				testoReimpostaPasswordLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ReimpostaPassword.png")));
			}
			@Override
			public void mouseClicked(MouseEvent e) {
				pannelloLogin.setVisible(false);
				pannelloReimpostaPassword1.setVisible(true);
			}
		});
		testoReimpostaPasswordLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ReimpostaPassword.png")));
		testoReimpostaPasswordLogin.setBounds(310, 578, 189, 26);
		pannelloLogin.add(testoReimpostaPasswordLogin);
	}

	private void generaBottoneAccediLogin() {
		bottoneAccediLogin = new JButton("");
		bottoneAccediLogin.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				eseguiLogin();
			}
		});
		bottoneAccediLogin.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneAccediLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/AccediFocus.png")));
				setCursor(new Cursor(Cursor.HAND_CURSOR));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneAccediLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Accedi.png")));
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
		});
		bottoneAccediLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Accedi.png")));
		bottoneAccediLogin.setOpaque(false);
		bottoneAccediLogin.setBorderPainted(false);
		bottoneAccediLogin.setContentAreaFilled(false);
		bottoneAccediLogin.setBounds(140, 470, 280, 48);
		pannelloLogin.add(bottoneAccediLogin);
	}

	private void generaPannelloBottoni() {
		pannelloBottoni = new JPanel();
		pannelloBottoni.setBounds(550, 0, 550, 36);
		pannelloInferiore.add(pannelloBottoni);
		pannelloBottoni.setBackground(Color.WHITE);
		pannelloBottoni.setLayout(null);
		
		bottoneEsci = new JButton("");
		bottoneEsci.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				System.exit(0);
			}
		});
		bottoneEsci.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/X.png")));
		bottoneEsci.setBounds(520, 8, 22, 22);
		bottoneEsci.setBorderPainted(false);
		bottoneEsci.setContentAreaFilled(false);
		bottoneEsci.setOpaque(false);
		pannelloBottoni.add(bottoneEsci);
		
		bottoneMinimizza = new JButton("");
		bottoneMinimizza.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				setState(ICONIFIED);
			}
		});
		bottoneMinimizza.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/minimizza.png")));
		bottoneMinimizza.setBounds(475, 5, 24, 25);
		bottoneMinimizza.setOpaque(false);
		bottoneMinimizza.setContentAreaFilled(false);
		bottoneMinimizza.setBorderPainted(false);
		pannelloBottoni.add(bottoneMinimizza);
		
		
	}

	private void generaPannelloRegistrazione() {
		pannelloRegistrazione = new JPanel();
		pannelloRegistrazione.setBackground(Color.WHITE);
		pannelloRegistrazione.setBounds(550, 0, 550, 650);
		pannelloInferiore.add(pannelloRegistrazione);
		pannelloRegistrazione.setLayout(null);
		pannelloRegistrazione.setVisible(false);
		
		bottoneRegistrazione = new JButton("");
		bottoneRegistrazione.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneRegistratiFocus.png")));
				setCursor(new Cursor(Cursor.HAND_CURSOR));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneRegistrati.png")));
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
			@Override
			public void mousePressed(MouseEvent e) {
				eseguiRegistrazione();
			}
		});
		bottoneRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneRegistrati.png")));
		bottoneRegistrazione.setBounds(132, 500, 280, 48);
		bottoneRegistrazione.setOpaque(false);
		bottoneRegistrazione.setContentAreaFilled(false);
		bottoneRegistrazione.setBorderPainted(false);
		pannelloRegistrazione.add(bottoneRegistrazione);
		
		generaTestoHaiGiaUnAccountRegistrazione();
		generaFieldUsernameRegistrazione();
		generaFieldNomeRegistrazione();
		generaFieldCognomeRegistrazione();
		generaFiledDataNascitaRegistrazione();
		generaFieldEmailRegistrazione();
		generaFieldPasswordRegistrazione();
		generaTestoErroriRegistrazione();
	}

	private void generaFieldPasswordRegistrazione() {
		testoPasswordRegistrazione = new JLabel("");
		testoPasswordRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Password.png")));
		testoPasswordRegistrazione.setBounds(80, 400, 111, 20);
		pannelloRegistrazione.add(testoPasswordRegistrazione);
		
		passwordFieldRegistrazione = new JPasswordField();
		passwordFieldRegistrazione.setBounds(80, 422, 383, 32);
		passwordFieldRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		passwordFieldRegistrazione.setBackground(new Color(255,255,255));
		passwordFieldRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloRegistrazione.add(passwordFieldRegistrazione);
		
		lineaPasswordRegistrazione = new JLabel("");
		lineaPasswordRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaPasswordRegistrazione.setBounds(80, 454, 383, 1);
		pannelloRegistrazione.add(lineaPasswordRegistrazione);
	}

	private void generaTestoErroriRegistrazione() {
		erroreUsernameNonDisponibileRegistrazione = new JLabel("Username non disponibile");
		erroreUsernameNonDisponibileRegistrazione.setHorizontalAlignment(SwingConstants.RIGHT);
		erroreUsernameNonDisponibileRegistrazione.setForeground(Color.RED);
		erroreUsernameNonDisponibileRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 16));
		erroreUsernameNonDisponibileRegistrazione.setBounds(201, 41, 262, 20);
		erroreUsernameNonDisponibileRegistrazione.setVisible(false);
		pannelloRegistrazione.add(erroreUsernameNonDisponibileRegistrazione);
		
		notificaErroreCampiVuotiOConfermaRegistrazione = new JLabel("Errore/Conferma");
		notificaErroreCampiVuotiOConfermaRegistrazione.setHorizontalAlignment(SwingConstants.CENTER);
		notificaErroreCampiVuotiOConfermaRegistrazione.setForeground(Color.RED);
		notificaErroreCampiVuotiOConfermaRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 16));
		notificaErroreCampiVuotiOConfermaRegistrazione.setBounds(80, 469, 383, 20);
		notificaErroreCampiVuotiOConfermaRegistrazione.setVisible(false);
		pannelloRegistrazione.add(notificaErroreCampiVuotiOConfermaRegistrazione);
		
		erroreEmailNonValidaOInUsoRegistrazione = new JLabel("Email non valida");
		erroreEmailNonValidaOInUsoRegistrazione.setHorizontalAlignment(SwingConstants.RIGHT);
		erroreEmailNonValidaOInUsoRegistrazione.setForeground(Color.RED);
		erroreEmailNonValidaOInUsoRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 16));
		erroreEmailNonValidaOInUsoRegistrazione.setBounds(155, 329, 308, 20);
		erroreEmailNonValidaOInUsoRegistrazione.setVisible(false);
		pannelloRegistrazione.add(erroreEmailNonValidaOInUsoRegistrazione);
		
		errorePasswordNonValidaRegistrazione = new JLabel("Password non valida");
		errorePasswordNonValidaRegistrazione.setHorizontalAlignment(SwingConstants.RIGHT);
		errorePasswordNonValidaRegistrazione.setForeground(Color.RED);
		errorePasswordNonValidaRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 16));
		errorePasswordNonValidaRegistrazione.setBounds(228, 400, 235, 20);
		errorePasswordNonValidaRegistrazione.setVisible(false);
		pannelloRegistrazione.add(errorePasswordNonValidaRegistrazione);
	}

	private void generaFieldEmailRegistrazione() {
		testoEmailRegistrazione = new JLabel("");
		testoEmailRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoEmail.png")));
		testoEmailRegistrazione.setBounds(80, 329, 111, 20);
		pannelloRegistrazione.add(testoEmailRegistrazione);
		
		textFieldEmailRegistrazione = new JTextField();
		textFieldEmailRegistrazione.setBounds(80, 351, 383, 32);
		textFieldEmailRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldEmailRegistrazione.setBackground(new Color(255,255,255));
		textFieldEmailRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloRegistrazione.add(textFieldEmailRegistrazione);
		textFieldEmailRegistrazione.setColumns(10);
		
		lineaEmailRegistrazione = new JLabel("");
		lineaEmailRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaEmailRegistrazione.setBounds(80, 383, 383, 1);
		pannelloRegistrazione.add(lineaEmailRegistrazione);
	}

	private void generaFiledDataNascitaRegistrazione() {
		testoDataNascitaRegistrazione = new JLabel("");
		testoDataNascitaRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoDataNascita.png")));
		testoDataNascitaRegistrazione.setBounds(80, 254, 140, 20);
		pannelloRegistrazione.add(testoDataNascitaRegistrazione);
		
		textFieldDataNascitaRegistrazione = new JTextField();
		textFieldDataNascitaRegistrazione.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				textFieldDataNascitaRegistrazione.setText(new DatePicker(SchermataAccesso.this).setPickedDate());
			}
		});
		textFieldDataNascitaRegistrazione.setBounds(80, 280, 383, 32);
		textFieldDataNascitaRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldDataNascitaRegistrazione.setBackground(new Color(255,255,255));
		textFieldDataNascitaRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloRegistrazione.add(textFieldDataNascitaRegistrazione);
		textFieldDataNascitaRegistrazione.setColumns(10);
		textFieldDataNascitaRegistrazione.setEditable(false);
		
		lineaDataNascitaRegistrazione = new JLabel("");
		lineaDataNascitaRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaDataNascitaRegistrazione.setBounds(80, 312, 383, 1);
		pannelloRegistrazione.add(lineaDataNascitaRegistrazione);
	}

	private void generaFieldCognomeRegistrazione() {
		testoCognomeRegistrazione = new JLabel("");
		testoCognomeRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoCognome.png")));
		testoCognomeRegistrazione.setBounds(80, 183, 111, 20);
		pannelloRegistrazione.add(testoCognomeRegistrazione);
		
		textFieldCognomeRegistrazione = new JTextField();
		textFieldCognomeRegistrazione.setBounds(80, 205, 383, 32);
		textFieldCognomeRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldCognomeRegistrazione.setBackground(new Color(255,255,255));
		textFieldCognomeRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloRegistrazione.add(textFieldCognomeRegistrazione);
		textFieldCognomeRegistrazione.setColumns(10);
		
		lineaCognomeRegistrazione = new JLabel("");
		lineaCognomeRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaCognomeRegistrazione.setBounds(80, 237, 383, 1);
		pannelloRegistrazione.add(lineaCognomeRegistrazione);
	}

	private void generaFieldNomeRegistrazione() {
		testoNomeRegistrazione = new JLabel("");
		testoNomeRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoNome.png")));
		testoNomeRegistrazione.setBounds(80, 112, 111, 20);
		pannelloRegistrazione.add(testoNomeRegistrazione);
		
		textFieldNomeRegistrazione = new JTextField();
		textFieldNomeRegistrazione.setBounds(80, 134, 383, 32);
		textFieldNomeRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldNomeRegistrazione.setBackground(new Color(255,255,255));
		textFieldNomeRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloRegistrazione.add(textFieldNomeRegistrazione);
		textFieldNomeRegistrazione.setColumns(10);
		
		lineaNomeRegistrazione = new JLabel("");
		lineaNomeRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaNomeRegistrazione.setBounds(80, 166, 383, 1);
		pannelloRegistrazione.add(lineaNomeRegistrazione);
	}

	private void generaFieldUsernameRegistrazione() {
		testoUsernamePannelloRegistrazione = new JLabel("");
		testoUsernamePannelloRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Username.png")));
		testoUsernamePannelloRegistrazione.setBounds(80, 41, 111, 20);
		pannelloRegistrazione.add(testoUsernamePannelloRegistrazione);
		
		textFieldUsernameRegistrazione = new JTextField();
		textFieldUsernameRegistrazione.setBounds(80, 63, 383, 32);
		textFieldUsernameRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldUsernameRegistrazione.setBackground(new Color(255,255,255));
		textFieldUsernameRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloRegistrazione.add(textFieldUsernameRegistrazione);
		textFieldUsernameRegistrazione.setColumns(10);
		
		lineaUsernameRegistrazione = new JLabel("");
		lineaUsernameRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaUsernameRegistrazione.setBounds(80, 95, 383, 1);
		pannelloRegistrazione.add(lineaUsernameRegistrazione);
	}

	private void generaTestoHaiGiaUnAccountRegistrazione() {
		testoHaiUnAccountRegistrazione = new JLabel("");
		testoHaiUnAccountRegistrazione.setHorizontalAlignment(SwingConstants.RIGHT);
		testoHaiUnAccountRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/haiGiaUnAccount.png")));
		testoHaiUnAccountRegistrazione.setBounds(132, 565, 200, 24);
		pannelloRegistrazione.add(testoHaiUnAccountRegistrazione);
		
		testoAccediRegistrazione = new JLabel("");
		testoAccediRegistrazione.setHorizontalAlignment(SwingConstants.LEFT);
		testoAccediRegistrazione.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				testoAccediRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoAccediFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				testoAccediRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoAccedi.png")));
			}
			@Override
			public void mousePressed(MouseEvent e) {
				pannelloLogin.setVisible(true);
				pannelloRegistrazione.setVisible(false);
				resettaErroriRegistrazione();
			}
		});
		testoAccediRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoAccedi.png")));
		testoAccediRegistrazione.setBounds(342, 563, 70, 24);
		pannelloRegistrazione.add(testoAccediRegistrazione);
	}
	
	
	
	//Metodi
	
	
	
	private void eseguiLogin() {
		ctrl.loginSchermataAccesso(textFieldUsernameLogin.getText(), passwordFieldPasswordLogin.getPassword());
	}

	private void eseguiRegistrazione() {
		ctrl.registratiSchermataAccesso(textFieldUsernameRegistrazione.getText(), textFieldNomeRegistrazione.getText(),
				textFieldCognomeRegistrazione.getText(), textFieldEmailRegistrazione.getText(), textFieldDataNascitaRegistrazione.getText(), passwordFieldRegistrazione.getPassword());
	}

	public void mostraErroreNonPossonoEsserciCampiVuotiRegistrazione() {
		notificaErroreCampiVuotiOConfermaRegistrazione.setForeground(Color.RED);
		notificaErroreCampiVuotiOConfermaRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 16));
		notificaErroreCampiVuotiOConfermaRegistrazione.setText("Non possono esserci campi vuoti!");
		
		notificaErroreCampiVuotiOConfermaRegistrazione.setVisible(true);
	}
	
	public void mostraConfermaRegistrazione() {
		notificaErroreCampiVuotiOConfermaRegistrazione.setForeground(new Color(64,151,0));
		notificaErroreCampiVuotiOConfermaRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 16));
		notificaErroreCampiVuotiOConfermaRegistrazione.setText("Registrazione effettuata con successo!");
		
		notificaErroreCampiVuotiOConfermaRegistrazione.setVisible(true);
	}

	public void mostraErrorePasswordNonValidaRegistrazione() {
		notificaErroreCampiVuotiOConfermaRegistrazione.setForeground(Color.RED);
		notificaErroreCampiVuotiOConfermaRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 16));
		notificaErroreCampiVuotiOConfermaRegistrazione.setText("La password deve essere di almeno 6 caratteri");
		
		notificaErroreCampiVuotiOConfermaRegistrazione.setVisible(true);
		errorePasswordNonValidaRegistrazione.setVisible(true);
	}

	public void mostraErroreEmailNonValidaRegistrazione() {
		erroreEmailNonValidaOInUsoRegistrazione.setText("Email non valida");
		erroreEmailNonValidaOInUsoRegistrazione.setVisible(true);
	}
	
	public void mostraErroreEmailGiaInUsoRegistrazione() {
		erroreEmailNonValidaOInUsoRegistrazione.setText("Email gia' in uso");
		erroreEmailNonValidaOInUsoRegistrazione.setVisible(true);
	}

	public void mostraErroreUsernameNonDisponibileRegistrazione() {
		erroreUsernameNonDisponibileRegistrazione.setVisible(true);
	}
	
	public void mostraErroreUsernamePassword(boolean controllo) {
		errorePasswordUsernameLogin.setVisible(controllo);
	}
	
	public void mostraErroreLePasswordNonCorrispondonoReimpostPassword() {
		labelMessaggioErroreReimpostaPassword2.setVisible(true);
	}
	
	public void resettaErroriRegistrazione() {
		erroreUsernameNonDisponibileRegistrazione.setVisible(false);
		notificaErroreCampiVuotiOConfermaRegistrazione.setVisible(false);
		erroreEmailNonValidaOInUsoRegistrazione.setVisible(false);
		errorePasswordNonValidaRegistrazione.setVisible(false);
	}
	
	private void invioCodiceReimpostaPassword(String Email) {
		ctrl.invioEmailCodiceVerificaSchermataAccessoReimpostaPassword(Email);
	}
	
	private void confermaNuovaPasswordReimpostaPassword() {
		String password = new String(passwordFieldNuovaPasswordReimpostaPassword2.getPassword());
		String passwordControllo = new String(passwordFieldConfermaNuovaPasswordReimpostaPassword2.getPassword());
		
		if(password.equals(passwordControllo))
			ctrl.impostaPassword(passwordFieldNuovaPasswordReimpostaPassword2.getPassword());
		else
			mostraErroreLePasswordNonCorrispondonoReimpostPassword();
	}
}
