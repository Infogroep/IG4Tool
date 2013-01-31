require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe OrderItemsController do

	def additional_params
		@additional_params || { :order_id => 1 }
	end

	def general_success
		should respond_with(:ok)
		response.should render_template("orders/_order_items")
	end

	def general_fail
		should respond_with(:internal_server_error)
		response.should render_template("layouts/_flash_messages")
	end

	def on_update_success(instance)
		general_success
	end

	# When update fails, it renders an error message
	def on_update_fail(instance)
		general_fail
	end

	def on_destroy_success
		general_success
	end

	def set_owner(user)
		@order = FactoryGirl.build(:order)
		@order.user = user
		@order.save

		@additional_params = { :order_id => @order.id }
	end

	def first_order_item_count
		@order.order_items.first.count
	end

	# This should return the minimal set of attributes required to create a valid
	# OrderItem. As you add validations to OrderItem, be sure to
	# update the return value of this method accordingly.
	def valid_attributes
		{ :order_id => @order.id, :store_item_id => @store_item.id, :count => 1 }
	end

	describe_access(
			:login => [:create, :update, :destroy],
	) do

		before(:each) do
			@store_item = FactoryGirl.create(:store_item)
		end

		it_should_require_user_or_access_for_actions(:order_processing,[:create,:update,:destroy]) do
			include_examples "standard_controller", OrderItem, :only => [:update,:destroy],
			                 :update  => { :on_success => "renders the orders/_order_items partial",
			                               :on_fail    => "renders the layouts/_flash_messages partial" },
			                 :destroy => { :on_success => "renders the orders/_order_items partial" }

			describe "POST create" do
				before(:each) do
					@barcode = FactoryGirl.create(:barcode, :store_item => @store_item)
				end

				describe "when there is already an order_item for this store_item" do
					before(:each) do
						FactoryGirl.create(:order_item, :store_item => @store_item, :order => @order)
					end

					describe "with valid params" do
						it "increases the count of this order_item by 1" do
							expect {
								post :create, additional_params.merge({ :barcode => @barcode.code })
							}.to change(self, :first_order_item_count).by(1)
						end

						it "redirects to the order_items list" do
							post :create, additional_params.merge({ :barcode => @barcode.code })
							general_success
						end
					end

					describe "with invalid params" do
						it "generates an error flash" do
							# Trigger the behavior that occurs when invalid params are submitted
							OrderItem.any_instance.stub(:save).and_return(false)
							post :create, additional_params.merge({ :barcode => -1878 })
							general_fail
						end
					end
				end

				describe "when there is no existing order_item for this store_item" do
					describe "with valid params" do
						it "creates a new order_item" do
							expect {
								post :create, additional_params.merge({ :barcode => @barcode.code })
							}.to change(OrderItem, :count).by(1)
						end

						it "redirects to the order_items list" do
							post :create, additional_params.merge({ :barcode => @barcode.code })
							general_success
						end
					end

					describe "with invalid params" do
						it "generates an error flash" do
							# Trigger the behavior that occurs when invalid params are submitted
							OrderItem.any_instance.stub(:save).and_return(false)
							post :create, additional_params.merge({ :barcode => -1878 })
							general_fail
						end
					end
				end
			end
		end
	end
end
