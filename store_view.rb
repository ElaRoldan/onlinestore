class View

  #Despliega la informacion del menu principal
  def main_menu_display
    puts "Bienvenido a nuestra online store:"
    puts "Selecciona la opcion que deseas"
    puts "1 Login"
    puts "2 Registrarse"
    puts "3 Salir"
    selection = gets.chomp.to_i 
  end  

  
  #Recolecta la informacion de registro de un usuario nuevo
  def display_registration
    user_data = []
    puts "*" * 80
    puts "Bienvenido al registro. Por favor llena la siguiente forma"
    puts "*" * 80
    puts "Escribe Nombre"  
    user_data << gets.chomp
    puts "Correo electronico"
    user_data << gets.chomp
    puts "Que tipo de usuario deseas 2 Vendedor, 1 Cliente"
    user_data << gets.chomp
    puts "Coloca un password" 
    user_data << gets.chomp
    puts "*" * 80
    puts "Registro exitoso"  
    puts "*" * 80
    user_data
  end 
  
  #Recolecta la informacion de login del usuario
  def login_user
    puts "*" * 80
    puts "Bienvenido a nuestra tienda. Haz login para disfrutar la experiencia"  
    puts "*" * 80
    login_data = []
    puts "Escribe tu nombre de usuario"
    login_data << gets.chomp
    puts "Escribe tu email"
    login_data << gets.chomp
    puts "Escribe tu password"
    login_data << gets.chomp
    login_data
  end

  #Envia mensaje al usuario sobre el status del login
  def login_status(verification_array)
    if verification_array.empty? 
      puts "Nombre de usuario o contraseña incorrecto"
    else 
      puts "*" * 80
      puts "Bienvenido #{verification_array[2]}"  
      puts "*" * 80
    end   
  end  

  #Muestra los 3 tipos de menus para cada tipo de usuario
  def menu(option)
    case option
      when "1"
        puts "Selecciona la opcion que deseas"
        puts "1. Ver productos" 
        puts "2. Comprar producto" 
        puts "3. Salir"
        gets.chomp
      when "2"
        puts "1. Ver productos" 
        puts "2. Comprar producto" 
        puts "3. Vender un nuevo producto" 
        puts "4. Quitar producto de la venta" 
        puts "5. Salir"
        gets.chomp
      when "10"
        puts "1. Ver productos" 
        puts "2. Comprar producto" 
        puts "3. Vender un nuevo producto" 
        puts "4. Quitar producto de la venta" 
        puts "5. Estadisticas de ventas" 
        puts "6. Listado de usuarios"
        puts "7. Salir"
        gets.chomp
      end
  end
  
  #Recolecta la informacion de un nuevo producto por parte de un vendedor
  def new_product_info
    product_info = []
    puts "¿cual es el nombre de tu producto?"
    product_info << gets.chomp
    puts "¿Cuantas piezas deseas vender? Recuerda que debes tenerlas para vender inmediatamente"
    product_info << gets.chomp.to_i
    puts "¿Cual es el precio por unidad?"
    product_info << gets.chomp
    puts "*" * 80
    puts "Felicidades agregaste #{product_info[1]} productos"  
    puts "*" * 80
    product_info
  end   

  #Muestra la informacion de los productos existentes
  def display_info_product(products)
    puts "*" * 80
    puts "Estos son nuestros productos en existencia"
    puts "*" * 80
    prods = products.count / 2
    num_product = 0
    num_quantity = 1
    p "    Cantidad       Producto"
    products.each_with_index do |product, index|
      if product.inventary.to_i > 0
        p "#{index + 1}. #{product.inventary}          #{product.product_name}"
      end
    end   
    puts "*" * 80
    puts "¿Que deseas hacer? 1.Comprar / 2. Salir"
    user_selection = gets.chomp
  end   
  
  #Solicita informacion al usuario sobre el producto a borrar
  def delete_product
    product = ""
    puts "*" * 80
    puts "¿Que producto deseas borrar?" 
    puts "Introduce el nombre de producto"
    product << gets.chomp 
    puts "*" * 80
    puts "Producto eliminado. Recuerda que cuando borras un producto se borran todas las existencias"
    product
  end  

  #Muestra los productos en existencia y recolecta la informacion del producto a comprar
  def buy_product(products)
    to_buy = []
    puts "*" * 80
    puts "Estos son nuestros productos en existencia"
    puts "*" * 80
    prods = products.count / 2
    num_product = 0
    num_quantity = 1
    p "    Cantidad       Producto"
    products.each_with_index do |product, index|
      if product.inventary.to_i > 0
        p "#{index + 1}. #{product.inventary}          #{product.product_name}       #{product.price}"
      end
    end 
    puts "*" * 80
    puts "¿Que producto deseas comprar?" 
    puts "Introduce el nombre de producto"
    to_buy << gets.chomp
    puts "¿Cuantos productos deseas comprar?"
    to_buy << gets.chomp 
    to_buy
  end  

  #Da el total de la compra en caso de que el numero de unidades a comprar sea menor que las existencias sino manda un error
  def buy_status(status)
    if status.empty?
      puts "No tenemos suficiente producto para esa compra"
      puts "*" * 80
    elsif status.count > 0 
      price = status[0].to_i
      quantity = status[1].to_i
      total_price = price * quantity
      puts "El total de tu compra es #{total_price}"
      puts "Gracias por comprar con nosotros"
      puts "*" * 80
    end  
  end 

  #Despliega al administrador estadisticas de las transacciones
  def display_stats(transaction_library)
    total_sales = []
    puts "*" * 80
    puts "Estas son las transacciones realizadas"
    puts "Cantidad   Precio      Total       Producto"
    transaction_library.each do |t|
      quantity = t.quantity.to_i
      price = t.price.to_i
      if t.price != nil 
        total_sales << t_price = quantity * price
        puts  "#{t.quantity}          #{t.price}          #{t_price}       #{t.product_name}  " 
      end 
    end
    puts "El total de ventas es #{total_sales.inject(:+)}"  
  end  

  def display_users(users_array)
    total_users = users_array.count
    client = 0
    clients = []
    admin = 0
    admins = []
    seller = 0
    sellers = []
    users_array.each do |user|
      if user.user_type == "1"
        client += 1
        clients << user 
      elsif user.user_type == "2"
        seller += 1
        sellers << user 
      elsif user.user_type == "10"
        admin += 1
        admins << user
      end         
    end 
    puts "*" * 80
    puts "La tienda cuenta con #{total_users} usuarios"
    puts "#{clients.count} clientes"
    clients.each do |client|
      p "#{client.user_name}"
    end   
    puts "#{sellers.count} vendedores"
    sellers.each do |seller|
      p "#{seller.user_name}"
    end 
    puts "#{admins.count} administradores"
    admins.each do |admin|
      p "#{admin.user_name}"
    end 
  end   

  def goodbye 
    puts "Gracias por visitarnos. Regresa pronto"  
  end  

end 
