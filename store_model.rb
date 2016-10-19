require "csv"

class User
  attr_accessor :user_name, :password, :user_type, :email
  
  def initialize(user_name="", email="", user_type="", password="hola")
    @user_name = user_name
    @email = email
    @user_type = user_type
    @password = password
  end

  #Guarda la informacion de los usuarios registrados
  def save_info(array_user) 
    CSV.open("user.csv", "a+") do |csv|
      csv << [array_user.user_name, array_user.email, array_user.user_type, array_user.password]
    end
  end

  #Da acceso a la base de datos de usuarios para verificar password y que existe el usuario
  def user_databse
    users_array = []
    CSV.foreach("user.csv") do |row|
      users_array << User.new(row[0], row[1], row[2], row[3])
    end 
    users_array  
  end 

  #Verifica que la informacion de login sea correcta, entrega un arreglo con true el tipo de usuario y su nombre
  def user_verification(login_info)
    existing_users = user_databse
    verification_status = []
    existing_users.each do |user|
      if login_info[0] == user.user_name && login_info[1] == user.email && login_info[2] == user.password
        verification_status << true << user.user_type << user.user_name
      end   
    end 
    verification_status
  end 

  #Muestra la informacion de todos los productos
  def show_product_info
    product_library = []
    CSV.foreach("products.csv") do |row|
      product_library << Product.new(row[0],row[1],row[2])
    end
    product_library
  end  
  
  #Guarda en la base de datos de productos la informacion de compras
  def save_buy_a_product(product_buy)
    prod_num = product_buy[1].to_i
    total_price = []
    new_list = []
    price = ""
    show_product_info.each do |product|
      existence = product.inventary.to_i 
      if product_buy[0] != product.product_name
        new_list << product
      elsif product_buy[0] == product.product_name && prod_num <= existence
        product.inventary = existence - prod_num
        new_list << product
        price = product.price
        total_price << price << prod_num << product.product_name
       else
        new_list << product
      end
    end
    save_all_products(new_list) 
    total_price
  end 

  #Guarda la base de datos de productos
  def save_all_products(actual_products)
    CSV.open("products.csv", "wb") do |csv|
      actual_products.each do |product|
        csv << [product.product_name, product.inventary, product.price]
      end
    end
  end 

end  

class Product
  attr_accessor :product_name, :inventary, :price

  #Atributos que todo producto debe de tener por default
  def initialize(product_name,inventary=1,price)
    @product_name = product_name
    @inventary = inventary
    @price = price
  end   

end  


class Operation
  #Clase que lleva el control de las transacciones de la tienda
  attr_accessor :price, :quantity, :product_name

  def initialize(price="", quantity="", product_name="")
    @price = price
    @quantity = quantity
    @product_name = product_name
  end 

  #Crea la base de datos con cada una de las transacciones
  def register_transactions(transaction_record)
    array_transactions = transaction_record
    CSV.open("transactions.csv", "a+") do |csv|
       csv << array_transactions 
    end
    array_transactions
  end 

  #Lee la informacion de la base de datos de las transacciones
  def read_transactions(transaction_record)
    transactions_library = []
    CSV.foreach("transactions.csv") do |row|
      transactions_library << Operation.new(row[0], row[1], row[2]) 
    end
    transactions_library
  end  
end  

class Client < User

end

class Seller < User
   
  #Guarda la informacion de los productos que registra el vendedor
  def save_product_info(array_product) 
    CSV.open("products.csv", "a+") do |csv|
      csv << [array_product.product_name, array_product.inventary,array_product.price]
    end
  end
  #Metodo que borra un producto en la base de datos y vuelve a guardar el nuevo inventario
  def delete_product(product_to_delete)
    products_array = show_product_info
    actual_products = []
    delete = []
    products_array.each do |product|
      if product.product_name == product_to_delete
        delete << product
      elsif product.product_name != product_to_delete
        actual_products << product
      end 
    end 
    save_all_products(actual_products)
  end 
end




class Admin < User

end


