package gui.pannelliSchermataPrincipale;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.ImageIcon;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.border.LineBorder;

import gestione.Controller;
import gui.LocaleGUI;
import res.ScrollPaneVerde;
import res.WrapLayout;

import javax.swing.JLabel;
import java.awt.Font;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import javax.swing.ScrollPaneConstants;

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
				ctrl.recuperaBusinessUtente();
			}
		});
		this.ctrl = Ctrl;
		setSize(850, 614);
		setBackground(Color.WHITE);
		setVisible(false);
		setLayout(null);
		
		generaBottonePubblica();
		generaPannelloVisualizzazioneAttivitaInTuoPossesso();
		generaTestoSelezionaBusiness();
	}


	private void generaPannelloVisualizzazioneAttivitaInTuoPossesso() {
		scrollPaneBusiness = new ScrollPaneVerde();
		scrollPaneBusiness.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
		scrollPaneBusiness.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
		scrollPaneBusiness.setBorder(new LineBorder(Color.DARK_GRAY,1));
		scrollPaneBusiness.setBounds(85, 125, 680, 250);
		add(scrollPaneBusiness);
		
		pannelloVediBusiness = new JPanel();
		pannelloVediBusiness.setLayout(new WrapLayout(WrapLayout.CENTER));
		pannelloVediBusiness.setBounds(85, 125, 680, 250);
		scrollPaneBusiness.setViewportView(pannelloVediBusiness);
	}


	private void generaTestoSelezionaBusiness() {
		testoSelezionaBusiness = new JLabel("Seleziona quale business modificare");
		testoSelezionaBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoSelezionaBusiness.setBounds(85, 64, 680, 38);
		add(testoSelezionaBusiness);
	}


	private void generaBottonePubblica() {
		bottonePubblica = new JButton("");
		bottonePubblica.setBounds(229, 414, 365, 50);
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
		add(bottonePubblica);
	}

	//METODI

	public void mostraPannelloVerifica_PubblicaBusiness1() {
		ctrl.controllaDocumentiUtente();
	}
	
	public void aggiungiBusiness(LocaleGUI nuovo) {
		pannelloVediBusiness.add(nuovo);
	}
}
