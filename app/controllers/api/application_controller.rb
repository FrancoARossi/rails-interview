class Api::ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::UnknownFormat, with: :raise_not_found
  
  def raise_not_found
    raise ActionController::RoutingError.new('Not supported format')
  end

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def render_success(data, status = :ok)
    render json: data, status:
  end

  def render_error(error, status = :not_found)
    render json: { error: }, status:
  end
end