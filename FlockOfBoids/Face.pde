class Face {
    Vector [] vertices;

    Face(Vector [] vertices) {
        this.vertices = vertices;
    }

    void draw() {
        beginShape();
        for(Vector v : this.vertices){
            vertex(v.x(), v.y(), v.z());
        }
        endShape(CLOSE);
    }
}