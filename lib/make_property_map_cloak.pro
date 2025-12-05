; --------------------------------------------------------------------------
; Purpose: write data into csv in x and y axis
; Inputs:  fln_data, x_axis, y_axis, data
; --------------------------------------------------------------------------
; 
pro write_map_csv, fln_data, x_axis, y_axis, data
    data_csv = [reform(y_axis, 1, n_elements(y_axis)), data]

    header = strarr(n_elements(x_axis) + 1)

    for i = 0, n_elements(x_axis) - 1 do header[i + 1] = string(x_axis[i])

    write_csv, fln_data, data_csv, header = header
end

; -----------------------------------------------------------------------------------------------------------------------------------
; Purpose: calculate teh boundary values slicing the x, y and z grids of the maps. If slice_mlt is on, meaning that the z axis is mlt.
; Inputs:
; Written by Jing Liao
; Written on 11/10/2024
; ------------------------------------------------------------------------------------------------------------------------------------
; 
pro calculate_cuttings,x_range, y_range, z_range, grid_x, grid_y, grid_z, x_axis, y_axis, z_axis, x_cuttings, y_cuttings, z_cuttings, slice_mlt = slice_mlt, x_log = x_log, y_log = y_log

  if keyword_set(x_log) then begin
    grid_x = grid_x / 2.
    nx = ceil(abs(alog10(x_range[1]) - alog10(x_range[0])) / grid_x)
    x_axis = 10 ^ (indgen(nx) * grid_x + grid_x * 0.5 + alog10(x_range[0] < x_range[1]))
    x_cuttings = [[x_axis * 10 ^ (-0.5 * grid_x)], [x_axis * 10 ^ (0.5 * grid_x)]]
  endif else begin
    nx = ceil(abs(x_range[1] - x_range[0]) / grid_x)
    x_axis = indgen(nx) * grid_x + (x_range[0] < x_range[1]) + grid_x * 0.5
    x_cuttings = [[x_axis - 0.5 * grid_x], [x_axis + 0.5 * grid_x]]
  endelse

  if keyword_set(y_log) then begin
    grid_y = grid_y / 2.
    ny = ceil(abs(alog10(y_range[1]) - alog10(y_range[0])) / grid_y)
    y_axis = 10 ^ (indgen(ny) * grid_y + grid_y * 0.5 + alog10(y_range[0] < y_range[1]))
    y_cuttings = [[y_axis * 10 ^ (-0.5 * grid_y)], [y_axis * 10 ^ (0.5 * grid_y)]]
  endif else begin
    ny = ceil(abs(y_range[1] - y_range[0]) / grid_y)
    y_axis = indgen(ny) * grid_y + (y_range[0] < y_range[1]) + grid_y * 0.5
    y_cuttings = [[y_axis - 0.5 * grid_y], [y_axis + 0.5 * grid_y]]
  endelse

  if keyword_set(slice_mlt) then begin
    z_axis = [0, 4, 8, 12, 16, 20]
    z_cuttings = [[22, 2, 6, 10, 14, 18], [2, 6, 10, 14, 18, 22]]
    nz = n_elements(z_axis)
  endif else begin
    nz = ceil(abs(z_range[1] - z_range[0]) / grid_z)
    ; IF z_log EQ 1 THEN z_axis = 10^(INDGEN(nz)*grid_z + grid_z*0.5 + z_range[0] < z_range[1]) ELSE
    z_axis = indgen(nz) * grid_z + (z_range[0] < z_range[1]) + grid_z * 0.5
    z_cuttings = [[z_axis - 0.5 * grid_z], [z_axis + 0.5 * grid_z]]
    ; IF z_log EQ 1 THEN nz = CEIL(ABS(alog10(z_range[1]) - alog10(z_range[0]))/grid_z) ELSE
  endelse
end

pro filter_property, flag, property, data_pos, substorm_phase = substorm_phase
if n_elements(flag) ne n_elements(property) or n_elements(flag) ne n_elements(data_pos)/3 then stop
  ; filter property with flag
  index_flag = where(flag gt 0, ct)
  if ct eq 0 then begin
    property[*] = !values.f_nan
    data_pos[*] = !values.f_nan
    if keyword_set(substorm_phase) then substorm_phase[*] = !values.f_nan
  endif 
  if ct gt 0 then begin 
    property = property[index_flag]
    data_pos = data_pos[index_flag, *]
    if keyword_set(substorm_phase) then substorm_phase = substorm_phase[index_flag]
  endif 
end

