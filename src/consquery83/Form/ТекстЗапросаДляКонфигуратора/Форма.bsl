﻿///////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	Попытка
		ТекстЗапросаПеременная = ТекстЗапроса.ПолучитьТекст();
		УстановитьТекстЗапросаВБуферОбмена(ТекстЗапросаПеременная);
	Исключение
	КонецПопытки;	
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Текст = Параметры.ТекстЗапроса;
	ТекстЗапроса.УстановитьТекст(СформироватьТекстЗапросаДляКонфигуратора(Текст));
КонецПроцедуры


///////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция СформироватьТекстЗапросаДляКонфигуратора(Текст)
	ВозврЗнач = """";
	Текст = Параметры.ТекстЗапроса;
	ПереводСтроки = Символы.ВК+Символы.ПС;
	Для Счетчик = 1 По СтрЧислоСтрок(Текст) Цикл
		ТекСтрока = СтрПолучитьСтроку(Текст, Счетчик);
		Если Счетчик > 1 Тогда 
			ТекСтрока = СтрЗаменить(ТекСтрока,"""","""""");
			ВозврЗнач = ВозврЗнач + ПереводСтроки + "|"+ ТекСтрока;
		Иначе	
			ТекСтрока = СтрЗаменить(ТекСтрока,"""","""""");
			ВозврЗнач = ВозврЗнач + ТекСтрока;
		КонецЕсли;	
	КонецЦикла;
	ВозврЗнач = ВозврЗнач + """";
	Возврат ВозврЗнач;
КонецФункции	

&НаКлиенте
Процедура УстановитьТекстЗапросаВБуферОбмена(Текст)
    ОбъектКопирования = Новый COMОбъект("htmlfile");
    ОбъектКопирования.ParentWindow.ClipboardData.Setdata("Text", Текст);
КонецПроцедуры 