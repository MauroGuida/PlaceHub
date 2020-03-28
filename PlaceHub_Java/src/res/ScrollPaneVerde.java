package res;

import java.awt.Color;
import java.awt.Dimension;

import javax.swing.JButton;
import javax.swing.JScrollPane;
import javax.swing.plaf.basic.BasicScrollBarUI;

public class ScrollPaneVerde extends JScrollPane {
	private static final long serialVersionUID = 1L;
	
	public ScrollPaneVerde() {
		this.getVerticalScrollBar().setUI(new BasicScrollBarUI()  {
            @Override 
            protected void configureScrollBarColors(){
                this.thumbColor = new Color(64,151,0);
            }
            @Override
            protected JButton createDecreaseButton(int orientation) {
                return createZeroButton();
            }

            @Override
            protected JButton createIncreaseButton(int orientation) {
                return createZeroButton();
            }

            private JButton createZeroButton() {
                JButton jbutton = new JButton();
                jbutton.setPreferredSize(new Dimension(0, 0));
                jbutton.setMinimumSize(new Dimension(0, 0));
                jbutton.setMaximumSize(new Dimension(0, 0));
                return jbutton;
            }
        });
		
		this.getHorizontalScrollBar().setUI(new BasicScrollBarUI()  {
            @Override 
            protected void configureScrollBarColors(){
                this.thumbColor = new Color(64,151,0);
            }
            @Override
            protected JButton createDecreaseButton(int orientation) {
                return createZeroButton();
            }

            @Override
            protected JButton createIncreaseButton(int orientation) {
                return createZeroButton();
            }

            private JButton createZeroButton() {
                JButton jbutton = new JButton();
                jbutton.setPreferredSize(new Dimension(0, 0));
                jbutton.setMinimumSize(new Dimension(0, 0));
                jbutton.setMaximumSize(new Dimension(0, 0));
                return jbutton;
            }
        });
	}
}
