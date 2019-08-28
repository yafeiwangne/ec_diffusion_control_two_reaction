[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 200
  xmax = 1
[]

[Variables]
  [C_O]
    order = FIRST
    family = LAGRANGE
    [InitialCondition]
      type = ConstantIC
      value = 1
      variable = C_O
    []
  []
  [C_R]
    order = FIRST
    family = LAGRANGE
    scaling = 1E5
    [InitialCondition]
      type = FunctionIC
      function = C_R_IC_funtion
      variable = C_R
    []
  []
  [C_O_2]
    family = LAGRANGE
    order = FIRST
    [InitialCondition]
      type = ConstantIC
      value = 1
      variable = C_O_2
    []
  []
  [C_R_2]
    family = LAGRANGE
    scaling = 1E5
    order = FIRST
    [InitialCondition]
      type = FunctionIC
      function = C_R_2_IC_function
      variable = C_R_2
    []
  []
[]

[Kernels]
  [C_O_diff]
    type = MatDiffusion
    variable = C_O
    D_name = D_O
  []
  [C_R_diff]
    type = MatDiffusion
    variable = C_R
    D_name = D_R
  []
  [C_O_dot]
    type = TimeDerivative
    variable = C_O
  []
  [C_R_dot]
    type = TimeDerivative
    variable = C_R
  []
  [C_O_2_diff]
    type = MatDiffusion
    D_name = D_O_2
    variable = C_O_2
  []
  [C_R_2_diff]
    type = MatDiffusion
    D_name = D_R_2
    variable = C_R_2
  []
  [C_O_2_dot]
    type = TimeDerivative
    variable = C_O_2
  []
  [C_R_2_dot]
    type = TimeDerivative
    variable = C_R_2
  []
[]

[BCs]
  # For each equation, only two bcs are needed, if more then two bcs for each equation it will be over-specify. If nodalBC and integrateBC are applied at the same time,  nodalBC will be strongly enforced while integrateBC will be ignored.
  [C_R_right]
    type = DirichletBC
    variable = C_R
    boundary = 'right'
    value = 0
  []
  [C_O_right]
    type = DirichletBC
    variable = C_O
    boundary = 'right'
    value = 1
  []
  [C_R_left_coupled_Fluxin]
    # C_R (primary var) taking the flux from C_O (coupled)
    type = CoupledEqualFluxBC
    variable = C_R
    boundary = 'left'
    D_O = D_O
    coupled_var = 'C_O'
  []
  [C_O_left_theta]
    # C_O (primary var) will couple the value of C_R (coupled var)
    type = Theta
    variable = C_O
    boundary = 'left'
    coupled_var = 'C_R'
    Exp = Exp_func
  []
  [C_R_2_right]
    type = DirichletBC
    variable = C_R
    boundary = 'right'
    value = 0
  []
  [C_O_2_right]
    type = DirichletBC
    variable = C_O_2
    boundary = 'right'
    value = 1
  []
  [C_R_2_left_coupled_Fluxin]
    # C_R (primary var) taking the flux from C_O (coupled)
    type = CoupledEqualFluxBCTwo
    variable = C_R_2
    boundary = 'left'
    coupled_var = 'C_O_2'
  []
  [C_O_2_left_theta]
    # C_O (primary var) will couple the value of C_R (coupled var)
    type = ThetaTwo
    variable = C_O_2
    boundary = 'left'
    coupled_var = 'C_R_2'
    Exp_2 = Exp_func_2
  []
[]

[Materials]
  [Diffusivity_of_C_O]
    type = GenericConstantMaterial
    prop_names = 'D_O'
    prop_values = '0.01'
  []
  [Diffusivity_of_C_R]
    type = GenericConstantMaterial
    prop_names = 'D_R'
    prop_values = '0.01'
  []
  [Diffusivity_of_C_O_2]
    type = GenericConstantMaterial
    prop_values = '0.01'
    prop_names = 'D_O_2'
  []
  [Diffusivity_of_C_R_2]
    type = GenericConstantMaterial
    prop_values = '0.01'
    prop_names = 'D_R_2'
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  num_steps = 600
  solve_type = PJFNK
  end_time = 1.8
  dtmax = 0.5e-2
  line_search = basic
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1E-12
  []
[]

[Outputs]
  # execute_on = 'TIMESTEP_END'
  # csv = true
  exodus = true
[]

[Debug]
  show_var_residual_norms = true
[]

[Functions]
  # #####parameter#####
  # #####parameter#####
  E1 = '1.4'
  v = '1'
  E0 = '0.85'
  Ef = '1'
  [Exp_func]
    type = ParsedFunction
    value = 'if(t<=0.9, exp(n*F*(${E1}-${v}*t-${E0})/R/T), exp(n*F*(${E1}+${v}*t-${E0}-2*${v}*0.9)/R/T))' # 6.2.2 time dependent
    vars = 'n F R T'
    vals = '1 96485 8.314 300'
  []
  [E]
    type = ParsedFunction
    value = 'if(t<=0.9, ${E1}-${v}*t, ${E1}+${v}*t-2*${v}*0.9)'
  []
  [C_R_IC_funtion]
    # Give C_R a small value to trigger the flux exchange
    type = ParsedFunction
    vars = 'a'
    value = 'a*x-a'
    vals = '-1E-9'
  []
  [C_R_2_IC_function]
    # Give C_R a small value to trigger the flux exchange
    type = ParsedFunction
    vars = 'a'
    value = 'a*x-a'
    vals = '-1E-9'
  []
  [Exp_func_2]
    type = ParsedFunction
    vars = 'n F R T'
    value = 'if(t<=0.9, exp(n*F*(${E1}-${v}*t-${Ef})/R/T), exp(n*F*(${E1}+${v}*t-${Ef}-2*${v}*0.9)/R/T))'
    vals = '1 96485 8.314 300'
  []
[]

[Postprocessors]
  [C_O]
    type = NodalVariableValue
    nodeid = 0
    variable = C_O
  []
  [C_R]
    type = NodalVariableValue
    nodeid = 0
    variable = C_R
  []
  [Flux_C_O]
    type = SideFluxIntegral
    diffusivity = D_O
    variable = 'C_O'
    boundary = 'left'
  []
  [Flux_C_R]
    type = SideFluxIntegral
    diffusivity = D_R
    variable = 'C_R'
    boundary = 'left'
  []
  [E]
    type = FunctionValuePostprocessor
    function = E
  []
  [C_O_2]
    type = NodalVariableValue
    nodeid = 0
    variable = C_O_2
  []
  [C_R_2]
    type = NodalVariableValue
    nodeid = 0
    variable = C_R_2
  []
  [Flux_C_O_2]
    type = SideFluxIntegral
    diffusivity = D_O_2
    variable = 'C_O_2'
    boundary = 'left'
  []
  [Flux_C_R_2]
    type = SideFluxIntegral
    diffusivity = D_R_2
    variable = 'C_R_2'
    boundary = 'left'
  []
[]
