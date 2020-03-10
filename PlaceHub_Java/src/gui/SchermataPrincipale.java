package gui;

import javax.swing.JFrame;

import gestione.Controller;
import javax.swing.JPanel;
import javax.swing.JButton;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;
import javax.swing.ImageIcon;
import javax.swing.LayoutStyle.ComponentPlacement;
import javax.swing.border.LineBorder;

import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.ActionEvent;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Cursor;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;

import javax.swing.JTextField;
import java.awt.event.FocusAdapter;
import java.awt.event.FocusEvent;
import javax.swing.JLabel;


public class SchermataPrincipale extends JFrame {
	private static final long serialVersionUID = 1L;
	private Controller ctrl;
	private JButton bottoneEsci;
	private int coordinataX;
	private int coordinataY;
	private JTextField textFieldCosa;
	private JTextField textFieldDove;
	private JButton bottoneHomepage;
	private JButton bottoneRistoranti;
	private JButton bottoneIntrattenimento;
	private JButton bottoneAlloggi;
	private int flagFocusBottone;
	
	public SchermataPrincipale(Controller Ctrl) {
		getContentPane().setBackground(Color.WHITE);
		this.ctrl = Ctrl;
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setBounds(100, 100, 450, 300);
		setSize(1100,650);
		setMinimumSize(new Dimension(1100,650));
		setUndecorated(true);
		setResizable(true);
		
		
		addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                coordinataX = e.getX();
                coordinataY = e.getY();
                setCursor(new Cursor(Cursor.HAND_CURSOR));
            }
            @Override
			public void mouseReleased(MouseEvent e) {
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
        });
        addMouseMotionListener(new MouseAdapter() {
            @Override
            public void mouseDragged(MouseEvent e) {
                setLocation(e.getXOnScreen()- coordinataX,e.getYOnScreen()-coordinataY);
            }
        });
		
		JPanel panelloSideBar = new JPanel();
		panelloSideBar.setBackground(new Color(51,51,51));
		
	    bottoneHomepage = new JButton("");
	    bottoneHomepage.addActionListener(new ActionListener() {
	    	public void actionPerformed(ActionEvent arg0) {
	    		flagFocusBottone = 1;
	    		cambiaIcona(flagFocusBottone);
	    		resettaIcone(flagFocusBottone);
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
					resettaIcone(flagFocusBottone);
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
				cambiaIcona(flagFocusBottone);
				resettaIcone(flagFocusBottone);
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
					resettaIcone(flagFocusBottone);
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
					resettaIcone(flagFocusBottone);
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
				cambiaIcona(flagFocusBottone);
				resettaIcone(flagFocusBottone);
			}
		});
		
		bottoneAlloggi = new JButton("");
		bottoneAlloggi.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				flagFocusBottone = 4;
				cambiaIcona(flagFocusBottone);
				resettaIcone(flagFocusBottone);
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
					resettaIcone(flagFocusBottone);
			}
		});
		bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
		bottoneAlloggi.setOpaque(false);
		bottoneAlloggi.setFocusPainted(false);
		bottoneAlloggi.setContentAreaFilled(false);
		bottoneAlloggi.setBorderPainted(false);
		JPanel pannelloCerca = new JPanel();
		pannelloCerca.setBackground(new Color(51,51,51));
		
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
				.addComponent(pannelloCerca, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
				.addComponent(bottoneGestisciBusiness, GroupLayout.PREFERRED_SIZE, 250, GroupLayout.PREFERRED_SIZE)
		);
		gl_panelloSideBar.setVerticalGroup(
			gl_panelloSideBar.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_panelloSideBar.createSequentialGroup()
					.addComponent(bottoneHomepage, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
					.addComponent(bottoneRistoranti, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
					.addComponent(bottoneIntrattenimento, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
					.addComponent(bottoneAlloggi, GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
					.addComponent(pannelloCerca, GroupLayout.DEFAULT_SIZE, 180, Short.MAX_VALUE)
					.addComponent(bottoneGestisciBusiness, GroupLayout.DEFAULT_SIZE, 150, Short.MAX_VALUE))
		);
		
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
		
		JButton bottoneCercaSideBar = new JButton("");
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
		
		JLabel lineaTestoCosaSideBar = new JLabel("");
		lineaTestoCosaSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaTestoBianca.png")));
		
		JLabel lineaTestoDoveSideBar = new JLabel("");
		lineaTestoDoveSideBar.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/lineaTestoBianca.png")));
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
		panelloSideBar.setLayout(gl_panelloSideBar);
		
		JPanel pannelloBottoni = new JPanel();
		pannelloBottoni.setBackground(Color.WHITE);
		
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
		bottoneEsci.setFocusPainted(false);
		
		JButton bottoneMassimizza = new JButton("");
		bottoneMassimizza.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if(getExtendedState() != SchermataPrincipale.MAXIMIZED_BOTH) {
					setExtendedState(SchermataPrincipale.MAXIMIZED_BOTH);
				}else {
					setExtendedState(SchermataPrincipale.NORMAL);
				}
			}
		});
		bottoneMassimizza.setOpaque(false);
		bottoneMassimizza.setContentAreaFilled(false);
		bottoneMassimizza.setBorderPainted(false);
		bottoneMassimizza.setFocusPainted(false);
		bottoneMassimizza.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IncreaseSize.png")));
		
		JButton bottoneMinimizza = new JButton("");
		bottoneMinimizza.setOpaque(false);
		bottoneMinimizza.setBorderPainted(false);
		bottoneMinimizza.setContentAreaFilled(false);
		bottoneMinimizza.setFocusPainted(false);
		bottoneMinimizza.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/minimizza.png")));
		bottoneMinimizza.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				setState(ICONIFIED);
			}
		});
		
		pannelloBottoni.setLayout(new FlowLayout(FlowLayout.RIGHT, -10, 0));
		pannelloBottoni.add(bottoneMinimizza, BorderLayout.EAST);
		pannelloBottoni.add(bottoneMassimizza, BorderLayout.EAST);
		pannelloBottoni.add(bottoneEsci, BorderLayout.EAST);
		
		JPanel panel = new JPanel();
		GroupLayout groupLayout = new GroupLayout(getContentPane());
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addComponent(panelloSideBar, GroupLayout.PREFERRED_SIZE, GroupLayout.DEFAULT_SIZE, GroupLayout.PREFERRED_SIZE)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(pannelloBottoni, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
						.addComponent(panel, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addComponent(panelloSideBar, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
				.addGroup(groupLayout.createSequentialGroup()
					.addComponent(pannelloBottoni, GroupLayout.PREFERRED_SIZE, 36, GroupLayout.PREFERRED_SIZE)
					.addComponent(panel, GroupLayout.DEFAULT_SIZE, 614, Short.MAX_VALUE))
		);
		GroupLayout gl_panel = new GroupLayout(panel);
		gl_panel.setHorizontalGroup(
			gl_panel.createParallelGroup(Alignment.LEADING)
				.addGap(0, 850, Short.MAX_VALUE)
		);
		gl_panel.setVerticalGroup(
			gl_panel.createParallelGroup(Alignment.LEADING)
				.addGap(0, 614, Short.MAX_VALUE)
		);
		panel.setLayout(gl_panel);
		getContentPane().setLayout(groupLayout);
		
	}
	
	private void cambiaIcona(int flag) {
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
	
	private void resettaIcone(int flag) {
		switch(flag) {
			case 1:
				bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
				bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimento.png")));
				bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
				break;
			case 2:
				bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
				bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimento.png")));
				bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
				break;
			case 3:
				bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
				bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
				bottoneAlloggi.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/alloggi.png")));
				break;
			case 4:
				bottoneHomepage.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/homepage.png")));
				bottoneRistoranti.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/ristoranti.png")));
				bottoneIntrattenimento.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/intrattenimento.png")));
				break;		
		}
	}
	
}