pro adjust_for_mlt, grid, plot_axis, grid_x, grid_y, slice_mlt = slice_mlt
  ; reset grid according to plot_axis
  if plot_axis[0] eq 'MLT' then begin
    grid_x = 0.5 * grid
    grid_y = 1.0 * grid
  endif else begin
    grid_x = grid
    grid_y = grid
  endelse

  if plot_axis[2] eq 'MLT' then begin
    slice_mlt = 1
  endif

end
; ----------------------------------------------------------
; Purpose: calculate the aggratation value based on type required
; Inputs: property_value, property_map_type
; ------------------------------------------------------------
function aggregate_property_value_cloak, property_values, property_map_type

  ; -------- mean
  if property_map_type eq 'mean' then  property_result = mean(property_values, /nan)
  
  ; -------- median
  if property_map_type eq 'median' then begin
        index = where(finite(property_values), ct)
        if ct gt 0 then property_values = property_values[index]
        property_result = median(property_values, /even)
  endif

  ; -------- minimum
  if property_map_type eq 'minimum' then  property_result = min(property_values, /nan)

  ; -------- maximum
  if property_map_type eq 'maximum' then  property_result = max(dummy, /nan)

  ; -------- difference
  if property_map_type eq 'difference' then  property_result = abs(max(dummy, /nan) - min(dummy, /nan))

  ; -------- standard deviation
  if property_map_type eq 'sd' then property_result = stddev(dummy, /nan)

  ; -------- upper quartile
  if property_map_type eq 'q3' then property_result = calcuate_quartile(dummy, 'q3')

  ; -------- lower quartile
  if property_map_type eq 'q1' then  property_result = calcuate_quartile(dummy, 'q1')

  ; -------- lower quartile
  if property_map_type eq 'iqr' then property_result = calcuate_quartile(dummy, 'iqr')

  return, property_result
end

; ----------------------------------------------
; Purpose: Calculate property value in axis for map
; Inputs:
; Written by Jing Liao
; Written on 05/12/2024
; ----------------------------------------------------
function calculate_property_map_cloak, property, data_pos, property_map_type, x_cuttings, y_cuttings, threshold = threshold ;, total_counts = total_counts

  nx = n_elements(x_cuttings)/2
  ny = n_elements(y_cuttings)/2

  property_map_value = replicate(!values.f_nan, nx, ny)

  if n_elements(property) eq 0 then return, property_map_value

  for ix = 0, nx - 1 do begin
    for iy = 0, ny - 1 do begin
          index = where(data_pos[*, 0] ge x_cuttings[ix, 0] and data_pos[*, 0] lt x_cuttings[ix, 1] and $
            data_pos[*, 1] ge y_cuttings[iy, 0] and data_pos[*, 1] lt y_cuttings[iy, 1], ct)
        if ct ge threshold then begin 
          property_map_value[ix,iy] = aggregate_property_value_cloak(property[index], property_map_type)
        endif 
    endfor
  endfor

  ; index = where(total_counts le threshold, ct)
  ; if ct gt 0 then property_map_value[index] = !values.f_nan

  return, property_map_value

end

; ------------
; Purpose: calculate quartile output depending on requested value
; Inputs:
; -----------------
function calcuate_quartile, input_array, output_type
  index = where(finite(input_array), ct)
  if ct eq 0 then return, !values.f_nan
  input_array = input_array[index]
  sortedData = input_array[sort(input_array)]
  if n_elements(sortedData) mod 2 eq 0 then begin
    index = n_elements(sortedData) / 2
    medianData = (sortedData[index - 1] + sortedData[index]) / 2.0
    lowerGroup = sortedData[0 : index - 1]
    higherGroup = sortedData[index : n_elements(data) - 1]
  endif else begin
    index = n_elements(sortedData) / 2
    medianData = sortedData[index]
    lowerGroup = sortedData[0 : index - 1]
    higherGroup = sortedData[index + 1 : n_elements(data) - 1]
  endelse

  if output_type eq 'q1' then return, median(lowerGroup, /even)
  if output_type eq 'q3' then return, median(higherGroup, /even)
  if output_type eq 'iqr' then return, median(higherGroup, /even) - median(lowerGroup, /even)

  return, median(sortedData, /even)
end

