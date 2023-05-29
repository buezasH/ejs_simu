public class Suelo extends DeformableObject {

  public Suelo(int numNodesX, int numNodesY, int numNodesZ, float sepX, float sepY, float sepZ, color c) {
    super(numNodesX, numNodesY, numNodesZ, sepX, sepY, sepZ, SpringLayout.STRUCTURAL, c);
  }

  @Override
    void initNodes() {
    for ( int i = 0; i < _numNodesX; i++)
    {
      for (int j = 0; j < _numNodesY; j++)
      {
        for (int k = 0; k < _numNodesZ; k++)
        {
          _nodes[i][j][k] = new Particle(new PVector(i*_sepX, j*_sepY, k*_sepZ -20), new PVector(), M, true, false);
        }
      }
    }
  }

  @Override
    void update (float simStep, PVector air) 
    {
      
    for ( int i = 0; i < _numNodesX; i++)
    {
      for (int j = 0; j < _numNodesY; j++)
      {
        for (int k = 0; k < _numNodesZ; k++)
        {
          _nodes[i][j][k].addExternalForce(new PVector(0, 0, G));  //Añadimos la fuerza a la particula
        }
      }
    }
  }




}
