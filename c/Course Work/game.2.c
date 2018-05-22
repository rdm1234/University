// Подключение библиотек
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
// Прототипы функций
// generate() отвечает за генерацию и вывод самого выражения, а также возвращает ответ
float generate(int, int, int);
// generate_level() генерирует входные данные для функции generate() в зависимости от выбранного уровня сложности
int generate_level(int*, int*, int*);
void generate_params();
// Значение функции используется в формуле генерации чисел выражения
int range(int, int);
// show_element() используется для вывод каждого элемента в функции generate() (если число отрицательное, ставит скобки)
void show_element(float);

// Функция main - "главная функция программ", она выполняется при запуске программы
int main(){
  // Генерация случайных чисел теперь зависит от системного времени
  srand(time(NULL));
  // Объявление переменных
  /* ifParams - переменная, задаваемая польлзователем в начале каждой игры:
     если равна 1, то пользователь выбирает уровень сложности;
     если равна 2, то пользователь задаёт параметры генерации вручную.
     ifEnd - переменная, задаваемая пользователем в конце каждой игры, если равна 0, то игра заканчивается.
     games - количество игр.
     points - количество очков по итогам всех игр.
     level - уровень сложности, который выбрал пользователь
   */
  int ifParams, ifEnd=0, games=0, points=0, level;
  /* from, to - от скольки до скольки будут генерироваться числа
     elementsAmount - количество элементов в генерируемом выражении
   */
  int from, to, elementsAmount;
  /* result - ответ выражения
     answer - вводимый пользователем ответ
   */
  float result, answer;

  // Бесконечный цикл, выход из которого будет осуществляться через оператор break
  // Использую его для возможности играть сколько угодно раз подряд, не запуская программу заново, при этом суммируются очки
  while(1){
    // Сначала выводится количество очков и количество сыгранных игр
    printf(" Кол-во очков: %d\n Кол-во игр: %d\n\n", points, games);
    // Пользователь выбирает способ генерации выражения
    printf("Если хотите задать параметры вручную введите 1, если хотите просто выбрать уровень сложности введите 2\n");
    scanf("%d", &ifParams);
    // Если он ввёл 2, то он выбирает уровень сложности, иначе он задаёт параметры вручную
    if(ifParams==2){
      // в функцию передаются ссылки на элементы, поскольку требуется, чтобы она меняла значения элементов, а не их копий
      level = generate_level(&from, &to, &elementsAmount);
    }
    else {
      // Пользователь вводит количество чисел в выражении
      printf("Введите количество чисел в выражении (введите 0, чтобы сгенерировать случайное число)\n");
      scanf("%d", &elementsAmount);
      // Если пользователь ввёл 0, генерируется число от 1 до 10 включительно
      if(elementsAmount == 0)
	elementsAmount = rand()%10+1;
      // Если пользователь воодит количество элементов < 0, то берётся модуль от этого числа
      if(elementsAmount < 0)
	elementsAmount = abs(elementsAmount);
      
      // Пользователь вводит какие числа будут генерироваться (с проверкой неверно введённых данных - если числа равны или если первое больше второго)
      do{
	printf("Числа будут генерироваться от from до to\nn = ");
	scanf("%d", &from);
	printf("m = ");
	scanf("%d", &to);
      } while(from == to || from > to);
      
    }

    /* Переменной result присваивается значение, возвращаемое функцией generate()
       Пользователь может ввести либо точный ответ, либо округлённый по обычным математическим правилам - и тот, и тот зачтётся
       Если пользователь ответил верно - ему зачисляться очки в зависимости от сложности выражения (уровень сложности + 1, а если самый сложный +1000)
       Если пользователь отвечает неверно, то кол-во очков уменьшается и выводится ответ (Количество очков не может опуститься ниже 0)
     */
    result = generate(elementsAmount, from, to);
    printf("Введите ответ (при желании можно округлить)\n");
    scanf("%f", &answer);
    if(answer==roundf(result) || answer == result){
      points+=level+1;
      if(level==5){
	printf("ok, you can\n");
	points+=994;
      }
      printf("Верно!\n");
    }

    else{
      points--;
      printf("Неверно. Ответ: %.3f\n", result);
    }
    if(points<0)
      points=0;
    // Пользователь выбирает продолжать ли игру
    printf("Кол-во очков: %d\nВведите 0, чтобы закончить игру или 1, чтобы продолжить\n", points);
    scanf("%d", &ifEnd);
    // Если пользователь вводит 0, цикл прерывается с помощью оператора break
    if(ifEnd == 0)
      break;
    games++;
    printf("\033[2J");// Очищает экран (как system('clean'))
  }

  return 0;
}

