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

# List and explation of parameters in OUTPUT_ROTATED:
- Index: Index
- First.Frame: Frame of fluorescence events first appearance (only relevant for tracking / grouping)
- Number.Frames: Number of frames that have been grouped to a single fluorescence event (only relevant for grouping)
- Frames.Missing: Number of frames that show no fluorescence event within a group (only relevant for grouping)
- Position.X..nm.: Localization (X)(nm)
- Position.Y..nm.: Localization (Y)(nm)
- Precision..nm.: Localization precision (nm)
- Number.Photons: Number of photons (photons)
- Background.variance: Background variance (photons)
- Chi.square: measure of the difference between the observed and expected frequencies of the outcomes of a set of events or variables
- PSF.half.width..nm.: Point Spread Function width at half maximum (nm)
- Channel: Channel identifier (only for multicolor)
- Z.slice: Z position (only for Z stack)
- CellName: Unique cell identifier (Cell+CellNumber+.txt+FOVNumber)
- Rot_X: Localization (X)(nm) [The cell ROIs angle is calculated as the slope of the segment connecting the two furthest points within the contour] 
- CellDiameter: Maximum X value for localizations belonging to a rotated cell brought to the origin 
- CellWidth: Maximum Y value for localizations belonging to a rotated cell brought to the origin
- CellArea: Theoretical area calculated for a rod of width "CellWidth" and length "CellDiameter". Each pole is half circle of radius "CellWidth"
