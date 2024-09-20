; -----------------------------------------------------------------------
; Purpose: Identify cloak population within rbsp
; Description: This is the main part of the cloak identification program:
; = > 1. plot pitch angle spectra for each energy bin
; = > 2. label the pitch angle peak condition
; = > 3. filter the population out by cleaning up the uncontineous pitch angle
;
; Input:   sat, specie, flux_name, average_time, time_avg, region_name
; Keywords:  , t_s, t_e peak_pa_range, pa_count_line = pa_count_line, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor , pa_name = pa_name, pa_eflux_name = pa_eflux_name , pap_name = pap_name, pap_beam_name = pap_beam_name, pap_range_name = pap_range_name, int_flux_name = int_flux_name, diff_en = diff_en, diff_pa = diff_pa, energy_limit = energy_limit
; 
; Created by Jing Liao
; Created on 09/04/2024
; -----------------------------------------------------------------------

pro identify_cloak_rbsp, sat, specie, flux_name, average_time, time_avg, region_name $
  , epcut_name = epcut_name, epcut_beam_name = epcut_beam_name, epcut_cloak_name = epcut_cloak_name $
  , t_s = t_s, t_e = t_e $
  , pa_count_line = pa_count_line, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor $
  , pa_name = pa_name, pa_eflux_name = pa_eflux_name $
  , pap_name = pap_name, pap_beam_name = pap_beam_name,pap_cloak_name = pap_cloak_name $
  , pap_range_name = pap_range_name, int_flux_name = int_flux_name $
  , diff_en = diff_en, diff_pa = diff_pa, energy_limit = energy_limit, remove_isotropic = remove_isotropic, isotropic_pa_def = isotropic_pa_def

  ; ----------------------------------------
  ; Keywords handling
  ; ---------------------------------------
  if ~keyword_set(t_s) or ~keyword_set(t_e) then begin
    get_timespan, interval
    t_s = interval[0]
    t_e = interval[1]
  endif

  if ~keyword_set(pa_count_line) then pa_count_line = 50
  if ~keyword_set(flux_threshold) then flux_threshold = [0, 0, 0]
  if ~keyword_set(def_pap_factor) then def_pap_factor = [1, 1, 1]

  ; -------------------------------------------------------------------
  ; find the evergy range and energy peak from average energy spectra
  ; -------------------------------------------------------------------
  ; plot pitch angle for each energy bin in 'DIFF FLUX' 
  tplot_names, pa_name, names = names
  ; if ~keyword_set(names) then $
  plot_pa_spec_for_ebin_rbsp, sat, specie, 'DIFF FLUX', flux_name, pa_name = pa_name, average_time = average_time, time_avg = time_avg, energy_limit = energy_limit 

  ; plot pitch angle for each energy bin  IN 'EFLUX'
  tplot_names, pa_eflux_name, names = names
  ; if ~keyword_set(names) then  $
  plot_pa_spec_for_ebin_rbsp, sat, specie, 'EFLUX', flux_name, pa_name = pa_eflux_name, average_time = average_time, time_avg = time_avg, energy_limit = energy_limit 

  ; find pitch angle peak
  tplot_names, pap_name, names = names
 ; if ~keyword_set(names) then $
  find_pa_peak_multi, pa_eflux_name, pa_name, pap_name, region_name, pa_count_line = pa_count_line, flux_threshold = flux_threshold, def_pap_factor = def_pap_factor, remove_isotropic = remove_isotropic, isotropic_pa_def = isotropic_pa_def
   
  ; filter pitch angle peak to beams by requiring continuity and close energy range
  tplot_names, pap_cloak_name, names = names
  ; if ~keyword_set(names) then $
  filter_cloak_multi, pap_name, pap_beam_name, pap_cloak_name, flux_name, epcut_name, epcut_beam_name, epcut_cloak_name, diff_en = diff_en, diff_pa = diff_pa

  ; find the pitch angle range around the pitch angle
  tplot_names, pap_range_name, names = names
  ;if ~keyword_set(names) then $
  find_pa_range_multi, pa_name, pap_cloak_name, flux_name, pap_range_name, int_flux_name
       
end