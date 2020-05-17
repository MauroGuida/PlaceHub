package frameGUI.pannelliSchermataAccesso;

import java.awt.Color;
import java.awt.Cursor;
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

import frameGUI.SchermataAccesso;
import gestione.Controller;

public class Bottoni extends JPanel {
	private static final long serialVersionUID = 1L;

	private JButton bottoneMinimizza;
	private JButton bottoneEsci;
	
	private Point clickIniziale;
	
	public Bottoni() {
		setSize(550, 36);
		setBackground(Color.WHITE);
		setLayout(null);
		
		generaBottoneEsci();		
		generaBottoneMinimizza();
		gestioneRiposizionamentoFinestra();
	}

	private void generaBottoneMinimizza() {
		bottoneMinimizza = new JButton("");
		bottoneMinimizza.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/minimizza.png")));
		bottoneMinimizza.setBounds(475, 5, 24, 25);
		bottoneMinimizza.setOpaque(false);
		bottoneMinimizza.setContentAreaFilled(false);
		bottoneMinimizza.setBorderPainted(false);
		bottoneMinimizza.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				Controller.getSchermataAccessoFrame().setState(Frame.ICONIFIED);
			}
		});
		add(bottoneMinimizza);
	}

	private void generaBottoneEsci() {
		bottoneEsci = new JButton("");
		bottoneEsci.setIcon(new ImageIcon(SchermataAccesso.class.getResource("/Icone/X.png")));
		bottoneEsci.setBounds(520, 8, 22, 22);
		bottoneEsci.setBorderPainted(false);
		bottoneEsci.setContentAreaFilled(false);
		bottoneEsci.setOpaque(false);
		bottoneEsci.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				System.exit(0);
			}
		});
		add(bottoneEsci);
	}

	public void gestioneRiposizionamentoFinestra() {
		this.addMouseListener(new MouseAdapter() {
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
		this.addMouseMotionListener(new MouseMotionAdapter() {
			@Override
			public void mouseDragged(MouseEvent e) {
				int x = Controller.getSchermataAccessoFrame().getLocation().x;
				int y = Controller.getSchermataAccessoFrame().getLocation().y;
				int xMoved = e.getX() - clickIniziale.x;
				int yMoved = e.getY() - clickIniziale.y;
				Controller.getSchermataAccessoFrame().setLocation(x + xMoved, y + yMoved);
			}
		});
	}
}
