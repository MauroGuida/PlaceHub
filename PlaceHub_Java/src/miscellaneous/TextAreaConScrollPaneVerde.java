package miscellaneous;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import javax.swing.JPanel;
import javax.swing.JTextArea;
import javax.swing.border.LineBorder;

import java.awt.BorderLayout;

public class TextAreaConScrollPaneVerde extends JPanel {
	private static final long serialVersionUID = 1L;
	
	private ScrollPaneVerde scrollPane;
	private JTextArea textArea;
	
	public TextAreaConScrollPaneVerde() {
		setLayout(new BorderLayout(0, 0));
		setSize(795, 247);
		
		scrollPane = new ScrollPaneVerde();
		scrollPane.setBorder(new LineBorder(Color.BLACK,1));
		
		textArea = new JTextArea();
		textArea.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				if(((e.getKeyChar() >= '0' && e.getKeyChar() <= '9' || e.getKeyChar() >= 'A' && e.getKeyChar() <= 'Z' || e.getKeyChar() >= 'a' && e.getKeyChar() <= 'z'
						|| e.getKeyCode() ==  KeyEvent.VK_BACK_SPACE || e.getKeyCode() ==  KeyEvent.VK_SPACE || e.getKeyCode() ==  KeyEvent.VK_DELETE ||
						e.getModifiersEx() ==  KeyEvent.CTRL_DOWN_MASK) && textArea.getText().length() <= 1999))
					textArea.setEditable(true);
				else
					textArea.setEditable(false);
			}
		});
		textArea.setForeground(new Color(192, 192, 192));
		textArea.setBackground(new Color(255, 255, 255));
		textArea.setFont(new Font("Roboto", Font.PLAIN, 17));
		textArea.setText("Scrivi qui! MAX(2000 caratteri)");
		textArea.setForeground(Color.DARK_GRAY);
		textArea.setLineWrap(true);
		textArea.setWrapStyleWord(true);
		textArea.addMouseListener(new MouseAdapter() {
			@Override
			public void mouseClicked(MouseEvent e) {
				if((textArea.getText().isEmpty() || textArea.getText().isBlank()) ||
						textArea.getText().equals("Scrivi qui! MAX(2000 caratteri)")) {
					textArea.setText("");
					textArea.setForeground(Color.BLACK);
				}
			}
		});
		scrollPane.setViewportView(textArea);
		
		add(scrollPane);
	}
	
	public String getText() {
		return textArea.getText();
	}
	
	public void setText(String text) {
		textArea.setText(text);
		textArea.setForeground(Color.BLACK);
	}
	
	@Override
	public void setForeground(Color newColor) {
		if(textArea != null)
			textArea.setForeground(newColor);
	}
	
	public void setEditable(boolean value) {
		textArea.setEditable(value);
	}
}
