connection: "qai_de_looker_training_q03617_shreya_kothavale"

# include all the views
include: "/views/**/dialogflow_cleaned_logs.view"
include: "/views/**/session_level.view"
include: "/views/**/exit_intent.view"
include: "/views/**/second_last_intent.view"
include: "/views/**/conversation_length.view"

datagroup: qai_de_looker_training_q03617_shreya_kothavale_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: qai_de_looker_training_q03617_shreya_kothavale_default_datagroup

explore: dialogflow_cleaned_logs {}

explore: session_level {
  join: exit_intent {
    type: left_outer
    relationship: one_to_one
    sql_on: ${session_level.session_id} = ${exit_intent.exit_intent} ;;
    # fields: [exit_intent]
  }
  join: second_last_intent {
    type: left_outer
    relationship: one_to_one
    sql_on: ${exit_intent.exit_intent} = ${second_last_intent.session_id} ;;
    # fields: [second_last_intent]
  }
  join: conversation_length {
    type: left_outer
    relationship: one_to_one
    sql_on: ${second_last_intent.session_id} = ${conversation_length.session_id} ;;
    # fields: []
  }
}
