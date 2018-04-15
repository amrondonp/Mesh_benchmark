class PWindow extends PApplet {
  float framerate;
  float framecount;
  float lastFrameY;
  boolean retained;
  int representation;
  int initBoidNum;
  PGraphics pgGraph;
  PGraphics pgFps;
  
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
      size(640, 200);
  }

  void setVariables(float framerate, float framecount, boolean retained, int representation, int initBoidNum){
      this.framerate = framerate;
      this.framecount = framecount;
      this.retained = retained;
      this.representation = representation;
      this.initBoidNum = initBoidNum;
  }
  void setup() {
        background(188);
        stroke(255);    
        pgFps = createGraphics(640, 75 );
  }

  void draw() {
        
        stroke(255,0,0);
        line(millis()/1000 -1 , height-lastFrameY, millis()/1000, height-framerate);

        stroke(0,0,0);
        line(framecount -1 , height-lastFrameY, framecount, height-framerate);
        lastFrameY = framerate;

        pgFps.beginDraw();
        pgFps.background(188);
        pgFps.fill(0);
        pgFps.text("FPS : " + framerate,0, 20);
        pgFps.text("Seconds : " + millis()/1000, width/2, 20);
        if( retained )
          pgFps.text( "Run in retained mode:" , width/2, 40);
        else 
           pgFps.text( "Run in inmediate mode", width/2, 40);
        if( representation == 1 )
          pgFps.text( "Representation face - vertex:" , 0, 40);
        else 
           pgFps.text( "Representation vertex - vertex", 0, 40);
        pgFps.stroke(255,0,0);
        pgFps.line(0,60,20 , 60);
        pgFps.text( "frameRate vs time (sec )", 60 , 60 );

        pgFps.stroke(0,0,0);
        pgFps.line(0,70,20 , 70);
        pgFps.text( "frameRate vs frameCount", 60 , 70 );

        pgFps.text("Numb of boids  " + initBoidNum , width/2, 60);
        pgFps.endDraw();
        image(pgFps, 0,0);
  }

}