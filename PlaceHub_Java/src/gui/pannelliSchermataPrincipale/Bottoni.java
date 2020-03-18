package gui.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.Cursor;
import java.awt.FlowLayout;
import java.awt.Frame;
import java.awt.Point;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseMotionAdapter;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JPanel;

import gestione.Controller;
import gui.SchermataAccesso;
import gui.SchermataPrincipale;

public class Bottoni extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JButton bottoneEsci;
	private JButton bottoneMinimizza;
	private JButton bottoneMassimizza;
	
	private Point clickIniziale;
	
	
	public Bottoni() {
		setSize(850, 36);
		setVisible(true);
		setBackground(Color.WHITE);
		FlowLayout flowLayout = new FlowLayout(FlowLayout.RIGHT);
		flowLayout.setVgap(3);
		flowLayout.setHgap(-7);
		setLayout(flowLayout);
		
		generaBottoneMinimizza();
		generaBottoneMassimizza();
		generaBottoneEsci();
		
		movimentoSchermataPrincipale();	
	}

	private void movimentoSchermataPrincipale() {
		addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent e) {
				clickIniziale = e.getPoint();
                setCursor(new Cursor(Cursor.HAND_CURSOR));
			}
			@Override
			public void mouseReleased(MouseEvent e) {
				setCursor(new Cursor(Cursor.DEFAULT_CURSOR));
			}
		});
		addMouseMotionListener(new MouseMotionAdapter() {
			@Override
			public void mouseDragged(MouseEvent e) {
				int x = Controller.getSchermataPrincipaleFrame().getLocation().x;
				int y = Controller.getSchermataPrincipaleFrame().getLocation().y;
				int xMoved = e.getX() - clickIniziale.x;
				int yMoved = e.getY() - clickIniziale.y;
				Controller.getSchermataPrincipaleFrame().setLocation(x + xMoved, y + yMoved);
			}
		});
	}

	private void generaBottoneEsci() {
		bottoneEsci = new JButton("");
		bottoneEsci.setSize(57, 33);
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
		
		add(bottoneEsci);
	}

	private void generaBottoneMassimizza() {
		bottoneMassimizza = new JButton("");
		bottoneMassimizza.setSize(57, 33);
		bottoneMassimizza.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				if(Controller.getSchermataPrincipaleFrame().getExtendedState() != Frame.MAXIMIZED_BOTH) {
					Controller.getSchermataPrincipaleFrame().setExtendedState(SchermataPrincipale.MAXIMIZED_BOTH);
				}else {
					Controller.getSchermataPrincipaleFrame().setExtendedState(SchermataPrincipale.NORMAL);
				}
			}
		});
		bottoneMassimizza.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/IncreaseSize.png")));
		bottoneMassimizza.setOpaque(false);
		bottoneMassimizza.setContentAreaFilled(false);
		bottoneMassimizza.setBorderPainted(false);
		bottoneMassimizza.setFocusPainted(false);
		
		
		add(bottoneMassimizza);
	}

	private void generaBottoneMinimizza() {
		bottoneMinimizza = new JButton("");
		bottoneMinimizza.setSize(57, 33);
		bottoneMinimizza.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				 Controller.getSchermataPrincipaleFrame().setState(Frame.ICONIFIED);
			}
		});
		bottoneMinimizza.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/minimizza.png")));
		bottoneMinimizza.setOpaque(false);
		bottoneMinimizza.setContentAreaFilled(false);
		bottoneMinimizza.setFocusPainted(false);
		bottoneMinimizza.setBorderPainted(false);
		
		add(bottoneMinimizza);
	}
	
}
