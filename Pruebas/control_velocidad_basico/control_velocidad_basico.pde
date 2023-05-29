int radio = 50;
PVector pos,vel;
float tam_vel = 5;
float dt = 0.3;
float modulo_vel = 10;

void setup(){
  size(600,600);
  pos = new PVector(width/2, height/2);
  vel = new PVector(1,0);
  vel.normalize();
  vel.mult(modulo_vel);
}

void draw(){
  background(255);
  
  stroke (0,0,100); //cambia el color de la barra
  strokeWeight(3);
  fill(200);
  ellipse(pos.x, pos.y, radio, radio);
  
  stroke (200,0,0); //cambia el color de la barra
  strokeWeight(2);
  line(pos.x, pos.y, pos.x + vel.x * tam_vel, pos.y + vel.y * tam_vel);
  
  //Actualizamos la posicion a vel constante
  pos.add(PVector.mult(vel, dt));
  
  //Actualizamos la vel a partir del mouse
  PVector mouse = new PVector(mouseX,mouseY);
  vel = PVector.sub(mouse,pos);
  vel.normalize();
  vel.mult(modulo_vel);
   
  // Limites:
  if(pos.x > width)
    pos.x = 0;
  
  
}
