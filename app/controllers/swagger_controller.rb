class SwaggerController < ApplicationController
  def respond
    if Rails.env.development? || Rails.env.test?
<<<<<<< HEAD
      render inline: Rails.root.join('swagger', derived_path).read
=======
      swagger_root = Rails.root.join('swagger')
      file_path = swagger_root.join(derived_path).cleanpath

      return head :not_found unless file_path.to_s.start_with?("#{swagger_root}/") && file_path.file?

      render inline: file_path.read
>>>>>>> upstream/develop
    else
      head :not_found
    end
  end

  private

  def derived_path
    params[:path] ||= 'index.html'
<<<<<<< HEAD
    path = Rack::Utils.clean_path_info(params[:path])
    path << ".#{Rack::Utils.clean_path_info(params[:format])}" unless path.ends_with?(params[:format].to_s)
=======
    path = Rack::Utils.clean_path_info(params[:path]).delete_prefix('/')
    path << ".#{Rack::Utils.clean_path_info(params[:format]).delete_prefix('/')}" unless path.ends_with?(params[:format].to_s)
>>>>>>> upstream/develop
    path
  end
end
