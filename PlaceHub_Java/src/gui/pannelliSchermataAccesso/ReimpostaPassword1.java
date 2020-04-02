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
import javax.swing.JTextField;
import javax.swing.SwingConstants;
import javax.swing.border.LineBorder;

import gestione.Controller;
import gui.SchermataAccesso;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

public class ReimpostaPassword1 extends JPanel {
	private static final long serialVersionUID = 1L;

	private JLabel testoEmail;
	private JTextField textFieldEmail;
	private JLabel lineaEmail;
	private JButton bottoneInviaCodice;
	private JButton bottoneTornaIndietro;
	private JLabel testoComunicazioneUtente;
	private JLabel testoErrore;
	
	private Controller ctrl;
	
	public ReimpostaPassword1(Controller Ctrl) {
		this.ctrl = Ctrl;
		setBackground(Color.WHITE);
		setSize(550, 650);
		setLayout(null);
		setVisible(false);
		
		svuotaCampi();
		
		generaCampoEmail();
		generaBottoneInviaCodice();
		generaBottoneIndietro();
		generaTestoComunicazioneUtente();
		generaTestoErrore();
	}

	private void svuotaCampi() {
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentShown(ComponentEvent e) {
				pulisciPannello();
			}
		});
	}
	
	public void generaTestoErrore() {
		testoErrore = new JLabel("Non siamo riusciti a mandarti alcuna Email, riprova!");
		testoErrore.setVisible(false);
		testoErrore.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoErrore.setForeground(Color.RED);
		testoErrore.setHorizontalAlignment(SwingConstants.CENTER);
		testoErrore.setBounds(80, 360, 383, 32);
		add(testoErrore);
	}

	public void generaTestoComunicazioneUtente() {
		testoComunicazioneUtente = new JLabel("<html><p>Si prega di inserire l'indirizzo Email di registrazione per consentirci di verificare l'account.</p>"
				+ "\n"
				+ "<p><center><b>Riceverai via email un codice di verifica entro 10 minuti.</b></center></p></html>");
		testoComunicazioneUtente.setVerticalAlignment(SwingConstants.TOP);
		testoComunicazioneUtente.setFont(new Font("Roboto", Font.PLAIN, 16));
		testoComunicazioneUtente.setBounds(80, 100, 383, 114);
		add(testoComunicazioneUtente);
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
				
				resettaErroriReimpostaPassword1();
			}
		});
		add(bottoneTornaIndietro);
	}

	public void generaBottoneInviaCodice() {
		bottoneInviaCodice = new JButton("");
		bottoneInviaCodice.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneInviaCodice.png")));
		bottoneInviaCodice.setBounds(132, 420, 280, 48);
		bottoneInviaCodice.setOpaque(false);
		bottoneInviaCodice.setBorderPainted(false);
		bottoneInviaCodice.setContentAreaFilled(false);
		bottoneInviaCodice.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				invioCodiceReimpostaPassword();
			}
		});
		bottoneInviaCodice.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneInviaCodice.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneInviaCodiceFocus.png")));
				setCursor(new Cursor(Cursor.HAND_CURSOR));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneInviaCodice.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/bottoneInviaCodice.png")));
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
		});
		add(bottoneInviaCodice);
	}

	private void generaCampoEmail() {
		testoEmail = new JLabel("");
		testoEmail.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoEmail.png")));
		testoEmail.setBounds(80, 262, 140, 20);
		add(testoEmail);
		
		textFieldEmail = new JTextField();
		textFieldEmail.setBounds(80, 290, 383, 32);
		textFieldEmail.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldEmail.setBackground(new Color(255,255,255));
		textFieldEmail.setBorder(new LineBorder(new Color(255,255,255),1));
		textFieldEmail.setColumns(10);
		textFieldEmail.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& textFieldEmail.getText().length() <= 99) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE || e.getKeyChar() <= '.' || e.getKeyChar() <= '@')
					textFieldEmail.setEditable(true);
				else
					textFieldEmail.setEditable(false);
				
				if(e.getKeyCode() == KeyEvent.VK_ENTER) 
					invioCodiceReimpostaPassword();
			}
		});
		add(textFieldEmail);
		
		
		lineaEmail = new JLabel("");
		lineaEmail.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaEmail.setBounds(80, 322, 383, 1);
		add(lineaEmail);
	}
	
	//Metodi
	
	public void mostraErroreReimpostaPassword1() {
		testoErrore.setVisible(true);
	}
	
	public void resettaErroriReimpostaPassword1() {
		testoErrore.setVisible(false);
	}
	
	private void invioCodiceReimpostaPassword() {
		ctrl.richediGenerazioneCodiceVerificaSchermataAccessoReimpostaPassword(textFieldEmail.getText());
		ctrl.invioEmailCodiceVerificaSchermataAccessoReimpostaPassword(textFieldEmail.getText());
	}

	private void pulisciPannello() {
		textFieldEmail.setText("");
	}
}
