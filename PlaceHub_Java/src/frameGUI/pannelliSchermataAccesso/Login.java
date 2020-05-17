package frameGUI.pannelliSchermataAccesso;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
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

import frameGUI.SchermataAccesso;
import gestione.Controller;

import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

public class Login extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JButton bottoneAccedi;
	private JLabel testoPasswordDimenticata;
	private JLabel testoReimpostaPassword;
	private JLabel testoCreaAccount;
	private JLabel testoRegistrati;
	private JLabel testoPassword;
	private JLabel placehubLogo;
	private JLabel testoUsernamePannello;
	private JTextField textFieldUsername;
	private JPasswordField passwordFieldPassword;
	private JLabel lineaUsername;
	private JLabel lineaPassword;
	
	private JLabel errorePasswordUsername;
	
	private Controller ctrl;
	
	public Login(Controller Ctrl) {
		this.ctrl = Ctrl;
		setBackground(Color.WHITE);
		setSize(550, 650);
		setLayout(null);
		
		svuotaCampi();
		
		generaLogo();
		generaBottoneAccedi();
		generaTestoPasswordDimenticata();
		generaTestoRegistrati();
		generaFieldUsername();
		generaFieldPassword();
		generaTestoErroreUsernameOPassword();
	}

	private void svuotaCampi() {
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentShown(ComponentEvent e) {
				pulisciPannello();
			}
		});
	}
	
	private void generaLogo() {
		placehubLogo = new JLabel("");
		placehubLogo.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/placehubLogo.png")));
		placehubLogo.setBounds(177, 50, 197, 152);
		add(placehubLogo);
	}
	
	private void generaTestoErroreUsernameOPassword() {
		errorePasswordUsername = new JLabel("Username o Password errati!");
		errorePasswordUsername.setHorizontalAlignment(SwingConstants.CENTER);
		errorePasswordUsername.setForeground(Color.RED);
		errorePasswordUsername.setFont(new Font("Roboto", Font.PLAIN, 16));
		errorePasswordUsername.setBounds(80, 410, 383, 26);
		errorePasswordUsername.setVisible(false);
		add(errorePasswordUsername);
	}

	private void generaFieldPassword() {
		testoPassword = new JLabel("");
		testoPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Password.png")));
		testoPassword.setBounds(80, 325, 111, 16);
		add(testoPassword);
		
		passwordFieldPassword = new JPasswordField();
		passwordFieldPassword.setBounds(80, 353, 383, 32);
		passwordFieldPassword.setBackground(new Color(255,255,255));
		passwordFieldPassword.setBorder(new LineBorder(new Color(255,255,255),1));
		passwordFieldPassword.setFont(new Font("Roboto", Font.PLAIN, 17));
		passwordFieldPassword.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& passwordFieldPassword.getPassword().length <= 49) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					passwordFieldPassword.setEditable(true);
				else
					passwordFieldPassword.setEditable(false);
				
				if(e.getKeyCode() == KeyEvent.VK_ENTER) {
				      eseguiLogin();
				   }
			}
		});
		add(passwordFieldPassword);
		
		lineaPassword = new JLabel("");
		lineaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaPassword.setBounds(80, 386, 383, 1);
		add(lineaPassword);
		
	}

	private void generaFieldUsername() {
		testoUsernamePannello = new JLabel("");
		testoUsernamePannello.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Username.png")));
		testoUsernamePannello.setBounds(80, 219, 111, 16);
		add(testoUsernamePannello);
		
		textFieldUsername = new JTextField();
		textFieldUsername.setBounds(80, 247, 383, 32);
		textFieldUsername.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldUsername.setBackground(new Color(255,255,255));
		textFieldUsername.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldUsername.setColumns(10);
		textFieldUsername.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& textFieldUsername.getText().length() <= 49) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					textFieldUsername.setEditable(true);
				else
					textFieldUsername.setEditable(false);
			}
		});
		add(textFieldUsername);
		
		lineaUsername = new JLabel("");
		lineaUsername.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaUsername.setBounds(80, 280, 383, 1);
		add(lineaUsername);
	}

	private void generaTestoRegistrati() {
		testoRegistrati = new JLabel("");
		testoRegistrati.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Registrati.png")));
		testoRegistrati.setBounds(310, 542, 83, 26);
		testoRegistrati.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				testoRegistrati.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/RegistratiFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				testoRegistrati.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Registrati.png")));
			}
			@Override
			public void mousePressed(MouseEvent e) {
				setVisible(false);
				Controller.getSchermataAccessoFrame().mostraPannelloRegistrazione();
			}
		});
		add(testoRegistrati);
		
		testoCreaAccount = new JLabel("");
		testoCreaAccount.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/creaAccount.png")));
		testoCreaAccount.setBounds(119, 540, 185, 26);
		add(testoCreaAccount);
	}

	private void generaTestoPasswordDimenticata() {
		testoPasswordDimenticata = new JLabel("");
		testoPasswordDimenticata.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/haiDimenticatolaPassword.png")));
		testoPasswordDimenticata.setBounds(39, 578, 265, 26);
		add(testoPasswordDimenticata);
		
		testoReimpostaPassword = new JLabel("");
		testoReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ReimpostaPassword.png")));
		testoReimpostaPassword.setBounds(310, 578, 189, 26);
		testoReimpostaPassword.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				testoReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ReimpostaPasswordFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				testoReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ReimpostaPassword.png")));
			}
			@Override
			public void mouseClicked(MouseEvent e) {
				setVisible(false);
				Controller.getSchermataAccessoFrame().mostraPannelloReimpostaPassword1();
			}
		});
		add(testoReimpostaPassword);
	}

	private void generaBottoneAccedi() {
		bottoneAccedi = new JButton("");
		bottoneAccedi.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Accedi.png")));
		bottoneAccedi.setOpaque(false);
		bottoneAccedi.setBorderPainted(false);
		bottoneAccedi.setContentAreaFilled(false);
		bottoneAccedi.setBounds(140, 470, 280, 48);
		bottoneAccedi.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				eseguiLogin();
			}
		});
		bottoneAccedi.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneAccedi.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/AccediFocus.png")));
				setCursor(new Cursor(Cursor.HAND_CURSOR));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneAccedi.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Accedi.png")));
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
		});
		add(bottoneAccedi);
	}

	
	//Metodi
	
	public void mostraErroreUsernamePassword(boolean controllo) {
		errorePasswordUsername.setVisible(controllo);
	}
	
	private void eseguiLogin() {
		ctrl.loginSchermataAccesso(textFieldUsername.getText(), passwordFieldPassword.getPassword());
	}

	private void pulisciPannello() {
		textFieldUsername.setText("");
		passwordFieldPassword.setText("");
	}
}
