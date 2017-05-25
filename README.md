#Weisfeiler-Lehman Neural Machine for Link Prediction
---

This file contains some important information for successfully running the code.

# Run Main.m in MATLAB for doing the link prediction experiments.


# Need to install liblinear in order to save .mat data to libsvm format, so that torch can read them.
cd software/
wget -O liblinear.tar.gz http://www.csie.ntu.edu.tw/~cjlin/cgi-bin/liblinear.cgi?+http://www.csie.ntu.edu.tw/~cjlin/liblinear+tar.gz
tar xvzf liblinear.tar.gz
cd liblinear-2.1/
make

This will install liblinear. Then, in MATLAB, cd to the "software/liblinear-2.1/matlab/", type "make" to install the MATLAB interface. Please also change the name of "train.mexa64" and "predict.mexa64" to "liblinear_train.mexa64" and "liblinear_predict.mexa64" if you want to train a logistic regression model instead of neural network.


# Use the below cmd to run matlab in server, in order to adopt system's own libstdc++.so.6 instead of the one of matlab's.
LD_PRELOAD="/usr/lib64/libstdc++.so.6" matlab 


# To calculate auc inside lua, need to download metrics package (optional)
git clone https://github.com/hpenedones/metrics.git
cd metrics
loarocks --local make


# Run in MATLAB: mex canonical.cpp    
  to compile this cpp file in MATLAB
To use nauty for canonical labeling, first download nauty26r7.tar.gz into "software/" by running:

cd software/
wget http://pallini.di.uniroma1.it/nauty26r7.tar.gz

Then install nauty by:

tar xvzf nauty26r7.tar.gz
cd nauty26r7
./configure
make

There are two MATLAB wrappers canon.m, canonical.c in the main folder. If there is no canonical.mex*64 file in the main folder, the program canon.m will compile canonical.c for the first time. 

# Please contact Muhan Zhang, muhan@wustl.edu if you encounter any bugs.
# 2017.2.15
