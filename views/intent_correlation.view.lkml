view: intent_correlation {
  derived_table: {
    sql:
    SELECT A.session_id, A.intent_triggered, B.intent_triggered as intent_list FROM (
SELECT session_id,intent_triggered  FROM dialogflow_cleaned_logs) A
INNER JOIN (
SELECT session_id,intent_triggered  FROM dialogflow_cleaned_logs) B
using (session_id)
where A.intent_triggered != B.intent_triggered
    ;;
  }

  dimension: session_id {
    type:  string
  }

  dimension: intent_triggered {
    type:  string
  }

  dimension: intent_list {
    type:  string
  }

  measure: count {
    type: count_distinct
    sql: ${session_id} ;;
  }

}

# view: intent_correlation {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
