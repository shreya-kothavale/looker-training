view: session_level {
  derived_table: {
    sql:
      SELECT session_id, intent_triggered AS entry_intent FROM
      (SELECT session_id, intent_triggered, ROW_NUMBER() OVER (PARTITION BY session_id  ORDER BY time_stamp  ASC) AS entry_rn
      FROM dialogflow_cleaned_logs )
      WHERE entry_rn =1
      ;;
  }
  dimension: session_id {
    type: string
  }

  dimension: entry_intent {
    type: string
  }

  measure: total_sessions {
    type: count
    drill_fields: []
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

  dimension: exit_intent {
    type: string
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

  dimension: second_last_intent {
    type: string
  }
}


view: conversation_length {
  derived_table: {
    sql:
      Select session_id,
      start_time, end_time,
      count_of_msg, session_date_time
      from
      (SELECT session_id, min( time_stamp ) as start_time, max( time_stamp ) as end_time, count(distinct response_ID) as count_of_msg, MIN( time_stamp ) as session_date_time
      FROM dialogflow_cleaned_logs
      group by session_id)
      ;;
  }

  dimension_group: conversation_length_in_seconds {
    type: duration
    intervals: [second, minute]
    sql_start: conversation_length.start_time ;;
    sql_end: conversation_lengthgraduation.end_time ;;
  }

  dimension: count_of_msg {
    type: number
  }

  dimension: session_date_time {
    type: number
  }
}
