package gui.pannelliSchermataPrincipale.raffinazioni;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.JCheckBox;
import java.awt.Font;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

public class pannelloRaffinazioneAlloggi extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JCheckBox checkBoxHotel;
	private JCheckBox checkBoxOstello;
	private JCheckBox checkBoxBedBreakfast;
	private JCheckBox checkBoxResidence;
	private JCheckBox checkBoxCasaVacanze;
	
	@Override
	public String toString() {
		String raffinazioni = "";
		if(checkBoxHotel.isSelected())
			raffinazioni = raffinazioni.concat("Hotel,");
		if(checkBoxOstello.isSelected())
			raffinazioni = raffinazioni.concat("Ostello,");
		if(checkBoxBedBreakfast.isSelected())
			raffinazioni = raffinazioni.concat("Bed&Breakfast,");
		if(checkBoxResidence.isSelected())
			raffinazioni = raffinazioni.concat("Residence,");
		if(checkBoxCasaVacanze.isSelected())
			raffinazioni = raffinazioni.concat("CasaVacanze,");
		
		return raffinazioni; 
	}
	
	
	public pannelloRaffinazioneAlloggi() {
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentHidden(ComponentEvent e) {
				rimuoviTutteLeSpunte();
			}
		});
		setBackground(Color.WHITE);
		setSize(506,106);
		
		generaCheckBoxHotel();
		generaCheckBoxOstello();
		generaCheckBoxBedBreakfast();
		generaBoxResidence();
		generaCheckBoxCasVacanze();
		
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(30)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(checkBoxHotel, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE)
							.addGap(45)
							.addComponent(checkBoxOstello, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE)
							.addGap(45)
							.addComponent(checkBoxResidence, GroupLayout.PREFERRED_SIZE, 108, GroupLayout.PREFERRED_SIZE))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(checkBoxBedBreakfast, GroupLayout.PREFERRED_SIZE, 141, GroupLayout.PREFERRED_SIZE)
							.addGap(33)
							.addComponent(checkBoxCasaVacanze, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE))))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(8)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(checkBoxHotel, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkBoxOstello, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkBoxResidence, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE))
					.addGap(4)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(checkBoxBedBreakfast, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkBoxCasaVacanze, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)))
		);
		setLayout(groupLayout);
	}

	private void generaCheckBoxCasVacanze() {
		checkBoxCasaVacanze = new JCheckBox("Casa Vacanze");
		checkBoxCasaVacanze.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxCasaVacanze.setBackground(Color.WHITE);
		checkBoxCasaVacanze.setFocusPainted(false);
	}

	private void generaBoxResidence() {
		checkBoxResidence = new JCheckBox("Residence");
		checkBoxResidence.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxResidence.setBackground(Color.WHITE);
		checkBoxResidence.setFocusPainted(false);
	}

	private void generaCheckBoxBedBreakfast() {
		checkBoxBedBreakfast = new JCheckBox("Bed & Breakfast");
		checkBoxBedBreakfast.setBackground(Color.WHITE);
		checkBoxBedBreakfast.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxBedBreakfast.setFocusPainted(false);
	}

	private void generaCheckBoxOstello() {
		checkBoxOstello = new JCheckBox("Ostello");
		checkBoxOstello.setBackground(Color.WHITE);
		checkBoxOstello.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxOstello.setFocusPainted(false);
	}

	private void generaCheckBoxHotel() {
		checkBoxHotel = new JCheckBox("Hotel");
		checkBoxHotel.setBackground(Color.WHITE);
		checkBoxHotel.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxHotel.setFocusPainted(false);
	}
	
	
	//Metodi

	
	public void rimuoviTutteLeSpunte() {
		checkBoxBedBreakfast.setSelected(false);
		checkBoxCasaVacanze.setSelected(false);
		checkBoxHotel.setSelected(false);
		checkBoxOstello.setSelected(false);
		checkBoxResidence.setSelected(false);
	}
}
