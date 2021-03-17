# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :uuid, comment: 'user global uuid from users service'
      t.string :name, comment: 'user name'
      t.string :phone, comment: 'user phone'
      t.date :birthdate, comment: 'user birth date'
      t.string :android_key, comment: 'user android key for push notification'
      t.string :ios_key, comment: 'user ios key for push notification'
      t.string :locale, comment: 'user preferred language'

      t.timestamps
    end
  end
end
