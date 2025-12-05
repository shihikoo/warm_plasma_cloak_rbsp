; -------------------------------------------------------------------------------
; Purpose: make superposed epoch analysis plots of warm plasma cloak occurrence frequency for substorms
; Inputs: flag, substorm_phase, path_sea, ts_date, te_date, filename
; Keywords: ps_plot = ps_plot, region = region
; Written by Jing Liao
; Written on 11/2025
; -------------------------------------------------------------------------------

pro plot_substorm_sea_ratio, flag, substorm_phase, l, ext_condition_str, int_condition_str, path_sea, ts_date, te_date, filename, ps_plot = ps_plot, l_cuttings = l_cuttings, remove_ps = remove_ps, y_range = y_range
  ; condition_substorm = finite(substorm_phase)
  condition_quiet = ~finite(substorm_phase)

  ; l_cuttings = [[4.5,5],[5,5.5],[5.5,6],[6,6.5],[6.5,7],[2,8],[2,4],[4,6],[6,8]]
  n_l_cuttings = n_elements(l_cuttings) / 2

  substorm_bin_size = 5 * 60. ; in second
  substorm_phase_period = 1800
  n_bin = ceil(substorm_phase_period * 2 / substorm_bin_size)
  substorm_bin = round(substorm_phase / substorm_bin_size) * (abs(substorm_phase) < 1) ; convert substorm_phases, which is the minitues from the onset, into the binned value

  substorm_sample = dblarr(n_bin, n_l_cuttings) * !values.f_nan
  substorm_event = dblarr(n_bin, n_l_cuttings) * !values.f_nan
  substorm_ratio = dblarr(n_bin, n_l_cuttings) * !values.f_nan
  substorm_ratio_time = dblarr(n_bin, n_l_cuttings) * !values.f_nan
  for ilcut = 0, n_l_cuttings - 1 do begin
    condition_l = (l gt min(l_cuttings[*, ilcut])) * (l lt max(l_cuttings[*, ilcut]))

    for ibin = 0, n_bin - 1 do begin
      condition_ibin = substorm_bin eq (-1. * substorm_phase_period + ibin * substorm_bin_size) / substorm_bin_size

      substorm_sample[ibin, ilcut] = total(condition_ibin * condition_l * (abs(flag) ge 0), /nan)

      substorm_event[ibin, ilcut] = total(condition_ibin * condition_l * (abs(flag) gt 0), /nan)

      substorm_ratio[ibin, ilcut] = substorm_event[ibin] / substorm_sample[ibin]

      substorm_ratio_time[ibin, ilcut] = (-1. * substorm_phase_period + (ibin + 0.5) * substorm_bin_size) / 60.
    endfor

    mean_quiet_ratio = total(condition_quiet * condition_l * (abs(flag) gt 0), /nan) / total(condition_quiet * condition_l * (abs(flag) ge 0), /nan)

    ; ----------
    ; ps_plot=0

    filename = path_sea + 'sea_' + ext_condition_str + '_' + int_condition_str + '_sample_' + ts_date + '_to_' + te_date + '_' + strcompress(l_cuttings[0, ilcut], /remove_all) + '_' + strcompress(l_cuttings[1, ilcut], /remove_all)

    spawn, 'mkdir -p ' + file_dirname(filename)

    title = ext_condition_str + '!C' + int_condition_str + ' Sample ' + ' at ' + 'L' + ':[ ' + strcompress(l_cuttings[0, ilcut]) + ',' + strcompress(l_cuttings[1, ilcut]) + ' ] ' + '!Cfrom ' + ts_date + ' to ' + te_date + ' avg:' + string(MEAN(substorm_sample, /nan), format = '(f8.3)')
    ; title =  ts_date + ' to ' + te_date + ' avg:' + string(mean(substorm_ratio, /nan), format = '(f8.3)')

    if keyword_set(ps_plot) then popen, filename + '.ps', /land
    PLOT, [-30, 30], [1., 1e5], psym = -1, xstyle = 1, ystyle = 1, xtitle = 'substorm SEA time', ytitle = '# of Total Samples', title = title, position = [0.12, 0.12, 0.8, 0.8], ylog = 1, /nodata

    oplot, substorm_ratio_time, substorm_sample, psym = -1
    
    if keyword_set(ps_plot) then begin
      pclose
      spawn, 'mogrify -format png -alpha opaque -density 150 ' + filename + '.ps'
      spawn, 'mogrify -rotate -90 ' + filename + '.png'
      spawn, 'rm -f ' + filename + '.ps'
    endif else stop

    write_csv, filename + '.csv', substorm_sample[*, ilcut]

    ; ----------
    filename = path_sea + 'sea_' + ext_condition_str + '_' + int_condition_str + '_event_' + ts_date + '_to_' + te_date + '_' + strcompress(l_cuttings[0, ilcut], /remove_all) + '_' + strcompress(l_cuttings[1, ilcut], /remove_all)

    spawn, 'mkdir -p ' + file_dirname(filename)

    title = ext_condition_str + '!C' + int_condition_str + ' Event ' + ' at ' + 'L' + ':[ ' + strcompress(l_cuttings[0, ilcut]) + ',' + strcompress(l_cuttings[1, ilcut]) + ' ] ' + '!Cfrom ' + ts_date + ' to ' + te_date + ' avg:' + string(MEAN(substorm_event, /nan), format = '(f8.3)')
    ; title =  ts_date + ' to ' + te_date + ' avg:' + string(mean(substorm_ratio, /nan), format = '(f8.3)')

    if keyword_set(ps_plot) then popen, filename + '.ps', /land
    PLOT, [-30, 30], [1, 1.e4], psym = -1, xstyle = 1, ystyle = 1, xtitle = 'substorm SEA time', ytitle = '# of events', title = title, position = [0.12, 0.12, 0.8, 0.8], ylog = 1, /nodata

    oplot, substorm_ratio_time, substorm_event, psym = -1

    if keyword_set(ps_plot) then begin
      pclose
      spawn, 'mogrify -format png -alpha opaque -density 150 ' + filename + '.ps'
      spawn, 'mogrify -rotate -90 ' + filename + '.png'
      spawn, 'rm -f ' + filename + '.ps'
    endif else stop

    write_csv, filename + '.csv', substorm_event[*, ilcut]

    ; -----------
    filename = path_sea + 'sea_' + ext_condition_str + '_' + int_condition_str + '_ratio_' + ts_date + '_to_' + te_date + '_' + strcompress(l_cuttings[0, ilcut], /remove_all) + '_' + strcompress(l_cuttings[1, ilcut], /remove_all)

    spawn, 'mkdir -p ' + file_dirname(filename)

    title = ext_condition_str + '!C' + int_condition_str + ' Ratio' + ' at ' + 'L' + ':[ ' + strcompress(l_cuttings[0, ilcut]) + ',' + strcompress(l_cuttings[1, ilcut]) + ' ] ' + '!Cfrom ' + ts_date + ' to ' + te_date + ' avg:' + string(MEAN(substorm_ratio, /nan), format = '(f8.3)')
    ; title =  ts_date + ' to ' + te_date + ' avg:' + string(mean(substorm_ratio, /nan), format = '(f8.3)')

    if ~keyword_set(y_range) then y_range = [0.5, 1]
    ; low_limit_y = min(y_range) < min([mean_quiet_ratio, min(substorm_ratio,/nan)],/nan)
    ; high_limit_y = max(y_range) <(min([mean_quiet_ratio, min(substorm_ratio,/nan)],/nan) + 0.5)

    if keyword_set(ps_plot) then popen, filename + '.ps', /land
    PLOT, [-30, 30], [0, 1.0], psym = -1, xstyle = 1, ystyle = 1, xtitle = 'substorm SEA time', ytitle = 'Occurrence Frequency', title = title, position = [0.12, 0.12, 0.8, 0.8], xrange = [-30, 30], yrange = [0, 1.0], /nodata

    oplot, [-30, 30], [mean_quiet_ratio, mean_quiet_ratio], psym = -1, color = 4
    oplot, substorm_ratio_time, substorm_ratio, psym = -1, color = 2

    if keyword_set(ps_plot) then begin
      pclose
      spawn, 'mogrify -format png -alpha opaque -density 150 ' + filename + '.ps'
      spawn, 'mogrify -rotate -90 ' + filename + '.png'
      spawn, 'rm -f ' + filename + '.ps'
    endif else stop

    write_csv, filename + '.csv', substorm_ratio[*, ilcut]
  endfor
end
