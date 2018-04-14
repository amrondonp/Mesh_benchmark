public class VertexVertex extends {

  private Map<Vector, List<Vector>> vertex;

  public VerteVertex (ObjRepresentation obj) {
    vertex = new HashMap<Vector, List<vector> >();
    for( Vector v : obj.vertices ){
      vertex.put( v, new ArrayList<Vector>() );
    }
    for(Face v : obj.faces ){
      for(Edge edge : face.edges){
        vertex.get(edge.vertex1).add(edge.vertex2);
        vertex.get(edge.vertex2).add(edge.vertex1);
      }
    }
  }

  public List<Face> getFaces(){
    LinkedList<Vector> unvisited = new LinkedList<Vector>;
    unvisited.addAll( vertex.keySet() );
    LinkedList<Vector> stack = new LinkedList<Vector>;
    stack.add( invisited.getFirst() );
    Map<Vector, List<Vector>> parents = new HashMap<Vector>();
    while(!stack.isEmpty()){
      Vector h = stack.pop();
      print(h);
      for( Vector v : vertex.get(h) ){
        stack.push(v);
      }
    }
    return null;
  }

}
