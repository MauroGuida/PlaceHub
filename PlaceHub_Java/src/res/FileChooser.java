package res;

import java.io.File;

import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;

public class FileChooser {
	public File selezionaFile() {
		File documento = null;
		
		JFileChooser chooser = new JFileChooser();
		FileNameExtensionFilter filter = new FileNameExtensionFilter("Images OR PDF", "jpg", "gif", "png", "pdf");
		chooser.setFileFilter(filter);
		int returnVal = chooser.showOpenDialog(null);
		if(returnVal == JFileChooser.APPROVE_OPTION) {
		        documento = new File(chooser.getSelectedFile().getPath());
		}
		
		return documento;
	}
}
