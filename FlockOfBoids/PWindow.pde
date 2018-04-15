class PWindow extends PApplet {
  float framerate;
  float framecount;
  float lastFrameY;

  PGraphics pgGraph;
  PGraphics pgFps;
  
  PWindow() {
    super();
    PApplet.runSketch(new String[] {this.getClass().getSimpleName()}, this);
  }

  void settings() {
      size(640, 200);
  }

  void setFrameRate(float framerate, float framecount){
      this.framerate = framerate;
      this.framecount = framecount;
  }
  void setup() {
        background(188);
        stroke(255);    
        pgFps = createGraphics(640, 50 );
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
        pgFps.endDraw();
        image(pgFps, 0,0);
  }

}