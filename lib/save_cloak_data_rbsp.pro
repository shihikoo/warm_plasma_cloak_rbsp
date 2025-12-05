; ---------------------------------------------------
; save external data
; ---------------------------------------------------
pro save_cloak_external_data_rbsp, date_s, data_path, all_tplot_names, t_s, t_e
  
  headers = ['Time' $
    , 'GSE_X', 'GSE_Y', 'GSE_Z' $
    , 'GSM_X', 'GSM_Y', 'GSM_Z' $
    , 'MLT', 'ILAT', 'DIST', 'L' $
    , 'Dst', 'AE', 'kp', 'F107' $
    , 'Bx_GSM', 'By_GSM', 'Bz_GSM' $
    , 'H_v', 'H_p', 'H_n' $
    , 'H_vx', 'H_vy', 'H_vz' $
    , 'H_vpar', 'H_vperp' $
    , 'O_v', 'O_p', 'O_n' $
    , 'O_vx', 'O_vy', 'O_vz' $
    , 'O_vpar', 'O_vperp' $
    , 'Beta', 'P_tot' $
    , 'Region' $

    , 'E_h', 'E_o' $
    , 'IMF_Bx', 'IMF_By', 'IMF_Bz' $
    , 'SW_v', 'SW_p', 'SW_n', 'SW_t', 'alfven_mack' $

    , 'IMF_Bx_1h', 'IMF_By_1h', 'IMF_Bz_1h' $
    , 'SW_v_1h', 'SW_p_1h', 'SW_n_1h', 'SW_t_1h', 'alfven_mack_1h' $

    , 'Storm_phase', 'Substorm_phase' $
    , 'Flag' $
    ]
 
    data_tplot_names_x = all_tplot_names.x_gse_name
    data_tplot_names_y = [all_tplot_names.x_gse_name, all_tplot_names.y_gse_name, all_tplot_names.z_gse_name $
      , all_tplot_names.x_gsm_name, all_tplot_names.y_gsm_name, all_tplot_names.z_gsm_name $
      , all_tplot_names.mlt_name, all_tplot_names.ilat_name, all_tplot_names.dist_name, all_tplot_names.l_name $
      , all_tplot_names.dst_name, all_tplot_names.ae_name, all_tplot_names.kp_name, all_tplot_names.f107_name $
      , all_tplot_names.bx_name, all_tplot_names.by_gsm_name, all_tplot_names.bz_gsm_name $
      , all_tplot_names.h1_velocity_t_name, all_tplot_names.h1_pressure_name, all_tplot_names.h1_density_name $
      , all_tplot_names.h1_velocity_x_name, all_tplot_names.h1_velocity_y_name, all_tplot_names.h1_velocity_z_name $
      , all_tplot_names.h1_velocity_par_name, all_tplot_names.h1_velocity_perp_name $
      , all_tplot_names.o1_velocity_t_name, all_tplot_names.o1_pressure_name, all_tplot_names.o1_density_name $
      , all_tplot_names.o1_velocity_x_name, all_tplot_names.o1_velocity_y_name, all_tplot_names.o1_velocity_z_name $
      , all_tplot_names.o1_velocity_par_name, all_tplot_names.o1_velocity_perp_name $
      , all_tplot_names.beta_name, all_tplot_names.p_total_name $
      , all_tplot_names.region_name $
  
      , all_tplot_names.electric_field_h_name, all_tplot_names.electric_field_o_name $
      , all_tplot_names.imf_bx_name, all_tplot_names.imf_by_gsm_name, all_tplot_names.imf_bz_gsm_name $
      , all_tplot_names.sw_v_name, all_tplot_names.sw_p_name, all_tplot_names.sw_n_name $
      , all_tplot_names.sw_t_name, all_tplot_names.sw_mack_number_name $
  
      , all_tplot_names.imf_bx_1H_name, all_tplot_names.imf_by_gsm_1H_name, all_tplot_names.imf_bz_gsm_1H_name $
      , all_tplot_names.sw_v_1H_name, all_tplot_names.sw_p_1H_name, all_tplot_names.sw_n_1H_name $
      , all_tplot_names.sw_t_1H_name, all_tplot_names.sw_mack_number_1H_name $

      , all_tplot_names.storm_phase_tplot_name, all_tplot_names.substorm_phase_tplot_name $
      ]


  data_x = r_data(data_tplot_names_x[0], /x)
  index_time = where(data_x ge t_s and data_x le t_e, ct)
  if ct eq 0 then return
  data_dd_x = data_x[index_time]
  n_avg = n_elements(data_dd_x)

  nterm = n_elements(data_tplot_names_y)
  data_dd_y = dblarr(nterm, n_avg)
  for ii = 0, nterm - 1 do data_dd_y[ii, *] = r_data_with_timetrim(data_tplot_names_y[ii], /y, ts = t_s, te = t_e, time = data_x)

  ; extract cloak flag from energy peak data
  energy = r_data_with_timetrim(all_tplot_names.epcut_cloak_name, /y, ts = t_s, te = t_e, time = data_x)
  flag = total(energy, 2, /nan) gt 0

  data_dd = [reform(data_dd_x, 1, n_avg) $
    , data_dd_y $
    , reform(flag, 1, n_avg) $
    ]

  ; save the data
  fln_dump = data_path + 'cloak_' + date_s + '_external.csv'
  write_csv, fln_dump, data_dd, header = headers
