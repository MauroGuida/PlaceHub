package gui;

import java.awt.BorderLayout;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.border.LineBorder;

import gestione.Controller;
import java.awt.Color;
import java.awt.Cursor;
import java.awt.Font;

import javax.swing.JButton;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.ImageIcon;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionListener;

import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.JPasswordField;

public class SchermataAccesso extends JFrame {
	private static final long serialVersionUID = 1L;
	
	private JPanel contentPane;
	private JPanel panelloBottoni;
	private Controller ctrl;
	private JButton bottoneMinimizza;
	private JButton bottoneEsci;
	private JPanel panelloLogin;
	private JButton bottoneAccedi;
	private JLabel testoPasswordDimenticata;
	private JLabel testoReimpostaPassword;
	private JLabel testoCreaAccount;
	private JLabel testoRegistrati;
	private JLabel placehubLogo;
	private JLabel testoUsername;
	private JTextField textFieldUsername;
	private JPasswordField passwordField;
	private JLabel lineaUsername;
	private JLabel lineaPassword;
	private int coordinataX;
	private int coordinataY;
	
	//Generazione finestra
	public SchermataAccesso(Controller Ctrl) {
		this.ctrl=Ctrl;
		
		setLocationRelativeTo(null);
		frameDrag();
		setUndecorated(true);
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		setSize(1100,650);
		
		contentPane = new JPanel();
		contentPane.setBackground(Color.RED);
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		panelloBottoni = new JPanel();
		panelloBottoni.setBackground(Color.WHITE);
		panelloBottoni.setBounds(550, 0, 550, 36);
		contentPane.add(panelloBottoni);
		panelloBottoni.setLayout(null);
		
		bottoneEsci = new JButton("");
		bottoneEsci.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				dispose();
			}
		});
		
		bottoneMinimizza = new JButton("");
		bottoneMinimizza.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				setState(ICONIFIED);
			}
		});
		bottoneMinimizza.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/minimizza.png")));
		bottoneMinimizza.setBounds(483, 5, 25, 25);
		bottoneMinimizza.setOpaque(false);
		bottoneMinimizza.setContentAreaFilled(false);
		bottoneMinimizza.setBorderPainted(false);
		panelloBottoni.add(bottoneMinimizza);
		bottoneEsci.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/X.png")));
		bottoneEsci.setBounds(520, 8, 22, 22);
		bottoneEsci.setBorderPainted(false);
		bottoneEsci.setContentAreaFilled(false);
		bottoneEsci.setOpaque(false);
		panelloBottoni.add(bottoneEsci);
		
		panelloLogin = new JPanel();
		panelloLogin.setBackground(Color.WHITE);
		panelloLogin.setBounds(550, 0, 550, 650);
		contentPane.add(panelloLogin);
		panelloLogin.setLayout(null);
		
		bottoneAccedi = new JButton("");
		bottoneAccedi.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneAccedi.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/AccediFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneAccedi.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Accedi.png")));
			}
		});
		bottoneAccedi.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Accedi.png")));
		bottoneAccedi.setOpaque(false);
		bottoneAccedi.setBorderPainted(false);
		bottoneAccedi.setContentAreaFilled(false);
		bottoneAccedi.setBounds(140, 470, 280, 48);
		panelloLogin.add(bottoneAccedi);
		
		testoPasswordDimenticata = new JLabel("");
		testoPasswordDimenticata.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/passwordDimenticata.png")));
		testoPasswordDimenticata.setBounds(55, 578, 250, 26);
		panelloLogin.add(testoPasswordDimenticata);
		
		testoReimpostaPassword = new JLabel("");
		testoReimpostaPassword.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				testoReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ReimpostaPasswordFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				testoReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ReimpostaPassword.png")));
			}
		});
		testoReimpostaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ReimpostaPassword.png")));
		testoReimpostaPassword.setBounds(307, 578, 189, 26);
		panelloLogin.add(testoReimpostaPassword);
		
		testoCreaAccount = new JLabel("");
		testoCreaAccount.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/creaAccount.png")));
		testoCreaAccount.setBounds(116, 540, 189, 26);
		panelloLogin.add(testoCreaAccount);
		
		testoRegistrati = new JLabel("");
		testoRegistrati.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				testoRegistrati.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/RegistratiFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				testoRegistrati.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Registrati.png")));
			}
		});
		testoRegistrati.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Registrati.png")));
		testoRegistrati.setBounds(307, 542, 83, 26);
		panelloLogin.add(testoRegistrati);
		
		placehubLogo = new JLabel("");
		placehubLogo.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/placehubLogo.png")));
		placehubLogo.setBounds(177, 50, 197, 152);
		panelloLogin.add(placehubLogo);
		
		testoUsername = new JLabel("");
		testoUsername.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Username.png")));
		testoUsername.setBounds(90, 219, 111, 16);
		panelloLogin.add(testoUsername);
		
		textFieldUsername = new JTextField();
		textFieldUsername.setBounds(90, 247, 383, 32);
		textFieldUsername.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldUsername.setBackground(new Color(255,255,255));
		textFieldUsername.setBorder(new LineBorder(new Color(255,255,255),1));
		panelloLogin.add(textFieldUsername);
		textFieldUsername.setColumns(10);
		
		JLabel testoPassword = new JLabel("");
		testoPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Password.png")));
		testoPassword.setBounds(90, 325, 111, 16);
		panelloLogin.add(testoPassword);
		
		passwordField = new JPasswordField();
		passwordField.setBounds(90, 353, 383, 32);
		passwordField.setBackground(new Color(255,255,255));
		passwordField.setBorder(new LineBorder(new Color(255,255,255),1));
		passwordField.setFont(new Font("Roboto", Font.PLAIN, 17));
		panelloLogin.add(passwordField);
		
		lineaUsername = new JLabel("");
		lineaUsername.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaUsername.setBounds(90, 280, 383, 1);
		panelloLogin.add(lineaUsername);
		
		lineaPassword = new JLabel("");
		lineaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaPassword.setBounds(90, 388, 383, 1);
		panelloLogin.add(lineaPassword);
	}
	
	private void frameDrag() {
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
}
