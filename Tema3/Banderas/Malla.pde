//Clase Malla: Define la estructura y actualiza las fuerzas que actúan sobre ella

class Malla
{
  int tipo; 
  PVector p[][]; // Matriz de vértices
  PVector f[][]; //Matriz de fuerzas
  PVector a[][]; //Matriz de aceleraciones
  PVector v[][]; //Matriz de velocidades
  
  int sizeX, sizeY; //Dimensiones de la malla
  
  float distDirecta; //Longitud entre vértices directos en reposo
  float distOblicua; //Longitud entre vértices diagonales en reposo
  
  float k; //Constante de muelles entre vértices
  float m_Damping; //Amortiguación en los muelles (Relación con fuerza de fricción)
  
  
  //Constructor
  Malla (int t, int x, int y)
  {
    tipo = t;
    sizeX = x;
    sizeY = y;
    
    p = new PVector[sizeX][sizeY]; //vector de posición
    f = new PVector[sizeX][sizeY]; //vector de fuerzas
    a = new PVector[sizeX][sizeY]; //vector de aceleración
    v = new PVector[sizeX][sizeY]; //vector de velocidad
    
    distDirecta = 3;
    distOblicua = sqrt(2* (distDirecta*distDirecta));
    
    //Se ajusta la elasticidad y el damping dependiendo del tipo de malla
    switch (tipo)
    {
      case 1: 
        k = 400;
        m_Damping = 3;
      break;
      
      case 2: 
        k = 150;
        m_Damping = 2;
      break;
      
      case 3: 
        k = 300;
        m_Damping = 2;
      break;
    }
    
    for (int i = 0; i < sizeX; i++)
    {
      for (int j = 0; j < sizeY; j++)
      {
        p[i][j] = new PVector (i*distDirecta, j*distDirecta,0);
        f[i][j] = new PVector (0,0,0);
        a[i][j] = new PVector (0,0,0);
        v[i][j] = new PVector (0,0,0);
      }
    }
    
  }

  void display(color c)
  {
    fill(c);
    for(int i = 0; i < sizeX-1; i++){
      beginShape(QUAD_STRIP);
      for(int j = 0; j < sizeY; j++){
        PVector p1 = p[i][j];
        PVector p2 = p[i+1][j];
        vertex(p1.x, p1.y, p1.z);
        vertex(p2.x, p2.y, p2.z);
      }
      endShape();
    }
    
  }
  
  //Actualiza mediante euler simpléctico se actualizan las posiciones y velocidades
  void update()
  {
    actualizaFuerzas();
    for (int i = 0; i < sizeX; i++)
    {
      for (int j = 0; j < sizeY; j++)
      {
        a[i][j].add(f[i][j].x*dt, f[i][j].y*dt, f[i][j].z*dt);
        v[i][j].add(a[i][j].x*dt, a[i][j].y*dt, a[i][j].z*dt);
        p[i][j].add(v[i][j].x*dt, v[i][j].y*dt, v[i][j].z*dt);
        
        if((i==0 &&  j==0) || (i==0 && j== sizeY-1))
        {
          f[i][j].set(0,0,0);
          v[i][j].set(0,0,0);
          p[i][j].set(i*distDirecta, j*distDirecta, 0);
        }
        a[i][j].mult(0);
      }
    }
  }

