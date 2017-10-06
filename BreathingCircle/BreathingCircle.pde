import themidibus.*; //Import the library
int time = 64;
Dot mydot;
Breather lung1;
Breather lung2;
Breather lung3;
Breather lung4;
Breather lung5;
Breather lung6;
Breather lung0;

MidiBus myBus; // The MidiBus
float curpitch = 50;
float curvel = 0;
float curcut = 60;
float curdet =0;
float detscale;
float cutscale;
float zoomscale;
float zfact =.1;
color c;
color l2c;
color l3c;
color l4c;
color l5c;
color l6c;
color l0c;
float h;
float s;
float easer=.5;
float b;




void setup() {
  colorMode(HSB);


  lung1 = new Breather(width/2,height/2,315, 0, 15, 100,1,-1); //black lung
  lung2 = new Breather(width/2,height/2, 450, l2c, 3, 200,-1,1); //big lung
  lung3 = new Breather(width/2,height/2, 530, l3c, 16, 300,.5,-.5); //bigger lung
  lung4 = new Breather(width/2,height/2, 640, l4c, 5, 400,-.5,.5);
  lung5 = new Breather(width/2,height/2, 720, l5c, 11, 500,1,1);
  lung6 = new Breather(width/2,height/2, 1000, l6c, 4, 600,-1,1);
  lung0 = new Breather(width/2,height/2, 55, l0c, 3, 45,.2,.2); //tiny center lung
  
  
  size(1000, 800);
  background(255);
  mydot = new Dot(c);


  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
  myBus = new MidiBus(this, 0, 1); // Create a new MidiBus with no input device and the default Java Sound Synthesizer as the output device.
}

void draw() {
  //rectMode(CENTER);
  fill(75, 100);
  rect(0, 0, width, height);
  noStroke();
  
  ellipseMode(CENTER);
  translate(0,0);
  scale(zoomscale);
  translate(0,0);
  
  detscale = map(curvel, 0, 127, 0, 100);
  //cutscale = map(curcut, 0, 127, 0, 1);

  colorMode(HSB);
  h = map(curpitch, 48, 71, 0, 360);
  s = map(curcut, 0, 127, 0, 300);
  c = color(h, s, 240);
  
  l2c = color(h+100, s-50, 200);
  l3c = color(h-50, s, curpitch+100);
  l4c = color(h,s,240);
  l5c = color(h-200, s, 310);
  l6c = color(h, s, 190);
  
  l0c = color(h+30, s-20, 280);
  
  lung6.c = l6c;
  lung6.breathe();
  lung6.drawcirc();
  
  lung5.c = l5c;
  lung5.breathe();
  lung5.drawcirc();
  
  colorMode(RGB);
  lung4.c = 255;
  lung4.breathe();
  lung4.drawcirc();
  colorMode(HSB);
  
  
  
  lung3.c = l3c;
  lung3.breathe();
  lung3.drawcirc();
  
  lung2.c = l2c;
  lung2.breathe();
  lung2.drawcirc();
  
  
  lung1.breathe();
  lung1.drawcirc();
  
  
  
  
  
  colorMode(RGB);
  fill(255);
  colorMode(HSB);
  ellipse(width/2 +((detscale-width/2)/easer), height/2 -((detscale-width/2)/easer) , 200, 200);
  fill(c);
  ellipse(width/2 -detscale, height/2 +detscale, 150, 150);
  
  lung0.c = l0c;
  lung0.breathe();
  lung0.drawcirc();
  
  fill(255);
  ellipse(width/2 -detscale*1.5,height/2 +detscale*.5, 40,40);
  
  zoomscale+=zfact;
  
  if(zoomscale > 2){
    zfact =-.005;
  }
  
  if(zoomscale < 1){
    zfact =.005;
  }
  
  println(zoomscale);
  
}


void noteOn(int channel, int pitch, int velocity) {
  curpitch = pitch;
  curvel= velocity;
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
  fill(255);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
  if(number == 21){
    curcut = value;
  println("cutoff:" + curcut);
  }
  if(number == 22){
    curdet = value;
  }
    
    
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}

class Dot {
  color c;

  Dot(color tempc) {
    c=tempc;
  }

  void drawdot() {
    colorMode(HSB);
    fill(c);
    ellipse(width/2, height/2, 200, 200);
  }
}

class Breather{
  float xpos;
  float ypos;
  int size;
  color c;
  float freqmax;
  float radius;
  float angle;
  float breatherate;
  float x;
  float xoff;
  float yoff;

  
  Breather(float tempxp, float tempyp, int tempsize, color tempc, float tempfreqm, float temprad, float tempxoff, float tempyoff){
    xpos = tempxp;
    ypos = tempyp;
    size = tempsize;
    c= tempc;
    freqmax = tempfreqm;
    radius = temprad;
    xoff = tempxoff;
    yoff = tempyoff;
      
  }
  
  void breathe(){
  float frequency = map(curpitch, 48, 71, 0, freqmax); 
  x = breatherate + cos(radians(angle))*(radius);
  angle -= frequency;
  //size*=cutscale;
  
  }
  
  void drawcirc(){
  fill(c);
  ellipse(xpos + ((detscale*xoff)/easer),ypos + ((detscale*yoff)/easer),x + size,x + size);
  
  }
  
  void drawsquare(){
  fill(c);
  rect(xpos,ypos,x+ size,x + size);
  }
  
  
  
  
  
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}