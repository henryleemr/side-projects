/** file: graphics.cpp
 ** brief: Graphic helpers implementation
 ** author: Andrea Vedaldi
 **/

#include "graphics.h"

#include <cassert>
#include <cmath>
#include <iostream>
#include <algorithm>
#include <sstream>
#include <iomanip>

inline int round(float x) { return (floor(x + 0.5)); }

typedef std::vector<Figure*> figures_t ;
figures_t figures ;

/* ---------------------------------------------------------------- */
// class Drawable
/* ---------------------------------------------------------------- */

void Drawable::draw()
{}

/* ---------------------------------------------------------------- */
// class Figure : public Drawable
/* ---------------------------------------------------------------- */

Figure::Figure(std::string name)
 : xmin(-1), xmax(1), ymin(-1), ymax(1), glGrid(0), glCircle(0)
{
  glutInitDisplayMode(GLUT_DEPTH | GLUT_DOUBLE | GLUT_RGBA);
  glutInitWindowPosition(128,128);
  glutInitWindowSize(320,256);
  id = glutCreateWindow(name.c_str()) ;

  // snychronise buffer swapping with OpenGL
  // also limits the frame rate to the one o the scren
#if defined(__APPLE__)
  int swap_interval = 1;
  CGLContextObj cgl_context = CGLGetCurrentContext();
  CGLSetParameter(cgl_context, kCGLCPSwapInterval, &swap_interval);
#endif

  updateGrid() ;

  figures.push_back(this) ;
  glutDisplayFunc(Figure::handleDisplay) ;
  glutReshapeFunc(Figure::handleReshape) ;
}

// A display list to show the grid
void Figure::updateGrid()
{
  if (glGrid) {
    glDeleteLists(glGrid,1) ;
  }

  glGrid = glGenLists(1) ;
  glNewList(glGrid, GL_COMPILE) ;
  double x, y ;
  std::stringstream sstr ;
  glColor3f(0.8f, 0.8f, 0.8f);
  for (x = xmin ; x <= xmax ; x += (xmax-xmin)/10.0) {
    x = round(x * 10.0) / 10.0 ;
    glBegin(GL_LINES) ;
    glVertex2d(x,-1) ;
    glVertex2d(x,+1) ;
    glEnd() ;
    sstr.str("") ;
    sstr<<std::fixed
		<<std::setprecision(1)<<x;
    drawString(x+2*pixelSize,2*pixelSize,sstr.str()) ;
  }
  for (y = ymin ; y <= ymax ; y += (ymax-ymin)/10.0) {
    y = round(y * 10.0) / 10.0 ;
    glBegin(GL_LINES) ;
    glVertex2d(-1,y) ;
    glVertex2d(1,y) ;
    glEnd() ;
    sstr.str("") ;
    sstr<<std::fixed
		<<std::setprecision(1)<<y;
    drawString(2*pixelSize,y+2*pixelSize,sstr.str()) ;
  }
  glEndList() ;
}


Figure::~Figure()
{
  if (glCircle) glDeleteLists(glCircle, 1) ;
  if (glGrid) glDeleteLists(glGrid, 1) ;
  glutDestroyWindow(id) ;
  figures.erase(std::remove(figures.begin(), figures.end(), this), figures.end());
}

void Figure::addDrawable(Drawable * object) {
	Figure::objects_t::iterator iter = std::find(objects.begin(), objects.end(), object) ;
  if (iter == objects.end()) {
    objects.push_back(object) ;
  }
}

void Figure::removeDrawables(Drawable * object) {
	Figure::objects_t::iterator  iter = std::find(objects.begin(), objects.end(), object) ;
  if (iter != objects.end()) {
    objects.erase(iter) ;
  }
}

Figure * Figure::findByWindowId(int id)
{
  for(figures_t::iterator iter = figures.begin() ;
      iter != figures.end() ;
      ++ iter) {
    if ((*iter)->id == id) return (*iter) ;
  }
  return NULL ;
}

void Figure::handleDisplay() {
  int id = glutGetWindow() ;
  Figure * figure = Figure::findByWindowId(id) ;
  if (! figure) return ;
  figure->draw() ;
}