  void actualizaFuerzas()
  {
    PVector v_Damping = new PVector (0,0,0);
    
    for (int i = 0; i<sizeX; i++)
    {
      for (int j = 0; j < sizeY; j++)
      {
        f[i][j].set(0,0,0);
        PVector vertexPos = p[i][j];
        
        //Fuerza externa de la gravedad
        f[i][j].set(g.x,g.y,g.z);
        
        //Fuerza externa del viento
        PVector fViento = getfViento(vertexPos, i, j);
        f[i][j] = PVector.add(f[i][j], fViento);
        
        //Fuerzas internas --> según el tipo de estructura actuará de una forma u otra
        
        switch(tipo)
        {
          case STRUCTURED:
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-1, j, distDirecta, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+1, j, distDirecta, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j-1, distDirecta, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j+1, distDirecta, k));
          
          break;
          
          case BEND:
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-1, j, distDirecta, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+1, j, distDirecta, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j-1, distDirecta, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j+1, distDirecta, k));
            
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-2, j, distDirecta*2, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+2, j, distDirecta*2, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j-2, distDirecta*2, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j+2, distDirecta*2, k));
          
          break;
          
          case SHEAR:
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-1, j, distDirecta, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+1, j, distDirecta, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j-1, distDirecta, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i, j+1, distDirecta, k));
            
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-1, j-1, distOblicua, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i-1, j+1, distOblicua, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+1, j-1, distOblicua, k));
            f[i][j] = PVector.add(f[i][j], getForce(vertexPos, i+1, j+1, distOblicua, k));
          
          break;
        }
        
        //Fuerza damping = -v*kr --> fuerza de amortiguamiento
        v_Damping.set(v[i][j].x, v[i][j].y, v[i][j].z);
        v_Damping.mult(-m_Damping);
        
        f[i][j] = PVector.add(f[i][j], v_Damping); 
      }
      
    }
  }
  
  PVector getfViento(PVector v, int i, int j)
  {
    PVector fuerza = new PVector(0,0,0);
    PVector normal1 = new PVector(0,0,0);
    PVector normal2 = new PVector(0,0,0);
    PVector normal3 = new PVector(0,0,0);
    PVector normal4 = new PVector(0,0,0);
    PVector normal = new PVector(0,0,0);
    float proyeccion;
    
    normal1 = getNormal(v, i-1, j, i, j-1);
    normal2 = getNormal(v, i-1, j, i, j+1);
    normal3 = getNormal(v, i, j+1, i+1, j);
    normal4 = getNormal(v, i+1, j, i, j-1);
    
    int cont = 0;
    
    if (normal1.mag() >0)
      cont++;
    
    if (normal2.mag() >0)
      cont++;
    
    if (normal3.mag() >0)
      cont++;
    
    if (normal4.mag() >0)
      cont++;

    normal1 = PVector.add(normal1, normal2);
    normal3 = PVector.add(normal3, normal4);
    normal = PVector.add(normal1, normal3);
    
    normal.div(cont);
    normal.normalize(); //Se debe normalizar el vector que indica la normal
    
    proyeccion = normal.dot(viento); //proyectamos la normal sobre el viento, y esa será la fuerza
                                    ///que aplica la velocidad del viento a las banderas
    fuerza.set(abs(proyeccion*viento.x), (proyeccion*viento.y), (proyeccion*viento.z));
    
    return fuerza;
    
  }
  
  PVector getNormal (PVector v, int a, int b, int c, int d)
  {
    PVector n = new PVector (0,0,0);
    
    if (a >= 0 && a <= sizeX-1 && b>=0 && b<=sizeY-1 && c>=0 && c<=sizeX-1 && d>=0 && d<= sizeY-1)
    {
      PVector v1 = PVector.sub(p[a][b], v);
      PVector v2 = PVector.sub(p[c][d], v);
      n = v1.cross(v2); //Obtenemos el vector perpendicular (normal) mediante el producto vectorial 
    }
    
    return n;
  }

  PVector getForce(PVector VertexPos, int i, int j,  float m_Distance, float k){

    PVector force = new PVector(0.0, 0.0, 0.0);
    PVector distancia = new PVector(0.0, 0.0, 0.0);
    float elongacion = 0.0;
    
    if (i >= 0 && i < sizeX && j >= 0 && j < sizeY) 
    {
      distancia = PVector.sub(VertexPos, p[i][j]); 
      
      elongacion = distancia.mag() - m_Distance;   /// s = e.mag() - l_reposo    ---> x
      
      distancia.normalize(); // e.normalize() = _eN
      
      force = PVector.mult(distancia, -k * elongacion); //cálculo de fuerza elástica  --> (_eN) * (K*s)
    }
    else{
      force.set(0.0, 0.0, 0.0);
    }
    
    return force;
  }
  
  
  
}
