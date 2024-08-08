#@ Integer (label="delay", min=1, max=100, value=100) delay

run("Duplicate...", "title=clock duplicate");

run("Duplicate...", "title=delayed duplicate");

n= nSlices;
setSlice(n);
for (i = 0; i < delay; i++) {
	run("Add Slice");
}

setSlice(1);
for (i = 0; i < delay; i++) {
	run("Delete Slice");
}



run("Invert", "stack");

imageCalculator("Average create stack", "clock","delayed");

setSlice(n);
for (i = 0; i < delay; i++) {
	run("Delete Slice");
}


//imageCalculator("Add create 32-bit stack", "clock","delayed");
//imageCalculator("Subtract create stack", "delayed","clock");
//imageCalculator("Difference create stack", "clock","delayed");
//imageCalculator("Subtract create stack", "1","delayed-2");
