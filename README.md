# FtsK_SPT-based-spatiotemporal-analysis
This is my first iteration for a tool aimed at achieving in depth "SPT-based-spatiotemporal-analysis". This pipeline was used for the paper titled "FtsK..." (DOI_: insert DOI after pubblished) and is aimed at extracting and combining information derived from protein localization and cell morphology.

This repository contains the following items:

# Fiji scripts:

Fiji macro 1 (Binary Mask):
- Input: Maximum intensity projection of localizations
- Output: Binary Mask (scaled 10 times, bicubic interpolation)
- Output format: .tif , .txt  

Fiji macro 2 (Watershed):
- Input: Binary Mask (.tif)
- Manual input required: Select area that needs watersheding
- Output: Binary Mask, selected area changes to watersheded version (Can be applied multiple times to different areas within the binary mask - used to segmentate cells)
- Output format: Requires manual save once satisfied with manual changes (.tif) 

Fiji macro 3 (ROIs to R):
- Input: Binary Mask (.tif)
- Manual Input required: Add ROIs of interest to ROI manager (Wand tool) (Save the list of ROIs as .zip before proceeding)
- Requirements: a folder named "Cells" within the working directory
- Output: Cell*.txt (it outputs in "Cells" a single file for each ROI listed within the ROI manager)

# R scripts:

Script_R1_Filtering_and_Flipping:
- Manual Input required: Update manually the needed input variables
- Input 1: ROIs obtained via Fiji macro 3 -> need to be named Cell*.txt
- Input 2: PALM_Table_Example.txt
- Output 1: ROIs list for R ("AreaList.RData")
- Output 2: ROIs list for R ("AreaList_cor.RData")
- Output 3: ROIs list for R ("AreaList_At0.RData")
- Output 4: Filtered + Aligned + ROIexclusive + CellName + CellDiameter + CellArea (OUTPUT.txt)
- Output 5: Filtered + Aligned + ROIexclusive (can be imported in ZenBlack) (CELLS_DRIFTED_FILTERED_IMG.txt)
- Output 6: Filtered + Aligned + ROIexclusive + CellName + CellDiameter + CellArea + RotatioRelatedParameters (OUTPUT_ROTATED)

Script_R2_Comparison:
- Manual Input required: Update the filepaths in the "Import Files" section
- Input 1: OUTPUT_ROTATED for all fields of view and two conditions of choice
- Input 2: PALM_Table_Example.txt
- Output 1: Table including all fields of view for the two conditions of choice ("Comparison_DATA.txt")
- Output 2: Intensity Comparison Map for the difference between conditions ("Comparison_MAP.txt")
- Output 3: Intensity Comparison Map for the first condition ("Strain1_MAP.txt")
- Output 4: Intensity Comparison Map for the second condition ("Strain2_MAP.txt")

