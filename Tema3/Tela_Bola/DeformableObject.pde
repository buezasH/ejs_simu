public class DeformableObject //<>// //<>// //<>// //<>// //<>// //<>//
{

  int _numNodesX;   // Number of nodes in X direction
  int _numNodesY;   // Number of nodes in Y direction
  int _numNodesZ;   // Number of nodes in Z direction

  float _sepX;      // Separation of the object's nodes in the X direction (m)
  float _sepY;      // Separation of the object's nodes in the Y direction (m)
  float _sepZ;      // Separation of the object's nodes in the Z direction (m)

  SpringLayout _springLayout;   // Physical layout of the springs that define the surface of each layer
  color _color;                 // Color (RGB)

  Particle[][][] _nodes;                             // Particles defining the object
  ArrayList<DampedSpring> _springs;                  // Springs joining the particles
  ArrayList<DampedSpring> _collision_springs;        // Springs for external particle collisions

  DeformableObject(int numNodesX, int numNodexY, int numNodesZ, float sepX, float sepY, float sepZ, SpringLayout sp, color c)
  {

    _numNodesX = numNodesX;
    _numNodesY = numNodexY;
    _numNodesZ = numNodesZ;

    _sepX = sepX;
    _sepY = sepY;
    _sepZ = sepZ;

    _color = c;

    _nodes = new Particle[_numNodesX][_numNodesY][_numNodesZ];
    _springs = new ArrayList();
    _collision_springs = new ArrayList();

    _springLayout = sp;

    initNodes();
    initSprings();
  }

  int getNumNodes()
  {
    return _numNodesX*_numNodesY*_numNodesZ;
  }

  int getNumSprings()
  {
    return _springs.size();
  }

  void update(float simStep, PVector air)
  {
    PVector fwind = new PVector();
    for (int i = 0; i < _springs.size(); i++)
      _springs.get(i).update(simStep);

    for (int i = 0; i < _collision_springs.size(); i++) {
      float dist_part = _collision_springs.get(i).getParticle1().getPosition().dist(_collision_springs.get(i).getParticle2().getPosition());
      if ( dist_part < _ball.getRadius())
        _collision_springs.get(i).update(simStep);
      else {
        _collision_springs.remove(i);
      }
    }
        
    for ( int i = 0; i < _numNodesX; i++)
    {
      for (int j = 0; j < _numNodesY; j++)
      {
        for (int k = 0; k < _numNodesZ; k++)
        {
          _nodes[i][j][k].update(simStep);
          if (_applywind) {
            fwind = applyWind(i, j, k);
            _nodes[i][j][k].addExternalForce(new PVector(fwind.x * air.x, fwind.y * air.y, fwind.z * air.z));  //Añadimos la fuerza a la particula
          }
        }
      }
    }
  }

  void initNodes()
  {
    for ( int i = 0; i < _numNodesX; i++)
    {
      for (int j = 0; j < _numNodesY; j++)
      {
        for (int k = 0; k < _numNodesZ; k++)
        {
          _nodes[i][j][k] = new Particle(new PVector(i*_sepX, j*_sepY, k*_sepZ), new PVector(), M, false, false);
        }
      }
    }
  }

  void initSprings()
  {
    switch(_springLayout)
    {
    case STRUCTURAL:
      createStructural();
      break;
    case SHEAR:
      createShear();
      break;
    case BEND:
      createBend();
      break;
    case STRUCTURAL_AND_SHEAR:
      createStructural();
      createShear();
      break;
    case STRUCTURAL_AND_BEND:
      createStructural();
      createBend();
      break;
    case SHEAR_AND_BEND:
      createShear();
      createBend();
      break;
    case STRUCTURAL_AND_SHEAR_AND_BEND:
      createStructural();
      createShear();
      createBend();
      break;
    }
  }

  void createStructural()
  {
    for ( int i = 0; i < _numNodesX; i++)
    {
      for (int j = 0; j < _numNodesY; j++)
      {
        for (int k = 0; k < _numNodesZ; k++)
        {
          if (i < _numNodesX -1)
            _springs.add(new DampedSpring(_nodes[i][j][k], _nodes[i+1][j][k], KE, KD, false));
          if (j < _numNodesY -1)
            _springs.add(new DampedSpring(_nodes[i][j][k], _nodes[i][j+1][k], KE, KD, false));
          if (k < _numNodesZ -1)
            _springs.add(new DampedSpring(_nodes[i][j][k], _nodes[i][j][k+1], KE_z, KD_z, false));
        }
      }
    }
  }

  void createShear()
  {
    for ( int i = 0; i < _numNodesX-1; i++)
    {
      for (int j = 0; j < _numNodesY-1; j++)
      {
        for (int k = 0; k < _numNodesZ; k++)
        {
          _springs.add(new DampedSpring(_nodes[i][j][k], _nodes[i+1][j+1][k], KE, KD, false));
          _springs.add(new DampedSpring(_nodes[i][j+1][k], _nodes[i+1][j][k], KE, KD, false));
          if (k < _numNodesZ -1)
            _springs.add(new DampedSpring(_nodes[i][j][k], _nodes[i][j][k+1], KE_z, KD_z, false));
        }
      }
    }
  }

  void createBend()
  {
    for ( int i = 0; i < _numNodesX; i++)
    {
      for (int j = 0; j < _numNodesY; j++)
      {
        for (int k = 0; k < _numNodesZ; k++)
        {
          if (i < _numNodesX -2)
            _springs.add(new DampedSpring(_nodes[i][j][k], _nodes[i+2][j][k], KE, KD, false));
          if (j < _numNodesY -2)
            _springs.add(new DampedSpring(_nodes[i][j][k], _nodes[i][j+2][k], KE, KD, false));
          if (k < _numNodesZ -1)
            _springs.add(new DampedSpring(_nodes[i][j][k], _nodes[i][j][k+1], KE_z, KD_z, false));
        }
      }
    }
  }


  void interaction(Ball ball)
  {
    float dist = 0;

    for (int i = 0; i < _numNodesX; i++) {
      for (int j = 0; j < _numNodesY; j++) {
        for (int k = 0; k < _numNodesZ; k++) {

          PVector particlePos = _nodes[i][j][k].getPosition();
          dist = particlePos.dist(ball.getPosition());
          DampedSpring newSpring = new DampedSpring(_nodes[i][j][k], ball, KE, 3.5, true);

          if (dist < ball.getRadius())
            _collision_springs.add(newSpring);
        }
      }
    }
  }

  PVector applyWind(int i, int j, int k) {
    PVector fviento = new PVector();
    PVector n = new PVector();
    float kviento = 0;

    int aux = 0;
    n = new PVector(0, 0, 0);

    if (i + 1 < _numNodesX && j + 1 < _numNodesY) {
      PVector norm1 = PVector.sub(_nodes[i + 1][j][k].getPosition(), _nodes[i][j][k].getPosition());
      PVector norm2 = PVector.sub(_nodes[i][j + 1][k].getPosition(), _nodes[i][j][k].getPosition());
      n.add(norm1.cross(norm2));
      aux++;
    }

    if (i - 1 >= 0 && j - 1 >= 0) {
      PVector norm1 = PVector.sub(_nodes[i][j - 1][k].getPosition(), _nodes[i][j][k].getPosition());
      PVector norm2 = PVector.sub(_nodes[i - 1][j][k].getPosition(), _nodes[i][j][k].getPosition());
      n.add(norm1.cross(norm2));
      aux++;
    }
    if (i + 1 < _numNodesX && j + 1 < _numNodesY) {
      PVector norm1 = PVector.sub(_nodes[i + 1][j][k].getPosition(), _nodes[i][j][k].getPosition());
      PVector norm2 = PVector.sub(_nodes[i][j + 1][k].getPosition(), _nodes[i][j][k].getPosition());
      n.add(norm1.cross(norm2));
      aux++;
    }
    if (j - 1 >= 0 && i + 1 < _numNodesX) {
      PVector norm1 = PVector.sub(_nodes[i][j - 1][k].getPosition(), _nodes[i][j][k].getPosition());
      PVector norm2 = PVector.sub(_nodes[i + 1][j][k].getPosition(), _nodes[i][j][k].getPosition());
      n.add(norm1.cross(norm2));
      aux++;
    }

    n.div(aux); // Media de las normales
    kviento = viento.dot(n.normalize()); // Direccion del viento para la particula
    fviento = PVector.mult(viento, kviento); // Nueva fuerza del viento

    return fviento;
  }


  void render()
  {
    if (DRAW_MODE)
      renderWithSegments();
    else
      renderWithQuads();
  }

  void renderWithSegments()
  {
    stroke(0);
    strokeWeight(0.5);

    for (DampedSpring s : _springs)
    {
      PVector pos1 = s.getParticle1().getPosition();
      PVector pos2 = s.getParticle2().getPosition();

      line(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z);
    }
  }

  void renderWithQuads()
  {
    int i, j, k;

    fill(_color);
    stroke(0);
    strokeWeight(1.0);

    for (j = 0; j < _numNodesY - 1; j++)
    {
      beginShape(QUAD_STRIP);
      for (i = 0; i < _numNodesX; i++)
      {
        if ((_nodes[i][j][0] != null) && (_nodes[i][j+1][0] != null))
        {
          PVector pos1 = _nodes[i][j][0].getPosition();
          PVector pos2 = _nodes[i][j+1][0].getPosition();

          vertex(pos1.x, pos1.y, pos1.z);
          vertex(pos2.x, pos2.y, pos2.z);
        }
      }
      endShape();
    }

    for (j = 0; j < _numNodesY - 1; j++)
    {
      beginShape(QUAD_STRIP);
      for (i = 0; i < _numNodesX; i++)
      {
        if ((_nodes[i][j][_numNodesZ-1] != null) && (_nodes[i][j+1][_numNodesZ-1] != null))
        {
          PVector pos1 = _nodes[i][j][_numNodesZ-1].getPosition();
          PVector pos2 = _nodes[i][j+1][_numNodesZ-1].getPosition();

          vertex(pos1.x, pos1.y, pos1.z);
          vertex(pos2.x, pos2.y, pos2.z);
        }
      }
      endShape();
    }

    for (j = 0; j < _numNodesY - 1; j++)
    {
      beginShape(QUAD_STRIP);
      for (k = 0; k < _numNodesZ; k++)
      {
        if ((_nodes[0][j][k] != null) && (_nodes[0][j+1][_numNodesZ-1] != null))
        {
          PVector pos1 = _nodes[0][j][k].getPosition();
          PVector pos2 = _nodes[0][j+1][k].getPosition();

          vertex(pos1.x, pos1.y, pos1.z);
          vertex(pos2.x, pos2.y, pos2.z);
        }
      }
      endShape();
    }

    for (j = 0; j < _numNodesY - 1; j++)
    {
      beginShape(QUAD_STRIP);
      for (k = 0; k < _numNodesZ; k++)
      {
        if ((_nodes[_numNodesX-1][j][k] != null) && (_nodes[_numNodesX-1][j+1][_numNodesZ-1] != null))
        {
          PVector pos1 = _nodes[_numNodesX-1][j][k].getPosition();
          PVector pos2 = _nodes[_numNodesX-1][j+1][k].getPosition();

          vertex(pos1.x, pos1.y, pos1.z);
          vertex(pos2.x, pos2.y, pos2.z);
        }
      }
      endShape();
    }

    for (i = 0; i < _numNodesX - 1; i++)
    {
      beginShape(QUAD_STRIP);
      for (k = 0; k < _numNodesZ; k++)
      {
        if ((_nodes[i][0][k] != null) && (_nodes[i+1][0][k] != null))
        {
          PVector pos1 = _nodes[i][0][k].getPosition();
          PVector pos2 = _nodes[i+1][0][k].getPosition();

          vertex(pos1.x, pos1.y, pos1.z);
          vertex(pos2.x, pos2.y, pos2.z);
        }
      }
      endShape();
    }

    for (i = 0; i < _numNodesX - 1; i++)
    {
      beginShape(QUAD_STRIP);
      for (k = 0; k < _numNodesZ; k++)
      {
        if ((_nodes[i][_numNodesY-1][k] != null) && (_nodes[i+1][_numNodesY-1][k] != null))
        {
          PVector pos1 = _nodes[i][_numNodesY-1][k].getPosition();
          PVector pos2 = _nodes[i+1][_numNodesY-1][k].getPosition();

          vertex(pos1.x, pos1.y, pos1.z);
          vertex(pos2.x, pos2.y, pos2.z);
        }
      }
      endShape();
    }
  }
}
