#include "setPID.h"

setPID set;

void setup() {
  pinMode(A0, INPUT);
  pinMode(A1, INPUT);
  pinMode(A2, INPUT);
  Serial.begin(115200);
}

void loop() {
  set.parse();
  //set.plot(set.kp() * 10, set.ki() * 10, set.kd() * 10);
  set.plot(analogRead(A0), analogRead(A1), analogRead(A2));
}
