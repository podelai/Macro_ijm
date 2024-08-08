// Macro to extract random 128x128 patches from random slices in an image stack

// User input for parameters
#@ File (label="Select input stack", style="file") input_file
#@ File (label="Select output directory", style="directory") output_dir
#@ Integer (label="Number of patches to extract", min=1, max=1000, value=10) num_patches
#@ Boolean (label="Is the dataset resliced?", value=false) is_resliced


// Open the image stack
open(input_file);

// If the dataset is resliced, downscaling it
if (is_resliced) {
    run("Scale...", "x=1.0 y=0.25 z=1.0 width=256 height=64 depth=256 interpolation=None process create");
    run("Scale...", "x=1.0 y=4 z=1.0 width=256 height=256 depth=256 interpolation=Bilinear process create");
}

stack_id = getImageID();


// Get stack dimensions
getDimensions(width, height, channels, slices, frames);

// Extract random patches
for (i = 1; i <= num_patches; i++) {
    // Select a random slice
    random_slice = floor(random() * slices) + 1;
    setSlice(random_slice);
    
    // Calculate random starting coordinates for the patch
    x_start = floor(random() * (width - 128));
    y_start = floor(random() * (height - 128));
    
    // Make a rectangular selection
    makeRectangle(x_start, y_start, 128, 128);
    
    // Duplicate the selection
    run("Duplicate...", "title=patch_" + i);
    
    // Save the patch
    patch_filename = output_dir + File.separator + "patch_" + i + "_slice_" + random_slice + ".tif";
    saveAs("Tiff", patch_filename);
    close();
    
    // Return to the original stack
    selectImage(stack_id);
}

// Close all
close("*");

print("Extracted " + num_patches + " random patches.");
print("from : " + input_file);
print("to : " + output_dir);