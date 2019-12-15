drop database if exists task_3;
create database task_3;
use task_3;

drop table if exists Продукты;
drop table if exists Рецепты_блюд;
drop table if exists Ингредиенты;

create table Продукты(
	НомерПозиции int primary key,
	Наименование_продукта varchar(20) not null,
	Единицы_измерения varchar(10) not null
);

create table Рецепты_блюд(
	НомерРецепта int primary key,
	Название_блюда varchar(30) not null,
	Количество_ингредиентов int not null
);

create table Ингредиенты(
	НомерРецепта int,
	НоменклатурныйНомер int,
	Количество float,
	primary key(НомерРецепта, НоменклатурныйНомер),
	foreign key (НомерРецепта) references Рецепты_блюд(НомерРецепта) on update cascade on delete cascade,
	foreign key (НоменклатурныйНомер) references Продукты(НомерПозиции) on update cascade on delete cascade
);

insert into Продукты(НомерПозиции, Наименование_продукта, Единицы_измерения)
values
	(100,'Мидии', 'кг'),
	(101,'Лук', 'кг'),
	(102,'Сыр', 'граммы'),
	(103,'Майонез', 'кг'),
	(105,'Кальмары', 'кг'),
	(106,'Яйцо куриное', 'шт.'),
	(107,'Огурец соленый', 'кг'),
	(108,'Яблоки', 'кг'),
	(109,'Дыня', 'кг');

insert into Рецепты_блюд(НомерРецепта, Название_блюда, Количество_ингредиентов)
values
	(101, 'Салат с кальмарами', 0),
	(103, 'Жульен с мидиями', 0);

insert into Ингредиенты
values
	(103, 100, 0.340),
	(103, 101, 0.100),
	(103, 102, 0.080),
	(103, 103, 0.100),
	(101, 105, 0.300),
	(101, 106, 3),
	(101, 107, 0.150),
	(101, 108, 0.300);

# 2	Хранимую функцию, которая используя данные из таблицы «Ингредиенты», подсчитывает общее количество ингредиентов, входящих в указанный рецепт блюда
delimiter $$
create procedure getIngerdientCount(in НомерВыбранногоРецепта int, inout Количество_ингредиентов int)
begin
	select count(НоменклатурныйНомер) as Количество_ингредиентов into Количество_ингредиентов
	from Рецепты_блюд A
	inner join Ингредиенты B on A.НомерРецепта = B.НомерРецепта
	where A.НомерРецепта = НомерВыбранногоРецепта
	group by A.НомерРецепта;
end $$
delimiter ;

# 3	Запрос на обновление данных в таблице «Рецепты блюд», который использует хранимую функцию, созданную в предыдущем пункте, для заполнения полей в столбце «Количество ингредиентов» по всем записям таблицы «Рецепты блюд».
set @recipe_num = 101;
call getIngerdientCount(@recipe_num, @count);
update Рецепты_блюд set Количество_ингредиентов = @count where НомерРецепта = @recipe_num;
set @recipe_num = 103;
call getIngerdientCount(@recipe_num, @count);
update Рецепты_блюд set Количество_ингредиентов = @count where НомерРецепта = @recipe_num;

# Cоздать триггеры, которые срабатывают при изменении данных в таблице «Ингредиенты», а именно:
# 4 при удалении записи из таблицы «Ингредиенты» требуется уменьшить на единицу значение в соответствующем поле столбца «Количество ингредиентов» таблицы «Рецепты блюд»;
delimiter $$
create trigger decreaseIngredientCountOnIngredientDelete 
	before delete 
on Ингредиенты 
for each row 
begin
	update Рецепты_блюд
	set Количество_ингредиентов = Количество_ингредиентов - 1
	where НомерРецепта = OLD.НомерРецепта;
end $$

# 5	при добавлении записи в таблицу «Ингредиенты» требуется увеличить на единиц значение соответствующего поля столбца «Количество ингредиентов» таблицы «Рецепты блюд»;
create trigger increaseIngredientCountOnIngredientInsert
	after insert
