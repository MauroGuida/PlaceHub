package gui.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.FocusAdapter;
import java.awt.event.FocusEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.GroupLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.GroupLayout.Alignment;
import javax.swing.border.LineBorder;

import gestione.Controller;
import gui.SchermataPrincipale;

public class SideBar extends JPanel {
	private static final long serialVersionUID = 1L;

	private JPanel pannelloCerca;
	private JTextField textFieldCosa;
	private JTextField textFieldDove;
	private JLabel lineaTestoCosaSideBar;
	private JLabel lineaTestoDoveSideBar;
	private JButton bottoneCercaSideBar;
	private JButton bottoneHomepage;
	private JButton bottoneRistoranti;
	private JButton bottoneIntrattenimento;
	private JButton bottoneAlloggi;
	private JButton bottoneGestisciBusiness;
	private int flagFocusBottone;
	
	
	public SideBar() {

		setSize(250, 650);
		setVisible(true);
		setBackground(new Color(51,51,51));
			
	    bottoneHomepage = new JButton("");
	    bottoneHomepage.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 1;
	    		resettaFocusIconeSideBar(flagFocusBottone);
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    		bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusiness.png")));
	    		
	    		Controller.getSchermataPrincipaleFrame().mostraHomepage();
	    	}
	    });
	    bottoneHomepage.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepageFocus.png")));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		if(flagFocusBottone != 1)
	    			bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
	    		else 
	    			bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepageFocus.png")));
	    	}

	    });
	    bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
	    bottoneHomepage.setOpaque(false);
	    bottoneHomepage.setFocusPainted(false);
	    bottoneHomepage.setContentAreaFilled(false);
	    bottoneHomepage.setBorderPainted(false);
	    
	    bottoneRistoranti = new JButton("");
	    bottoneRistoranti.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 2;
	    		resettaFocusIconeSideBar(flagFocusBottone);
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    		bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusiness.png")));
	    		
	    		Controller.getSchermataPrincipaleFrame().mostraRistornati();
	    	}
	    });
	    bottoneRistoranti.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristorantiFocus.png")));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		if(flagFocusBottone != 2)
	    			bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
	    		else
	    			bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristorantiFocus.png")));
	    	}
	    });
	    bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
	    bottoneRistoranti.setOpaque(false);
	    bottoneRistoranti.setFocusPainted(false);
	    bottoneRistoranti.setContentAreaFilled(false);
	    bottoneRistoranti.setBorderPainted(false);
	    
	    bottoneIntrattenimento = new JButton("");
	    bottoneIntrattenimento.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimentoFocus.png")));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		if(flagFocusBottone != 3)
	    			bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimento.png")));
	    		else
	    			bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimentoFocus.png")));
	    	}
	    });
	    bottoneIntrattenimento.setOpaque(false);
	    bottoneIntrattenimento.setFocusPainted(false);
	    bottoneIntrattenimento.setContentAreaFilled(false);
	    bottoneIntrattenimento.setBorderPainted(false);
	    bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimento.png")));
	    bottoneIntrattenimento.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 3;
	    		resettaFocusIconeSideBar(flagFocusBottone);
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    		bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusiness.png")));
	    	}
	    });
	    
	    bottoneAlloggi = new JButton("");
	    bottoneAlloggi.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 4;
	    		resettaFocusIconeSideBar(flagFocusBottone);
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    		bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusiness.png")));
	    	}
	    });
	    bottoneAlloggi.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggiFocus.png")));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		if(flagFocusBottone != 4)
	    			bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
	    		else
	    			bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggiFocus.png")));
	    	}
	    });
	    bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
	    bottoneAlloggi.setOpaque(false);
	    bottoneAlloggi.setFocusPainted(false);
	    bottoneAlloggi.setContentAreaFilled(false);
	    bottoneAlloggi.setBorderPainted(false);
	    
	    bottoneGestisciBusiness = new JButton("");
	    bottoneGestisciBusiness.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent e) {
	    		Controller.getSchermataPrincipaleFrame().mostraGestisciBusiness();
	    	}
	    });
	    bottoneGestisciBusiness.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusinessFocus.png")));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		if(!Controller.getSchermataPrincipaleFrame().controlloPannelliBusinessVisibili())
	    			bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusiness.png")));
	    	}
	    });
	    
	    bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusiness.png")));
	    bottoneGestisciBusiness.setOpaque(false);
	    bottoneGestisciBusiness.setFocusPainted(false);
	    bottoneGestisciBusiness.setContentAreaFilled(false);
	    bottoneGestisciBusiness.setBorderPainted(false);
	    
	    pannelloCerca = new JPanel();
	    pannelloCerca.setBackground(new Color(51,51,51));
	    
	    textFieldCosa = new JTextField();
	    textFieldCosa.addFocusListener(new FocusAdapter() {
	    	@Override
	    	public void focusGained(FocusEvent e) {
	    		textFieldCosa.setText("");
	    		textFieldCosa.setForeground(Color.WHITE);
	    	}
	    	@Override
	    	public void focusLost(FocusEvent e) {
	    		if(textFieldCosa.getText().isEmpty() ){
	    			textFieldCosa.setText("Cosa?");
	    			textFieldCosa.setForeground(Color.LIGHT_GRAY);
	    		}
	    	}
	    });
	    textFieldCosa.setColumns(10);
	    textFieldCosa.setFont(new Font("Roboto", Font.PLAIN, 20));
	    textFieldCosa.setBackground(new Color(51,51,51));
	    textFieldCosa.setBorder(new LineBorder(new Color(51,51,51),1));
	    textFieldCosa.setText("Cosa?");
	    textFieldCosa.setForeground(Color.LIGHT_GRAY);
	    textFieldCosa.setCaretColor(Color.WHITE);
	    
	    textFieldDove = new JTextField();
	    textFieldDove.addFocusListener(new FocusAdapter() {
	    	@Override
	    	public void focusGained(FocusEvent e) {
	    		textFieldDove.setText("");
	    		textFieldDove.setForeground(Color.WHITE);
	    	}
	    	@Override
	    	public void focusLost(FocusEvent e) {
	    		if(textFieldDove.getText().isEmpty()) {
	    			textFieldDove.setText("Dove?");
	    			textFieldDove.setForeground(Color.LIGHT_GRAY);
	    		}
	    	}
	    });
	    textFieldDove.setColumns(10);
	    textFieldDove.setFont(new Font("Roboto", Font.PLAIN, 20));
	    textFieldDove.setBackground(new Color(51,51,51));
	    textFieldDove.setBorder(new LineBorder(new Color(51,51,51),1));
	    textFieldDove.setText("Dove?");
	    textFieldDove.setForeground(Color.LIGHT_GRAY);
	    textFieldDove.setCaretColor(Color.WHITE);
	    
	    bottoneCercaSideBar = new JButton("");
	    bottoneCercaSideBar.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusiness.png")));
	    	}
	    });
	    bottoneCercaSideBar.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneCercaSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/CercaButtonFocus.png")));
	    		setCursor(new Cursor(Cursor.HAND_CURSOR));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
	    		bottoneCercaSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/CercaButton.png")));
	    	}
	    });
	    
	    bottoneCercaSideBar.setOpaque(false);
	    bottoneCercaSideBar.setBorderPainted(false);
	    bottoneCercaSideBar.setContentAreaFilled(false);
	    bottoneCercaSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/CercaButton.png")));
	    
	    lineaTestoCosaSideBar = new JLabel("");
	    lineaTestoCosaSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaTestoBianca.png")));
	    
	    lineaTestoDoveSideBar = new JLabel("");
	    lineaTestoDoveSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaTestoBianca.png")));
	    
	    GroupLayout gl_pannelloSideBar = new GroupLayout(this);
	    gl_pannelloSideBar.setHorizontalGroup(
	    	gl_pannelloSideBar.createParallelGroup(Alignment.LEADING)
	    		.addComponent(bottoneHomepage, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneRistoranti, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneIntrattenimento, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneAlloggi, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(pannelloCerca, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneGestisciBusiness, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    );
	    gl_pannelloSideBar.setVerticalGroup(
	    	gl_pannelloSideBar.createParallelGroup(Alignment.LEADING)
	    		.addGroup(gl_pannelloSideBar.createSequentialGroup()
	    			.addComponent(bottoneHomepage, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
	    			.addComponent(bottoneRistoranti, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
	    			.addComponent(bottoneIntrattenimento, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
	    			.addComponent(bottoneAlloggi, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
	    			.addComponent(pannelloCerca, GroupLayout.DEFAULT_SIZE, 180, Short.MAX_VALUE)
	    			.addComponent(bottoneGestisciBusiness, GroupLayout.DEFAULT_SIZE, 150, Short.MAX_VALUE))
	    );
	    
	    GroupLayout gl_pannelloCerca = new GroupLayout(pannelloCerca);
	    gl_pannelloCerca.setHorizontalGroup(
	    	gl_pannelloCerca.createParallelGroup(Alignment.LEADING)
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(textFieldCosa, GroupLayout.PREFERRED_SIZE, 210, GroupLayout.PREFERRED_SIZE))
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(lineaTestoCosaSideBar))
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(textFieldDove, GroupLayout.PREFERRED_SIZE, 210, GroupLayout.PREFERRED_SIZE))
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(lineaTestoDoveSideBar))
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(70)
	    			.addComponent(bottoneCercaSideBar, GroupLayout.PREFERRED_SIZE, 120, GroupLayout.PREFERRED_SIZE))
	    );
	    gl_pannelloCerca.setVerticalGroup(
	    	gl_pannelloCerca.createParallelGroup(Alignment.LEADING)
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(textFieldCosa, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
	    			.addComponent(lineaTestoCosaSideBar)
	    			.addGap(19)
	    			.addComponent(textFieldDove, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
	    			.addComponent(lineaTestoDoveSideBar)
	    			.addGap(19)
	    			.addComponent(bottoneCercaSideBar, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE))
	    );
	    pannelloCerca.setLayout(gl_pannelloCerca);
	    setLayout(gl_pannelloSideBar);
	}
	

	private void cambiaFocusIconeSideBar(int flag) {
		switch(flag) {
			case 1:
				bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepageFocus.png")));
				break;
			case 2:
				bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristorantiFocus.png")));
				break;
			case 3:
				bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimentoFocus.png")));
				break;
			case 4:
				bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggiFocus.png")));
				break;
		}
	}
	
	
	private void resettaFocusIconeSideBar(int flag) {
		bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
		bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
		bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimento.png")));
		bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
	}
	
	

}
