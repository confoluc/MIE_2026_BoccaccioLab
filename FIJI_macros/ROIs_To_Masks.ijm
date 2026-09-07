inputDir = getDirectory("Choose folder with images");
ROIDir = getDirectory("Choose folder with ROIs to divide image");
outputDir = getDirectory("Choose folder to output masks by cell");

fileList = getFileList(inputDir);
ROIList = getFileList(ROIDir);

//activate batch mode
setBatchMode(true);

roiManager("reset");
for (i = 0; i < lengthOf(fileList); i++) {
	current_imagePath = inputDir + fileList[i];
	current_ROIPath = ROIDir + ROIList[i];
	// Open current image and ROI set
	open(current_imagePath);
	imgTitle = File.nameWithoutExtension;
	roiManager("open", current_ROIPath);
	n = roiManager("count");
	
	// Loop through ROI set and save as separate images
	for (j = 0; j < n; j++) {
		roiManager("select", j);
		run("Duplicate...", " ");
		run("Clear Outside");
		
		// Make masks
		setForegroundColor(255, 255, 255);
		run("Fill", "slice");
		setAutoThreshold("Default dark");
		setOption("BlackBackground", true);
		run("Convert to Mask");
		
		// Save single-ROI image/mask
		saveAs("Tiff", outputDir + imgTitle + "_" + j);
		close();
	}
	
	// Close current image and reset ROI Manager for next iteration
	close("*");
	roiManager("reset");
}