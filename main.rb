require 'sinatra'
require './boot.rb'
require './money_calculator.rb'


change = 0
hash = {'key'=>"value"}
qty = 0
total_amount = 0
quantity = 0
# ROUTES FOR ADMIN SECTION
get '/' do
  @products = Item.all.sort_by{rand}.slice(0,10)
  erb :home
end

get '/home' do
  @products = Item.all.sort_by{rand}.slice(0,10)
  erb :home
end

get '/about' do
  erb :about
end

get '/products' do
  @products = Item.all
  erb :products
end

get '/quantity/:id' do
  @product = Item.find(params[:id])
  qty = params[:qty].to_i
  @qty = qty
  quantity = @product.quantity
  @quantity = quantity
  erb :quantity
end

get '/payment_form/:id' do
  @product = Item.find(params[:id])
  qty = params[:qty].to_i
  @qty = qty
  total_amount = @product.price.to_i * @qty
  @total_amount = total_amount
  erb :payment_form
end

post '/payment_form/:id' do
  @product = Item.find(params[:id])
  @qty = qty
  quantity = @product.quantity
  @quantity = quantity
  @total_amount = @product.price.to_i * @qty
  money_changer = MoneyCalculator.new params[:one_coin], params[:five_coin], params[:ten_coin], 
                  params[:twenty_bill], params[:fifty_bill], params[:hundred_bill], params[:five_hundred_bill], params[:thousand_bill]
  @payment = money_changer.total_payment
  money_changer.get_change(@total_amount)
  change = @payment - @total_amount
  @change = change
  hash = money_changer.bills
  @hash = hash

  if @change < 0
    @say_someting = "Insufficient Funds!"
    erb :payment_form
  else
      @product.update_attributes!(quantity: @product.quantity.to_i - @qty,
      sold: @product.sold.to_i + @qty)
    erb :payment
  end
end

#DEFAULT CODE BELOW
#DEFAULT CODE BELOW
#DEFAULT CODE BELOW

get '/admin' do
  @products = Item.all
  erb :admin_index
end

get '/new_product' do
  @product = Item.new
  erb :product_form
end

post '/create_product' do
	@item = Item.new
	@item.name = params[:name]
	@item.price = params[:price]
	@item.quantity = params[:quantity]
	@item.sold = 0
	@item.save
 	redirect to '/admin'
end

get '/edit_product/:id' do
  @product = Item.find(params[:id])
  erb :product_form
end

post '/update_product/:id' do
  @product = Item.find(params[:id])
  @product.update_attributes!(
    name: params[:name],
    price: params[:price],
    quantity: params[:quantity],
  )
  redirect to '/admin'
end

get '/delete_product/:id' do
  @product = Item.find(params[:id])
  @product.destroy!
  redirect to '/admin'
end
# ROUTES FOR ADMIN SECTION
