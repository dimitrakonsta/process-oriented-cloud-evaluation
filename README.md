# process-oriented-cloud-evaluation
The multi-sensors A-train observations allow to make the correlation between the different cloud variables at the instantaneous time scale, and at high resolution (CALIPSO-GOCCP and MODIS, PARASOL). This allows to see how different key cloud properties (cloud fraction, cloud vertical distribution provided from CALIPSO and cloud reflectance measured by MODIS and PARASOL which is a good surrogate of the cloud optical depth) vary one as a function of the other and build pictures of cloud processes well suited for the evaluation of clouds in climate models. The COSP simulator allows to provide a description of the clouds simulated by the models that is consistent with these satellite observations and to build the same pictures from the models outputs and the simulator tools. The use of instantaneous joint observations facilitates the link between observations relationship and parameterization in the models.



# References
1) Konsta D., H. Chepfer, J.-L. Dufresne, 2012: A process oriented characterization of tropical oceanic clouds for climate model evaluation, based on a statistical analysis of daytime A-train observations, Clim. Dyn., 39:2091-2108, DOI: 10.1007/s00382-012-1533-7

2) Konsta, D., J-L. Dufresne, H. Chepfer, A. Idelkadi and G. Cesana, 2015 : Use of A-train satellite observations (CALIPSO-PARASOL) to evaluate tropical cloud properties in the LMDZ5 GCM, Clim Dyn, 1-22, doi: 10.1007/s00382-016-3050-6. 



Input
----------

| Frequency | Variable | CMOR labels | Unit | File Format |
|:----------|:-----------------------------|:-------------|:------|:------------|
| daily mean | Cloud Reflectance PARASOL | CRef_par    |    | nc
|  | Cloud Reflectance MODIS 1km  |  CRef_mod1km   |     | nc
|  | Cloud Reflectance MODIS 250m  |  CRef_mod250   |     | nc
|  | Surface snow area fraction | snc     |  %    | nc
|  | Sea ice area fraction  | sic     |  1    | nc
|  | Outgoing shortwave flux at the top-of-the-atmosphere(TOA)  | rsut     |  Wm-2    | nc
|  | TOA outgoing longwave flux  | rlut     |  Wm-2    | nc
|  | TOA outgoing shortwave flux assuming clear-sky | rsutcs     |  Wm-2    | nc
|  | TOA outgoing longwave flux assuming clear-sky | rsutcs     |  Wm-2    | nc

Link to the observations (if they are expected in the code):

Monthly ISCCP data: http://climserv.ipsl.polytechnique.fr/cfmip-obs/

Output
----------
Single value texts of Statistical mean of daily mean CREMpd [Wm-2]

 
Is a script to draw a figure in the paper included ?: No


