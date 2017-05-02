; This example file shows you how to use the library and the helper functions that are
; provided alongside (get_s17_template and get_s17_template_calib).

; Launch this code in IDL (or GDL) and type ".continue" when you want to move forward in
; the list of examples.

; For all the examples below, and whenevery ou want to use the library, you first need to
; load the library files in memory. These are FITS tables (column oriented) that can be
; read by 'mrdfits' (this procedure is part of the NASA IDL astronomy library).

dustlib = mrdfits('s17_dust.fits', 1, /silent)
pahlib  = mrdfits('s17_pah.fits',  1, /silent)
no_stop = 1

; Now we are ready to begin, whenever you want.

print, "type .continue whenever you are ready!"
stop


; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------

print, ''
print, '-----------------------------------------------------'
print, 'Example 1: finding a template, knowing Tdust and fPAH'
print, '-----------------------------------------------------'

; We know this:
tdust = 35.0 ; the dust temperature (Kelvins)
ir8 = 4.0  ; the LIR/L8 ratio

; We want to get the corresponding SED.
; Simply call 'get_s17_template':

get_s17_template, $
    ; Input parameters
    dustlib=dustlib, pahlib=pahlib, tdust=tdust, ir8=ir8, $
    ; Output parameters
    lambda=lambda, nulnu=nulnu, lir=lir, mdust=mdust

; Now the SED is stored in 'lambda' (for the wavelength) and 'nulnu' (for the luminosity)
; The wavelength is given in micron [um], while the luminosity is in solar luminosity
; [Lsun].

; The procedure has given us to other values: lir and mdust, which can be used to
; normalize the SED.
print, 'with Tdust='+strn(tdust)+' K and IR8='+strn(ir8)
print, 'we have Mdust='+strn(mdust)+' Msun and LIR='+strn(lir)+' Lsun'

; The current SED is normalized to unit Mdust
plot, lambda, nulnu, xr=[1,1000], yr=[10,2d4], /xlog, /ylog, $
    xtit='rest-frame wavelength [um]', ytit='nuL!dnu!n/M!ddust!n [Lsun]', charsize=2

stop

; We can choose instead to normalize it to unit LIR
nulnu /= lir
mdust /= lir ; note that the dust mass is also affected
lir = 1.0

print, 'we have Mdust='+strn(Mdust)+' Msun and LIR='+strn(lir)+' Lsun'

; The SED is now normalized to unit LIR
plot, lambda, nulnu, xr=[1,1000], yr=[0.01, 1.0], /xlog, /ylog, $
    xtit='rest-frame wavelength [um]', ytit='nuL!dnu!n/L!dIR!n [Lsun]', charsize=2

stop


; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------

print, ''
print, '------------------------'
print, 'Example 2: varying Tdust'
print, '------------------------'

; To show the extent of the library, we will show how multiple SEDs of different dust
; temperatures, each with a different color

; First build the color array
nsed = 40
color1 = [255,255,255] & color2 = [255,0,0]
x = findgen(nsed)/(nsed-1)
colorsR = long(x*color1[0] + (1-x)*color2[0])
colorsG = long(x*color1[1] + (1-x)*color2[1])
colorsB = long(x*color1[2] + (1-x)*color2[2])
colors = colorsR + colorsG*256L + colorsB*65536L

; Define the Tdust grid
ir8 = 4.0
tdust_min = 25
tdust_max = 60
tdust = (tdust_max - tdust_min)*findgen(nsed)/(nsed-1) + tdust_min

; First show the templates in unit Mdust

; Initialize the plot area
plot, lambda, nulnu, /nodata, xr=[1,1000], yr=[10,2d4], /xlog, /ylog, $
    xtit='rest-frame wavelength [um]', ytit='nuL!dnu!n/M!ddust!n [Lsun]', charsize=2

; Plot the SEDs, normalized to unit Mdust
for i=0, nsed-1 do begin
    get_s17_template, dustlib=dustlib, pahlib=pahlib, tdust=tdust[i], ir8=ir8, $
        lambda=lambda, nulnu=nulnu, lir=lir

    oplot, lambda, nulnu, color=colors[i]
endfor

stop

; Then show the templates in unit LIR

; Initialize the plot area
plot, lambda, nulnu, /nodata, xr=[1,1000], yr=[0.01,1.0], /xlog, /ylog, $
    xtit='rest-frame wavelength [um]', ytit='nuL!dnu!n/L!dIR!n [Lsun]', charsize=2

; Plot the SEDs, normalized to unit Mdust
for i=0, nsed-1 do begin
    get_s17_template, dustlib=dustlib, pahlib=pahlib, tdust=tdust[i], ir8=ir8, $
        lambda=lambda, nulnu=nulnu, lir=lir

    nulnu /= lir

    oplot, lambda, nulnu, color=colors[i]
