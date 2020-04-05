package oggetti.GUI;

import java.awt.Color;
import java.awt.Font;
import java.awt.Image;

import javax.swing.GroupLayout;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.GroupLayout.Alignment;
import javax.swing.border.LineBorder;

import gestione.Controller;
import oggetti.Locale;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.io.File;

public class LocaleGUI extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private StelleGUI stelle;
	private JLabel testoNome;
	private JLabel testoIndirizzo;
	private JLabel labelImmaginePrincipale;
	
	private Locale locale;

	private Controller ctrl;
	
	public LocaleGUI(Locale locale, Controller ctrl) {
		this.locale = locale;
		this.ctrl = ctrl;
		
		generaEsteticaPannello();
		
		generaStelle();
		generaTestoNome();
		generaTestoIndirizzo();
		generaImmaginePrincipale();
		
		generaLayout();
	}
	
	private void generaEsteticaPannello() {
		setBackground(Color.WHITE);
		setSize(400,260);
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
		
		Image imgScalata = new ImageIcon(Locale.class.getResource("/Icone/placeholder.gif")).getImage().getScaledInstance(W, H, java.awt.Image.SCALE_SMOOTH);
		
		try {
			File fileImmagine = new File(locale.getImmaginePrincipale());
			if(fileImmagine.exists())
				imgScalata = new ImageIcon(fileImmagine.getAbsolutePath()).getImage().getScaledInstance(W, H, java.awt.Image.SCALE_SMOOTH);
		} catch (IndexOutOfBoundsException e) {
			e.printStackTrace();
		} finally{
			labelImmaginePrincipale.setIcon(new ImageIcon(imgScalata));
		}
	}

	private void generaLayout() {
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(12)
					.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
						.addGroup(groupLayout.createSequentialGroup()
							.addGroup(groupLayout.createParallelGroup(Alignment.LEADING)
								.addComponent(testoNome, GroupLayout.DEFAULT_SIZE, 185, Short.MAX_VALUE)
								.addGroup(groupLayout.createSequentialGroup()
									.addComponent(testoIndirizzo, GroupLayout.DEFAULT_SIZE, 179, Short.MAX_VALUE)
									.addGap(6)))
							.addGap(4)
							.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 185, GroupLayout.PREFERRED_SIZE))
						.addComponent(labelImmaginePrincipale, GroupLayout.DEFAULT_SIZE, 374, Short.MAX_VALUE))
					.addGap(12))
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(195)
					.addComponent(testoNome, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE)
					.addGap(5)
					.addComponent(testoIndirizzo, GroupLayout.PREFERRED_SIZE, 24, GroupLayout.PREFERRED_SIZE))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(205)
					.addComponent(stelle, GroupLayout.PREFERRED_SIZE, 43, GroupLayout.PREFERRED_SIZE))
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(16)
					.addComponent(labelImmaginePrincipale, GroupLayout.PREFERRED_SIZE, 184, GroupLayout.PREFERRED_SIZE))
		);
		setLayout(groupLayout);
	}
}
