inputDir = getDirectory("Choose folder with ilastik segmentations");
outputDir = getDirectory("Choose folder to output label masks");

fileList = getFileList(inputDir);

//activate batch mode
setBatchMode(true);

roiManager("reset");
for (i = 0; i < lengthOf(fileList); i++) {
	current_imagePath = inputDir + fileList[i];
	// Open current image
	open(current_imagePath);
	imgTitle = File.nameWithoutExtension;
	
	// Make binary
	run("Select None");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	// Optional: dilate mask before particle analysis
	//run("Dilate");
		
	// Create count mask -- INDICATE MINIMUM SIZE TO FILTER PARTICLES
	run("Analyze Particles...", "size=3-Infinity show=[Count Masks]");
	run("glasbey_inverted");
	
	// Save and close images before next iteration
	saveAs("Tiff", outputDir + imgTitle);
	close("*");
}