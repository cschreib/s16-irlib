; Description
; -----------
;
; Build a new combined IR template from the S16 library by specifying
; directly its dust temperature and PAH mass fraction. The returned SED
; will be normalized to a dust mass of one solar mass.
;
;
; Parameters (required)
; ---------------
;
;  - dustlib: the S16 dust library
;  - pahlib: the S16 PAH library
;  - tdust: the dust temperature (in Kelvin)
;  - fpah: the PAH mass fraction, between 0 and 1
;  - ir8: the ratio between LIR and L8. This parameter can be given
;         in place of 'fpah', in which case the procedure will determine
;         the corresponding fPAH value. Not all values of IR8 are
;         physical (the range is typically from 0.3 to 30), and the
;         procedure will emit an error if such an invalid value is
;         requested. Note finally that, for the procedure to use this
;         value, the keyword 'from_ir8' must be set.
;  - from_ir8: set this keyword to compute 'fpah' from 'ir8'
;
;
; Output
; ------
;
;  - lambda: the wavelength of the SED
;  - nulnu: the SED (in units of solar luminosity)
;  - ir8: if not provided in input, will give the ratio between LIR and L8
;         L8 for this template
;  - fpah: if not provided in input, will give the PAH mass fraction of
;          this template
;  - lir: the total IR luminosity of the template (8-1000um) in solar
;         luminosity
;  - mdust: the dust mass of the template, 1 solar mass by construction
;
;
;  2] Giving directly the dust temperature and the PAH mass fraction.
;     To follow this approach, you must provide a value for the following
;     parameters. Note that, instead of the PAH mass fraction, you can
;     also give the IR8 value.
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
pro get_s16_template, tdust=tdust, fpah=fpah, ir8=ir8, $
    lir=lir, mdust=mdust, from_fpah=from_fpah, from_ir8=from_ir8, $
    dustlib=dustlib, pahlib=pahlib, lambda=lambda, nulnu=nulnu, $
    idsed=idsed

    ; Check for missing arguments
    if n_elements(tdust)   eq 0 then message, 'missing dust temperature (tdust=...)'
    if n_elements(dustlib) eq 0 then message, 'missing dust library (dustlib=...)'
    if n_elements(pahlib)  eq 0 then message, 'missing PAH library (pahlib=...)'

    ; Find corresponding SED in library
    nsed = n_elements(dustlib.lam[0,*])
    id = long(round(interpol(findgen(nsed), dustlib.tdust, tdust)))
    idsed = id

    if id lt 0 or id ge nsed then begin
        message, 'invalid Tdust value (min:'+strn(min(dustlib.tdust))+$
            ', max:'+strn(max(dustlib.tdust))+')'
    endif

    ; Get the PAH mass fraction from IR8 (if asked)
    if n_elements(ir8) ne 0 and keyword_set(from_ir8) then begin
        fpah = (dustlib.lir[id] - ir8*dustlib.l8[id]) / $
            (ir8*(pahlib.l8[id] - dustlib.l8[id]) - (pahlib.lir[id] - dustlib.lir[id]))

        if fpah lt 0 or fpah gt 1 or ~finite(fpah) then begin
            ratios = [dustlib.lir[id]/dustlib.l8[id], pahlib.lir[id]/pahlib.l8[id]]
            message, 'invalid IR8 value for this Tdust (min:'+$
                strn(min(ratios))+', max:'+strn(max(ratios))+')'
        endif
    endif else if n_elements(fpah) ne 0 then begin
        if fpah lt 0 or fpah gt 1 or ~finite(fpah) then begin
            message, 'invalid fPAH value (min:0, max:1)'
        endif
    endif else message, 'missing PAH mass fraction (fpah=...)'

    ; Build combined SED
    lambda = reform(dustlib.lam[*,id])
    nulnu = reform(dustlib.sed[*,id]*(1.0-fpah) + pahlib.sed[*,id]*fpah)

    mdust = 1.0
    lir = dustlib.lir[id]*(1.0-fpah) + pahlib.lir[id]*fpah
end
