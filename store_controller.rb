require_relative "store_model.rb"
require_relative "store_view.rb"

class Controller 
  def initialize
    @model = Operation.new 
    @view = View.new
    @client = Client.new
    @seller = Seller.new
    @admin = Admin.new
    @total_price = []
    store
  end 

  #Muestra las opciones del menu principal de la tienda 
  def store
    user_choice = @view.main_menu_display
    case user_choice
    when 2
      register_user  
    when 1 
      login_user
    when 3 
      @view.goodbye    
    end 
  end

  #Toma los datos de los nuevos usuarios y les genera un pefil ya sea de clientes o vendedores 
  def register_user
    user_data = @view.display_registration 
    new_user = User.new(user_data[0], user_data[1], user_data[2], user_data[3])  
    access = user_data[2].to_i
    case access
    when 1
      @client.save_info(new_user)
      login_user
    when 2
      @seller.save_info(new_user)
      login_user
    when 10
      @admin.save_info(new_user)
      login_user      
    end   
  end  

  def login_user 
    verification = []
    while verification.count == 0
      login_info = @view.login_user.to_a
      verification = @client.user_verification(login_info)
      @view.login_status(verification)
    end 
    option = verification[1]
    case option
      when "1"
        input = @view.menu("1")
        client_action(input)
      when "2"
        input = @view.menu("2")
        seller_actions(input)
      when "10"
        input = @view.menu("10")
        admin_actions(input)
      end 
  end 

  def client_action(option)
    case option
      when "1"
        product_info_client
      when "2"
        buy_product_client
      when "3"
        @view.goodbye
    end
  end

  def seller_actions(option)
    case option
      when "1"
        product_info_seller
      when "2"
        buy_product
      when "3"
        add_new_product
      when "4" 
        delete_product
      when "5"
        @view.goodbye
    end 
  end 

  def admin_actions(option)
   case option
      when "1"
        product_info_admin
      when "2"
        buy_product_admin
      when "3"
        add_new_product_admin
      when "4" 
        delete_product_admin
      when "5"
        transaction_record
      when "6"
        user_index
      when "7"
        @view.goodbye     
    end
  end 

  #METODOS RELACIONADOS CON LOS  PRODUCTOS
  #Agrega nuevos productos a la base de datos 
  def add_new_product
    array_product = @view.new_product_info
    new_product = Product.new(array_product[0],array_product[1],array_product[2])
    @seller.save_product_info(new_product)
    input = @view.menu("2")
    seller_actions(input)
  end

  def add_new_product_admin
    array_product = @view.new_product_info
    new_product = Product.new(array_product[0],array_product[1],array_product[2])
    @seller.save_product_info(new_product)
    input = @view.menu("10")
    admin_actions(input)
  end

  #Metodo que muestra todos los productos en existencia
  def product_info_seller
    products = @seller.show_product_info 
    choice = @view.display_info_product(products)
    choice == "1" ? buy_product : input = @view.menu("2") 
    seller_actions(input)
  end  
   
  def product_info_admin
    products = @admin.show_product_info 
    choice = @view.display_info_product(products)
    choice == "1" ? buy_product_admin : input = @view.menu("10") 
    admin_actions(input)
  end  

   def product_info_client
    products = @client.show_product_info 
    choice = @view.display_info_product(products)
    choice == "1" ? buy_product_client : input = @view.menu("1") 
    client_action(input)
  end 

  #Metodo que borra productos del inventario
  def delete_product
    product_to_delete = @view.delete_product
    @seller.delete_product(product_to_delete)
    input = @view.menu("2")
    seller_actions(input)      
  end 

  def delete_product_admin
    product_to_delete = @view.delete_product
    @admin.delete_product(product_to_delete)
    input = @view.menu("10")
    admin_actions(input)      
  end 

  #Metodos para comprar productos
  def buy_product
    products = @seller.show_product_info 
    product_buy = @view.buy_product(products)
    @total_price = @seller.save_buy_a_product(product_buy)
    @view.buy_status(@total_price)
    input = @view.menu("2")
    seller_actions(input)  
  end  
  
  def buy_product_client
    products = @client.show_product_info 
    product_buy = @view.buy_product(products)
    @total_price = @client.save_buy_a_product(product_buy)
    @view.buy_status(@total_price)
    input = @view.menu("1")
    client_action(input)  
  end  

  def buy_product_admin
    products = @admin.show_product_info 
    product_buy = @view.buy_product(products)
    @total_price = @admin.save_buy_a_product(product_buy)
    @view.buy_status(@total_price)
    input = @view.menu("10")
    admin_actions(input)  
  end  
  
  #Metodo que muestra todas las transaciones de compra con un total
  #Metodo exclusivo para el administrador
  def transaction_record
    transaction_record = @model.register_transactions(@total_price)
    transaction_library = @model.read_transactions(transaction_record)
    @view.display_stats(transaction_library)
    input = @view.menu("10")
    admin_actions(input) 
  end 

  def user_index
    users_array = @admin.user_databse
    @view.display_users(users_array)
    input = @view.menu("10")
    admin_actions(input) 
  end  
end



Controller.new


