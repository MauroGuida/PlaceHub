package frameGUI;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;

import frameGUI.pannelliSchermataAccesso.Bottoni;
import frameGUI.pannelliSchermataAccesso.Login;
import frameGUI.pannelliSchermataAccesso.Registrazione;
import frameGUI.pannelliSchermataAccesso.ReimpostaPassword1;
import frameGUI.pannelliSchermataAccesso.ReimpostaPassword2;
import gestione.Controller;

import java.awt.Color;

import javax.swing.ImageIcon;
import java.awt.geom.RoundRectangle2D;
import java.util.Random;
import java.util.Timer;
import java.util.TimerTask;

import javax.swing.JLabel;
import javax.swing.SwingConstants;

public class SchermataAccesso extends JFrame {
	private static final long serialVersionUID = 1L;
	
	private Controller ctrl;
	
	private JPanel pannelloInferiore;
	private JLabel immaginiSinistra;
	
	private Bottoni pannelloBottoni;
	private Login pannelloLogin;
	private Registrazione pannelloRegistrazione;
	private ReimpostaPassword1 pannelloReimpostaPassword1;
	private ReimpostaPassword2 pannelloReimpostaPassword2;
	
	public SchermataAccesso(Controller ctrl) {
		this.ctrl=ctrl;
		
		impostazioniFrame();
		generaPannelloBackground();
		generaPannelloBottoni();
		generaPannelloLogin();
		generaPannelloRegistrazione();
		generaPannelloReimpostaPassword1(ctrl);
		generaPannelloReimpostaPassword2(ctrl);
	}

	private void generaPannelloReimpostaPassword2(Controller ctrl) {
		pannelloReimpostaPassword2 = new ReimpostaPassword2(ctrl);
		pannelloReimpostaPassword2.setBounds(550, 0, 550, 650);
		add(pannelloReimpostaPassword2);
	}

	private void generaPannelloReimpostaPassword1(Controller ctrl) {
		pannelloReimpostaPassword1 = new ReimpostaPassword1(ctrl);
		pannelloReimpostaPassword1.setBounds(550, 0, 550, 650);
		add(pannelloReimpostaPassword1);
	}

	private void generaPannelloRegistrazione() {
		pannelloRegistrazione = new Registrazione(ctrl);
		pannelloRegistrazione.setBounds(550, 0, 550, 650);
		add(pannelloRegistrazione);
	}

	private void generaPannelloLogin() {
		pannelloLogin = new Login(ctrl);
		pannelloLogin.setBounds(550, 0, 550, 650);
		add(pannelloLogin);
	}

	private void generaPannelloBottoni() {
		pannelloBottoni = new Bottoni();
		pannelloBottoni.setBounds(550, 0, 550, 36);
		add(pannelloBottoni);
	}
	
	private void impostazioniFrame() {
		setLocationRelativeTo(null);
		setUndecorated(true);
		setShape(new RoundRectangle2D.Double(15, 0, 1100, 650, 30, 30));
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		setSize(1100,650);
		setLocationRelativeTo(null);
	}
	
	private void generaPannelloBackground() {
		pannelloInferiore = new JPanel();
		pannelloInferiore.setBackground(Color.GRAY);
		pannelloInferiore.setBorder(new EmptyBorder(5, 5, 5, 5));
		pannelloInferiore.setLayout(null);
		setContentPane(pannelloInferiore);
		
		immaginiSinistra = new JLabel("");
		immaginiSinistra.setHorizontalAlignment(SwingConstants.CENTER);
		immaginiSinistra.setBounds(0, 0, 550, 650);
		pannelloInferiore.add(immaginiSinistra);
		
		gestioneRotazioneImmagini();
	}
	
	private void gestioneRotazioneImmagini() {
		Timer timer = new Timer();
		timer.scheduleAtFixedRate(new TimerTask() {
			Random rand = new Random();
			private int i = rand.nextInt(3);
			  @Override
			  public void run() {
					immaginiSinistra.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/immagini/"+ i +".png")));
					if(i<2)
						i++;
					else
						i=0;
			  }
		}, 0, 5000);
	}
	
	//Metodi

	public void mostraErroreNonPossonoEsserciCampiVuotiRegistrazione() {
		pannelloRegistrazione.mostraErroreNonPossonoEsserciCampiVuotiRegistrazione();
	}
	
	public void mostraConfermaRegistrazione() {
		pannelloRegistrazione.mostraConfermaRegistrazione();
	}

	public void mostraErrorePasswordNonValidaRegistrazione() {
		pannelloRegistrazione.mostraErrorePasswordNonValidaRegistrazione();
	}

	public void mostraErroreEmailNonValidaRegistrazione() {
		pannelloRegistrazione.mostraErroreEmailNonValidaRegistrazione();
	}
	
	public void mostraErroreEmailGiaInUsoRegistrazione() {
		pannelloRegistrazione.mostraErroreEmailGiaInUsoRegistrazione();
	}

	public void mostraErroreUsernameNonDisponibileRegistrazione() {
		pannelloRegistrazione.mostraErroreUsernameNonDisponibileRegistrazione();
	}
	
	public void mostraErroreDataDiNascitaNonValida() {
		pannelloRegistrazione.mostraErroreDataDiNascitaNonValida();
		immaginiSinistra.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/immagini/GrandeGiove.png")));
	}
	
	public void resettaErroriRegistrazione() {
		pannelloRegistrazione.resettaErroriRegistrazione();
	}
	
	public void mostraErroreReimpostaPassword1() {
		pannelloReimpostaPassword1.mostraErroreReimpostaPassword1();
	}
	
	public void mostraErroreUsernamePassword(boolean controllo) {
		pannelloLogin.mostraErroreUsernamePassword(controllo);
	}
	
	public void mostraErroreLePasswordNonCorrispondonoReimpostaPassword2() {
		pannelloReimpostaPassword2.mostraErroreLePasswordNonCorrispondonoReimpostaPassword2();
	}
	
	public void mostraErrorePasswordTroppoCortaReimpostaPassword2() {
		pannelloReimpostaPassword2.mostraErrorePasswordTroppoCortaReimpostaPassword2();
	}
	
	public void mostraErroreCodiceDiVerificaNonValidoReimpostaPassword2() {
		pannelloReimpostaPassword2.mostraErroreCodiceDiVerificaNonValidoReimpostaPassword2();
	}
	
	public void mostraAvvisoPasswordImpostataConSuccessoReimpostaPassword2() {
		pannelloReimpostaPassword2.mostraAvvisoPasswordImpostataConSuccessoReimpostaPassword2();
	}
	
	public void mostraPannelloLogin() {
		pannelloLogin.setVisible(true);
	}
	
	public void nascondiPannelloLogin() {
		pannelloLogin.setVisible(false);
	}
	
	public void mostraPannelloRegistrazione() {
		pannelloRegistrazione.setVisible(true);
	}
	
	public void nascondiPannelloRegistrazione() {
		pannelloRegistrazione.setVisible(false);
	}
	
	public void mostraPannelloReimpostaPassword1() {
		pannelloReimpostaPassword1.setVisible(true);
	}
	
	public void nascondiPannelloReimpostaPassword1() {
		pannelloReimpostaPassword1.setVisible(false);
	}
	
	public void mostraPannelloReimpostaPassword2() {
		pannelloReimpostaPassword2.setVisible(true);
	}
	
	public void nascondiPannelloReimpostaPassword2() {
		pannelloReimpostaPassword2.setVisible(false);
	}
}
