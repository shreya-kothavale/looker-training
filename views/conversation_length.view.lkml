view: conversation_length {
  derived_table: {
    sql:
      Select session_id, sentiment_score,
      start_time, end_time,
      count_of_msg, session_date_time
      from
      (SELECT session_id, avg(sentiment_score) as sentiment_score, min( time_stamp ) as start_time, max( time_stamp ) as end_time, count(distinct response_ID) as count_of_msg, MIN( time_stamp ) as session_date_time
      FROM dialogflow_cleaned_logs
      group by session_id)
      ;;
  }

  dimension: session_id {
    type: string
  }

  dimension_group: conversation_duration {
    type: duration
    intervals: [second, minute]
    sql_start: conversation_length.start_time ;;
    sql_end: conversation_length.end_time ;;
  }

  dimension: count_of_msg {
    type: number
  }

  dimension_group: session_date_time {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: datetime
  }

  dimension: call_duration_bucket {
    case: {
      when: {
        sql: ${minutes_conversation_duration} < 1 ;;
        label: "< 1 min"
      }
      when: {
        sql: ${minutes_conversation_duration} < 3 and ${minutes_conversation_duration} >= 1;;
        label: "1-3 min"
      }
      when: {
        sql: ${minutes_conversation_duration} < 5 and ${minutes_conversation_duration} >= 3;;
        label: "3-5 min"
      }
      when: {
        sql: ${minutes_conversation_duration} < 7 and ${minutes_conversation_duration} >= 5;;
        label: "5-7 min"
      }
      else: "> 7 min"
    }
  }

  dimension: sentiment_score {
    type:  number
  }

  measure: avg_session_duration {
    type: number
    sql: avg(${seconds_conversation_duration}) ;;
    value_format: "MM:SS"
  }

  measure: avg_sentiment_score {
    type: average
    sql: ${sentiment_score} ;;
  }
}
