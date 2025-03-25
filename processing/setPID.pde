final int UartSpeed = 115200;       //скорость (115200 и выше)
final String ComPort = "COM3";      //COM-порт (кроме COM1)

import processing.serial.*;

Serial serial;

int received = 0;
final int padding_p = 30;
final int padding_i = 100;
final int padding_d = 170;
final int h = 770;
final int w = 0;
final int k = 10;
int cursor = 0;
String data;
float Kp = 0.0, Ki = 0.0, Kd = 0.0;
int sliderValue_p = 0;
int sliderValue_i = 0;
int sliderValue_d = 0;
String[] values;
final int width = 800;
final int height = 25;
float[] valuesToPlot1 = new float[width];
float[] valuesToPlot2 = new float[width];
float[] valuesToPlot3 = new float[width];
int index = 0;
String inString;
long timer;
boolean stopFlag = false;
boolean plotMode = false;
final int buttonWidth = 200;
final int buttonHeight = 40;
float y1_start, y1_end, y1;
float y2_start, y2_end, y2;
float y3_start, y3_end, y3;
int i = 400;



void setup() {
  size(800, 800);
  frameRate(10);
  serial = new Serial(this, ComPort, UartSpeed);
}

void draw() {
  drawSliders();
  drawButton();
  if (stopFlag != true) {
    while (serial.available() > 0) {
      parse();
    }
  }
  if (millis() - timer >= 500) {
    sending();
  }
  fill(200);
  rect(400, 0, 800, 800);
  if (plotMode == false) {
    drawGraph();
  } else {
    drawGraphInterpol();
  }
  //mousePressed();
}

void sending() {
  data = Kp + "," + Ki + "," + Kd + "\n";
  serial.write(data);
}

void drawSliders() {
  textAlign(LEFT);
  background(#6B817A);
  noStroke();
  fill(#F3F7DE);
  textSize(30);
  text("настройка PID", 100, 40);

  Kp = float(sliderValue_p) / k;
  Ki = float(sliderValue_i) / k;
  Kd = float(sliderValue_d) / k;

  fill(150);
  rect(100, 100 + padding_p, 200, 20, 20, 20, 20, 20);
  rect(100, 100 + padding_i, 200, 20, 20, 20, 20, 20);
  rect(100, 100 + padding_d, 200, 20, 20, 20, 20, 20);
  fill(#000000);
  if (cursor == 1) {
    fill(#800000);
  }
  rect(90 + sliderValue_p, 90 + padding_p, 20, 40, 20, 20, 20, 20);
  fill(#000000);
  if (cursor == 2) {
    fill(#008000);
  }
  rect(90 + sliderValue_i, 90 + padding_i, 20, 40, 20, 20, 20, 20);
  fill(#000000);
  if (cursor == 3) {
    fill(#000080);
  }
  rect(90 + sliderValue_d, 90 + padding_d, 20, 40, 20, 20, 20, 20);
  fill(0);
  textSize(16);
  text("коэффициент P: " + Kp, 135, 80 + padding_p);
  text("коэффициент I: " + Ki, 135, 80 + padding_i);
  text("коэффициент D: " + Kd, 135, 80 + padding_d);
}

void mouseDragged() {
  if (mouseX > 100 && mouseX < 300 && mouseY > 90 + padding_p && mouseY < 130 + padding_p) {
    sliderValue_p = constrain(mouseX - 100, 0, 200);
    cursor = 1;
  } else if (mouseX > 100 && mouseX < 300 && mouseY > 90 + padding_i && mouseY < 130 + padding_i) {
    sliderValue_i = constrain(mouseX - 100, 0, 200);
    cursor = 2;
  } else if (mouseX > 100 && mouseX < 300 && mouseY > 90 + padding_d && mouseY < 130 + padding_d) {
    sliderValue_d = constrain(mouseX - 100, 0, 200);
    cursor = 3;
  } else {
    cursor = 0;
  }
}

void parse() {
  inString = serial.readStringUntil('\n');

  if (inString != null) {
    values = split(trim(inString), ',');
    if (values.length == 3) {
      valuesToPlot1[index] = float(values[0]);
      valuesToPlot2[index] = float(values[1]);
      valuesToPlot3[index] = float(values[2]);

      index = (index + 1) % width;
    }
  }
}

void drawGraphInterpol() {
  for (i = 400; i < width; i++) {

    y1_start = height + h - valuesToPlot1[(index + i - 1) % (width + w)] * ((height + h) / 1023.0);
    y1_end = height + h - valuesToPlot1[(index + i) % (width + w)] * ((height + h) / 1023.0);
    y1 = lerp(y1_start, y1_end, 0.1);

    y2_start = height + h - valuesToPlot2[(index + i - 1) % (width + w)] * ((height + h) / 1023.0);
    y2_end = height + h - valuesToPlot2[(index + i) % (width + w)] * ((height + h) / 1023.0);
    y2 = lerp(y2_start, y2_end, 0.1);

    y3_start = height + h - valuesToPlot3[(index + i - 1) % (width + w)] * ((height + h) / 1023.0);
    y3_end = height + h - valuesToPlot3[(index + i) % (width + w)] * ((height + h) / 1023.0);
    y3 = lerp(y3_start, y3_end, 0.1);

    stroke(#ff0000);
    line(i - 1, y1_start, i, y1);
    stroke(#009000);
    line(i - 1, y2_start, i, y2);
    stroke(#0000ff);
    line(i - 1, y3_start, i, y3);
  }
}

void drawGraph() {
  for (i = 400; i < width; i++) {
    stroke(#ff0000);
    line(i - 1, height + h - valuesToPlot1[(index + i - 1) % (width + w)] * ((height + h) / 1023.0),
      i, height + h - valuesToPlot1[(index + i) % (width + w)] * ((height + h) / 1023.0));
    stroke(#009000);
    line(i - 1, height + h - valuesToPlot2[(index + i - 1) % (width + w)] * ((height + h) / 1023.0),
      i, height + h - valuesToPlot2[(index + i) % (width + w)] * ((height + h) / 1023.0));
    stroke(#0000ff);
    line(i - 1, height + h - valuesToPlot3[(index + i - 1) % (width + w)] * ((height + h) / 1023.0),
      i, height + h - valuesToPlot3[(index + i) % (width + w)] * ((height + h) / 1023.0));
  }
}

void drawButton() {
  fill(200);
  rect(100, 400, buttonWidth, buttonHeight, 20, 20, 20, 20);
  rect(100, 450, buttonWidth, buttonHeight, 20, 20, 20, 20);
  fill(0);
  textSize(16);
  textAlign(CENTER, CENTER);
  if (stopFlag  == false) {
    text("остановить", 100 + buttonWidth / 2, 400 + buttonHeight / 2);
  } else {
    text("возобновить", 100 + buttonWidth / 2, 400 + buttonHeight / 2);
  }
  if (plotMode  == false) {
    text("включить интерполяцию", 100 + buttonWidth / 2, 450 + buttonHeight / 2);
  } else {
    text("выключить интерполяцию", 100 + buttonWidth / 2, 450 + buttonHeight / 2);
  }
}

void mousePressed() {
  if (mouseX > 100 && mouseX < 100 + 200 &&
    mouseY > 400 && mouseY < 400 + 50) {
    stopFlag = !stopFlag;
    print("stop ");
    println(stopFlag);
  } else if (mouseX > 100 && mouseX < 100 + 200 &&
    mouseY > 450 && mouseY < 450 + 50) {
    plotMode = !plotMode;
    println("mode");
  }
}
