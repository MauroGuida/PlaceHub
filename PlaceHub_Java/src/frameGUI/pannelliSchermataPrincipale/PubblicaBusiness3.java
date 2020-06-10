package frameGUI.pannelliSchermataPrincipale;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.GroupLayout;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;

import gestione.Controller;

import javax.swing.GroupLayout.Alignment;

import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.border.LineBorder;

import frameGUI.SchermataPrincipale;

import javax.swing.SwingConstants;

public class PubblicaBusiness3 extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private JLabel testoRegistrazioneAvvenutaConSuccesso;
	private JLabel immagineVerificato;
	private JButton bottoneOK;
	private JPanel pannelloMessaggio;
	private Controller ctrl;

	public PubblicaBusiness3(Controller ctrl) {
		this.ctrl = ctrl;
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		
		generaBottoneOK();	
		generaPannelloMessaggio();
		generaLayout();
	}

	private void generaPannelloMessaggio() {
		pannelloMessaggio = new JPanel();
		pannelloMessaggio.setBackground(Color.WHITE);
		pannelloMessaggio.setBorder(new LineBorder(Color.WHITE, 1));
		
		testoRegistrazioneAvvenutaConSuccesso = new JLabel("Registrazione avvenuta con successo!");
		testoRegistrazioneAvvenutaConSuccesso.setHorizontalAlignment(SwingConstants.CENTER);
		testoRegistrazioneAvvenutaConSuccesso.setFont(new Font("Roboto", Font.PLAIN, 23));
		
		immagineVerificato = new JLabel("");
		immagineVerificato.setHorizontalAlignment(SwingConstants.CENTER);
		immagineVerificato.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/verified.png")));
		
		generaLayoutPannelloMessaggio();
	}

	private void generaLayoutPannelloMessaggio() {
		GroupLayout gl_pannelloMessaggio = new GroupLayout(pannelloMessaggio);
		gl_pannelloMessaggio.setHorizontalGroup(
			gl_pannelloMessaggio.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pannelloMessaggio.createSequentialGroup()
					.addGap(218)
					.addComponent(immagineVerificato, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(218))
				.addGroup(gl_pannelloMessaggio.createSequentialGroup()
					.addGap(80)
					.addComponent(testoRegistrazioneAvvenutaConSuccesso, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(81))
		);
		gl_pannelloMessaggio.setVerticalGroup(
			gl_pannelloMessaggio.createParallelGroup(Alignment.LEADING)
				.addGroup(gl_pannelloMessaggio.createSequentialGroup()
					.addGap(40)
					.addComponent(immagineVerificato, GroupLayout.PREFERRED_SIZE, 120, GroupLayout.PREFERRED_SIZE)
					.addGap(20)
					.addComponent(testoRegistrazioneAvvenutaConSuccesso)
					.addContainerGap(90, Short.MAX_VALUE))
		);
		pannelloMessaggio.setLayout(gl_pannelloMessaggio);
	}

	private void generaBottoneOK() {
		bottoneOK = new JButton("");
		bottoneOK.setOpaque(false);
		bottoneOK.setBorderPainted(false);
		bottoneOK.setContentAreaFilled(false);
		bottoneOK.setFocusPainted(false);
		bottoneOK.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOK.png")));
		bottoneOK.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseEntered(MouseEvent e) {
				bottoneOK.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOKFocus.png")));
			}
			@Override
			public void mouseExited(MouseEvent e) {
				bottoneOK.setIcon(new ImageIcon(SchermataPrincipale.class.getResource("/Icone/bottoneOK.png")));
			}
		});
		bottoneOK.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent e) {
				ctrl.mostraHompageSchermataPrincipale();
			}
		});
	}

	private void generaLayout() {
		GroupLayout groupLayout = new GroupLayout(this);
		groupLayout.setHorizontalGroup(
			groupLayout.createParallelGroup(Alignment.TRAILING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(147)
					.addComponent(pannelloMessaggio, GroupLayout.DEFAULT_SIZE, GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
					.addGap(147))
				.addGroup(groupLayout.createSequentialGroup()
					.addContainerGap(677, Short.MAX_VALUE)
					.addComponent(bottoneOK, GroupLayout.PREFERRED_SIZE, 163, GroupLayout.PREFERRED_SIZE)
					.addContainerGap())
		);
		groupLayout.setVerticalGroup(
			groupLayout.createParallelGroup(Alignment.LEADING)
				.addGroup(groupLayout.createSequentialGroup()
					.addGap(157)
					.addComponent(pannelloMessaggio, GroupLayout.DEFAULT_SIZE, 300, Short.MAX_VALUE)
					.addGap(76)
					.addComponent(bottoneOK)
					.addGap(21))
		);
		setLayout(groupLayout);
	}
}
