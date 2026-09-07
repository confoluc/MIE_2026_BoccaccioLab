// Set input folders
inputDir1 = getDirectory("Choose the folder with Ch1");
inputDir2 = getDirectory("Choose the folder with Ch2");

// Get list of all files in the folders
list1 = getFileList(inputDir1);
list2 = getFileList(inputDir2);

// Loop through each file in the list
for (i = 0; i < list1.length; i++) {
        // Set up file paths
        filePath1 = inputDir1 + list1[i];
        filePath2 = inputDir2 + list2[i];
        
       	// Open images
       	open(filePath1);
       	Title1 = getTitle();
       	
       	//setOption("BlackBackground", true); // Make binary if input is not binary
		//run("Convert to Mask");
        // Optional: dilate mask
        //run("Dilate");
        
       	open(filePath2);
       	
       	//setOption("BlackBackground", true); // Make binary if input is not binary
		//run("Convert to Mask");
		//run("Dilate");
		
       	Title2 = getTitle();
       	
        // Evaluate overlap by multiplying both channels and analyze particles
        imageCalculator("Multiply create", Title1, Title2);
        run("Grays");
                
        run("Analyze Particles...", "summarize");	
		
		// Close image windows before opening next
		close("*");
}

// Save summary as table
selectWindow("Summary");
saveAs("results", inputDir1 + "Contacts.csv");
run("Close");