on Ингредиенты
for each row
begin
	update Рецепты_блюд
	set Количество_ингредиентов = Количество_ингредиентов + 1
	where НомерРецепта = NEW.НомерРецепта;
end $$

# 6	при обновлении записи в таблице «Ингредиенты» требуется выполнить пункт 1 для необновленной (старой) записи таблицы «Ингредиенты», а затем выполнить пункт 2 для обновленной (новой) записи таблицы «Ингредиенты».
create trigger updateIngredientCountOnIngredientUpdate
	after update
on Ингредиенты
for each row 
begin
	update Рецепты_блюд
	set Количество_ингредиентов = Количество_ингредиентов - 1
	where НомерРецепта = OLD.НомерРецепта;
	update Рецепты_блюд
	set Количество_ингредиентов = Количество_ингредиентов + 1
	where НомерРецепта = NEW.НомерРецепта;
end $$

delimiter ;

# Проверка
-- select * from Ингредиенты;
-- select * from Рецепты_блюд;
-- insert into Ингредиенты 
-- values
-- 	(103, 109, 0.340);
-- select * from Ингредиенты;
-- select * from Рецепты_блюд;
-- delete from Ингредиенты where НоменклатурныйНомер = 103;
-- select * from Ингредиенты;
-- select * from Рецепты_блюд;
-- update Ингредиенты set НомерРецепта = 103 where НоменклатурныйНомер = 105;
-- select * from Ингредиенты;
-- select * from Рецепты_блюд;

# 7	Создать пользователей: administrator (администратор), director (директор), worker (работник) и visitor (посетитель)
drop user if exists 'administrator1';
drop user if exists 'director';
drop user if exists 'worker';
drop user if exists 'visitor';

create user 'administrator1' identified by 'adm_pass';
create user 'director' identified by 'dir_pass';
create user 'worker' identified by 'wor_pass';
create user 'visitor';

# 8	Назначить пользователю administratorвсе права доступа, в том числе создания новых таблиц, их модификации и удаления, кроме создания новых и удаления существующих баз данных и таблиц.
grant all privileges on task_3.* to 'administrator1';
revoke create, drop on var_14_2.* from 'administrator1';

# 9	Назначить пользователю director все права доступа ко всем существующим таблицам, в том числе созданию новых пользователей, их модификации и удаления, кроме создания новых баз данных, таблиц, их модификации и удаления.
grant all privileges on var_14_2.* to 'director';
grant grant option on var_14_2.* to 'director';
revoke create, drop, update on var_14_2.* from 'director';

# 10 Назначить пользователю worker следующие права доступа:
# •	к таблице «Продукты» по созданию, просмотру и обновлению записей;
grant insert, update, select 
	on Продукты to 'worker';

# •	к таблице «Рецепты блюд» по созданию, просмотру и обновлению записей, кроме поля «№ рецепта», к которому доступ ограничить только созданием и просмотром;
grant create, select, update (Название_блюда)
	on Рецепты_блюд to 'worker';

# •	к таблице «Ингредиенты» по созданию, просмотру записей, в том числе обновлению поля «Количество»;
grant create, select, update (Количество)
	on Ингредиенты to 'worker';

# 11 Создать представление (виртуальную таблицу), содержащую следующие поля: «№ рецепта», «Название блюда», «Наименование продукта», «Единицы измерения», «Количество».
create view temp as select A.НомерРецепта, Название_блюда, Наименование_продукта, Единицы_измерения, Количество
from Ингредиенты A
inner join Рецепты_блюд B on A.НомерРецепта = B.НомерРецепта
inner join Продукты C on A.НоменклатурныйНомер = C.НомерПозиции;

# 12 Назначить права доступа visitor только к данному представлению на просмотр.
grant select on task_3.temp to 'visitor';

flush privileges;