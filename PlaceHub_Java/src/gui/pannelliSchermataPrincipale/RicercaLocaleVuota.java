package gui.pannelliSchermataPrincipale;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.JLabel;
import javax.swing.ImageIcon;
import java.awt.Font;
import javax.swing.SwingConstants;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

public class RicercaLocaleVuota extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JLabel immagineFaccia;
	private JLabel testoRicercaLocaleVuota;
	
	public RicercaLocaleVuota() {
		setSize(850, 400);
		setVisible(true);
		setBackground(Color.WHITE);
		
		generaImmagineFaccia();
		generaTestoRicercaLocaleVuota();
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(361)
					.addComponent(immagineFaccia, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(361))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(214)
					.addComponent(testoRicercaLocaleVuota, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(215))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(140)
					.addComponent(immagineFaccia)
					.addGap(22)
					.addComponent(testoRicercaLocaleVuota))
		);
		setLayout(groupLayout);
	}

	private void generaTestoRicercaLocaleVuota() {
		testoRicercaLocaleVuota = new JLabel("La tua ricerca non ha prodotto risultati");
		testoRicercaLocaleVuota.setHorizontalAlignment(SwingConstants.CENTER);
		testoRicercaLocaleVuota.setFont(new Font("Roboto", Font.PLAIN, 25));
	}

	private void generaImmagineFaccia() {
		immagineFaccia = new JLabel("");
		immagineFaccia.setIcon(new ImageIcon(RicercaLocaleVuota.class.getResource("/Icone/facciaTriste.png")));
	}
}
