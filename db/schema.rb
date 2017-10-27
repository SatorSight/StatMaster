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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171027132630) do

  create_table "article", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "journal_id"
    t.string "image", null: false
    t.string "title", null: false
    t.text "text", limit: 4294967295, null: false
    t.integer "page", null: false
    t.boolean "active", null: false
    t.index ["journal_id"], name: "IDX_23A0E66478E8802"
  end

  create_table "auth", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id"
    t.datetime "date", null: false
    t.string "ip"
    t.string "os"
    t.string "model"
    t.string "device_type"
    t.index ["user_id"], name: "IDX_F8DEB059A76ED395"
  end

  create_table "banner", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "image", limit: 100, null: false
    t.integer "order"
    t.integer "width", null: false
    t.integer "height", null: false
    t.string "link", limit: 200, null: false
    t.integer "sub_id"
    t.boolean "active", null: false
    t.index ["sub_id"], name: "IDX_6F9DB8E756992D9"
  end

  create_table "categories_also", primary_key: ["category_id", "category_j_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "category_id", null: false
    t.integer "category_j_id", null: false
    t.index ["category_id"], name: "IDX_E23F734412469DE2"
    t.index ["category_j_id"], name: "IDX_E23F73446744AE1E"
  end

  create_table "category", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "title", limit: 100, null: false
    t.text "description", limit: 4294967295
    t.string "url", limit: 100, null: false
    t.string "image_main", limit: 100, null: false
    t.integer "order_cat", default: 0, null: false
    t.string "genre", limit: 100
    t.string "publisher", limit: 100
    t.boolean "archived"
    t.string "period"
  end

  create_table "favourite", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id"
    t.string "url", null: false
    t.string "title", null: false
    t.integer "journal_id"
    t.string "page", null: false
    t.string "image", null: false
    t.index ["journal_id"], name: "IDX_62A2CA19478E8802"
    t.index ["user_id"], name: "IDX_62A2CA19A76ED395"
  end

  create_table "feed", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "journal_id"
    t.string "image"
    t.text "text", limit: 4294967295
    t.integer "page"
    t.string "header"
    t.string "link"
    t.boolean "approved"
    t.integer "clicks"
    t.datetime "generated", null: false
    t.index ["journal_id"], name: "IDX_234044AB478E8802"
  end

  create_table "folder", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "folder_name", limit: 100, null: false
    t.date "date_scanned", null: false
  end

  create_table "ip_adress", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "ip", null: false
    t.text "operator", limit: 4294967295, null: false
  end

  create_table "ip_mask", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "operator_id"
    t.string "mask", null: false
    t.string "macro_region"
    t.string "region"
    t.index ["operator_id"], name: "IDX_6C089FBF584598A3"
  end

  create_table "j_tag", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "image", limit: 100, null: false
    t.string "name", limit: 100, null: false
  end

  create_table "journal", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "image_main", limit: 100, null: false
    t.date "date", null: false
    t.integer "number"
    t.integer "listing", null: false
    t.string "path", limit: 100, null: false
    t.boolean "double_number"
    t.boolean "double_month"
    t.boolean "every_week"
    t.boolean "number_set"
    t.integer "category__id"
    t.boolean "feeds_generated"
    t.datetime "added", null: false
    t.index ["category__id"], name: "IDX_C1A7E74D4383686A"
  end

  create_table "journal_hit_stats", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "journal_id"
    t.integer "operator_id"
    t.datetime "time", null: false
    t.integer "page"
    t.string "ip"
    t.index ["journal_id"], name: "IDX_8E1E9AA478E8802"
    t.index ["operator_id"], name: "IDX_8E1E9AA584598A3"
  end

  create_table "journals_also", primary_key: ["journal_id", "journal_j_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "journal_id", null: false
    t.integer "journal_j_id", null: false
    t.index ["journal_id"], name: "IDX_F49CADBE478E8802"
    t.index ["journal_j_id"], name: "IDX_F49CADBE54E7ECD1"
  end

  create_table "listing", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.text "data", limit: 4294967295, null: false
    t.integer "journal_id"
    t.index ["journal_id"], name: "IDX_CB0048D4478E8802"
  end

  create_table "migration_versions", primary_key: "version", id: :string, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
  end

  create_table "operator", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name", null: false
    t.string "tech", null: false
  end

  create_table "page_seen", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id"
    t.string "type", null: false
    t.index ["user_id"], name: "IDX_239616C2A76ED395"
  end

  create_table "saved_journal", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "journal_id"
    t.integer "user_id"
    t.datetime "time", null: false
    t.index ["journal_id"], name: "IDX_4BA628DA478E8802"
    t.index ["user_id"], name: "IDX_4BA628DAA76ED395"
  end

  create_table "search_text_index", id: :integer, force: :cascade, options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "link", null: false
    t.text "content", limit: 4294967295, null: false
    t.string "title", null: false
    t.integer "journal", null: false
    t.integer "type", limit: 2, null: false
    t.string "bundle_name"
    t.string "category_name"
    t.integer "number"
    t.integer "page"
    t.index ["content"], name: "fulltext_content", type: :fulltext
    t.index ["title", "content"], name: "fulltext_title_content", type: :fulltext
    t.index ["title"], name: "fulltext_title", type: :fulltext
  end

  create_table "services", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "title"
    t.integer "order"
    t.string "tech"
    t.string "domain"
    t.string "yandex_counter"
  end

  create_table "services_stat_types", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.bigint "stat_type_id"
    t.bigint "service_id"
    t.index ["service_id"], name: "index_services_stat_types_on_service_id"
    t.index ["stat_type_id"], name: "index_services_stat_types_on_stat_type_id"
  end

  create_table "setting_type", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name", null: false
    t.string "tech", null: false
  end

  create_table "setting_value", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "value", null: false
    t.integer "type_id"
    t.index ["type_id"], name: "IDX_54DFAB55C54C8C93"
  end

  create_table "settings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "label", null: false
    t.string "code", null: false
    t.string "value", null: false
  end

  create_table "stat_results", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.float "value", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "service_id"
    t.bigint "stat_type_id"
    t.index ["service_id"], name: "index_stat_results_on_service_id"
    t.index ["stat_type_id"], name: "index_stat_results_on_stat_type_id"
  end

  create_table "stat_source_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "title"
    t.boolean "active"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stat_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=latin1" do |t|
    t.string "name"
    t.integer "order"
    t.string "title"
    t.string "stat_class"
    t.integer "active", default: 1
    t.bigint "stat_source_type_id"
    t.index ["stat_source_type_id"], name: "index_stat_types_on_stat_source_type_id"
  end

  create_table "subscription", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "title", limit: 100, null: false
    t.string "domain", limit: 100, null: false
    t.string "sub_link", limit: 200, null: false
    t.string "image"
  end

  create_table "subscription_category", primary_key: ["subscription_id", "category_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "category_id", null: false
    t.integer "subscription_id", null: false
    t.index ["category_id"], name: "IDX_61E246ED12469DE2"
    t.index ["subscription_id"], name: "IDX_61E246ED9A1887DC"
  end

  create_table "tag", primary_key: ["journal_id", "tag_id"], force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "journal_id", null: false
    t.integer "tag_id", null: false
    t.index ["journal_id"], name: "IDX_389B783478E8802"
    t.index ["tag_id"], name: "IDX_389B783BAD26311"
  end

  create_table "user", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "operator_id"
    t.string "msisdn", null: false
    t.string "last_page"
    t.string "email"
    t.string "name"
    t.integer "active", limit: 2
    t.index ["operator_id"], name: "IDX_8D93D649584598A3"
  end

  create_table "user_read", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "journal_id"
    t.integer "user_id"
    t.datetime "time", null: false
    t.integer "page"
    t.index ["journal_id"], name: "IDX_E2D60DAE478E8802"
    t.index ["user_id"], name: "IDX_E2D60DAEA76ED395"
  end

  create_table "user_settings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id"
    t.integer "type_id"
    t.integer "value_id"
    t.index ["type_id"], name: "IDX_5C844C5C54C8C93"
    t.index ["user_id"], name: "IDX_5C844C5A76ED395"
    t.index ["value_id"], name: "IDX_5C844C5F920BBA2"
  end

  create_table "user_subscription", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "user_id"
    t.integer "sub_id"
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.index ["sub_id"], name: "IDX_230A18D156992D9"
    t.index ["user_id"], name: "IDX_230A18D1A76ED395"
  end

  add_foreign_key "article", "journal", name: "FK_23A0E66478E8802"
  add_foreign_key "auth", "user", name: "FK_F8DEB059A76ED395"
  add_foreign_key "banner", "subscription", column: "sub_id", name: "FK_6F9DB8E756992D9"
  add_foreign_key "categories_also", "category", column: "category_j_id", name: "FK_E23F73446744AE1E"
  add_foreign_key "categories_also", "category", name: "FK_E23F734412469DE2"
  add_foreign_key "favourite", "journal", name: "FK_62A2CA19478E8802"
  add_foreign_key "favourite", "user", name: "FK_62A2CA19A76ED395"
  add_foreign_key "feed", "journal", name: "FK_234044AB478E8802"
  add_foreign_key "ip_mask", "operator", name: "FK_6C089FBF584598A3"
  add_foreign_key "journal", "category", column: "category__id", name: "FK_C1A7E74D4383686A"
  add_foreign_key "journal_hit_stats", "journal", name: "FK_8E1E9AA478E8802"
  add_foreign_key "journal_hit_stats", "operator", name: "FK_8E1E9AA584598A3"
  add_foreign_key "journals_also", "journal", column: "journal_j_id", name: "FK_F49CADBE54E7ECD1"
  add_foreign_key "journals_also", "journal", name: "FK_F49CADBE478E8802"
  add_foreign_key "listing", "journal", name: "FK_CB0048D4478E8802"
  add_foreign_key "page_seen", "user", name: "FK_239616C2A76ED395"
  add_foreign_key "saved_journal", "journal", name: "FK_4BA628DA478E8802"
  add_foreign_key "saved_journal", "user", name: "FK_4BA628DAA76ED395"
  add_foreign_key "setting_value", "setting_type", column: "type_id", name: "FK_54DFAB55C54C8C93"
  add_foreign_key "subscription_category", "category", name: "FK_61E246ED12469DE2", on_delete: :cascade
  add_foreign_key "subscription_category", "subscription", name: "FK_61E246ED9A1887DC", on_delete: :cascade
  add_foreign_key "tag", "j_tag", column: "tag_id", name: "FK_389B783BAD26311", on_delete: :cascade
  add_foreign_key "tag", "journal", name: "FK_389B783478E8802", on_delete: :cascade
  add_foreign_key "user", "operator", name: "FK_8D93D649584598A3"
  add_foreign_key "user_read", "journal", name: "FK_E2D60DAE478E8802"
  add_foreign_key "user_read", "user", name: "FK_E2D60DAEA76ED395"
  add_foreign_key "user_settings", "setting_type", column: "type_id", name: "FK_5C844C5C54C8C93"
  add_foreign_key "user_settings", "setting_value", column: "value_id", name: "FK_5C844C5F920BBA2"
  add_foreign_key "user_settings", "user", name: "FK_5C844C5A76ED395"
  add_foreign_key "user_subscription", "subscription", column: "sub_id", name: "FK_230A18D156992D9"
  add_foreign_key "user_subscription", "user", name: "FK_230A18D1A76ED395"
end
