# ECC_memorability_vs_aesthetics
**Comparing the notion of image memorabiltiy and image aesthetics** (An eye**E**M &amp; **C**ambridge University **C**ollaboration - **ECC**)

-----------------------------------------------------------
This project aims to see if the aesthetically pleasing images are als omore memorable. For the memorability test, we utlize near-human performance MemNet (http://memorability.csail.mit.edu/download.html) model. For aesthetics, we utilize the eyeEM image aesthetics dataset (dataset-aesthetics). 

-----------------------------------------------------------
**RUNNING THE COMAPRISON** 

(1) Download the [MemNet] (http://memorability.csail.mit.edu/download.html). Unpack it to have a folder memnet under the ROOT folder. memnet folder should contain the trained caffemodel, deploy file, and the mean file in MAT format. 

(2) Run main.m. The code is pretty much self explanatory. Make sure you have the eyeEM dataset on the correct path, which contains the image names as specified in the testSet.txt 

-----------------------------------------------------------
**DEPENDENCIES** 

Standard [Caffe] (https://github.com/BVLC/caffe)  with matCaffe Installation 