endfor

stop


; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------

print, ''
print, '-----------------------'
print, 'Example 3: varying IR8'
print, '-----------------------'

; We will show how multiple SEDs of different IR8 values, each with a different color

; First build the color array
nsed = 40
color1 = [255,255,255] & color2 = [0,255,0]
x = findgen(nsed)/(nsed-1)
colorsR = long(x*color1[0] + (1-x)*color2[0])
colorsG = long(x*color1[1] + (1-x)*color2[1])
colorsB = long(x*color1[2] + (1-x)*color2[2])
colors = colorsR + colorsG*256L + colorsB*65536L

; Define the IR8 grid
tdust = 35.0
ir8_min = 2.0
ir8_max = 20.0
ir8 = ir8_min*10d0^((alog10(ir8_max) - alog10(ir8_min))*findgen(nsed)/(nsed-1))

; First show the templates in unit Mdust

; Initialize the plot area
plot, lambda, nulnu, /nodata, xr=[1,1000], yr=[10,2d4], /xlog, /ylog, $
    xtit='rest-frame wavelength [um]', ytit='nuL!dnu!n/M!ddust!n [Lsun]', charsize=2

; Plot the SEDs, normalized to unit Mdust
for i=0, nsed-1 do begin
    get_s17_template, dustlib=dustlib, pahlib=pahlib, tdust=tdust, ir8=ir8[i], $
        lambda=lambda, nulnu=nulnu, lir=lir

    oplot, lambda, nulnu, color=colors[i]
endfor

stop

; Then show the templates in unit LIR

; Initialize the plot area
plot, lambda, nulnu, /nodata, xr=[1,1000], yr=[0.01,1.0], /xlog, /ylog, $
    xtit='rest-frame wavelength [um]', ytit='nuL!dnu!n/L!dIR!n [Lsun]', charsize=2

; Plot the SEDs, normalized to unit Mdust
for i=0, nsed-1 do begin
    get_s17_template, dustlib=dustlib, pahlib=pahlib, tdust=tdust, ir8=ir8[i], $
        lambda=lambda, nulnu=nulnu, lir=lir

    nulnu /= lir

    oplot, lambda, nulnu, color=colors[i]
endfor

stop


; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------

print, ''
print, '----------------------------------------------------------------'
print, 'Example 4: finding a "best guess" template from redshift and RSB'
print, '----------------------------------------------------------------'

; We know this:
z = 1.85  ; the redshift
rsb = 2.5 ; the offset of the galaxy from the Main Sequence (SFR/SFR_MS)

; We want to get the typical SED of such a galaxy.
; For this we can use the calibrations of Tdust and IR8 from S17.
; These calibrations are implemented in 'get_s17_template_calib':

get_s17_template_calib, $
    ; Input parameters
    dustlib=dustlib, pahlib=pahlib, z=z, rsb=rsb, $
    ; Output parameters
    lambda=lambda, nulnu=nulnu, $
    tdust=tdust, ir8=ir8, lir=lir, mdust=mdust

; The situation is the same as with the previous example.
print, 'with z='+strn(z)+' and RSB='+strn(rsb)
print, 'we have Tdust='+strn(tdust)+' K and IR8='+strn(ir8)
print, 'we have Mdust='+strn(mdust)+' Msun and LIR='+strn(lir)+' Lsun'

; The current SED is normalized to unit Mdust
plot, lambda, nulnu, xr=[1,1000], yr=[10,2d4], /xlog, /ylog, $
    xtit='rest-frame wavelength [um]', ytit='nuL!dnu!n/M!ddust!n [Lsun]', charsize=2

stop


; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------

print, ''
print, '-------------------------------'
print, 'Example 5: varying the redshift'
print, '-------------------------------'

; We will show multiple average SEDs at different redshifts, each with a different color

; First build the color array
nsed = 40
color1 = [255,0,0] & color2 = [0,0,255]
x = findgen(nsed)/(nsed-1)
colorsR = long(x*color1[0] + (1-x)*color2[0])
colorsG = long(x*color1[1] + (1-x)*color2[1])
colorsB = long(x*color1[2] + (1-x)*color2[2])
colors = colorsR + colorsG*256L + colorsB*65536L

; Define the redshift grid
rsb = 1.0
z_min = 0.2
z_max = 2.5
z = (z_max - z_min)*findgen(nsed)/(nsed-1) + z_min

; First show the templates in unit Mdust

; Initialize the plot area
plot, lambda, nulnu, /nodata, xr=[1,1000], yr=[10,2d4], /xlog, /ylog, $
    xtit='rest-frame wavelength [um]', ytit='nuL!dnu!n/M!ddust!n [Lsun]', charsize=2

