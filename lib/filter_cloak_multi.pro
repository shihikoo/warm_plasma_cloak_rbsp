;----------------------------------------------------------------
; Purpose:  Continuity check of the cloak population: 1. Check the energy peak, 2. check the pitch angle peak. 3. review the energy peak again.
; filter energy peak and erange data with beam duration (continuity check) 4. bidirectional 
;
; Input: pap_name
;        cpcut_name
;        erange_name
;        bx_name
;        x_gse_name
;        bz_gsm_name
;        pap_beam_et_name
;        epcut_beam_name
;        erange_beam_name
; 
; Created by Jing Liao
; Created on 09/05/2024  
; Modified on 09/12/2024
;--------------------------------------------------------------------

PRO filter_cloak_multi, pap_name, pap_beam_name, pap_cloak_name, energy_name, epcut_name, epcut_beam_name, epcut_cloak_name, diff_en = diff_en, diff_pa = diff_pa

   common SHARE1, ENERGY_BINS, DENERGY_BINS, PA_BINS, ERROR_MESSAGE

;--------------------------------------------------------------------
;load input data and basic settings
;--------------------------------------------------------------------
   get_data, pap_name, data = data, dlim = dlim, lim = lim
   time_avg= data.x
   flux_pap = data.y
   pa_pap = data.v
   
   n_time = N_ELEMENTS(time_avg)
   npa = N_ELEMENTS(pa_pap[0, *])
   nen = N_ELEMENTS(ENERGY_BINS)

   IF ~KEYWORD_SET(diff_en) THEN diff_en = 1   ; accepted energy bin difference 
   IF ~KEYWORD_SET(diff_pa) THEN diff_pa = 1 ; accepted pitch bin difference
;  IF ~KEYWORD_SET(diff_time) THEN diff_time = 1 ; beams are defined as beam before and after 1 times of average time. 

; initalize all beam arrays with inital peak arrays
   flux_beam = flux_pap

;--------------------------------------------------------------------------------------------------------------------------
; Check the pitch angle peak flux data. A beam needs to have similar continuety in both energy and pitch angle. 
; If one has to have both left and right neighbor within defiend energy and pitch angle range, then it is considered a beam. 
; Adding the edge points of the beam later. Hence the beam lasts 3 * average_time minimum
;---------------------------------------------------------------------------------------------------------------------------
   beam_flag = intarr(n_time, npa, nen)

; search through for continuity
   FOR i = 1, n_time-2 DO BEGIN
      FOR j = 0, npa-1 DO BEGIN 
         for k = 0, nen - 1 do begin
            IF flux_beam[i, j, k] GT 0 THEN BEGIN 
               l = TOTAL(flux_beam[i-1, ((j-diff_pa) > 0):((j+diff_pa) < (npa-1)), ((k-diff_en) > 0):((k+diff_en) < (nen-1))] GT 0) GT 0
               r = TOTAL(flux_beam[i+1, ((j-diff_pa) > 0):((j+diff_pa) < (npa-1)), ((k-diff_en) > 0):((k+diff_en) < (nen-1))] GT 0) GT 0
               beam_flag[i, j, k] = l + r
            ENDIF
         ENDFOR
      endfor 
   ENDFOR 

; add the edge point of a beam back as 2
   FOR i = 1, n_time-2 DO BEGIN 
      FOR j = 0, npa-1 DO BEGIN
         for k = 0, nen - 1 do begin
            IF beam_flag[i, j, k] EQ 2 THEN BEGIN
               temp =  beam_flag[i-1, (j-diff_pa > 0):(j+diff_pa < (npa-1)),  ((k-diff_en) > 0):((k+diff_en) < (nen-1))]
               index = WHERE(temp EQ 1, ct)
               IF ct GT 0 THEN BEGIN 
                  temp[index] = temp[index] + 1
                  beam_flag[i-1, (j-diff_pa > 0):(j+diff_pa < (npa-1)),  ((k-diff_en) > 0):((k+diff_en) < (nen-1))] = temp
               ENDIF

               temp =  beam_flag[i+1, (j-diff_pa > 0):(j+diff_pa < (npa-1)),  ((k-diff_en) > 0):((k+diff_en) < (nen-1))]
               index = WHERE(temp EQ 1, ct)
               IF ct GT 0 THEN BEGIN
                  temp[index] = temp[index] + 1
                  beam_flag[i+1, (j-diff_pa > 0):(j+diff_pa < (npa-1)),  ((k-diff_en) > 0):((k+diff_en) < (nen-1))] = temp
               ENDIF           
            ENDIF
         ENDFOR
      endfor
   ENDFOR

