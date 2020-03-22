package gui.pannelliSchermataPrincipale.raffinazioni;

import java.awt.Color;
import java.awt.Font;

import javax.swing.JCheckBox;
import javax.swing.JPanel;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

public class pannelloRaffinazioneAttrazioni extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JCheckBox checkBoxCinema;
	private JCheckBox checkBoxMuseo;
	private JCheckBox checkBoxPiscina;
	private JCheckBox checkBoxShopping;
	private JCheckBox checkBoxParcoGiochi;
	private JCheckBox checkBoxBar_Lounge;
	private JCheckBox checkBoxMonumento;
	
	@Override
	public String toString() {
		String raffinazioni = "";
		
		if(checkBoxCinema.isSelected())
			raffinazioni = raffinazioni.concat("Cinema,");
		if(checkBoxMuseo.isSelected())
			raffinazioni = raffinazioni.concat("Museo,");
		if(checkBoxPiscina.isSelected())
			raffinazioni = raffinazioni.concat("Piscina,");
		if(checkBoxShopping.isSelected())
			raffinazioni = raffinazioni.concat("Shopping,");
		if(checkBoxParcoGiochi.isSelected())
			raffinazioni = raffinazioni.concat("ParcoGiochi,");
		if(checkBoxBar_Lounge.isSelected())
			raffinazioni = raffinazioni.concat("Bar/Lounge,");
		if(checkBoxMonumento.isSelected())
			raffinazioni = raffinazioni.concat("Monumento,");
		
		return raffinazioni;
	}
	
	
	public pannelloRaffinazioneAttrazioni() {
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentHidden(ComponentEvent e) {
				rimuoviTutteLeSpunte();
			}
		});
		setLayout(null);
		setBackground(Color.WHITE);
		setSize(506,106);
		
		generaCheckBoxCinema();
		generaCheckBoxMuseo();
		generaCheckBoxPiscina();
		generaCheckBoxShopping();
		generaCheckBoxParcoGiochi();
		generaCheckBoxBar_Lounge();
		generaCheckBoxMonumento();
	}

	private void generaCheckBoxMonumento() {
		checkBoxMonumento = new JCheckBox("Monumento");
		checkBoxMonumento.setBackground(Color.WHITE);
		checkBoxMonumento.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxMonumento.setBounds(30, 62, 129, 23);
		checkBoxMonumento.setFocusPainted(false);;
		add(checkBoxMonumento);
	}

	private void generaCheckBoxBar_Lounge() {
		checkBoxBar_Lounge = new JCheckBox("Bar/Lounge");
		checkBoxBar_Lounge.setBackground(Color.WHITE);
		checkBoxBar_Lounge.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxBar_Lounge.setBounds(378, 35, 129, 23);
		checkBoxBar_Lounge.setFocusPainted(false);
		add(checkBoxBar_Lounge);
	}

	private void generaCheckBoxParcoGiochi() {
		checkBoxParcoGiochi = new JCheckBox("Parco Giochi");
		checkBoxParcoGiochi.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxParcoGiochi.setBackground(Color.WHITE);
		checkBoxParcoGiochi.setBounds(204, 35, 140, 23);
		checkBoxParcoGiochi.setFocusPainted(false);
		add(checkBoxParcoGiochi);
	}

	private void generaCheckBoxShopping() {
		checkBoxShopping = new JCheckBox("Shopping");
		checkBoxShopping.setBackground(Color.WHITE);
		checkBoxShopping.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxShopping.setBounds(30, 35, 140, 23);
		checkBoxShopping.setFocusPainted(false);
		add(checkBoxShopping);
	}

	private void generaCheckBoxPiscina() {
		checkBoxPiscina = new JCheckBox("Piscina");
		checkBoxPiscina.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxPiscina.setBackground(Color.WHITE);
		checkBoxPiscina.setBounds(378, 8, 108, 23);
		checkBoxPiscina.setFocusPainted(false);
		add(checkBoxPiscina);
	}

	private void generaCheckBoxMuseo() {
		checkBoxMuseo = new JCheckBox("Museo");
		checkBoxMuseo.setBackground(Color.WHITE);
		checkBoxMuseo.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxMuseo.setBounds(204, 8, 129, 23);
		checkBoxMuseo.setFocusPainted(false);
		add(checkBoxMuseo);
	}

	private void generaCheckBoxCinema() {
		checkBoxCinema = new JCheckBox("Cinema");
		checkBoxCinema.setBackground(Color.WHITE);
		checkBoxCinema.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxCinema.setBounds(30, 8, 129, 23);
		checkBoxCinema.setFocusPainted(false);
		add(checkBoxCinema);
	}
	
	//Metodi

	public void rimuoviTutteLeSpunte() {
		checkBoxBar_Lounge.setSelected(false);
		checkBoxCinema.setSelected(false);
		checkBoxMonumento.setSelected(false);
		checkBoxMuseo.setSelected(false);
		checkBoxParcoGiochi.setSelected(false);
		checkBoxPiscina.setSelected(false);
		checkBoxShopping.setSelected(false);
	}
}