end

; ---------------------------------------------------
; save cloak data
; ---------------------------------------------------
pro save_cloak_cloak_data_rbsp, date_s,  data_path, all_tplot_names, t_s, t_e
  common SHARE1, ENERGY_BINS, DENERGY_BINS, PA_BINS, ERROR_MESSAGE

  headers = ['Time', 'En', 'Pa', 'Flux', 'Eflux', 'Int_flux', 'Pa_range' $ ; , 'n' , 'p', 't' $
    ]
    data_tplot_names_x = all_tplot_names.x_gse_name

    data_x = r_data(data_tplot_names_x[0], /x)
    index_time = where(data_x ge t_s and data_x le t_e, ct)
    if ct eq 0 then return
    data_dd_x = data_x[index_time]
    time_avg = data_dd_x
    n_avg = n_elements(data_dd_x)
  
    ; --- read in data ---
  
    ; pitch angle peak, flux
    get_data, all_tplot_names.pap_cloak_name, data = data
    flux = data.y[index_time, *, *]
    pa = data.v[index_time, *, *]
  
    ; eflux
    get_data, all_tplot_names.pa_eflux_name, data = data
    eflux = data.y[index_time, *, *]
    index = where(~finite(flux), ct)
    if ct gt 0 then eflux[index] = !values.f_nan
  
    ; integrated flux
    get_data, all_tplot_names.int_diffflux_ion_name, data = data
    int_flux = data.y[index_time, *, *]
  
    ; pitch angle range
    get_data, all_tplot_names.pap_range_name, data = data
    pap_range = data.y[index_time, *, *]
  
    ; density
    ; get_data, all_tplot_names.density_name, data = data
    ; density = data.y[index_time, *, *]
  
    ; velocity
    ; get_data, all_tplot_names.velocity_name, data = data
    ; velocity = data.y[index_time,*,*]
  
    ; pressure
    ; get_data, all_tplot_names.pressure_name, data = data
    ; pressure = data.y[index_time, *, *]
  
    ; temperature
    ; get_data, all_tplot_names.temperature_name, data = data
    ; temperature = data.y[index_time, *, *]
  
    ; --- flat the flux, and eflux data with energy ---
    nen = n_elements(ENERGY_BINS)
    npa = n_elements(pa[0, *])
    n_total = n_avg * npa * nen
  
    time_avg = reform(cmreplicate(data_dd_x, [npa * nen]), [n_total])
  
    en_flat = []
    for k = 0, nen - 1 do en_flat = [en_flat, replicate(ENERGY_BINS[k], n_avg * npa)]
  
    ; reform  data
    flux_flat = reform(flux, [n_total])
    pa_flat = reform(pa, [n_total])
  
    eflux_flat = reform(eflux, [n_total])
  
    int_flux_flat = reform(int_flux, [n_total])
  
    range_flat = reform(pap_range, [n_total])
  
    ; density_flat = reform(density, [n_total])
    ; velocity_flat = REFORM(velocity,[n_total])
    ; pressure_flat = reform(pressure, [n_total])
    ; temperature_flat = reform(temperature, [n_total])
  
    ; comebine all data
    data_dd_temp = [reform(time_avg, 1, n_total), reform(en_flat, 1, n_total) $
      , reform(pa_flat, 1, n_total), reform(flux_flat, 1, n_total) $
      , reform(eflux_flat, 1, n_total), reform(int_flux_flat, 1, n_total), reform(range_flat, 1, n_total) $
      ; , reform(density_flat, 1, n_total) $
      ; , REFORM(velocity_flat,1,n_total)
      ; , reform(pressure_flat, 1, n_total), reform(temperature_flat, 1, n_total) $
      ]
  
    ; index = WHERE(TOTAL(data_dd_temp[2:(N_ELEMENTS(data_dd_temp[*,0])-1),*],1,/NAN) NE 0, ct)
    index = where(total(data_dd_temp[4, *], 1, /nan) ne 0 or total(data_dd_temp[5, *], 1, /nan) ne 0, ct)
    if ct gt 0 then begin
      data_dd = reform(data_dd_temp[*, index], n_elements(headers), ct)
  
      ; save the data
      fln_dump = data_path + 'cloak_' + date_s + '_cloak.csv'
      write_csv, fln_dump, data_dd, header = headers
    endif
    
  end

; --------------------------
; save all data
; ----------------------
pro save_cloak_data_rbsp, date_s, data_path, all_tplot_names, t_s, t_e
  save_cloak_external_data_rbsp, date_s,  data_path, all_tplot_names, t_s, t_e
  
  save_cloak_cloak_data_rbsp, date_s,  data_path, all_tplot_names, t_s, t_e

end