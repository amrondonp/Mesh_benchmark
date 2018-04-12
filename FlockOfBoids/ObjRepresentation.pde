class ObjRepresentation {    
    ArrayList<Vector> vertices;
    ArrayList<Face> faces;
    String file;

    ObjRepresentation(String file) {
        this.file = file;
        vertices = new ArrayList<Vector>();
        faces = new ArrayList<Face>();
        this.loadRepresentation();
    }

    private void loadRepresentation() {
        BufferedReader bf = createReader(this.file); 
        try{
            String line;
            while( (line = bf.readLine()) != null ) {
                this.parseLine(line);
            }
            bf.close();
        }catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void parseLine(String line) {
        String [] splitted = line.split(" ");
        
        if(splitted.length > 0) {
            switch (splitted[0]) {
                case "v":
                    print("v found\n");
                break;
                case "f":
                    print("f found\n");
                break;
            }
        }   
    }
}