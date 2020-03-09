package gui;

import javax.swing.JFrame;

import gestione.Controller;
import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.ImageIcon;
import javax.swing.LayoutStyle.ComponentPlacement;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.FlowLayout;


public class SchermataPrincipale extends JFrame {
	private static final long serialVersionUID = 1L;
	private Controller ctrl;
	private JButton bottoneEsci;
	public SchermataPrincipale(Controller Ctrl) {
		this.ctrl = Ctrl;
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		setSize(1100,650);
		setMinimumSize(new Dimension(1100,650));
		
		JPanel panelloSideBar = new JPanel();
		panelloSideBar.setBackground(new Color(51,51,51));
		
		JButton bottoneHomepage = new JButton("");
		bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
//		Image img;
//		try {
//			img = ImageIO.read(new File("/home/davide/Downloads/homepage.png"));
//			Image Icon = img.getScaledInstance(70,70,java.awt.Image.SCALE_SMOOTH);
//			btnHomepage.setIcon(new ImageIcon(Icon));
//			btnHomepage.setOpaque(false);
//			btnHomepage.setContentAreaFilled(false);
//			btnHomepage.setBorderPainted(false);
//		} catch (IOException e) {
//			// TODO Auto-generated catch block
//			e.printStackTrace();
//		}
		bottoneHomepage.setOpaque(false);
		bottoneHomepage.setFocusPainted(false);
		bottoneHomepage.setContentAreaFilled(false);
		bottoneHomepage.setBorderPainted(false);
		
		JButton bottoneRistoranti = new JButton("");
		bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
		bottoneRistoranti.setOpaque(false);
		bottoneRistoranti.setFocusPainted(false);
		bottoneRistoranti.setContentAreaFilled(false);
		bottoneRistoranti.setBorderPainted(false);
		
		
		JButton bottoneIntrattenimento = new JButton("");
		bottoneIntrattenimento.setOpaque(false);
		bottoneIntrattenimento.setFocusPainted(false);
		bottoneIntrattenimento.setContentAreaFilled(false);
		bottoneIntrattenimento.setBorderPainted(false);
		bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimento.png")));
		bottoneIntrattenimento.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
			}
		});
		
		JButton bottoneAlloggi = new JButton("");
		bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
		bottoneAlloggi.setOpaque(false);
		bottoneAlloggi.setFocusPainted(false);
		bottoneAlloggi.setContentAreaFilled(false);
		bottoneAlloggi.setBorderPainted(false);
		JPanel panel_1 = new JPanel();
		panel_1.setBackground(new Color(51,51,51));
		
		JButton bottoneGestisciBusiness = new JButton("");
		bottoneGestisciBusiness.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/gestisciAttvita.png")));
		bottoneGestisciBusiness.setOpaque(false);
		bottoneGestisciBusiness.setFocusPainted(false);
		bottoneGestisciBusiness.setContentAreaFilled(false);
		bottoneGestisciBusiness.setBorderPainted(false);
		
		GroupLayout gl_panelloSideBar = new GroupLayout(panelloSideBar);
		gl_panelloSideBar.setHorizontalGroup(
			gl_panelloSideBar.createParallelGroup(Alignment.LEADING)
				.addComponent(bottoneHomepage, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
				.addComponent(bottoneRistoranti, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
				.addComponent(bottoneIntrattenimento, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
				.addComponent(bottoneAlloggi, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
				.addComponent(panel_1, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
				.addComponent(bottoneGestisciBusiness, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
		);
		gl_panelloSideBar.setVerticalGroup(
			gl_panelloSideBar.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_panelloSideBar.createSequentialGroup()
					.addComponent(bottoneHomepage, GroupLayout.DEFAULT_SIZE, 70, Short.MAX_VALUE)
					.addComponent(bottoneRistoranti, GroupLayout.DEFAULT_SIZE, 70, Short.MAX_VALUE)
					.addComponent(bottoneIntrattenimento, GroupLayout.DEFAULT_SIZE, 70, Short.MAX_VALUE)
					.addComponent(bottoneAlloggi, GroupLayout.DEFAULT_SIZE, 70, Short.MAX_VALUE)
					.addComponent(panel_1, GroupLayout.DEFAULT_SIZE, 230, Short.MAX_VALUE)
					.addComponent(bottoneGestisciBusiness, GroupLayout.DEFAULT_SIZE, 110, Short.MAX_VALUE))
		);
		panelloSideBar.setLayout(gl_panelloSideBar);
		
		JPanel pannelloBottoni = new JPanel();
		pannelloBottoni.setBackground(Color.WHITE);
		GroupLayout groupLayout = new GroupLayout(getContentPane());
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addComponent(panelloSideBar, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
					.addPreferredGap(ComponentPlacement.RELATED)
					.addComponent(pannelloBottoni, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addComponent(panelloSideBar, GroupLayout.DEFAULT_SIZE, 620, Short.MAX_VALUE)
				.addGroup(groupLayout.createSequentialGroup()
					.addComponent(pannelloBottoni, GroupLayout.PREFERRED_SIZE, 36, GroupLayout.PREFERRED_SIZE)
					.addContainerGap(584, Short.MAX_VALUE))
		);
		getContentPane().setLayout(groupLayout);
		
		bottoneEsci = new JButton("");
		bottoneEsci.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				System.exit(0);
			}
		});
		bottoneEsci.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/X.png")));
		bottoneEsci.setBorderPainted(false);
		bottoneEsci.setContentAreaFilled(false);
		bottoneEsci.setOpaque(false);
		
		JButton bottoneMassimizza = new JButton("");
		bottoneMassimizza.setOpaque(false);
		bottoneMassimizza.setContentAreaFilled(false);
		bottoneMassimizza.setBorderPainted(false);
		bottoneMassimizza.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IncreaseSize.png")));
		
		JButton bottoneMinimizza = new JButton("");
		bottoneMinimizza.setOpaque(false);
		bottoneMinimizza.setBorderPainted(false);
		bottoneMinimizza.setContentAreaFilled(false);
		bottoneMinimizza.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/minimizza.png")));
		
		pannelloBottoni.setLayout(new FlowLayout(FlowLayout.RIGHT, 5, 5));
		pannelloBottoni.add(bottoneMinimizza, BorderLayout.EAST);
		pannelloBottoni.add(bottoneMassimizza, BorderLayout.EAST);
		pannelloBottoni.add(bottoneEsci, BorderLayout.EAST);
		

	}
}
