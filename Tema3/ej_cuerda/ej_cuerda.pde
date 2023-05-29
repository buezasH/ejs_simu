final int NMUELLES = 6;
 
Extremo[] vExtr = new Extremo[NMUELLES+1];
Muelle[] vMuelles = new Muelle[NMUELLES];
final int Tam_Vent_X = 630, Tam_Vent_Y = 100;
float[] vE = new float[Tam_Vent_X];             // Energia del sistema (t)
                 
int lmuelle = 30;                               // Longitud del muelles                    
int t = 0;
 
 
void setup() {
  size(640, 720);
  // Create objects at starting location
  // Note third argument in Spring constructor is "rest length"
  for (int i = 0; i < vExtr.length; i++) {
    vExtr[i] = new Extremo(width*0.5 + i*lmuelle, height*0.3);
  }
  for (int i = 0; i < vMuelles.length; i++) {
    vMuelles[i] = new Muelle(vExtr[i], vExtr[i+1],lmuelle);
  }
}
 
void draw() {
  background(255);
   
  for (Muelle s : vMuelles) {
    s.update();
    s.display();
  }
  
  for (int i = 1; i < vExtr.length; i++){
    vExtr[i].update();
    vExtr[i].display();
  }

}
 
void plot_func(int time, int cx, int cy, int rx, int ry)
{
  stroke(200, 10, 0);
  strokeWeight(3);
  fill(153);
  rect(cx, cy, rx, ry);
  stroke(200, 210, 0);
   
   
  strokeWeight(1);
  stroke(255);
  
  for(int i=0;i<time;i++)
   point (i, Tam_Vent_Y*0.5 - (vE[i]/6.5e5)*Tam_Vent_Y) ;
   
 }
