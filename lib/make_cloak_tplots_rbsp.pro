; ----------------------------------------
; set up tplot options
; ------------------------------------------
pro setup_tplot_options, all_tplot_names, sp_str
  if sp_str eq '0' then sp_title = 'H'
  if sp_str eq '3' then sp_title = 'O'

  options, '*', 'panel_size', 1
  options, '*', 'zticks', 3
  options, [all_tplot_names.pa_name, all_tplot_names.pap_name, all_tplot_names.pap_beam_name], 'ztitle', ''

  ylim, all_tplot_names.p_total_name, 0.01, 3, 1
  ylim, all_tplot_names.beta_name, 0.01, 10, 1
  ylim, [all_tplot_names.diffflux_o1_name, all_tplot_names.diffflux_h1_name, all_tplot_names.diffflux_ion_name], 1., 5.e4, 1

  zlim, [all_tplot_names.diffflux_o1_name, all_tplot_names.diffflux_o1_pa_name], 10., 1.e4, 1
  zlim, [all_tplot_names.diffflux_h1_name, all_tplot_names.diffflux_h1_pa_name], 10., 1.e4, 1
  ; zlim, [all_tplot_names.diffflux_ion_name, all_tplot_names.diffflux_pa_name], 1, 10000, 1

  zlim, [all_tplot_names.pa_eflux_name], 1e3, 1e6, 1
  zlim, [all_tplot_names.diffflux_ion_name], 10., 1.e4, 1

  ylim, [all_tplot_names.electric_field_o_name, all_tplot_names.electric_field_h_name], 0, 10, 0
  ylim, all_tplot_names.h1_density_name, 0.001, 10, 1
  ylim, all_tplot_names.region_name, 0.1, 100, 1
  ylim, [all_tplot_names.diffflux_ion_high_energy_pa_name, all_tplot_names.diffflux_ion_cloak_energy_pa_name, all_tplot_names.diffflux_ion_low_energy_pa_name], 0, 180, 0

  options, all_tplot_names.dst_name, 'ytitle', 'Dst'
  
  options, all_tplot_names.diffflux_ion_high_energy_pa_name, 'ztitle', ''
  ; options, all_tplot_names.diffflux_ion_cloak_energy_pa_name, 'ztitle',''
  options, all_tplot_names.diffflux_ion_low_energy_pa_name, 'ztitle', ''

  options, all_tplot_names.diffflux_ion_high_energy_pa_name, 'ytitle', sp_title + '!U+!N(PA)!C1Kev - 50KeV'
  options, all_tplot_names.diffflux_ion_cloak_energy_pa_name, 'ytitle', sp_title + '!U+!N(PA)!C10eV - 1KeV'
  options, all_tplot_names.diffflux_ion_low_energy_pa_name, 'ytitle', sp_title + '!U+!N(PA)!C <10eV'

  options, all_tplot_names.region_name, 'ytitle', 'Region'
  options, all_tplot_names.beta_name, 'ytitle', '!C!Cbeta'
  options, all_tplot_names.diffflux_h1_name, 'ytitle', 'H!U+!N (eV)'

  options, all_tplot_names.pap_beam_combine_name, 'ytitle', ' O!U+!CPitch Angle!CBeam'

  options, all_tplot_names.pa_name, 'ytitle', 'PA!CEN peak'
  options, 'ytitle', 'PA!CEN peak'
  options, all_tplot_names.pap_name, 'ytitle', 'PA!CPeak'
  options, all_tplot_names.pap_beam_name, 'ytitle', 'PA!CBeam'

  options, all_tplot_names.h1_velocity_name, 'ytitle', 'V(!UH+!N)!CGSM'
  options, all_tplot_names.o1_velocity_name, 'ytitle', 'V(!UO+!N)!CGSM'
  options, all_tplot_names.mag_name, 'ytitle', 'B!C(nT)'
  options, all_tplot_names.bx_name, 'ytitle', 'Bx!C(nT)'
  options, all_tplot_names.o1_velocity_par_name, 'ytitle', 'O!U+!CVpar(km/s)'
  options, all_tplot_names.o1_velocity_perp_name, 'ytitle', 'O!U+!CVperp(km/s)'
  options, all_tplot_names.h1_velocity_par_name, 'ytitle', 'H!U+!CVpar'
  options, all_tplot_names.h1_velocity_perp_name, 'ytitle', 'H!U+!CVperp'

  options, all_tplot_names.electric_field_h_name, 'ytitle', 'E (mV/m)!CH!U+'
  options, all_tplot_names.electric_field_o_name, 'ytitle', 'E (mV/m)!CO!U+'
  options, all_tplot_names.density_ratio_name, 'ytitle', 'nO!U+!N/nH!U+'

  options, all_tplot_names.sw_p_name, 'ytitle', 'SW!Cpdyn!C(nPa)'
  options, all_tplot_names.imf_bz_gsm_name, 'ytitle', 'IMF Bz!C(nT)'

  options, all_tplot_names.diffflux_h1_pa_name, 'ytitle', 'H!U+!N(PA)'
  options, all_tplot_names.diffflux_h1_name, 'ytitle', 'H!U+!N(eV)'
  options, all_tplot_names.diffflux_o1_name, 'ytitle', 'O!U+!N(eV)'
  options, all_tplot_names.diffflux_o1_pa_name, 'ytitle', 'O!U+!N(PA)'

  options, [all_tplot_names.o1_density_name, all_tplot_names.electric_field_o_name], 'color', 2
  options, [all_tplot_names.epcut_name, all_tplot_names.epcut_beam_name], 'color', 0

  options, [all_tplot_names.bx_name, all_tplot_names.sw_p_name, all_tplot_names.imf_bz_gsm_name, all_tplot_names.electric_field_h_name, all_tplot_names.density_ratio_name], 'yticks', 2
