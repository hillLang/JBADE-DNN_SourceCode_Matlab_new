This folder contains Matlab programs for a toolbox for joint extimating the azimuth and the distance of sound sources using deep neural networks (DNNs). 


#######################
Description of folders and files

config/


DATA/
Mixtures, features and  masks are stored here.

dnn/
Code for DNN training and test, where dnn/main/ includes key functions for DNN training/test, dnn/pretraining/ includes code for unsupervised DNN pretraining.

gen_mixture/
Code for creating training and testing datasets.

get_feat/:
Code for binaural features and statistical preperties calculation.

premix_data/
Original binaural signals are stored here.

load_config.m
Configures feature type, noise type, training utterance list, test utterance list, mixture SNR, mask type, etc.

RUN.m
Loads configurations from load_config.m and runs a binaural azimuth and distance estimation demo.

The output results is the azimuth and the distance estimating results of the testing sound sources. 

#######################
DEMO

A binaural azimuth and distance estimation demo for small size of training dataset. The reader can easily modify the code for the large size of training dataset.

There is no significant difference between the results. 


