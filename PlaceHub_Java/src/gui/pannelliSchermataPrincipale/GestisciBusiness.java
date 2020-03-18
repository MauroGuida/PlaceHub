package gui.pannelliSchermataPrincipale;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.ImageIcon;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.border.LineBorder;

import res.ScrollPaneVerde;
import javax.swing.JLabel;
import java.awt.Font;

public class GestisciBusiness extends JPanel {
	
	private static final long serialVersionUID = 1L;
	private JButton bottonePubblica;
	private ScrollPaneVerde scrollPaneBusiness;
	private JPanel pannelloVediBusiness;
	
	public GestisciBusiness() {
		setSize(850, 614);
		setBackground(Color.WHITE);
		setLayout(null);
		
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
		add(bottonePubblica);
		
		scrollPaneBusiness = new ScrollPaneVerde();
		scrollPaneBusiness.setBorder(new LineBorder(Color.DARK_GRAY,1));
		scrollPaneBusiness.setBounds(85, 125, 680, 250);
		add(scrollPaneBusiness);
		
		pannelloVediBusiness = new JPanel();
		pannelloVediBusiness.setBounds(85, 125, 680, 250);
		scrollPaneBusiness.setViewportView(pannelloVediBusiness);
		
		JLabel testoSelezionaBusiness = new JLabel("Seleziona quale business modificare");
		testoSelezionaBusiness.setFont(new Font("Roboto", Font.PLAIN, 20));
		testoSelezionaBusiness.setBounds(85, 64, 680, 38);
		add(testoSelezionaBusiness);
	}
}
