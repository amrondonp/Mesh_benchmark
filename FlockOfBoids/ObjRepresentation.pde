class ObjRepresentation implements IRepresentation{    
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

    @Override
    public void pintar(float sc){
        beginShape();
        for(Face face : this.faces) {
        for(Edge edge : face.edges){
            vertex(edge.vertex1.x() * sc , edge.vertex1.y() * sc, edge.vertex1.z() * sc );
            vertex(edge.vertex2.x() * sc , edge.vertex2.y() * sc, edge.vertex2.z() * sc );
        }
        }
        endShape();
    }
}