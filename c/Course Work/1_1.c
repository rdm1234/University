#include <stdio.h> // Подключение стандартной библиотеки ввода\вывода stido.h
#include <stdlib.h> // Подключение библиотеки stdio.h
#include <math.h> // Подключение математической библиотеки math.h (для работы некотопрых вещей нужно компилировать с ключом -lm)

float sumR(float, int); // Прототип функции

main(){ // Главная функция - main выполняется при старте программы
  float x, lPart, E; // Объявление переменных с плавающей точкой
  int n=1; // int - целочисленное число
  printf("Введите х такое, что |x| < 1\n x = "); // Вывод строки
  while(1){ // Бесконечный цикл, который завершается, если правильно введены данные (если неверные - выводится сообщение об ошибке и требуется ввести заново)
    scanf("%f", &x); // Ввод значения типа float с клавиатуры (присваивается переменной х)
    if(abs(x) < 1) // Если |x| < 1, то цикл прерывается
      break;
    printf("Неверное значение х, введите ещё раз\n x = "); // Если |x| >= 1, то выводится сообщение об ошибке и требуется ввести х заново
  }
  
  printf("Введите точность вычисления выражения\n E = ");
  scanf("%f", &E); // Вводится точность вычислений
  E=fabs(E); // Обрабатывается ошиба при E<0
  
  lPart = powf(M_PI, 2)/8 - M_PI/4*abs(x); // Левая часть выражения
  while(abs(lPart) - abs(sumR(x, n)) > E) n++; // Проверяется сколько слагаемых надо взять, чтобы вычислить выражение с заданной точностью

  printf("Нужно взять %d слагаемых\n", n); // Выводится количество слагаемых
  return 0; // Возвращение 0 в конце функции main используется для проверки правильности работы программы
}

float sumR(float x, int n){ // Функция, вычисляющая значение правой части при заданных х и n
  float s=0; // Сумма
  int i; // Переменная, используемая как счётчик в цикле
  for(i=0; i<n; i++){ // Цикл, выполняющийся пока i<n, i меняется на +1 каждую итерацию (а изначально i = 0)
    s+=cos(3*x/180)/powf(3, 2); // К уже имеющейся сумме прибавляются слагаемые
  }
  return s; // Функция возвращает сумму элементов
}