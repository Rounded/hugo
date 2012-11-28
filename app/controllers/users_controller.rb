class UsersController < ApplicationController

  # GET /users/1
  # GET /users/1.json
  def show

  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end


  def create
    @user = User.new(params[:user])

    Telapi.config do |config|
      config.account_sid = 'ACbbcf2b79541543ff86dd9955952d1076'
      config.auth_token  = 'bc039f3d301a4475899cb9e31cb3d953'
    end
    Telapi::Message.create( "#{@user.number}", '(302) 752-4624', "Hi, I'm Hugo! Thanks for signing up, #{@user.name}. Send me your zip code and I'll send you some hotels with pppowweerrrrrrrrrrrr!" )

    # respond_to do |format|
    #   if @user.save
    #     format.html { redirect_to @user, notice: 'User was successfully created.' }
    #     format.json { render json: @user, status: :created, location: @user }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

end
