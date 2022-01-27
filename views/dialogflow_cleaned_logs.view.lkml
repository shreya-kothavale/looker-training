view: dialogflow_cleaned_logs {
  sql_table_name: `looker_training.dialogflow_cleaned_logs`
    ;;

  dimension: action {
    type: string
    sql: ${TABLE}.action ;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: intent_detection_confidence {
    type: number
    sql: ${TABLE}.intent_detection_confidence ;;
  }

  dimension: intent_triggered {
    type: string
    sql: ${TABLE}.intent_triggered ;;
  }

  dimension: is_fallback {
    type: yesno
    sql: ${TABLE}.isFallback ;;
  }

  dimension: language_code {
    type: string
    sql: ${TABLE}.language_code ;;
  }

  dimension: magnitude {
    type: number
    sql: ${TABLE}.magnitude ;;
  }

  dimension: month_number {
    type: number
    sql: ${TABLE}.month_number ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: query_text {
    type: string
    sql: ${TABLE}.query_text ;;
  }

  dimension: query_text_redacted {
    type: string
    sql: ${TABLE}.query_text_redacted ;;
  }

  dimension: response_id {
    type: string
    sql: ${TABLE}.response_ID ;;
  }

  dimension: sentiment_score {
    type: number
    sql: ${TABLE}.sentiment_score ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_ID ;;
  }

  dimension_group: time {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.time ;;
  }

  dimension_group: time_stamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.time_stamp ;;
  }

  dimension: week_number {
    type: number
    sql: ${TABLE}.week_number ;;
  }

  dimension: sentiment_bucket {
    type: tier
    tiers: [-1,-0.6,-0.2,0.2,0.6,1]
    sql: ${sentiment_score} ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: total_sessions {
    type: count_distinct
    sql: ${session_id} ;;
  }

  measure: average_queries_per_session {
    type: number
    sql: count(${query_text})/${total_sessions} ;;
  }

  measure: average_session_per_day {
    type: number
    sql: ${total_sessions}/count(distinct ${time_date}) ;;
  }

  measure: average_sentiment_score {
    type: average
    sql: ${sentiment_score};;
  }

  measure: average_intent_detection_confidence {
    type: average
    sql: ${intent_detection_confidence};;
  }

  measure: success_rate {
    type: number
    sql: sum(if(${is_fallback},0,1))/${count} ;;
  }
}
