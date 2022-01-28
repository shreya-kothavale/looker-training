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

  dimension: session_id {
    type: string
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

#   dimension: session_date_time {
#     type: number
#   }
}
