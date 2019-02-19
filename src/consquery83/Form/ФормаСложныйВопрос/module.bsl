﻿// ссылка на страницу с обработкой: http://1c.proclub.ru/modules/mydownloads/personal.php?cid=120&lid=5964

// Способ вызова:
//		ФормаВопроса=Обработки.СложныйВопрос.ПолучитьФорму("Форма");
//		ФормаВопроса.Параметры.Добавить("Текст вопроса");
//		ФормаВопроса.Параметры.Добавить("Переключатель Имя1","Заголовок 1");
//		ФормаВопроса.Параметры.Добавить("Переключатель Имя2","Заголовок 2",Истина);
//		ФормаВопроса.Параметры.Добавить("Флажок Имя3","Заголовок 3",Истина);
//		ФормаВопроса.Параметры.Добавить("Кнопка Имя4","Заголовок 4");
//		ФормаВопроса.Параметры.Добавить("Кнопка Имя5","Заголовок 5",Истина);
//		Ответ=ФормаВопроса.ОткрытьМодально(Таймаут);
//		Сообщить(?(Ответ=Неопределено,"Неопределено",Ответ));
//
// Параметры:
// Все параметры добавляются в СписокЗначений "Параметры" (реквизит формы)
// 1-ый параметр - текст вопроса (может быть многострочным, перенос по словам не делается)
// Остальные параметры - элементы диалога (все необязательные, но хотя бы 1 кнопка должна быть)
// Элементы диалога добавляются в порядке списка, флажки и переключатели в столбик, кнопки в ряд
// Параметр Элемент диалога:
//   Значение - Строка в формате "Тип Имя". Возможные типы: "Переключатель", "Флажок", "Кнопка"
//   Представление - Заголовок (необязательно). Если не задан, то используется Имя
//   Пометка одного из переключателей - начальное значение (необязательно)
//   Пометка флажка - начальное значение (необязательно)
//   Пометка одной из кнопок - КнопкаПоУмолчанию (необязательно)
// Все переключатели объединяются в 1 группу, первый в списке - ПервыйВГруппе
// Между переключателями не должно быть других элементов
// Все кнопки должны быть в конце списка, между ними не должно быть других элементов
// Если заголовок одной из кнопок "Отмена", тогда форму можно закрыть кнопкой "Х" или "Esc"
// Таймаут - Время показа формы в секундах, по истечении которого форма будет закрыта с параметром закрытия Неопределено.
//   Если значение параметра не задано, время показа не ограничено. Значение по умолчанию: 0
//
// Ответ:
// Если форма закрыта кнопкой "Х" или "Esc" или по Таймауту, тогда возвращается Неопределено
// Иначе строка: имена установленных флажков, текущего переключателя, нажатой кнопки (через ";", в порядке списка)
// Например: "Имя2;Имя4" - Переключатель Имя2, Кнопка Имя4 (Флажок Имя3 не установлен)

Перем Ответ;

