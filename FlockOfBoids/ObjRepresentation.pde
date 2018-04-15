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
        Vector [] faceVertices = new Vector[tokens.length - 1];
        
        for(int i = 1 ; i < tokens.length ; i++) {
            String [] vertexIndexes = tokens[i].split("/+");
            int index1 = Integer.parseInt(vertexIndexes[0]) - 1;

            faceVertices[i - 1] = vertices.get(index1);
        }

        Face face = new Face(faceVertices);
        faces.add(face);
    }

    @Override
    public void pintar(float sc){
        for(Face face : this.faces) {
            face.draw(sc);
        }
    }

    @Override
    public List<PShape> getShape(PShape boidShape, float sc){
        List<PShape> facePshape = new ArrayList();
        for(Face face : this.faces) {
            facePshape.add( face.getShape(boidShape, sc));
        }
        return facePshape;
    }

}