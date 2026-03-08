component = require('component')

-- Турбины

-- Адреса турбин
turbine = {
	'',
	'',
	'',
	''
	}

-- Импортируем адреса турбин
turbine_1_address = component.get(turbine[1])
turbine_2_address = component.get(turbine[2])
turbine_3_address = component.get(turbine[3])
turbine_4_address = component.get(turbine[4])

-- Импортируем турбины
turbine_1 = component.proxy(turbine_1_address)
turbine_2 = component.proxy(turbine_2_address)
turbine_3 = component.proxy(turbine_3_address)
turbine_4 = component.proxy(turbine_4_address)

-- Основной цикл

while true do
	
	-- Импортируем данные турбин
	turbine_1_power, turbine_1_status, turbine_1_fuel, turbine_1_max_fuel, turbine_1_lubricant, turbine_1_max_lubricant, turbine_1_water, turbine_1_max_water, turbine_1_steam, turbine_1_max_steam = turbine_1.getInfo()
	turbine_2_power, turbine_2_status, turbine_2_fuel, turbine_2_max_fuel, turbine_2_lubricant, turbine_2_max_lubricant, turbine_2_water, turbine_2_max_water, turbine_2_steam, turbine_2_max_steam = turbine_2.getInfo()
	turbine_3_power, turbine_3_status, turbine_3_fuel, turbine_3_max_fuel, turbine_3_lubricant, turbine_3_max_lubricant, turbine_3_water, turbine_3_max_water, turbine_3_steam, turbine_3_max_steam = turbine_3.getInfo()
	turbine_4_power, turbine_4_status, turbine_4_fuel, turbine_4_max_fuel, turbine_4_lubricant, turbine_4_max_lubricant, turbine_4_water, turbine_4_max_water, turbine_4_steam, turbine_4_max_steam = turbine_4.getInfo()
	
	-- Действия с турбинами
	
	-- Первая турбина
	if turbine_1_status == 0 and turbine_1_fuel > 0 and turbine_1_lubricant > 0 then
		turbine_1.start()
		end
	if turbine_1_power < 100 and turbine_1_status == 1 then
		turbine_1.setThrottle(100)
		end
	
	-- Вторая турбина
	if turbine_2_status == 0 and turbine_2_fuel > 0 and turbine_2_lubricant > 0 then
		turbine_2.start()
		end
	if turbine_2_power < 100 and turbine_2_status == 1 then
		turbine_2.setThrottle(100)
		end
	
	-- Третья турбина
	if turbine_3_status == 0 and turbine_3_fuel > 0 and turbine_3_lubricant > 0 then
		turbine_3.start()
		end
	if turbine_3_power < 100 and turbine_3_status == 1 then
		turbine_3.setThrottle(100)
		end
	
	-- Четвёртая турбина
	if turbine_4_status == 0 and turbine_4_fuel > 0 and turbine_4_max_lubricant > 0 then
		turbine_4.start()
		end
	if turbine_4_power < 100 and turbine_4_status == 1 then
		turbine_4.setThrottle(100)
		end
	
	-- Вывод
	
	-- Первая турбина
	print("Турбина 1 : ")
	if turbine_1_status == 1 then
		print("	Мощность : ", turbine_1_power)
		print("	Статус : Работает")
		print("	Топливо : ", turbine_1_fuel, " / ", turbine_1_max_fuel)
		print("	Смаска : ", turbine_1_lubricant, " / ", turbine_1_max_lubricant)
		print("	Вода : ", turbine_1_water," / ", turbine_1_max_water)
		print("	Пар", turbine_1_steam, " / ", turbine_1_max_steam)
	elseif turbine_1_status == 0 then
		print("Статус : Остановлен")
		if turbine_1_fuel == 0 then
			print("Причина : Нехватка топлива")
			end
		if turbine_1_lubricant == 0 then
			print("Причина : Нехватка смаски")
			end
	else
		print("Статус : Запускается")
	end
	
	-- Вторая турбина
	print("Турбина 2 : ")
	if turbine_2_status == 1 then
		print("	Мощность : ", turbine_2_power)
		print("	Статус : Работает")
		print("	Топливо : ", turbine_2_fuel, " / ", turbine_2_max_fuel)
		print("	Смаска : ", turbine_2_lubricant, " / ", turbine_2_max_lubricant)
		print("	Вода : ", turbine_2_water," / ", turbine_2_max_water)
		print("	Пар", turbine_2_steam, " / ", turbine_2_max_steam)
	elseif turbine_2_status == 0 then
		print("Статус : Остановлен")
		if turbine_2_fuel == 0 then
			print("Причина : Нехватка топлива")
			end
		if turbine_2_lubricant == 0 then
			print("Причина : Нехватка смаски")
			end
	else
		print("Статус : Запускается")
	end
	
	-- Третья турбина
	print("Турбина 3 : ")
	if turbine_3_status == 1 then
		print("	Мощность : ", turbine_3_power)
		print("	Статус : Работает")
		print("	Топливо : ", turbine_3_fuel, " / ", turbine_3_max_fuel)
		print("	Смаска : ", turbine_3_lubricant, " / ", turbine_3_max_lubricant)
		print("	Вода : ", turbine_3_water," / ", turbine_3_max_water)
		print("	Пар", turbine_3_steam, " / ", turbine_3_max_steam)
	elseif turbine_3_status == 0 then
		print("Статус : Остановлен")
		if turbine_3_fuel == 0 then
			print("Причина : Нехватка топлива")
			end
		if turbine_3_lubricant == 0 then
			print("Причина : Нехватка смаски")
			end
	else
		print("Статус : Запускается")
	end
	
	-- Четвёртая турбина
	print("Турбина 4 : ")
	if turbine_4_status == 1 then
		print("	Мощность : ", turbine_4_power)
		print("	Статус : Работает")
		print("	Топливо : ", turbine_4_fuel, " / ", turbine_4_max_fuel)
		print("	Смаска : ", turbine_4_lubricant, " / ", turbine_4_max_lubricant)
		print("	Вода : ", turbine_4_water," / ", turbine_4_max_water)
		print("	Пар", turbine_4_steam, " / ", turbine_4_max_steam)
	elseif turbine_4_status == 0 then
		print("Статус : Остановлен")
		if turbine_4_fuel == 0 then
			print("Причина : Нехватка топлива")
			end
		if turbine_4_lubricant == 0 then
			print("Причина : Нехватка смаски")
			end
	else
		print("Статус : Запускается")
	end
	
	-- Конец вывода
	os.sleep(2.5) -- Ждём
	os.execute('clear') -- Очищаем экран
	end -- Конец основного цикла