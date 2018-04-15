import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class VertexVertex implements IRepresentation{

  private List<Vector> vertex;

  public VertexVertex (ObjRepresentation obj) {
    vertex = new ArrayList<Vector>();
    for(Face f : obj.faces ){
      List<Vector> verticesTmp = new ArrayList(); 
      for(Edge edge : f.edges){
        if( !belongTo(verticesTmp, edge.vertex1) )
          verticesTmp.add(edge.vertex1);
        if( !belongTo(verticesTmp, edge.vertex2) )
          verticesTmp.add(edge.vertex2);
      }
      for(Vector v : verticesTmp){
        vertex.add(v);
      }
    }
  }

  public boolean belongTo(List<Vector> list, Vector v){
    for(Vector x : list){
      if( x.x() == v.x() && 
          x.y() == v.y() &&
          x.z() == v.z() ){
            
            return true;
          }
    }
    return false;
  }

  public void pintar(float sc){
    beginShape();
    for(Vector v : this.vertex) {
      vertex( v.x() * sc, v.y() * sc, v.z() * sc );
    }
    endShape();
  }

}
