package gui.pannelliSchermataPrincipale.raffinazioni;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.JCheckBox;
import java.awt.Font;

public class pannelloRaffinazioneAlloggi extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JCheckBox checkBoxHotel;
	private JCheckBox checkBoxOstello;
	private JCheckBox checkBoxBedBreakfast;
	private JCheckBox checkBoxResidence;
	private JCheckBox checkBoxCasaVacanze;
	
	public pannelloRaffinazioneAlloggi() {
		setLayout(null);
		setBackground(Color.WHITE);
		setSize(506,106);
		
		generaCheckBoxHotel();
		generaCheckBoxOstello();
		generaCheckBoxBedBreakfast();
		generaBoxResidence();
		generaCheckBoxCasVacanze();
		
	}

	private void generaCheckBoxCasVacanze() {
		checkBoxCasaVacanze = new JCheckBox("Casa Vacanze");
		checkBoxCasaVacanze.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxCasaVacanze.setBackground(Color.WHITE);
		checkBoxCasaVacanze.setBounds(204, 35, 129, 23);
		checkBoxCasaVacanze.setFocusPainted(false);
		add(checkBoxCasaVacanze);
	}

	private void generaBoxResidence() {
		checkBoxResidence = new JCheckBox("Residence");
		checkBoxResidence.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxResidence.setBackground(Color.WHITE);
		checkBoxResidence.setBounds(378, 8, 108, 23);
		checkBoxResidence.setFocusPainted(false);
		add(checkBoxResidence);
	}

	private void generaCheckBoxBedBreakfast() {
		checkBoxBedBreakfast = new JCheckBox("Bed & Breakfast");
		checkBoxBedBreakfast.setBackground(Color.WHITE);
		checkBoxBedBreakfast.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxBedBreakfast.setBounds(30, 35, 141, 23);
		checkBoxBedBreakfast.setFocusPainted(false);
		add(checkBoxBedBreakfast);
	}

	private void generaCheckBoxOstello() {
		checkBoxOstello = new JCheckBox("Ostello");
		checkBoxOstello.setBackground(Color.WHITE);
		checkBoxOstello.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxOstello.setBounds(204, 8, 129, 23);
		checkBoxOstello.setFocusPainted(false);
		add(checkBoxOstello);
	}

	private void generaCheckBoxHotel() {
		checkBoxHotel = new JCheckBox("Hotel");
		checkBoxHotel.setBackground(Color.WHITE);
		checkBoxHotel.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkBoxHotel.setBounds(30, 8, 129, 23);
		checkBoxHotel.setFocusPainted(false);
		add(checkBoxHotel);
	}
	
	public JCheckBox getCheckBoxHotel() {
		return checkBoxHotel;
	}

	public JCheckBox getCheckBoxOstello() {
		return checkBoxOstello;
	}

	public JCheckBox getCheckBoxBedBreakfast() {
		return checkBoxBedBreakfast;
	}

	public JCheckBox getCheckBoxResidence() {
		return checkBoxResidence;
	}

	public JCheckBox getCheckBoxCasaVacanze() {
		return checkBoxCasaVacanze;
	}

}
