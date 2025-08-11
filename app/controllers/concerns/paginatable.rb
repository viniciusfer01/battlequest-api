module Paginatable
  extend ActiveSupport::Concern

  included do
    private

    def paginate(scope, default_per_page: 25, max_per_page: 100)
      page = params.fetch(:page, 1).to_i
      per_page = params.fetch(:per_page, default_per_page).to_i
      per_page = [ per_page, max_per_page ].min # Enforce the max per page limit

      scope.offset((page - 1) * per_page).limit(per_page)
    end
  end
end