Процедура КнопкаНажатие(Кнопка)
	Ответ=";";
	Для каждого Элемент из ЭлементыФормы Цикл
		Если ТипЗнч(Элемент)=Тип("Флажок") Тогда
			Если Элемент.Значение Тогда
				Ответ=Ответ+Элемент.Имя+";";
			КонецЕсли;
		ИначеЕсли ТипЗнч(Элемент)=Тип("Переключатель") Тогда
			Если Найти(Ответ,";"+Переключатель+";")=0 Тогда
				Ответ=Ответ+Переключатель+";";
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Ответ=Сред(Ответ,2)+Кнопка.Имя;
	Закрыть(Ответ);
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Вопрос=Параметры.Получить(0);
	Текст=Вопрос.Значение;
	ТекстВопроса=ЭлементыФормы.ТекстВопроса;
	ТекстВопроса.Заголовок=Текст;
	Если Вопрос.Пометка Тогда
		ТекстВопроса.ЦветТекста=ЦветаСтиля.ТекстВажнойНадписи;
	КонецЕсли;
	МаксШирТ=0; Строк=СтрЧислоСтрок(Текст);
	Для Ном=1 по Строк Цикл
		Стр=СтрПолучитьСтроку(Текст,Ном);
		Шир=СтрДлина(Стр)*6;
		МаксШирТ=Макс(МаксШирТ,Шир);
	КонецЦикла;
	//Ширина=Макс(Ширина,МаксШирТ+30);
	ТекстВопроса.Высота=Строк*14;
	ТекстВопроса.Ширина=МаксШирТ;
	Лево=ТекстВопроса.Лево;
	Верх=ТекстВопроса.Верх+ТекстВопроса.Высота+10;
	ТекТип=""; МаксШир=0; МаксШирК=0;
	Для Ном=1 по Параметры.Количество()-1 Цикл
		Параметр=Параметры.Получить(Ном);
		Имя=Параметр.Значение;
		Пробел=Найти(Имя," ");
		Если Пробел=0 Тогда
			ИмяТипа=Имя;
			Имя=Имя+Ном;
		Иначе
			ИмяТипа=Лев(Имя,Пробел-1);
			Имя=Сред(Имя,Пробел+1);
		КонецЕсли;
		Тип=Тип(ИмяТипа);
		Заг=Параметр.Представление;
		Если Заг="" Тогда
			Заг=Имя;
		КонецЕсли;
		Шир=(СтрДлина(Заг)+4)*6;
		Элемент=ЭлементыФормы.Добавить(Тип,Имя);
		Элемент.Заголовок=Заг;
		Если ИмяТипа="Флажок" Тогда
			Элемент.Значение=Параметр.Пометка;
			Элемент.Лево=Лево;
			Элемент.Верх=Верх;
			Верх=Верх+20;
			Элемент.Ширина=Шир;
			МаксШир=Макс(МаксШир,Шир);
		ИначеЕсли ИмяТипа="Переключатель" Тогда
			Если ИмяТипа<>ТекТип Тогда
				Элемент.ПервыйВГруппе=Истина;
				Элемент.Данные="Переключатель";
				Переключатель=Имя;
			КонецЕсли;
			Элемент.ВыбираемоеЗначениe=Имя;
			Если Параметр.Пометка Тогда
				Переключатель=Имя;
			КонецЕсли;
			Элемент.Лево=Лево;
			Элемент.Верх=Верх;
			Верх=Верх+20;
			Элемент.Ширина=Шир;
			МаксШир=Макс(МаксШир,Шир);
		ИначеЕсли ИмяТипа="Кнопка" Тогда
			Элемент.УстановитьДействие("Нажатие",Новый Действие("КнопкаНажатие"));
			//Элемент.КнопкаПоУмолчанию=Параметр.Пометка;
			Если ИмяТипа<>ТекТип Тогда
				Верх=Верх+5;
				Кнопки=0;
				ТекущийЭлемент=Элемент;
			КонецЕсли;
			Если Параметр.Пометка Тогда
				ТекущийЭлемент=Элемент;
			КонецЕсли;
			Элемент.Лево=Лево;
			Лево=Лево+Шир+8;
			Элемент.Верх=Верх;
			Элемент.Ширина=Шир;
			Элемент.Высота=23;
			Если Заг="Отмена" Тогда
				Ответ=Имя;
			КонецЕсли;
			Кнопки=Кнопки+1;
			МаксШирК=Макс(МаксШирК,Шир);
		КонецЕсли;
		ТекТип=ИмяТипа;
		Параметр.Значение=Имя;
		Параметр.Пометка=Ложь;
	КонецЦикла;
	МаксШирК=Макс(МаксШирК,76);
	ШиринаК=(МаксШирК+8)*Кнопки-8;
	Ширина=Макс(МаксШирТ,МаксШир,ШиринаК)+30;
	Высота=Верх+35;
	Кнопки=0;
	Для каждого Элемент из ЭлементыФормы Цикл
		Если ТипЗнч(Элемент)=Тип("Кнопка") Тогда
			Если Кнопки=0 Тогда
				Лево=Окр((Ширина-ШиринаК)/2,0);
				Кнопки=1;
			КонецЕсли;
			Элемент.Лево=Лево;
			Лево=Лево+МаксШирК+8;
			Элемент.Ширина=МаксШирК;
		ИначеЕсли ТипЗнч(Элемент)=Тип("Надпись") Тогда
			Лево=Окр((Ширина-МаксШирТ)/2,0);
			Элемент.Лево=Лево;
		Иначе
			Лево=Окр((Ширина-МаксШир)/2,0);
			Элемент.Лево=Лево;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если Ответ="" Тогда
		Отказ=Истина;
	КонецЕсли;
КонецПроцедуры


// +++++++++++++++++++++++++++++++++++++
Ответ="";
