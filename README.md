# CNVtable-likePLOT

## Input data format

The file format should look like this:

    1	866642	921679	2	normal	eg.txt
    1	921679	982372	2	normal	eg.txt

It is a tab separated .txt file with 6 columns without header. The information is as follows:

1. Chromosome
2. Startpoint of CN state
3. Endpoint of CN state
4. CNstate
5. Meaning (loss, gain or normal)
6. Original samplename 

As the samplenames in the plot are generated from the filename, the filenames need to be chosen properly and must end with "_CNVs".




## Important

* `"D:/DIRECTORY"` means you have to put the directory to the files / the working directory in here.
* There is a function in the script that merges all files to one big dataframe.
* `sortedNames <- c("","")`: Here you have to add all sample/filenames (without _CNVs) if you want a specific order, if not just remove the function and also the next one for the opposite order.
*	The filtering is set to exclude all CNVs smaller 500 bp, play a bit around with the numbers
*	The output format here is a .pdf file. Depending on the number of samples, you have to play around a bit with the size: `pdf(file="outputname.pdf", width=8, height=5, pointsize=6, useDingbats=FALSE)` and of course: add a filename.

![CNV-table-like-visualization](https://github.com/KristinaKeuper/CNVtable-likePLOT/blob/master/cnv_table-like_visualization.png "CNV plot")


## R packages

*reshape2 (version 1.4.3):* Wickham, Hadley (2007): Reshaping Data with the reshape Package. In J. Stat. Soft. 21 (12).

*ggplot2 (version 2.2.1):* H. Wickham. ggplot2: Elegant Graphics for Data Analysis. Springer-Verlag New York, 2016. 

*gtools (version 3.5.0):* Gregory R. Warnes, Ben Bolker, and Thomas Lumley (2018): Various R Programming Tools.
