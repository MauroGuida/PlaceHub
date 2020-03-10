package res;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;

//create class
public class DatePicker extends JDialog
{
	private static final long serialVersionUID = 1L;
	
		//define variables
        int month = 0;
        int year = 1990;
        //create object of JLabel with alignment
        JTextField textFieldDisplay = new JTextField("", JTextField.CENTER);
        //define variable
        String day = "";
        //create object of JButton
        JButton[] button = new JButton[49];

        public DatePicker(JFrame parent)//create constructor 
        {
        		ActionListener esciShortcut = new ActionListener(){
                    public void actionPerformed(ActionEvent ae){
                        dispose();
                    }
               };
               getRootPane().registerKeyboardAction(esciShortcut, "command", KeyStroke.getKeyStroke(KeyEvent.VK_ESCAPE, 0),
            		   JComponent.WHEN_IN_FOCUSED_WINDOW);
        	
                //set modal true
                setModal(true);
                //define string
                String[] header = { "Sun", "Mon", "Tue", "Wed", "Thur", "Fri", "Sat" };
                //create JPanel object and set layout
                JPanel p1 = new JPanel(new GridLayout(7, 7));
                //set size
                p1.setPreferredSize(new Dimension(420, 200));
                p1.setBackground(Color.WHITE);
                //for loop condition
                for (int x = 0; x < button.length; x++) 
                {		
                	//define variable
                        final int selection = x;
                        //create object of JButton
                        button[x] = new JButton();
                        //set focus painted false
                        button[x].setFocusPainted(false);
                        
                        button[x].setOpaque(false);
                        button[x].setContentAreaFilled(false);
                        button[x].setFont(new Font("Roboto", Font.PLAIN, 12));
                        
                        //set background colour
                        button[x].setBackground(Color.white);
                        //if loop condition
                        if (x > 6)
                        //add action listener
                        button[x].addActionListener(new ActionListener() 
                        {
                                 public void actionPerformed(ActionEvent ae) 
                                 {
                                       day = button[selection].getActionCommand();
                                       //call dispose() method
                                       dispose();
                                 }
                        });
                        if (x < 7)//if loop condition 
                        {
                                button[x].setText(header[x]);
                                //set fore ground colour
                                button[x].setForeground(new Color(64,151,0));
                        }
                        p1.add(button[x]);//add button
                }
                //create JPanel object with grid layout
                JPanel p2 = new JPanel(new GridLayout(1, 5));
                
                textFieldDisplay.setHorizontalAlignment(SwingConstants.CENTER);
                
                //create object of button for previous month
                JButton previousMonth = new JButton("<");
                //add action command
                previousMonth.addActionListener(new ActionListener() 
                {
                        public void actionPerformed(ActionEvent ae) 
                        {
                            //decrement month by 1
                            month--;
                            //call method
                            displayDate();
                        }
                });
                
                
                JButton previousYear = new JButton("<<");
                previousYear.addActionListener(new ActionListener() {
                	public void actionPerformed(ActionEvent ae) 
                    {
                        //decrement month by 1
                        year--;
                        //call method
                        displayDate();
                    }
                });
                
                JButton nextYear = new JButton(">>");
                nextYear.addActionListener(new ActionListener() {
                	public void actionPerformed(ActionEvent ae) 
                    {
                        //decrement month by 1
                        year++;
                        //call method
                        displayDate();
                    }
                });
                
                
                //create object of button for next month
                JButton nextMonth = new JButton(">");
                //add action command
                nextMonth.addActionListener(new ActionListener()
                {
                        public void actionPerformed(ActionEvent ae) 
                        {
                             //increment month by 1
                             month++;
                             //call method
                            displayDate();
                        }
                });
                  
                
                p2.add(previousYear);
                p2.add(previousMonth);
                p2.add(textFieldDisplay);
                p2.add(nextMonth);
                p2.add(nextYear);
                
                textFieldDisplay.setEditable(false);
                setBackground(Color.WHITE);
                setUndecorated(true);
                setResizable(false);
                textFieldDisplay.setBackground(Color.WHITE);
                
                //set border alignment
                getContentPane().add(p1, BorderLayout.CENTER);
                getContentPane().add(p2, BorderLayout.SOUTH);
                pack();
                //set location
                setLocationRelativeTo(parent);
                //call method
                displayDate();
                //set visible true
                setVisible(true);
        }

        public void displayDate() 
        {
        	for (int x = 7; x < button.length; x++)//for loop
        	button[x].setText("");//set text
      	        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");	
                //create object of SimpleDateFormat 
                java.util.Calendar cal = java.util.Calendar.getInstance();			
                //create object of java.util.Calendar 
        	cal.set(year, month, 1); //set year, month and date
         	//define variables
        	int dayOfWeek = cal.get(java.util.Calendar.DAY_OF_WEEK);
        	int daysInMonth = cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
        	//condition
        	for (int x = 6 + dayOfWeek, day = 1; day <= daysInMonth; x++, day++)
        	//set text
        	button[x].setText("" + day);
        	textFieldDisplay.setText(sdf.format(cal.getTime()));
        	//set title
        	setTitle("Date Picker");
        }

        public String setPickedDate() 
        {
        	//if condition
        	if (day.equals(""))
        		return day;
            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.util.Calendar cal = java.util.Calendar.getInstance();
            cal.set(year, month, Integer.parseInt(day));
            return sdf.format(cal.getTime());
        }
}
