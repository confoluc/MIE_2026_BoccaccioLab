// Set input folders
inputDir1 = getDirectory("Choose the folder with SUBFOLDERS with randomized images of Ch1");
inputDir2 = getDirectory("Choose the folder with images of Ch2");

// Get list of all files in folder 2
list2 = getFileList(inputDir2);

// Get list of all subfolders in folder 1
list1 = getFileList(inputDir1);

setBatchMode(true);

// Loop through each file of Ch2
for (i = 0; i < list2.length; i++) {
        // Set up file path
        filePath2 = inputDir2 + list2[i];
        
       	// Open Ch2 image and convert to binary mask
       	open(filePath2);
       	Title2 = getTitle();       	
       	//setOption("BlackBackground", true); // Make binary if input is not binary
		//run("Convert to Mask");
		// Optional: dilate mask
		//run("Dilate");
		
		// Set up path to corresponding Ch1 subfolder
		subfolderPath1 = inputDir1 + list1[i];
		// Get list of all files in this subfolder of Ch1
		sublist1 = getFileList(subfolderPath1);
		
        // Loop through each image in subfolder of Ch1
        for (j = 0; j < sublist1.length; j++) {
        	// Set up file path
        	filePath1 = subfolderPath1 + sublist1[j];
        
       		// Open Ch1 image and convert to binary mask
       		open(filePath1);
       		Title1 = getTitle();       	
       		setThreshold(1, 65535, "raw"); // Thresholding is required when working with label images
			setOption("BlackBackground", true);
			run("Convert to Mask");
			
			// Optional: dilate binary mask
			//run("Dilate");
			
			// Evaluate overlap by multiplying both channels and analyze particles
        	imageCalculator("Multiply create", Title1, Title2);
        	run("Grays");
        	rename(Title2 + "_RandomContacts");
                
        	run("Analyze Particles...", "summarize");
        	
        	// Close result and Ch1 images
        	close(); // to close active image (result)
        	close(Title1); // to close Ch1 image
        }
       	// Close Ch2 image before moving on to next
		close("*");
}

// Save summary as table
selectWindow("Summary");
saveAs("results", inputDir2 + "Contacts.csv");
run("Close");

setBatchMode(false);
