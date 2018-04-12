import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import frames.input.*; 
import frames.input.event.*; 
import frames.primitives.*; 
import frames.core.*; 
import frames.processing.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class FlockOfBoids extends PApplet {

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

int initBoidNum = 900; // amount of boids to start the program with
ArrayList<Boid> flock;
Node avatar;
boolean animate = true;

public void setup() {
  ObjRepresentation rep = new ObjRepresentation("cube.obj");
  rep.loadRepresentation();

  
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
  flock = new ArrayList();
  for (int i = 0; i < initBoidNum; i++)
    flock.add(new Boid(new Vector(flockWidth / 2, flockHeight / 2, flockDepth / 2), rep));
}

public void draw() {
  background(0);
  ambientLight(128, 128, 128);
  directionalLight(255, 255, 255, 0, 1, -100);
  walls();
  // Calls Node.visit() on all scene nodes.
  scene.traverse();
}

public void walls() {
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

public void keyPressed() {
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
class Boid {
  Node node;
  int grabsMouseColor;
  int avatarColor;
  // fields
  Vector position, velocity, acceleration, alignment, cohesion, separation; // position, velocity, and acceleration in
  // a vector datatype
  float neighborhoodRadius; // radius in which it looks for fellow boids
  float maxSpeed = 4; // maximum magnitude for the velocity vector
  float maxSteerForce = .1f; // maximum magnitude of the steering vector
  float sc = 3; // scale factor for the render of the boid
  float flap = 0;
  float t = 0;
  ObjRepresentation rep;
  


  Boid(Vector inPos, ObjRepresentation rep) {
    this.rep = rep;
    grabsMouseColor = color(0, 0, 255);
    avatarColor = color(255, 255, 0);
    position = new Vector();
    position.set(inPos);
    node = new Node(scene) {
      // Note that within visit() geometry is defined at the
      // node local coordinate system.
      @Override
      public void visit() {
        if (animate)
          run(flock);
        render();
      }

      // Behaviour: tapping over a boid will select the node as
      // the eye reference and perform an eye interpolation to it.
      @Override
      public void interact(TapEvent event) {
        if (avatar != this && scene.eye().reference() != this) {
          avatar = this;
          scene.eye().setReference(this);
          scene.interpolateTo(this);
        }
      }
    };
    node.setPosition(new Vector(position.x(), position.y(), position.z()));
    velocity = new Vector(random(-1, 1), random(-1, 1), random(1, -1));
    acceleration = new Vector(0, 0, 0);
    neighborhoodRadius = 100;
  }

  public void run(ArrayList<Boid> boids) {
    t += .1f;
    flap = 10 * sin(t);
    // acceleration.add(steer(new Vector(mouseX,mouseY,300),true));
    // acceleration.add(new Vector(0,.05,0));
    if (avoidWalls) {
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), flockHeight, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), 0, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(flockWidth, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(0, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), 0)), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), flockDepth)), 5));
    }
    flock(boids);
    move();
    checkBounds();
  }

  public Vector avoid(Vector target) {
    Vector steer = new Vector(); // creates vector for steering
    steer.set(Vector.subtract(position, target)); // steering vector points away from
    steer.multiply(1 / sq(Vector.distance(position, target)));
    return steer;
  }

  //-----------behaviors---------------

  public void flock(ArrayList<Boid> boids) {
    //alignment
    alignment = new Vector(0, 0, 0);
    int alignmentCount = 0;
    //cohesion
    Vector posSum = new Vector();
    int cohesionCount = 0;
    //separation
    separation = new Vector(0, 0, 0);
    Vector repulse;
    for (int i = 0; i < boids.size(); i++) {
      Boid boid = boids.get(i);
      //alignment
      float distance = Vector.distance(position, boid.position);
      if (distance > 0 && distance <= neighborhoodRadius) {
        alignment.add(boid.velocity);
        alignmentCount++;
      }
      //cohesion
      float dist = dist(position.x(), position.y(), boid.position.x(), boid.position.y());
      if (dist > 0 && dist <= neighborhoodRadius) {
        posSum.add(boid.position);
        cohesionCount++;
      }
      //separation
      if (distance > 0 && distance <= neighborhoodRadius) {
        repulse = Vector.subtract(position, boid.position);
        repulse.normalize();
        repulse.divide(distance);
        separation.add(repulse);
      }
    }
    //alignment
    if (alignmentCount > 0) {
      alignment.divide((float) alignmentCount);
      alignment.limit(maxSteerForce);
    }
    //cohesion
    if (cohesionCount > 0)
      posSum.divide((float) cohesionCount);
    cohesion = Vector.subtract(posSum, position);
    cohesion.limit(maxSteerForce);

    acceleration.add(Vector.multiply(alignment, 1));
    acceleration.add(Vector.multiply(cohesion, 3));
    acceleration.add(Vector.multiply(separation, 1));
  }

  public void move() {
    velocity.add(acceleration); // add acceleration to velocity
    velocity.limit(maxSpeed); // make sure the velocity vector magnitude does not
    // exceed maxSpeed
    position.add(velocity); // add velocity to position
    node.setPosition(position);
    node.setRotation(Quaternion.multiply(new Quaternion(new Vector(0, 1, 0), atan2(-velocity.z(), velocity.x())),
      new Quaternion(new Vector(0, 0, 1), asin(velocity.y() / velocity.magnitude()))));
    acceleration.multiply(0); // reset acceleration
  }

  public void checkBounds() {
    if (position.x() > flockWidth)
      position.setX(0);
    if (position.x() < 0)
      position.setX(flockWidth);
    if (position.y() > flockHeight)
      position.setY(0);
    if (position.y() < 0)
      position.setY(flockHeight);
    if (position.z() > flockDepth)
      position.setZ(0);
    if (position.z() < 0)
      position.setZ(flockDepth);
  }

  public void render() {
    pushStyle();

    // uncomment to draw boid axes
    //scene.drawAxes(10);

    int kind = TRIANGLES;
    strokeWeight(2);
    stroke(color(0, 255, 0));
    fill(color(255, 0, 0, 125));

    // visual modes
    switch(mode) {
    case 1:
      noFill();
      break;
    case 2:
      noStroke();
      break;
    case 3:
      strokeWeight(3);
      kind = POINTS;
      break;
    }

    // highlight boids under the mouse
    if (node.track(mouseX, mouseY)) {
      noStroke();
      fill(grabsMouseColor);
    }

    // highlight avatar
    if (node == avatar) {
      noStroke();
      fill(avatarColor);
    }

    //draw boid
    // beginShape(kind);
    // vertex(3 * sc, 0, 0);
    // vertex(-3 * sc, 2 * sc, 0);
    // vertex(-3 * sc, -2 * sc, 0);

    // vertex(3 * sc, 0, 0);
    // vertex(-3 * sc, 2 * sc, 0);
    // vertex(-3 * sc, 0, 2 * sc);

    // vertex(3 * sc, 0, 0);
    // vertex(-3 * sc, 0, 2 * sc);
    // vertex(-3 * sc, -2 * sc, 0);

    // vertex(-3 * sc, 0, 2 * sc);
    // vertex(-3 * sc, 2 * sc, 0);
    // vertex(-3 * sc, -2 * sc, 0);
    // endShape();

    for(Face face : this.rep.faces) {
      for(Edge edge : face.edges){
        if(edge == null){
          print("You're srewd\n");
          continue;
        }
        print(edge.vertex1 + " " + edge.vertex2 + "\n");
      }
    }

    popStyle();
  }
}
class Edge {
    Vector vertex1, vertex2;

