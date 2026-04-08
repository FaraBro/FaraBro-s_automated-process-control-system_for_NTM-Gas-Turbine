-- Настройки
settings = {
	outputInfo_To_Console = false, -- Вывод информации о турбинах в консоль, может снизить производительность системы и повысить потребление энергии при включении
	AutoSearchTurbines = true, -- Автоматический поиск турбин комб. цикла
	mode = { -- Режим работы
		mode = 1, -- Номер режима работы
		
		-- Настройки режима работы 2
		AutoSearchEnergyStorages = true, -- Автоматический поиск аккумуляторов
		EnergySrorages_address = { -- Адресы аккумуляторов (не используется, если включён автоматический поиск). Указывается в таком же формате как и адресы турбин комб. цикла.
		},
	},
}

-- Адресы турбин
turbines_address = { --Адресы турбин комб. цикла (не используется, если включён автоматический поиск)
	'', -- Адрес турбины №1
	'', -- Адрес турбины №2
	'', -- и так далее P.S. можно от 0 до Inf турбин (ограничивается сервером OpenComputers и вашим компьютером)
}

timeOfSleep = 2.5 -- Время ожидания после цикла

component = require('component')
computer = require('computer')

-- Импортируем адресы турбин
turbines = {}
turbines_data = {}
if (settings.AutoSearchTurbines==false) then
	for index, value in ipairs(turbines_address) do
		turbines[index] = component.proxy(component.get(value))
		turbines_data[index] = {}
		turbines_data[index]['Must_work'] = false
	end
else
	numb = 1
	turbines_list = component.list("ntm_gas_turbine")
	for key, value in pairs(turbines_list) do
		turbines[numb] = component.proxy(key)
		turbines_data[numb] = {}
		turbines_data[numb]['Must_work'] = false
		
		numb = numb + 1
	end
end

if settings.mode.mode == 2 then
	-- Импортируем адресы аккумуляторов
	EnergySrorages = {}
	if (settings.mode.AutoSearchEnergyStorages==false) then
		for index, value in ipairs(settings.mode.EnergySrorages_address) do
			EnergySrorages[index] = component.proxy(component.get(value))
		end
	else
		numb = 1
		EnergySrorages_list = component.list("ntm_energy_storage")
		for key, value in pairs(EnergySrorages_list) do
			EnergySrorages[numb] = component.proxy(key)
			numb = numb + 1
		end
	end
end

-- Основной цикл

while true do
	if settings.mode.mode == 2 then
		-- Импортируем данные аккумуляторов
		
		EnergySrorages_data = {}
		for index, value in ipairs(EnergySrorages) do
			EnergySrorage_data = {}
			EnergySrorage_data['Enow'], EnergySrorage_data['Emax'], EnergySrorage_data['upd'], EnergySrorage_data['redact_noRed'], EnergySrorage_data['redact_withRed'], EnergySrorage_data['priority'], EnergySrorage_data['type'], EnergySrorage_data['Emax_in'], EnergySrorage_data['Emax_out']  = value.getInfo()
			EnergySrorage_data['Enow_in_prosent'] = EnergySrorage_data['Enow']/EnergySrorage_data['Emax']*100
			
			EnergySrorages_data[index] = EnergySrorage_data
		end
		
		-- Действия с аккумуляторами
		MaxEStorage = 0
		NowESrorage = 0
		for index, value in ipairs(EnergySrorages_data) do
			MaxEStorage = MaxEStorage + value['Emax']
			NowESrorage = NowESrorage + value['Enow']
			if value['redact_noRed'] ~= 1 then
				EnergySrorages[index].setModeLow(1)
				computer.beep()
			end
			if value['redact_withRed'] ~= 1 then
				EnergySrorages[index].setModeHigh(1)
				computer.beep()
			end
			if value['priority'] ~= 0 then
				EnergySrorages[index].setPriority(0)
				computer.beep()
			end
		end
		EnergyAVprosent = NowESrorage/MaxEStorage*100
		Throttle = 225-2.5*EnergyAVprosent
	end
	
	-- Импортируем данные турбин
	
	for index, value in ipairs(turbines) do
		turbine_data = turbines_data[index]
		turbine_data['power'], turbine_data['status'], turbine_data['fuel'], turbine_data['max_fuel'], turbine_data['lubricant'], turbine_data['max_lubricant'], turbine_data['water'], turbine_data['max_water'], turbine_data['steam'], turbine_data['max_steam'] = value.getInfo() -- Получаем данные с турбины
		
		turbines_data[index] = turbine_data
	end
	
	-- Действия с турбинами
	
	for index, value in ipairs(turbines_data) do
		if settings.mode.mode == 1 then
			if value['status'] == 0 and value['fuel'] > 0 and value['lubricant'] > 0 then
				if value['Must_work'] == false then
					turbines[index].start()
					turbines_data[index]['Must_work'] = true
				else
					computer.beep(1750, 30)
					os.sleep(20)
					turbines_data[index]['Must_work'] = false
				end
			end
			if value['power'] < 100 and value['status'] == 1 then
				turbines[index].setThrottle(100)
			end
		elseif settings.mode.mode == 2 then
			if value['status'] == 0 then
				if EnergyAVprosent < 75 and value['fuel'] > 0 and value['lubricant'] > 0 then
					if value['Must_work'] == false then
						turbines[index].start()
						turbines_data[index]['Must_work'] = true
					else
						computer.beep(1750, 30)
						os.sleep(20)
						turbines_data[index]['Must_work'] = false
					end
				end
			elseif value['status'] == 1 then
				if EnergyAVprosent > 95 then
					turbines[index].stop()
					turbines_data[index]['Must_work'] = false
				end
				if EnergyAVprosent < 50 then
					turbines[index].setThrottle(100)
				else
					turbines[index].setThrottle(Throttle)
				end
			end
		end
		if value['fuel'] < 0 or value['lubricant'] < 0 then
			turbines_data[index]['Must_work'] = false
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
		
		if settings.mode.mode == 2 then
			for index, value in ipairs(EnergySrorages_data) do
				print("Энергохранилище ", index)
				print("	Энергия: ", value['Enow'], " HE / ", value['Emax'], " HE (", string.format("%.2f" ,value['Enow_in_prosent'])," %)")
				print()
			end
			print("Общее наполнение аккумуляторов: ", NowESrorage, "HE / ", MaxEStorage, " HE (", string.format("%.2f" ,EnergyAVprosent)," %)")
		end
	end
	
	-- Конец вывода
	
	os.sleep(timeOfSleep) -- Ждём
end -- Конец основного цикла

