#include "ECDiffusionControlTwoReactionApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template <>
InputParameters
validParams<ECDiffusionControlTwoReactionApp>()
{
  InputParameters params = validParams<MooseApp>();
  return params;
}

ECDiffusionControlTwoReactionApp::ECDiffusionControlTwoReactionApp(InputParameters parameters) : MooseApp(parameters)
{
  ECDiffusionControlTwoReactionApp::registerAll(_factory, _action_factory, _syntax);
}

ECDiffusionControlTwoReactionApp::~ECDiffusionControlTwoReactionApp() {}

void
ECDiffusionControlTwoReactionApp::registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ModulesApp::registerAll(f, af, s);
  Registry::registerObjectsTo(f, {"ECDiffusionControlTwoReactionApp"});
  Registry::registerActionsTo(af, {"ECDiffusionControlTwoReactionApp"});

  /* register custom execute flags, action syntax, etc. here */
}

void
ECDiffusionControlTwoReactionApp::registerApps()
{
  registerApp(ECDiffusionControlTwoReactionApp);
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
ECDiffusionControlTwoReactionApp__registerAll(Factory & f, ActionFactory & af, Syntax & s)
{
  ECDiffusionControlTwoReactionApp::registerAll(f, af, s);
}
extern "C" void
ECDiffusionControlTwoReactionApp__registerApps()
{
  ECDiffusionControlTwoReactionApp::registerApps();
}
