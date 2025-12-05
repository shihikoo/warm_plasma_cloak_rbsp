; -------------------------------------------------------------------------------
; Purpose: Create maps of streaming O+ with given conditions
; Desctiption: Process is written for RBSP HOPE O+ data
; Inputs:
; Keywords: ps_plot, read_from_dat, store_tplot
;
; Created by Jing Liao
; Created on 04/13/2021
; -------------------------------------------------------------------------------

pro sort_cloak_map_rbsp, sc = sc, sp = sp, ps_plot = ps_plot, read_from_dat = read_from_dat, store_tplot = store_tplot, time_start = time_start, time_end = time_end, stop = stop $
  , sliced_with_input_range = sliced_with_input_range, non_sort_map = non_sort_map, sort_hemi_map = sort_hemi_map, sort_dist_map = sort_dist_map $
  , sort_kp_map = sort_kp_map, sort_ae_map = sort_ae_map, sort_bx = sort_bx $
  , plot_2d = plot_2d $
  , plot_slice = plot_slice $
  , direction_set = direction_set $
  , storm_phase_set = storm_phase_set $
  , substorm_phase_set = substorm_phase_set $
  , region_map_set = region_map_set $
  , point_plot = point_plot $
  , property_map_set = property_map_set $
  , property_map_type_set = property_map_type_set $
  , events_map = events_map $
  , coor_set = coor_set $
  , grid = grid, slice_grid = slice_grid $
  , energy_set = energy_set $ direction_set
  , imfbz_set = imfBz_set $
  , imfby_set = imfBy_set $
  , swp_set = swP_set $
  , swv_set = swV_set $
  , flux_threshold = flux_threshold $
  , def_pap_factor = def_pap_factor $
  , average_time = average_time $
  , hemi_sort_sliced = hemi_sort_sliced $
  , sample_size_threshold = sample_size_threshold $
  , diff_pa = diff_pa, diff_en = diff_en, diff_time = diff_time $
  , remove_isotropic = remove_isotropic, release = release, isotropic_pa_def = isotropic_pa_def $
  , samples_v_range = samples_v_range, ratio_v_range = ratio_v_range $
  , plot_substorm_sea = plot_substorm_sea $
  , sort_mlt_map = sort_mlt_map
  ; ---------------------------------------------------------------
  ; Handle keywords
  ; --------------------------------------------------------------

  ; if n_elements(sc) eq 0 then sc = 1 ; set the satallite number
  if sc eq 1 then sc_str = 'A'
  if sc eq 2 then sc_str = 'B'

  ; if n_elements(sp) eq 0 then sp = 0 ; set the species, 0: H+, 3: O+

  if ~keyword_set(remove_isotropic) then remove_isotropic = 1
  if ~keyword_set(diff_pa) then diff_pa = 1
  if ~keyword_set(diff_en) then diff_en = 0
  if ~keyword_set(diff_time) then diff_time = 4
  if ~keyword_set(release) then release = 'rel04' ; 'rel04', 'rel05'

  ; if n_elements(flux_threshold) eq 0 then flux_threshold = [20, 20, 20] ; [0,0,0] ;[0.1, 0.15, 0.2]
  if array_equal(flux_threshold, [0, 0, 0]) then flux_threshold_str = '' else flux_threshold_str = '_flux' + string(flux_threshold[0], format = '(i2.0)') + string(flux_threshold[1], format = '(i2.0)') + string(flux_threshold[2], format = '(i2.0)')
  print, flux_threshold
  ; if n_elements(def_pap_factor) eq 0 then def_pap_factor = [3, 1.3, 1.3] ; [1,1,1] ;[1.7, 1.4, 1.1] ;[3, 2.5, 2] [3,2.0,1.1]
  if array_equal(def_pap_factor, [1, 1, 1]) then def_pap_factor_str = '' else def_pap_factor_str = '_pap' + string(def_pap_factor[0], format = '(f3.1)') + string(def_pap_factor[1], format = '(f3.1)') + string(def_pap_factor[2], format = '(f3.1)')

  ; if n_elements(isotropic_pa_def) eq 0 then isotropic_pa_def = [60, 120]  ; [30,150],[45,135] [60, 120]
  if array_equal(isotropic_pa_def, [90, 90]) then isotropic_pa_def_str = '' else isotropic_pa_def_str = '_isotropic' + string(isotropic_pa_def[0], format = '(i3.3)') + string(isotropic_pa_def[1], format = '(i3.3)')

  if ~keyword_set(time_start) then time_start = '2013-01-01/00:00:00'
  if ~keyword_set(time_end) then time_end = '2019-11-01'

  if ~keyword_set(average_time) then average_time = 5 * 60 ; in seconds

  if ~keyword_set(sample_size_threshold) then sample_size_threshold = 27

  ; ----------------------------------------------------
  ; Set up folders filenames
  ; -----------------------------------------------------
  output_path = 'output'
  output_path = output_path + '_' + release + '_' + strcompress(average_time, /remove_all) + 'sec'

  if keyword_set(diff_pa) then output_path = output_path + '_pa' + strcompress(diff_pa, /remove_all)
  if keyword_set(diff_en) then output_path = output_path + '_en' + strcompress(diff_en, /remove_all)
  if keyword_set(diff_time) then output_path = output_path + '_time' + strcompress(diff_time, /remove_all)

  if flux_threshold_str ne '' then output_path = output_path + flux_threshold_str
  if def_pap_factor_str ne '' then output_path = output_path + def_pap_factor_str
  if isotropic_pa_def_str ne '' then output_path = output_path + isotropic_pa_def_str

  output_path = output_path + '/'

  scsp_str = 'sc' + strcompress(sc, /remove_all) + '_sp' + strcompress(sp, /remove_all)

  data_path = output_path + 'data/' + scsp_str + '/'
  plot_path = output_path + 'plots/' + scsp_str + '/'
  tplot_path = output_path + 'tplot_map/' + scsp_str + '/'

  if keyword_set(sample_size_threshold) then plot_path = plot_path + 'maps_ss' + strcompress(string(sample_size_threshold), /remove_all)

  plot_path = plot_path + '/'
  tplot_path = tplot_path + '/'
  ; --------------------------------------------------------------------------
  ; read in daily data from csv files into structure data
  ; ---------------------------------------------------------------------------
  read_daily_cloak_data_rbsp, time_start, time_end, tplot_path, data_path, read_from_dat = read_from_dat, store_tplot = store_tplot

  get_data, 'data', data = data
  ; ----------------------------------------------------------------------------
  ; non_sort plots
  ; ----------------------------------------------------------------------------
  if keyword_set(non_sort_map) then begin
    sort_path = plot_path + 'non_sort_map/'
    ; sort_flag = {sort_flag:1, sort_flag_fulldata:1}
    sort_title = ''
    make_cloak_map_rbsp, data, header $
      , sort_flag = sort_flag, sort_title = sort_title $
      , ps_plot = ps_plot, plot_path = sort_path $
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
      , sample_size_threshold = sample_size_threshold, samples_v_range = samples_v_range, ratio_v_range = ratio_v_range $
      , plot_substorm_sea = plot_substorm_sea
  endif

  if keyword_set(sort_kp_map) then begin
    kp_set = ['lt_2', 'ge_2']
    kp_title_set = ['lt_2', 'ge_2']
    for iset = 0, n_elements(kp_set) - 1 do begin
      this_range_str = kp_set[iset]
      this_title_set = kp_title_set[iset]
      sort_title = 'Kp' + this_title_set
      sort_path = plot_path + 'kp_sort_map/kp_' + this_range_str + '/'
      if iset eq 0 then begin
        sort_flag_data = 1.0 * (data.data.kp lt 2)
        sort_flag_fulldata = 1.0 * (data.fulldata.kp lt 2)
      endif else begin
        sort_flag_data = 1.0 * (data.data.kp ge 2)
        sort_flag_fulldata = 1.0 * (data.fulldata.kp ge 2)
      endelse

      index = where(sort_flag_data eq 0, ct)
      if ct gt 0 then sort_flag_data[index] = !values.f_nan
      index = where(sort_flag_fulldata eq 0, ct)
      if ct gt 0 then sort_flag_fulldata[index] = !values.f_nan

      sort_flag = {sort_flag: sort_flag_data, sort_flag_fulldata: sort_flag_fulldata}

      make_cloak_map_rbsp, data, header $
        , sort_flag = sort_flag, sort_title = sort_title $
        , ps_plot = ps_plot, plot_path = sort_path $
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
        , sample_size_threshold = sample_size_threshold, samples_v_range = samples_v_range, ratio_v_range = ratio_v_range $
        , plot_substorm_sea = plot_substorm_sea
    endfor
  endif

  if keyword_set(sort_mlt_map) then begin
    mlt_set = ['night_quarter']; ['all_mlt','night_side', 'day_side', 'night_quarter', 'dawn_quarter', 'dusk_quarter', 'day_quarter']
    mlt_title_set =  ['night_quarter'] ;['all_mlt','night_side', 'day_side', 'night_quarter', 'dawn_quarter', 'dusk_quarter', 'day_quarter']
    for iset = 0, n_elements(mlt_set) - 1 do begin
      this_range_str = mlt_set[iset]
      this_title_set = mlt_title_set[iset]
      sort_title = 'mlt' + this_title_set
      sort_path = plot_path + 'mlt_sort_map/mlt_' + this_range_str + '/'

      if this_range_str eq 'all_mlt' then begin
        sort_flag_data = 1.0 * (data.data.mlt  ge 0)
        sort_flag_fulldata = 1.0 * (data.data.mlt  ge 0)
      endif

      if this_range_str eq 'night_side' then begin
        sort_flag_data = 1.0 * (data.data.mlt le 6 or data.data.mlt gt 18)
        sort_flag_fulldata = 1.0 * (data.fulldata.mlt lt 6 or data.fulldata.mlt gt 18)
      endif
      if this_range_str eq 'day_side' then begin
        sort_flag_data = 1.0 * (data.data.mlt le 18 and data.data.mlt gt 6)
        sort_flag_fulldata = 1.0 * (data.fulldata.mlt lt 18 and data.fulldata.mlt gt 6)
      endif
      if this_range_str eq 'night_quarter' then begin
        sort_flag_data = 1.0 * (data.data.mlt le 3 or data.data.mlt gt 22)
        sort_flag_fulldata = 1.0 * (data.fulldata.mlt lt 3 or data.fulldata.mlt gt 22)
      endif
      if this_range_str eq 'dawn_quarter' then begin
        sort_flag_data = 1.0 * (data.data.mlt le 9 and data.data.mlt gt 3)
        sort_flag_fulldata = 1.0 * (data.fulldata.mlt lt 9 and data.fulldata.mlt gt 3)
      endif
      if this_range_str eq 'dusk_quarter' then begin
        sort_flag_data = 1.0 * (data.data.mlt le 22 and data.data.mlt gt 15)
        sort_flag_fulldata = 1.0 * (data.fulldata.mlt lt 22 and data.fulldata.mlt gt 15)
      endif
      if this_range_str eq 'day_quarter' then begin
        sort_flag_data = 1.0 * (data.data.mlt le 15 and data.data.mlt gt 9)
        sort_flag_fulldata = 1.0 * (data.fulldata.mlt lt 15 and data.fulldata.mlt gt 9)
      endif

      index = where(sort_flag_data eq 0, ct)
      if ct gt 0 then sort_flag_data[index] = !values.f_nan
      index = where(sort_flag_fulldata eq 0, ct)
      if ct gt 0 then sort_flag_fulldata[index] = !values.f_nan

      sort_flag = {sort_flag: sort_flag_data, sort_flag_fulldata: sort_flag_fulldata}

      make_cloak_map_rbsp, data, header $
        , sort_flag = sort_flag, sort_title = sort_title $
        , ps_plot = ps_plot, plot_path = sort_path $
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
        , sample_size_threshold = sample_size_threshold, samples_v_range = samples_v_range, ratio_v_range = ratio_v_range $
        , plot_substorm_sea = plot_substorm_sea
    endfor
  endif

  if keyword_set(sort_ae_map) then begin
    ae_set = ['lt_200', 'ge_200']
    ae_title_set = ['lt_200', 'ge_200']
    for iset = 0, n_elements(ae_set) - 1 do begin
      this_range_str = ae_set[iset]
      this_title_set = ae_title_set[iset]
      sort_title = 'AE' + this_title_set
      sort_path = plot_path + 'ae_sort_map/ae_' + this_range_str + '/'
      if iset eq 0 then begin
        sort_flag_data = 1.0 * (data.data.ae lt 200)
        sort_flag_fulldata = 1.0 * (data.fulldata.ae lt 200)
      endif else begin
        sort_flag_data = 1.0 * (data.data.ae ge 200)
        sort_flag_fulldata = 1.0 * (data.fulldata.ae ge 200)
      endelse

      index = where(sort_flag_data eq 0, ct)
      if ct gt 0 then sort_flag_data[index] = !values.f_nan
      index = where(sort_flag_fulldata eq 0, ct)
      if ct gt 0 then sort_flag_fulldata[index] = !values.f_nan

      sort_flag = {sort_flag: sort_flag_data, sort_flag_fulldata: sort_flag_fulldata}

      make_cloak_map_rbsp, data, header $
        , sort_flag = sort_flag, sort_title = sort_title $
        , ps_plot = ps_plot, plot_path = sort_path $
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
        , sample_size_threshold = sample_size_threshold, samples_v_range = samples_v_range, ratio_v_range = ratio_v_range $
        , plot_substorm_sea = plot_substorm_sea
    endfor
  endif

  if keyword_set(sort_hemi_map) then begin
    coor_set = [['MLT', 'L', 'MLAT']]
    plot_2d = 1
    plot_slice = 0

    bx_set = ['south', 'north']
    bx_title_set = ['south', 'north']
    for iset = 0, n_elements(bx_set) - 1 do begin
      this_range_str = bx_set[iset]
      this_title_set = bx_title_set[iset]
      sort_title = this_title_set
      sort_path = plot_path + 'hemi_sort_map/hemi_' + this_range_str + '/'
      if iset eq 0 then begin
        sort_flag_data = 1.0 * ((data.data.gsm_x le -1 and data.data.bx_gsm le 0) or (data.data.gsm_x gt -1 and data.data.gsm_z le 0))
        sort_flag_fulldata = 1.0 * ((data.fulldata.gsm_x le -1 and data.fulldata.bx_gsm le 0) or (data.fulldata.gsm_x gt -1 and data.fulldata.gsm_z le 0))
      endif else begin
        sort_flag_data = 1.0 * ((data.data.gsm_x le -1 and data.data.bx_gsm gt 0) or (data.data.gsm_x gt -1 and data.data.gsm_z gt 0))
        sort_flag_fulldata = 1.0 * ((data.fulldata.gsm_x le -1 and data.fulldata.bx_gsm gt 0) or (data.fulldata.gsm_x gt -1 and data.fulldata.gsm_z gt 0))
      endelse

      index = where(sort_flag_data eq 0, ct)
      if ct gt 0 then sort_flag_data[index] = !values.f_nan
      index = where(sort_flag_fulldata eq 0, ct)
      if ct gt 0 then sort_flag_fulldata[index] = !values.f_nan

      sort_flag = {sort_flag: sort_flag_data, sort_flag_fulldata: sort_flag_fulldata}

      make_cloak_map_rbsp, data, header $
        , sort_flag = sort_flag, sort_title = sort_title $
        , ps_plot = ps_plot, plot_path = sort_path $
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
        , sample_size_threshold = sample_size_threshold, samples_v_range = samples_v_range, ratio_v_range = ratio_v_range $
        , plot_substorm_sea = plot_substorm_sea
    endfor
  endif

  if keyword_set(sort_bx) then begin
    bx_set = ['le15', 'gt15']
    bx_title_set = ['le15', 'gt15']
    for iset = 0, n_elements(bx_set) - 1 do begin
      this_range_str = bx_set[iset]
      this_title_set = bx_title_set[iset]
      sort_title = this_title_set
      sort_path = plot_path + 'bx_sort_map/bx_' + this_range_str + '/'
      if iset eq 0 then begin
        sort_flag_data = 1.0 * (abs(data.data.bx_gsm) le 15)
        sort_flag_fulldata = 1.0 * (abs(data.fulldata.bx_gsm) le 15)
      endif else begin
        sort_flag = 1.0 * (abs(data.data.bx_gsm) gt 15)
        sort_flag_fulldata = 1.0 * (abs(data.fulldata.bx_gsm) gt 15)
      endelse

      index = where(sort_flag_data eq 0, ct)
      if ct gt 0 then sort_flag_data[index] = !values.f_nan
      index = where(sort_flag_fulldata eq 0, ct)
      if ct gt 0 then sort_flag_fulldata[index] = !values.f_nan

      sort_flag = {sort_flag: sort_flag_data, sort_flag_fulldata: sort_flag_fulldata}

      make_cloak_map_rbsp, data, header $
        , sort_flag = sort_flag, sort_title = sort_title $
        , ps_plot = ps_plot, plot_path = sort_path $
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
        , sample_size_threshold = sample_size_threshold, samples_v_range = samples_v_range, ratio_v_range = ratio_v_range $
        , plot_substorm_sea = plot_substorm_sea
    endfor
  endif

  if keyword_set(sort_dist_map) then begin
    dist_set = ['gt7']
    dist_title_set = ['gt7']
    for iset = 0, n_elements(dist_set) - 1 do begin
      this_range_str = dist_set[iset]
      this_title_set = dist_title_set[iset]
      sort_title = this_title_set
      sort_path = plot_path + 'dist_sort_map/dist_' + this_range_str + '/'
      if iset eq 0 then begin
        sort_flag_data = 1.0 * (abs(data.data.dist) gt 7)
        sort_flag_fulldata = 1.0 * (abs(data.fulldata.dist) gt 7)
      endif else begin
        sort_flag_data = 1.0
        sort_flag_fulldata = 1.0
      endelse

      index = where(sort_flag_data eq 0, ct)
      if ct gt 0 then sort_flag_data[index] = !values.f_nan
      index = where(sort_flag_fulldata eq 0, ct)
      if ct gt 0 then sort_flag_fulldata[index] = !values.f_nan

      sort_flag = {sort_flag: sort_flag_data, sort_flag_fulldata: sort_flag_fulldata}

      make_cloak_map_rbsp, data, header $
        , sort_flag = sort_flag, sort_title = sort_title $
        , ps_plot = ps_plot, plot_path = sort_path $
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
        , sample_size_threshold = sample_size_threshold, samples_v_range = samples_v_range, ratio_v_range = ratio_v_range $
        , plot_substorm_sea = plot_substorm_sea
    endfor
  endif

  if keyword_set(sliced_with_input_range) then begin
    plot_2d = 0
    plot_slice = 1
    coor_set_set = [['MLT', 'L', 'MLAT']]
    slice_grid_set = [30]
    input_range_set = [0, 90]
    ; coor_set_set = [['X_GSM', 'Y_GSM', 'Z_GSM']]
    ; slice_grid_set = [5.]
    ; input_range_set = [[-15.,10.]]

    for iset = 0, n_elements(slice_grid_set) - 1 do begin
      coor_set = coor_set_set[*, iset]
      slice_grid = slice_grid_set[iset]
      range_input = input_range_set[*, iset]

      sort_title = ''
      sort_path = plot_path + 'non_sort_map/'

      make_cloak_map_rbsp, data, header $
        , sort_flag = sort_flag, sort_title = sort_title $
        , ps_plot = ps_plot, plot_path = sort_path $
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
        , sample_size_threshold = sample_size_threshold, samples_v_range = samples_v_range, ratio_v_range = ratio_v_range $
        , plot_substorm_sea = plot_substorm_sea
    endfor
  endif

  if keyword_set(hemi_sort_sliced) then begin
    plot_2d = 0
    plot_slice = 1

    bx_set = ['south', 'north']
    bx_title_set = ['south', 'north']

    coor_set_set = [['MLT', 'L', 'MLAT']]
    slice_grid_set = [30.]
    input_range_set = [[0., 90.]]

    for i_bxset = 0, n_elements(bx_set) - 1 do begin
      this_range_str = bx_set[i_bxset]
      this_title_set = bx_title_set[i_bxset]
      sort_title = this_title_set
      sort_path = plot_path + 'hemi_sort_map/hemi_' + this_range_str + '/'
      if i_bxset eq 0 then begin
        sort_flag_data = 1.0 * ((data.data.gsm_x le -1 and data.data.bx_gsm le 0) or (data.data.gsm_x gt -1 and data.data.gsm_z le 0))
        sort_flag_fulldata = 1.0 * ((data.fulldata.gsm_x le -1 and data.fulldata.bx_gsm le 0) or (data.fulldata.gsm_x gt -1 and data.fulldata.gsm_z le 0))
      endif else begin
        sort_flag_data = 1.0 * ((data.data.gsm_x le -1 and data.data.bx_gsm gt 0) or (data.data.gsm_x gt -1 and data.data.gsm_z gt 0))
        sort_flag_fulldata = 1.0 * ((data.fulldata.gsm_x le -1 and data.fulldata.bx_gsm gt 0) or (data.fulldata.gsm_x gt -1 and data.fulldata.gsm_z gt 0))
      endelse

      index = where(sort_flag_data eq 0, ct)
      if ct gt 0 then sort_flag_data[index] = !values.f_nan
      index = where(sort_flag_fulldata eq 0, ct)
      if ct gt 0 then sort_flag_fulldata[index] = !values.f_nan

      sort_flag = {sort_flag: sort_flag_data, sort_flag_fulldata: sort_flag_fulldata}

      for iset = 0, n_elements(slice_grid_set) - 1 do begin
        coor_set = coor_set_set[*, iset]
        slice_grid = slice_grid_set[iset]
        range_input = input_range_set[*, iset]

        make_cloak_map_rbsp, data, header $
          , sort_flag = sort_flag, sort_title = sort_title $
          , ps_plot = ps_plot, plot_path = sort_path $
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
          , sample_size_threshold = sample_size_threshold, samples_v_range = samples_v_range, ratio_v_range = ratio_v_range $
          , plot_substorm_sea = plot_substorm_sea
      endfor
    endfor
  endif
end
