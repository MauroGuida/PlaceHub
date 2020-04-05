package gui.pannelliSchermataPrincipale;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.ImageIcon;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.border.LineBorder;

import gestione.Controller;
import oggetti.GUI.LocaleGUI;
import oggetti.GUI.ScrollPaneVerde;
import res.WrapLayout;

import javax.swing.JLabel;
import java.awt.Font;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.LayoutStyle.ComponentPlacement;
import javax.swing.SwingConstants;

public class GestisciBusiness extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JButton bottonePubblica;
	private ScrollPaneVerde scrollPaneBusiness;
	private JPanel pannelloVediBusiness;
	private JLabel testoSelezionaBusiness;
	
	private Controller ctrl;
	
	public GestisciBusiness(Controller Ctrl) {
		addComponentListener(new ComponentAdapter() {
			@Override
			public void componentShown(ComponentEvent e) {
				pulisciPannello();
				ctrl.recuperaBusinessUtente();
				revalidate();
			}
		});
		this.ctrl = Ctrl;
		setSize(850, 614);
		setBackground(Color.WHITE);
		setVisible(false);
		
		generaBottonePubblica();
		generaPannelloVisualizzazioneAttivitaInTuoPossesso();
		generaTestoSelezionaBusiness();
		
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addComponent(testoSelezionaBusiness, GroupLayout.DEFAULT_SIZE, 830, Short.MAX_VALUE)
					.addContainerGap())
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(243)
					.addComponent(bottonePubblica, GroupLayout.PREFERRED_SIZE, 365, Short.MAX_VALUE)
					.addGap(242))
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addComponent(scrollPaneBusiness, GroupLayout.DEFAULT_SIZE, 830, Short.MAX_VALUE)
					.addContainerGap())
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap()
					.addComponent(testoSelezionaBusiness, GroupLayout.PREFERRED_SIZE, 38, GroupLayout.PREFERRED_SIZE)
					.addPreferredGap(ComponentPlacement.RELATED)
					.addComponent(scrollPaneBusiness, GroupLayout.DEFAULT_SIZE, 474, Short.MAX_VALUE)
					.addPreferredGap(ComponentPlacement.UNRELATED)
					.addComponent(bottonePubblica, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)
					.addGap(24))
		);
		setLayout(groupLayout);
	}


	private void generaPannelloVisualizzazioneAttivitaInTuoPossesso() {
		scrollPaneBusiness = new ScrollPaneVerde();
		scrollPaneBusiness.getHorizontalScrollBar().setUnitIncrement(15);
		scrollPaneBusiness.setBorder(new LineBorder(Color.DARK_GRAY,1));
		
		pannelloVediBusiness = new JPanel();
		pannelloVediBusiness.setBackground(Color.WHITE);
		pannelloVediBusiness.setLayout(new WrapLayout(WrapLayout.CENTER));
		pannelloVediBusiness.setBounds(85, 125, 680, 250);
		scrollPaneBusiness.setViewportView(pannelloVediBusiness);
	}


	private void generaTestoSelezionaBusiness() {
		testoSelezionaBusiness = new JLabel("Seleziona quale business modificare");
		testoSelezionaBusiness.setHorizontalAlignment(SwingConstants.CENTER);
		testoSelezionaBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
	}


	private void generaBottonePubblica() {
		bottonePubblica = new JButton("");
		bottonePubblica.setOpaque(false);
		bottonePubblica.setBorderPainted(false);
		bottonePubblica.setContentAreaFilled(false);
		bottonePubblica.setFocusPainted(false);
		bottonePubblica.setIcon(new ImageIcon(GestisciBusiness.class.getResource("/Icone/bottonePubblicaNuovo.png")));
		bottonePubblica.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottonePubblica.setIcon(new ImageIcon(GestisciBusiness.class.getResource("/Icone/bottonePubblicaNuovoFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottonePubblica.setIcon(new ImageIcon(GestisciBusiness.class.getResource("/Icone/bottonePubblicaNuovo.png")));
			}
		});
		bottonePubblica.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				mostraPannelloVerifica_PubblicaBusiness1();
			}
		});
	}

	//METODI

	public void pulisciPannello() {
		pannelloVediBusiness.removeAll();
	}
	
	public void mostraPannelloVerifica_PubblicaBusiness1() {
		ctrl.controllaDocumentiUtente();
	}
	
	public void aggiungiBusiness(LocaleGUI nuovo) {
		pannelloVediBusiness.add(nuovo);
	}
}
