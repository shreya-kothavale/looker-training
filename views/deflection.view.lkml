view: deflection {
  derived_table: {
    sql: select dialogflow_cleaned_logs.session_id,
    sum(case when dialogflow_cleaned_logs.isFallback is true then 1
    else 0 end) as fallback,
    sum(case when dialogflow_cleaned_logs.intent_triggered = "LiveAgentTransfer" then 1
    else 0 end) as agent_transfer,

    from dialogflow_cleaned_logs
    group by session_id
    ;;
  }

  dimension: session_id {
    type: string
    primary_key: yes
  }

  dimension:  fallback {
    type: number
  }

  dimension:  agent_transfer {
    type: number
  }

  dimension: deflection_bucket {
    case: {
      when: {
        sql: ${fallback} = 0 and ${agent_transfer} = 0 ;;
        label: "Successfully Handled End to End by Bot"
      }
      when: {
        sql: ${fallback} > 0 and ${agent_transfer} = 0 ;;
        label: "Partially Handled by Bot (No Live Agent Transfer)"
      }
      when: {
        sql: ${fallback} > 0 and ${agent_transfer} > 0 ;;
        label: "Partially Handled by Bot (Live Agent Transfer)"
      }
      when: {
        sql: ${fallback} = 0 and ${agent_transfer} > 0 ;;
        label: "Expected Live Agent Transfer as per the flow"
      }
    }
  }

  dimension: deflection_rate {
    case: {
      when: {
        sql: ${deflection_bucket} = "Successfully Handled End to End by Bot" or ${deflection_bucket} = "Partially Handled by Bot (No Live Agent Transfer)";;
        label: "Fully Deflected"
      }
      when: {
        sql: ${deflection_bucket} = "Partially Handled by Bot (Live Agent Transfer)";;
        label: "Partially Deflected"
      }
      when: {
        sql: ${deflection_bucket} = "Expected Live Agent Transfer as per the flow" ;;
        label: "Not Deflected"
      }
    }
  }
}