    Edge(Vector vertex1, Vector vertex2) {
        this.vertex1 = vertex1;
        this.vertex2 = vertex2;
    }
}
public class Eye extends Node {
  public Eye(Graph graph) {
    super(graph);
  }

  protected Eye(Graph otherGraph, Eye otherNode) {
    super(otherGraph, otherNode);
  }

  @Override
  public Eye get() {
    return new Eye(graph(), this);
  }

  @Override
  public void interact(frames.input.Event event) {
    if (graph().eye().reference() == null) {
      if (event.shortcut().matches(new Shortcut(RIGHT)))
        translate(event);
      else if (event.shortcut().matches(new Shortcut(LEFT)))
        rotate(event);
      if (event.shortcut().matches(new Shortcut(frames.input.Event.SHIFT, CENTER)))
        rotate(event);
      else if (event.shortcut().matches(new TapShortcut(CENTER, 2)))
        center();
      else if (event.shortcut().matches(new TapShortcut(RIGHT)))
        align();
      else if (event.shortcut().matches(new Shortcut(MouseEvent.WHEEL)))
        translateZ(event);
    } else {
      if (event.shortcut().matches(new Shortcut(RIGHT)))
        moveBackward(event);
      else if (event.shortcut().matches(new Shortcut(LEFT)))
        moveForward(event);
      else if (event.shortcut().matches(new Shortcut(frames.input.Event.NO_ID)))
        lookAround(event);
    }
  }
}
class Face {
    Edge [] edges;

    Face(Edge [] edges) {
        this.edges = edges;
    }
}
class ObjRepresentation {    
    ArrayList<Vector> vertices;
    ArrayList<Face> faces;
    String file;

    ObjRepresentation(String file) {
        this.file = file;
        vertices = new ArrayList<Vector>();
        faces = new ArrayList<Face>();
    }

    private void loadRepresentation() {
        BufferedReader bf = createReader(this.file); 
        try{
            String line;
            while( (line = bf.readLine()) != null ) {
                this.parseLine(line);
            }
            print("Number of vertices: " + vertices.size() + "\n");
            print("Number of faces " + faces.size() + "\n");
            bf.close();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void parseLine(String line) {
        String [] splitted = line.split(" +");
        
        if(splitted.length > 0) {
            switch (splitted[0]) {
                case "v":
                    parseVertex(splitted);
                break;
                case "f":
                    parseFace(splitted);
                break;
            }
        }   
    }

    private void parseVertex(String [] tokens) {
        Vector vertex = new Vector(
            Float.parseFloat(tokens[1]),
            Float.parseFloat(tokens[2]),
            Float.parseFloat(tokens[3])
        );

        vertices.add(vertex);
    }

    private void parseFace(String [] tokens){
        Edge [] edges = new Edge[3];
        
        for(int i = 1 ; i <= 3 ; i++) {
            String [] vertexIndexes = tokens[i].split("//");
            int index1 = Integer.parseInt(vertexIndexes[0]) - 1;
            int index2 = Integer.parseInt(vertexIndexes[1]) - 1;

            edges[i - 1] = new Edge(vertices.get(index1), vertices.get(index2));
        }

        Face face = new Face(edges);
        faces.add(face);
    }
}
  public void settings() {  size(1000, 800, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "FlockOfBoids" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
