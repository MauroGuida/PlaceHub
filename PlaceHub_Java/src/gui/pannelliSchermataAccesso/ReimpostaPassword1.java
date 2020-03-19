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

public class ReimpostaPassword1 extends JPanel {
	private static final long serialVersionUID = 1L;

	private JLabel testoEmailReimpostaPassword1;
	private JTextField textFieldEmailReimpostaPassword1;
	private JLabel lineaEmailReimpostaPassword1;
	private JButton bottoneInviaCodiceReimpostaPassword1;
	private JButton bottoneTornaIndietroReimpostaPassword1;
	private JLabel labelComunicazioneUtenteReimpostaPassword1;
	private JLabel labelErroreReimpostaPassword1;
	
	private Controller ctrl;
	
	public ReimpostaPassword1(Controller Ctrl) {
		this.ctrl = Ctrl;
		setBackground(Color.WHITE);
		setSize(550, 650);
		setLayout(null);
		setVisible(false);
		
		generaFieldEmailReimpostaPassword1();
		generaBottoneInviaCodiceReimpostaPassword1();
		generaBottoneIndietroReimpostaPassword1();
		generaLabelComunicazioneUtenteReimpostaPassword1();
		generaLabelErroreReimpostaPassword1();
	}
	
	public void generaLabelErroreReimpostaPassword1() {
		labelErroreReimpostaPassword1 = new JLabel("Non siamo riusciti a mandarti alcuna Email, riprova!");
		labelErroreReimpostaPassword1.setVisible(false);
		labelErroreReimpostaPassword1.setFont(new Font("Roboto", Font.PLAIN, 16));
		labelErroreReimpostaPassword1.setForeground(Color.RED);
		labelErroreReimpostaPassword1.setHorizontalAlignment(SwingConstants.CENTER);
		labelErroreReimpostaPassword1.setBounds(80, 360, 383, 32);
		add(labelErroreReimpostaPassword1);
	}

	public void generaLabelComunicazioneUtenteReimpostaPassword1() {
		labelComunicazioneUtenteReimpostaPassword1 = new JLabel("<html><p>Si prega di inserire l'indirizzo Email di registrazione per consentirci di verificare l'account.</p>"
				+ "\n"
				+ "<p><center><b>Riceverai via email un codice di verifica entro 10 minuti.</b></center></p></html>");
		labelComunicazioneUtenteReimpostaPassword1.setVerticalAlignment(SwingConstants.TOP);
		labelComunicazioneUtenteReimpostaPassword1.setFont(new Font("Roboto", Font.PLAIN, 16));
		labelComunicazioneUtenteReimpostaPassword1.setBounds(80, 100, 383, 114);
		add(labelComunicazioneUtenteReimpostaPassword1);
	}
	
	private void generaBottoneIndietroReimpostaPassword1() {
		bottoneTornaIndietroReimpostaPassword1 = new JButton("");
		bottoneTornaIndietroReimpostaPassword1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				Controller.getSchermataAccessoFrame().mostraPannelloLogin();
				setVisible(false);
				
				resettaErroriReimpostaPassword1();
			}
		});
		bottoneTornaIndietroReimpostaPassword1.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/arrow.png")));
		bottoneTornaIndietroReimpostaPassword1.setBounds(12, 595, 43, 43);
		bottoneTornaIndietroReimpostaPassword1.setOpaque(false);
		bottoneTornaIndietroReimpostaPassword1.setContentAreaFilled(false);
		bottoneTornaIndietroReimpostaPassword1.setBorderPainted(false);
		add(bottoneTornaIndietroReimpostaPassword1);
	}

	public void generaBottoneInviaCodiceReimpostaPassword1() {
		bottoneInviaCodiceReimpostaPassword1 = new JButton("");
		bottoneInviaCodiceReimpostaPassword1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				invioCodiceReimpostaPassword();
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
		add(bottoneInviaCodiceReimpostaPassword1);
	}

	private void generaFieldEmailReimpostaPassword1() {
		testoEmailReimpostaPassword1 = new JLabel("");
		testoEmailReimpostaPassword1.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/testoEmail.png")));
		testoEmailReimpostaPassword1.setBounds(80, 262, 140, 20);
		add(testoEmailReimpostaPassword1);
		
		textFieldEmailReimpostaPassword1 = new JTextField();
		textFieldEmailReimpostaPassword1.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if(e.getKeyCode() == KeyEvent.VK_ENTER) 
					invioCodiceReimpostaPassword();
			}
		});
		textFieldEmailReimpostaPassword1.setBounds(80, 290, 383, 32);
		textFieldEmailReimpostaPassword1.setFont(new Font("Roboto", Font.PLAIN, 17));
		textFieldEmailReimpostaPassword1.setBackground(new Color(255,255,255));
		textFieldEmailReimpostaPassword1.setBorder(new LineBorder(new Color(255,255,255),1));
		add(textFieldEmailReimpostaPassword1);
		textFieldEmailReimpostaPassword1.setColumns(10);
		
		lineaEmailReimpostaPassword1 = new JLabel("");
		lineaEmailReimpostaPassword1.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/lineaTesto.png")));
		lineaEmailReimpostaPassword1.setBounds(80, 322, 383, 1);
		add(lineaEmailReimpostaPassword1);
	}
	
	//Metodo
	
	public void mostraErroreReimpostaPassword1() {
		labelErroreReimpostaPassword1.setVisible(true);
	}
	
	public void resettaErroriReimpostaPassword1() {
		labelErroreReimpostaPassword1.setVisible(false);
	}
	
	private void invioCodiceReimpostaPassword() {
		ctrl.richediGenerazioneCodiceVerificaSchermataAccessoReimpostaPassword(textFieldEmailReimpostaPassword1.getText());
		ctrl.invioEmailCodiceVerificaSchermataAccessoReimpostaPassword(textFieldEmailReimpostaPassword1.getText());
	}
}
