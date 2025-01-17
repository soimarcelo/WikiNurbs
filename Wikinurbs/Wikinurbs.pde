//import nervoussystem.obj.*;  
import processing.serial.*; 
Serial myPort;                                                      //MARTIN STACEY WIKINURBS 2017
boolean record = false;                                                            

void setup() {                                                                      //All setups are refered to the classes pages
  size(1300, 600, P3D);                                                             //This facilitates file swapping
  smooth();
  setuppos();
  setupvar();
  loadfi();
  loadtraind(0, nTotImgs);
  loadtestd(0, nTotImgs);
  setupdr();
  setupnn();
  trainnn(nTotImgs);
  setupft();
  setupsl();
  setupbt();
  setupcb();
  setuprs();
  setupns();
  setupmap();
  setupmi();
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\n');
}
void draw() {
  background(255);
  //printabs();
  drawdr();
  drawnn();
  drawftb();
  drawdis();
  drawsl();
  drawbt();
  drawcb();
  drawrs();
  drawmap();
  pushMatrix();
  actpsl(miorigin, misize, 0);
  if (record) beginRecord("nervoussystem.obj.OBJExport", "mi.obj"); 
  drawmi();
  if (record) {
    endRecord();
    record = false;
  }
  popMatrix();
  actpsl(nsorigin, nssize, 1);
  drawns();
}

void serialEvent(Serial myPort) {
  String inString = myPort.readStringUntil('\n');
  if (inString != null) {
    inString = trim(inString);
    float sensorValue = float(inString);
    sensorValue = map(sensorValue, 0, 1023, 1, 89); // fold angleの範囲が1から89と仮定

    // スライダーの値を更新します。
    sl[0].setValue(sensorValue);
  }
}

void keyPressed() {
  if (key == 'd') {
    loaddraw();
    testnnd();
  }
  if (key == 'e') setupdr();
  if (key == 's') {
    record = true;
    print("saved");
  }
}
void mousePressed() {
  presssl();
  pressbt();
  presscb();
  pressrs();
  pressns();
  pressmap();
}
void mouseReleased() {
  releasesl();
  releasers();
  releasemap();
}

void mouseWheel(MouseEvent event) {
  if (event.getCount()==-1) ns.scrollup();
  if (event.getCount()==+1) ns.scrolldown();
}