void Figure::handleReshape(int width, int height)
{
  int id = glutGetWindow() ;
  Figure * figure = Figure::findByWindowId(id) ;
  if (! figure) return ; // probably deleted but still messages in queue
  figure->windowWidth = width ;
  figure->windowHeight = height ;
  figure->reshape(width, height) ;
}

void Figure::makeCurrent() const
{
  if (glutGetWindow() != id) {
    glutSetWindow(id) ;
  }
}

void Figure::reshape(int width, int height)
{
  makeCurrent() ;
  if (windowWidth != width ||
      windowHeight != height) {
    glutReshapeWindow(width,height) ;
  }
  double aspect = (double)width/height ;
  double x0 = (xmin + xmax)/ 2.0 ;
  double ysize = ymax - ymin ;
  pixelSize = ysize / height;
  glViewport(0, 0, width, height);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluOrtho2D(-aspect*ysize/2+x0,aspect*ysize/2+x0,ymin,ymax) ;
  updateGrid() ;
  glutPostRedisplay() ;
}

void Figure::update() const
{
  makeCurrent() ;
  glutPostRedisplay() ;
}

void Figure::draw()
{
  makeCurrent() ;
  glClearColor(1.0, 1.0, 1.0, 1.0) ;
  glClear(GL_COLOR_BUFFER_BIT);
  glCallList(glGrid) ;

  for(Figure::objects_t::iterator iter = objects.begin() ;
      iter != objects.end() ;
      ++iter) {
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    (*iter)->draw() ;
  }

  glutSwapBuffers();
}

void Figure::drawString(double x, double y, std::string str)
{
  glRasterPos2f(x, y);
  for (char const * cstr = str.c_str() ;
       *cstr ;
       ++cstr) {
    glutBitmapCharacter(GLUT_BITMAP_HELVETICA_10, *cstr);
  }
}

void Figure::drawLine(double x1, double y1, double x2, double y2, double thickness)
{
  glPushMatrix() ;
  glPushAttrib(GL_LINE_BIT) ;
  glLineWidth(thickness) ;
  glBegin(GL_LINES) ;
  glVertex2d(x1, y1) ;
  glVertex2d(x2, y2) ;
  glEnd() ;
  glPopAttrib() ;
}

void Figure::drawCircle(double x, double y, double r)
{
  if (glCircle == 0) {
    glCircle = glGenLists(1) ;
    glNewList(glCircle, GL_COMPILE) ;
    glBegin(GL_TRIANGLE_FAN);
    glColor3d(0,0,1) ;
    glVertex2d(0,0) ;
    int numSegments = 128;
    for (int i = 0; i <= numSegments; i++) {
      double angle = i * 2.0 * 3.1468 / numSegments;
      glVertex2d(std::cos(angle),
                 std::sin(angle));
    }
    glEnd();
    glEndList() ;
  }

  glPushMatrix() ;
  glTranslated(x,y,0) ;
  glScaled(r,r,r) ;
  glCallList(glCircle) ;
  glPopMatrix() ;
}

Simulation * runningSimulation = NULL ;
double runningSimulationTime ;
double runningSimulationTimeStep ;

void handleTimer(int id)
{
  if (runningSimulation) {
    double now = glutGet(GLUT_ELAPSED_TIME) / 1000.0 ;
    double dt = now - runningSimulationTime ;
    double dt0 = runningSimulationTimeStep ;
    runningSimulationTime = now ;
    double n = std::ceil(dt / dt0) ;
    for (int i = 0 ; i < n ; ++i) {
      runningSimulation->step(dt / n) ;
    }
    runningSimulation->display() ;
  }
  glutTimerFunc((unsigned int)
                (0.99 * 1000 * runningSimulationTimeStep), handleTimer, 0);
}

void run() {
  run (NULL, 0) ;
}

void run(Simulation * simulation, double timeStep)
{
  runningSimulationTimeStep = timeStep ;
  runningSimulationTime = glutGet(GLUT_ELAPSED_TIME) / 1000.0 ;
  if (simulation) {
    runningSimulation = simulation ;
    glutTimerFunc(0, handleTimer, 0);
  }
  glutMainLoop() ;
}
