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
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

public class ReimpostaPassword2 extends JPanel {
	private static final long serialVersionUID = 1L;

	private JButton bottoneConferma;
	private JButton bottoneTornaIndietro;
	private JLabel testoCodiceVerifica;
	private JTextField textFieldCodiceVerifica;
	private JLabel lineaCodiceVerifica;
	private JLabel testoNuovaPassword;
	private JPasswordField passwordFieldNuovaPassword;
	private JLabel lineaNuovaPassword;
	private JLabel testoConfermaNuovaPassword;
	private JPasswordField passwordFieldConfermaNuovaPassword;
	private JLabel lineaConfermaNuovaPassword;
	private JLabel testoComunicazioneUtente;
	private JLabel testoMessaggioErrore;
	
	private Controller ctrl;
	
	public ReimpostaPassword2(Controller Ctrl) {
		this.ctrl = Ctrl;
		setBackground(Color.WHITE);
		setSize(550, 650);
		setLayout(null);
		setVisible(false);
		
		svuotaCampi();
		
		generatestoComunicazioneUtente();
		generaBottoneConferma();
		generaBottoneIndietro();
		generaFieldCodiceVerifica();
		generaFieldNuovaPassword();
		generaFieldConfermaNuovaPassword();
		generatestoMessaggioErrore();
	}

