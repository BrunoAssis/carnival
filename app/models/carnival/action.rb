module Carnival
  class Action
    include Rails.application.routes.url_helpers
    PARTIAL_DEFAULT = "/admin/shared/action_default"
    PARTIAL_DELETE = "/admin/shared/action_delete"
    PARTIAL_REMOTE = "/admin/shared/action_remote"

    def initialize(presenter, name, params={})
      @presenter = presenter
      @name = name
      @params = params
      @partial = default_partial
      @path = params[:path] if params[:path].present?
    end

    def path(extra_params={})
      if @path.nil?
        params = {controller: "admin/#{@presenter.controller_name}", action: @name}
        params = params.merge(extra_params) if extra_params.present?
        params = params.merge(:only_path => true)
        url_for(params)
      else
        @path
      end
    end

    def partial
      @partial
    end

    def name
      @name
    end

    def target
      @params[:target]
    end

    def default_partial()
      if [:new, :edit, :show].include?(@name)
        PARTIAL_DEFAULT
      elsif @name == :destroy
        PARTIAL_DELETE
      elsif @params[:remote]
        PARTIAL_REMOTE
      else
        PARTIAL_DEFAULT
      end
    end
  end
end
