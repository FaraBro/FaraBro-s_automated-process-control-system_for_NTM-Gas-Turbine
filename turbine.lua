-- Настройки
settings = {
	outputInfo_To_Console = false, -- Вывод информации о турбинах в консоль, может снизить производительность системы и повысить потребление энергии при включении
	AutoSearchTurbines = true, -- Автоматический поиск турбин комб. цикла
}

-- Адресы турбин
turbines_address = {
	'', -- Адрес турбины №1
	'', -- Адрес турбины №2
	'', -- и так далее P.S. можно от 0 до Inf турбин (ограничивается сервером OpenComputers и вашим компьютером)
}

timeOfSleep = 2.5 -- Время ожидания после цикла

component = require('component')

-- Импортируем адресы турбин
turbines = {}
if (settings.AutoSearchTurbines==false) then
	for index, value in ipairs(turbines_address) do
		turbines[index] = component.proxy(component.get(value))
	end
else
	numb = 1
	turbines_list = component.list("ntm_gas_turbine")
	for key, value in pairs(turbines_list) do
		turbines[numb] = component.proxy(key)
		numb = numb + 1
	end
end

-- Основной цикл

while true do
	
	-- Импортируем данные турбин
	
	turbines_data = {}
	for index, value in ipairs(turbines) do
		turbine_data = {}
		turbine_data['power'], turbine_data['status'], turbine_data['fuel'], turbine_data['max_fuel'], turbine_data['lubricant'], turbine_data['max_lubricant'], turbine_data['water'], turbine_data['max_water'], turbine_data['steam'], turbine_data['max_steam'] = value.getInfo() -- Получаем данные с турбины
		
		turbines_data[index] = turbine_data
	end
	
	-- Действия с турбинами
	
	for index, value in ipairs(turbines_data) do
		if value['status'] == 0 and value['fuel'] > 0 and value['lubricant'] > 0 then
			turbines[index].start()
		end
		if value['power'] < 100 and value['status'] == 1 then
			turbines[index].setThrottle(100)
		end
	end
	
	-- Вывод
	
	if (settings.outputInfo_To_Console==true) then
		os.execute('clear') -- Очищаем экран
		
		for index, value in ipairs(turbines_data) do
			print("Турбина ", index)
			if value['status'] == 1 then
				print("	Мощность: ", value['power'])
				print("	Статус: 	Работает")
				print("	Топливо: ", value['fuel'], " / ", value['max_fuel'])
				print("	Смазка: ", value['lubricant'], " / ", value['max_lubricant'])
				print("	Вода: 	", value['water'], " / ", value['max_water'])
				print("	Пар: 	", value['steam'], " / ", value['max_steam'])
			elseif value['status'] == 0 then
				print("	Статус: 	Остановлена")
				if value['fuel'] == 0 and value['lubricant'] == 0 then
					print("	Возможная причина: Нехватка топлива и смазки")
				elseif value['fuel'] == 0 then
					print("	Возможная причина: Нехватка топлива")
				elseif value['lubricant'] == 0 then
					print("	Возможная причина: Нехватка смазки")
				end
			else
				print("	Статус: 	Запускается")
			end
			print()
		end
	end
	
	-- Конец вывода
	
	os.sleep(timeOfSleep) -- Ждём
end -- Конец основного цикла

