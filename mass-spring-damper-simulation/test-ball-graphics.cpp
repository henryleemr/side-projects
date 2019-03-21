/** file: test-ball-graphics.cpp
 ** brief: Tests the bouncing ball simulation with graphical output
 ** author: Andrea Vedaldi
 **/

#include "graphics.h"
#include "ball.h"

#include <iostream>
#include <sstream>
#include <iomanip>

/* ---------------------------------------------------------------- */
class BallDrawable : public Ball, public Drawable {
/* ---------------------------------------------------------------- */
private:
  Figure figure ;

public:
  BallDrawable()
  : figure("Bouncing ball")
  {
    figure.addDrawable(this) ;
  }

  void draw() {
    figure.drawCircle(x,y,r) ;
  }

  void display() {
    figure.update() ;
  }
} ;

int main(int argc, char** argv)
{
  glutInit(&argc,argv) ;
  const double dt = 1/60.0 ;
  BallDrawable ball ;
  run(&ball, dt) ;
  return 0 ;
}