; ----------------------------------------------------
; Purpose: make 2d property map
; Inputs: property_value, property_map_type, property_name, filepath, ts_date, te_date, plot_axis, x_axis, y_axis, x_range, y_range,filename,  property_v_log, property_v_range, property_unit
; Keywords:ps_plot
; ----------------------------------------------------
pro make_2d_property_map_cloak, property, data_pos,  property_map_type, property_name, filepath, ext_condition_str, int_condition_str, ts_date, te_date, plot_axis, x_axis, y_axis, x_range, y_range, xlog, ylog, x_cuttings, y_cuttings, filename, property_v_log, property_v_range, property_unit, ps_plot = ps_plot, threshold = threshold,remove_ps = remove_ps ;, total_counts = total_counts
  ; 2d filepath
  path_pp_2d = filepath + '2d/'

  ;   if size(property_value, /n_dim) ne 3 and size(property_value, /n_dim) ne 4 then stop
;   if size(property_value, /n_dim) eq 4 then begin
;     nx = n_elements(property_value[0, *, 0, 0])
;     ny = n_elements(property_value[0, 0, *, 0])
;   endif else begin
;     nx = n_elements(property_value[0, *, 0])
;     ny = n_elements(property_value[0, 0, *])
;   endelse
;   property_result = replicate(!values.f_nan, nx, ny)

  ; calculation

  property_map_2d = calculate_property_map_cloak(property, data_pos, property_map_type, x_cuttings, y_cuttings, threshold = threshold);, total_counts = total(total_counts, 3, /nan))

  ; draw heat map
  filename = path_pp_2d + ext_condition_str + '_' + int_condition_str + '_' + property_map_type + '_' + property_name + '_' + '_' + ts_date + '_to_' + te_date + '_' + plot_axis[0] + '_vs_' + plot_axis[1] 

  title = ext_condition_str + '!C' + int_condition_str + '!C' + property_map_type + ' ' + property_name + '!Cfrom ' + ts_date + ' TO ' + te_date
  
  make_heat_map, x_axis, y_axis, property_map_2d, filename+'.ps', title, plot_axis, unit = property_unit, xrange = x_range, yrange = y_range, zrange = property_v_range, xlog = xlog, ylog = ylog, zlog = property_v_log, ps_plot = ps_plot, remove_ps = remove_ps

  ; write ratio into a csv file
  write_map_csv, filename + '.csv' , x_axis, y_axis, property_map_2d

end

pro make_slice_property_map_cloak, property, data_pos, property_map_type, property_name, filepath, ext_condition_str, int_condition_str, ts_date, te_date, plot_axis, x_axis, y_axis, z_axis, z_cuttings, x_range, y_range, xlog, ylog, x_cuttings, y_cuttings, slice_grid, filename, property_v_log, property_v_range, property_unit, ps_plot = ps_plot, slice_mlt = slice_mlt, threshold = threshold, remove_ps = remove_ps ;, total_counts = total_counts

  nz =  n_elements(z_cuttings)/2 - 1
  ; slice filepath
  slice_grid_str = string(slice_grid, format = '(i2.2)')
  path_pp_slice = filepath + 'slice/slice_zgrid_' + slice_grid_str + '/'

  for iz = 0, nz - 1 do begin
    ct_slice = 0
    index_slice = []
    if z_cuttings[iz, 0] gt z_cuttings[iz, 1] and keyword_set(slice_mlt) then begin
      index_slice = where((data_pos[*, 2] ge z_cuttings[iz, 0] and data_pos[*, 2] lt 24.) or (data_pos[*, 2] ge 0 and data_pos[*, 2] lt z_cuttings[iz, 1]), ct_slice)
    endif else begin
      index_slice = where(data_pos[*, 2] ge z_cuttings[iz, 0] and data_pos[*, 2] lt z_cuttings[iz, 1], ct_slice)
    endelse
    if ct_slice gt 0 then property_slice = property[index_slice] else property_slice = []

    ; calculation
    property_map_slice = calculate_property_map_cloak(property_slice, data_pos, property_map_type, x_cuttings, y_cuttings, threshold = threshold) ;, total_counts = total(total_counts, 3, /nan))

    ; draw the plot
    slice_block = [strcompress(string(z_cuttings[iz, 0], format = '(f5.1)'), /remove_all), $
      strcompress(string(z_cuttings[iz, 1], format = '(f5.1)'), /remove_all)]

    filename = path_pp_slice + ext_condition_str + '_' + int_condition_str + '_' + property_map_type + '_' + property_name + '_' + '_' + ts_date + '_to_' + te_date + '_' + plot_axis[0] + '_vs_' + plot_axis[1] + '_at_' + plot_axis[2] + '_' + slice_block[0] + '_' + slice_block[1] + '.ps'
    title = ext_condition_str + '!C' + int_condition_str + '!C' + property_map_type + ' ' + property_name + ' at ' + plot_axis[2] + ':[ ' + slice_block[0] + ',' + slice_block[1] + ' ] ' + '!CFROM ' + ts_date + ' TO ' + te_date

    make_heat_map, x_axis, y_axis, property_map_slice, filename, title, plot_axis, unit = property_unit, xrange = x_range, yrange = y_range, zrange = property_v_range, xlog = xlog, ylog = ylog, zlog = property_v_log, ps_plot = ps_plot, remove_ps = remove_ps

    ; write ratio into a csv file
    fln_data = path_pp_slice + ext_condition_str + '_' + int_condition_str + '_' + property_map_type + '_' + property_name + '_' + '_' + ts_date + '_to_' + te_date + '_' + plot_axis[0] + '_vs_' + plot_axis[1] + '_at_' + plot_axis[2] + '_' + slice_block[0] + '_' + slice_block[1] + '.csv'

    data_csv = [reform(y_axis, 1, n_elements(y_axis)), property_map_slice]

    header = strarr(n_elements(x_axis) + 1)

    for i = 0, n_elements(x_axis) - 1 do header[i + 1] = string(x_axis[i])

    write_csv, fln_data, data_csv, header = header

  endfor
