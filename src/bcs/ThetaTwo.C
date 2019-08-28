//* This file is revised from MatchedValueBC, need to be sure which one is the variable to be coupled.

#include "ThetaTwo.h"
#include "Function.h"


registerMooseObject("ECDiffusionControlTwoReactionApp", ThetaTwo);

template <>
InputParameters
validParams<ThetaTwo>()
{
  InputParameters params = validParams<NodalBC>();
  params.addRequiredCoupledVar("coupled_var", "variable is C_O_2, coupled C_R_2.");
  params.addClassDescription("Implements a NodalBC, get the two different Variables' values "
                             "on a specified boundary, so we get the ratio.");
  params.addRequiredParam<FunctionName>("Exp_2", "Exp term in 5.4.6.");
  return params;
}

ThetaTwo::ThetaTwo(const InputParameters & parameters)
  : NodalBC(parameters), 
    _coupled_var(coupledValue("coupled_var")), 
    _coupled_var_num(coupled("coupled_var")),
    _func_2(getFunction("Exp_2"))
{
}

Real
ThetaTwo::f()
{
  return _func_2.value(_t, *_current_node);
}

Real
ThetaTwo::computeQpResidual()
{
  return _u[_qp] / _coupled_var[_qp] - f();

}

//NodalBCs are applied directly at nodes so there is no interpolation done like what it is done in the interior of an element volume or an element face. Instead of the approximate solution being u_h = sum(uj * phij), the solution is just simply uj because this is at a node. So there is NO phij for NodalBCs. That is why the Jacobian for most of NodalBCs is just 1 instead of _phi. 


Real
ThetaTwo::computeQpJacobian()
{
  return 1. / _coupled_var[_qp];

}

Real
ThetaTwo::computeQpOffDiagJacobian(unsigned int jvar)
{
  if (jvar == _coupled_var_num)
    return -_u[_qp] / (_coupled_var[_qp] * _coupled_var[_qp]);
  else
    return 0.;
}
