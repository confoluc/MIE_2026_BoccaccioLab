// Select folders
Chdir = getDirectory("Select folder with images to calculate ACF profiles");
ROIsdir = getDirectory("Select folder with ROIs to calculate ACF profiles");

// Get the lists of files
ChList = getFileList(Chdir);
ROIsList = getFileList(ROIsdir);

// Select a folder to output the ACF tables
output_dir = getDirectory("Select folder to save ACF data");

setBatchMode(true);
for (i = 0; i < lengthOf(ChList); i++) {
	// Define the "paths" by concatenation of dir and the i-th element of the array fileList
	Ch_path = Chdir + ChList[i];
	ROIs_path = ROIsdir + ROIsList[i];
	
	// Open channel image and ROI set
	open(Ch_path);
	fileName = File.nameWithoutExtension(); // Get original name before renaming
	setOption("ScaleConversions", true);
	run("8-bit");
	rename("Channel");
	
	roiManager("open", ROIs_path);
	ROInum = roiManager("count");
	
	// Iterate over ROIs to calculate ACF
	for (j = 0; j < ROInum; j++) {
		selectImage("Channel");
		roiManager("select", j);
		run("Colocalization Test", "channel_1=Channel channel_2=Channel roi=[ROI in channel 1 ] randomization=[van Steensel (x translation)] current_slice");
		
		// Get the X and Y values of the ACF plot into arrays
		Plot.getValues(xpoints, ypoints);

		// Create a new table to store the data
		Table.create("ACF Table");
		Table.setColumn("Translation", xpoints);
		Table.setColumn("Pearson", ypoints);
		Table.update();
		Table.save(output_dir + fileName + "_" + j + ".csv");
		
		// Close tables before next iteration
		selectWindow("Results");
		run("Close");
		selectWindow("ACF Table");
		run("Close");
		selectWindow("CCF");
		run("Close");
	}
	
	// Reset ROI Manager before moving on to next image
	roiManager("reset");
	
	// Close all images before moving on to next image
	close("*");
}

setBatchMode(false);
