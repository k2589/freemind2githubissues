Процедура НастроитьКоманду(Знач Команда, Знач Парсер) Экспорт

	// Добавление параметров команды
	// Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "ИмяПараметра", "Описание параметра");
	Парсер.ДобавитьПозиционныйПараметрКоманды(Команда, "файл", "Файл freemind (*.mm) или xml файл нужной стркутры");
	// Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "ИмяПараметра", "Описание параметра");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-u", "Владелец репозитория");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-r", "Репозиторий");
	Парсер.ДобавитьИменованныйПараметрКоманды(Команда, "-k", "Apikey пользователя с доступом на пуш в репозиторий");
	// Парсер.ДобавитьПараметрФлагКоманды(Команда, "ИмяПараметра", "Описание параметра");
	// Парсер.ДобавитьПараметрКоллекцияКоманды(Команда, "ИмяПараметра", "Описание параметра");
	// Парсер.ДобавитьИменованныйПараметрКоллекцияКоманды(Команда, "ИмяПараметра", "Описание параметра");

КонецПроцедуры // НастроитьКоманду

// Выполняет логику команды
// 
// Параметры:
//   ПараметрыКоманды - Соответствие - Соответствие ключей командной строки и их значений
//   Приложение - Модуль - Модуль менеджера приложения
//
Функция ВыполнитьКоманду(Знач ПараметрыКоманды, Знач Приложение) Экспорт
	
	ТЗсДаннымиИзКарты = ВТаблицу(ПараметрыКоманды["файл"]);
	МассивДляПреобразования = ТЗВМассивСтруктур(ТЗсДаннымиИзКарты);

	ОтправитьНаСервер(МассивДляПреобразования, ПараметрыКоманды["-u"], ПараметрыКоманды["-r"], ПараметрыКоманды["-k"]);

	//ВызватьИсключение "Не реализовано";

	// При успешном выполнении возвращает код успеха
	Возврат Приложение.РезультатыКоманд().Успех;
	
КонецФункции // ВыполнитьКоманду

Функция ВТаблицу(Файл)

	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(Файл); 	
	Счетчик = 0;

	ТЗ =  Новый ТаблицаЗначений();
	ТЗ.Колонки.Добавить("title");
	ТЗ.Колонки.Добавить("body");

	Пока ЧтениеXML.Прочитать() Цикл
	Если ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента И ЧтениеXML.Имя = "node" Тогда
		Счетчик = Счетчик - 1;
			Если Счетчик = 2 Тогда
				ТекущаяСтрока = ТЗ.Добавить();
			ИначеЕсли Счетчик = 4 Тогда
				ТекущаяСтрока.body = ЧтениеXML.ЗначениеАтрибута("TEXT");
			КонецЕсли;
	ИначеЕсли ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента И ЧтениеXML.Имя = "node" Тогда
		Счетчик = Счетчик + 1;
			Если Счетчик = 2 Тогда 
				ТекущаяСтрока = ТЗ.Добавить();
			ИначеЕсли Счетчик = 3 Тогда 
				ТекущаяСтрока.title = ЧтениеXML.ЗначениеАтрибута("TEXT");
			ИначеЕсли Счетчик = 4 Тогда
				ТекущаяСтрока.body = ЧтениеXML.ЗначениеАтрибута("TEXT");
			КонецЕсли;
	КонецЕсли;
	КонецЦикла;

	Стр = ТЗ.Количество();
	Пока Стр > 0 Цикл
		Если ПустаяСтрока(ТЗ[Стр-1].title) Тогда
			ТЗ.Удалить(Стр-1);
		КонецЕсли;
		Стр = Стр - 1;
	КонецЦикла;

	Возврат ТЗ;
КонецФункции

Функция ТЗВМассивСтруктур(ТЗ)
	Массив = Новый Массив();
	Для Каждого Строка Из ТЗ Цикл
		Массив.Добавить(Новый Структура("title, body", Строка.title, Строка.body));
	КонецЦикла;
	Возврат Массив;
КонецФункции

Функция СтруктураВJson(Структура)
	
	ЗаписьJSON = Новый ЗаписьJSON();
	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON( , Символы.Таб);
	ЗаписьJSON.УстановитьСтроку(ПараметрыЗаписи);
	ЗаписатьJSON(ЗаписьJSON, Структура);
	Возврат ЗаписьJSON.Закрыть();

КонецФункции

Функция АпиСоздатьЗадачи(TasksJson, Пользователь, Репозиторий, ТокенАвторизации)

	ИмяСервера = "https://api.github.com";
	// URL = "orgs/" + ПараметрыПодключения.Организация + "/repos";
	// POST /repos/:owner/:repo/issues
	URL = СтрШаблон("/repos/%1/%2/issues", Пользователь, Репозиторий);
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Accept", СтрШаблон("application/vnd.github.v%1+json", 3));
	Заголовки.Вставить("User-Agent", "oscript");
	Заголовки.Вставить("Authorization", СтрШаблон("token %1", ТокенАвторизации));
	

	HTTPЗапрос = Новый HTTPЗапрос(URL, Заголовки);
	HTTPЗапрос.УстановитьТелоИзСтроки(TasksJson);
	HTTP = Новый HTTPСоединение(ИмяСервера, 443,,,,,,Ложь);
	Попытка
		ОтветHTTP = HTTP.Post(HTTPЗапрос);
	Исключение
		Сообщить("Какие-то проблемы с АПИ, может быть стоит подумать над их обработкой?");
	КонецПопытки;
	ОтветОтГитХаб = ОтветHTTP.ПолучитьТелоКакСтроку();
	Возврат ОтветОтГитХаб;
	
КонецФункции

Функция ОтправитьНаСервер(МассивДляПреобразования, Пользователь, Репозиторий, ТокенАвторизации)
	Для Каждого Стр из МассивДляПреобразования Цикл
		Сообщить(СтруктураВJson(Стр));
		Сообщить(АпиСоздатьЗадачи(СтруктураВJson(Стр), Пользователь, Репозиторий, ТокенАвторизации));
		Приостановить(2500);
	КонецЦикла;
КонецФункции



