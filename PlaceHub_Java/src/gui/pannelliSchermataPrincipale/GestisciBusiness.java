package gui.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.FlowLayout;

import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.ImageIcon;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.border.LineBorder;

import gestione.Controller;
import gui.LocaleGUI;
import res.ScrollPaneVerde;

import javax.swing.JLabel;
import java.awt.Font;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import javax.swing.ScrollPaneConstants;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

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
					.addGap(85)
					.addComponent(testoSelezionaBusiness, GroupLayout.DEFAULT_SIZE, 680, Short.MAX_VALUE)
					.addGap(85))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(85)
					.addComponent(scrollPaneBusiness, GroupLayout.DEFAULT_SIZE, 680, Short.MAX_VALUE)
					.addGap(85))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(229)
					.addComponent(bottonePubblica, GroupLayout.PREFERRED_SIZE, 365, Short.MAX_VALUE)
					.addGap(256))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(64)
					.addComponent(testoSelezionaBusiness, GroupLayout.PREFERRED_SIZE, 38, GroupLayout.PREFERRED_SIZE)
					.addGap(11)
					.addComponent(scrollPaneBusiness, GroupLayout.DEFAULT_SIZE, 280, Short.MAX_VALUE)
					.addGap(21)
					.addComponent(bottonePubblica, GroupLayout.PREFERRED_SIZE, 50, GroupLayout.PREFERRED_SIZE)
					.addGap(150))
		);
		setLayout(groupLayout);
	}


	private void generaPannelloVisualizzazioneAttivitaInTuoPossesso() {
		scrollPaneBusiness = new ScrollPaneVerde();
		scrollPaneBusiness.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_NEVER);
		scrollPaneBusiness.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		scrollPaneBusiness.getHorizontalScrollBar().setUnitIncrement(15);
		scrollPaneBusiness.setBorder(new LineBorder(Color.DARK_GRAY,1));
		
		pannelloVediBusiness = new JPanel();
		pannelloVediBusiness.setBackground(Color.WHITE);
		pannelloVediBusiness.setLayout(new FlowLayout(FlowLayout.CENTER));
		pannelloVediBusiness.setBounds(85, 125, 680, 250);
		scrollPaneBusiness.setViewportView(pannelloVediBusiness);
	}


	private void generaTestoSelezionaBusiness() {
		testoSelezionaBusiness = new JLabel("Seleziona quale business modificare");
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
