name1 = getTitle(); 
roiManager("Add");
run("Duplicate...", " ");
run("Watershed");
run("Copy");
close();
selectWindow(name1);
run("Paste");
