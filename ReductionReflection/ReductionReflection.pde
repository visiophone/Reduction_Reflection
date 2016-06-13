/*
Code for Reduction/Reflection's audioreactive visuals.
 Made by Rodrigo Carvalho / Visiophone (2016)
 www.visiophone-lab.com
 
 Code build over the "Flow Field" example by
 Daniel Shiffman on "The Nature of Code"
 http://natureofcode.com
  
 Needs Mesh library by Lee Byron http://leebyron.com/mesh/
 Works on Processing 3.0.1
 */

import megamu.mesh.*;

// Menu GUI. Bolleans to change visualizations
boolean debug = false;
boolean view = true;
boolean info=true;
boolean voronoi=false;
boolean lines=true;

FlowField flowfield; // Flowfield object
ArrayList<Vehicle> vehicles; // An ArrayList of vehicles
int nrParticles = 300; // number of elements/particles
float[][] points = new float[nrParticles][2]; // Array for the VORONOI cells

void setup() {
  size(1280, 720);

  // Resolution of the flowfield. nr of cells
  flowfield = new FlowField(50);

  // create the elements in a random position
  vehicles = new ArrayList<Vehicle>();
  for (int i = 0; i < nrParticles; i++) {
    vehicles.add(new Vehicle(new PVector(random(width), random(height)), random(2, 15), random(0.1, 1.5)));
  }

  noCursor(); // hide the mouse

  // INICIATE VORONOY STUFF
  for (int i=0; i<nrParticles; i++) {
    points[i][0]= random(800);
    points[i][1]= random(800);
  }

  //Audiostuff      
  input = new AudioIn(this, 0);  //Create an Audio input and grab the 1st channel
  input.start();// start the Audio Input

  rms = new Amplitude(this); // create a new Amplitude analyze
  rms.input(input);  // Patch the input to an volume analyzer
  input.amp(1.0);

  smooth();
}

void draw() {

  //amplitude stuff
  float analise = map(rms.analyze(), 0, 0.5, 0.0, 50.0);
  audioIn+= (analise-audioIn)*0.01; //smoothing the audioIn vall

  background(0);

  flowfield.update(); // Flowfield update and display 
  if (debug) flowfield.display(); // If debug mode True, display flowfield 

  // Tell all the vehicles to follow the flow field
  for (Vehicle v : vehicles) {
    v.follow(flowfield);
    v.run();
  }

  // DRAWING VORONOI
  int nrVoronois=int(map(mouseY, 0, height, 0, nrParticles));

  //GETTING VEHICLES POSITION TO VORONOI'S POINTS
  for (int i=0; i<vehicles.size(); i++) {   
    points[i][0]= vehicles.get(i).location.x;
    points[i][1]= vehicles.get(i).location.y;
  }

  Voronoi myVoronoi = new Voronoi( points );
  MPolygon[] myRegions = myVoronoi.getRegions();

  for (int i=0; i<nrVoronois; i++)
  {
    // an array of points
    float[][] regionCoordinates = myRegions[i].getCoords();

    fill(int(map(i, 0, nrParticles, 150, 255)));

    //fill(255,int(map(sum[i],0,10,255,0)));  // dar valor do FFT ao interior do voronoi
    if (voronoi) myRegions[i].draw(this); // draw this shape
  }

  float[][] myEdges = myVoronoi.getEdges();

  for (int i=0; i<myEdges.length; i++)

  {
    float startX = myEdges[i][0];
    float startY = myEdges[i][1];
    float endX = myEdges[i][2];
    float endY = myEdges[i][3];
    stroke(255);
    if (lines) line( startX, startY, endX, endY );
  }


// Menu GUI
  if (info) {
    // Instructions
    fill(0, 220);
    stroke(180);
    rect(10, 10, 220, 150);
    fill(255);
    text("FPS: "+frameRate, 20, 30);
    text("VIEW INFO ('i'): "+info, 20, 45);
    text("VIEW FLOWFIELD ('SPACE'): "+debug, 20, 60);
    text("VIEW PARTICLE ('p'): "+view, 20, 75);
    text("VIEW VORONOI REGIONS ('v'):" +voronoi, 20, 90);
    text("VIEW VORONOI LINES ('l'):" +lines, 20, 105);
    text("NR ELEMENTS :"+nrParticles, 20, 135);
  }
}

// Keyboard Interaction
void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
  if (key=='i') {  
    info=!info;
  }
  if (key=='p') {  
    view=!view;
  }
  if (key=='v') {  
    voronoi=!voronoi;
  }
  if (key=='l') {  
    lines=!lines;
  }
  if (key=='r') {
    vehicles.remove(0);
    println(vehicles.size());
  }
  if (key=='a') {   
    vehicles.add(new Vehicle(new PVector(random(width), 0-3), random(2, 5), random(0.1, 0.5)));
    println(vehicles.size());
  }
}