import java.util.List;
import java.util.Set;
import java.util.TreeSet;

public class VertexVertex implements IRepresentation{

  private List<Vector> vertex;

  public VertexVertex (ObjRepresentation obj) {
    vertex = new ArrayList<Vector>();
    for(Face f : obj.faces ){
      List<Vector> verticesTmp = new ArrayList(); 
      for(Vector v : f.vertices){
        if( !belongTo(verticesTmp, v) )
          verticesTmp.add(v);
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
  /* Method for retained mode */
  public List<PShape> getShape( PShape boidShape , float sc){
    List<PShape> ps = new ArrayList();
    boidShape.beginShape();
    boidShape.stroke(255,0,0);
    for(Vector v : this.vertex) {
      boidShape.vertex( v.x() * sc, v.y() * sc, v.z() * sc );
    }
    boidShape.endShape();
    ps.add(boidShape);
    return ps;
    }
}
