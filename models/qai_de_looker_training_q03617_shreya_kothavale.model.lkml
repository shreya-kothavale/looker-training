connection: "qai_de_looker_training_q03617_shreya_kothavale"

# include all the views
include: "/views/**/*.view"

datagroup: qai_de_looker_training_q03617_shreya_kothavale_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: qai_de_looker_training_q03617_shreya_kothavale_default_datagroup

explore: dialogflow_cleaned_logs {}
