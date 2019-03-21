/** file: simulation.h
 ** brief: Simulation class (an interface)
 ** author: Andrea Vedaldi
 **/

#ifndef __simulation__
#define __simulation__

class Simulation
{
public:
  virtual void step(double dt) = 0 ;
  virtual void display() = 0 ;
} ;

#endif /* defined(__simulation__) */
