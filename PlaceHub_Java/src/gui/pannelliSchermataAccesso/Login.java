package gui.pannelliSchermataAccesso;

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

import gestione.Controller;
import gui.SchermataAccesso;

public class Login extends JPanel {
	private static final long serialVersionUID = 1L;
	
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
	
	private JLabel errorePasswordUsernameLogin;
	
	private Controller ctrl;
	
	public Login(Controller Ctrl) {
		this.ctrl = Ctrl;
		setBackground(Color.WHITE);
		setSize(550, 650);
		setLayout(null);
		
		//Piazza il logo
		placehubLogoLogin = new JLabel("");
		placehubLogoLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/placehubLogo.png")));
		placehubLogoLogin.setBounds(177, 50, 197, 152);
		add(placehubLogoLogin);
		
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
		add(errorePasswordUsernameLogin);
	}

	private void generaFieldPasswordLogin() {
		JLabel testoPasswordLogin = new JLabel("");
		testoPasswordLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Password.png")));
		testoPasswordLogin.setBounds(80, 325, 111, 16);
		add(testoPasswordLogin);
		
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
		add(passwordFieldPasswordLogin);
		
		lineaPasswordLogin = new JLabel("");
		lineaPasswordLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaPasswordLogin.setBounds(80, 386, 383, 1);
		add(lineaPasswordLogin);
		
	}

	private void generaFieldUsernameLogin() {
		testoUsernamePannelloLogin = new JLabel("");
		testoUsernamePannelloLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Username.png")));
		testoUsernamePannelloLogin.setBounds(80, 219, 111, 16);
		add(testoUsernamePannelloLogin);
		
		textFieldUsernameLogin = new JTextField();
		textFieldUsernameLogin.setBounds(80, 247, 383, 32);
		textFieldUsernameLogin.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldUsernameLogin.setBackground(new Color(255,255,255));
		textFieldUsernameLogin.setBorder(new LineBorder(new Color(255,255,255),1));
		add(textFieldUsernameLogin);
		textFieldUsernameLogin.setColumns(10);
		
		lineaUsernameLogin = new JLabel("");
		lineaUsernameLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaUsernameLogin.setBounds(80, 280, 383, 1);
		add(lineaUsernameLogin);
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
				setVisible(false);
				Controller.getSchermataAccessoFrame().mostraPannelloRegistrazione();
			}
		});
		testoRegistratiLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Registrati.png")));
		testoRegistratiLogin.setBounds(310, 542, 83, 26);
		add(testoRegistratiLogin);
		
		testoCreaAccountLogin = new JLabel("");
		testoCreaAccountLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/creaAccount.png")));
		testoCreaAccountLogin.setBounds(119, 540, 185, 26);
		add(testoCreaAccountLogin);
	}

	private void gerenaTestoPasswordDimenticataLogin() {
		testoPasswordDimenticataLogin = new JLabel("");
		testoPasswordDimenticataLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/haiDimenticatolaPassword.png")));
		testoPasswordDimenticataLogin.setBounds(39, 578, 265, 26);
		add(testoPasswordDimenticataLogin);
		
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
				setVisible(false);
				Controller.getSchermataAccessoFrame().mostraPannelloReimpostaPassword1();
			}
		});
		testoReimpostaPasswordLogin.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ReimpostaPassword.png")));
		testoReimpostaPasswordLogin.setBounds(310, 578, 189, 26);
		add(testoReimpostaPasswordLogin);
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
		add(bottoneAccediLogin);
	}

	//Metodi
	
	public void mostraErroreUsernamePassword(boolean controllo) {
		errorePasswordUsernameLogin.setVisible(controllo);
	}
	
	private void eseguiLogin() {
		ctrl.loginSchermataAccesso(textFieldUsernameLogin.getText(), passwordFieldPasswordLogin.getPassword());
	}
}
