


#@ Integer (label="Number of slices", style="slider", min=1, max=10, stepSize=1) slices_nb //size of the ROI


current_title = getTitle(); print(current_title);


for (i = 0; i < nSlices; i++) {
	
	print("current slice : " + i);
	selectWindow(current_title);
	
	if (i < slices_nb / 2 + 0.5) { 
		param = "start=" + 1 + " stop=" + slices_nb + " projection=[Average Intensity]";
		
	} else if ( i > nSlices - slices_nb / 2 - 1.5){
		param = "start=" + (nSlices - slices_nb + 1) + " stop=" + nSlices + " projection=[Average Intensity]";

	} else {
		slice_1 = i - (slices_nb/2) + 1.5;
		slice_2 = i + (slices_nb/2) + 0.5;
		param = "start=" + slice_1 + " stop=" + slice_2 + " projection=[Average Intensity]";
	}
	
	run("Z Project...", param);
	selectWindow(current_title);
}

selectWindow(current_title);
close();

run("Images to Stack", "use");

print("Done");




