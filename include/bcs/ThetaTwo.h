//* This file is revised from MatchedValueBC

#ifndef THETATWO_H
#define THETATWO_H

#include "NodalBC.h"


// Forward Declarations
class ThetaTwo;
class Function;

template <>
InputParameters validParams<ThetaTwo>();

/**
 * Implements a simple coupled boundary condition where u=v on the boundary.
 */
class ThetaTwo : public NodalBC
{
public:
  ThetaTwo(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpJacobian() override;
  virtual Real computeQpOffDiagJacobian(unsigned int jvar) override;

  const VariableValue & _coupled_var;

  /// The id of the coupled variable
  unsigned int _coupled_var_num;


  /**
   * Evaluate the function at the current quadrature point and timestep.
   */
  Real f();

  Function & _func_2;

};

#endif // THETA_H
