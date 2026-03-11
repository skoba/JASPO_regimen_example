# frozen_string_literal: true

class DatabaseController < ApplicationController
  def schema
    @tables = fetch_table_info
  end

  def table
    @table_name = params[:table_name]

    # セキュリティ: テーブル名のホワイトリストチェック
    allowed_tables = ActiveRecord::Base.connection.tables - ['ar_internal_metadata', 'schema_migrations']
    unless allowed_tables.include?(@table_name)
      redirect_to database_schema_path, alert: "Invalid table name"
      return
    end

    @columns = ActiveRecord::Base.connection.columns(@table_name)
    @foreign_keys = ActiveRecord::Base.connection.foreign_keys(@table_name)

    # ページネーション用のパラメータ
    @page = (params[:page] || 1).to_i
    @per_page = 50
    @offset = (@page - 1) * @per_page

    # データを取得
    @total_count = ActiveRecord::Base.connection.execute(
      "SELECT COUNT(*) FROM #{ActiveRecord::Base.connection.quote_table_name(@table_name)}"
    ).first['count'].to_i

    @total_pages = (@total_count.to_f / @per_page).ceil

    @data = ActiveRecord::Base.connection.execute(
      "SELECT * FROM #{ActiveRecord::Base.connection.quote_table_name(@table_name)} LIMIT #{@per_page} OFFSET #{@offset}"
    )
  end

  private

  def fetch_table_info
    tables_info = []

    ActiveRecord::Base.connection.tables.sort.each do |table_name|
      next if table_name == 'ar_internal_metadata' || table_name == 'schema_migrations'

      columns = ActiveRecord::Base.connection.columns(table_name)

      table_info = {
        name: table_name,
        columns: columns.map do |col|
          {
            name: col.name,
            type: col.sql_type,
            null: col.null,
            default: col.default,
            primary: col.name == 'id' || (table_name == 'code_systems' && col.name == 'id')
          }
        end
      }

      # 外部キー情報を取得
      foreign_keys = ActiveRecord::Base.connection.foreign_keys(table_name)
      table_info[:foreign_keys] = foreign_keys.map do |fk|
        {
          column: fk.column,
          to_table: fk.to_table,
          primary_key: fk.primary_key
        }
      end

      # インデックス情報を取得
      indexes = ActiveRecord::Base.connection.indexes(table_name)
      table_info[:indexes] = indexes.map do |idx|
        {
          name: idx.name,
          columns: idx.columns,
          unique: idx.unique
        }
      end

      tables_info << table_info
    end

    tables_info
  end
end
