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
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;

public class SideBar extends JPanel {
	private static final long serialVersionUID = 1L;

	private JPanel pannelloCerca;
	private JTextField textFieldCosa;
	private JTextField textFieldDove;
	private JLabel lineaTestoCosa;
	private JLabel lineaTestoDove;
	private JButton bottoneCerca;
	private JButton bottoneHomepage;
	private JButton bottoneRistoranti;
	private JButton bottoneAttrazioni;
	private JButton bottoneAlloggi;
	private JButton bottoneGestisciBusiness;
	private int flagFocusBottone;
	
	
	public SideBar() {
		setSize(250, 650);
		setVisible(true);
		setBackground(new Color(51,51,51));
			
	    generaBottoneHomepage();
	    generaBottoneRistoranti();
	    generaBottoneAttrazioni();
	    generaBottoneAlloggi(); 
	    generaBottoneGestisciBusiness();
	    
	    generaPannelloCerca();
	    generaCampoCosa(); 
	    generaCampoDove();
	    generaBottoneCerca();
	    
	    generaLayout();
	}


	private void generaPannelloCerca() {
		pannelloCerca = new JPanel();
	    pannelloCerca.setBackground(new Color(51,51,51));
	}


	private void generaLayout() {
		GroupLayout gl_pannelloSideBar = new GroupLayout(this);
	    gl_pannelloSideBar.setHorizontalGroup(
	    	gl_pannelloSideBar.createParallelGroup(Alignment.LEADING)
	    		.addComponent(bottoneHomepage, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneRistoranti, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneAttrazioni, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneAlloggi, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(pannelloCerca, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    		.addComponent(bottoneGestisciBusiness, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
	    );
	    gl_pannelloSideBar.setVerticalGroup(
	    	gl_pannelloSideBar.createParallelGroup(Alignment.LEADING)
	    		.addGroup(gl_pannelloSideBar.createSequentialGroup()
	    			.addComponent(bottoneHomepage, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
	    			.addComponent(bottoneRistoranti, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
	    			.addComponent(bottoneAttrazioni, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
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
	    			.addComponent(lineaTestoCosa))
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(textFieldDove, GroupLayout.PREFERRED_SIZE, 210, GroupLayout.PREFERRED_SIZE))
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(lineaTestoDove))
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(70)
	    			.addComponent(bottoneCerca, GroupLayout.PREFERRED_SIZE, 120, GroupLayout.PREFERRED_SIZE))
	    );
	    gl_pannelloCerca.setVerticalGroup(
	    	gl_pannelloCerca.createParallelGroup(Alignment.LEADING)
	    		.addGroup(gl_pannelloCerca.createSequentialGroup()
	    			.addGap(20)
	    			.addComponent(textFieldCosa, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
	    			.addComponent(lineaTestoCosa)
	    			.addGap(19)
	    			.addComponent(textFieldDove, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE)
	    			.addComponent(lineaTestoDove)
	    			.addGap(19)
	    			.addComponent(bottoneCerca, GroupLayout.PREFERRED_SIZE, 40, GroupLayout.PREFERRED_SIZE))
	    );
	    pannelloCerca.setLayout(gl_pannelloCerca);
	    setLayout(gl_pannelloSideBar);
	}


	private void generaBottoneCerca() {
		bottoneCerca = new JButton("");
	    bottoneCerca.setOpaque(false);
	    bottoneCerca.setBorderPainted(false);
	    bottoneCerca.setContentAreaFilled(false);
	    bottoneCerca.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/CercaButton.png")));
	    bottoneCerca.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		Controller.getSchermataPrincipaleFrame().mostraRicercaLocali(textFieldCosa.getText(), textFieldDove.getText());
	    	}
	    });
	    bottoneCerca.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneCerca.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/CercaButtonFocus.png")));
	    		setCursor(new Cursor(Cursor.HAND_CURSOR));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
	    		bottoneCerca.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/CercaButton.png")));
	    	}
	    });
	}


	private void generaCampoDove() {
		textFieldDove = new JTextField();
	    textFieldDove.setColumns(10);
	    textFieldDove.setFont(new Font("Roboto", Font.PLAIN, 20));
	    textFieldDove.setBackground(new Color(51,51,51));
	    textFieldDove.setBorder(new LineBorder(new Color(51,51,51),1));
	    textFieldDove.setText("Dove?");
	    textFieldDove.setForeground(Color.LIGHT_GRAY);
	    textFieldDove.setCaretColor(Color.WHITE);
	    textFieldDove.addKeyListener(new KeyAdapter() {
	    	@Override
	    	public void keyPressed(KeyEvent e) {
	    		if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& textFieldDove.getText().length() <= 20) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE || e.getKeyCode() ==  KeyEvent.VK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
	    			textFieldDove.setEditable(true);
				else
					textFieldDove.setEditable(false);
	    		
				if(e.getKeyCode() == KeyEvent.VK_ENTER)
		    		Controller.getSchermataPrincipaleFrame().mostraRicercaLocali(textFieldCosa.getText(), textFieldDove.getText());
	    	}
	    });
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
	    
	    lineaTestoDove = new JLabel("");
	    lineaTestoDove.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaTestoBianca.png")));
	}


	private void generaCampoCosa() {
		textFieldCosa = new JTextField();
	    textFieldCosa.setColumns(10);
	    textFieldCosa.setFont(new Font("Roboto", Font.PLAIN, 20));
	    textFieldCosa.setBackground(new Color(51,51,51));
	    textFieldCosa.setBorder(new LineBorder(new Color(51,51,51),1));
	    textFieldCosa.setText("Cosa?");
	    textFieldCosa.setForeground(Color.LIGHT_GRAY);
	    textFieldCosa.setCaretColor(Color.WHITE);
	    textFieldCosa.addKeyListener(new KeyAdapter() {
	    	@Override
	    	public void keyPressed(KeyEvent e) {
	    		if((((e.getKeyChar() >= '0' && e.getKeyChar() <= '9') || (e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z') || (e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'))
						&& textFieldCosa.getText().length() <= 20) || e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE || e.getKeyCode() ==  KeyEvent.VK_SPACE ||
						e.getKeyCode() ==  KeyEvent.VK_DELETE)
					textFieldCosa.setEditable(true);
				else
					textFieldCosa.setEditable(false);
	    		
				if(e.getKeyCode() == KeyEvent.VK_ENTER)
		    		Controller.getSchermataPrincipaleFrame().mostraRicercaLocali(textFieldCosa.getText(), textFieldDove.getText());
	    	}
	    });
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
	    
	    lineaTestoCosa = new JLabel("");
	    lineaTestoCosa.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaTestoBianca.png")));
	}


	private void generaBottoneGestisciBusiness() {
		bottoneGestisciBusiness = new JButton("");
	    bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusiness.png")));
	    bottoneGestisciBusiness.setOpaque(false);
	    bottoneGestisciBusiness.setFocusPainted(false);
	    bottoneGestisciBusiness.setContentAreaFilled(false);
	    bottoneGestisciBusiness.setBorderPainted(false);
	    bottoneGestisciBusiness.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent e) {
	    		flagFocusBottone = 5;
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    		
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
	    		if(!Controller.getSchermataPrincipaleFrame().controllaVisibilitaPannelliBusiness())
	    			bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusiness.png")));
	    	}
	    });
	}


	private void generaBottoneAlloggi() {
		bottoneAlloggi = new JButton("");
	    bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
	    bottoneAlloggi.setOpaque(false);
	    bottoneAlloggi.setFocusPainted(false);
	    bottoneAlloggi.setContentAreaFilled(false);
	    bottoneAlloggi.setBorderPainted(false);
	    bottoneAlloggi.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 4;
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    		
	    		Controller.getSchermataPrincipaleFrame().mostraAlloggi();
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
	}


	private void generaBottoneAttrazioni() {
		bottoneAttrazioni = new JButton("");
	    bottoneAttrazioni.setOpaque(false);
	    bottoneAttrazioni.setFocusPainted(false);
	    bottoneAttrazioni.setContentAreaFilled(false);
	    bottoneAttrazioni.setBorderPainted(false);
	    bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/attrazioni.png")));
	    bottoneAttrazioni.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 3;
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    		
	    		Controller.getSchermataPrincipaleFrame().mostraAttrazioni();
	    	}
	    });
	    bottoneAttrazioni.addMouseListener(new MouseAdapter() {
	    	@Override
	    	public void mouseEntered(MouseEvent e) {
	    		bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/attrazioniFocus.png")));
	    	}
	    	@Override
	    	public void mouseExited(MouseEvent e) {
	    		if(flagFocusBottone != 3)
	    			bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/attrazioni.png")));
	    		else
	    			bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/attrazioniFocus.png")));
	    	}
	    });
	}


	private void generaBottoneRistoranti() {
		bottoneRistoranti = new JButton("");
	    bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
	    bottoneRistoranti.setOpaque(false);
	    bottoneRistoranti.setFocusPainted(false);
	    bottoneRistoranti.setContentAreaFilled(false);
	    bottoneRistoranti.setBorderPainted(false);
	    bottoneRistoranti.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 2;
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    		
	    		Controller.getSchermataPrincipaleFrame().mostraRistoranti();
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
	}


	private void generaBottoneHomepage() {
		bottoneHomepage = new JButton("");
	    bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
	    bottoneHomepage.setOpaque(false);
	    bottoneHomepage.setFocusPainted(false);
	    bottoneHomepage.setContentAreaFilled(false);
	    bottoneHomepage.setBorderPainted(false);
	    bottoneHomepage.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 1;
	    		cambiaFocusIconeSideBar(flagFocusBottone);
	    		
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
	}
	
	
	//METODI
	

	private void cambiaFocusIconeSideBar(int flag) {
		resettaFocusIconeSideBar();
		switch(flag) {
			case 1:
				bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepageFocus.png")));
				break;
			case 2:
				bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristorantiFocus.png")));
				break;
			case 3:
				bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/attrazioniFocus.png")));
				break;
			case 4:
				bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggiFocus.png")));
				break;
			case 5:
				bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusinessFocus.png")));
				break;
		}
	}
	
	
	private void resettaFocusIconeSideBar() {
		bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
		bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
		bottoneAttrazioni.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/attrazioni.png")));
		bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
		bottoneGestisciBusiness.setIcon(new ImageIcon(SideBar.class.getResource("/Icone/gestisciBusiness.png")));
	}
}
