/** file: springmass.cpp
 ** brief: SpringMass simulation implementation
 ** author: Andrea Vedaldi
 **/

#include "springmass.h"

#include <iostream>
#include <cmath>

/* ---------------------------------------------------------------- */
// class Mass
/* ---------------------------------------------------------------- */

Mass::Mass()
: position(), velocity(), force(), mass(1), radius(1)
{ }

Mass::Mass(Vector2 position, Vector2 velocity, double mass, double radius)
: position(position), velocity(velocity), force(), mass(mass), radius(radius),
xmin(-1),xmax(1),ymin(-1),ymax(1)
{ }

void Mass::setForce(Vector2 f)
{
  force = f ;
}

void Mass::addForce(Vector2 f)
{
  force = force + f ;
}

Vector2 Mass::getForce() const
{
  return force ;
}

Vector2 Mass::getPosition() const
{
  return position ;
}

Vector2 Mass::getVelocity() const
{
  return velocity ;
}

double Mass::getRadius() const
{
  return radius ;
}

double Mass::getMass() const
{
  return mass ;
}

double Mass::getEnergy(double gravity) const
{
  double energy = 0 ;

/* INCOMPLETE: TYPE YOUR CODE HERE */
  energy = mass*velocity.norm2()/2+mass*gravity*position.y;

  return energy ;
}

void Mass::step(double dt)
{

/* INCOMPLETE: TYPE YOUR CODE HERE */
	velocity = velocity+(force/mass)*dt ;
	Vector2 pos = position+velocity*dt;
	if (xmin + radius <= pos.x && pos.x <= xmax - radius) {
    position.x = pos.x ;
  } else {
    velocity.x = -velocity.x ;
  }
  if (ymin + radius <= pos.y && pos.y <= ymax - radius) {
    position.y = pos.y ;
  } else {
    velocity.y = -velocity.y ;
  }

}

/* ---------------------------------------------------------------- */
// class Spring
/* ---------------------------------------------------------------- */

Spring::Spring(Mass * mass1, Mass * mass2, double naturalLength, double stiffness, double damping)
: mass1(mass1), mass2(mass2),
naturalLength(naturalLength), stiffness(stiffness), damping(damping)
{ }

Mass * Spring::getMass1() const
{
  return mass1 ;
}

Mass * Spring::getMass2() const
{
  return mass2 ;
}

Vector2 Spring::getForce() const
{
  Vector2 F ;

/* INCOMPLETE: TYPE YOUR CODE HERE */
  Vector2 u = (mass2->getPosition()-mass1->getPosition())/getLength();
  F=stiffness*(getLength()-naturalLength)*u; 
  Vector2 v = dot(mass2->getVelocity()-mass1->getVelocity(),u)*u;
  F = F+damping*v;

  return F ;
}

double Spring::getLength() const
{
  Vector2 u = mass2->getPosition() - mass1->getPosition() ;
  return u.norm() ;
}

double Spring::getEnergy() const {
  double length = getLength() ;
  double dl = length - naturalLength;
  return 0.5 * stiffness * dl * dl ;
}

std::ostream& operator << (std::ostream& os, const Mass& m)
{
  os<<"("
  <<m.getPosition().x<<","
  <<m.getPosition().y<<")" ;
  return os ;
}

std::ostream& operator << (std::ostream& os, const Spring& s)
{
  return os<<"$"<<s.getLength() ;
}

/* ---------------------------------------------------------------- */
// class SpringMass : public Simulation
/* ---------------------------------------------------------------- */

SpringMass::SpringMass()
{
  const double mass = 0.05 ;
  const double radius = 0.02 ;
  const double naturalLength = 0.95 ;
  /////////
  const double stiff = 10;
  const double damping =0.01;
  this->mass1 = new Mass(Vector2(-.5,0), Vector2(), mass, radius);
  this->mass2 = new Mass(Vector2(+.5,0), Vector2(), mass, radius);
  this->spring = new Spring(mass1, mass2, naturalLength,stiff,damping);
  gravity=1.62;
}
SpringMass::SpringMass(Spring * spring,double gravity)
	:gravity(gravity),spring(spring),mass1(spring->getMass1()),mass2(spring->getMass2())
{}

void SpringMass::display()
{

/* INCOMPLETE: TYPE YOUR CODE HERE */
	Vector2 m1pos=mass1->getPosition();
	Vector2 m2pos=mass2->getPosition();
	std::cout<<m1pos.x<<" "<<m1pos.y<<" "<<m2pos.x<<" "<<m2pos.y<<std::endl;
}

double SpringMass::getEnergy() const
{
  double energy = 0 ;

/* INCOMPLETE: TYPE YOUR CODE HERE */
  energy = mass1->getEnergy(gravity) + mass2->getEnergy(gravity) + spring->getEnergy();

  return energy ;
}

void SpringMass::step(double dt)
{
  Vector2 g(0,-gravity) ;
  mass1->setForce(g);
  mass2->setForce(g);
  Vector2 F = spring->getForce();
  mass1->addForce(F);
  mass2->addForce(-1*F);
  mass1->step(dt);
  mass2->step(dt);

/* INCOMPLETE: TYPE YOUR CODE HERE */

}


/* INCOMPLETE: TYPE YOUR CODE HERE */


