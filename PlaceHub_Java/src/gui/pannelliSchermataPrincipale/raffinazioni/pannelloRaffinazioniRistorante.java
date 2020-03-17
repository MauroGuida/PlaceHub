package gui.pannelliSchermataPrincipale.raffinazioni;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.JCheckBox;
import java.awt.Font;

public class pannelloRaffinazioniRistorante extends JPanel {
	private static final long serialVersionUID = 1L;
	private JCheckBox checkboxPizzeria;
	private JCheckBox checkboxBraceria;
	private JCheckBox checkboxPaninoteca;
	private JCheckBox checkboxFastFood;
	private JCheckBox checkboxOsteria;
	private JCheckBox checkboxTavolaCalda;
	private JCheckBox checkboxTaverna;
	private JCheckBox checkboxTrattoria;
	private JCheckBox checkboxPesce;
	
	public pannelloRaffinazioniRistorante() {
		setLayout(null);
		setBackground(Color.WHITE);
		setSize(506,106);
		
		generaCheckBoxPizzeria();
		generaCheckBoxBraceria();
		generaCheckBoxPaninoteca();
		generaCheckBoxFastFood();
		generaCheckBoxOsteria();
		generaCheckBoxTavolaCalda();
		generaCheckBoxTaverna();
		generaCheckBoxTrattoria();
		generaCheckBoxPesce();	
	}

	private void generaCheckBoxPesce() {
		checkboxPesce = new JCheckBox("Pesce");
		checkboxPesce.setBackground(Color.WHITE);
		checkboxPesce.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxPesce.setBounds(378, 62, 129, 23);
		checkboxPesce.setFocusPainted(false);
		add(checkboxPesce);
	}

	private void generaCheckBoxTrattoria() {
		checkboxTrattoria = new JCheckBox("Trattoria");
		checkboxTrattoria.setBackground(Color.WHITE);
		checkboxTrattoria.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxTrattoria.setBounds(378, 35, 120, 23);
		checkboxTrattoria.setFocusPainted(false);
		add(checkboxTrattoria);
	}

	private void generaCheckBoxTaverna() {
		checkboxTaverna = new JCheckBox("Taverna");
		checkboxTaverna.setBackground(Color.WHITE);
		checkboxTaverna.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxTaverna.setBounds(378, 8, 129, 23);
		checkboxTaverna.setFocusPainted(false);
		add(checkboxTaverna);
	}

	private void generaCheckBoxTavolaCalda() {
		checkboxTavolaCalda = new JCheckBox("Tavola Calda");
		checkboxTavolaCalda.setBackground(Color.WHITE);
		checkboxTavolaCalda.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxTavolaCalda.setBounds(204, 62, 129, 23);
		checkboxTavolaCalda.setFocusPainted(false);
		add(checkboxTavolaCalda);
	}

	private void generaCheckBoxOsteria() {
		checkboxOsteria = new JCheckBox("Osteria");
		checkboxOsteria.setBackground(Color.WHITE);
		checkboxOsteria.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxOsteria.setBounds(204, 35, 129, 23);
		checkboxOsteria.setFocusPainted(false);
		add(checkboxOsteria);
	}

	private void generaCheckBoxFastFood() {
		checkboxFastFood = new JCheckBox("Fast Food");
		checkboxFastFood.setBackground(Color.WHITE);
		checkboxFastFood.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxFastFood.setBounds(30, 62, 129, 23);
		checkboxFastFood.setFocusPainted(false);
		add(checkboxFastFood);
	}

	private void generaCheckBoxPaninoteca() {
		checkboxPaninoteca = new JCheckBox("Paninoteca");
		checkboxPaninoteca.setBackground(Color.WHITE);
		checkboxPaninoteca.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxPaninoteca.setBounds(204, 8, 129, 23);
		checkboxPaninoteca.setFocusPainted(false);
		add(checkboxPaninoteca);
	}

	private void generaCheckBoxBraceria() {
		checkboxBraceria = new JCheckBox("Braceria");
		checkboxBraceria.setBackground(Color.WHITE);
		checkboxBraceria.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxBraceria.setBounds(30, 35, 129, 23);
		checkboxBraceria.setFocusPainted(false);
		add(checkboxBraceria);
	}

	private void generaCheckBoxPizzeria() {
		checkboxPizzeria = new JCheckBox("Pizzeria");
		checkboxPizzeria.setBackground(Color.WHITE);
		checkboxPizzeria.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxPizzeria.setBounds(30, 8, 129, 23);
		checkboxPizzeria.setFocusPainted(false);
		add(checkboxPizzeria);
	}
}
