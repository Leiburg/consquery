﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ МОДУЛЯ

Перем мЭтоКопирование;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	лСписокВыбора = Новый СписокЗначений;
	Для каждого КлючЗначение Из гТипыЗначенийПараметров() Цикл
		лСписокВыбора.Добавить(КлючЗначение.Значение, КлючЗначение.Ключ);
	КонецЦикла; 
	ЭлементыФормы.ПараметрыСписок.Колонки.Тип.ЭлементУправления.СписокВыбора = лСписокВыбора;
	
	мЭтоКопирование = Ложь;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

Процедура КоманднаяПанельФормыЗаполнитьПараметрыИзЗапроса(Кнопка)
	гОбработкаДействийЗаполнитьПараметрыИзЗапроса(ЭтаФорма);
КонецПроцедуры

Процедура КоманднаяПанельФормыОчиститьПараметры(Кнопка)
	Если ПараметрыСписок.Количество()>0 и Вопрос("Удалить ВСЕ параметры?", РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.ОК тогда
		ЭлементыФормы.ПараметрыСписок.Значение.Очистить();    
	КонецЕсли;
КонецПроцедуры

Процедура КоманднаяПанельФормыСоздатьПараметрИзБуфера(Кнопка)
	
	лТекстИзБуфера =  Новый ТекстовыйДокумент;	
	лТекстИзБуфера.УстановитьТекст(гПолучитьСодержимоеБуфера());
	
	Если лТекстИзБуфера.КоличествоСтрок() = 0 Тогда 
		ПоказатьПредупреждение(, "Нет данных в буфере");
		Возврат;
	Иначе
		
		НовыйПараметр = ПараметрыСписок.Добавить();
		
		Если лТекстИзБуфера.КоличествоСтрок() = 1 Тогда 
			НовыйПараметр.Тип = 1;
			лЗначениеПараметра = лТекстИзБуфера.ПолучитьСтроку(1)
		Иначе
			НовыйПараметр.Тип = 2;
			лЗначениеПараметра = Новый СписокЗначений;
			Для сч = 1 По лТекстИзБуфера.КоличествоСтрок() Цикл
				лЗначениеПараметра.Добавить(лТекстИзБуфера.ПолучитьСтроку(сч));
			КонецЦикла;
		КонецЕсли;
		
		НовыйПараметр.Значение = лЗначениеПараметра;
		
	КонецЕсли;
	
	
КонецПроцедуры

Процедура КоманднаяПанельФормыВычислитьИПодставить(Кнопка)
	текТекущаяСтрока = ЭлементыФормы.ПараметрыСписок.ТекущаяСтрока;
	лСтрокаСАлгоритмом = "";
	Если ВвестиСтроку(лСтрокаСАлгоритмом, "Введите алгоритм для расчета значения параметра", ,Истина) Тогда 
		Попытка
			лВычисленноеЗначение = Вычислить(лСтрокаСАлгоритмом);
			текТекущаяСтрока.Тип = 1;
			текТекущаяСтрока.Значение = лВычисленноеЗначение;
		Исключение
			Сообщить("Ошибка расчета значения параметра: " + ОписаниеОшибки());
		КонецПопытки; 
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ ПараметрыСписок


// Обработчик события при начале редактирования строки параметров
//
Процедура ПараметрыСписокПриНачалеРедактирования(Элемент, НоваяСтрока)
	Если НоваяСтрока И мЭтоКопирование <> Истина Тогда 
		Элемент.ТекущаяСтрока.Тип = 1;
		Элемент.ТекущаяСтрока.ИдентификаторСтроки = Новый УникальныйИдентификатор;
	КонецЕсли;
КонецПроцедуры // ПараметрыСписокПриНачалеРедактирования()

// Обработчик события при окончании редактирования строки параметров
//
Процедура ПараметрыСписокПриОкончанииРедактирования(Элемент, НоваяСтрока)

	ВладелецФормы.Модифицированность = Истина;
	мЭтоКопирование                  = Ложь;

КонецПроцедуры // ПараметрыСписокПриОкончанииРедактирования()

// Обработчик события перед удалением строки параметров
//
Процедура ПараметрыСписокПередУдалением(Элемент, Отказ)

	ВладелецФормы.Модифицированность = Истина;

КонецПроцедуры // ПараметрыСписокПередУдалением()

Процедура ПараметрыСписокТипПриИзменении(Элемент)
	
	текТекущаяСтрока = ЭлементыФормы.ПараметрыСписок.ТекущаяСтрока;
	текТип           = текТекущаяСтрока.Тип;
	
	Если текТип = 2 Тогда
		Если Не ТипЗнч(текТекущаяСтрока.Значение) = Тип("СписокЗначений") Тогда
			лЗначениеПараметра = текТекущаяСтрока.Значение;
			текТекущаяСтрока.Значение = Новый СписокЗначений;
			Если лЗначениеПараметра <> Неопределено Тогда
				текТекущаяСтрока.Значение.Добавить(лЗначениеПараметра);
			КонецЕсли;
		КонецЕсли; 
	ИначеЕсли текТип = 3 Тогда
		текТекущаяСтрока.Значение = текТекущаяСтрока.ИмяПараметра;
	Иначе
		Если ТипЗнч(текТекущаяСтрока.Значение) = Тип("СписокЗначений") Тогда
			Если текТекущаяСтрока.Значение.Количество() > 1 Тогда
				текТекущаяСтрока.Значение = текТекущаяСтрока.Значение[0].Значение;
			Иначе
				текТекущаяСтрока.Значение = Неопределено;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ПараметрыСписокТипПриИзменении()

Процедура ПараметрыСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Перем ЭлементСписка;
	
	ЭлементСписка = Элемент.Колонки.Тип.ЭлементУправления.СписокВыбора.НайтиПоЗначению(ДанныеСтроки.Тип);
	
	Если ЭлементСписка <> Неопределено Тогда 
		ОформлениеСтроки.Ячейки.Тип.Текст = ЭлементСписка.Представление;
	КонецЕсли;
	
	ОформлениеСтроки.Ячейки.ГлобальныйПараметр.ОтображатьТекст = Ложь;
	
КонецПроцедуры

Процедура ПараметрыСписокПередНачаломДобавления(Элемент, Отказ, Копирование)
	мЭтоКопирование = Копирование;
КонецПроцедуры


Процедура ПараметрыСписокЗначениеПриИзменении(Элемент)
	лТекущиеДанные = ЭлементыФормы.ПараметрыСписок.ТекущиеДанные;
	Если ТипЗнч(лТекущиеДанные.Значение) = Тип("Дата") Тогда 
		Если лТекущиеДанные.Значение = НачалоДня(КонецМесяца(лТекущиеДанные.Значение)) Тогда 
			ПоказатьВопрос(Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтаФорма, Новый Структура("Режим, ТекущиеДанные", "УстановитьКонецДня", лТекущиеДанные)), "Изменить дату на конец дня?", РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


//////////////////////////////////////////////
// ЗавершенияАсинхронныхВызовов

Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	Если Параметры.Режим = "УстановитьКонецДня" Тогда 
		Если Результат = КодВозвратаДиалога.Да Тогда
			Параметры.ТекущиеДанные.Значение = КонецДня(Параметры.ТекущиеДанные.Значение);
	    КонецЕсли;
	КонецЕсли;
КонецПроцедуры
