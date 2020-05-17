package miscellaneousGUI;

import java.awt.Color;
import java.awt.Font;
import java.awt.Image;

import javax.imageio.ImageIO;
import javax.swing.GroupLayout;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.GroupLayout.Alignment;
import javax.swing.border.LineBorder;

import gestione.Controller;
import oggettiServizio.Business;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.net.URL;

import javax.swing.JPopupMenu;
import java.awt.Component;
import java.awt.Dimension;

import javax.swing.JMenuItem;

public class LocaleGUI extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private StelleGUI stelle;
	private JLabel testoNome;
	private JLabel testoIndirizzo;
	private JLabel labelImmaginePrincipale;
	
	private Business locale;

	private Controller ctrl;
	private JPopupMenu popupMenu;
	private JMenuItem menuItemModifica;

	public LocaleGUI(Business locale, Controller ctrl) {
		this.locale = locale;
		this.ctrl = ctrl;
		
		generaEsteticaPannello();
		
		generaStelle();
		generaTestoNome();
		generaTestoIndirizzo();
		generaImmaginePrincipale();
		
		popupMenuProprietari();
		
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(12)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addComponent(testoNome, GroupLayout.PREFERRED_SIZE, 185, GroupLayout.PREFERRED_SIZE)
						.addComponent(labelImmaginePrincipale, GroupLayout.DEFAULT_SIZE, 374, Short.MAX_VALUE))
					.addGap(12))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(12)
					.addComponent(testoIndirizzo, GroupLayout.PREFERRED_SIZE, 179, GroupLayout.PREFERRED_SIZE))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(201)
					.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 185, GroupLayout.PREFERRED_SIZE))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(16)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addGap(179)
							.addComponent(testoNome, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE))
						.addGroup(groupLayout.createSequentialGroup()
							.addComponent(labelImmaginePrincipale, GroupLayout.DEFAULT_SIZE, 180, Short.MAX_VALUE)
							.addGap(23)))
					.addGap(5)
					.addComponent(testoIndirizzo, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE)
					.addGap(10))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(205)
					.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 43, GroupLayout.PREFERRED_SIZE))
		);
		setLayout(groupLayout);
	}
	
	/**
	 * @wbp.parser.constructor
	 */
	public LocaleGUI(Business locale, Controller ctrl, boolean consentiModifica) {
		this(locale, ctrl);
		
		if(consentiModifica)
			addPopup(labelImmaginePrincipale, popupMenu);
	}
	
	private void popupMenuProprietari() {
		popupMenu = new JPopupMenu();
		
		menuItemModifica = new JMenuItem("Modifica");
		menuItemModifica.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
            	ctrl.modificaBusinessPubblicaBusiness1(locale.getCodBusiness());
            }
        });
		popupMenu.add(menuItemModifica);
	}
	
	private void generaEsteticaPannello() {
		setBackground(Color.WHITE);
		setSize(400,260);
		setMinimumSize(new Dimension(400,260));
		setMaximumSize(new Dimension(400,260));
		setVisible(true);
		setBorder(new LineBorder(Color.DARK_GRAY,1));
	}

	private void generaStelle() {
		stelle = new StelleGUI();
		stelle.aggiungiStelle(locale.getStelle());
	}

	
	private void generaTestoIndirizzo() {
		testoIndirizzo = new JLabel(locale.getIndirizzo());
		testoIndirizzo.setFont(new Font("Roboto", Font.PLAIN, 17));
	}

	private void generaTestoNome() {
		testoNome = new JLabel(locale.getNome());
		testoNome.setFont(new Font("Roboto", Font.PLAIN, 17));
	}

	private void generaImmaginePrincipale() {
		labelImmaginePrincipale = new JLabel();
		labelImmaginePrincipale.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				ctrl.vaiAVisitaBusiness(locale.getCodBusiness());
			}
		});
		
		final int W = 374;
		final int H = 180;
		
		Image imgScalata = new ImageIcon(Business.class.getResource("/Icone/placeholder.gif")).getImage().getScaledInstance(W, H, java.awt.Image.SCALE_SMOOTH);
		
		try {
			if(locale.getImmaginePrincipale().contains("http://") || locale.getImmaginePrincipale().contains("https://")) {
				URL url = new URL(locale.getImmaginePrincipale());
				BufferedImage img = ImageIO.read(url);
				imgScalata = new ImageIcon(img).getImage().getScaledInstance(W, H, java.awt.Image.SCALE_SMOOTH);
			}else {
				File fileImmagine = new File(locale.getImmaginePrincipale());
				if(fileImmagine.exists())
					imgScalata = new ImageIcon(fileImmagine.getAbsolutePath()).getImage().getScaledInstance(W, H, java.awt.Image.SCALE_SMOOTH);
			}
		} catch (IndexOutOfBoundsException | IOException e) {
//			Verra' visualizzato il placehoder
		} finally{
			labelImmaginePrincipale.setIcon(new ImageIcon(imgScalata));
		}
	}
	private static void addPopup(Component component, final JPopupMenu popup) {
		component.addMouseListener(new MouseAdapter() {
			public void mousePressed(MouseEvent e) {
				if (e.isPopupTrigger()) {
					showMenu(e);
				}
			}
			public void mouseReleased(MouseEvent e) {
				if (e.isPopupTrigger()) {
					showMenu(e);
				}
			}
			private void showMenu(MouseEvent e) {
				popup.show(e.getComponent(), e.getX(), e.getY());
			}
		});
	}
}
