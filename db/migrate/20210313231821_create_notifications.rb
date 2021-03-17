# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.string :channel_type, null: false, comment: 'notifications types [sms| push]'
      t.json :filter, null: false, comment: 'user filters'
      t.string :status, null: false, comment: 'notifications status [pending| running| finished]'

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Notification.create_translation_table! message: :string
      end

      dir.down do
        Notification.drop_translation_table!
      end
    end
  end
end
