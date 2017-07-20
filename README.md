# process-oriented-cloud-evaluation
The multi-sensors A-train observations allow to make the correlation between the different cloud variables at the instantaneous time scale, and at high resolution (CALIPSO-GOCCP and MODIS, PARASOL). This allows to see how different key cloud properties (cloud fraction, cloud vertical distribution provided from CALIPSO and cloud reflectance measured by MODIS and PARASOL which is a good surrogate of the cloud optical depth) vary one as a function of the other and build pictures of cloud processes well suited for the evaluation of clouds in climate models. The COSP simulator allows to provide a description of the clouds simulated by the models that is consistent with these satellite observations and to build the same pictures from the models outputs and the simulator tools. The use of instantaneous joint observations facilitates the link between observations and parameterization in the models.


References
----------
1) Konsta D., H. Chepfer, J.-L. Dufresne, 2012: A process oriented characterization of tropical oceanic clouds for climate model evaluation, based on a statistical analysis of daytime A-train observations, Clim. Dyn., 39:2091-2108, DOI: 10.1007/s00382-012-1533-7

2) Konsta, D., J-L. Dufresne, H. Chepfer, A. Idelkadi and G. Cesana, 2015 : Use of A-train satellite observations (CALIPSO-PARASOL) to evaluate tropical cloud properties in the LMDZ5 GCM, Clim Dyn, 1-22, doi: 10.1007/s00382-016-3050-6. 


Preprocessing Α 
----------
The diagnostic calculation code needs the file 'tetas_lmdz96' as input information. This information is needed because the reflectance from PARASOL is given as a function of 5 solar zenith angles (tetas). In each case the corresponding tetas at the given place and at the given time should be chosen. We consider approximately that tetas depends on the latitude and on the reference month. To calculate the dependence of tetas on the model latitude and month, we use the program https://github.com/dimitrakonsta/process-oriented-cloud-evaluation/blob/master/preprocessing/code_tetas/fortran/ess_gcm2pold.f . The generated file 'tetas_lmdz96' gives for each grid of the model and for each month, the corresponding tetas. The diagnostic code reads this information and extrapolates the corresponding reflectance from PARASOL.



<sub> Input </sub>
---------
The latitude grid of the model. In the example provided, we use the ASCII file 'latitude_lmdz96' as given in the Sect. data.  

<sub> Output </sub>
--------
The preprocessing code generates the ASCCI file 'tetas_lmdz96' provided in the Sect. data. The file 'tetas_lmdz96' gives for each grid of the model and for each month, the corresponding tetas.


Preprocessing Β
----------
The diagnostic requires an estimate of the PARASOL reflectance of the cloudy part of each grid cell, but the standard COSP output provides the total value of PARASOL reflectance (i.e. cloud free + cloudy part of the grid cell). For that reason a small addition is required to the standard COSP simulator output in the routine where variables are written to output files (see https://github.com/dimitrakonsta/process-oriented-cloud-evaluation/blob/master/preprocessing/code_cosp/fortran/add_cosp_Crefl.f). In case where parasol_crefl is provided the diagnistic code can be run on daily time scale.
In case where this variable is not provided, the diagnostics can still be proceeded with the use of 'parasol_refl' instead, but only at instantaneous (8hrly) time scale, as described in the code provided (https://github.com/dimitrakonsta/process-oriented-cloud-evaluation/blob/master/code/matlab/ref_cf.m).

<sub> Output </sub>
--------
| Frequency | Variable | Variable labels | Unit | File Format |
|:----------|:-----------------------------|:-------------|:------|:------------|
| 8 hourly / daily | Cloud Reflectance PARASOL | parasol_crefl  | -  | nc

Diagnostic calculation
-----------------------

For the diagnostic calculation use the code : https://github.com/dimitrakonsta/process-oriented-cloud-evaluation/blob/master/code/matlab/ref_cf.m

<sub>  Input </sub>
----------

| Frequency | Variable | Variable labels | Unit | File Format |
|:----------|:-----------------------------|:-------------|:------|:------------|
| 8 hourly | Cloud Reflectance PARASOL / Reflectance PARASOL | parasol_crefl / parasol_refl   | -  | nc
| 8 hourly | Total Cloud fraction CALIPSO-GOCCP | cltcalipso     |  %    | nc
| 8 hourly | Low-level Cloud Fraction CALIPSO-GOCCP  | cllcalipso     |  %   | nc

Apart from the CMIP data listed in the previous table, the codes needs also as input data the information of Latitude, Longitude and Land Ocean Mask that should be given from netcdf files describing the standard geographical attributes of the model's grid cells (see AmipLmdz5_19790101_19790131_HF_histhf.nc in the Sect. data)


The observational benchmarks, Daily Cloud Reflectance and CALIPSO-GOCCP data are found in http://climserv.ipsl.polytechnique.fr/cfmip-obs/

<sub>  Output </sub>
----------
Plots of 2D histograms of cloud reflectance and cloud cover. An output example can be found in https://github.com/dimitrakonsta/process-oriented-cloud-evaluation/tree/master/images

Is a script to draw a figure in the paper included ?: No







