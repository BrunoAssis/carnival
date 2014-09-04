# -*- encoding : utf-8 -*-
module Admin
  class StatePresenter < Carnival::BaseAdminPresenter
    field :id,
          :actions => [:index, :show],
          :searchable => true,
          :sortable => true,
          :advanced_search => {:operator => :equal}

    field :name,
          :sortable => true,
          :actions => [:index, :new, :edit, :show],
          :searchable => true,
          :advanced_search => {:operator => :like}

    field :code,
          :sortable => {:default => true, :direction => :desc},
          :actions => [:index, :new, :edit, :show],
          :searchable => true,
          :advanced_search => {:operator => :like}

    field :country,
          :actions => [:index, :new, :edit, :show],
          :advanced_search => {:operator => :equal},
          :relation_column => :name

    field :cities,
          :actions => [:show, :edit, :new],
          :show_as_list => true,
          :nested_form => true,
          :nested_form_allow_destroy => true,
          :nested_form_modes => [:associate],
          :relation_column => :name

    field :created_at, :actions => [:index, :show]
    field :updated_at, :actions => [:index, :show]

    action :show
    action :edit
    action :destroy
    action :new

    scope :all
    scope :national, :default => true
    scope :international

  end
end
