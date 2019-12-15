# Если база данных уже существует, то она удалится
drop database if exists task_1;
# Создание базы данных
create database task_1;
# Использование базы данных
use task_1;

# Удаление таблиц, если они существуют
drop table if exists Учебные_дисциплины;
drop table if exists Учебный_план;
drop table if exists Список_студентов;
drop table if exists Итоги_семестра;

# Создание таблицы
create table Учебные_дисциплины(
	Код_дисциплины int primary key auto_increment,
	Название_дисциплины varchar(30)
);

# Заполнение таблицы
insert into Учебные_дисциплины(Название_дисциплины)
values ('Математический анализ'), ('Информатика'), ('Иностранный язык');

# Создание таблицы
create table Учебный_план(
	НомерГруппы varchar(10),
	Код_дисциплины int,
	Количество_часов_лекции int,
	Количество_часов_практика int,
	Дата_сдачи date,
	primary key (НомерГруппы, Код_дисциплины),
	foreign key (Код_дисциплины) references Учебные_дисциплины(Код_дисциплины)
);

# Заполнение таблицы
insert into Учебный_план(НомерГруппы, Код_дисциплины, Количество_часов_лекции, Количество_часов_практика, Дата_сдачи)
values
	('ИВТ-301', 1, 20, 30, '2014-01-20'),
	('ИВТ-301', 2, 20, 30, '2014-01-15'),
	('ИВТ-301', 3, 0, 40, '2012-12-16'),
	('БУ-101', 1, 20, 20, '2014-01-14'),
	('БУ-101', 2, 30, 60, '2013-12-21');

# Создание таблицы
create table Список_студентов(
	НомерЗачетки int primary key,
	ФИО_студента varchar(30),
	НомерГруппы varchar(10),
	foreign key (НомерГруппы) references Учебный_план(НомерГруппы)
);

# Заполнение таблицы
insert into Список_студентов(НомерЗачетки, ФИО_студента, НомерГруппы)
values
	(12345, 'Иванов Сергей Степанович', 'ИВТ-301'),
	(12487, 'Петров Иван Петрович', 'ИВТ-301'),
	(22222, 'Сидорова Ольга Юрьевна', 'БУ-101'),
	(33333, 'Сараева Елена Васильевна', 'БУ-101');

# Создание таблицы
create table Итоги_семестра(
	НомерЗачетки int,
	Код_дисциплины int,
	Аттестация_зачет int,
	Аттестация_экзамент int,
	primary key (НомерЗачетки, Код_дисциплины),
	foreign key (НомерЗачетки) references Список_студентов(НомерЗачетки),
	foreign key (Код_дисциплины) references Учебные_дисциплины(Код_дисциплины)
);

# Заполнение таблицы
insert into Итоги_семестра(НомерЗачетки, Код_дисциплины, Аттестация_зачет, Аттестация_экзамент)
values
	(12345, 1, null, 5),
	(12345, 2, null, 4),
	(12345, 3, 1, null),
	(12487, 1, null, 3),
	(12487, 3, 1, null),
	(22222, 1, 5, null),
	(22222, 2, null, 3),
	(33333, 1, 4, null);

# Получение исходной таблицы из полученных благодаря нормализации
select C.НомерЗачетки as `№ Зачетки`, ФИО_студента as `ФИО студента`, C.НомерГруппы as `№ группы`, B.Код_дисциплины as `Код дисциплины`, Название_дисциплины as `Название дисциплины`, Количество_часов_лекции as `Количество часов лекций`, Количество_часов_практика as `Количество часов практика`, date_format(Дата_сдачи, '%d-%m-%Y') as `Дата сдачи`, ifnull(Аттестация_зачет, "") as `Аттестация зачет`, ifnull(Аттестация_экзамент, "") as `Аттестация экзамент`
from Учебные_дисциплины as A
inner join Учебный_план as B on A.Код_дисциплины = B.Код_дисциплины
inner join Список_студентов as C on B.НомерГруппы = C.НомерГруппы
inner join Итоги_семестра as D on C.НомерЗачетки = D.НомерЗачетки and D.Код_дисциплины = A.Код_дисциплины
order by C.НомерЗачетки, A.Код_дисциплины;