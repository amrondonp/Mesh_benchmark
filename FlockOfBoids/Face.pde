class Face {
    Vector [] vertices;

    Face(Vector [] vertices) {
        this.vertices = vertices;
    }

    void draw(float sc) {
        beginShape();
        for(Vector v : this.vertices){
            vertex(v.x() * sc, v.y() * sc, v.z() * sc);
        }
        endShape(CLOSE);
    }
    /* Method for retained mode */
    PShape getShape( PShape boidShape , float sc){
        boidShape = createShape();
        boidShape.beginShape(); 
        boidShape.stroke(0,255,0, 5);
        for(Vector v : this.vertices){
            boidShape.vertex(v.x() * sc, v.y() * sc, v.z() * sc);
        }
        boidShape.endShape();
        return boidShape;
    }
}