; so anything in pitch angle beam array less  than 2 is not identified as a beam
   index = where(beam_flag LT 2, ct)
; save the filtered results into flux_beam
   if ct gt 0 then flux_beam[index] = !VALUES.F_NAN

;---------------------------------------------------------------------------------------------------------------
; Save into pitch angle
;--------------------------------------------------------------------------------------------------------------
   store_data, pap_beam_name, data = {x:time_avg, y:flux_beam, v:pa_pap}, dlim = dlim, lim = lim
   options, pap_beam_name, 'ytitle', 'Pitch Angle!C!CBeam'

;---------------------------------------------------------------------------------------------------------------
; Filter beam with bidiration rule for cloak
;--------------------------------------------------------------------------------------------------------------
   para_flag = total(flux_beam[*,0:3,*],2,/nan) gt 0 
   anti_flag = total(flux_beam[*,7:10,*],2,/nan) gt 0 

   cloak_flag = para_flag * anti_flag
   flux_cloak = flux_beam

   index = where(cloak_flag eq 0, ct)
   if ct gt 0 then begin 
      for ipa = 0, npa -1 do begin 
         foo = flux_cloak[*,ipa,*]
         foo[index] = !values.f_nan
         flux_cloak[*,ipa,*] = foo
      endfor 
   endif 
   
   store_data, pap_cloak_name, data = {x:time_avg, y:flux_cloak, v:pa_pap}, dlim = dlim, lim = lim
   options, pap_cloak_name, 'ytitle', 'Pitch Angle!C!CCloak'

;---------------------------------------------------------------------------------------------------------------
; save the energy with pa peaks and pa beam peaks into epcut and epcut beam string. 
;--------------------------------------------------------------------------------------------------------------
   get_data, energy_name, data = data, dlim=dlim,lim=lim

   epcut = data.v
   index = where(total(flux_pap,2,/nan) eq 0 , ct)
   if ct gt 0 then epcut[index] = !VALUES.F_NAN

   store_data, epcut_name, data = {x: time_avg, y: epcut}, dlim = dlim, lim = lim
   options, epcut_name, 'ytitle', 'en peak'
   options, epcut_name, 'color', 0

   epcut_beam = data.v
   index = where(total(flux_beam,2,/nan) eq 0 , ct)

   if ct gt 0 then epcut_beam[index] = !VALUES.F_NAN

   store_data, epcut_beam_name, data = {x: time_avg, y: epcut_beam}, dlim = dlim, lim = lim
   options, epcut_beam_name, 'ytitle', 'en beam'
   options, epcut_beam_name, 'color', 0

   epcut_cloak = data.v
   index = where(total(flux_cloak,2,/nan) eq 0 , ct)

   if ct gt 0 then epcut_cloak[index] = !VALUES.F_NAN

   store_data, epcut_cloak_name, data = {x: time_avg, y: epcut_cloak}, dlim = dlim, lim = lim
   options, epcut_cloak_name, 'ytitle', 'en beam'
   options, epcut_cloak_name, 'color', 0
   
;  for k = 0, nen-1 do store_data, pap_beam_name+'_'+string(k,format='(i2.2)'), data = {x:time_avg, y:reform(flux_beam[*,*,k]), v:reform(pa_pap[*,*,k])} , dlim =dlim , lim = lim 
;  for k = 0, nen -1 do options, pap_beam_name+'_'+string(k,format='(i2.2)'), 'ytitle',string(k)

;   for k = 0, nen-1 do store_data, pap_cloak_name+'_'+string(k,format='(i2.2)'), data = {x:time_avg, y:reform(flux_cloak[*,*,k]), v:reform(pa_pap[*,*,k])} , dlim =dlim , lim = lim 
;   for k = 0, nen -1 do options, pap_cloak_name+'_'+string(k,format='(i2.2)'), 'ytitle',string(k)

;  stop

END
