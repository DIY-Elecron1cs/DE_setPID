#pragma once

class setPID {
  public:
    void parse() {
      if (Serial.available() > 0) {
        String data = Serial.readStringUntil('\n');
        int firstComma = data.indexOf(',');
        int secondComma = data.indexOf(',', firstComma + 1);

        if (firstComma > 0 && secondComma > firstComma) {
          _Kp = data.substring(0, firstComma).toFloat();
          _Ki = data.substring(firstComma + 1, secondComma).toFloat();
          _Kd = data.substring(secondComma + 1).toFloat();
        }
      }
    }

    void plot(uint16_t n1, uint16_t n2, uint16_t n3) {
      Serial.print(n1);
      Serial.print(',');
      Serial.print(n2);
      Serial.print(',');
      Serial.println(n3);
    }

    float kp() {
      return _Kp;
    }

    float ki() {
      return _Ki;
    }

    float kd() {
      return _Kd;
    }

  private:
    float _Kp, _Ki, _Kd;
};
