;--------------------------------------------------------------
; merge external data into cloak data
;--------------------------------------------------------------
function merge_external_to_cloak, external_data, cloak_data
  cloak_matrix = convert_structure_to_matrix(cloak_data, header = tagnames_cloak)
  external_matrix = convert_structure_to_matrix(external_data, header = tagnames_external)

  n_term_external = n_elements(tagnames_external)
;  n_term_cloak = n_elements(tagnames_cloak)

  index = where(cloak_data.flux gt 0, ct)
  if ct gt 0 then output_cloak = cloak_matrix[index, *] else stop
  
  index_time = where(tagnames_cloak eq "TIME")
  index_en = where(tagnames_cloak eq 'EN')
  time = output_cloak[*,index_time]
  ; en =  output_cloak[*,index_en]
  n_time = n_elements(time)
  
  unique_time = time[uniq(time, sort(time))]
  n_unique_time = n_elements(unique_time)
  
  output = dblarr(n_time, n_term_external)
  output[*] = !values.f_nan

  for itime = 0, n_unique_time-1 do begin
     index_cloak = where(output_cloak[*,index_time] eq unique_time[itime], ct_cloak)
     index_external = where(external_data.Time eq unique_time[itime],ct_external)
     if ct_external gt 0 then begin
        output[index_cloak,*] = transpose(cmreplicate(reform(external_matrix[index_external,*],n_term_external),ct_cloak))
     endif else begin
        print,'no external data found'
        stop
     endelse 
  endfor
  
  index_time_external = where(tagnames_external eq "TIME")
  if index_time_external ne 0 then stop
  tagnames_external = tagnames_external[1:n_term_external-1]
  output = output[*, 1:n_term_external-1]
  
  str_output = convert_matrix_to_structure([[output_cloak], [output]], [tagnames_cloak, tagnames_external])
  
  return, str_output
end 

;-------------------------------------------------------------
; Merge cloak data into external data (need to be tested)
;-------------------------------------------------------------
function new_merge_cloak_to_external, external_data, cloak_data
  cloak_matrix = convert_structure_to_matrix(cloak_data, header = tagnames_cloak)
  ; external_matrix = convert_structure_to_matrix(external_data, header = tagnames_external)

  ; n_term_external = n_elements(tagnames_external)
  n_term_cloak = n_elements(tagnames_cloak)

  index = where(cloak_data.flux gt 0, ct)
  if ct gt 0 then valid_cloak_matrix = cloak_matrix[index, *] else stop
  
  index_time = where(tagnames_cloak eq "TIME")
  time = external_data.time  
  n_time = n_elements(time)

  output = dblarr(n_time, n_term_cloak)
  output[*] = !values.f_nan
  
  for itime = 0, n_time-1 do begin
     index = where(valid_cloak_matrix[*,index_time] eq time[itime], ct)
     if ct gt 0 then output[itime, *] = total(valid_cloak_matrix[index, *], 1,/nan)/ct
  endfor
  
  str_output = convert_matrix_to_structure(output, tagnames_cloak)  
  
  return, str_output
end

;-------------------------------------------------------------
; Merge cloak data into external data
;-------------------------------------------------------------
function merge_cloak_to_external, external_data, cloak_data
  time = external_data.time  
  n_time = n_elements(time)
;   tagnames_external = tag_names(external_data)
  tagnames_cloak = tag_names(cloak_data)
;   n_term_external = n_elements(tagnames_external)
  n_term_cloak = n_elements(tagnames_cloak)
  output = dblarr(n_time, n_term_cloak)
  ens_str_arr = strarr(n_time)
  output[*] = !values.f_nan
  for itime = 0, n_time-1 do begin 
     en = !values.f_nan &  pa = !values.f_nan &  flux = !values.f_nan &  eflux = !values.f_nan & int_flux = !values.f_nan & pa_range = !values.f_nan ; & n = !values.f_nan & n_weighted = !values.f_nan & p = !values.f_nan & t = !values.f_nan;& v = !values.f_nan
    
     index_time = where(cloak_data.Time eq time[itime],ct_time)
     if ct_time gt 0 then begin 
        index = where(finite(cloak_data.flux[index_time]), ct)
        if ct gt 0 then begin 
           ens = cloak_data.en[index_time[index]]
           ens = ens[UNIQ(ens, SORT(ens))]
           ens_str = (strcompress(ens)).join(' ')
           en = total(ens)/N_ELEMENTS(ens)
           pas = cloak_data.pa[index_time[index]]
           pas = 90-ABS(pas[UNIQ(pas, SORT(pas))]-90)
           pa = total(pas)/N_ELEMENTS(pas)
           flux = total(cloak_data.flux[index_time[index]])/ct
           eflux = total(cloak_data.eflux[index_time[index]])
           int_flux = total(cloak_data.int_flux[index_time[index]])
           pa_range = total(cloak_data.pa_range[index_time[index]])/ct
          ;  n = total(cloak_data.n[index_time[index]])
          ;  v = total(cloak_data.v[index_time[index]])/ct
          ;  p = total(cloak_data.p[index_time[index]])
          ;  t = total(cloak_data.t[index_time[index]])/ct
        endif
        ens_str_arr[itime] = ens_str
        output[itime,*] = [time[itime], en, pa, flux, eflux, int_flux, pa_range  $ ;, n, n_weighted, p, t $
        ]
        
     endif 
  endfor
  
  str_output = external_data

  str_output =CREATE_STRUCT(str_output, 'en', output[*,1])
  str_output =CREATE_STRUCT(str_output, 'pa', output[*,2])
  str_output =CREATE_STRUCT(str_output, 'flux', output[*,3])
  str_output =CREATE_STRUCT(str_output, 'eflux', output[*,4])
  str_output =CREATE_STRUCT(str_output, 'int_flux', output[*,5])
  str_output =CREATE_STRUCT(str_output, 'pa_range', output[*,6])
  str_output =CREATE_STRUCT(str_output, 'ens', ens_str_arr)
  ; str_output =CREATE_STRUCT(str_output, 'n', output[*,7])
  ; str_output =CREATE_STRUCT(str_output, 'p', output[*,9])
  ; str_output =CREATE_STRUCT(str_output, 't', output[*,10])
  return, str_output
end 

function combine_cloak_data, external_data, cloak_data, type = type
  if ~keyword_set(type) then type = 'cloak_data'

  if type eq 'cloak_data' then output = merge_external_to_cloak(external_data, cloak_data)

  if type eq 'external_data' then output = merge_cloak_to_external(external_data, cloak_data)
; if type eq 'external_data' then new_output = new_merge_cloak_to_external(external_data, cloak_data)

  return, output
end 
