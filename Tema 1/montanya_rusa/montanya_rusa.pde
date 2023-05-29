float frequency = PI * 6.9; // Variables para el muestreo de la función coseno
float amplitude = 100; // Variables para el muestreo de la función seno
int numSegments = 30;// Variable que indica el número de tramos

ArrayList<PVector> points = new ArrayList<PVector>(); // Lista de puntos por los que pasa el objeto
PVector currentPos, currentVel, currentAcc;
PVector point1, point2;

int currentSegment = -1;

float         SIM_STEP = .02;   // dt = Simulation time-step (s)
float         _simTime;

void settings()
{
    size(600, 600);
}

void setup() {

  point1 = new PVector(width/10, 0);
  point2 = new PVector();

  for (int i = 0; i < numSegments; i++) {
    point1 = new PVector(point1.x, point1.y);
    point2 = new PVector(point2.x, point2.y);

    if (i != 0) {
      point1.x += frequency;
      point1.y = cos(point1.x) * amplitude;
    }

    point2.x = point1.x + frequency + 2 * cos(PI/2);
    point2.y = cos(point2.x) * amplitude;

    points.add(point1);
  }
  points.add(point2);

  // Marcamos como posición inicial el primer punto
  currentPos = points.get(0);
}

void draw() {

  translate(0, height/2);

  // Calcular el tramo actual
  for (int i = 0; i < numSegments; i++) {
    if (currentPos.x < points.get(i + 1).x) {
      // Si estamos cambiando de tramo
      if (currentSegment != i) {
        currentSegment = i;

        point1 = points.get(currentSegment);
        point2 = points.get(currentSegment + 1);

        currentVel = PVector.sub(point2, point1);
        currentVel.normalize();
        currentVel.mult(30);
        currentAcc = PVector.div(currentVel, 1);
      }     
      break;
    }
  }

  currentVel = PVector.add(PVector.mult(currentAcc, SIM_STEP), currentVel);
  currentPos = PVector.add(PVector.mult(currentVel, SIM_STEP), currentPos);

  ellipse(currentPos.x, currentPos.y, 10, 10);
}
