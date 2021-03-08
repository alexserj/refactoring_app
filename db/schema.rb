# db/schema.rb

# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20200429100752) do

  # ...

  create_table "gigs", :force => true do |t|
    t.string   "title"
    t.string   "state"
    t.datetime "date_from"
    t.text     "description"
    t.float    "stage_width"
    t.float    "stage_depth"
    t.boolean  "available_pa",                                 :default => false
    t.text     "annotation_for_pa"
    t.boolean  "available_backline",                           :default => false
    t.text     "annotation_for_backline"
    t.boolean  "available_stage_light",                        :default => false
    t.text     "annotation_for_stage_light"
    t.boolean  "travel_expenses_negotiable",                   :default => true
    t.boolean  "accommodation_negotiable",                     :default => false
    t.boolean  "available_backstage_room",                     :default => false
    t.text     "annotation_for_backstage_room"
    t.boolean  "available_catering",                           :default => false
    t.text     "annotation_for_catering"
    t.boolean  "available_guest_list",                         :default => false
    t.integer  "guest_list_count"
    t.boolean  "available_soundman",                           :default => false
    t.boolean  "available_security",                           :default => false
    t.boolean  "available_promoter_insurance",                 :default => false
    t.boolean  "fixed_fee_option",                             :default => false
    t.integer  "fixed_fee_max"
    t.boolean  "deal_option",                                  :default => false
    t.integer  "deal_max_number_of_audience"
    t.string   "gig_type_custom"
    t.integer  "gig_type_cd"
    t.integer  "stage_type_cd"
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.integer  "user_id",                                                         :null => false
    t.integer  "promoter_id",                                                     :null => false
    t.boolean  "looking_for_dj"
    t.boolean  "looking_for_live"
    t.integer  "inquiries_count",                              :default => 0
    t.float    "deal_split_amount_for_promoter"
    t.float    "deal_possible_fee_min"
    t.float    "deal_possible_fee_max"
    t.float    "deal_guaranteed_artist_fee"
    t.float    "deal_break_even_point"
    t.float    "deal_fee_max"
    t.float    "deal_possible_fee_tax",                        :default => 0.07
    t.integer  "contracts_count",                              :default => 0
    t.integer  "gig_invite_send_count",                        :default => 0
    t.integer  "distance"
    t.string   "slug"
    t.integer  "highrise_id"
    t.datetime "date_to"
    t.integer  "wanted_artist_count"
    t.string   "currency",                                     :default => "EUR"
    t.boolean  "fixed_fee_negotiable",                         :default => false
    t.boolean  "is_featured",                                  :default => false
    t.boolean  "premium",                                      :default => false
    t.boolean  "send_gig_invites_for_premium_artists",         :default => true
    t.integer  "cents_per_inquiry",                            :default => 100
    t.text     "custom_fields"
    t.boolean  "insurance_included",                           :default => false
    t.boolean  "declined_insurance_pre_damages",               :default => false
    t.text     "tags"
    t.integer  "parent_id"
    t.boolean  "fixed_fee_gross_amounts_only",                 :default => false
    t.datetime "application_deadline"
    t.string   "sidekiq_application_deadline_close_job_id"
    t.string   "sidekiq_application_deadline_reminder_job_id"
    t.string   "sidekiq_gig_expire_job_id"
  end

  add_index "gigs", ["parent_id"], :name => "index_gigs_on_parent_id"
  add_index "gigs", ["promoter_id"], :name => "index_gigs_on_profile_id"
  add_index "gigs", ["user_id"], :name => "index_gigs_on_user_id"

  create_table "inquiries", :force => true do |t|
    t.integer  "fixed_fee"
    t.float    "travel_expenses"
    t.integer  "travel_party_count"
    t.boolean  "accommodation_required",       :default => false
    t.integer  "accommodation_standard_cd"
    t.integer  "accommodation_buy_out"
    t.text     "annotation"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.integer  "user_id"
    t.integer  "promoter_id"
    t.integer  "artist_id"
    t.boolean  "side_agreements_optional",     :default => false
    t.string   "artist_contact"
    t.string   "state"
    t.integer  "gig_id"
    t.boolean  "travel_expenses_included",     :default => true
    t.text     "decline_annotation"
    t.boolean  "fixed_fee_negotiable",         :default => true
    t.boolean  "fixed_fee_option",             :default => false
    t.boolean  "deal_option",                  :default => false
    t.float    "deal_possible_fee_min"
    t.float    "deal_fee_max"
    t.text     "withdraw_annotation"
    t.datetime "read_at"
    t.integer  "conversation_id"
    t.boolean  "matching",                     :default => false
    t.string   "sidekiq_decline_job_id"
    t.float    "fee_sortable",                 :default => 0.0
    t.text     "tags"
    t.text     "custom_fields"
    t.float    "average_voting_score"
    t.boolean  "fixed_fee_gross_amounts_only", :default => false
    t.boolean  "favorite",                     :default => false, :null => false
    t.datetime "accepted_at"
    t.datetime "declined_at"
    t.datetime "expired_at"
    t.datetime "withdrawn_at"
  end

  add_index "inquiries", ["gig_id"], :name => "index_inquiries_on_gig_id"
  add_index "inquiries", ["user_id"], :name => "index_inquiries_on_user_id"

  # ...

end
