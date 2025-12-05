;--------------------------------------------------------------------
; Purpose: According to input property_name, load property data into property 
; also load log, range, and unit
; Inputs: data, property_name, property
; property_v_log, property_v_range, property_unit
;-----------------------------------------------------------------------
PRO load_property_data_cloak, data, property_name, property, property_v_log, property_v_range, property_unit, property_map_type = property_map_type

 ; -- Settings for graphing --
  energy_V_LOG = 1 & ENERGY_V_RANGE = [1, 60000.] & energy_unit = 'eV' & median_ENERGY_V_RANGE = [10,1000]   & minimum_ENERGY_V_RANGE   =[10,100]
  flux_V_LOG = 1 & FLUX_V_RANGE = [100., 1.e4] & flux_unit = '1/cm!U3!N-s-sr-(eV/e)'
  eflux_V_LOG = 1 & EFLUX_V_RANGE = [1000.,10000.] & eflux_unit = 'eV/cm!U3!N-s-sr(eV/e)'
  density_v_log = 1 &  density_v_range = [0.001, 0.1] & density_unit = 'cm!U-3'
  velocity_v_log = 1 &  velocity_v_range = [20, 200] & velocity_unit = 'km/s'
  velocity_vpara_log = 1 &  velocity_vpara_range = [20, 200]
  velocity_vperp_log = 1 &  velocity_vperp_range = [20, 200]
  distfunc_v_log = 1 &  distfunc_v_range = [1e-10, 1e-6] & distfunc_unit='(s!E3!N/cm!E3!N-km!E3!N)'
  normal_distfunc_v_log=1 & normal_distfunc_v_range=[1e-10,1e-8] & normal_distfunc_unit='(s!E3!N/cm!E3!N-km!E3!N)'
  nv_v_log = 1 & nv_v_range = [0.1, 10]*1e9 & nv_unit = 'm!U-2!Ns!U-1'
  pitch_angle_v_log = 0 & pitch_angle_v_range = [0, 60] & pitch_angle_unit = 'deg'
 ;   nvpara_over_b_v_log = 1 &  nvpara_over_b_v_range = [0.001, 0.01] & nvpara_over_b_unit = 'cm!U-3!N-km-s!U-1!N/gauss'
 ;    temperature_v_log = 1 &  temperature_v_range = [1000, 10000] & temperature_unit = 'eV'
  densityratio_v_log = 1 &  densityratio_v_range = [0.001, 1] & densityratio_unit = ''
  dipolization_v_log = 0 &  dipolization_v_range = [0, 90] & dipolization_unit = 'deg'
 ;   density_weighted_V_RANGE = [0.0005, 0.05]

  pressure_V_LOG = 1 & pressure_V_RANGE = [0.01, 10] & pressure_unit = 'nPa'

  By_v_log = 0 & By_v_range = [-50., 50.] & By_unit = 'nT'
  Beta_v_log = 1 & Beta_v_range = [1e-4, 1.] & Beta_unit = ''

 ; -- load the property --
  IF property_name EQ 'distfunc' THEN BEGIN 
     property = data.distfunc
     PROPERTY_v_log = distfunc_V_LOG & PROPERTY_V_RANGE = distfunc_V_RANGE 
     property_unit = distfunc_unit
  ENDIF
  IF property_name EQ 'normal_distfunc' THEN BEGIN 
     property = data.distfunc/data.mag
     PROPERTY_V_LOG = normal_distfunc_V_LOG & PROPERTY_V_RANGE = normal_distfunc_V_RANGE 
     property_unit = normal_distfunc_unit
  ENDIF
  IF property_name EQ 'energy' THEN BEGIN 
     property = data.en 
     PROPERTY_V_LOG = ENERGY_V_LOG 
     property_unit = energy_unit
     if property_map_type eq 'median' then  PROPERTY_V_RANGE = median_ENERGY_V_RANGE     $
     else if property_map_type eq 'minimum' then PROPERTY_V_RANGE = minimum_ENERGY_V_RANGE $
     else PROPERTY_V_RANGE = ENERGY_V_RANGE
     
  ENDIF 
   ;   IF property_name EQ 'energy_v' THEN BEGIN 
   ;      property = data.energy_v
   ;      PROPERTY_V_LOG = velocity_V_LOG & PROPERTY_V_RANGE = velocity_V_RANGE 
   ;      property_unit = velocity_unit
   ;   ENDIF 
   ;   IF property_name EQ 'v_energy' THEN BEGIN 
   ;      property = data.v_energy_
   ;      PROPERTY_V_LOG = energy_V_LOG & PROPERTY_V_RANGE = energy_V_RANGE 
   ;      property_unit = energy_unit
   ;   ENDIF 

  IF property_name EQ 'flux' THEN BEGIN 
     property = data.flux 
     PROPERTY_V_LOG = FLUX_V_LOG &  PROPERTY_V_RANGE = FLUX_V_RANGE 
     property_unit = FLUX_unit
  ENDIF 
  IF property_name EQ 'eflux' THEN BEGIN 
     property = data.eflux 
     PROPERTY_V_LOG = EFLUX_V_LOG &  PROPERTY_V_RANGE = EFLUX_V_RANGE 
     property_unit = EFLUX_unit
  ENDIF 
  
  IF property_name EQ 'total_density' THEN BEGIN 
   property = data.O_n
   PROPERTY_V_LOG = density_V_LOG &   PROPERTY_V_RANGE = density_V_RANGE 
   property_unit = density_unit
   ENDIF 
   IF property_name EQ 'total_velocity' THEN BEGIN 
      property = data.O_v 
      PROPERTY_V_LOG = velocity_V_LOG &   PROPERTY_V_RANGE = velocity_V_RANGE 
      property_unit = velocity_unit
   ENDIF 

   IF property_name EQ 'total_density_ratio' THEN BEGIN 
      property = data.O_n / data.H_n
      PROPERTY_V_LOG = densityratio_V_LOG &   PROPERTY_V_RANGE = densityratio_V_RANGE 
      property_unit = densityratio_unit
   ENDIF 

   IF property_name EQ 'density' THEN BEGIN 
     property = data.n
     PROPERTY_V_LOG = density_V_LOG &   PROPERTY_V_RANGE = density_V_RANGE 
     property_unit = density_unit
  ENDIF 

  IF property_name EQ 'velocity' THEN BEGIN 
     property = data.v
     PROPERTY_V_LOG = velocity_V_LOG &   PROPERTY_V_RANGE = velocity_V_RANGE 
     property_unit = velocity_unit
  ENDIF 

  IF property_name EQ 'V_H' THEN BEGIN 
      property = data.H_v 
      PROPERTY_V_LOG = velocity_V_LOG &   PROPERTY_V_RANGE = velocity_V_RANGE 
      property_unit = velocity_unit
   ENDIF 

  IF property_name EQ 'pressure' THEN BEGIN 
   property = data.p
   PROPERTY_V_LOG = pressure_V_LOG &   PROPERTY_V_RANGE = pressure_V_RANGE 
   property_unit = pressure_unit
   ENDIF
   IF property_name EQ 'Vpar_O' THEN BEGIN 
      property = data.O_VPAR 
      PROPERTY_V_LOG = velocity_Vpara_LOG &  PROPERTY_V_RANGE = velocity_Vpara_RANGE
      property_unit = velocity_unit
   ENDIF 
   IF property_name EQ 'Vperp_O' THEN BEGIN 
      property = data.O_VPERP 
      PROPERTY_V_LOG = velocity_Vperp_LOG &  PROPERTY_V_RANGE = velocity_Vperp_RANGE

      property_unit = velocity_unit
   ENDIF 

   IF property_name EQ 'Vpar_H' THEN BEGIN 
      property = data.H_VPAR
      PROPERTY_V_LOG = velocity_Vpara_LOG &  PROPERTY_V_RANGE = velocity_Vpara_RANGE
      property_unit = velocity_unit
   ENDIF 
   IF property_name EQ 'Vperp_H' THEN BEGIN 
   property = data.H_VPERP 
   PROPERTY_V_LOG = velocity_Vperp_LOG &  PROPERTY_V_RANGE = velocity_Vperp_RANGE

   property_unit = velocity_unit
   ENDIF 

  IF property_name EQ 'Vpar' THEN BEGIN 
     property = ABS(data.vpar) 
     PROPERTY_V_LOG = velocity_Vpara_LOG &   PROPERTY_V_RANGE = velocity_Vpara_RANGE 
     property_unit = velocity_unit
  ENDIF 
  IF property_name EQ 'Vperp' THEN BEGIN 
     property = data.Vperp 
     PROPERTY_V_LOG = velocity_Vperp_LOG &   PROPERTY_V_RANGE = velocity_Vperp_RANGE 
     property_unit = velocity_unit
  ENDIF 
  IF property_name EQ 'nV' THEN BEGIN 
     property = data.n*data.v*1e9
     PROPERTY_V_LOG = nv_V_LOG &  PROPERTY_V_RANGE = nv_V_RANGE 
     property_unit = nv_unit
  ENDIF 
  IF property_name EQ 'pitch_angle' THEN BEGIN 
     property = 90-abs(data.pa-90)
     PROPERTY_V_LOG = pitch_angle_V_LOG & PROPERTY_V_RANGE = pitch_angle_V_RANGE 
     property_unit = pitch_angle_unit
  ENDIF 
   ;   IF property_name EQ 'nVpara_over_B' THEN BEGIN 
   ;      property = (data.n*ABS(data.Vpar))/data.mag 
   ;      PROPERTY_V_LOG = nvpara_over_b_v_log & PROPERTY_V_RANGE = nvpara_over_b_v_range
   ;      property_unit = nvpara_over_b_unit
   ;   ENDIF 
   ;   IF property_name EQ 'temperature' THEN BEGIN 
   ;      property = ABS(data.t)
   ;      PROPERTY_V_LOG = temperature_v_log & PROPERTY_V_RANGE = temperature_v_range
   ;      property_unit = temperature_unit
   ;   ENDIF
  IF property_name EQ 'By' THEN BEGIN 
     property = data.By_GSM  ; replicate(!values.f_nan,n_elements(data.By))
     PROPERTY_V_LOG = By_v_log &  PROPERTY_V_RANGE = By_v_range

     property_unit = By_unit
  ENDIF 
  IF property_name EQ 'Beta' THEN BEGIN 
     property = data.Beta  ; replicate(!values.f_nan,n_elements(data.Beta))
     PROPERTY_V_LOG = Beta_v_log &  PROPERTY_V_RANGE = Beta_v_range
     property_unit = Beta_unit
  ENDIF  

  IF property_name EQ 'dipolization' THEN BEGIN 
     property = atan(abs(data.Bz_GSM)/sqrt(data.Bx_GSM^2+data.By_GSM^2))*180/3.1415926  ; replicate(!values.f_nan,n_elements(data.By))
     PROPERTY_V_LOG = dipolization_v_log &  PROPERTY_V_RANGE = dipolization_v_range

     property_unit = dipolization_unit
  ENDIF 

  IF ~KEYWORD_SET(property) THEN BEGIN 
     print, 'no ' +property_name+' avaliabe for mapping'
     stop
  ENDIF 
  
END
