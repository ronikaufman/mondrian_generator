// By Roni Kaufman

int thickness = 8; // thickness of the lines between the cubes

int[][] colors = {{0, 0, 0}, {255, 255, 255}, {0, 0, 250}, {255, 200, 0}, {250, 0, 0}}; // colors used, including black and white
int nbColors = colors.length; // number of colors
float[] probColors = new float[5]; // probabilities of applying each color to a rectangle, the sum of its elements must be equal to 1.0
float[] startingProbColors = {0.01, 0.81, 0.06, 0.06, 0.06}; // starting probabilities
float[] probReducingColors = {0.8, 0.1, 0.5, 0.5, 0.5}; // gives how the probabilities for each color evolve every time we use them (the closest to 1, the more we'll reduce)

float probFactor = 0.7; // factor to multiply the probability of division with when we call the function mondrianRecursion recursively


void setup() {
  size(800, 800);
  arrayCopy(startingProbColors, probColors);
  noLoop();
}


void draw() {
  background(0);
  mondrianRecursion(width-thickness, height-thickness, thickness/2, thickness/2, 1.0, (random(2)<1));
} 


void keyPressed() {
  if (key == ' ') { // generate new image
    arrayCopy(probColors, startingProbColors);
    redraw();
  } else if (key == 's') { // save image
    String timestamp = getTimestamp();
    save("mondrian_" + timestamp + ".jpg");
  }
}


/* Draws a generated Mondrian-style picture recursively
   w the width, h the height, (x,y) the top-left corner
   prob the probability to divide this rectangle into 2 new rectangles
   vertical = true if we must divide vertically, false if horizontally */

void mondrianRecursion(int w, int h, int x, int y, float prob, boolean vertical) {
  if (random(1) < prob) { // we must divide again
    if (vertical) {
      int wDivision = (int)(random(w*0.3, w*0.7));
      mondrianRecursion(wDivision, h, x, y, prob*probFactor, false);
      mondrianRecursion(w-wDivision, h, x+wDivision, y, prob*probFactor, false);
    } else {
      int hDivision = (int)(random(h*0.3, h*0.7));
      mondrianRecursion(w, hDivision, x, y, prob*probFactor, true);
      mondrianRecursion(w, h-hDivision, x, y+hDivision, prob*probFactor, true);
    }
  } else { // we must draw a rectangle in the zone
    int idx = chooseColor();
    newProbColors(idx);
    fill(colors[idx][0], colors[idx][1], colors[idx][2]);
    rect(x+thickness/2, y+thickness/2, w-thickness, h-thickness);
  }
}


/* Choose a color randomly using the probability distribution of probColors */

int chooseColor() {
  float r = random(1), sum = 0;
  int i = 0;
  while (sum <= r) {
    sum += probColors[i++];
  }  
  return i-1;
}


/* Changes probColors during the execution in order not to have too much of a certain color
   Reduces the probability of the last used color and redistributes it uniformly to all the others */

void newProbColors(int i) {
  float x = probColors[i] * probReducingColors[i];
  for (int k = 0; k < nbColors; k++) {
    if (i == k) {
      probColors[k]=probColors[k] - x; // decrease this probability
    } else {
      probColors[k]=probColors[k] + x/(nbColors-1); // increase all the other ones
    }
  }
}


/* Returns a timestamp of the form [year][month][day][hour][minute][second] 
   its length is always 14 */

String getTimestamp() {
  String yea = String.valueOf(year());
  String mon = String.valueOf(month());
  if (mon.length() == 1) {
    mon = "0" + mon;
  }
  String day = String.valueOf(day());
  if (day.length() == 1) {
    day = "0" + day;
  }
  String hou = String.valueOf(hour());
  if (hou.length() == 1) {
    hou = "0" + hou;
  }
  String min = String.valueOf(minute());
  if (min.length() == 1) {
    min = "0" + min;
  }
  String sec = String.valueOf(second());
  if (sec.length() == 1) {
    sec = "0" + sec;
  }
  
  String s = yea + mon + day + hou + min + sec;
  return s;
}
