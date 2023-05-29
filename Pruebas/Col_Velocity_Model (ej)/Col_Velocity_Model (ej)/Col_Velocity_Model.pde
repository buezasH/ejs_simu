ArrayList<Particula> parts;
Particula p;
int nparts = 0;
Plano plano,plano1;
Boolean g = false;

void setup(){
  size(800,600);
  parts = new ArrayList<Particula>();
  plano = new Plano(new PVector(100,100), new PVector(600,500));
  
  //Ejemplos
  //plano = new Plano(new PVector(500,100), new PVector(600,500));
  //plano = new Plano(new PVector(100,100), new PVector(600,200));
  
  
}

void draw(){  
  
  background(255);
  
  plano.display();
    
  // Particulas
  for(Particula p : parts){
    
    p.update(g);

    if (plano.inside(p.pos))
       plano.draw_box();
       
    plano.collide(p);
   
    Boolean left_side = plano.isLeft(p.pos);
    p.display(left_side);
  }
  
  fill(0);
  text("Numero de particulas= " + nparts ,15,15);
  text("Frame rate =" + frameRate, 15,35);
  text("Gravity =" + g, 15,55);
  
 
}

void keyReleased(){

    if (key == 'n')
      plano.show_normals = !plano.show_normals;
    if (key == 'g')
      g = !g;  

}

void mousePressed(){
  
    p = new Particula(new PVector(random(-50,50),random(-50,50)),new PVector(mouseX, mouseY), 40, nparts);
    parts.add(p);
    nparts++;
  
}
