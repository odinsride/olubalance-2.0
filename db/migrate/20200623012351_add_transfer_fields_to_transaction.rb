# frozen_string_literal: true

class AddTransferFieldsToTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :transfer, :boolean, default: false
  end
end
