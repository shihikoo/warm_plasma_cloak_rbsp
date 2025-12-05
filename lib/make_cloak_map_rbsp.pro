; -------------------------------------------------------------------------------
; Purpose: make map plots for rbsp
; Inputs: data
; header
; Keywords: sort_flag
; sort_title
; ps_plot
; plot_path
; grid
; slice_grid
; coor_set
; region_map_set
; direction_set
; storm_phase_set
; plot_2d
; plot_slice
; point_plot
; events_map
; property_map_set
; property_map_type_set
; make_table
; energy_set
;
; Written by Jing Liao
; Written on 04/2021
; -------------------------------------------------------------------------------

pro make_cloak_map_rbsp, odata, header $
  , sort_flag = sort_flag, sort_title = sort_title $
  , ps_plot = ps_plot, plot_path = plot_path $
  , grid = grid, slice_grid = slice_grid $
  , point_plot = point_plot, events_map = events_map $
  , make_table = make_table $
  , plot_2d = plot_2d, plot_slice = plot_slice $
  , region_map_set = region_map_set $
  , direction_set = direction_set $
  , storm_phase_set = storm_phase_set $
  , substorm_phase_set = substorm_phase_set $
  , coor_set = coor_set $
  , property_map_set = property_map_set $
  , property_map_type_set = property_map_type_set $
  , energy_set = energy_set $
  , imfbz_set = imfBz_set $
  , imfby_set = imfBy_set $
  , swp_set = swP_set $
  , swv_set = swV_set $
  , range_input = range_input $
  , sample_size_threshold = sample_size_threshold $
  , samples_v_range = samples_v_range, ratio_v_range = ratio_v_range $
  , plot_substorm_sea = plot_substorm_sea $
  , l_cuttings = l_cuttings
  ; -- default keywords settings if keywords are not set --
  if ~keyword_set(grid) then grid = 1
  grid_str = string(grid, format = '(i2.2)')
  if ~keyword_set(slice_grid) then slice_grid = 2.

  if ~keyword_set(plot_path) then plot_path = 'unknow_sort/'
  if ~keyword_set(sort_title) then sort_title = ''
  if ~keyword_set(region_map_set) then region_map_set = ['all'] ; ,'Lobe', 'BL', 'PS', 'Tail']
  if ~keyword_set(coor_set) then coor_set = [['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM']] ; ,['X_GSM','Beta','MLT'],['DIST','Beta','MLT']]
  if ~keyword_set(direction_set) then direction_set = ['any'] ; , 'para', 'anti', 'both']
  if ~keyword_set(storm_phase_set) then storm_phase_set = ['all'] ; ,'storm_time','nonstorm_time'] ;,'prestorm', 'nonstorm_time', 'storm_time', 'initial_phase', 'main_phase', 'recovery']
  if ~keyword_set(substorm_phase_set) then substorm_phase_set = ['all'] ; , 'non_substorm', 'substorm']
  if ~keyword_set(property_map_type_set) then property_map_type_set = ['median', 'mean'] ; ['mean', 'median', 'minimum','maximum']
  if ~keyword_set(property_map_set) then property_map_set = [''] ; ['energy', 'flux','pitch_angle','density','temperature','velocity']
  ; IF ~KEYWORD_SET(sample_size_threshold) THEN  sample_size_threshold = 27

  if ~keyword_set(sort_flag) then sort_flag = {sort_flag: 1, sort_flag_fulldata: 1}

  if ~keyword_set(energy_set) || array_equal(energy_set, [[0., 60000.]]) then begin
    energy_set = [[0., 60000.]]
    energy_str = ''
  endif else energy_str = 'en_'

  if ~keyword_set(imfBz_set) || array_equal(imfBz_set, [[-100, 100]]) then begin
    imfBz_set = [[-100, 100]]
    imfBz_str = ''
  endif else imfBz_str = 'imfBz_'

  if ~keyword_set(imfBy_set) || array_equal(imfBy_set, [[-100, 100]]) then begin
    imfBy_set = [[-100, 100]]
    imfBy_str = ''
  endif else imfBy_str = 'imfBy_'

  if ~keyword_set(swP_set) || array_equal(swP_set, [[0, 100]]) then begin
    swP_set = [[0, 100]]
    swP_str = ''
  endif else swP_str = 'swP'

  if ~keyword_set(swV_set) || array_equal(swV_set, [[0, 900]]) then begin
    swV_set = [[0, 900]]
    swV_str = ''
  endif else swV_str = 'swV'

  if ~keyword_set(l_cuttings) then l_cuttings = [[4.5,5.5],[5.5,6],[6,6.5],[6.5,7],[2,8],[2,4],[4,6],[6,8]]

  ; IF ~KEYWORD_SET(kp_set) THEN kp_set = [[0, 9]]
  ; -- time settings --
  get_timespan, interval
  ts_str = time_struct(interval[0])
  te_str = time_struct(interval[1])
  ts_date = string(ts_str.year, format = '(i4.4)') + string(ts_str.month, format = '(i2.2)') + string(ts_str.date, format = '(i2.2)')
  te_date = string(te_str.year, format = '(i4.4)') + string(te_str.month, format = '(i2.2)') + string(te_str.date, format = '(i2.2)')

  ; -- combine conditions --
  condition_set = combine_condition_sets(storm_phase_set, substorm_phase_set, direction_set, region_map_set, coor_set, energy_set, imfBz_set, imfBy_set, swP_set, swV_set)

  ; -- Run plotting routine for different conditions
  for icondition = 0, n_elements(condition_set[*, 0]) - 1 do begin
    data = odata.data

    storm_phase = condition_set[icondition, 0]
    substorm_phase = condition_set[icondition, 1]
    region = condition_set[icondition, 2]
    direction = condition_set[icondition, 3]
    plot_axis = condition_set[icondition, 4 : 6]
    energy_filter = condition_set[icondition, 7 : 8]
    imfBz_filter = condition_set[icondition, 9 : 10]
    swP_filter = condition_set[icondition, 11 : 12]
    imfBy_filter = condition_set[icondition, 13 : 14]
    swV_filter = condition_set[icondition, 15 : 16]

    load_external_condition_flags_rbsp, data, storm_phase, substorm_phase, region, flag_ext_condition

    load_internal_condition_flags_cloak, data, direction, energy_filter, imfBz_filter, imfBy_filter, swP_filter, swV_filter, flag_int_condition, data_type = 'data'

    data.flag = data.flag * flag_int_condition * flag_ext_condition * sort_flag.sort_flag

    load_axis_rbsp, data, plot_axis, data_pos, range, log, range_input = range_input

    ext_condition_str = ''
    if storm_phase ne 'all' then ext_condition_str = ext_condition_str + storm_phase + '_'
    if substorm_phase ne 'all' then ext_condition_str = ext_condition_str + substorm_phase + '_'
    if region ne 'all' then ext_condition_str = ext_condition_str + region + '_'
    ext_condition_str = ext_condition_str + direction

    int_condition_str = ''
    if energy_str ne '' and ~array_equal(energy_filter, [0, 60000]) then int_condition_str = int_condition_str + 'en_' + strtrim(long(energy_filter[0]), 2) + '_' + strtrim(long(energy_filter[1]), 2) + '_'
    if imfBz_str ne '' and ~array_equal(imfBz_filter, [-100, 100]) then int_condition_str = int_condition_str + 'imfBz_' + strtrim(fix(imfBz_filter[0]), 2) + '_' + strtrim(fix(imfBz_filter[1]), 2) + '_'
    if imfBy_str ne '' and ~array_equal(imfBy_filter, [-100, 100]) then int_condition_str = int_condition_str + 'imfBy_' + strtrim(fix(imfBy_filter[0]), 2) + '_' + strtrim(fix(imfBy_filter[1]), 2) + '_'
    if swP_str ne '' and ~array_equal(swP_filter, [0, 20]) then int_condition_str = int_condition_str + 'swP_' + strtrim(fix(swP_filter[0]), 2) + '_' + strtrim(fix(swP_filter[1]), 2) + '_'
    if swV_str ne '' and ~array_equal(swV_filter, [0, 900]) then int_condition_str = int_condition_str + 'swV_' + strtrim(fix(swV_filter[0]), 2) + '_' + strtrim(fix(swV_filter[1]), 2)

    if sort_title ne '' then ext_condition_str = sort_title + '_' + ext_condition_str

    main_path = plot_path + 'grid_' + grid_str + '/' + ext_condition_str + '/'
    path_ev = main_path + 'events/'
    path_sea = path_ev + 'sea/'
    if keyword_set(point_plot) then make_points_map, data_pos, data.flag, data.flag, data.beta, data.mlt, range, log, path_ev, ts_date, te_date, plot_axis, grid, ext_condition_str, int_condition_str, ps_plot = ps_plot

    if keyword_set(events_map) then make_events_map, data_pos, data.flag, data.flag, path_ev, ts_date, te_date, plot_axis, ext_condition_str, int_condition_str, range, log, grid, slice_grid, filename, plot_2d, plot_slice, make_table, ps_plot = ps_plot, threshold = sample_size_threshold,  region = region, samples_v_range = samples_v_range, ratio_v_range = ratio_v_range,remove_ps = remove_ps

    if keyword_set(plot_substorm_sea) then begin
      plot_substorm_sea_ratio, data.flag, data.substorm_phase, data.l, ext_condition_str, int_condition_str, path_sea, ts_date, te_date, filename, ps_plot = ps_plot, l_cuttings = l_cuttings

      for ipmt = 0, n_elements(property_map_type_set) - 1 do begin
        for ipp = 0, n_elements(property_map_set) - 1 do begin
          path_pp_main = main_path + property_map_set[ipp] + '/'

          if property_map_set[ipp] eq 'dipolization' then make_property_map_cloak, data, data_pos, property_map_set[ipp], property_map_type_set[ipmt], data.flag, path_pp_main, ts_date, te_date, plot_axis, ext_condition_str, int_condition_str, range, log, grid, slice_grid, filename, plot_2d, plot_slice, make_table, ps_plot = ps_plot, threshold = sample_size_threshold, plot_substorm_sea = plot_substorm_sea,remove_ps = remove_ps,l_cuttings=l_cuttings
        endfor
      endfor
    endif

    if keyword_set(property_map_set) then begin
      data = odata.fulldata

      load_external_condition_flags_rbsp, data, storm_phase, substorm_phase, region, flag_ext_condition

      load_internal_condition_flags_cloak, data, direction, energy_filter, imfBz_filter, imfBy_filter, swP_filter, swV_filter, flag_int_condition, data_type = 'fulldata'

      data.flag = data.flag * flag_int_condition * flag_ext_condition * sort_flag.sort_flag_fulldata

      load_axis_rbsp, data, plot_axis, data_pos, range, log, range_input = range_input

      for ipmt = 0, n_elements(property_map_type_set) - 1 do begin
        for ipp = 0, n_elements(property_map_set) - 1 do begin
          path_pp_main = main_path + property_map_set[ipp] + '/'

          if property_map_set[ipp] ne 'dipolization' then make_property_map_cloak, data, data_pos, property_map_set[ipp], property_map_type_set[ipmt], data.flag, path_pp_main, ts_date, te_date, plot_axis, ext_condition_str, int_condition_str, range, log, grid, slice_grid, filename, plot_2d, plot_slice, make_table, ps_plot = ps_plot, threshold = sample_size_threshold, plot_substorm_sea = plot_substorm_sea, l_cuttings = l_cuttings,remove_ps = remove_ps
        endfor
      endfor
    endif
  endfor
end
