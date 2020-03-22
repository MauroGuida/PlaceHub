package oggetti;

import javax.swing.JPanel;

import java.awt.Color;
import javax.swing.JLabel;
import java.awt.Font;
import java.awt.Image;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;

import javax.swing.ImageIcon;
import javax.imageio.ImageIO;
import javax.swing.border.LineBorder;

import errori.NumeroStelleNonValidoException;
import res.WrapLayout;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

public class Locale extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private String codBusiness;
	private String nome;
	private String indirizzo;
	private String telefono;
	private String partitaIVA;
	private String descrizione;
	private String raffinazioni;
	private String urlImmagine;
	
	private JPanel stelle;
	private JLabel testoNome;
	private JLabel testoLuogo;
	private JLabel immagineLocale;
	
	private ArrayList<File> listaImmagini;
	
	public Locale(String nome, String indirizzo, String codBusiness,
				  String telefono, String partitaIVA, String descrizione, String urlImmagine) {
		this.codBusiness = codBusiness;
		this.nome = nome;
		this.indirizzo = indirizzo;
		this.urlImmagine = urlImmagine;
		this.telefono = telefono;
		this.partitaIVA = partitaIVA;
		this.descrizione = descrizione;
		listaImmagini = new ArrayList<File>();
		
		generaEsteticaPannello();
		
		generaStelle();
		generaTestoNome();
		generaTestoLuogo();
		generaImmagineLocale();
		
		generaLayout();
	}
	
	private void generaEsteticaPannello() {
		setBackground(Color.WHITE);
		setSize(400,250);
		setVisible(true);
		setBorder(new LineBorder(Color.DARK_GRAY,1));
	}
	
	

	private void generaStelle() {
		stelle = new JPanel();
		stelle.setBackground(Color.WHITE);
		stelle.setLayout(new WrapLayout(WrapLayout.LEFT, 1 ,1));
	}

	
	private void generaTestoLuogo() {
		testoLuogo = new JLabel(this.indirizzo);
		testoLuogo.setFont(new Font("Roboto", Font.PLAIN, 17));
	}

	private void generaTestoNome() {
		testoNome = new JLabel(this.nome);
		testoNome.setFont(new Font("Roboto", Font.PLAIN, 17));
	}

	private void generaImmagineLocale() {
		immagineLocale = new JLabel();
		try {
			URL url = new URL(this.urlImmagine);
			Image immagine = new ImageIcon(ImageIO.read(url)).getImage();
			Image immagineScalata = immagine.getScaledInstance(374, 180, java.awt.Image.SCALE_SMOOTH);
			immagineLocale.setIcon(new ImageIcon(immagineScalata));
		}catch(IOException e) {
			e.printStackTrace();
		}
	}

	private void generaLayout() {
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(12)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(testoNome, GroupLayout.DEFAULT_SIZE, 185, Short.MAX_VALUE)
							.addGap(189))
						.addComponent(immagineLocale, GroupLayout.DEFAULT_SIZE, 374, Short.MAX_VALUE)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(195)
							.addComponent(testoLuogo, GroupLayout.DEFAULT_SIZE, 179, Short.MAX_VALUE))
						.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 170, GroupLayout.PREFERRED_SIZE))
					.addGap(12))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(16)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(179)
							.addComponent(testoNome, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(immagineLocale, GroupLayout.DEFAULT_SIZE, 180, Short.MAX_VALUE)
							.addGap(23))
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(179)
							.addComponent(testoLuogo, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE)))
					.addGap(6)
					.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE))
		);
		setLayout(groupLayout);
	}
	
	//generaCANI
	public void setCodBusiness(String codBusiness) {
		this.codBusiness = codBusiness;
	}


	public void setNome(String nome) {
		this.nome = nome;
	}


	public void setIndirizzo(String indirizzo) {
		this.indirizzo = indirizzo;
	}


	public void setTelefono(String telefono) {
		this.telefono = telefono;
	}


	public void setPartitaIVA(String partitaIVA) {
		this.partitaIVA = partitaIVA;
	}


	public void setDescrizione(String descrizione) {
		this.descrizione = descrizione;
	}


	public void setUrlImmagine(String urlImmagine) {
		this.urlImmagine = urlImmagine;
	}


	public void setImmagineLocale(JLabel immagineLocale) {
		this.immagineLocale = immagineLocale;
	}
	
	public void setRaffinazini(String raffinazini) {
		this.raffinazioni = raffinazini;
	}
	
	//METODI
	
	
	public void aggiungiImmagini(File nuovaImmagini) {
		listaImmagini.add(nuovaImmagini);
	}

	public int getNumeroImmagini() {
		return listaImmagini.size();
	}
	
	public void aggiungiStelle(int numStelle, boolean mezzaStella) throws NumeroStelleNonValidoException{
		if((numStelle==5 && mezzaStella) || numStelle>5)
			throw new NumeroStelleNonValidoException();
		
		for(int i=0; i<numStelle; i++) {
			JLabel stellaPiena = new JLabel();
			stellaPiena.setIcon(new ImageIcon(Locale.class.getResource("/Icone/stella.png")));
			stelle.add(stellaPiena);
		}
		
		if(mezzaStella) {
			JLabel stellaPiena = new JLabel();
			stellaPiena.setIcon(new ImageIcon(Locale.class.getResource("/Icone/mezzaStella.png")));
			stelle.add(stellaPiena);
		}
	}

}