	private void svuotaCampi() {
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentShown(ComponentEvent e) {
				textFieldCodiceVerifica.setText("");
				passwordFieldNuovaPassword.setText("");
				passwordFieldConfermaNuovaPassword.setText("");
			}
		});
	}

	private void generatestoComunicazioneUtente() {
		testoComunicazioneUtente = new JLabel("<html><center><p><b>Inserire il codice ricevuto via Email</b></p>"
				+ "<p>\n</p>"
				+ "<p><font size=\"4\"><i>Nel caso non si dovesse ricevere un'Email entro 10 minuti si prega di"
				+ "controllare l'indirizzo inserito e riprovare!</i></font></p></center></html>");
		testoComunicazioneUtente.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoComunicazioneUtente.setBounds(80, 62, 383, 117);
		add(testoComunicazioneUtente);
	}
	
	private void generatestoMessaggioErrore() {
		testoMessaggioErrore = new JLabel("Le password non corrispondono!");
		testoMessaggioErrore.setVisible(false);
		testoMessaggioErrore.setHorizontalAlignment(SwingConstants.CENTER);
		testoMessaggioErrore.setForeground(Color.RED);
		testoMessaggioErrore.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoMessaggioErrore.setBounds(80, 442, 383, 32);
		add(testoMessaggioErrore);
	}

	private void generaFieldConfermaNuovaPassword() {
		testoConfermaNuovaPassword = new JLabel("");
		testoConfermaNuovaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ConfermaNuovaPassword.png")));
		testoConfermaNuovaPassword.setBounds(80, 370, 250, 20);
		add(testoConfermaNuovaPassword);
		
		passwordFieldConfermaNuovaPassword = new JPasswordField();
		passwordFieldConfermaNuovaPassword.setBounds(80, 398, 383, 32);
		passwordFieldConfermaNuovaPassword.setFont(new Font("Roboto", Font.PLAIN, 17));
		passwordFieldConfermaNuovaPassword.setBackground(new Color(255,255,255));
		passwordFieldConfermaNuovaPassword.setBorder(new LineBorder(new Color(255,255,255),1));
		passwordFieldConfermaNuovaPassword.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& passwordFieldConfermaNuovaPassword.getPassword().length <= 99) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					passwordFieldConfermaNuovaPassword.setEditable(true);
				else
					passwordFieldConfermaNuovaPassword.setEditable(false);
				
				if(e.getKeyCode() == KeyEvent.VK_ENTER) {
					confermaNuovaPasswordReimpostaPassword();
				}
			}
		});
		add(passwordFieldConfermaNuovaPassword);
		
		lineaConfermaNuovaPassword = new JLabel("");
		lineaConfermaNuovaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaConfermaNuovaPassword.setBounds(80, 430, 383, 1);
		add(lineaConfermaNuovaPassword);
	}

	private void generaFieldNuovaPassword() {
		testoNuovaPassword = new JLabel("");
		testoNuovaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Nuova Password.png")));
		testoNuovaPassword.setBounds(80, 280, 185, 20);
		add(testoNuovaPassword);
		
		passwordFieldNuovaPassword = new JPasswordField();
		passwordFieldNuovaPassword.setBounds(80, 308, 383, 32);
		passwordFieldNuovaPassword.setFont(new Font("Roboto", Font.PLAIN, 17));
		passwordFieldNuovaPassword.setBackground(new Color(255,255,255));
		passwordFieldNuovaPassword.setBorder(new LineBorder(new Color(255,255,255),1));
		passwordFieldNuovaPassword.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& passwordFieldNuovaPassword.getPassword().length <= 99) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					passwordFieldNuovaPassword.setEditable(true);
				else
					passwordFieldNuovaPassword.setEditable(false);
			}
		});
		add(passwordFieldNuovaPassword);
		
		lineaNuovaPassword = new JLabel("");
		lineaNuovaPassword.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaNuovaPassword.setBounds(80, 340, 383, 1);
		add(lineaNuovaPassword);
	}

	private void generaFieldCodiceVerifica() {
		testoCodiceVerifica = new JLabel("");
		testoCodiceVerifica.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/CodiceVerifica.png")));
		testoCodiceVerifica.setBounds(80, 190, 140, 20);
		add(testoCodiceVerifica);
		
		textFieldCodiceVerifica = new JTextField();
		textFieldCodiceVerifica.setBounds(80, 218, 383, 32);
		textFieldCodiceVerifica.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldCodiceVerifica.setBackground(new Color(255,255,255));
		textFieldCodiceVerifica.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldCodiceVerifica.setColumns(10);
		add(textFieldCodiceVerifica);
		
		lineaCodiceVerifica = new JLabel("");
		lineaCodiceVerifica.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaCodiceVerifica.setBounds(80, 250, 383, 1);
		add(lineaCodiceVerifica);
	}

	private void generaBottoneIndietro() {
		bottoneTornaIndietro = new JButton("");
		bottoneTornaIndietro.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/arrow.png")));
		bottoneTornaIndietro.setBounds(12, 595, 43, 43);
		bottoneTornaIndietro.setOpaque(false);
		bottoneTornaIndietro.setContentAreaFilled(false);
		bottoneTornaIndietro.setBorderPainted(false);
		bottoneTornaIndietro.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				Controller.getSchermataAccessoFrame().mostraPannelloLogin();
				setVisible(false);
				
				resettaErroriReimpostaPassword2();
			}
		});
		add(bottoneTornaIndietro);
	}

	private void generaBottoneConferma() {
		bottoneConferma = new JButton("");
		bottoneConferma.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneConferma.png")));
		bottoneConferma.setBounds(132, 506, 280, 48);
		bottoneConferma.setOpaque(false);
		bottoneConferma.setBorderPainted(false);
		bottoneConferma.setContentAreaFilled(false);
		bottoneConferma.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				confermaNuovaPasswordReimpostaPassword();
			}
		});
		bottoneConferma.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneConferma.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneConfermaFocus.png")));
				setCursor(new Cursor(Cursor.HAND_CURSOR));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneConferma.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneConferma.png")));
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
		});
		add(bottoneConferma);
	}
	
	//Metodi
	
	public void mostraErroreLePasswordNonCorrispondonoReimpostaPassword2() {
		testoMessaggioErrore.setForeground(Color.RED);
		testoMessaggioErrore.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoMessaggioErrore.setText("Le password non corrispondono!");
		testoMessaggioErrore.setVisible(true);
	}
	
	public void mostraErrorePasswordTroppoCortaReimpostaPassword2() {
		testoMessaggioErrore.setForeground(Color.RED);
		testoMessaggioErrore.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoMessaggioErrore.setText("La password deve essere di almeno 6 caratteri!");
		testoMessaggioErrore.setVisible(true);
	}
	
	public void mostraErroreCodiceDiVerificaNonValidoReimpostaPassword2() {
		testoMessaggioErrore.setForeground(Color.RED);
		testoMessaggioErrore.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoMessaggioErrore.setText("Il codice di verifica NON valido!");
		testoMessaggioErrore.setVisible(true);
	}
	
	public void mostraAvvisoPasswordImpostataConSuccessoReimpostaPassword2() {
		testoMessaggioErrore.setForeground(new Color(64,151,0));
		testoMessaggioErrore.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoMessaggioErrore.setText("Password impostata con successo!");
		testoMessaggioErrore.setVisible(true);
	}
	
	public void resettaErroriReimpostaPassword2() {
		testoMessaggioErrore.setVisible(false);
	}
	
	private void confermaNuovaPasswordReimpostaPassword() {
		String codiceVerifica = new String(textFieldCodiceVerifica.getText());
		String password = new String(passwordFieldNuovaPassword.getPassword());
		String passwordControllo = new String(passwordFieldConfermaNuovaPassword.getPassword());
		
		if(password.equals(passwordControllo))
			ctrl.impostaPassword(codiceVerifica, passwordFieldNuovaPassword.getPassword());
		else
			mostraErroreLePasswordNonCorrispondonoReimpostaPassword2();
	}

}
