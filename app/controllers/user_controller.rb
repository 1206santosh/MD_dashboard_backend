class UserController < ApplicationController
  def index
       @user=User.where.not(id:@current_user.id)
      render json: @user
  end


  def login
    login_cred = params["login_cred"]
    password = params["password"]
    user = nil
    puts "login Request"
    user = User.where("email=?", login_cred).last
    if !user.blank?
      is_valid =user.valid_password?(password)
      if is_valid
        if true
          employee_id = user.employee_id rescue ""
          email = user.email rescue "NA"
          render json: {auth_token: user.uuid,name:user.name,email:user.email,success: true}
          return user
        else
          render json: {auth_token: "", success: false, message: "Please confirm your account before logging in"}
          return
        end
      else
        render json:{auth_token: "", success: false, message: "user and password do not match"}
        return
      end
    end
    render json: {success: false, auth_token: "", message: "user not found"}
    return
  end
end


