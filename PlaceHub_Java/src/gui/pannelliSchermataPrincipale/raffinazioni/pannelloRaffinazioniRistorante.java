package gui.pannelliSchermataPrincipale.raffinazioni;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.JCheckBox;
import java.awt.Font;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

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
	
	
	@Override
	public String toString() {
		String raffinazioni = "";
		
		if(checkboxPizzeria.isSelected())
			raffinazioni = raffinazioni.concat("Pizzeria,");
		if(checkboxBraceria.isSelected())
			raffinazioni = raffinazioni.concat("Braceria,");
		if(checkboxPaninoteca.isSelected())
			raffinazioni = raffinazioni.concat("Paninoteca,");
		if(checkboxFastFood.isSelected())
			raffinazioni = raffinazioni.concat("FastFood,");
		if(checkboxOsteria.isSelected())
			raffinazioni = raffinazioni.concat("Osteria,");
		if(checkboxTavolaCalda.isSelected())
			raffinazioni = raffinazioni.concat("TavolaCalda,");
		if(checkboxTaverna.isSelected())
			raffinazioni = raffinazioni.concat("Taverna,");
		if(checkboxTrattoria.isSelected())
			raffinazioni = raffinazioni.concat("Trattoria,");
		if(checkboxPesce.isSelected())
			raffinazioni = raffinazioni.concat("Pesce,");
		
		return raffinazioni;
	}
	
	public pannelloRaffinazioniRistorante() {
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentHidden(ComponentEvent e) {
				rimuoviTutteLeSpunte();
			}
		});
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
		
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(30)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(checkboxPizzeria, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE)
							.addGap(45)
							.addComponent(checkboxPaninoteca, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE)
							.addGap(45)
							.addComponent(checkboxTaverna, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(checkboxBraceria, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE)
							.addGap(45)
							.addComponent(checkboxOsteria, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE)
							.addGap(45)
							.addComponent(checkboxTrattoria, GroupLayout.PREFERRED_SIZE, 120, GroupLayout.PREFERRED_SIZE))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(checkboxFastFood, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE)
							.addGap(45)
							.addComponent(checkboxTavolaCalda, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE)
							.addGap(45)
							.addComponent(checkboxPesce, GroupLayout.PREFERRED_SIZE, 129, GroupLayout.PREFERRED_SIZE))))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(8)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(checkboxPizzeria, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkboxPaninoteca, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkboxTaverna, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE))
					.addGap(4)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(checkboxBraceria, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkboxOsteria, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkboxTrattoria, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE))
					.addGap(4)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(checkboxFastFood, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkboxTavolaCalda, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)
						.addComponent(checkboxPesce, GroupLayout.PREFERRED_SIZE, 23, GroupLayout.PREFERRED_SIZE)))
		);
		setLayout(groupLayout);
	}

	private void generaCheckBoxPesce() {
		checkboxPesce = new JCheckBox("Pesce");
		checkboxPesce.setBackground(Color.WHITE);
		checkboxPesce.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxPesce.setFocusPainted(false);
	}

	private void generaCheckBoxTrattoria() {
		checkboxTrattoria = new JCheckBox("Trattoria");
		checkboxTrattoria.setBackground(Color.WHITE);
		checkboxTrattoria.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxTrattoria.setFocusPainted(false);
	}

	private void generaCheckBoxTaverna() {
		checkboxTaverna = new JCheckBox("Taverna");
		checkboxTaverna.setBackground(Color.WHITE);
		checkboxTaverna.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxTaverna.setFocusPainted(false);
	}

	private void generaCheckBoxTavolaCalda() {
		checkboxTavolaCalda = new JCheckBox("Tavola Calda");
		checkboxTavolaCalda.setBackground(Color.WHITE);
		checkboxTavolaCalda.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxTavolaCalda.setFocusPainted(false);
	}

	private void generaCheckBoxOsteria() {
		checkboxOsteria = new JCheckBox("Osteria");
		checkboxOsteria.setBackground(Color.WHITE);
		checkboxOsteria.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxOsteria.setFocusPainted(false);
	}

	private void generaCheckBoxFastFood() {
		checkboxFastFood = new JCheckBox("Fast Food");
		checkboxFastFood.setBackground(Color.WHITE);
		checkboxFastFood.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxFastFood.setFocusPainted(false);
	}

	private void generaCheckBoxPaninoteca() {
		checkboxPaninoteca = new JCheckBox("Paninoteca");
		checkboxPaninoteca.setBackground(Color.WHITE);
		checkboxPaninoteca.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxPaninoteca.setFocusPainted(false);
	}

	private void generaCheckBoxBraceria() {
		checkboxBraceria = new JCheckBox("Braceria");
		checkboxBraceria.setBackground(Color.WHITE);
		checkboxBraceria.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxBraceria.setFocusPainted(false);
	}

	private void generaCheckBoxPizzeria() {
		checkboxPizzeria = new JCheckBox("Pizzeria");
		checkboxPizzeria.setBackground(Color.WHITE);
		checkboxPizzeria.setFont(new Font("Roboto", Font.PLAIN, 16));
		checkboxPizzeria.setFocusPainted(false);
	}
	
	//Metodi

	public void rimuoviTutteLeSpunte() {
		checkboxBraceria.setSelected(false);
		checkboxFastFood.setSelected(false);
		checkboxOsteria.setSelected(false);
		checkboxPaninoteca.setSelected(false);
		checkboxPesce.setSelected(false);
		checkboxPizzeria.setSelected(false);
		checkboxTaverna.setSelected(false);
		checkboxTavolaCalda.setSelected(false);
		checkboxTrattoria.setSelected(false);
	}
	
	public void impostaRaffinazioni(String raffinazioni) {
		if(raffinazioni.contains("Pizzeria"))
			checkboxPizzeria.setSelected(true);
		if(raffinazioni.contains("Braceria"))
			checkboxBraceria.setSelected(true);
		if(raffinazioni.contains("Paninoteca"))
			checkboxPaninoteca.setSelected(true);
		if(raffinazioni.contains("FastFood"))
			checkboxFastFood.setSelected(true);
		if(raffinazioni.contains("Osteria"))
			checkboxOsteria.setSelected(true);
		if(raffinazioni.contains("TavolaCalda"))
			checkboxTavolaCalda.setSelected(true);
		if(raffinazioni.contains("Taverna"))
			checkboxTaverna.setSelected(true);
		if(raffinazioni.contains("Trattoria"))
			checkboxTrattoria.setSelected(true);
		if(raffinazioni.contains("Pesce"))
			checkboxPesce.setSelected(true);
	}
}
