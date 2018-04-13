class Face {
    Edge [] edges;

    Face(Edge [] edges) {
        this.edges = edges;
    }

    void draw() {
        beginShape();
        for(Edge edge : this.edges){
            vertex(edge.vertex1.x(), edge.vertex1.y(), edge.vertex1.z());
            vertex(edge.vertex2.x(), edge.vertex2.y(), edge.vertex2.z());
        }
        endShape();
    }
}