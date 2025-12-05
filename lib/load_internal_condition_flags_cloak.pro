function load_flag_cloak, arr, range, set_nan = set_nan
  flag = float(arr ge range[0] and arr lt range[1])

  if keyword_set(set_nan) then begin
    index = where(~finite(arr), ct)
    if ct gt 0 then flag[index] = !values.f_nan

    index = where(flag eq 0, ct)
    if ct gt 0 then flag[index] = !values.f_nan
  endif

  RETURN, flag
end

function load_energy_flag_cloak, arr, energy_filter, data_type
  if data_type eq 'data' then begin
    energy_flag = float(arr ne '')

    if ~array_equal(energy_filter, [0, 60000]) then begin
      index = where(energy_flag eq 1, ct)
      if ct gt 0 then begin
        ens_list = strsplit(arr[index], ' ', /extract)
        
        for iindex = 0, ct - 1 do energy_flag[index[iindex]] = total(float(ens_list[iindex]) gt energy_filter[0] and float(ens_list[iindex]) lt energy_filter[1], /nan) gt 0
        
      endif
    endif
  endif else begin
    energy_flag = load_flag_cloak(arr, energy_filter)
  endelse

  return, energy_flag
end

; ; Here we used "_1h" solar wind paramenters to use the solar wind parameters that has been averaged over the previouse 1 hour
; PRO load_imfBz_flag_cloak, data, imfBz_filter, imfBz_flag
; imfBz_flag = load_flag_cloak(data.IMF_Bz_1h, imfBz_filter,/set_nan)
; END

; PRO load_imfBy_flag_cloak, data, imfBy_filter, imfBy_flag
; imfBy_flag = load_flag_cloak(data.IMF_By_1h, imfBy_filter,/set_nan)
; END

; PRO load_swP_flag_cloak, data, swP_filter, swP_flag
; swP_flag = load_flag_cloak(data.sw_P_1h, swP_filter,/set_nan)
; END

; PRO load_swV_flag_cloak, data, swV_filter, swV_flag
; swV_flag = load_flag_cloak(abs(data.sw_V_1h), swV_filter,/set_nan)
; END

pro load_direction_flag_cloak, data, direction, direction_flag
  ndata = n_elements(data.time)
  direction_flag = dblarr(ndata)

  if direction eq 'para' then begin
    direction_flag[*] = 1
  endif

  if direction eq 'both' then begin
    direction_flag[*] = 1
  endif

  if direction eq 'anti' then begin
    direction_flag[*] = 0
  endif

  if direction eq 'any' then begin
    direction_flag[*] = 1
  endif

  if direction eq 'outflow' then begin
    direction_flag[*] = 0

    index = where((data.gsm_x gt -1 and data.gsm_z le 0) or (data.gsm_x le -1 and data.bx_gsm le 0), ct)
    if ct gt 0 then direction_flag[index] = 1
  endif

  direction_flag = float(direction_flag)
end

; ----------------------------------------------------------------
; Purpose: load internal condition flags. Internal condition is
; defined as conditions that are different for parallel and
; antiparallel O+ beams. All solar wind conditions are delayed
; according to the O+ beam velocities, and that is the reason the
; solar wind conditions are considered internal conditions here
; ----------------------------------------------------------------

pro load_internal_condition_flags_cloak, data, direction, energy_filter, imfBz_filter, imfBy_filter, swP_filter, swV_filter, flag_int_condition, data_type = data_type
  ; energy_flag = load_flag_cloak(data.ens, energy_filter)

  imfBz_flag = load_flag_cloak(data.imf_bz_1H, imfBz_filter, set_nan = 1)
  imfBy_flag = load_flag_cloak(data.imf_by_1H, imfBy_filter, set_nan = 1)
  swP_flag = load_flag_cloak(data.sw_p_1H, swP_filter, set_nan = 1)
  swV_flag = load_flag_cloak(abs(data.sw_v_1H), swV_filter, set_nan = 1)

  print, 'start to load energy' 
  
  if ~keyword_set(data_type) then data_type = 'full_data'

  if data_type eq 'data' then energy_flag = load_energy_flag_cloak(data.ens, energy_filter, data_type) else energy_flag = load_energy_flag_cloak(data.en, energy_filter, data_type)

  load_direction_flag_cloak, data, direction, direction_flag

  flag_int_condition = direction_flag * energy_flag * imfBz_flag * swP_flag * imfBy_flag * swV_flag

  print, 'finish to load'
end
