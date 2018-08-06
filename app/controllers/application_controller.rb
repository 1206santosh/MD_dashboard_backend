class ApplicationController < ActionController::API

  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate,except: :login




  private
      def authenticate
        authenticate_or_request_with_http_token do |token, options|
          puts "++++++++++++++++++++++++++++++++++++++++++"
          puts token
          puts "++++++++++++++++++++++++++++++++++++++++++"
          user = User.where(uuid: token).last
          if !user.blank?
            ActiveSupport::SecurityUtils.secure_compare(
                ::Digest::SHA256.hexdigest(token),
                ::Digest::SHA256.hexdigest(user.uuid)
            )
            @current_user = user
            return true
          end


        end

      end
end
