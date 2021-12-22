class CreateAgencyRequirements < ActiveRecord::Migration
  def change
    create_table :agency_offices do |t|
      t.text :name, null: false, unique: true
      t.text :abbreviation

      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    create_table :agency_offer_codes do |t|
      t.text :name, null: false, unique: true

      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    create_table :agency_offer_scopes do |t|
      t.text :name, null: false, unique: true

      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    create_table :agency_offer_agreements do |t|
      t.text :name, null: false, unique: true

      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    create_table :agency_contract_types do |t|
      t.text :name, null: false, unique: true

      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    create_table :agency_cos do |t|
      t.text :first_name, null: false
      t.text :last_name, null: false
      t.text :phone
      t.text :email
      t.text :address1
      t.text :address2
      t.text :city
      t.text :state
      t.text :zip

      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    create_table :agency_naics_codes do |t|
      t.text :code, index: true, null: false, unique: true
      t.text :industry_title
      t.text :size_dollars_mm
      t.text :size_employees

      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end

    create_table :agency_requirements do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.references :organization, index: true, foreign_key: true
      t.references :duty_station, index: true, foreign_key: true
      t.references :program, index: true, foreign_key: true
      t.references :agency_naics_code, index: true, foreign_key: true
      t.references :agency_office, index: true, foreign_key: true, null: false
      t.references :agency_offer_code, index: true, foreign_key: true
      t.references :agency_offer_scope, index: true, foreign_key: true
      t.references :agency_offer_agreement, index: true, foreign_key: true
      t.references :agency_contract_type, index: true, foreign_key: true
      t.references :agency_co, index: true, foreign_key: true
      t.text :title, null: false
      t.text :description
      t.date :received_on
      t.decimal :estimated_contract_value, precision: 15, scale: 2
      t.decimal :contract_value, precision: 15, scale: 2
      t.text :offer_solicitation_number
      t.text :offer_value
      t.text :contract_number
      t.text :agency_comments
      t.text :contract_comments
      t.text :comments
      t.boolean :contract_awarded

      t.datetime :deleted_at, index: true
      t.timestamps null: false
    end
  end
end
