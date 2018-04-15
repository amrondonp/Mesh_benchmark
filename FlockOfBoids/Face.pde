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
}