; -------------------------------------------------------------------------------
; Purpose: make superposed epoch analysis plots of warm plasma cloak property for substorms
; Inputs: flag, substorm_phase, path_sea, ts_date, te_date, filename
; Keywords: ps_plot = ps_plot, region = region
; Written by Jing Liao
; Written on 11/2025
; -------------------------------------------------------------------------------

pro plot_substorm_sea_property, property, substorm_phase, data_pos, property_map_type, property_name, path_sea, ext_condition_str, int_condition_str, ts_date, te_date, filename, property_v_log, property_v_range, property_unit, ps_plot = ps_plot, l_cuttings = l_cuttings, remove_ps = remove_ps
 ; the coordinates should be coor_set = [['MLT', 'ILAT', 'L']]
  l = data_pos[*,2]  
; ps_plot=0
  condition_valid = property gt 0

  condition_substorm = condition_valid * finite(substorm_phase)
  condition_quiet = condition_valid * (~finite(substorm_phase))

  ; l_cuttings = [[4.5,5],[5,5.5],[5.5,6],[6,6.5],[6.5,7]];[[2,8],[2,4],[4,6],[6,8]]
  n_l_cuttings = n_elements(l_cuttings) / 2

  substorm_bin_size = 5 * 60. ; in second
  substorm_phase_period = 1800
  n_bin = ceil(substorm_phase_period * 2 / substorm_bin_size)
  substorm_bin = round(substorm_phase / substorm_bin_size) * (abs(substorm_phase) <1)  ; convert substorm_phases, which is the minitues from the onset, into the binned value
  
  substorm_time = dblarr(n_bin, n_l_cuttings) * !values.f_nan
  substorm_mean = dblarr(n_bin, n_l_cuttings) * !values.f_nan
  substorm_std = dblarr(n_bin, n_l_cuttings) * !values.f_nan
  quiet_mean = dblarr(n_l_cuttings) * !values.f_nan
  quiet_std = dblarr(n_l_cuttings) * !values.f_nan

  print, property_name + ' ' + property_map_type

  for ilcut = 0, n_l_cuttings - 1 do begin
    condition_l = (l gt min(l_cuttings[*,ilcut])) * (l lt max(l_cuttings[*, ilcut]))
    for ibin = 0, n_bin - 1 do begin
      condition_ibin = (substorm_bin eq (-1. * substorm_phase_period + ibin * substorm_bin_size) / substorm_bin_size)
      iindex = where(condition_ibin * condition_l * condition_substorm, ct)
      if ct eq 0 then continue

      substorm_time[ibin, ilcut] = (-1. * substorm_phase_period + (ibin + 0.5) * substorm_bin_size) / 60.
      substorm_mean[ibin, ilcut] = aggregate_property_value_cloak(property[iindex], property_map_type)
      substorm_std[ibin, ilcut] = stddev(property[iindex])
    endfor

    quiet_index = where(condition_quiet * condition_l, ct)
    if ct gt 0 then begin
      quiet_mean[ilcut] = aggregate_property_value_cloak(property[quiet_index], property_map_type)
      quiet_std[ilcut] = stddev(property[quiet_index])
    endif
    ; print, substorm_mean[*,ilcut]
  endfor

  for ilcut = 0, n_l_cuttings - 1 do begin
    filename = path_sea + 'sea_' + ext_condition_str + '_' + int_condition_str + property_map_type + '_' + property_name + '_' + ts_date + '_to_' + te_date + '_' + strcompress(l_cuttings[0,ilcut], /remove_all) + '_' + strcompress(l_cuttings[1,ilcut], /remove_all)

    spawn, 'mkdir -p ' + file_dirname(filename)

    title = ext_condition_str + '!C' + int_condition_str + 'Cloak!C' + property_map_type + ' ' + property_name + ' at ' + 'L' + ':[ ' + strcompress(l_cuttings[0,ilcut]) + ',' + strcompress(l_cuttings[1,ilcut]) + ' ] ' + '!CFROM ' + ts_date + ' TO ' + te_date + ' avg:' + string(MEAN(substorm_mean, /nan), format = '(f10.3)')

    if keyword_set(ps_plot) then popen, filename + '.ps', /land

    low_limit_y = min(property_v_range) < min([quiet_mean, min(substorm_mean[*, ilcut],/nan)],/nan)
    high_limit_y = (max(property_v_range) < (min([quiet_mean, min(substorm_mean[*, ilcut],/nan)],/nan) * 100.))>max([quiet_mean, min(substorm_mean[*, ilcut],/nan)],/nan) 

    PLOT, [min(substorm_time), max(substorm_time)], [low_limit_y, high_limit_y], psym = -1, ylog = property_v_log, xstyle = 1, ystyle = 1, xtitle = 'substorm SEA time', ytitle = property_name + ' ' + property_unit, title = title, position = [0.12, 0.12, 0.8, 0.8], /nodata

    oplot, [min(substorm_time), max(substorm_time)], [quiet_mean[ilcut], quiet_mean[ilcut]], psym = -1,color=3
    oplot, substorm_time[*, ilcut], substorm_mean[*, ilcut], psym = -1, color=2

    ; ERRPLOT, substorm_time[*,ilcut ] * substorm_bin_size / 60., substorm_mean[*,ilcut ]-substorm_std[*,ilcut], substorm_mean[*,ilcut]+substorm_std[*,ilcut], color = 2

    if keyword_set(ps_plot) then begin
      pclose
      spawn, 'mogrify -format png -alpha opaque -density 150 ' + filename + '.ps'
      spawn, 'mogrify -rotate -90 ' + filename + '.png'
      if keyword_set(remove_ps) then spawn, 'rm -f ' + filename+ '.ps'
    endif else stop

      write_csv, filename+'.csv', substorm_mean[*, ilcut]

  endfor
  
end
