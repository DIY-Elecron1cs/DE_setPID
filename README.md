# DE_setPID
настройщик ПИД регулятора по UART

- [Processing](#Processing)
- [Arduino](#Arduino)

![setPID](https://github.com/DIY-Elecron1cs/DE_setPID/blob/main/images/image-setPID1.png?raw=true)

## Processing
### функционал
- программа на [Processing](https://github.com/DIY-Elecron1cs/DE_setPID/blob/main/processing/setPID.pde) включает в себя 3 слайдера для настройки коэффициентов ПИД от 0 до 20 с интервалом в 0.1;
- имеется встроенный плоттер для отображения графиков;
- есть функция остановки (заморозки) графика;
- есть функция интерполяции графика, позволяет отслеживать быстроту изменения значений.
### использование
- в строках 1 и 2 нужно указать скорость передачи и текущий COM-порт (кроме COM1)
- на скорости меньше 115200 бод может зависать!

Если при открытии программы график не отображается – попробуйте перезагрузить Arduino/ESP.

![interpolation](https://github.com/DIY-Elecron1cs/DE_setPID/blob/main/images/interpolation.png?raw=true)

## Arduino
Настройщик включает в себя мини-библиотеку для Arduino для удобной работы по Serial:
### подключение и инициализация
```cpp
#include "setPID.h"
setPID;
```
### использование
```cpp
void parse();                                        //парсинг (коэффициентов ПИД)
void plot(uint16_t n1, uint16_t n2, uint16_t n3);    //отправка значений на плоттер
float kp();                                          //возвращает пропорциональный коэффициент
float ki();                                          //возвращает интегральный коэффициент
float kd();                                          //возвращает дифференциальный коэффициент
```
### пример
```cpp
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
```
