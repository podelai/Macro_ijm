//hide random pixel of an image and extract thoses pixel to a new image with black background
// This script is an illustration of the Noise2Void strategie

#@ Integer (label="number of mask", style="slider", min=0, max=500, stepSize=1) mask_nb
#@ Integer (label="size of the mask", style="slider", min=0, max=4, stepSize=1) mask_size

width = Image.width; height = Image.height
print(width);

roiManager("reset")

for (i = 0; i < mask_nb; i++) {
	x=floor(random*width);
	y=floor(random*height);
	print("x=" + x + " y=" + y);

	makeRectangle(x, y, mask_size, mask_size);
	roiManager("add")}
	

print(i);

roiManager("combine");

run("Duplicate...", "title=off");
run("Duplicate...", "title=on");

selectWindow("off");
run("Add...", "value=250");
run("Select None");
roiManager("reset");

selectWindow("on");
run("Make Inverse");
run("Add...", "value=250");
run("Select None");
roiManager("reset");





