;------------------------------------------
; function to filter bidirectional data. At this moment, it only checks whether there is a beam identified in both directions
;------------------------------------------
function filter_bidirectional_data_rbsp, flux_input
   para_flag = total(flux_input[*,0:3,*],2,/nan) gt 0 
   anti_flag = total(flux_input[*,7:10,*],2,/nan) gt 0 

   bidirection_flag = para_flag * anti_flag
   flux_bidirection = flux_input

   npa = n_elements(flux_input[0,*,0])

   index = where(bidirection_flag eq 0, ct)
   if ct gt 0 then begin 
      for ipa = 0, npa -1 do begin 
         foo = flux_bidirection[*,ipa,*]
         foo[index] = !values.f_nan
         flux_bidirection[*,ipa,*] = foo
      endfor
   endif 
   return, flux_bidirection
end

;----------------------------------------------------------------
; Purpose: bidirectional and continuity check of the cloak population: 
; 1. Remove non-bidirectional identification. - bi-directional data
; 2. Identify identification with continuity within the energy range (diff_en) and the pitch angle range (diff_pa) - beam
; 3. Remove non-bidirectional identification again on the continues data. - bi-directional beam
; 4. Calculate the bidirectional beam lengths and filter it with time range (diff_time) - cloak
; 5. Remove non-bidirectional identification again on the continues data. - bi-directional cloak
; 
; Input: pap_name, pap_bidirection_name, pap_cloak_name, energy_name, epcut_name, epcut_bidirection_name, epcut_cloak_name
; Keywords: diff_en = diff_en, diff_pa = diff_pa, diff_time = diff_time
; 
; Created by Jing Liao
; Created on 09/05/2024  
; Modified on 09/12/2024
;--------------------------------------------------------------------

PRO filter_cloak_multi_rbsp, pap_name, pap_bidirection_name, pap_cloak_name, energy_name, epcut_name, epcut_bidirection_name, epcut_cloak_name, diff_en = diff_en, diff_pa = diff_pa, diff_time = diff_time

   common SHARE1, ENERGY_BINS, DENERGY_BINS, PA_BINS, ERROR_MESSAGE

;--------------------------------------------------------------------
; load input data and basic settings
;--------------------------------------------------------------------
   get_data, pap_name, data = data, dlim = dlim, lim = lim
   time_avg= data.x
   flux_pap = data.y
   pa_pap = data.v
   
   n_time = N_ELEMENTS(time_avg)
   npa = N_ELEMENTS(pa_pap[0, *])
   nen = N_ELEMENTS(ENERGY_BINS)
   if ~keyword_set(diff_time) then diff_time = 3
;--------------------------------------------------------------------------------------------------------------------
; Start the calculations
;-----------------------------------------------------------------------------------------------------------------------
;-- 1. Remove non-bidirectional identification. - bi-directional data
; Here we only require there are postive identification on both sides
   flux_bidirection = filter_bidirectional_data_rbsp(flux_pap)

   store_data, pap_bidirection_name, data = {x:time_avg, y:flux_bidirection, v:pa_pap}, dlim = dlim, lim = lim
   options, pap_bidirection_name, 'ytitle', 'Pitch Angle!C!CBidirection'

;-- 2. Identify identification with continuity within the energy range (diff_en) and the pitch angle range (diff_pa) - beam
; Check neighbor on left and right sides within energy and pa range. Adding the edge points of the beam. 
; Thus, the cloak needs to last 3 * average_time at minimum.
; initalize all cloak arrays with inital peak arrays
   flux_beam = flux_bidirection 

   beam_flag = intarr(n_time, npa, nen)
; search through for continuity
   FOR itime= 0, n_time-1 DO BEGIN
      FOR ipa = 0, npa-1 DO BEGIN 
         for ien = 0, nen - 1 do begin
            IF flux_beam[itime, ipa, ien] GT 0 THEN BEGIN
               if itime eq 0 then l = 0 else l = TOTAL(flux_beam[itime-1, ((ipa-diff_pa) > 0):((ipa+diff_pa) < (npa-1)), ((ien-diff_en) > 0):((ien+diff_en) < (nen-1))] GT 0) GT 0
               if itime eq n_time - 1 then r = 0 else r = TOTAL(flux_beam[itime+1, ((ipa-diff_pa) > 0):((ipa+diff_pa) < (npa-1)), ((ien-diff_en) > 0):((ien+diff_en) < (nen-1))] GT 0) GT 0
               beam_flag[itime, ipa, ien] = l + r     
            ENDIF
         ENDFOR
      endfor 
   ENDFOR 

