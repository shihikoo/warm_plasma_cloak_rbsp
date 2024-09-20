;+
; PROCEDURE: plot_rbsp_hope_l3_paspec
;
; PURPOSE: To load and plot RBSP/HOPE L3 pitch angle spectra from the cdf files in:
;           https://rbsp-ect.newmexicoconsortium.org/data_pub/rbspa/hope/level3/pitchangle/
;           https://rbsp-ect.newmexicoconsortium.org/data_pub/rbspb/hope/level3/pitchangle/
; 
; SET TIME INTERVAL: Time interval is set using the tplot timespan procedure:
;                    Example: 
;                    timespan, '2013-01-01/00:00:00', 1, /D
;                    (keywords: SECONDS, MINUTES, HOURS, DAYS (DEFAULT))
;
; INPUT PARAMETERS: probe:   VAP id array ('A','B' | 'a', 'b' | 1,2)
;                   species: 0: H+, 1: e-, 2: He+, 3: O+
;                   units:   Units for energy spectra 
;                            'DIFF FLUX', 'EFLUX'
;
; KEYWORDS: ENERGY_RANGE --> min max energy for the pitch angle spectrum in eV
;           energy_bins_range --> This overrides the energy_range. 
;                 To shut it down it should be set to single 0
;           ENERGY_UNITS_IN_FLUX --> 'eV' or 'keV'
;           aux_data --> Load auxiliary data avalable in the cdf file
;           eph_data --> Load the ephemeris data from the cdf file
;           NEW_NAME --> A string to overwite the default tplot_variable name
;           PATH --> A string to overwite the default data path
;           FLN --> A string to overwite the default data file name
;
; NOTES:
; 
; @author Chris Mouikis
;
; LAST MODIFICATION: 06/28/2023
;
; MODIFICATION HISTORY: 
;  6/23/2023 - (cgm): Updated to properly handle EFLUX units
;  6/28/2023 - (cgm): Minor edits / improvements
;-
pro plot_rbsp_hope_l3_paspec_jing, $
    probe, $
    species, $
    units, $
    energy_units_in_flux=energy_units_in_flux, $
    energy_range=energy_range, $
    energy_bins_range=energy_bins_range, $
    aux_data=aux_data, $
    eph_data=eph_data, $
    new_name=new_name, $
    path=path, $
    fln=fln

  ; Reset common error message variables
  common get_error, get_err_no, get_err_msg, default_verbose
  get_err_no = 0 & get_err_msg=''
  
  ;>>--------------------------------------------------------------------
  ; Input checks
  ;----------------------------------------------------------------------
  ; Check if probe and species arrays have the same number of elements
  if n_elements(probe) NE n_elements(species) then begin
    print, 'The probe array and the species array MUST have'
    print, 'the same number of elements.'
    stop
  endif
 
  ; Check if input parameters are within the allowed limits
  probe_str = strarr(n_elements(probe))
  for ipar = 0, n_elements(probe)-1 do begin
    if size(probe(ipar), /TYPE) EQ 7 then begin
      probe_str(ipar) = STRUPcase(probe(ipar))
    endif else begin
      if probe(ipar) EQ 1 then probe_str(ipar) = 'A'
      if probe(ipar) EQ 2 then probe_str(ipar) = 'B'
    endelse
    if probe_str(ipar) NE 'A' AND probe_str(ipar) NE  'B' then begin
      print, 'Allowed values for probe are: 1 or 2 or a or b or A or B '
    endif

    if species(ipar) LT 0 OR species(ipar) GT 3 then begin
      print, 'Allowed values for species are: 0, 1, 3 or 3'
      stop
    endif
  endfor
  ;<<--------------------------------------------------------------------

  ; Set variables
  species_str = ['H!U+!N','e!U-!N','He!U+!N','O!U+!N']
  if ~keyword_set(energy_range) then energy_range = [1., 60000.]
  if ~keyword_set(energy_units_in_flux) then energy_units_in_flux = 'keV'

  ; >>--------------------------------------------------------------------
  ; Loop over all probe/species combinations
  ;----------------------------------------------------------------------
  for ii = 0, n_elements(species)-1 do begin
     
     ; Reset error tracking
     get_err_no = 0 & get_err_msg=''

     ; Read the data for each probe/species combination
     if keyword_set(new_name) then name = new_name else name=''
		 get_rbsp_hope_l3_paspec_jing, $
        probe_str(ii), $
        species(ii), $
        units, $
        energy_range, $
        energy_units_in_flux = energy_units_in_flux, $
        energy_bins_range=energy_bins_range, $
        aux_data=aux_data, $
        eph_data=eph_data, $
        name = name, $
        path=path, $
        fln=fln

     energy_range_string = string(energy_range[0], forMAT='(i5.5)') + $
        '-' + string(energy_range[1], forMAT='(i5.5)')
     options, name, 'ytitle', $
        'PROBE ' + strupcase(probe_str(ii)) + '!C!C' + $
                 species_str(species(ii))+' (eV)' + '!C!C' + energy_range_string
     
     uname = ''
     if units EQ 'DIFF FLUX' then begin
        if energy_units_in_flux EQ 'eV' then begin
           uname = '1/cm!E2!N-s-sr-(eV/e)'
        endif else begin
           uname = '1/cm!E2!N-s-sr-(keV/e)'
        endelse
     endif
     
     if units EQ 'EFLUX' then begin
        if energy_units_in_flux EQ 'eV' then begin
           uname = 'eV/cm!E2!N-s-sr-(eV/e)'
        endif else begin
           uname = 'keV/cm!E2!N-s-sr-(keV/e)'
        endelse
     endif
     
     options, name, 'spec',1
     options, name, 'x_no_interp',1
     options, name, 'y_no_interp',1
     
     options, name, 'ztitle', uname
     
    if units EQ 'DIFF FLUX' AND energy_units_in_flux EQ 'eV' then begin
      case species(ii) OF
        0: zlim, name,  1.e+0, 1.e4, 1
        1: zlim, name,  1.e+2, 1.e6, 1
        2: zlim, name,  1.e-1, 1.e3, 1
        3: zlim, name,  1.e+0, 1.e4, 1          
      endcase
    endif else begin
      case species(ii) OF
        0: zlim, name,  1.e+3, 1.e7, 1
        1: zlim, name,  1.e+5, 1.e9, 1
        2: zlim, name,  1.e+2, 1.e6, 1
        3: zlim, name,  1.e+3, 1.e7, 1
      endcase
    endelse
     
     next:
  endfor
  ;<<--------------------------------------------------------------------
  
END
