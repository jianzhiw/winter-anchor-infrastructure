resource "google_bigquery_dataset" "stock_data_prod" {
    dataset_id = "stock_data_prod"
    location = "US"
    project = "winter-anchor-259905"

    access {
        role = "OWNER"
        user_by_email = "johnnywong5657@gmail.com"
    }
}

resource "google_bigquery_table" "stg_rakuten_stock_transactions" {
    dataset_id = google_bigquery_dataset.stock_data_prod.dataset_id
    table_id = "stg_rakuten_stock_transactions"
    project = "winter-anchor-259905"
    deletion_protection = false

    external_data_configuration {
      autodetect = false
      ignore_unknown_values = false
      source_format = "CSV"
      schema = file("bigquery/stock_data_prod/stg_rakuten_stock_transactions.json")
      source_uris = [
        "https://docs.google.com/spreadsheets/d/1vtlJO4PDrh5Jsvj1ivkJve1zlcXNNm056GoQdws8XyI"
      ]
      csv_options {
        quote = "\""
        field_delimiter = ","
        skip_leading_rows = 1
      }
    }
}

resource "google_bigquery_table" "vw_glb_rakuten_stock_transaction" {
    dataset_id = google_bigquery_dataset.stock_data_prod.dataset_id
    table_id = "glb_rakuten_stock_transactions"
    project = "winter-anchor-259905"
    deletion_protection = false
    view {
      query = file("bigquery/stock_data_prod/vw_glb_rakuten_stock_transactions.sql")
      use_legacy_sql = false
    }
}

resource "google_bigquery_table" "vw_rakuten_transactions_last_100_days" {
    dataset_id = google_bigquery_dataset.stock_data_prod.dataset_id
    table_id = "vw_rakuten_transactions_last_100_days"
    project = "winter-anchor-259905"
    deletion_protection = false
    view {
      query = file("bigquery/stock_data_prod/vw_rakuten_transactions_last_100_days.sql")
      use_legacy_sql = false
    }
}