int generate_level(int *fP, int *tP, int *elAmP){
  int level;
  printf("Выберите уровень сложности\n 0 - very easy\n 1 - easy\n 2 - medium\n 3 - hard\n 4 - impossible\n 5 - you can't do this\n");
  scanf("%d", &level);
  switch(level){
  default:
    level = 0;
    *fP=rand()%100-50;
    *tP=rand()%100+51;
    *elAmP=rand()%6+2;
    break;
  case 0:
    *fP=0;
    *tP=10;
    *elAmP=2;
    break;
  case 1:
    *fP=0;
    *tP=100;
    *elAmP=3;
    break;
  case 2:
    *fP=-100;
    *tP=100;
    *elAmP=3;
    break;
  case 3:
    *fP=-500;
    *tP=500;
    *elAmP=5;
    break;
  case 4:
    *fP=-1000;
    *tP=1000;
    *elAmP=10;
    break;
  case 5:
    *fP=-1000;
    *tP=1000;
    *elAmP=100;
    printf("Ну ладно, попробуем (Подсказка: если не можете найти 0, посчитайте минусы)\n\n");
  }
  return level;
}

float generate(int elementsAmount, int from, int to){
  float result=0, element[2];
  int i, *signArr, r;
  // Переменной R присваивается число, получаемое в функции range()
  r=range(from, to);

  // под signArr выделяется пямять = количеству элементов в массиве, умноженному на размер типа int
  signArr = (int *)malloc((elementsAmount)*sizeof(int));
  // Это будет использоваться для последней итерации цикла
  signArr[elementsAmount-1]=-1; 
  /* Генерация чисел от 1 до 5
     1 - сложить
     2 - вычесть
     3 - умножить
     4 - разделить
     5 - возвести в степень (мб извлечь корень)
  */
  for(i = 0; i < elementsAmount-1; i++)
    signArr[i] = rand()%5+1;

  for(i = 1; i < elementsAmount; i++){
    if(signArr[i] > 2 && signArr[i-1] < 3)
      printf("(");
  }
  
  for(i = -1; i < elementsAmount; i++){
    element[0]=rand()%r - abs(from);
    if(signArr[i] == 4 && element[0] == 0)
      element[0]++;
    if(i==-1){
      result=element[0];
      if(signArr[0]>2)
	printf("(");
      show_element(result);
      continue;
    }
    if(signArr[i] > 2 && signArr[i-1] < 3)
      printf(")");     
    switch(signArr[i]){
    case 1:
      printf(" + ");
      result+=element[0];
      break;
    case 2:
      printf(" - ");
      result-=element[0];
      break;
    case 3:
      printf(" * ");
      result*=element[0];
      break;
    case 4:
      printf(" / ");
      result/=element[0];
      break;
    case 5:
      // Ввиду того, что довольно сложно считать в уме большие степени, а также того, что в результате получатся огромные числа,
      // я сделал только степени 0, 0.5, 2
      switch(rand()%3){
      case 0:
	element[0]=0;
      case 1:
	element[0]=0.5;
      case 2:
	element[0]=2;
      }
      printf(" ^ ");
      result=powf(result, element[0]);
      break;
    case -1:
      printf(" = ? \n");
    }
    if(signArr[i]==-1)
      break;
    show_element(element[0]);
    
    element[1]=element[0];
  }
  return result;
}
void show_element(float element){
   if(element<0)
      printf("(");
    printf("%.2f", element);
    if(element<0)
      printf(")");
    
}
int range(int n, int m){
  if(n<0 && m<0)
    return abs(n)-abs(m);
  else
    return m-n;
}
