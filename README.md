# process-oriented-cloud-evaluation
The multi-sensors A-train observations allow to make the correlation between the different cloud variables at the instantaneous time scale, and at high resolution (CALIPSO-GOCCP and MODIS, PARASOL). This allows to see how different key cloud properties (cloud fraction, cloud vertical distribution provided from CALIPSO and cloud reflectance measured by MODIS and PARASOL which is a good surrogate of the cloud optical depth) vary one as a function of the other and build pictures of cloud processes well suited for the evaluation of clouds in climate models. The COSP simulator allows to provide a description of the clouds simulated by the models that is consistent with these satellite observations and to build the same pictures from the models outputs and the simulator tools. The use of instantaneous joint observations facilitates the link between observations relationship and parameterization in the models.


References
----------
1) Konsta D., H. Chepfer, J.-L. Dufresne, 2012: A process oriented characterization of tropical oceanic clouds for climate model evaluation, based on a statistical analysis of daytime A-train observations, Clim. Dyn., 39:2091-2108, DOI: 10.1007/s00382-012-1533-7

2) Konsta, D., J-L. Dufresne, H. Chepfer, A. Idelkadi and G. Cesana, 2015 : Use of A-train satellite observations (CALIPSO-PARASOL) to evaluate tropical cloud properties in the LMDZ5 GCM, Clim Dyn, 1-22, doi: 10.1007/s00382-016-3050-6. 



Input
----------

| Frequency | Variable | Variable labels | Unit | File Format |
|:----------|:-----------------------------|:-------------|:------|:------------|
| - | Latitude grid | lat    |  degrees  | nc
| - | Longitude grid | lon    |  degrees  | nc
| - | Land Ocean Mask | pourc_oce   |  flag  | nc
| 8 hourly | Cloud Reflectance PARASOL / Reflectance PARASOL | parasol_crefl / parasol_refl   | -  | nc
| 8 hourly | Total Cloud fraction CALIPSO-GOCCP | cltcalipso     |  %    | nc
| 8 hourly | Low-level Cloud Fraction CALIPSO-GOCCP  | cllcalipso     |  %   | nc

All the above variables can be found in CMIP data with the exception of the variable parasol_crefl that needs a small addition to COSP simulator output (see Sect. Preprocessing).

Additionally auxiliary input data of the solar zenith angle are needed ('tetas_lmdz'). Details as well as the code to generate this file are provided in the Sect. Preprocessing. 

The observational benchmarks, Daily Cloud Reflectance and CALIPSO-GOCCP data are found in http://climserv.ipsl.polytechnique.fr/cfmip-obs/

Output
----------
Plots of 2D histograms of cloud reflectance and cloud cover. An output example can be found in https://github.com/dimitrakonsta/process-oriented-cloud-evaluation/tree/master/images

Is a script to draw a figure in the paper included ?: No

Preprocessing 
----------
The diagnostic requirs an estimate of the PARASOL reflectance of the cloudy part of each grid cell, but the standard COSP output provide the total value of PARASOL reflectance (i.e. cloud free + cloudy part of the grid cell). For that reason a small addition is required to the standard COSP simulator output in the routine where variables are written to output files (see https://github.com/dimitrakonsta/process-oriented-cloud-evaluation/blob/master/preprocessing/code_cosp/fortran/add_cosp_Crefl.f). 
In case where this variable is not provided, the diagnostics can still be proceeded with the use of 'parasol_refl' instead but only at instantaneous (8hrly) time scale, as described in the code provided (https://github.com/dimitrakonsta/process-oriented-cloud-evaluation/blob/master/code/matlab/ref_cf.m).

The code needs also the file 'tetas_lmdz96' as input information. This inforamtion is needed because the reflectance from PARASOL is given as a function of 5 solar zenith angles (tetas). In each case the corresponding tetas at the given place and at the given time should be chosen. We consider approximately that tetas depends on the latitude and on the reference month. To calculate the dependence of tetas on the model latitude, we use the program https://github.com/dimitrakonsta/process-oriented-cloud-evaluation/blob/master/preprocessing/code_tetas/fortran/ess_gcm2pold.f that uses as input the file 'latitude_lmdz96' and generates the file 'tetas_lmdz96'. Both files are provided in the Sect. data. The file gives for eac grid of the model and for each month, the corresponding tetas. The diagnostic code reads this information and extrapolates the corresponding reflectance from PARASOL. 






