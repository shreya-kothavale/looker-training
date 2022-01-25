view: session_level {
 derived_table: {
   sql:
  SELECT session_id, intent_triggered AS entry_intent FROM
  (SELECT session_id, intent_triggered, ROW_NUMBER() OVER (PARTITION BY session_id  ORDER BY time_stamp  ASC) AS entry_rn
  FROM dialogflow_cleaned_logs )
  WHERE entry_rn =1
  ;;
 }
}

view: exit_intent {
  derived_table: {
    sql:
      SELECT session_id, intent_triggered AS exit_intent FROM
      (SELECT session_id, intent_triggered, ROW_NUMBER() OVER (PARTITION BY session_id  ORDER BY time_stamp  DESC) AS exit_rn
      FROM dialogflow_cleaned_logs )
      WHERE exit_rn =1
      ;;
  }
}

view: second_last_intent {
  derived_table: {
    sql:
      SELECT session_id, intent_triggered AS second_last_intent FROM
      (SELECT session_id, intent_triggered, ROW_NUMBER() OVER (PARTITION BY session_id  ORDER BY time_stamp  DESC) AS exit_rn
      FROM dialogflow_cleaned_logs )
      WHERE exit_rn =2
      ;;
  }
}


view: conversation_length {
  derived_table: {
    sql:
      Select session_id, DATETIME_DIFF(end_time, start_time, second) as conversation_length_in_seconds, count_of_msg, session_date_time
      from
      (SELECT session_id, min( time_stamp ) as start_time, max( time_stamp ) as end_time, count(distinct response_ID) as count_of_msg, MIN( time_stamp_MST ) as session_date_time
      FROM dialogflow_cleaned_logs
      group by session_id)
      ;;
  }
}

explore: session_level {
  join: exit_intent {
    type: left_outer
    relationship: one_to_one
    sql_on: session_level.session_id = exit_intent.session_id ;;
  }
  join: second_last_intent {
    type: left_outer
    relationship: one_to_one
    sql_on: session_level.session_id = second_last_intent.session_id ;;
  }
  join: conversation_length {
    type: left_outer
    relationship: one_to_one
    sql_on: session_level.session_id = conversation_length.session_id ;;
  }
}