end

; ------------------------------------------------------------------------------
; Purpose: make property map
; Inputs: data, data_pos, property_name, property_map_type, flag, filepath, ts_date, te_date, plot_axis,  x_range, y_range, z_range, grid, slice_grid, filename, plot_2d, plot_slice, make_table
; Keywords: ps_plot
; ------------------------------------------------------------------------------
pro make_property_map_cloak, data, data_pos_input, property_name, property_map_type, flag, filepath, ts_date, te_date, plot_axis, ext_condition_str, int_condition_str, range, log, grid, slice_grid, filename, plot_2d, plot_slice, make_table, ps_plot = ps_plot, threshold = threshold, x_log = x_log, y_log = y_log, plot_substorm_sea=plot_substorm_sea, l_cuttings = l_cuttings,remove_ps = remove_ps ;, total_counts = total_counts

  x_range = range[*, 0]
  y_range = range[*, 1]
  z_range = range[*, 2]
  ; r_range=ABS(y_range[0]-y_RANGE[1])
  xlog = log[0]
  ylog = log[1]
  
  data_pos = data_pos_input
  substorm_phase = data.substorm_phase

  ; print, property_name + ' ' + property_map_type
  ; load property data and property graphing settings
  load_property_data_cloak, data, property_name, property, property_v_log, property_v_range, property_unit, property_map_type = property_map_type

  ; filter the property and data_pos with only data that has a valid cloak identification
  filter_property, flag , property, data_pos, substorm_phase = substorm_phase

  ; for maps with mlt, the grid is different for grid_x and grid_y.
  adjust_for_mlt, grid, plot_axis, grid_x, grid_y, slice_mlt = slice_mlt

  calculate_cuttings, x_range, y_range, z_range, grid_x, grid_y, slice_grid, x_axis, y_axis, z_axis, x_cuttings, y_cuttings, z_cuttings, slice_mlt = slice_mlt, x_log = x_log, y_log = y_log

  ; Draw 2d maps
  if keyword_set(plot_2d) then make_2d_property_map_cloak, property, data_pos, property_map_type, property_name, filepath, ext_condition_str, int_condition_str, ts_date, te_date, plot_axis, x_axis, y_axis, x_range, y_range, xlog, ylog, x_cuttings, y_cuttings, filename, property_v_log, property_v_range, property_unit, ps_plot = ps_plot, threshold = threshold,remove_ps = remove_ps ;, total_counts = total_counts

  ; Draw slice maps
  if keyword_set(plot_slice) then make_slice_property_map_cloak, property, data_pos, property_map_type, property_name, filepath, ext_condition_str, int_condition_str, ts_date, te_date, plot_axis, x_axis, y_axis, z_axis, z_cuttings, x_range, y_range, xlog, ylog, x_cuttings, y_cuttings, slice_grid, filename, property_v_log, property_v_range, property_unit, ps_plot = ps_plot, slice_mlt = slice_mlt, threshold = threshold,remove_ps = remove_ps ;, total_counts = total_counts
  
  ; Draw superposed epoches analsys for substorms 
  if keyword_set(plot_substorm_sea) then  plot_substorm_sea_property, property, substorm_phase, data_pos, property_map_type, property_name, filepath+'sea/', ext_condition_str, int_condition_str, ts_date, te_date, filename, property_v_log, property_v_range, property_unit, ps_plot = ps_plot, l_cuttings = l_cuttings,remove_ps = remove_ps

  ; make historgram
  if keyword_set(make_table) then stop

end