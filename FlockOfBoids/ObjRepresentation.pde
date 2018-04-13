class ObjRepresentation {    
    ArrayList<Vector> vertices;
    ArrayList<Face> faces;
    String file;

    ObjRepresentation(String file) {
        this.file = file;
        vertices = new ArrayList<Vector>();
        faces = new ArrayList<Face>();
    }

    void draw() {
        for(Face face : this.faces) {
            face.draw();
        }
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
        Edge [] edges = new Edge[tokens.length - 1];
        
        for(int i = 1 ; i < tokens.length ; i++) {
            String [] vertexIndexes = tokens[i].split("/+");
            int index1 = Integer.parseInt(vertexIndexes[0]) - 1;
            int index2 = Integer.parseInt(vertexIndexes[1]) - 1;

            edges[i - 1] = new Edge(vertices.get(index1));
        }

        Face face = new Face(edges);
        faces.add(face);
    }
}