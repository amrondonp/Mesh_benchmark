/**
 * Flock of Boids
 * by Jean Pierre Charalambos.
 * 
 * This example displays the 2D famous artificial life program "Boids", developed by
 * Craig Reynolds in 1986 and then adapted to Processing in 3D by Matt Wetmore in
 * 2010 (https://www.openprocessing.org/sketch/6910#), in 'third person' eye mode.
 * Boids under the mouse will be colored blue. If you click on a boid it will be
 * selected as the scene avatar for the eye to follow it.
 *
 * Press ' ' to switch between the different eye modes.
 * Press 'a' to toggle (start/stop) animation.
 * Press 'p' to print the current frame rate.
 * Press 'm' to change the mesh visual mode.
 * Press 't' to shift timers: sequential and parallel.
 * Press 'v' to toggle boids' wall skipping.
 * Press 's' to call scene.fitBallInterpolation().
 */

import frames.input.*;
import frames.input.event.*;
import frames.primitives.*;
import frames.core.*;
import frames.processing.*;

Scene scene;
int flockWidth = 1280;
int flockHeight = 720;
int flockDepth = 600;
boolean avoidWalls = true;

// visual modes
// 0. Faces and edges
// 1. Wireframe (only edges)
// 2. Only faces
// 3. Only points
int mode;

// 1 for face-vertex representation, 2 for vertex-vertex representation
int representation = 1;

// Retained mode, or inmediate mode
boolean retained = false;
int initBoidNum = 800; // amount of boids to start the program with
ArrayList<Boid> flock;
Node avatar;
boolean animate = true;

PWindow window;
/* PShape object for retained mode*/
PShape boidShape;

public void settings() {
  size(1000, 640, P3D);
}

void setup() {

  window = new PWindow();
  
  scene = new Scene(this);
  scene.setBoundingBox(new Vector(0, 0, 0), new Vector(flockWidth, flockHeight, flockDepth));
  scene.setAnchor(scene.center());
  Eye eye = new Eye(scene);
  scene.setEye(eye);
  scene.setFieldOfView(PI / 3);
  //interactivity defaults to the eye
  scene.setDefaultGrabber(eye);
  scene.fitBall();
  // create and fill the list of boids
 
  ObjRepresentation rep = new ObjRepresentation("cube.obj");
  rep.loadRepresentation();
  VertexVertex rep2 = new VertexVertex(rep);


  flock = new ArrayList();
  if( representation == 1)
    for (int i = 0; i < initBoidNum; i++)
      flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2), rep,retained));
    else
      for (int i = 0; i < initBoidNum; i++)
        flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2), rep2,retained));
  
}

void draw() {
  
  background(0);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  // Calls Node.visit() on all scene nodes.
  scene.traverse();
  window.setVariables(frameRate, frameCount, retained, representation,initBoidNum);

}

void walls() {
  pushStyle();
  noFill();
  stroke(255);

  line(0, 0, 0, 0, flockHeight, 0);
  line(0, 0, flockDepth, 0, flockHeight, flockDepth);
  line(0, 0, 0, flockWidth, 0, 0);
  line(0, 0, flockDepth, flockWidth, 0, flockDepth);

  line(flockWidth, 0, 0, flockWidth, flockHeight, 0);
  line(flockWidth, 0, flockDepth, flockWidth, flockHeight, flockDepth);
  line(0, flockHeight, 0, flockWidth, flockHeight, 0);
  line(0, flockHeight, flockDepth, flockWidth, flockHeight, flockDepth);

  line(0, 0, 0, 0, 0, flockDepth);
  line(0, flockHeight, 0, 0, flockHeight, flockDepth);
  line(flockWidth, 0, 0, flockWidth, 0, flockDepth);
  line(flockWidth, flockHeight, 0, flockWidth, flockHeight, flockDepth);
  popStyle();
}

void keyPressed() {
  switch (key) {
  case 'a':
    animate = !animate;
    break;
  case 's':
    if (scene.eye().reference() == null)
      scene.fitBallInterpolation();
    break;
  case 't':
    scene.shiftTimers();
    break;
  case 'p':
    println("Frame rate: " + frameRate);
    break;
  case 'v':
    avoidWalls = !avoidWalls;
    break;
  case 'm':
    mode = mode < 3 ? mode+1 : 0;
    break;
  case ' ':
    if (scene.eye().reference() != null) {
      scene.lookAt(scene.center());
      scene.fitBallInterpolation();
      scene.eye().setReference(null);
    } else if (avatar != null) {
      scene.eye().setReference(avatar);
      scene.interpolateTo(avatar);
    }
    break;
  }
}
