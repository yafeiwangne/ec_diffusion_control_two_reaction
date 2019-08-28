//* This file is revised from CoupledNeumannBC

#ifndef COUPLEDEQUALFLUXBCTWO_H
#define COUPLEDEQUALFLUXBCTWO_H

#include "IntegratedBC.h"

// Forward Declarations
class CoupledEqualFluxBCTwo;

template <>
InputParameters validParams<CoupledEqualFluxBCTwo>();

/**
 * Implements Neumann BC where grad(u)=-grad(v) on the boundary.
 */

class CoupledEqualFluxBCTwo : public IntegratedBC
{
public:

  CoupledEqualFluxBCTwo(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpOffDiagJacobian(unsigned int jvar) override;

private:

  const VariableGradient & _grad_couple_var;
  /// int label for coupled_var for Jac
  unsigned int _coupled_var_jac;
 /**
   * Diffusivity.
 */ 
  const MaterialProperty<Real> & _D_O_2;
 
};

#endif
