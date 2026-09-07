ImgDir = getDirectory("Choose folder with images to segment");
CellROIDir = getDirectory("Choose folder with cell ROI sets");
NucleiROIDir = getDirectory("Choose folder with nuclei ROI sets");
OutputDir = getDirectory("Choose folder to output cytoplasmic masks");

ImgList = getFileList(ImgDir);
CellROIList = getFileList(CellROIDir);
NucleiROIList = getFileList(NucleiROIDir);

// Activate batch mode
setBatchMode(true);

roiManager("reset");
for (i = 0; i < lengthOf(ImgList); i++) {
	current_imagePath = ImgDir + ImgList[i];
	current_CellROIPath = CellROIDir + CellROIList[i];
	current_NuclearROIPath = NucleiROIDir + NucleiROIList[i];
	// Open image
	open(current_imagePath);
	imgTitle = File.nameWithoutExtension;
	
	// Open cell ROI set
	roiManager("open", current_CellROIPath);
	// Make binary mask
	run("Binary (0-255) mask(s) from Roi(s)", "show_mask(s) save_in=[] suffix=[] save_mask_as=tif rm=[RoiManager[visible=true]]");
	rename("Cells_Mask");
	// Reset ROI Manager
	roiManager("reset");
	
	// Open nuclei ROI set
	roiManager("open", current_NuclearROIPath);
	// Make binary mask
	run("Binary (0-255) mask(s) from Roi(s)", "show_mask(s) save_in=[] suffix=[] save_mask_as=tif rm=[RoiManager[visible=true]]");
	rename("Nuclei_Mask");
	// Reset ROI Manager
	roiManager("reset");
	
	// Substract nuclei mask from cell mask
	imageCalculator("Subtract create", "Cells_Mask","Nuclei_Mask");
	// Erode and generate cytoplasmic ROIs
	setOption("BlackBackground", true);
	run("Erode");
	run("Analyze Particles...", "add composite");
	// Save ROI set as .zip
	roiManager("save", OutputDir + imgTitle + ".zip");
	roiManager("reset");
	
	// Close all open images
	close("*");
}

setBatchMode(false);