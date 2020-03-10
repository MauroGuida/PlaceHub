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
	
	private JPanel pannelloReimpostaPassword;
	private JButton bottoneConfermaReimpostaPassword;
	private JButton bottoneTornaIndietroReimpostaPassword;
	private JLabel testoEmailReimpostaPassword;
	private JTextField textFieldEmailReimpostaPassword;
	private JLabel lineaEmailReimpostaPassword;
	private JLabel testoCodiceVerificaReimpostaPassword;
	private JTextField textFieldCodiceVerificaReimpostaPassword;
	private JLabel lineaCodiceVerificaReimpostaPassword;
	private JLabel testoNuovaPasswordReimpostaPassword;
	private JPasswordField passwordFieldNuovaPasswordReimpostaPassword;
	private JLabel lineaNuovaPasswordReimpostaPassword;
	private JLabel testoConfermaNuovaPasswordReimpostaPassword;
	private JPasswordField passwordFieldConfermaNuovaPasswordReimpostaPassword;
	private JLabel lineaConfermaNuovaPasswordReimpostaPassword;
	
	public SchermataAccesso(Controller Ctrl) {
		this.ctrl=Ctrl;
		
		layoutGeneraleFinestra();
		
		generaPannelloBackground();
		
		generaPannelloBottoni();
		
		generaPannelloLogin();
		
		generaPannelloRegistrazione();
		
		generaPannelloReimpostaPassword();
	}
	
	private void layoutGeneraleFinestra() {
		setLocationRelativeTo(null);
		gestioneRiposizionamentoFinestra();
		setUndecorated(true);
		setShape(new RoundRectangle2D.Double(15, 0, 1100, 650, 30, 30));
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		setSize(1100,650);
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

	private void generaPannelloReimpostaPassword() {
		pannelloReimpostaPassword = new JPanel();
		pannelloReimpostaPassword.setBackground(Color.WHITE);
		pannelloReimpostaPassword.setBounds(550, 0, 550, 650);
		pannelloInferiore.add(pannelloReimpostaPassword);
		pannelloReimpostaPassword.setLayout(null);
		pannelloReimpostaPassword.setVisible(false);
		
		generaBottoneConfermaReimpostaPassword();
		
		generaBottoneIndietroReimpostaPassword();
		
		generaFieldEmailReimpostaPassword();
		
		generaFieldCodiceVerificaReimpostaPassword();
		
		generaFieldNuovaPasswordReimpostaPassword();
		
		generaFieldConfermaNuovaPasswordReimpostaPassword();
	}

	private void generaFieldConfermaNuovaPasswordReimpostaPassword() {
		testoConfermaNuovaPasswordReimpostaPassword = new JLabel("");
		testoConfermaNuovaPasswordReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ConfermaNuovaPassword.png")));
		testoConfermaNuovaPasswordReimpostaPassword.setBounds(80, 370, 250, 20);
		pannelloReimpostaPassword.add(testoConfermaNuovaPasswordReimpostaPassword);
		
		passwordFieldConfermaNuovaPasswordReimpostaPassword = new JPasswordField();
		passwordFieldConfermaNuovaPasswordReimpostaPassword.setBounds(80, 398, 383, 32);
		passwordFieldConfermaNuovaPasswordReimpostaPassword.setFont(new Font("Roboto", Font.PLAIN, 17));
		passwordFieldConfermaNuovaPasswordReimpostaPassword.setBackground(new Color(255,255,255));
		passwordFieldConfermaNuovaPasswordReimpostaPassword.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloReimpostaPassword.add(passwordFieldConfermaNuovaPasswordReimpostaPassword);
		
		lineaConfermaNuovaPasswordReimpostaPassword = new JLabel("");
		lineaConfermaNuovaPasswordReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaConfermaNuovaPasswordReimpostaPassword.setBounds(80, 430, 383, 1);
		pannelloReimpostaPassword.add(lineaConfermaNuovaPasswordReimpostaPassword);
	}

	private void generaFieldNuovaPasswordReimpostaPassword() {
		testoNuovaPasswordReimpostaPassword = new JLabel("");
		testoNuovaPasswordReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Nuova Password.png")));
		testoNuovaPasswordReimpostaPassword.setBounds(80, 280, 185, 20);
		pannelloReimpostaPassword.add(testoNuovaPasswordReimpostaPassword);
		
		passwordFieldNuovaPasswordReimpostaPassword = new JPasswordField();
		passwordFieldNuovaPasswordReimpostaPassword.setBounds(80, 308, 383, 32);
		passwordFieldNuovaPasswordReimpostaPassword.setFont(new Font("Roboto", Font.PLAIN, 17));
		passwordFieldNuovaPasswordReimpostaPassword.setBackground(new Color(255,255,255));
		passwordFieldNuovaPasswordReimpostaPassword.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloReimpostaPassword.add(passwordFieldNuovaPasswordReimpostaPassword);
		
		lineaNuovaPasswordReimpostaPassword = new JLabel("");
		lineaNuovaPasswordReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaNuovaPasswordReimpostaPassword.setBounds(80, 340, 383, 1);
		pannelloReimpostaPassword.add(lineaNuovaPasswordReimpostaPassword);
	}

	private void generaFieldCodiceVerificaReimpostaPassword() {
		testoCodiceVerificaReimpostaPassword = new JLabel("");
		testoCodiceVerificaReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/CodiceVerifica.png")));
		testoCodiceVerificaReimpostaPassword.setBounds(80, 190, 140, 20);
		pannelloReimpostaPassword.add(testoCodiceVerificaReimpostaPassword);
		
		textFieldCodiceVerificaReimpostaPassword = new JTextField();
		textFieldCodiceVerificaReimpostaPassword.setBounds(80, 218, 383, 32);
		textFieldCodiceVerificaReimpostaPassword.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldCodiceVerificaReimpostaPassword.setBackground(new Color(255,255,255));
		textFieldCodiceVerificaReimpostaPassword.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloReimpostaPassword.add(textFieldCodiceVerificaReimpostaPassword);
		textFieldCodiceVerificaReimpostaPassword.setColumns(10);
		
		lineaCodiceVerificaReimpostaPassword = new JLabel("");
		lineaCodiceVerificaReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaCodiceVerificaReimpostaPassword.setBounds(80, 250, 383, 1);
		pannelloReimpostaPassword.add(lineaCodiceVerificaReimpostaPassword);
	}

	private void generaFieldEmailReimpostaPassword() {
		testoEmailReimpostaPassword = new JLabel("");
		testoEmailReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoEmail.png")));
		testoEmailReimpostaPassword.setBounds(80, 100, 111, 20);
		pannelloReimpostaPassword.add(testoEmailReimpostaPassword);
		
		textFieldEmailReimpostaPassword = new JTextField();
		textFieldEmailReimpostaPassword.setBounds(80, 128, 383, 32);
		textFieldEmailReimpostaPassword.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldEmailReimpostaPassword.setBackground(new Color(255,255,255));
		textFieldEmailReimpostaPassword.setBorder(new LineBorder(new Color(255,255,255),1));
		pannelloReimpostaPassword.add(textFieldEmailReimpostaPassword);
		textFieldEmailReimpostaPassword.setColumns(10);
		
		lineaEmailReimpostaPassword = new JLabel("");
		lineaEmailReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaEmailReimpostaPassword.setBounds(80, 160, 383, 1);
		pannelloReimpostaPassword.add(lineaEmailReimpostaPassword);
	}

	private void generaBottoneIndietroReimpostaPassword() {
		bottoneTornaIndietroReimpostaPassword = new JButton("");
		bottoneTornaIndietroReimpostaPassword.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				pannelloLogin.setVisible(true);
				pannelloReimpostaPassword.setVisible(false);
			}
		});
		bottoneTornaIndietroReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/arrow.png")));
		bottoneTornaIndietroReimpostaPassword.setBounds(12, 595, 43, 43);
		bottoneTornaIndietroReimpostaPassword.setOpaque(false);
		bottoneTornaIndietroReimpostaPassword.setContentAreaFilled(false);
		bottoneTornaIndietroReimpostaPassword.setBorderPainted(false);
		pannelloReimpostaPassword.add(bottoneTornaIndietroReimpostaPassword);
	}

	private void generaBottoneConfermaReimpostaPassword() {
		bottoneConfermaReimpostaPassword = new JButton("");
		bottoneConfermaReimpostaPassword.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneConfermaReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneConfermaFocus.png")));
				setCursor(new Cursor(Cursor.HAND_CURSOR));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneConfermaReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneConferma.png")));
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
		});
		
		bottoneConfermaReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneConferma.png")));
		bottoneConfermaReimpostaPassword.setBounds(140, 485, 280, 48);
		bottoneConfermaReimpostaPassword.setOpaque(false);
		bottoneConfermaReimpostaPassword.setBorderPainted(false);
		bottoneConfermaReimpostaPassword.setContentAreaFilled(false);
		pannelloReimpostaPassword.add(bottoneConfermaReimpostaPassword);
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
		
		generaBottoneAccedi();
		gerenaTestoPasswordDimenticata();
		generaTestoRegistrati();
		generaFieldUsername();
		generaFieldPassword();
	}

	private void generaFieldPassword() {
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

	private void generaFieldUsername() {
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

	private void generaTestoRegistrati() {
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

	private void gerenaTestoPasswordDimenticata() {
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
				pannelloReimpostaPassword.setVisible(true);
			}
		});
		testoReimpostaPasswordLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ReimpostaPassword.png")));
		testoReimpostaPasswordLogin.setBounds(310, 578, 189, 26);
		pannelloLogin.add(testoReimpostaPasswordLogin);
	}

	private void generaBottoneAccedi() {
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
				ctrl.registratiSchermataAccesso(textFieldUsernameRegistrazione.getText(), textFieldNomeRegistrazione.getText(),
						textFieldCognomeRegistrazione.getText(), textFieldEmailRegistrazione.getText(), textFieldDataNascitaRegistrazione.getText(), passwordFieldRegistrazione.getPassword());
				
				pannelloRegistrazione.setVisible(false);
				pannelloLogin.setVisible(true);
			}
		});
		bottoneRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneRegistrati.png")));
		bottoneRegistrazione.setBounds(140, 500, 280, 48);
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
		testoHaiUnAccountRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/haiGiaUnAccount.png")));
		testoHaiUnAccountRegistrazione.setBounds(155, 565, 177, 24);
		pannelloRegistrazione.add(testoHaiUnAccountRegistrazione);
		
		testoAccediRegistrazione = new JLabel("");
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
			}
		});
		testoAccediRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoAccedi.png")));
		testoAccediRegistrazione.setBounds(335, 563, 62, 24);
		pannelloRegistrazione.add(testoAccediRegistrazione);
	}
	
	
	private void eseguiLogin() {
		ctrl.loginSchermataAccesso(textFieldUsernameLogin.getText(), passwordFieldPasswordLogin.getPassword());
	}

}
