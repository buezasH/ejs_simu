class HeightMap
{
  private final int mapSize;
  private final float cellSize;
  
  private float initPos[][][];
  private float pos [][][];
  private float tex[][][]; //Vector de textura
  
  protected ArrayList<Wave> waves;
  
  private Wave waveArray[];
  
  
  public HeightMap(int mSize, float cSize){
    mapSize = mSize;
    cellSize = cSize;
    
    initGridPositions();
    initTextValues();
    
    waves = new ArrayList<Wave>();
    waveArray = new Wave[0];
  }
  
  //Inicialización de las posiciones de la malla
  private void initGridPositions()
  {
    float startPos = -mapSize * cellSize/2f;
    pos = new float[mapSize][mapSize][3]; 
    initPos = new float[mapSize][mapSize][3];
    
    
    for (int i = 0; i < mapSize; i++)
    {
      for (int j = 0; j < mapSize; j++)
      {
        pos[i][j][0] = startPos + j * cellSize; //X
        pos[i][j][1] = 0; //Y --> //La posición de cada nodo se situará en el plano XZ 
        pos[i][j][2] = startPos + i * cellSize; //Z
       
        //Posición inicial de cada nodo
        initPos[i][j][0] = pos[i][j][0];
        initPos[i][j][1] = pos[i][j][1];
        initPos[i][j][2] = pos[i][j][2];
        
      }
    }
  
  }
  
  private void initTextValues()
  {
    tex = new float [mapSize][mapSize][2]; //Inicialización de textura en plano XZ
    float mapSizeCasted = (float)mapSize;
    
    
    for (int i = 0; i <mapSize; i++)
    {
      for (int j = 0; j < mapSize; j++)
      {
        tex[i][j][0] = j/mapSizeCasted*image.width;
        tex[i][j][1] = i/mapSizeCasted*image.height;
      }
    }
    
  }
  
  public void update()
  {
    waveArray = waves.toArray(waveArray);
    
    //Declaraciones
    PVector variation;
    float time = millis()/1000f;
    
    //Iteración sobre los arrays de posición según la variación de la onda 
    for (int i = 0; i < mapSize; i++)
    {
      for (int j = 0; j < mapSize; j++)
      {
        //Resetear posiciones
        pos[i][j][0] = initPos[i][j][0];
        pos[i][j][1] = initPos[i][j][1];
        pos[i][j][2] = initPos[i][j][2];
        
        //Iterate through waves
        for ( int k = 0; k < waveArray.length; k++)
        {
          waveArray[k].setTime(time);
          variation = waveArray[k].calculateVariation(pos[i][j][0], pos[i][j][1], pos[i][j][2]);
          pos[i][j][0] += variation.x;
          pos[i][j][1] += variation.y;
          pos[i][j][2] += variation.z;
         
        }
        
      }
    }  
  
  }
  
  //Dibujado de la malla con la textura
  public void present(){
    noStroke();
    for (int i = 0; i < mapSize-1; i++) {
      beginShape(QUAD_STRIP);
      texture(image);
      for (int j = 0; j < mapSize; j++) {
        vertex(pos[i][j][0], pos[i][j][1], pos[i][j][2], tex[i][j][0], tex[i][j][1]);
        vertex(pos[i+1][j][0], pos[i+1][j][1], pos[i+1][j][2], tex[i+1][j][0], tex[i][j][1]);
      }
      endShape();
    }
  }
  
  //Dibujado de la malla sin textura: visualización de cada nodo
  public void presentWired(){
    stroke(0, 0, 0);
    for (int i = 0; i < mapSize-1; i++) {
      for (int j = 0; j < mapSize-1; j++) {
        line(pos[i][j][0], pos[i][j][1], pos[i][j][2], pos[i+1][j][0], pos[i+1][j][1], pos[i+1][j][2]);
        line(pos[i][j][0], pos[i][j][1], pos[i][j][2], pos[i][j+1][0], pos[i][j+1][1], pos[i][j+1][2]);
        line(pos[i][j][0], pos[i][j][1], pos[i][j][2], pos[i+1][j+1][0], pos[i+1][j+1][1], pos[i+1][j+1][2]);
      }
    }
  }
  
  //Añade una ola al array que almacena las ondas
  void addWave(boolean clean,Wave wave){
    if(clean){
      this.waves.clear();
      waveArray = new Wave[0];
    }
    this.waves.add(wave);
  }
  
  void adjustValuesWave(float amp, float L, float vp)
  {
    for(Wave w: waves)
      {
        w._amplitude += amp;
        w.wLength += L;
        w.velo += vp;
      }
  }
  
  void display()
  {
    if(_viewmode) 
      presentWired();
    else 
      present();
  }
  
  
  void run(){
    display();
    update();
  }  
}
