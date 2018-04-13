class Face {
    Edge [] edges;

    Face(Edge [] edges) {
        this.edges = edges;
    }

    void draw() {
        beginShape(TRIANGLE_STRIP);
        for(Edge edge : this.edges){
            vertex(edge.vertex1.x(), edge.vertex1.y(), edge.vertex1.z());
        }
        endShape();
    }
}