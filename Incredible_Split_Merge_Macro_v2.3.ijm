/*
 * Function that Ask the user a source folder that contain images, the extension files to import, 
 * and the output folder were the final image will be saved.
 * 
 * 1.import only images with correct extension
 * 2. Split and merge channels
 * 3. Save the merged image as tiff
 */


//Ask the user to choose : 
#@ File (label = "Input Image directory", style = "directory") source_folder //the input image directory
#@ String (label = "Input Image extension", value = ".nd") extension //the extension file to import
#@ File (label = "csv Results directory", style = "directory") output_folder //the output directory were to save 

//Channels order
#@ String (choices={"red", "green", "blue", "gray", "cyan", "magenta", "yellow"}, style="listBox") Channel_1
#@ String (choices={"red", "green", "blue", "gray", "cyan", "magenta", "yellow"}, style="listBox") Channel_2
#@ String (choices={"red", "green", "blue", "gray", "cyan", "magenta", "yellow", "None"}, style="listBox") Channel_3
#@ String (choices={"red", "green", "blue", "gray", "cyan", "magenta", "yellow", "None"}, style="listBox") Channel_4

/////////////////////////////////////////////////
timer1 = getTime(); //timer intialisation 
run("Close All"); // close all images open
setBatchMode("show"); //Batch mode
/////////////////////////////////////////////////

if ((Channel_1 == Channel_2) || (Channel_1 == Channel_3) || (Channel_2 == Channel_3)) {
	print("attention");
	waitForUser("! identical channel order declare ! Click Cancel");}

channel_list = newArray(Channel_1, Channel_2, Channel_3, Channel_4);

function channel_order(channel) {
	if (channel == "red"){channel = 1;}
	if (channel == "green"){channel = 2;}
	if (channel == "blue"){channel = 3;}
	if (channel == "gray"){channel = 4;}
	if (channel == "cyan"){channel = 5;}
	if (channel == "magenta"){channel = 6;}
	if (channel == "yellow"){channel = 7;}
	if (channel == "None"){channel = 0;}
	
	return channel; }

for (a = 0; a < channel_list.length; a++) { channel_list[a] = channel_order(channel_list[a]);}


//Scan the source folder
image_list = getFileList(source_folder);
image_list = Array.sort(image_list);


// Function that import only images with correct extension
// Split and merge channels
// Save the merged image as tiff
for (i = 0; i < image_list.length; i++) {
	
	fileName = image_list[i];	
	filePath = source_folder + File.separator + fileName;
	
	//import only file with the correct extension
	if (endsWith(fileName, extension)) {
		
		print("Processing: " + fileName);
		open(filePath);
		
		current_title = getTitle();
		getDimensions(width, height, channels, slices, frames);
		
		// Split channels //////////////////////////////////////////////////
		run("Split Channels");
		
		// Merge all the channels //////////////////////////////////////////
		merge_arg = "";
		for (n = 1; n <= channels; n++) {
			print("n :" + n);
			print(channel_list[n-1]);
			merge_arg = merge_arg + "c"+channel_list[n-1]+"=[C"+n+"-" + current_title + "] ";}
			
		merge_arg = merge_arg + "create ignore";
		run("Merge Channels...", merge_arg);
		
		// Save as tiff ////////////////////////////////////////////////////
		extension_index = indexOf(fileName, extension);
		fileName = substring(fileName, 0, extension_index);
	
		saveAs("TIFF", output_folder + File.separator + fileName + "tif");
		run("Close All");
		
	}

}



//execution summary
print("Finished");
timer2 = getTime();
timetaken = Math.round((timer2-timer1)/1000) ;
print("Time taken :" + timetaken + "sec");
print("Source folder : " + source_folder);
print("Saved to: " + output_folder);

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////v/////////////////////////////////////////////// Lucien DAUNAS 30.03.2023 //
///////////////////////////////////////////////////////////////////////////////////////////////////