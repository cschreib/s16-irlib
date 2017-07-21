# The S17 library

This is a library of model infrared spectra of galaxies, calibrated on the deepest Herschel images in the CANDELS fields. These are based on the physically-motivated dust model of [Galliano et al. (2011)], using amorphous carbon grains.

The library is composed of two files: 's17_dust.fits' which contains the dust continuum templates created by big grains, and 's17_pah.fits' which contains the mid-infrared features coming from polycyclic aromatic hydrocarbon molecules (PAHs). Each file contains the same number of templates (150), each corresponding to a different intensity of the interstellar radiation field (<U>) or, equivalently, to a different dust temperature (Tdust). These templates correspond to the luminosity (expressed in units of the solar luminosity) emitted by a cloud of dust of mass equal to one solar mass. The big grain and PAH templates can be co-added to form a full dust spectrum.

To facilitate the usage of this library, two [IDL]/[GDL] scripts are provided. The first, 'get_s17_template.pro', will create a new spectrum given Tdust and fPAH. The second, 'get_s17_template_calib.pro', will use the calibrated evolution of Tdust and IR8 (or fPAH) with redshift (plus an additional, optional dependence on the Main Sequence offset) that is published in the paper. Therefore it will create a spectrum based solely on the redshift. Further documentation is available in each file.

Lastly, an example IDL/GDL script ('example.pro') is provided to show how the above procedures can be used, and to illustrate the features of the library.


[Galliano et al. (2011)]: http://adsabs.harvard.edu/abs/2011A%26A...536A..88G
[IDL]: http://www.exelisvis.com/ProductsServices/IDL.aspx
[GDL]: http://gnudatalanguage.sourceforge.net/
