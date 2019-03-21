/** file: test-ball.cpp
 ** brief: Tests the bouncing ball simulation
 ** author: Andrea Vedaldi
 **/

#include "ball.h"

int main(int argc, char** argv)
{
  Ball ball ;
  const double dt = 1.0/30 ;
  for (int i = 0 ; i < 100 ; ++i) {
    ball.step(dt) ;
    ball.display() ;
  }
  return 0 ;
}
