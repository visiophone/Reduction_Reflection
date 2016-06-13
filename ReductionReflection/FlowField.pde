

class FlowField {

  // A flow field is a two dimensional array of PVectors
  PVector[][] field;
  int cols, rows; // Columns and Rows
  int resolution; // How large is each "cell" of the flow field

  float zoff = 0.0; // 3rd dimension of noise
  
  FlowField(int r) {
    resolution = r;
    // Determine the number of columns and rows based on sketch's width and height
    cols = width/resolution;
    rows = height/resolution;
    field = new PVector[cols][rows];
    update();
  }

  void update() {
    float xoff = 0;
    for (int i = 0; i < cols; i++) {
      float yoff = 0;
      for (int j = 0; j < rows; j++) {
      // float theta = map(noise(xoff,yoff,zoff),0,1,0, map(mouseX, 0, width, 0,10));  // aqui funciona com o mouse
       
       //AUDIO INPUT HEHE
       float theta = map(noise(xoff,yoff,zoff),0,1,0, audioIn);      
        
       theta = theta+PI/2;
        // Make a vector from an angle
        field[i][j] = PVector.fromAngle(theta);      
        yoff += 0.1;
      }
      xoff += 0.1;
    }
    // Animate by changing 3rd dimension of noise every frame
    zoff += 0.01;
  }

  // Draw every vector
  void display() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        drawVector(field[i][j],i*resolution+(width/cols),j*resolution,resolution-2);
      }
    }

  }

  // Renders a vector object 'v' as an arrow and a location 'x,y'
  void drawVector(PVector v, float x, float y, float scayl) {
    pushMatrix();
    float arrowsize = 4;
    // Translate to location to render vector
    translate(x,y);
    stroke(255);
    // Call vector heading function to get direction (note that pointing up is a heading of 0) and rotate
    rotate(v.heading2D());
    // Calculate length of vector & scale it to be bigger or smaller if necessary
    float len = v.mag()*scayl;
    // Draw three lines to make an arrow (draw pointing up since we've rotate to the proper direction)
    stroke(155);
   // fill(255,60);
    line(0,0,len+10,0);
    

    popMatrix();
  }

  PVector lookup(PVector lookup) {
    int column = int(constrain(lookup.x/resolution,0,cols-1));
    int row = int(constrain(lookup.y/resolution,0,rows-1));
    return field[column][row].get();
  }


}