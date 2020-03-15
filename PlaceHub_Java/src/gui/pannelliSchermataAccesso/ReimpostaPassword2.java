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

public class ReimpostaPassword2 extends JPanel {
	private static final long serialVersionUID = 1L;

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
	
	private Controller ctrl;
	
	public ReimpostaPassword2(Controller Ctrl) {
		this.ctrl = Ctrl;
		setBackground(Color.WHITE);
		setSize(550, 650);
		setLayout(null);
		setVisible(false);
		
		labelComunicazioneUtenteReimpostaPassword2 = new JLabel("<html><center><p><b>Inserire il codice ricevuto via Email</b></p>"
				+ "<p>\n</p>"
				+ "<p><font size=\"4\"><i>Nel caso non si dovesse ricevere un'Email entro 10 minuti si prega di"
				+ "controllare l'indirizzo inserito e riprovare!</i></font></p></center></html>");
		labelComunicazioneUtenteReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 16));
		labelComunicazioneUtenteReimpostaPassword2.setBounds(80, 62, 383, 117);
		add(labelComunicazioneUtenteReimpostaPassword2);
		
		generaBottoneConfermaReimpostaPassword2();
		generaBottoneIndietroReimpostaPassword2();
		generaFieldCodiceVerificaReimpostaPassword2();
		generaFieldNuovaPasswordReimpostaPassword2();
		generaFieldConfermaNuovaPasswordReimpostaPassword2();
		generaLabelMessaggioErroreReimpostaPassword2();
	}
	
	private void generaLabelMessaggioErroreReimpostaPassword2() {
		labelMessaggioErroreReimpostaPassword2 = new JLabel("Le password non corrispondono!");
		labelMessaggioErroreReimpostaPassword2.setVisible(false);
		labelMessaggioErroreReimpostaPassword2.setHorizontalAlignment(SwingConstants.CENTER);
		labelMessaggioErroreReimpostaPassword2.setForeground(Color.RED);
		labelMessaggioErroreReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 16));
		labelMessaggioErroreReimpostaPassword2.setBounds(80, 442, 383, 32);
		add(labelMessaggioErroreReimpostaPassword2);
	}

	private void generaFieldConfermaNuovaPasswordReimpostaPassword2() {
		testoConfermaNuovaPasswordReimpostaPassword2 = new JLabel("");
		testoConfermaNuovaPasswordReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/ConfermaNuovaPassword.png")));
		testoConfermaNuovaPasswordReimpostaPassword2.setBounds(80, 370, 250, 20);
		add(testoConfermaNuovaPasswordReimpostaPassword2);
		
		passwordFieldConfermaNuovaPasswordReimpostaPassword2 = new JPasswordField();
		passwordFieldConfermaNuovaPasswordReimpostaPassword2.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if(e.getKeyCode() == KeyEvent.VK_ENTER) {
					confermaNuovaPasswordReimpostaPassword();
				}
			}
		});
		passwordFieldConfermaNuovaPasswordReimpostaPassword2.setBounds(80, 398, 383, 32);
		passwordFieldConfermaNuovaPasswordReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 17));
		passwordFieldConfermaNuovaPasswordReimpostaPassword2.setBackground(new Color(255,255,255));
		passwordFieldConfermaNuovaPasswordReimpostaPassword2.setBorder(new LineBorder(new Color(255,255,255),1));
		add(passwordFieldConfermaNuovaPasswordReimpostaPassword2);
		
		lineaConfermaNuovaPasswordReimpostaPassword2 = new JLabel("");
		lineaConfermaNuovaPasswordReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaConfermaNuovaPasswordReimpostaPassword2.setBounds(80, 430, 383, 1);
		add(lineaConfermaNuovaPasswordReimpostaPassword2);
	}

	private void generaFieldNuovaPasswordReimpostaPassword2() {
		testoNuovaPasswordReimpostaPassword2 = new JLabel("");
		testoNuovaPasswordReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/Nuova Password.png")));
		testoNuovaPasswordReimpostaPassword2.setBounds(80, 280, 185, 20);
		add(testoNuovaPasswordReimpostaPassword2);
		
		passwordFieldNuovaPasswordReimpostaPassword2 = new JPasswordField();
		passwordFieldNuovaPasswordReimpostaPassword2.setBounds(80, 308, 383, 32);
		passwordFieldNuovaPasswordReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 17));
		passwordFieldNuovaPasswordReimpostaPassword2.setBackground(new Color(255,255,255));
		passwordFieldNuovaPasswordReimpostaPassword2.setBorder(new LineBorder(new Color(255,255,255),1));
		add(passwordFieldNuovaPasswordReimpostaPassword2);
		
		lineaNuovaPasswordReimpostaPassword2 = new JLabel("");
		lineaNuovaPasswordReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaNuovaPasswordReimpostaPassword2.setBounds(80, 340, 383, 1);
		add(lineaNuovaPasswordReimpostaPassword2);
	}

	private void generaFieldCodiceVerificaReimpostaPassword2() {
		testoCodiceVerificaReimpostaPassword2 = new JLabel("");
		testoCodiceVerificaReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/CodiceVerifica.png")));
		testoCodiceVerificaReimpostaPassword2.setBounds(80, 190, 140, 20);
		add(testoCodiceVerificaReimpostaPassword2);
		
		textFieldCodiceVerificaReimpostaPassword2 = new JTextField();
		textFieldCodiceVerificaReimpostaPassword2.setBounds(80, 218, 383, 32);
		textFieldCodiceVerificaReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldCodiceVerificaReimpostaPassword2.setBackground(new Color(255,255,255));
		textFieldCodiceVerificaReimpostaPassword2.setBorder(new LineBorder(new Color(255,255,255),1));
		add(textFieldCodiceVerificaReimpostaPassword2);
		textFieldCodiceVerificaReimpostaPassword2.setColumns(10);
		
		lineaCodiceVerificaReimpostaPassword2 = new JLabel("");
		lineaCodiceVerificaReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaCodiceVerificaReimpostaPassword2.setBounds(80, 250, 383, 1);
		add(lineaCodiceVerificaReimpostaPassword2);
	}

	private void generaBottoneIndietroReimpostaPassword2() {
		bottoneTornaIndietroReimpostaPassword2 = new JButton("");
		bottoneTornaIndietroReimpostaPassword2.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				Controller.getSchermataAccessoFrame().mostraPannelloLogin();
				setVisible(false);
				
				resettaErroriReimpostaPassword2();
			}
		});
		bottoneTornaIndietroReimpostaPassword2.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/arrow.png")));
		bottoneTornaIndietroReimpostaPassword2.setBounds(12, 595, 43, 43);
		bottoneTornaIndietroReimpostaPassword2.setOpaque(false);
		bottoneTornaIndietroReimpostaPassword2.setContentAreaFilled(false);
		bottoneTornaIndietroReimpostaPassword2.setBorderPainted(false);
		add(bottoneTornaIndietroReimpostaPassword2);
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
		add(bottoneConfermaReimpostaPassword2);
	}
	
	//Metodi
	
	public void mostraErroreLePasswordNonCorrispondonoReimpostaPassword2() {
		labelMessaggioErroreReimpostaPassword2.setForeground(Color.RED);
		labelMessaggioErroreReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 16));
		labelMessaggioErroreReimpostaPassword2.setText("Le password non corrispondono!");
		labelMessaggioErroreReimpostaPassword2.setVisible(true);
	}
	
	public void mostraErrorePasswordTroppoCortaReimpostaPassword2() {
		labelMessaggioErroreReimpostaPassword2.setForeground(Color.RED);
		labelMessaggioErroreReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 16));
		labelMessaggioErroreReimpostaPassword2.setText("La password deve essere di almeno 6 caratteri!");
		labelMessaggioErroreReimpostaPassword2.setVisible(true);
	}
	
	public void mostraErroreCodiceDiVerificaNonValidoReimpostaPassword2() {
		labelMessaggioErroreReimpostaPassword2.setForeground(Color.RED);
		labelMessaggioErroreReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 16));
		labelMessaggioErroreReimpostaPassword2.setText("Il codice di verifica NON valido!");
		labelMessaggioErroreReimpostaPassword2.setVisible(true);
	}
	
	public void mostraAvvisoPasswordImpostataConSuccessoReimpostaPassword2() {
		labelMessaggioErroreReimpostaPassword2.setForeground(new Color(64,151,0));
		labelMessaggioErroreReimpostaPassword2.setFont(new Font("Roboto", Font.PLAIN, 16));
		labelMessaggioErroreReimpostaPassword2.setText("Password impostata con successo!");
		labelMessaggioErroreReimpostaPassword2.setVisible(true);
	}
	
	public void resettaErroriReimpostaPassword2() {
		labelMessaggioErroreReimpostaPassword2.setVisible(false);
	}
	
	private void confermaNuovaPasswordReimpostaPassword() {
		String codiceVerifica = new String(textFieldCodiceVerificaReimpostaPassword2.getText());
		String password = new String(passwordFieldNuovaPasswordReimpostaPassword2.getPassword());
		String passwordControllo = new String(passwordFieldConfermaNuovaPasswordReimpostaPassword2.getPassword());
		
		if(password.equals(passwordControllo))
			ctrl.impostaPassword(codiceVerifica, passwordFieldNuovaPasswordReimpostaPassword2.getPassword());
		else
			mostraErroreLePasswordNonCorrispondonoReimpostaPassword2();
	}

}
