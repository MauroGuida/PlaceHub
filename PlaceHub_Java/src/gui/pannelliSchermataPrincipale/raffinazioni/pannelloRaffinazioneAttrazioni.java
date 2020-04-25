package gui.pannelliSchermataPrincipale.raffinazioni;

import java.awt.Color;
import java.awt.Font;

import javax.swing.JCheckBox;
import javax.swing.JPanel;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

public class pannelloRaffinazioneAttrazioni extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JCheckBox checkBoxCinema;
	private JCheckBox checkBoxMuseo;
	private JCheckBox checkBoxPiscina;
	private JCheckBox checkBoxShopping;
	private JCheckBox checkBoxParcoGiochi;
	private JCheckBox checkBoxLounge;
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
		if(checkBoxLounge.isSelected())
			raffinazioni = raffinazioni.concat("Lounge,");
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
		setBackground(Color.WHITE);
		setSize(506,106);
		
		generaCheckBoxCinema();
		generaCheckBoxMuseo();
		generaCheckBoxPiscina();
		generaCheckBoxShopping();
		generaCheckBoxParcoGiochi();
		generaCheckBoxBar_Lounge();
		generaCheckBoxMonumento();
		
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(30)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(checkBoxCinema, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE)
							.addGap(45)
							.addComponent(checkBoxMuseo, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE)
							.addGap(45)
							.addComponent(checkBoxPiscina, GroupLayout.PREFERRED_SIZE, 108, GroupLayout.PREFERRED_SIZE))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(checkBoxShopping, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)
							.addGap(34)
							.addComponent(checkBoxParcoGiochi, GroupLayout.PREFERRED_SIZE, 140, GroupLayout.PREFERRED_SIZE)
							.addGap(34)
							.addComponent(checkBoxLounge, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE))
						.addComponent(checkBoxMonumento, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE)))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(8)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(checkBoxCinema, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkBoxMuseo, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkBoxPiscina, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE))
					.addGap(4)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(checkBoxShopping, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkBoxParcoGiochi, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkBoxLounge, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE))
					.addGap(4)
					.addComponent(checkBoxMonumento, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE))
		);
		setLayout(groupLayout);
	}

	private void generaCheckBoxMonumento() {
		checkBoxMonumento = new JCheckBox("Monumento");
		checkBoxMonumento.setBackground(Color.WHITE);
		checkBoxMonumento.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxMonumento.setBounds(30, 62, 129, 23);
		checkBoxMonumento.setFocusPainted(false);;
	}

	private void generaCheckBoxBar_Lounge() {
		checkBoxLounge = new JCheckBox("Lounge");
		checkBoxLounge.setBackground(Color.WHITE);
		checkBoxLounge.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxLounge.setFocusPainted(false);
	}

	private void generaCheckBoxParcoGiochi() {
		checkBoxParcoGiochi = new JCheckBox("Parco Giochi");
		checkBoxParcoGiochi.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxParcoGiochi.setBackground(Color.WHITE);
		checkBoxParcoGiochi.setFocusPainted(false);
	}

	private void generaCheckBoxShopping() {
		checkBoxShopping = new JCheckBox("Shopping");
		checkBoxShopping.setBackground(Color.WHITE);
		checkBoxShopping.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxShopping.setFocusPainted(false);
	}

	private void generaCheckBoxPiscina() {
		checkBoxPiscina = new JCheckBox("Piscina");
		checkBoxPiscina.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxPiscina.setBackground(Color.WHITE);
		checkBoxPiscina.setFocusPainted(false);
	}

	private void generaCheckBoxMuseo() {
		checkBoxMuseo = new JCheckBox("Museo");
		checkBoxMuseo.setBackground(Color.WHITE);
		checkBoxMuseo.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxMuseo.setFocusPainted(false);
	}

	private void generaCheckBoxCinema() {
		checkBoxCinema = new JCheckBox("Cinema");
		checkBoxCinema.setBackground(Color.WHITE);
		checkBoxCinema.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxCinema.setFocusPainted(false);
	}
	
	//Metodi

	public void rimuoviTutteLeSpunte() {
		checkBoxLounge.setSelected(false);
		checkBoxCinema.setSelected(false);
		checkBoxMonumento.setSelected(false);
		checkBoxMuseo.setSelected(false);
		checkBoxParcoGiochi.setSelected(false);
		checkBoxPiscina.setSelected(false);
		checkBoxShopping.setSelected(false);
	}
	
	public void impostaRaffinazioni(String raffinazioni) {
		if(raffinazioni.contains("Cinema"))
			checkBoxCinema.setSelected(true);
		if(raffinazioni.contains("Museo"))
			checkBoxMuseo.setSelected(true);
		if(raffinazioni.contains("Piscina"))
			checkBoxPiscina.setSelected(true);
		if(raffinazioni.contains("Shopping"))
			checkBoxShopping.setSelected(true);
		if(raffinazioni.contains("ParcoGiochi"))
			checkBoxParcoGiochi.setSelected(true);
		if(raffinazioni.contains("Lounge"))
			checkBoxLounge.setSelected(true);
		if(raffinazioni.contains("Monumento"))
			checkBoxMonumento.setSelected(true);
	}
}
