; Description
; -----------
;
; Build a new combined IR template from the S17 library by specifying
; a redshift and position with respect to the Main Sequence. The
; returned SED will be normalized to a dust mass of one solar mass.
;
;
; Parameters (required)
; ----------
;
;  - dustlib: the S17 dust library
;  - pahlib: the S17 PAH library
;  - z: the redshift of your object
;  - rsb: the starburstiness of your object, i.e., the ratio between its
;         SFR and the SFR it would have on the Main Sequence. This
;         parameter can be omitted, in which case the default value is 1,
;         i.e., the galaxy is assumed to be on the Main Sequence.
;
;
; Output
; ------
;
;  - lambda: the wavelength of the SED
;  - nulnu: the SED (in units of solar luminosity)
;  - tdust: the dust temperature in Kelvin
;  - ir8: the LIR to L8 ratio
;  - fpah: the PAH mass fraction (from 0 to 1)
;  - lir: the total IR luminosity of the template (8-1000um) in solar
;         luminosity
;  - mdust: the dust mass of the template, 1 solar mass by construction
;
;
; Normalizing the SED
; -------------------
;
; By default the SED is normalized to a dust mass of one solar mass.
; This way, you can rescale the SED yourself afterwards to any dust
; mass that you want. The procedure also gives you the LIR of this
; normalized template, so that you can renormalize it to unit LIR.
;
;
pro get_s17_template_calib, z=z, rsb=rsb, tdust=tdust, fpah=fpah, ir8=ir8, $
    lir=lir, mdust=mdust, $
    dustlib=dustlib, pahlib=pahlib, lambda=lambda, nulnu=nulnu

    if n_elements(rsb) eq 0 then rsb = 1.0
    if n_elements(z)   eq 0 then message, 'missing redshift (z=...)'

    ; Get the dust temperature
    tdust = 32.9 + 4.60*(z-2) + 10.1*alog10(rsb)

    ; Find corresponding SED in library
    nsed = n_elements(dustlib.lam[0,*])
    id = long(round(interpol(findgen(nsed), dustlib.tdust, tdust)))

    ; Get the IR8
    ir8 = (4.08 + 3.29*(z-1 > 0 < 1))*rsb^0.66

    ; Get the full SED
    get_s17_template, tdust=tdust, fpah=fpah, ir8=ir8, lir=lir, mdust=mdust, $
        dustlib=dustlib, pahlib=pahlib, lambda=lambda, nulnu=nulnu
end
