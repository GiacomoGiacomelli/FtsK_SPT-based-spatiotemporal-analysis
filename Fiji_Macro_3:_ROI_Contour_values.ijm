 dir=getDirectory("image");
 n = roiManager("count");
  run("Properties...", "pixel_width=0.00967821 pixel_height=0.00967821 voxel_depth=1.0000000 global");
 for (i=0; i<n; i++) {
      roiManager("select", i);
      roiManager("rename", i);
      run("Properties... ", "name=0157-0027 position=none stroke=none width=0 fill=none list");
      wait(25);
	  saveAs("Results", dir+"cells//" + "Cell" + i + ".txt");
	  if (isOpen("Cell"+i+".txt")) { 
       selectWindow("Cell"+i+".txt"); 
       run("Close"); 
   } 
}
