; ----------------------------------------------------------------
; Wrapper routines to use sort_cloak_map_rbsp
; ----------------------------------------------------------------
pro run_substorm_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , non_sort_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; , 'Tail'] ;,'BetaLE005','all','Dayside',] $
  , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
     , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , energy_set = [[0., 60000.], [30., 500.], [500,1000],[1000., 3000.]] $ ;[[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , substorm_phase_set = ['all', 'substorm_time', 'non_substorm_time'] $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_storm_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , non_sort_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; , 'Tail'] ;,'BetaLE005','all','Dayside',] $
  , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
     , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , energy_set = [[0., 60000.], [30., 500.], [500,1000],[1000., 3000.]] $ ;[[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , storm_phase_set = ['all', 'storm_time', 'nonstorm_time'] $ ;, 'prestorm', 'initial_phase', 'main_phase', 'recovery'] $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_kp_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , sort_kp_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; , 'Tail'] ;,'BetaLE005','all','Dayside',] $
  , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
     , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , energy_set = [[0., 60000.], [30., 500.], [500,1000],[1000., 3000.]] $ ;[[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_ae_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , sort_ae_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; , 'Tail'] ;,'BetaLE005','all','Dayside',] $
  , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
     , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , energy_set = [[0., 60000.], [30., 500.], [500,1000],[1000., 3000.]] $ ;[[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , storm_phase_set = ['all', 'storm_time', 'nonstorm_time'] $ ;['all', 'storm_time', 'nonstorm_time', 'prestorm', 'initial_phase', 'main_phase', 'recovery'] $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------

pro run_swV_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , non_sort_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; , 'Tail'] ;,'BetaLE005','all','Dayside',] $
  , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
     , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , energy_set = [[0., 60000.], [30., 500.], [500,1000],[1000., 3000.]] $ ;[[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , swv_set = [[0., 450.], [450., 900]] $
  , storm_phase_set = ['all'] $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_energy_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , non_sort_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; , 'Tail'] ;,'BetaLE005','all','Dayside',] $
  , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
     , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , energy_set = [[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
    , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_swP_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , non_sort_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
   , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , energy_set = [[0., 60000.], [30., 500.], [500,1000],[1000., 3000.]] $ ;[[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , swp_set = [[0., 2.], [2., 20]] $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_imfbybz_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , non_sort_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; ,'BetaLE005','all','Dayside',] $
   , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
        , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , energy_set = [[0., 60000.], [30., 500.], [500,1000],[1000., 3000.]] $ ;[[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , imfby_set = [[-25, 0], [0, 25]] $
  , imfbz_set = [[-25, 0], [0, 25]] $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_imfby_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , non_sort_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; ,'BetaLE005','all','Dayside',] $
   , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
        , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , energy_set = [[0., 60000.], [30., 500.], [500,1000],[1000., 3000.]] $ ;[[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , imfby_set = [[-25, 0], [0, 25]] $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_hemi_imfby_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , sort_hemi_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; ,'BetaLE005','all','Dayside',] $
   , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
        , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['X_GSM', 'Y_GSM', 'Z_GSM']] $
  , ps_plot = 1 $
  , energy_set = [[0., 60000.], [30., 500.], [500,1000],[1000., 3000.]] $ ;[[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , imfby_set = [[-25, 0], [0, 25]] $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_hemi_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , sort_hemi_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; ,'BetaLE005','all','Dayside',] $
   , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
     , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['X_GSM', 'Y_GSM', 'Z_GSM']] $
  , ps_plot = 1 $
  , energy_set = [[0., 60000.], [30., 500.], [500,1000],[1000., 3000.]] $ ;[[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_energy_mlt_sort_2d_cloak_sea_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , non_sort_map = 0 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; ,'BetaLE005','all','Dayside',] $
   , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
   , property_map_type_set = ['mean', 'median'] $ 
  ; , events_map = 0 $
  , sort_mlt_map  = 1 $
  , coor_set =  [['MLT', 'ILAT', 'L']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , energy_set = [[0., 60000.], [30., 500.], [500,1000],[1000., 3000.]] $ ;[[0., 60000.],[0, 30],[30, 100], [100, 300],[300., 500.], [30., 500.], [500,1000],[1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , plot_substorm_sea = 1 $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_non_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , non_sort_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; ,'BetaLE005','all','Dayside',] $
   , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
     , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 1 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_non_sort_2d_property_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , non_sort_map = 1 $
  , plot_2d = 1 $
  , direction_set = ['both'] $ ; ,'both'] ;['any', 'para','anti','both','both'] $
  , region_map_set = ['all'] $ ; ,'BetaLE005','all','Dayside',] $
  , property_map_set = ['dipolization','energy','flux','pitch_angle'] $
  , property_map_type_set = ['mean', 'median'] $ 
  , events_map = 0 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  ; , energy_set = [[0, 50],[0, 100],[0, 400],[30, 500], [10, 1000], [0., 30.], [30., 100.], [30., 500.], [500., 1000.], [1000., 3000.], [3000., 10000.],[10000., 60000.]] $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release, RATIO_V_RANGE = [0., 1]
end

; ----------------------------------------------------------------
pro run_non_sort_points_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  sort_cloak_map_rbsp, store_tplot = 1 $
  , time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat $
  , non_sort_map = 1 $
  , direction_set = ['both'] $
  , region_map_set = ['all'] $
  , point_plot = 1 $
  , coor_set = [['MLT', 'L', 'ILAT']] $ ; ['X_GSM', 'Y_GSM', 'Z_GSM'], ['X_GSM', 'Z_GSM', 'Y_GSM'], ['Y_GSM', 'Z_GSM', 'X_GSM'],
  , ps_plot = 1 $
  , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
end

; -------------------------------------------
; main programs
; -----------------------------------------
pro run_sort_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release

  if ~keyword_set(flux_threshold) then flux_threshold = [20, 20, 20]
  if ~keyword_set(def_pap_factor) then def_pap_factor = [3, 1.3, 1.3]
  if n_elements(isotropic_pa_def) eq 0 then isotropic_pa_def = [60, 120] ; [30,150],[45,135] [60, 120]
  if ~keyword_set(average_time) then average_time = 300
  if ~keyword_set(time_start) then time_start = '2013-01-01'
  if ~keyword_set(time_end) then time_end = '2019-10-06/23:59:59'
  if ~keyword_set(sample_size_threshold) then sample_size_threshold = 25
  if ~keyword_set(grid) then grid = 1
  if ~keyword_set(remove_isotropic) then remove_isotropic = 1
  if ~keyword_set(diff_pa) then diff_pa = 1
  if ~keyword_set(diff_en) then diff_en = 0
  if ~keyword_set(diff_time) then diff_time = 4
  if ~keyword_set(release) then release = 'rel05' ; 'rel04', 'rel05'

  if n_elements(sc) eq 0 then sc = 1 ; set the satallite number
  if n_elements(sp) eq 0 then sp = 0 ; set the species, 0: H+, 3: O+

  ; if n_elements(flux_threshold) eq 0 then flux_threshold = [20, 20, 20] ; [0,0,0] ;[0.1, 0.15, 0.2]
  if array_equal(flux_threshold, [0, 0, 0]) then flux_threshold_str = '' else flux_threshold_str = '_flux' + string(flux_threshold[0], format = '(i2.0)') + string(flux_threshold[1], format = '(i2.0)') + string(flux_threshold[2], format = '(i2.0)')
  print, flux_threshold
  ; if n_elements(def_pap_factor) eq 0 then def_pap_factor = [3, 1.3, 1.3] ; [1,1,1] ;[1.7, 1.4, 1.1] ;[3, 2.5, 2] [3,2.0,1.1]
  if array_equal(def_pap_factor, [1, 1, 1]) then def_pap_factor_str = '' else def_pap_factor_str = '_pap' + string(def_pap_factor[0], format = '(f3.1)') + string(def_pap_factor[1], format = '(f3.1)') + string(def_pap_factor[2], format = '(f3.1)')

  if array_equal(isotropic_pa_def, [90, 90]) then isotropic_pa_def_str = '' else isotropic_pa_def_str = '_isotropic' + string(isotropic_pa_def[0], format = '(i3.3)') + string(isotropic_pa_def[1], format = '(i3.3)')

  if ~keyword_set(time_start) then time_start = '2013-01-01/00:00:00'
  if ~keyword_set(time_end) then time_end = '2019-11-01'

  if ~keyword_set(average_time) then average_time = 5 * 60 ; in seconds
  if ~keyword_set(sample_size_threshold) then sample_size_threshold = 27

  ; run_non_sort_points_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en, diff_time = diff_time, release = release

  ; run_non_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en, diff_time = diff_time, release = release

  run_energy_mlt_sort_2d_cloak_sea_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en, diff_time = diff_time, release = release

  run_energy_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc = sc, sp = sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en, diff_time = diff_time, release = release

  run_ae_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid,sc=sc,sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  
  run_kp_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid,sc=sc,sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  
  run_swV_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid,sc=sc,sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en, diff_time = diff_time, release = release

  run_storm_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid,sc=sc,sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en, diff_time = diff_time, release = release  

  run_swP_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid,sc=sc,sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release

  run_substorm_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid,sc=sc,sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en, diff_time = diff_time, release = release  

  ; run_hemi_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc=sc, sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release

  ; run_hemi_imfby_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time, sample_size_threshold = sample_size_threshold, grid = grid, sc=sc, sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release

  ; run_imfby_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time ,sample_size_threshold = sample_size_threshold, grid = grid, sc=sc, sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release

 ; run_imfbybz_sort_2d_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time ,sample_size_threshold = sample_size_threshold, grid = grid, sc=sc, sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
  
  ; run_Beta_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time ,sample_size_threshold = sample_size_threshold, grid = grid, sc=sc, sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release

  ; -- only runs for property cloak_maps --
  ; run_non_sort_2d_property_cloak_map_rbsp, time_start = time_start, time_end = time_end, stop = stop, read_from_dat = read_from_dat , flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , average_time = average_time ,sample_size_threshold = sample_size_threshold, grid = grid, sc=sc, sp=sp, isotropic_pa_def = isotropic_pa_def, remove_isotropic = remove_isotropic, diff_pa = diff_pa, diff_en = diff_en,diff_time = diff_time, release = release
end