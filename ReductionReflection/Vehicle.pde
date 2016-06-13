class Vehicle {

  // The usual stuff
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  
  int size;

    Vehicle(PVector l, float ms, float mf) {
    location = l.get();
    r = 3.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0,0);
    velocity = new PVector(0,0);
    
    size=int(random(2,9));
  }

  public void run() {
    update();
    borders();
    if(view)display();
  }

  // Implementing Reynolds' flow field following algorithm
  // http://www.red3d.com/cwr/steer/FlowFollow.html
  void follow(FlowField flow) {
    // What is the vector at that spot in the flow field?
    PVector desired = flow.lookup(location);
    // Scale it up by maxspeed
    desired.mult(maxspeed);
    // Steering is desired minus velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    applyForce(steer);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // Method to update location
  void update() {

   // maxspeed=(map(mouseY,0,height,0,4));
   maxspeed=(map(audioIn,0,50,0,20));
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);

  }

  void display() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);

  // draw the vehicle
    pushMatrix();
    translate(location.x,location.y);   
    rotate(theta);
    
    fill(255);
   
    noStroke();
    ellipse(0,0,size,size);   
     fill(0);
   // rect(0,-5,size,5);
    popMatrix();
    
  }

  // Borders
  void borders() {
    
    if (location.x < -r) {location.x =  width+r; location.x=location.x+(random(-50,50)); }
    if (location.y < -r) {location.y = height+r; location.x=location.x+(random(-50,50)); }
    if (location.x > width+r) {location.x = -r; location.y=location.y+(random(-50,50)); }
    if (location.y > height+r) {location.y = -r; location.x=location.x+(random(-50,50));}
    
  }
}