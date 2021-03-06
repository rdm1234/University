drop database if exists var_14_2;
create database var_14_2;
use var_14_2;

drop table if exists Продукты;
drop table if exists Список_продуктов;
drop table if exists Накладные;

create table Продукты(
Номенклатурный_номер int primary key auto_increment,
Наименование_продукта varchar(20) not null,
Единицы_измерения varchar(10) not null
);

alter table Продукты auto_increment = 100;

create table Накладные(
Номер_накладной int primary key,
Дата_оформления date,
Кому_Должность varchar(20) not null,
Кому_ФИО varchar(30) not null,
От_Должность varchar(20) not null,
От_ФИО varchar(30) not null
);

create table Список_продуктов(
Номер_накладной int,
Номенклатурный_номер int,
Количество int not null,
Цена_за_ед int not null,
primary key (Номер_накладной, Номенклатурный_номер),
foreign key (Номенклатурный_номер) references Продукты(Номенклатурный_номер) on update cascade on delete no action,
foreign key (Номер_накладной) references  Накладные(Номер_накладной) on update cascade on delete no action
);

insert into Продукты(Наименование_продукта, Единицы_измерения)
values
('Картошка', 'кг'),
('Морковка', 'кг'),
('Свёкла', 'кг'),
('Сигареты', 'пачки'),
('Сок виноградный', 'литры'),
('Яблоки', 'кг');

insert into Накладные(Номер_накладной, Дата_оформления, Кому_должность, Кому_ФИО, От_должность, От_ФИО)
values
(1001, '2013-12-20', 'Зав.складом', 'Иванова С.П', 'Шеф повар', 'Сидоров П.В'),
(1002, '2014-01-23', 'Экспедитор', 'Фролов Ю.Б.', 'Зав.складом', 'Иванова С.П.');

insert into Список_продуктов(Номер_накладной, Номенклатурный_номер, Количество, Цена_за_ед)
values
(1001, 100, 20, 25),
(1001, 101, 5, 28),
(1001, 104, 12, 45),
(1001, 102, 3, 18),
(1002, 100, 120, 28),
(1002, 103, 100, 200);

drop user if exists 'administrator1';
drop user if exists 'director';
drop user if exists 'worker';
drop user if exists 'visitor';

# 3
create user 'administrator1' identified by 'adm_pass';
create user 'director' identified by 'dir_pass';
create user 'worker' identified by 'wor_pass';
create user 'visitor';

# 4
grant all privileges on var_14_2.* to 'administrator1';
#revoke grant option on var_14_2.* from 'administrator1';

# 5
grant all privileges on var_14_2.* to 'director';
grant grant option on var_14_2.* to 'director';
revoke create, drop on var_14_2.* from 'director';

# 6
grant insert, delete, update, select 
	on Продукты to 'worker';
grant insert, update(Кому_Должность, Кому_ФИО, От_Должность, От_ФИО), select 
	on Накладные to 'worker';
grant insert, select, update(Количество, Цена_за_ед) 
	on Список_продуктов to 'worker';

# 7
create view temp as select A.Номер_накладной, Дата_оформления, C.Номенклатурный_номер, Наименование_продукта, Единицы_измерения, Цена_за_ед
from Накладные as A
inner join Список_продуктов as B on A.Номер_накладной = B.Номер_накладной
inner join Продукты as C on B.Номенклатурный_номер = C.Номенклатурный_номер;

# 8
grant select on var_14_2.temp to 'visitor';

flush privileges;