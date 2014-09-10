module Carnival
  class QueryService

    def initialize(model, presenter, query_form)
      @model = model
      @presenter = presenter
      @query_form = query_form
      @should_include_relation = !@model.is_a?(ActiveRecord::Relation)
    end

    def get_query
      records = @model
      records = scope_query(records)
      records = date_period_query(records)
      records = search_query(records)
      records = advanced_search_query(records)
      records = page_query(records)
      records = order_query(records)
      records = includes_relations(records)
    end

    def scope_query(records)
      if(@query_form.scope.present? && @query_form.scope.to_sym != :all)
        records = records.send(@query_form.scope)
      end
      records
    end

    def date_period_query(records)
      date_filter_field = @presenter.date_filter_field
      if(date_filter_field.present? && @query_form.date_period_from.present? && @query_form.date_period_from != "" && @query_form.date_period_to.present? && @query_form.date_period_to != "")
        records = records.where("#{@presenter.table_name}.#{date_filter_field.name} between ? and ?", "#{@query_form.date_period_from} 00:00:00", "#{@query_form.date_period_to} 23:59:59")
      end
      records
    end

    def search_query(records)
      filtros = []
      if @query_form.search_term.present? and @presenter.searchable_fields.size > 0
        @presenter.searchable_fields.each do |key, field|
          filtros << "#{key.to_s} like :search"
        end
        records = includes_relations(records) if @should_include_relation
        records = records.where(filtros.join(" or "), search: "%#{@query_form.search_term}%")
      end
      records
    end

    def advanced_search_query(records)
      return records if !@query_form.advanced_search.present?
      @presenter.parse_advanced_search(records, @query_form.advanced_search)
    end

    def page_query(records)
        records = records.paginate(page: @query_form.page, per_page: @presenter.items_per_page)
    end

    def order_query(records)
      records.order("#{sort_column} #{sort_direction}")
    end

    def includes_relations(records)
      if @should_include_relation
        @presenter.join_tables.each do |relation_name|
          records = records.includes(relation_name)
        end
      end
      records
    end

    def sort_column
      fields = @presenter.fields_for_action(:index)
      if fields.size > 0
        columns =  fields.map {|k, v| k.to_s}
      end
        
      column_index = @query_form.sort_column_index.to_i
      column_index = column_index - 1 if @presenter.has_batch_actions?

      column = columns[column_index]
      if @presenter.relation_field? column.to_sym
        column_name = "#{column.pluralize}.name"
      else
        column_name = "#{@presenter.table_name}.#{column}"
      end
      #@query_form.sort_column = column_name
    end

    def sort_direction
      #return 'desc' if params[:sSortDir_0] == 'desc'
      'asc'
    end

  end
end