end

pro make_cloak_tplots_rbsp, sc_str, sp_str, t_s, t_e, t_dt, plot_path, all_tplot_names, displaytime = displaytime, ps = ps, idl_plot = idl_plot, to_plot = to_plot
  common SHARE1, ENERGY_BINS, DENERGY_BINS, PA_BINS, ERROR_MESSAGE

  to_plot = ['day_figure','procedure4'];, 'identification', 'procedure4'] ; , 'procedure4'] ; , 'day_figure', 'identification', 'procedure2', 'procedure3','procedure1', 'plasma_condition','moments']

  setup_tplot_options, all_tplot_names, sp_str

  ; get_rbsp_hope_ephem, sc_str
  
  ; var_label = 'RBSP'+sc_str+'_EPH_'
  ; var_label = var_label + ['MLT','L']
  ; tplot, var_label=var_label

  var_label_origin = [all_tplot_names.ilat_name, all_tplot_names.l_name, all_tplot_names.mlt_name]
  var_label = 'RBSP' + sc_str + '_EPH_'
  var_label = var_label + ['ILAT', 'L', 'MLT']

  for ivar_label = 0, n_elements(var_label_origin) - 1 do begin
    get_data, var_label_origin[ivar_label], data = data, dlim = dlim, lim = lim
    store_data, var_label[ivar_label], data = data, dlim = dlim, lim = lim
  endfor

  if ~keyword_set(displaytime) then displaytime = t_dt

  if ~keyword_set(idl_plot) and ~keyword_set(ps) then RETURN

  ps_folder = plot_path + 'cloak_day/'
  spawn, 'mkdir -p ' + ps_folder

  identification_folder = ps_folder + 'identification/'
  spawn, 'mkdir -p ' + identification_folder

  procedure1_ps_folder = ps_folder + 'procedure1/'
  spawn, 'mkdir -p ' + procedure1_ps_folder

  procedure2_ps_folder = ps_folder + 'procedure2/'
  spawn, 'mkdir -p ' + procedure2_ps_folder

  procedure3_ps_folder = ps_folder + 'procedure3/'
  spawn, 'mkdir -p ' + procedure3_ps_folder

  procedure4_ps_folder = ps_folder + 'procedure4/'
  spawn, 'mkdir -p ' + procedure4_ps_folder

  dayfigure_ps_folder = ps_folder + 'day_figure/'
  spawn, 'mkdir -p ' + dayfigure_ps_folder

  moments_folder = ps_folder + 'moments/'
  spawn, 'mkdir -p ' + moments_folder

  other_folder = ps_folder + 'others/'
  spawn, 'mkdir -p ' + other_folder

  A = findgen(16) * (!pi * 2 / 16.)
  user_sym_size = 0.2
  usersym, user_sym_size * cos(A), user_sym_size * sin(A), /fill

  ; --------------------------------------------------------------------------
  ; making tplots
  ; -----------------------------------------------------------------

  ; ----------- plasma_condition result plot -----------
  index = where(to_plot eq 'plasma_condition', ct)
  if ct gt 0 then begin
    for idisplay = 0, ceil(t_dt / displaytime) - 1 do begin
      ts_plot = time_string(t_s + idisplay * displaytime)
      te_plot = time_string(t_s + (idisplay + 1) * displaytime)
      date_s_plot = strmid(ts_plot, 0, 4) + strmid(ts_plot, 5, 2) + strmid(ts_plot, 8, 2)
      time_s_plot = strmid(ts_plot, 11, 2) + strmid(ts_plot, 14, 2) + strmid(ts_plot, 17, 2)
      date_e_plot = strmid(te_plot, 0, 4) + strmid(te_plot, 5, 2) + strmid(te_plot, 8, 2)
      time_e_plot = strmid(te_plot, 11, 2) + strmid(te_plot, 14, 2) + strmid(te_plot, 17, 2)

      timespan, t_s + idisplay * displaytime, displaytime, /seconds

      if keyword_set(ps) then begin
        fln = other_folder + 'cloak' + date_s_plot + '_' + time_s_plot + '_to_' + date_e_plot + '_' + time_e_plot + '_plasma_condition.ps'
        popen, fln, /port
      endif

      tplot, [ $
        ; all_tplot_names.bx_name $
        all_tplot_names.mag_name $
        , all_tplot_names.sw_p_name, all_tplot_names.imf_bz_gsm_name $
        , all_tplot_names.diffflux_h1_name, all_tplot_names.diffflux_h1_pa_name $
        , all_tplot_names.diffflux_o1_name, all_tplot_names.diffflux_o1_pa_name $
        , all_tplot_names.h1_density_name, all_tplot_names.h1_velocity_name $
        , all_tplot_names.electric_field_h_name, all_tplot_names.density_ratio_name $
        ], var_label = var_label

      tplot_panel, v = all_tplot_names.h1_density_name, o = all_tplot_names.o1_density_name
      tplot_panel, v = all_tplot_names.h1_velocity_name, o = all_tplot_names.o1_velocity_name

      yline, all_tplot_names.density_ratio_name, offset = 1, col = 2

      if keyword_set(ps) then begin
        pclose
        spawn, 'mogrify -format png -alpha opaque -density 150 ' + fln
        spawn, 'rm -f ' + fln
      endif else stop
    endfor
  endif

  ; ----------- day figure of the paper -----------
  index = where(to_plot eq 'day_figure', ct)
  if ct gt 0 then begin
    ; t_s = time_double('2013-10-15/04:00')
    ; t_e = time_double('2013-10-15/22:00')
    timespan, t_s, t_e - t_s, /s

    if keyword_set(ps) then begin
      ts_plot = time_string(t_s)
      te_plot = time_string(t_e)

      date_s = extract_date_string(ts_plot)
      time_s = extract_time_string(ts_plot)
      date_e = extract_date_string(te_plot)
      time_e = extract_time_string(te_plot)

      fln = dayfigure_ps_folder + 'cloak' + date_s + '_' + time_s + '_to_' + date_e + '_' + time_e + '_day_figure.ps'
      popen, fln, /land
    endif
    zlim, [all_tplot_names.diffflux_h1_name $
      , all_tplot_names.diffflux_ion_high_energy_pa_name $
      , all_tplot_names.diffflux_ion_cloak_energy_pa_name $
      ; , all_tplot_names.diffflux_ion_low_energy_pa_name $
      , all_tplot_names.diffflux_o1_name $
      , all_tplot_names.diffflux_o1_pa_name $
      ], 1., 1.e4, 1
    tplot, [all_tplot_names.diffflux_h1_name $
      , all_tplot_names.diffflux_ion_high_energy_pa_name $
      , all_tplot_names.diffflux_ion_cloak_energy_pa_name $
      ; , all_tplot_names.diffflux_ion_low_energy_pa_name $
      , all_tplot_names.diffflux_o1_name $
      , all_tplot_names.diffflux_o1_pa_name $
      , all_tplot_names.dst_name $
      , all_tplot_names.ae_name $
      ], var_label = var_label
    ; tplot_panel, v = all_tplot_names.h1_density_name, o = all_tplot_names.o1_density_name

    if keyword_set(ps) then begin
      pclose
      spawn, 'mogrify -rotate -90 ' + fln
      spawn, 'mogrify -format png -alpha opaque -density 150 ' + fln
      ; spawn, 'rm -f ' + fln
    endif else stop
  endif

  ; ----------- identification result plot -----------
  index = where(to_plot eq 'identification', ct)
  if ct gt 0 then begin
    displaytime_identification = 24. * 3600
    displaytime_input = displaytime
    displaytime = displaytime_identification
    for idisplay = 0, ceil(t_dt / displaytime) - 1 do begin
      timespan, t_s + idisplay * displaytime, displaytime, /seconds

      if keyword_set(ps) then begin
        ts_plot = time_string(t_s + idisplay * displaytime)
        te_plot = time_string(t_s + (idisplay + 1) * displaytime)

        date_s = extract_date_string(ts_plot)
        time_s = extract_time_string(ts_plot)
        date_e = extract_date_string(te_plot)
        time_e = extract_time_string(te_plot)

        fln = identification_folder + 'cloak' + date_s + '_' + time_s + '_to_' + date_e + '_' + time_e + '_identification.ps'
        popen, fln, /land
      endif

      zlim, [all_tplot_names.diffflux_ion_name $
        , all_tplot_names.diffflux_ion_high_energy_pa_name $
        , all_tplot_names.diffflux_ion_cloak_energy_pa_name $
        , all_tplot_names.diffflux_ion_low_energy_pa_name $
        ], 10., 1.e4, 1
      tplot, [ $
        ; all_tplot_names.region_name $
        all_tplot_names.diffflux_ion_name $
        , all_tplot_names.diffflux_ion_high_energy_pa_name $
        , all_tplot_names.diffflux_ion_cloak_energy_pa_name $
        , all_tplot_names.diffflux_ion_low_energy_pa_name $
        ; , all_tplot_names.diffflux_o1_name, all_tplot_names.diffflux_o1_pa_name $
        ; , all_tplot_names.h1_density_name $
        , all_tplot_names.dst_name $
        , all_tplot_names.ae_name $
        ], var_label = var_label

      ; tplot_panel, v = all_tplot_names.h1_density_name, o = all_tplot_names.o1_density_name

      tplot_panel, v = all_tplot_names.diffflux_ion_name, o = all_tplot_names.epcut_cloak_name, psym = 8

      yline, all_tplot_names.diffflux_h1_name, offset = 3
      yline, all_tplot_names.diffflux_h1_name, offset = 3000

      if keyword_set(ps) then begin
        pclose
        spawn, 'mogrify -rotate -90 ' + fln
        spawn, 'mogrify -format png -alpha opaque -density 150 ' + fln
        spawn, 'rm -f ' + fln
      endif else stop
    endfor
    displaytime = displaytime_input
  endif

  ; ----------- identification procedure 1 -----------
  index = where(to_plot eq 'procedure1', ct)
  if ct gt 0 then begin
    for idisplay = 0, ceil(t_dt / displaytime) - 1 do begin
      timespan, t_s + idisplay * displaytime, displaytime, /seconds

      if keyword_set(ps) then begin
        ts_plot = time_string(t_s + idisplay * displaytime)
        te_plot = time_string(t_s + (idisplay + 1) * displaytime)

        date_s = extract_date_string(ts_plot)
        time_s = extract_time_string(ts_plot)
        date_e = extract_date_string(te_plot)
        time_e = extract_time_string(te_plot)

        fln = procedure1_ps_folder + 'cloak' + date_s + '_' + time_s + '_to_' + date_e + '_' + time_e + '_' + 'procedure1.ps'
        popen, fln, /port
      endif
      zlim, all_tplot_names.eflux_ion_name, 100., 1.e6, 1
      tplot, [all_tplot_names.diffflux_ion_name + '_Original', all_tplot_names.eflux_ion_name, all_tplot_names.diffflux_ion_name $
        ], var_label = var_label

      if keyword_set(ps) then begin
        pclose
        spawn, 'mogrify -format png -alpha opaque -density 150 ' + fln
        spawn, 'rm -f ' + fln
      endif else stop
    endfor
  endif

  ; ----------- identification pitch angle distriburtion procedure -----------
  index = where(to_plot eq 'procedure2', ct)
  if ct gt 0 then begin
    ; --- seperate pitch angle data and pitch angle peak into different energy pitch angle, so they can be plotted ---
    nenergybins = n_elements(ENERGY_BINS)

    get_data, all_tplot_names.pa_name, data = data_pa, dlim = dlim, lim = lim
    get_data, all_tplot_names.pap_name, data = data_pap, dlim = dlim, lim = lim
    for k = 0, nenergybins - 1 do begin
      data_pap_y = reform((data_pap.y[*, *, k] gt 0) * data_pap.v[*, *, k])
      index = where(data_pap_y eq 0, ct)
      if ct gt 0 then data_pap_y[index] = !values.f_nan
      store_data, all_tplot_names.pap_name + '_' + string(k, format = '(i2.2)'), data = {x: data_pap.x, y: data_pap_y}, dlim = dlim, lim = lim

      store_data, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), data = {x: data_pa.x, y: reform(data_pa.y[*, *, k]), v: reform(data_pa.v[*, *, k])}, dlim = dlim, lim = lim

      options, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), 'ytitle', string(ENERGY_BINS[k] + ' eV', format = '(i5.1)')
      zlim, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), 1., 1.e4, 1
      ylim, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), 0, 180, 0
      options, all_tplot_names.pap_name + '_' + string(k, format = '(i2.2)'), 'color', 0
    endfor
    stop
    ; --- plot tplots for different time frames ---
    for idisplay = 0, ceil(t_dt / displaytime) - 1 do begin
      its = t_s + idisplay * displaytime
      ite = its + displaytime
      idt = displaytime
      timespan, its, idt, /seconds

      tplot_names, all_tplot_names.pa_name + '_??', names = names
      n_tplot = n_elements(names)
      n_panel_per_page = 9
      for igraph = 0, ceil(1.0*n_tplot / n_panel_per_page) - 1 do begin
        if keyword_set(ps) then begin
          ts_plot = time_string(its)
          te_plot = time_string(ite)
          date_s = extract_date_string(ts_plot)
          time_s = extract_time_string(ts_plot)
          date_e = extract_date_string(te_plot)
          time_e = extract_time_string(te_plot)

          fln = procedure2_ps_folder + 'cloak' + date_s + '_' + time_s + '_to_' + date_e + '_' + time_e + '_procedure2_' + string(igraph, format = '(i2.2)') + '.ps'
          popen, fln, /port
        endif

        ; --- plot data ----
        tplot_names, all_tplot_names.pa_name + '_??', names = names
        names = names[igraph * n_panel_per_page : ((igraph + 1) * n_panel_per_page - 1) < n_tplot]
        tplot, [all_tplot_names.diffflux_ion_name, names], var_label = var_label

        tplot_panel, v = all_tplot_names.diffflux_ion_name, o = all_tplot_names.epcut_name, psym = 3
        yline, all_tplot_names.diffflux_ion_name, offset = ENERGY_BINS[igraph * n_panel_per_page], col = 2
        yline, all_tplot_names.diffflux_ion_name, offset = ENERGY_BINS[((igraph + 1) * n_panel_per_page - 1) < n_tplot], col = 1

        for k = 0, nenergybins - 1 do tplot_panel, v = all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), o = all_tplot_names.pap_name + '_' + string(k, format = '(i2.2)'), psym = 7

        if keyword_set(ps) then begin
          pclose
          spawn, 'mogrify -format png -alpha opaque -density 150 ' + fln
          spawn, 'rm -f ' + fln
        endif else stop
      endfor
    endfor

    tplot_names, all_tplot_names.pa_name + '_??', names = names
    store_data, delete = names
    tplot_names, all_tplot_names.pap_name + '_??', names = names
    store_data, delete = names
  endif

  ; ----------- identification pitch angle distriburtion procedure 3 -----------
  index = where(to_plot eq 'procedure3', ct)
  if ct gt 0 then begin
    ; --- seperate pitch angle data and bidirectional pitch angle peak into different energy pitch angle, so they can be plotted ---
    nenergybins = n_elements(ENERGY_BINS)

    get_data, all_tplot_names.pa_name, data = data_pa, dlim = dlim, lim = lim
    get_data, all_tplot_names.pap_bidirection_name, data = data_pap_bidirection, dlim = dlim, lim = lim
    for k = 0, nenergybins - 1 do begin
      data_pap_bidirection_y = reform((data_pap_bidirection.y[*, *, k] gt 0) * data_pap_bidirection.v[*, *, k])
      index = where(data_pap_bidirection_y eq 0, ct)
      if ct gt 0 then data_pap_bidirection_y[index] = !values.f_nan

      store_data, all_tplot_names.pap_bidirection_name + '_' + string(k, format = '(i2.2)'), data = {x: data_pap_bidirection.x, y: data_pap_bidirection_y}, dlim = dlim, lim = lim
      store_data, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), data = {x: data_pa.x, y: reform(data_pa.y[*, *, k]), v: reform(data_pa.v[*, *, k])}, dlim = dlim, lim = lim

      options, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), 'ytitle', string(ENERGY_BINS[k] + ' eV', format = '(i5.1)')
      zlim, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), 1., 1.e4, 1
      ylim, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), 0, 180, 0
      options, all_tplot_names.pap_bidirection_name + '_' + string(k, format = '(i2.2)'), 'color', 0
    endfor

    ; --- plot tplots for different time frames ---
    for idisplay = 0, ceil(t_dt / displaytime) - 1 do begin
      its = t_s + idisplay * displaytime
      ite = its + displaytime
      idt = displaytime
      timespan, its, idt, /seconds

      tplot_names, all_tplot_names.pa_name + '_??', names = names
      n_tplot = n_elements(names)
      n_panel_per_page = 9
      for igraph = 0, ceil(1.0*n_tplot / n_panel_per_page) - 1 do begin
        if keyword_set(ps) then begin
          ts_plot = time_string(its)
          te_plot = time_string(ite)
          date_s = extract_date_string(ts_plot)
          time_s = extract_time_string(ts_plot)
          date_e = extract_date_string(te_plot)
          time_e = extract_time_string(te_plot)

          fln = procedure3_ps_folder + 'cloak' + date_s + '_' + time_s + '_to_' + date_e + '_' + time_e + '_procedure3_' + string(igraph, format = '(i2.2)') + '.ps'
          popen, fln, /port
        endif

        ; --- plot data ----
        tplot_names, all_tplot_names.pa_name + '_??', names = names
        names = names[igraph * n_panel_per_page : ((igraph + 1) * n_panel_per_page - 1) < n_tplot]
        tplot, [all_tplot_names.diffflux_ion_name, names], var_label = var_label

        tplot_panel, v = all_tplot_names.diffflux_ion_name, o = all_tplot_names.epcut_bidirection_name, psym = 3
        yline, all_tplot_names.diffflux_ion_name, offset = ENERGY_BINS[igraph * n_panel_per_page], col = 2
        yline, all_tplot_names.diffflux_ion_name, offset = ENERGY_BINS[((igraph + 1) * n_panel_per_page - 1) < n_tplot], col = 1
        for k = 0, nenergybins - 1 do tplot_panel, v = all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), o = all_tplot_names.pap_bidirection_name + '_' + string(k, format = '(i2.2)'), psym = 7

        if keyword_set(ps) then begin
          pclose
          spawn, 'mogrify -format png -alpha opaque -density 150 ' + fln
          spawn, 'rm -f ' + fln
        endif else stop
      endfor
    endfor

    tplot_names, all_tplot_names.pa_name + '_??', names = names
    store_data, delete = names
    tplot_names, all_tplot_names.pap_bidirection_name + '_??', names = names
    store_data, delete = names
  endif

  ; ----------- identification pitch angle distriburtion procedure 3 -----------
  index = where(to_plot eq 'procedure4', ct)
  if ct gt 0 then begin
    ; --- seperate pitch angle data and cloak into different energy pitch angle, so they can be plotted ---
    nenergybins = n_elements(ENERGY_BINS)

    get_data, all_tplot_names.pa_name, data = data_pa, dlim = dlim, lim = lim
    get_data, all_tplot_names.pap_cloak_name, data = data_pap_cloak, dlim = dlim, lim = lim
    for k = 0, nenergybins - 1 do begin
      data_pap_cloak_y = reform((data_pap_cloak.y[*, *, k] gt 0) * data_pap_cloak.v[*, *, k])
      index = where(data_pap_cloak_y eq 0, ct)
      if ct gt 0 then data_pap_cloak_y[index] = !values.f_nan

      ; index = where(data_pap_cloak_y gt 0, ct)
      ; if ct gt 0 then begin
      store_data, all_tplot_names.pap_cloak_name + '_' + string(k, format = '(i2.2)'), data = {x: data_pap_cloak.x, y: data_pap_cloak_y}, dlim = dlim, lim = lim

      store_data, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), data = {x: data_pa.x, y: reform(data_pa.y[*, *, k]), v: reform(data_pa.v[*, *, k])}, dlim = dlim, lim = lim

      options, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), 'ytitle', string(ENERGY_BINS[k] + ' eV', format = '(i5.1)')
      zlim, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), 10., 1.e4, 1
      ylim, all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), 0, 180, 0
      options, all_tplot_names.pap_cloak_name + '_' + string(k, format = '(i2.2)'), 'color', 0
      options, all_tplot_names.pap_cloak_name + '_' + string(k, format = '(i2.2)'), 'ztitle', ''

      ; endif
    endfor

    ; --- plot tplots for different time frames ---
    for idisplay = 0, ceil(t_dt / displaytime) - 1 do begin
      its = t_s + idisplay * displaytime
      ite = its + displaytime
      idt = displaytime
      timespan, its, idt, /seconds

      tplot_names, all_tplot_names.pa_name + '_??', names = names
      n_tplot = n_elements(names)
      n_panel_per_page = 9
      for igraph = 0, ceil(1.0*n_tplot / n_panel_per_page) - 1 do begin
        if keyword_set(ps) then begin
          ts_plot = time_string(its)
          te_plot = time_string(ite)
          date_s = extract_date_string(ts_plot)
          time_s = extract_time_string(ts_plot)
          date_e = extract_date_string(te_plot)
          time_e = extract_time_string(te_plot)

          fln = procedure4_ps_folder + 'cloak' + date_s + '_' + time_s + '_to_' + date_e + '_' + time_e + '_procedure4_' + string(igraph, format = '(i2.2)') + '.ps'
          popen, fln, /port
        endif

        ; --- plot data ----
        tplot_names, all_tplot_names.pa_name + '_??', names = names
        names = names[igraph * n_panel_per_page : ((igraph + 1) * n_panel_per_page - 1) < n_tplot]
        ; zlim, [names], 10, 1000,1
        tplot, [all_tplot_names.diffflux_ion_name, names], var_label = var_label

        tplot_panel, v = all_tplot_names.diffflux_ion_name, o = all_tplot_names.epcut_cloak_name, psym = 8
        yline, all_tplot_names.diffflux_ion_name, offset = ENERGY_BINS[igraph * n_panel_per_page], col = 1
        yline, all_tplot_names.diffflux_ion_name, offset = ENERGY_BINS[((igraph + 1) * n_panel_per_page - 1) < n_tplot], col = 1

        for k = 0, nenergybins - 1 do tplot_panel, v = all_tplot_names.pa_name + '_' + string(k, format = '(i2.2)'), o = all_tplot_names.pap_cloak_name + '_' + string(k, format = '(i2.2)'), psym = 7

        if keyword_set(ps) then begin
          pclose
          spawn, 'mogrify -format png -alpha opaque -density 150 ' + fln
          spawn, 'rm -f ' + fln
        endif else stop
      endfor
      
      ; -- this part of commented out code make the above plots without identification on -- 
      ; for igraph = 0, n_tplot / n_panel_per_page - 1 do begin
      ;   if keyword_set(ps) then begin
      ;     ts_plot = time_string(its)
      ;     te_plot = time_string(ite)
      ;     date_s = extract_date_string(ts_plot)
      ;     time_s = extract_time_string(ts_plot)
      ;     date_e = extract_date_string(te_plot)
      ;     time_e = extract_time_string(te_plot)

      ;     fln = procedure4_ps_folder + 'cloak' + date_s + '_' + time_s + '_to_' + date_e + '_' + time_e + '_procedure4_clean_' + string(igraph, format = '(i2.2)') + '.ps'
      ;     popen, fln, /port
      ;   endif

      ;   ; --- plot data ----
      ;   tplot_names, all_tplot_names.pa_name + '_??', names = names
      ;   names = names[igraph * n_panel_per_page : ((igraph + 1) * n_panel_per_page - 1) < n_tplot]
      ;   tplot, [all_tplot_names.diffflux_ion_name, names], var_label = var_label

      ;   ; tplot_panel, v = all_tplot_names.diffflux_ion_name, o = all_tplot_names.epcut_cloak_name, psym = 8
      ;   yline, all_tplot_names.diffflux_ion_name, offset = ENERGY_BINS[igraph * n_panel_per_page], col = 1
      ;   yline, all_tplot_names.diffflux_ion_name, offset = ENERGY_BINS[((igraph + 1) * n_panel_per_page - 1) < n_tplot], col = 1

      ;   if keyword_set(ps) then begin
      ;     pclose
      ;     spawn, 'mogrify -format png -alpha opaque -density 150 ' + fln
      ;     spawn, 'rm -f ' + fln
      ;   endif else stop
      ; endfor

    endfor

    tplot_names, all_tplot_names.pa_name + '_??', names = names
    store_data, delete = names
    tplot_names, all_tplot_names.pap_cloak_name + '_??', names = names
    store_data, delete = names
  endif

  ; -----------  moments plot -----------
  index = where(to_plot eq 'moments', ct)
  if ct gt 0 then begin
    ; --- seperate pitch angle data and pitch angle peak beam into
    ; different energy pitch angle, so they can be plotted ---
    nenergybins = n_elements(ENERGY_BINS)
    ; --- FOR all pa plots (before peak and beam filter)
    get_data, all_tplot_names.density_name, data = data, dlim = dlim, lim = lim
    for k = 0, nenergybins - 1 do begin
      store_data, all_tplot_names.density_name + '_' + string(k, format = '(i2.2)'), data = {x: data.x, y: reform(data.y[*, *, k])}, dlim = dlim, lim = lim
      options, all_tplot_names.density_name + '_' + string(k, format = '(i2.2)'), 'ytitle', string(ENERGY_BINS[k] + ' eV', format = '(i5.1)')
      options, all_tplot_names.density_name + '_' + string(k, format = '(i2.2)'), 'psym', 1
      ylim, all_tplot_names.density_name + '_' + string(k, format = '(i2.2)'), 0.001, 1, 1
    endfor

    ; --- plot tplots for different time frames ---
    for idisplay = 0, ceil(t_dt / displaytime) - 1 do begin
      its = t_s + idisplay * displaytime
      ite = its + displaytime
      idt = displaytime
      timespan, its, idt, /seconds

      if keyword_set(ps) then begin
        ts_plot = time_string(its)
        te_plot = time_string(ite)
        date_s = extract_date_string(ts_plot)
        time_s = extract_time_string(ts_plot)
        date_e = extract_date_string(te_plot)
        time_e = extract_time_string(te_plot)

        fln = moments_folder + 'cloak' + date_s + '_' + time_s + '_to_' + date_e + '_' + time_e + '_moments.ps'
        popen, fln, /port
      endif

      ; --- plot data ----
      tplot_names, all_tplot_names.density_name + '_??', names = names
      tplot, [all_tplot_names.diffflux_ion_name, names], var_label = var_label

      if keyword_set(ps) then begin
        pclose
        spawn, 'mogrify -format png -alpha opaque -density 150 ' + fln
        spawn, 'rm -f ' + fln
      endif else stop
    endfor

    tplot_names, all_tplot_names.density_name + '_??', names = names
    store_data, delete = names
  endif

  timespan, t_s, t_dt, /seconds
end