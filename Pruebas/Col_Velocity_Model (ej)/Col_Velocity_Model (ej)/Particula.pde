class Particula{
  PVector acc;
  PVector vel;
  PVector pos;
  float rad;
  float dt = 0.02;  
  PVector grav = new PVector(0,9.8);
  int id;
  
   int r;
   int g;
   int b;
  
  Particula(PVector v,PVector p, float rd, int i)  {
    acc = new PVector();
    vel = v;
    pos = p;
    rad = rd;
    id = i;
    
    r = (int)random(255);
    g = (int)random(255);
    b = (int)random(255);
  }
  
  void update(Boolean g){
    
    if (g)
      addForce(grav);    
    
   // Integrar ...
    
    if(pos.x+rad/2 > width)
      vel.x*=-1;
    if(pos.x-rad/2 < 0)
      vel.x*=-1;
    if(pos.y+rad/2 > height)
      vel.y*=-1;
    if(pos.y-rad/2 < 0)
      vel.y*=-1; 
      
    checkCollision();
    acc = new PVector();
  }
  
  void addForce(PVector f){
    acc = PVector.add(acc,f);
  }  
  
  void checkCollision(){
    
  }
  
   void collisionPart(Particula p){
   
  }
  
  void display(Boolean side) 
  { 
    stroke(0);
    if (side)
      fill(200,0,0);
    else
      fill(0,0,200);
      
    ellipse(pos.x, pos.y, rad, rad);
  }
}
