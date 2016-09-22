# ECC_memorability_vs_aesthetics
**Comparing Image Memorabiltiy and Image Aesthetics** (An eye**E**M &amp; **C**ambridge University **C**ollaboration - **ECC**)

-----------------------------------------------------------
This project aims to see if the aesthetically pleasing images are als omore memorable. For the memorability test, we utlize near-human performance MemNet (http://memorability.csail.mit.edu/download.html) model. For aesthetics, we utilize the eyeEM image aesthetics dataset (dataset-aesthetics). 

-----------------------------------------------------------
**RUNNING THE COMPARISON TEST** 

(1) Download the [MemNet] (http://memorability.csail.mit.edu/download.html). Unpack it to have a folder memnet under the ROOT folder. memnet folder should contain the trained caffemodel, deploy file, and the mean file in MAT format. 

(2) For memorability test, run main_memorability.m (by placing it directly under the ROOT folder). The code is pretty much self explanatory. Make sure you have the eyeEM dataset on the correct path, which contains the image names as specified in the testSet.txt 

(3) For aesthetics test, run main_aesthetics.m (by placing it directly under the root folder). It has dependencies of the mean file, prototxt and the caffemodel, which should be put in appropriate paths as specified in the file main_aesthetics.m. The models and the mean file for aesthetics can be accessed at https://drive.google.com/open?id=0B3TXswfo-kA1aURBQ1Q5bGZMNlU. The code uses the models from S. Kong, X. Shen, Z. Lin, R. Mech, C. Fowlkes, "Photo Aesthetics Ranking Network with Attributes and Content Adaptation", ECCV, Amsterdam, the Netherlands, (Oct. 2016). 

-----------------------------------------------------------
**DEPENDENCIES** 

Standard [Caffe] (https://github.com/BVLC/caffe)  with matCaffe Installation 
