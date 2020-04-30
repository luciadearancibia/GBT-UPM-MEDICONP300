# GBT-UPM-MEDICONP300

Approach of the GBT-UPM team for the 2019 IFMBE Scientific Challenge on a multi-session P300-based BCI dataset.
The following project contains a MATLAB implementation for the P300 detection method described in [[1]](#1).

The code uses the dataset provided by MEDICON for the 2019 IFMBE Scientific Challenge (available at https://www.kaggle.com/disbeat/multisession-eeg-p300based-bci-for-autism).

## Description of the approach

This code predicts the object to which a subject is paying attention in a virtual reality. Using the data of the calibration phases, it trains a linear discriminant analysis or a support vector machine to detect the presence of P300 in the EEG of the subject. This code also includes the functions to predict the target object of new online sessions.

### Feature extraction

The algorithm first averages all EEG events corresponding to the same object in the same block, obtaining 8 averaged signals per block (number of signals averaged is equal to the number of runs per block). Then, the following features are extracted from the averaged signals:

* **Features based on time domain**. For each channel in the subset, the 250 samples corresponding to the time slot from stimulus onset (0ms) until 1000ms later are extracted and downsampled by average (decimation factor = 10), and the resulting samples from each channel are concatenated obtaining a single vector of 200 samples from each observation.

* **Features based on continuous wavelet transform (CWT)**. This code computes the CWT of the EEG samples with a Mexican wavelet on scales corresponding to the delta (0.5 to 4Hz) and theta (4 to 8Hz) bands, following [[2]](#2). During training, the t-CWT [[3]](#3) technique is applied to extract the most differential features on the frequency domain. This technique applies Student’s t-statistics to find points of maximum statistical difference between average P300 and non-P300 in the time–frequency domain. In our case, 128 points are selected for each of the 8 channels and concatenated, adding a total of 128*8 = 1024 time-scale features.

* **Feature reduction techniques**. Principal component analysis (PCA) reduction is then applied to transofrm the 1224 time and frequency features into the first 120 principal components of the data. 

### Classification
This code allows training with linear discriminant analysis (LDA) as well as linear support vector machine (LSVM) and a radial kernel support vector machine (RSVM). LDA outperforms the rest of classifiers implemented.

### Prediction
During testing, the code calculated the likelihood of the presence of a P300 signal while each object was being presented during a session. The object whose corresponding signals yield a higher probability of containing a P300 event was chosen as predicted target object of the block. An inter-session training strategy is followed, training subject-specific classifiers.


## Contents

**Main files to execute:**

```allSubjects_phI.m``` Executes a classification algorithm (LDA or SVM) on all subjects and sessions of phase II and saves the predictions of target object using the chosen algorithm. 
                              
```trainDA_within_sbj.m```      Function to train an LDA within-subject classifier on labeled data for a chosen subject. The sessions used to train the model must be specified inside the function.

```trainSVM_within_sbj.m```     Function to train a linear or radial SVM within-subject classifier on labeled data for a chosen subject. The sessions used to train the model as well as the specific SVM model to use must be specified inside the function.

**Secundary functions:**

```synchrAv_session.m``` Function for averaging EEG events corresponding to the same object in the same block.

```av_ds.m``` Function to average downsample and concatenate channels of a single 8-channel EEG signal.

```cwt_eeg.m```  Returns Mexican Hat wavelet coefficients of the given EEGs using the specified scales.

```tStudentofCWT.m``` Function for calculating points I, J were the discriminability of CWT is maximum among 2 classes by calculating the Student's t statistic.

```relevantCWT.m``` Function for extracting the CWT coefficients corresponding to the points of maximum discriminability between the 2 classes.

```oversampling.m``` Function for oversampling P300 signals to improve training.

```labels2targets.m```Transforms labels (block's target object) to targets (1 or 0).  

```f_score.m``` Function for calculating the precision, recall and F-score of a prediction from the confusion matrix.

--------------------
```trueLabelsphaseI.mat``` True labels (1-8) of each block of phase I data as provided by MEDICON.

```trueTargetsphaseI.mat``` True targets (0/1) of each event of phase I data as provided by MEDICON.

The above mentioned .m files can be used and customized to train and predict on specific sessions and subjects.

 
## References
<a id="1">[1]</a> 
L. de Arancibia, P. Sanchez-Gonzalez, E. J. Gomez, M. E. Hernando and I. Oropesa. 
Linear vs nonlinear classification of social joint attention in autism using VR P300-based brain computer interfaces.
In Mediterranean Conference on Medical and Biological Engineering and Computing (pp. 1869-1874). Springer, Cham.

<a id="2">[2]</a> 
Demiralp, T., Ademoglu, A., Schürmann, M., Basar-Eroglu, C., Basar, E. 
Detection of P300 waves in single trials by the wavelet transform (WT). 
Brain Lang. (1999).

<a id="3">[3]</a> 
Bostanov, V., Kotchoubey, B.
The t-CWT: A new ERP detection and quantification method based on the continuous wavelet transform and Student’s t-statistics.
Clin. Neurophysiol. (2006).
