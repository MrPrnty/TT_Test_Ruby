require 'selenium-webdriver'

#   Env
        @driver = Selenium::WebDriver.for :firefox
        # @driver = Selenium::WebDriver.for :chrome
        @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        @driver.get("Address")   # Address - Адрес демостенда
        @wait.until {@driver.find_element(name: "username")}
        @driver.switch_to()

# #   Переключение на Английский   
#       @driver.find_element(class: "x-tool-en").click 
#       @wait.until {@driver.find_element(name: "username")}

#   Вход
        @driver.find_element(name: "username").send_keys("Login")       # Login - Логин
        @driver.find_element(name: "pass").send_keys("Psw")             # Psw   - Пароль
        @driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'Вход'}.first.click

#   Появилась таблица?
        @wait.until {@driver.find_element(css: "*.x-grid3-col-id").displayed?}

#   Закупочные процедуры
        el_temp=@driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'Закупочные процедуры'}.first                # Находим кнопку "Закупочные процедуры"
        @driver.action.move_to(el_temp).perform                                                                                 # Наводим на кнопку курсор 
        @driver.action.click(el_temp).perform                                                                                   # Нажимаем на кнопку
        @wait.until {@driver.find_elements(class: 'x-menu-item-text').select {|el| el.text == 'Актуальные процедуры'}.first}    # Ждём выпадающее меню
        el_temp=@driver.find_elements(class: 'x-menu-item-text').select {|el| el.text == 'Актуальные процедуры'}.first          # Находим  строку "Актуальные процедуры"
        @driver.action.move_to(el_temp).perform                                                                                 # Наводим на строку курсор                          
        @wait.until {@driver.find_elements(class: 'x-menu-item-text').select {|el| el.text == 'Запрос предложений'}.first}      # Ждём выпадающее меню
        @driver.find_elements(class: 'x-menu-item-text').select {|el| el.text == 'Запрос предложений'}.first.click              # Выбираем "Запрос предложений"
        
#   Появилась таблица?
        begin
            @wait.until {@driver.find_element(css: 'div.x-grid3-row:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5) > div:nth-child(1)')}        
        rescue
            @wait.until {@driver.find_element(css: 'div.x-grid3-row:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5) > div:nth-child(1)')}                
        end

#   Работа с "Запрос предложений"
        el_temp=@driver.find_element(css: "div.x-grid3-row:nth-child(9) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5) > div:nth-child(1)") # Выбираем 9 строку в таблице
        el_temp_name=el_temp.text                                                                                               # Запоминаем номер закупки на 9 строке
        puts el_temp_name
        el_temp=@driver.find_element(css: "*.x-form-empty-field")                                                               # Находим поиск
        el_temp.send_keys(el_temp_name)                                                                                         # Вводим номер закупки
        el_temp.send_keys(:enter)                                                                                               # Ищем по номеру закупки
        begin                                                                                                                   # Ждём обновления таблицы
            @wait.until {@driver.find_element(css: "div.x-grid3-row:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5) > div:nth-child(1)").text == el_temp_name}
        rescue
            @wait.until {@driver.find_element(css: "div.x-grid3-row:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5) > div:nth-child(1)").text == el_temp_name}
        end     
        @driver.find_element(css: 'div.x-grid3-row:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5) > div:nth-child(1)').click # Выбираем найденную строку
        @driver.find_element(css: '*.x-grid3-row-selected').find_element(css: 'img.x-action-col-5').click                       # Нажимаем на "Просмотреть извещение о проведении процедуры"
        @wait.until {@driver.find_element(xpath: "//fieldset[contains(.,'Извещение:')]")}                                       # Находим поле Извещение
        @driver.find_element(xpath: "//fieldset[contains(.,'Извещение:')]").find_element(css: "a:nth-child(1)").click           # Скачиваем приложенный файл