; Plot the SEDs, normalized to unit Mdust
for i=0, nsed-1 do begin
    get_s17_template_calib, dustlib=dustlib, pahlib=pahlib, rsb=rsb, z=z[i], $
        lambda=lambda, nulnu=nulnu, lir=lir

    oplot, lambda, nulnu, color=colors[i]
endfor

stop

; Then show the templates in unit LIR

; Initialize the plot area
plot, lambda, nulnu, /nodata, xr=[1,1000], yr=[0.01,1.0], /xlog, /ylog, $
    xtit='rest-frame wavelength [um]', ytit='nuL!dnu!n/L!dIR!n [Lsun]', charsize=2

; Plot the SEDs, normalized to unit Mdust
for i=0, nsed-1 do begin
    get_s17_template_calib, dustlib=dustlib, pahlib=pahlib, rsb=rsb, z=z[i], $
        lambda=lambda, nulnu=nulnu, lir=lir

    nulnu /= lir

    oplot, lambda, nulnu, color=colors[i]
endfor

stop


; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------

print, ''
print, '-------------------------------------'
print, 'Example 6: varying the starburstiness'
print, '-------------------------------------'

; We will show multiple average SEDs at different RSB, each with a different color

; First build the color array
nsed = 40
color1 = [255,255,0] & color2 = [255,0,0]
x = findgen(nsed)/(nsed-1)
colorsR = long(x*color1[0] + (1-x)*color2[0])
colorsG = long(x*color1[1] + (1-x)*color2[1])
colorsB = long(x*color1[2] + (1-x)*color2[2])
colors = colorsR + colorsG*256L + colorsB*65536L

; Define the RSB grid
z = 1.0
lrsb_min = -0.3
lrsb_max = 1.0
rsb = 10d0^((lrsb_max - lrsb_min)*findgen(nsed)/(nsed-1) + lrsb_min)

; First show the templates in unit Mdust

; Initialize the plot area
plot, lambda, nulnu, /nodata, xr=[1,1000], yr=[10,2d4], /xlog, /ylog, $
    xtit='rest-frame wavelength [um]', ytit='nuL!dnu!n/M!ddust!n [Lsun]', charsize=2

; Plot the SEDs, normalized to unit Mdust
for i=0, nsed-1 do begin
    get_s17_template_calib, dustlib=dustlib, pahlib=pahlib, rsb=rsb[i], z=z, $
        lambda=lambda, nulnu=nulnu, lir=lir

    oplot, lambda, nulnu, color=colors[i]
endfor

stop

; Then show the templates in unit LIR

; Initialize the plot area
plot, lambda, nulnu, /nodata, xr=[1,1000], yr=[0.01,1.0], /xlog, /ylog, $
    xtit='rest-frame wavelength [um]', ytit='nuL!dnu!n/L!dIR!n [Lsun]', charsize=2

; Plot the SEDs, normalized to unit Mdust
for i=0, nsed-1 do begin
    get_s17_template_calib, dustlib=dustlib, pahlib=pahlib, rsb=rsb[i], z=z, $
        lambda=lambda, nulnu=nulnu, lir=lir

    nulnu /= lir

    oplot, lambda, nulnu, color=colors[i]
endfor

stop


; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------
; ----------------------------------------------------------------------------------------

print, ''
print, '-------------------------------'
print, 'Example 7: converting to fluxes'
print, '-------------------------------'

; So far we have worked in rest-frame units.
; Just to make sure that you got the units right, here is how the SED can be converted
; into the observer frame.

; Using the first SED we saw
tdust = 38.0 ; the dust temperature (Kelvins)
ir88 = 4.0   ; the LIR/L8 ratio

get_s17_template, dustlib=dustlib, pahlib=pahlib, tdust=tdust, ir8=ir8, $
    lambda=lambda, nulnu=nulnu, lir=lir

; Pick a LIRG at z=1
nulnu *= (1d12/lir)
z = 1.0

; First define constant factors
Mpc = 3.0856d22 ; Mpc to m
Lsol = 3.839d26 ; Lsun to W/m^2
mJy = 1.0d29    ; W/m^2/Hz to mJy
c = 2.9979d14   ; um/s

; The cosmological parameters
omega_m = 0.3
omega_L = 0.7
H0 = 70.0

; Compute the luminosity distance (given here in Mpc)
d = lumdist(z, H0=H0, omega_m=omega_m, Lambda0=omega_L, /silent)

; Here is the conversion
lambda_obs = lambda*(1.0 + z)
fnu = (mJy*Lsol/(c*4.0*!dpi*Mpc^2))*lambda_obs*nulnu/d^2

plot, lambda_obs, fnu, xr=[1,1000], yr=[0.01,1d2], /xlog, /ylog, $
    xtit='observed wavelength [um]', ytit='S!dnu!n [mJy]', charsize=2

stop


end
