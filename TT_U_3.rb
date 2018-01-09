require 'selenium-webdriver'

#   Env
        @driver = Selenium::WebDriver.for :firefox
        # @driver = Selenium::WebDriver.for :chrome
        @wait = Selenium::WebDriver::Wait.new(:timeout => 10)
        @driver.get("Address")                                                                            # Address - Адрес демостенда
        @wait.until {@driver.find_element(name: "username")}
        @driver.switch_to()

# #   Переключение на Английский   
#       @driver.find_element(class: "x-tool-en").click 
#       @wait.until {@driver.find_element(name: "username")}

#   Вход
        @driver.find_element(name: "username").send_keys("Login")                                                                     # Login - Логин
        @driver.find_element(name: "pass").send_keys("Psw")                                                                       # Psw   - Пароль
        @driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'Вход'}.first.click

#   Появилась таблица?
        @wait.until {@driver.find_element(css: "div.x-grid3-row").displayed?}

#   Закупочные процедуры
        el_temp=@driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'Закупочные процедуры'}.first                      # Находим кнопку "Закупочные процедуры"
        @driver.action.move_to(el_temp).perform                                                                                       # Наводим на кнопку курсор 
        @driver.action.click(el_temp).perform                                                                                         # Нажимаем на кнопку
        @wait.until {@driver.find_elements(class: 'x-menu-item-text').select {|el| el.text == 'Актуальные процедуры'}.first}          # Ждём выпадающее меню
        el_temp=@driver.find_elements(class: 'x-menu-item-text').select {|el| el.text == 'Актуальные процедуры'}.first                # Находим  строку "Актуальные процедуры"
        @driver.action.move_to(el_temp).perform                                                                                       # Наводим на строку курсор                          
        @wait.until {@driver.find_elements(class: 'x-menu-item-text').select {|el| el.text == 'Запрос предложений'}.first}            # Ждём выпадающее меню
        @driver.find_elements(class: 'x-menu-item-text').select {|el| el.text == 'Запрос предложений'}.first.click                    # Выбираем "Запрос предложений"
        
#   Появилась таблица?
        @wait.until {@driver.find_element(css: "div.x-grid3-row").displayed?}
        
#   Работа с таблицей
        els_temp=@driver.find_elements(css: "div.x-grid3-row")
        puts "Строк в таблице: " + "#{els_temp.size}"
        el_name=els_temp[1].find_element(css: "*.x-grid3-td-4").text
        puts "Номер процедуры во 2й строке: " + "#{el_name}"
        # el_temp=@driver.find_element(css: "*.x-form-empty-field")                                                                    # Находим поиск
        el_temp=@driver.find_element(css: "*.x-form-field")  
        el_temp.send_keys(el_name)                                                                                                   # Вводим номер закупки
        el_temp.send_keys(:enter)                                                                                                    # Ищем по номеру закупки
        sleep(2) #<-------------------------------------------------------------------------------------------------------------------------------------------
        els_temp=@driver.find_elements(css: "div.x-grid3-row")
        puts "Строк в таблице: " + "#{els_temp.size}"
        el1_name=els_temp[0].find_element(css: "*.x-grid3-td-4").text
        puts "Номер процедуры в 1й строке: " + "#{el1_name}"
        el_name_cut=el1_name[1..6]
        puts "Кусок номера с 2 по 7 символ: " + "#{el_name_cut}"    
        begin
                el_temp=@driver.find_element(css: "*.x-form-empty-field")                                                                      # Находим поиск      
        rescue 
                @driver.find_element(css: "*.x-tool-close").click
                sleep(3) #<-------------------------------------------------------------------------------------------------------------------------------------------
                el_temp=@driver.find_element(css: "*.x-form-field")
        end
        el_temp.send_keys(el_name_cut)                                                                                                   # Вводим номер закупки
        el_temp.send_keys(:enter)     
        sleep(3) #<--------------------------------------------------------------------------------------------------------------------------------------
        els_temp=@driver.find_elements(css: '*.x-grid3-td-4').select {|el| el.attribute("tabindex") == '0'}
        puts els_temp.size
        @flag=true
        els_temp.each do |el|
               @falg=false unless el.text.index(el_name_cut)
        end
        puts "Поиск верен!" if @flag 

#   Просмотр извещения
        @driver.find_element(css: 'div.x-grid3-row:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5) > div:nth-child(1)').click # Выбираем первую строку
        @driver.find_element(css: '*.x-grid3-row-selected').find_element(css: 'img.x-action-col-5').click                             # Нажимаем на "Просмотреть извещение о проведении процедуры"
        @wait.until {@driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'OK'}.first}    
        @driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'OK'}.first.click   
        @wait.until {@driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'Закрыть'}.first}    
        @driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'Закрыть'}.first.click   
        @wait.until {@driver.find_element(xpath: "//fieldset[contains(.,'Особенности закупки')]")}                                             # Находим поле Извещение
        el_temp=@driver.find_element(xpath: "//fieldset[contains(.,'Особенности закупки')]").find_element(css: "*.x-table-layout")             # Делимость лота
        puts el_temp.text

#   Операции
        @driver.navigate.back
        sleep(3)
        # begin
        #         @wait.until {@driver.find_element(css: "div.x-grid3-row").displayed?}  
        # rescue
        #         @wait.until {@driver.find_element(css: "div.x-grid3-row").displayed?}     
        # end
        @driver.find_element(css: 'div.x-grid3-row:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5) > div:nth-child(1)').click # Выбираем первую строку
        begin
                @driver.find_element(css: '*.x-grid3-row-selected').find_element(css: 'img.x-action-col-6').click                             # Нажимаем на "Добавить в избранное"     
        rescue 
                @driver.find_element(css: '*.x-grid3-row-selected').find_element(css: 'img.x-action-col-7').click                             # Нажимаем на "Удалить из избранного"
        end
        @wait.until {@driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'OK'}.first}    
        @driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'OK'}.first.click   
        @driver.find_element(css: 'div.x-grid3-row:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5) > div:nth-child(1)').click # Выбираем первую строку
        begin
                @driver.find_element(css: '*.x-grid3-row-selected').find_element(css: 'img.x-action-col-6').click                             # Нажимаем на "Добавить в избранное"     
        rescue 
                @driver.find_element(css: '*.x-grid3-row-selected').find_element(css: 'img.x-action-col-7').click                             # Нажимаем на "Удалить из избранного"
        end
        @wait.until {@driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'OK'}.first}    
        @driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'OK'}.first.click   
        @driver.find_element(css: 'div.x-grid3-row:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5) > div:nth-child(1)').click # Выбираем первую строку
        @driver.find_element(css: '*.x-grid3-row-selected').find_element(css: 'img.x-action-col-8').click                             # Нажимаем на "Проверить подпись"
        @wait.until {@driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'OK'}.first}   
        el_temp=@driver.find_element(class: 'ext-mb-text')
        puts el_temp.text
        @driver.find_elements(class: 'x-btn-text').select {|el| el.text == 'OK'}.first.click 
        @driver.find_element(css: 'div.x-grid3-row:nth-child(1) > table:nth-child(1) > tbody:nth-child(1) > tr:nth-child(1) > td:nth-child(5) > div:nth-child(1)').click # Выбираем первую строку
        @driver.find_element(css: '*.x-grid3-row-selected').find_element(css: 'img.x-action-col-35').click                             # Нажимаем на "Акты и протоколы"
        sleep(3) #<--------------------------------------------------------------------------------------------------------------------------------------------------------------
        el_temp=@driver.find_element(xpath: "//th[contains(.,'Внутренний номер закупки:')]")      
        puts el_temp.text