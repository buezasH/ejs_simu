PVector _v, _s, f, a, fam;
 
float dt,
      masa,
      Kd,
      g,
      peso,
      Ks,
      Lre_so;
      
void settings()
{
    size(600, 600);

}

void setup() {
    
  textSize(20);
  
  _s = new PVector (0,400);
  fam = new PVector (0,0);
  _v = new PVector(0,0);
  f = new PVector (0, 0);
  a = new PVector (0, 0);
  
  dt = 0.1;
  masa = 5;  
  Kd= 0.1;
  g = 9.8;
  Ks = 0.4;
  Lre_so= 200.0;
    
}
 
void calcular_f(){
   
  fam.y =  -Ks * (_s.y - Lre_so)-(Kd * _v.y);
  f.y =  g * masa + fam.y;
  a.y = f.y / masa;
 
}

void integrador(){ 
  _v.y += a.y * dt;
  _s.y += _v.y * dt;
}
 
void draw() {
   
  background(255);
 
  calcular_f();
  integrador();
      
  stroke(0);
  line(width/2-80, 0, width/2-80, _s.y);
  fill(255, 0, 0);
  ellipse(width/2-80, _s.y, 15, 15);
   
}
 
