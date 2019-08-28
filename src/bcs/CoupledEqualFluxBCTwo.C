//* This file is is revised from CoupledNeumannBC, C_R take the flux from C_O


#include "CoupledEqualFluxBCTwo.h"

registerMooseObject("ECDiffusionControlTwoReactionApp", CoupledEqualFluxBCTwo);

template <>
InputParameters
validParams<CoupledEqualFluxBCTwo>()
{
  InputParameters params = validParams<IntegratedBC>();
  params.addCoupledVar("coupled_var", "Coupled the variable C_O_2.");
  
  params.addParam<MaterialPropertyName>("D_O_2","D_O_2", "Diffusivity for oxidizing agent.");
  params.addParam<MaterialPropertyName>("D_R_2","D_R_2", "Diffusivity for reducing agent.");
  return params;
}

CoupledEqualFluxBCTwo::CoupledEqualFluxBCTwo(const InputParameters & parameters)
  : IntegratedBC(parameters),

    _grad_couple_var(coupledGradient("coupled_var")),
    _coupled_var_jac(coupled("coupled_var")),
    _D_O_2(getMaterialProperty<Real>("D_O_2"))

{
}


Real
CoupledEqualFluxBCTwo::computeQpResidual()
{
    return  _test[_i][_qp] *_grad_couple_var[_qp] * _D_O_2[_qp] *_normals[_qp];
}

//This will improve convergence
Real
CoupledEqualFluxBCTwo::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _coupled_var_jac)
    return _test[_i][_qp] *_grad_phi[_j][_qp] * _D_O_2[_qp]*_normals[_qp];
  else
    return 0.;
}