; add the edge point of a beam back as 2
   FOR itime = 1, n_time-2 DO BEGIN 
      FOR ipa = 0, npa-1 DO BEGIN
         for ien = 0, nen - 1 do begin
            IF beam_flag[itime, ipa, ien] EQ 2 THEN BEGIN
               foo =  beam_flag[itime-1, (ipa-diff_pa > 0):(ipa+diff_pa < (npa-1)),  ((ien-diff_en) > 0):((ien+diff_en) < (nen-1))]
               index = WHERE(foo EQ 1, ct)
               IF ct GT 0 THEN BEGIN 
                  foo[index] = foo[index] + 1
                  beam_flag[itime-1, (ipa-diff_pa > 0):(ipa+diff_pa < (npa-1)),  ((ien-diff_en) > 0):((ien+diff_en) < (nen-1))] = foo
               ENDIF

               foo =  beam_flag[itime+1, (ipa-diff_pa > 0):(ipa+diff_pa < (npa-1)),  ((ien-diff_en) > 0):((ien+diff_en) < (nen-1))]
               index = WHERE(foo EQ 1, ct)
               IF ct GT 0 THEN BEGIN
                  foo[index] = foo[index] + 1
                  beam_flag[itime+1, (ipa-diff_pa > 0):(ipa+diff_pa < (npa-1)),  ((ien-diff_en) > 0):((ien+diff_en) < (nen-1))] = foo
               ENDIF           
            ENDIF
         ENDFOR
      ENDFOR
   ENDFOR

; so anything in pitch angle beam array less  than 2 is not identified as a beam
   index = where(beam_flag LT 2, ct)
; save the filtered results into flux_beam
   if ct gt 0 then flux_beam[index] = !VALUES.F_NAN

;-- 3. Remove non-bidirectional identification again on the continues data. - bi-directional beam
flux_bidirectional_beam = filter_bidirectional_data_rbsp(flux_beam)

;-- 4. Calculate the bidirectional beam lengths and filter it with time range (diff_time) - cloak
; calculate the time duration of each bidirectional beam identification (in number of data points). 
   length_of_cloak= intarr(n_time, nen)
   count = 0
   index_begin = -1
   index_end = -1
   for ien = 0, nen - 1 do begin
      FOR itime = 0, n_time-1 DO BEGIN
         IF total(flux_bidirectional_beam[itime, *, ien] gt 0) gt 0 THEN BEGIN
            if index_begin eq -1 then index_begin = itime
            count = count + 1
         endif 
         if ((total(flux_bidirectional_beam[itime, *, ien] gt 0) eq 0) or (itime eq n_time-1)) and (count gt 0) then begin 
            index_end = itime - 1
            length_of_cloak[index_begin:index_end,ien] = count
         endif 

         if index_end ne -1 then begin
            count = 0
            index_begin = -1
            index_end = -1
         endif
      ENDFOR
   ENDFOR
; filter flux with length of cloak > diff_time
   flux_cloak = flux_bidirectional_beam
   index = where(length_of_cloak LT diff_time, ct) 
   if ct gt 0 then begin 
      FOR ipa = 0, npa-1 DO BEGIN
         foo = flux_cloak[*,ipa, *] 
         foo[index] = !values.f_nan
         flux_cloak[*,ipa,*] = foo
      endfor 
   endif 

; 5. Remove non-bidirectional identification again on the continues data. - bi-directional cloak
   flux_bidirectional_cloak = filter_bidirectional_data_rbsp(flux_cloak)

   store_data, pap_cloak_name, data = {x:time_avg, y:flux_bidirectional_cloak, v:pa_pap}, dlim = dlim, lim = lim
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
   
   epcut_bidirection = data.v
   index = where(total(flux_bidirection,2,/nan) eq 0 , ct)
   if ct gt 0 then epcut_bidirection[index] = !VALUES.F_NAN

   store_data, epcut_bidirection_name, data = {x: time_avg, y: epcut_bidirection}, dlim = dlim, lim = lim
   options, epcut_bidirection_name, 'ytitle', 'en beam'
   options, epcut_bidirection_name, 'color', 0

   epcut_cloak = data.v
   index = where(total(flux_bidirectional_cloak,2,/nan) eq 0 , ct)
   if ct gt 0 then epcut_cloak[index] = !VALUES.F_NAN

   store_data, epcut_cloak_name, data = {x: time_avg, y: epcut_cloak}, dlim = dlim, lim = lim
   options, epcut_cloak_name, 'ytitle', 'en beam'
   options, epcut_cloak_name, 'color', 0
   
;  for k = 0, nen-1 do store_data, pap_bidirection_name+'_'+string(k,format='(i2.2)'), data = {x:time_avg, y:reform(flux_beam[*,*,k]), v:reform(pa_pap[*,*,k])} , dlim =dlim , lim = lim 
;  for k = 0, nen -1 do options, pap_bidirection_name+'_'+string(k,format='(i2.2)'), 'ytitle',string(k)

;   for k = 0, nen-1 do store_data, pap_cloak_name+'_'+string(k,format='(i2.2)'), data = {x:time_avg, y:reform(flux_cloak[*,*,k]), v:reform(pa_pap[*,*,k])} , dlim =dlim , lim = lim 
;   for k = 0, nen -1 do options, pap_cloak_name+'_'+string(k,format='(i2.2)'), 'ytitle',string(k)

;  stop

END
