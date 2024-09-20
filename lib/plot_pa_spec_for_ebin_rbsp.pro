; ------------------------------------------------------------------------------------------------------------------------------
; Purpose:  Plot pitch angle around for each energy bin within the given energy range and store pitch angle peak into tplot strings
; Inputs:   sc, specie, units_name, flux_name
; Keywords: pa_name, average_time, time_avg, energy_limit
; Created by Jing Liao
; Created 09/04/2024
; ------------------------------------------------------------------------------------------------------------------------------

pro plot_pa_spec_for_ebin_rbsp, sc,  specie,  units_name, flux_name, pa_name = pa_name, average_time = average_time, time_avg = time_avg, energy_limit = energy_limit 
  common SHARE1, ENERGY_BINS, DENERGY_BINS, PA_BINS, ERROR_MESSAGE

  ; ----------------------------------------------------------
  ; check keywords and set the energybins range to nrange
  ; ---------------------------------------------------------
  energy_bins_defined = ENERGY_BINS
  nenergybins = n_elements(energy_bins_defined)
  pa_bins_defined = PA_BINS
  npabins = n_elements(pa_bins_defined)
  n_time = n_elements(time_avg)

  ; This units is for pitch angle tplot names of rbsp
  case units_name of
    'DIFF FLUX': units_str = 'DIFFFLUX'
    'EFLUX': units_str = 'EFLUX'
  endcase
  
  case specie of
    '3': sp_str = '3'
    '0': sp_str = '0'
    '1': sp_str = '1'
  endcase

  case sc of
    '1': sc_str = 'A'
    '2': sc_str = 'B'
  endcase

  ; -----------------------------------------------------------------
  ; plot pa in the energy range and store pa specta data
  ; -----------------------------------------------------------------
  flux_pa = cmreplicate(!values.f_nan, [n_time,npabins, nenergybins]) 
  pa_pa = cmreplicate(transpose(cmreplicate(pa_bins_defined, n_time)), nenergybins)

; plot pa for each energy bin within the energy limit.
  this_energybins = where(energy_bins_defined gt min(energy_limit) and energy_bins_defined le max(energy_limit), ct)
  if ct lt 1 then stop
  for ienergybin = 0, n_elements(this_energybins) - 1 do begin
    this_energtybin = this_energybins[ienergybin]

    plot_rbsp_hope_l3_paspec_jing, sc, specie, units_name, energy_units_in_flux = 'eV', eph_data = 0, aux_data = 0, energy_bins_range = [this_energtybin, this_energtybin]
    
    en_str = strcompress(string(energy_bins_defined[this_energtybin], format = '(i5.5)'), /remove_all)
    
    ipa_name = 'RBSP' + sc_str + '_HOPE_l3_paspec_sp' + sp_str + '_' + units_str + '_' + en_str + '_' + en_str
    average_tplot_variable_with_given_time, ipa_name, average_time, time_avg
    
    get_data, ipa_name, data = data, dlim=dlim,lim=lim
    flux_pa[*, *, this_energybins[ienergybin]] = data.y
  ;  store_data, ipa_name, data = {x:data.x, y:data.y, v:pa_pa[*, *, this_energybins[ienergybin]]}, dlim = dlim, lim=lim
    store_data, delete = ipa_name
  endfor
  
  get_data, flux_name, data = data
  index = where(~finite(total(data.y,2)),ct)
  if ct gt 0 then flux_pa[index,*,*] = !values.f_nan

; store pitch angle tplot
  str = {x: time_avg, y: flux_pa, v: pa_pa}
  store_data, pa_name, data = str, dlim = dlim, lim = lim
  options, pa_name, 'ytitle', 'PA!CEN Peak'
  zlim, pa_name, 1, 1000
  ylim, pa_name, 0, 180
  
  ; for k = 0, nenergybins-1 do store_data, pa_name+'_'+string(k,format='(i2.2)'), data = {x:time_avg, y:reform(flux_pa[*,*,k]), v:reform(pa_pa[*,*,k])} , dlim =dlim , lim = lim
  ; for k = 0, nenergybins-1 do options, pa_name+'_'+string(k,format='(i2.2)'), 'ytitle', 'pa!C'+string(energy_bins[k])
   
  ; tplot_names, 'RBSP*'
  
  ; stop

end