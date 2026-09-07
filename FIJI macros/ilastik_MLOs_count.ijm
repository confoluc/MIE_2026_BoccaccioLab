// Set input and output folders
inputDir = getDirectory("Choose the folder with ilastik segmentations to process");
ROIDir = getDirectory("Choose the folder with cell ROIs");
outputDir = getDirectory("Choose the folder to save tables");

// Get list of all files in the folder
list = getFileList(inputDir);
ROIlist = getFileList(ROIDir);


// Loop through each file in the list
for (i = 0; i < list.length; i++) {
        // Set up file and ROIs path
        filePath = inputDir + list[i];
        ROIsPath = ROIDir + ROIlist[i];
        		
        // Open ROIs to count them
        roiManager("open", ROIsPath);
        ROInum = roiManager("count");
        
        // Loop through cell ROIs
        if (ROInum > 0) {
        	open(filePath);
        	setOption("BlackBackground", true);
			run("Convert to Mask");
			run("Fill Holes");

        	fileName = File.nameWithoutExtension;
        // Get MLOs count in each cell
        for (j = 0; j < ROInum; j++) {
        	roiManager("select", j);        	
        	// Analyze Particles and get summary ONLY
        	// Check size filter using argument "size"
        	run("Analyze Particles...", "size=3-Infinity clear summarize");
        }
        close("*");
        // Save MLOs summary as table
        selectWindow("Summary");
        saveAs("results", outputDir + fileName + ".csv");
        run("Close");        
        }
        // Reset ROI Manager for next iteration
        roiManager("reset");
}