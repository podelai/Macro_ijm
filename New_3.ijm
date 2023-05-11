



//Ask the user to choose : 
#@ File (label = "Input Image directory", style = "directory") source_folder //the input image directory
#@ Integer (label="Roi size", style="slider", min=2, max=10, stepSize=2) ROI_size //size of the ROI
#@ Boolean (label= "Only one csv for all the images" ) csv_per_img //csv for each image or only one for all the image processed


//Scan the source folder (becarefull to only have images)
fluo_image_list = getFileList(source_folder + "/image"); labeled_image_list = getFileList(source_folder + "/label");

//set Batch Mode
setBatchMode("hide");

//Set Measurements
run("Set Measurements...", "area mean stack display redirect=None decimal=3");



///////////////////////////////////////////////////////////////////////////////ROI_Measure_Loop
////////////////////////////////////////////////////////////////////////////////////////////////
function ROI_Measure_Loop(){
	for (slice = 1; slice <= nSlices; slice++) {
		//Get ROI from the slice
		selectWindow(labeled_image_name); setSlice(slice);
		//getMinAndMax(min, max); for (ROI_nb = 2; ROI_nb < max; ROI_nb++) {getROI(ROI_nb, 10);}
		getMinAndMax(min, max); for (ROI_nb = 2; ROI_nb < 30; ROI_nb++) {getROI(ROI_nb, ROI_size);}
	
		//Measure
		selectWindow(fluo_image_name); setSlice(slice);
		roiManager("multi-measure append"); roiManager("delete");}
		
	if (csv_per_img==0) {
		//Save Measures
		Result_save_name = source_folder + "/Results_" + fluo_image_name + ".csv"; print(Result_save_name); saveAs("Results", Result_save_name);
		//Close result window
		selectWindow("Results"); run("Close");}
	
	
	//close images
	close("*");
	
}

/////////////////////////////////////////////////////////////////////////////////////////getROI
////////////////////////////////////////////////////////////////////////////////////////////////
function getROI(ROI_nb, ROI_size){
	
	run("Duplicate...", "title=ROI_1");
	setThreshold(ROI_nb, ROI_nb, "raw"); run("Convert to Mask");

	run("Duplicate...", "title=ROI_2");
	for (Erode_it = 1; Erode_it < (ROI_size/2); Erode_it++) {run("Erode");}
	run("Analyze Particles...", "add");
	
	selectWindow("ROI_1");
	for (Dilate_it = 1; Dilate_it < (ROI_size/2); Dilate_it++) {run("Dilate");}
	
	imageCalculator("Subtract create", "ROI_1","ROI_2");
	setThreshold(254, 255); run("Convert to Mask");
	run("Create Selection"); roiManager("Add");
	
	close("ROI_1"); close("ROI_2"); close("Result of ROI_1"); //Close all binary mask
}


/////////////////////////////////////////////////////////////////////////////////////////getROI
////////////////////////////////////////////////////////////////////////////////////////////////
for (img_nb = 0; img_nb < fluo_image_list.length; img_nb++) {
	
	fluo_image_name = fluo_image_list[img_nb]; fluo_image_path = source_folder + "/image/"+ fluo_image_name; open(fluo_image_path);
	labeled_image_name = labeled_image_list[img_nb]; labeled_image_path = source_folder + "/label/"+ labeled_image_name; open(labeled_image_path);
	
	ROI_Measure_Loop();
}


if (csv_per_img==1) {
	//Save Measures
	Result_save_name = source_folder + "/Results_" + fluo_image_name + ".csv"; print(Result_save_name); saveAs("Results", Result_save_name);
	//Close result window
	selectWindow("Results"); run("Close");}

