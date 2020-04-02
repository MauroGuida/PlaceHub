package gui.pannelliSchermataAccesso;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Font;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.border.LineBorder;

import gestione.Controller;
import gui.SchermataAccesso;
import res.DatePicker;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

public class Registrazione extends JPanel {
	private static final long serialVersionUID = 1L;
	
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

	private JLabel notificaErrori;
	private JLabel erroreUsernameNonDisponibileRegistrazione;
	private JLabel erroreEmailNonValidaOInUsoRegistrazione;
	private JLabel errorePasswordNonValidaRegistrazione;
	
	private Controller ctrl;
	
	public Registrazione(Controller Ctrl) {
		
		this.ctrl = Ctrl;
		setBackground(Color.WHITE);
		setBounds(550, 0, 550, 650);
		setLayout(null);
		setVisible(false);
		
		svuotaCampi();
		
		generaBottoneRegistrazione();
		generaTestoHaiGiaUnAccountRegistrazione();
		generaFieldUsernameRegistrazione();
		generaFieldNomeRegistrazione();
		generaFieldCognomeRegistrazione();
		generaFiledDataNascitaRegistrazione();
		generaFieldEmailRegistrazione();
		generaFieldPasswordRegistrazione();
		generaTestoErroriRegistrazione();
	}

	private void svuotaCampi() {
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentShown(ComponentEvent e) {
				textFieldUsernameRegistrazione.setText("");
				textFieldNomeRegistrazione.setText("");
				textFieldCognomeRegistrazione.setText("");
				textFieldDataNascitaRegistrazione.setText("");
				textFieldEmailRegistrazione.setText("");
				passwordFieldRegistrazione.setText("");
			}
		});
	}

	private void generaBottoneRegistrazione() {
		bottoneRegistrazione = new JButton("");
		bottoneRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneRegistrati.png")));
		bottoneRegistrazione.setBounds(132, 500, 280, 48);
		bottoneRegistrazione.setOpaque(false);
		bottoneRegistrazione.setContentAreaFilled(false);
		bottoneRegistrazione.setBorderPainted(false);
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
		add(bottoneRegistrazione);
	}
	
	private void generaFieldPasswordRegistrazione() {
		testoPasswordRegistrazione = new JLabel("");
		testoPasswordRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Password.png")));
		testoPasswordRegistrazione.setBounds(80, 400, 111, 20);
		add(testoPasswordRegistrazione);
		
		passwordFieldRegistrazione = new JPasswordField();
		passwordFieldRegistrazione.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& passwordFieldRegistrazione.getPassword().length <= 99) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					passwordFieldRegistrazione.setEditable(true);
				else
					passwordFieldRegistrazione.setEditable(false);
				
				if(e.getKeyCode() == KeyEvent.VK_ENTER)
					eseguiRegistrazione();
			}
		});
		passwordFieldRegistrazione.setBounds(80, 422, 383, 32);
		passwordFieldRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		passwordFieldRegistrazione.setBackground(new Color(255,255,255));
		passwordFieldRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		add(passwordFieldRegistrazione);
		
		lineaPasswordRegistrazione = new JLabel("");
		lineaPasswordRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaPasswordRegistrazione.setBounds(80, 454, 383, 1);
		add(lineaPasswordRegistrazione);
	}

	private void generaTestoErroriRegistrazione() {
		erroreUsernameNonDisponibileRegistrazione = new JLabel("Username non disponibile");
		erroreUsernameNonDisponibileRegistrazione.setHorizontalAlignment(SwingConstants.RIGHT);
		erroreUsernameNonDisponibileRegistrazione.setForeground(Color.RED);
		erroreUsernameNonDisponibileRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 16));
		erroreUsernameNonDisponibileRegistrazione.setBounds(201, 41, 262, 20);
		erroreUsernameNonDisponibileRegistrazione.setVisible(false);
		add(erroreUsernameNonDisponibileRegistrazione);
		
		notificaErrori = new JLabel("Errore/Conferma");
		notificaErrori.setHorizontalAlignment(SwingConstants.CENTER);
		notificaErrori.setForeground(Color.RED);
		notificaErrori.setFont(new Font("Roboto", Font.PLAIN, 16));
		notificaErrori.setBounds(80, 469, 383, 20);
		notificaErrori.setVisible(false);
		add(notificaErrori);
		
		erroreEmailNonValidaOInUsoRegistrazione = new JLabel("Email non valida");
		erroreEmailNonValidaOInUsoRegistrazione.setHorizontalAlignment(SwingConstants.RIGHT);
		erroreEmailNonValidaOInUsoRegistrazione.setForeground(Color.RED);
		erroreEmailNonValidaOInUsoRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 16));
		erroreEmailNonValidaOInUsoRegistrazione.setBounds(155, 329, 308, 20);
		erroreEmailNonValidaOInUsoRegistrazione.setVisible(false);
		add(erroreEmailNonValidaOInUsoRegistrazione);
		
		errorePasswordNonValidaRegistrazione = new JLabel("Password non valida");
		errorePasswordNonValidaRegistrazione.setHorizontalAlignment(SwingConstants.RIGHT);
		errorePasswordNonValidaRegistrazione.setForeground(Color.RED);
		errorePasswordNonValidaRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 16));
		errorePasswordNonValidaRegistrazione.setBounds(228, 400, 235, 20);
		errorePasswordNonValidaRegistrazione.setVisible(false);
		add(errorePasswordNonValidaRegistrazione);
	}

	private void generaFieldEmailRegistrazione() {
		testoEmailRegistrazione = new JLabel("");
		testoEmailRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoEmail.png")));
		testoEmailRegistrazione.setBounds(80, 329, 111, 20);
		add(testoEmailRegistrazione);
		
		textFieldEmailRegistrazione = new JTextField();
		textFieldEmailRegistrazione.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& textFieldEmailRegistrazione.getText().length() <= 99) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE  || e.getKeyChar() <= '.' || e.getKeyChar() <= '@')
					textFieldEmailRegistrazione.setEditable(true);
				else
					textFieldEmailRegistrazione.setEditable(false);
			}
		});
		textFieldEmailRegistrazione.setBounds(80, 351, 383, 32);
		textFieldEmailRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldEmailRegistrazione.setBackground(new Color(255,255,255));
		textFieldEmailRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		add(textFieldEmailRegistrazione);
		textFieldEmailRegistrazione.setColumns(10);
		
		lineaEmailRegistrazione = new JLabel("");
		lineaEmailRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaEmailRegistrazione.setBounds(80, 383, 383, 1);
		add(lineaEmailRegistrazione);
	}

	private void generaFiledDataNascitaRegistrazione() {
		testoDataNascitaRegistrazione = new JLabel("");
		testoDataNascitaRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoDataNascita.png")));
		testoDataNascitaRegistrazione.setBounds(80, 254, 140, 20);
		add(testoDataNascitaRegistrazione);
		
		textFieldDataNascitaRegistrazione = new JTextField();
		textFieldDataNascitaRegistrazione.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				textFieldDataNascitaRegistrazione.setText(new DatePicker(Controller.getSchermataAccessoFrame()).setPickedDate());
			}
		});
		textFieldDataNascitaRegistrazione.setBounds(80, 280, 383, 32);
		textFieldDataNascitaRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldDataNascitaRegistrazione.setBackground(new Color(255,255,255));
		textFieldDataNascitaRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		add(textFieldDataNascitaRegistrazione);
		textFieldDataNascitaRegistrazione.setColumns(10);
		textFieldDataNascitaRegistrazione.setEditable(false);
		
		lineaDataNascitaRegistrazione = new JLabel("");
		lineaDataNascitaRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaDataNascitaRegistrazione.setBounds(80, 312, 383, 1);
		add(lineaDataNascitaRegistrazione);
	}

	private void generaFieldCognomeRegistrazione() {
		testoCognomeRegistrazione = new JLabel("");
		testoCognomeRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoCognome.png")));
		testoCognomeRegistrazione.setBounds(80, 183, 111, 20);
		add(testoCognomeRegistrazione);
		
		textFieldCognomeRegistrazione = new JTextField();
		textFieldCognomeRegistrazione.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& textFieldCognomeRegistrazione.getText().length() <= 49) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					textFieldCognomeRegistrazione.setEditable(true);
				else
					textFieldCognomeRegistrazione.setEditable(false);
			}
		});
		textFieldCognomeRegistrazione.setBounds(80, 205, 383, 32);
		textFieldCognomeRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldCognomeRegistrazione.setBackground(new Color(255,255,255));
		textFieldCognomeRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		add(textFieldCognomeRegistrazione);
		textFieldCognomeRegistrazione.setColumns(10);
		
		lineaCognomeRegistrazione = new JLabel("");
		lineaCognomeRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaCognomeRegistrazione.setBounds(80, 237, 383, 1);
		add(lineaCognomeRegistrazione);
	}

	private void generaFieldNomeRegistrazione() {
		testoNomeRegistrazione = new JLabel("");
		testoNomeRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoNome.png")));
		testoNomeRegistrazione.setBounds(80, 112, 111, 20);
		add(testoNomeRegistrazione);
		
		textFieldNomeRegistrazione = new JTextField();
		textFieldNomeRegistrazione.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& textFieldNomeRegistrazione.getText().length() <= 49) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					textFieldNomeRegistrazione.setEditable(true);
				else
					textFieldNomeRegistrazione.setEditable(false);
			}
		});
		textFieldNomeRegistrazione.setBounds(80, 134, 383, 32);
		textFieldNomeRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldNomeRegistrazione.setBackground(new Color(255,255,255));
		textFieldNomeRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		add(textFieldNomeRegistrazione);
		textFieldNomeRegistrazione.setColumns(10);
		
		lineaNomeRegistrazione = new JLabel("");
		lineaNomeRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaNomeRegistrazione.setBounds(80, 166, 383, 1);
		add(lineaNomeRegistrazione);
	}

	private void generaFieldUsernameRegistrazione() {
		testoUsernamePannelloRegistrazione = new JLabel("");
		testoUsernamePannelloRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Username.png")));
		testoUsernamePannelloRegistrazione.setBounds(80, 41, 111, 20);
		add(testoUsernamePannelloRegistrazione);
		
		textFieldUsernameRegistrazione = new JTextField();
		textFieldUsernameRegistrazione.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& textFieldUsernameRegistrazione.getText().length() <= 49) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					textFieldUsernameRegistrazione.setEditable(true);
				else
					textFieldUsernameRegistrazione.setEditable(false);
			}
		});
		textFieldUsernameRegistrazione.setBounds(80, 63, 383, 32);
		textFieldUsernameRegistrazione.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldUsernameRegistrazione.setBackground(new Color(255,255,255));
		textFieldUsernameRegistrazione.setBorder(new LineBorder(new Color(255,255,255),1));
		add(textFieldUsernameRegistrazione);
		textFieldUsernameRegistrazione.setColumns(10);
		
		lineaUsernameRegistrazione = new JLabel("");
		lineaUsernameRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaUsernameRegistrazione.setBounds(80, 95, 383, 1);
		add(lineaUsernameRegistrazione);
	}

	private void generaTestoHaiGiaUnAccountRegistrazione() {
		testoHaiUnAccountRegistrazione = new JLabel("");
		testoHaiUnAccountRegistrazione.setHorizontalAlignment(SwingConstants.RIGHT);
		testoHaiUnAccountRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/haiGiaUnAccount.png")));
		testoHaiUnAccountRegistrazione.setBounds(132, 565, 200, 24);
		add(testoHaiUnAccountRegistrazione);
		
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
				Controller.getSchermataAccessoFrame().mostraPannelloLogin();
				setVisible(false);
				resettaErroriRegistrazione();
			}
		});
		testoAccediRegistrazione.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoAccedi.png")));
		testoAccediRegistrazione.setBounds(342, 563, 70, 24);
		add(testoAccediRegistrazione);
	}
	
	//Metodi
	
	private void eseguiRegistrazione() {
		ctrl.registratiSchermataAccesso(textFieldUsernameRegistrazione.getText(), textFieldNomeRegistrazione.getText(),
				textFieldCognomeRegistrazione.getText(), textFieldEmailRegistrazione.getText(), textFieldDataNascitaRegistrazione.getText(), passwordFieldRegistrazione.getPassword());
	}
	
	public void mostraErroreNonPossonoEsserciCampiVuotiRegistrazione() {
		notificaErrori.setForeground(Color.RED);
		notificaErrori.setFont(new Font("Roboto", Font.PLAIN, 16));
		notificaErrori.setText("Non possono esserci campi vuoti!");
		
		notificaErrori.setVisible(true);
	}
	
	public void mostraConfermaRegistrazione() {
		notificaErrori.setForeground(new Color(64,151,0));
		notificaErrori.setFont(new Font("Roboto", Font.PLAIN, 16));
		notificaErrori.setText("Registrazione effettuata con successo!");
		
		notificaErrori.setVisible(true);
	}

	public void mostraErrorePasswordNonValidaRegistrazione() {
		notificaErrori.setForeground(Color.RED);
		notificaErrori.setFont(new Font("Roboto", Font.PLAIN, 16));
		notificaErrori.setText("La password deve essere di almeno 6 caratteri");
		
		notificaErrori.setVisible(true);
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
	
	public void mostraErroreDataDiNascitaNonValida() {
		notificaErrori.setForeground(Color.RED);
		notificaErrori.setFont(new Font("Roboto", Font.PLAIN, 16));
		notificaErrori.setText("Non sono accettati utenti provenienti dal futuro!");
		
		notificaErrori.setVisible(true);
	}
	
	public void resettaErroriRegistrazione() {
		erroreUsernameNonDisponibileRegistrazione.setVisible(false);
		notificaErrori.setVisible(false);
		erroreEmailNonValidaOInUsoRegistrazione.setVisible(false);
		errorePasswordNonValidaRegistrazione.setVisible(false);
	}
}
