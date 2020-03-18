package gui.pannelliSchermataPrincipale;

import java.awt.Color;

import javax.swing.JPanel;
import javax.swing.ScrollPaneConstants;
import javax.swing.border.LineBorder;

import oggetti.Locale;
import res.ScrollPaneVerde;
import res.WrapLayout;
import javax.swing.GroupLayout;
import javax.swing.GroupLayout.Alignment;

public class Ricerche extends JPanel {
	private static final long serialVersionUID = 1L;
	private JPanel pannelloRisulatoRicerca;
	private ScrollPaneVerde scorrimentoRisultati;
	
	public Ricerche() {
		setSize(850, 614);
		setVisible(false);
		setBackground(Color.WHITE);
		
	    pannelloRisulatoRicerca = new JPanel();
	    pannelloRisulatoRicerca.setBackground(Color.WHITE);
	    pannelloRisulatoRicerca.setLayout(new WrapLayout(WrapLayout.CENTER));
	    
	    scorrimentoRisultati = new ScrollPaneVerde();
	    scorrimentoRisultati.setViewportView(pannelloRisulatoRicerca);
	    scorrimentoRisultati.setBackground(Color.WHITE);
	    scorrimentoRisultati.setBorder(new LineBorder(Color.WHITE,1));
	    
	    scorrimentoRisultati.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS);
	    scorrimentoRisultati.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
	    scorrimentoRisultati.getVerticalScrollBar().setUnitIncrement(15);
	    scorrimentoRisultati.getVerticalScrollBar().setBackground(Color.WHITE);
		
	    generaLayout();
	}

	private void generaLayout() {
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
	
	
	public void addRisultatoRicerca(Locale risultatoRicerca) {
		pannelloRisulatoRicerca.add(risultatoRicerca);
	}
	
	public void svuotaRicerche() {
		pannelloRisulatoRicerca.removeAll();
	}
}
