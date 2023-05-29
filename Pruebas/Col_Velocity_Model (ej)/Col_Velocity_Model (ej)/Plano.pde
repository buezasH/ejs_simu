class Plano{
  PVector a;
  PVector b;
  PVector ab;
  PVector n1, n2;
  Boolean show_normals;
  
  Plano(PVector _a,PVector _b)  {
    a = _a.copy();
    b = _b.copy();
    ab = PVector.sub(b,a);
    
    //n1 = 
    //n2 = 
    
    show_normals = false;
  }
   
  Boolean inside(PVector x){
    return false;
        
}

  public Boolean isLeft(PVector c){ 
    return ((b.x - a.x)*(c.y - a.y) - (b.y - a.y)*(c.x - a.x)) > 0; 
  }


  void collide(Particula p)
  {
     PVector n;
     
     if (inside(p.pos)){
       
       if (isLeft(p.pos))
         n = n1;
       else
         n = n2;
       
     }
  }
  
  void display()
  {
    stroke(100);
    line(a.x,a.y,b.x,b.y);
    if (show_normals){
      int m = 100;
      stroke(200,0,0);
      line(a.x, a.y, a.x+n1.x*m, a.y+n1.y*m);
      stroke(0,0,200);
      line(b.x, b.y, b.x+n2.x*m, b.y+n2.y*m);
    }
  }
  
  void draw_box(){
  
    fill(200,20);
    rect(a.x,a.y, ab.x, ab.y);  
  }
  
}
