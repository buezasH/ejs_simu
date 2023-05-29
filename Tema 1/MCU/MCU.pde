float r = 250;
float theta = 0;
float dt;
float tiempoAnterior;

void setup() {
  size(600, 600);
  tiempoAnterior = millis();
}

void draw() {
  background(200);
  
  // Calculamos el tiempo transcurrido desde el último dibujo
  float tiempoActual = millis();
  dt = (tiempoActual - tiempoAnterior) / 1000.0; // convertimos a segundos
  tiempoAnterior = tiempoActual;
  
  // Calculamos la nueva posición de la bola
  theta += 2 * PI * dt;
  float x = width/2 + r * cos(theta);
  float y = height/2 + r * sin(theta);
  
  // Dibujar la circunferencia
  noFill();
  strokeWeight(2);
  stroke(0);
  ellipse(width/2, height/2, r*2, r*2);
  
  // Dibujar el punto central
  fill(0, 255, 0);
  strokeWeight(1);
  stroke(0);
  ellipse(width/2 , height/2 , 10, 10);
  
  // Dibujamos la bola
  fill(255, 0, 0);
  strokeWeight(1);
  stroke(0);
  ellipse(x, y, 20, 20);
  
  // Mostramos el tiempo de simulación en la pantalla
  fill(0);
  textAlign(RIGHT);
  text("Tiempo de simulación: " + nf(millis() / 1000.0, 0, 2) + " s", width - 10, height - 10);
}
