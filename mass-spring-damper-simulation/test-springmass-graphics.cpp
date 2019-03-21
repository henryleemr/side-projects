/** file: test-springmass-graphics.cpp
 ** brief: Tests the spring mass simulation with graphics
 ** author: Andrea Vedaldi
 **/

#include "graphics.h"
#include "springmass.h"

#include <iostream>
#include <sstream>
#include <iomanip>

/* ---------------------------------------------------------------- */
class SpringMassDrawable : public SpringMass, public Drawable {
/* ---------------------------------------------------------------- */

/* INCOMPLETE: TYPE YOUR CODE HERE */
private:
	Figure figure;
public:
	SpringMassDrawable()
	:figure("SpringMass")
	{
		figure.addDrawable(this);
	}

	void draw() {
		Vector2 posm1=mass1->getPosition();
		Vector2 posm2=mass2->getPosition();
    figure.drawCircle(posm1.x,posm1.y,0.02) ;
	figure.drawCircle(posm2.x,posm2.y,0.02) ;
	figure.drawLine(posm1.x,posm1.y,posm2.x,posm2.y,1);
  }

	void display() {
    figure.update() ;
  }


} ;



int main(int argc, char** argv)
{
  glutInit(&argc,argv) ;
  const double dt = 1/60.0 ;
  SpringMassDrawable springmass ;


/* INCOMPLETE: TYPE YOUR CODE HERE */

  run(&springmass, 1/120.0) ;
}
