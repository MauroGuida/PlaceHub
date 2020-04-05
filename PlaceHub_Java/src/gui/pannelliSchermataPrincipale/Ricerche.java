package gui.pannelliSchermataPrincipale;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.ScrollPaneConstants;
import javax.swing.border.LineBorder;

import oggetti.GUI.ScrollPaneVerde;
import res.WrapLayout;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

public class Ricerche extends JPanel {
	private static final long serialVersionUID = 1L;
	private JPanel pannelloRisultatoRicerca;
	private ScrollPaneVerde scorrimentoRisultati;
	
	public Ricerche() {
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		
	    pannelloRisultatoRicerca = new JPanel();
	    pannelloRisultatoRicerca.setBackground(Color.WHITE);
	    pannelloRisultatoRicerca.setLayout(new WrapLayout(WrapLayout.CENTER));
	    
	    scorrimentoRisultati = new ScrollPaneVerde();
	    scorrimentoRisultati.setViewportView(pannelloRisultatoRicerca);
	    scorrimentoRisultati.setBackground(Color.WHITE);
	    scorrimentoRisultati.setBorder(new LineBorder(Color.WHITE,1));
	    
	    scorrimentoRisultati.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);
	    scorrimentoRisultati.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
	    scorrimentoRisultati.getVerticalScrollBar().setUnitIncrement(15);
	    scorrimentoRisultati.getVerticalScrollBar().setBackground(Color.WHITE);
		
		GroupLayout groupLayout = new GroupLayout(this);
	    groupLayout.setHorizontalGroup(
	    	groupLayout.createParallelGroup(Alignment.LEADING)
	    		.addComponent(scorrimentoRisultati, GroupLayout.DEFAULT_SIZE, 850, Short.MAX_VALUE)
	    );
	    groupLayout.setVerticalGroup(
	    	groupLayout.createParallelGroup(Alignment.LEADING)
	    		.addComponent(scorrimentoRisultati, GroupLayout.DEFAULT_SIZE, 614, Short.MAX_VALUE)
	    );
	    setLayout(groupLayout);
	}
	
	
	//METODI
	
	
	public void addRisultatoRicerca(JPanel risultatoRicerca) {
		pannelloRisultatoRicerca.add(risultatoRicerca);
	}
	
	public void svuotaRicerche() {
		pannelloRisultatoRicerca.removeAll();
	}
}
