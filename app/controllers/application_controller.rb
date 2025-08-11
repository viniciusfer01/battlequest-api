class ApplicationController < ActionController::API
  include Filterable
  include Paginatable
end
