variable "account_id" {
  description = "AWS Account where this stack will be created"
  type        = string
}

variable "aws_region" {
  description = "AWS Region where this stack will be created"
  type        = string
}

variable "environment" {
  description = "Amazon Connect environemnt where this stack will be created"
  type        = string
}

variable "connect_instance_friendly_name" {
  description = "The friendly name of your Amazon Connect instance for ease of reference (i.e. Dev, Prod, UAT). Alphanumeric, no spaces."
  type        = string
}

variable "connect_instance_arn" {
  description = "The Amazon Connect instance ARN (i.e. Prod). Alphanumeric, no spaces."
  type = string
}

variable "connect_instance_id" {
  description = "The Amazon Connect instance ID"
  type        = string
} 

# Queue Variables

variable "basic_queue_arn" {
  description = "Basic Queue ARN"
  type        = string
}

# Prompt Variables

variable "Beep_prompt_arn" {
  description = "Beep prompt ARN"
  type        = string
}

variable "CustomerHold_prompt_arn" {
  description = "CustomerHold prompt ARN"
  type        = string
}                                     

variable "CustomerQueue_prompt_arn" {
  description = "CustomerQueue prompt ARN"
  type        = string
}
     
variable "Music_Jazz_MyTimetoFly_Inst_prompt_arn" {
  description = "Music_Jazz_MyTimetoFly_Inst prompt ARN"
  type        = string
}

variable "Music_Pop_ThisAndThatIsLife_Inst_prompt_arn" {
  description = "Music_Pop_ThisAndThatIsLife_Inst prompt ARN"
  type        = string
}

variable "Music_Pop_ThrowYourselfInFrontOfIt_Inst_prompt_arn" {
  description = "Music_Pop_ThrowYourselfInFrontOfIt_Inst prompt ARN"
  type        = string
}

variable "Music_Rock_EverywhereTheSunShines_Inst_prompt_arn" {
  description = "Music_Rock_EverywhereTheSunShines_Inst prompt ARN"
  type        = string
}


# Hours of Operation Variables
variable "Spanish_HOOP_International_Support_arn" {
  description = "Spanish HOOP (International Support) ARN"
  type        = string
}


variable "Canada_Business_Hours_arn" {
  description = "Canada Business Hours ARN"
  type        = string
}

variable "Germany_Business_Hours_arn" {
  description = "Germany Business Hours ARN"
  type        = string
}

variable "Basic_Hours_arn" {
  description = "Basic Hours ARN"
  type        = string
}

variable "German_HOOP_International_Support_arn" {
  description = "German HOOP (International Support) ARN"
  type        = string
}

variable "Brazilian_Portuguese_HOOP_International_Support_arn" {
  description = "Brazilian/Portuguese HOOP (International Support) ARN"
  type        = string
}

variable "_24x7_arn" {
  description = "24x7 ARN"
  type        = string
}

variable "Snowball_Business_Hours_arn" {
  description = "Snowball Business Hours ARN"
  type        = string
}


variable "French_HOOP_International_Support_arn" {
  description = "French HOOP (International Support) ARN"
  type        = string
}

variable "UK_Business_Hours_arn" {
  description = "UK Business Hours ARN"
  type        = string
}

variable "India_Hours_arn" {
  description = "India Hours ARN"
  type        = string
}

# Contact Flow Module Variables

variable "Contact_Center_Call_Count_flow_module" {
  description = "Contact_Center_Call_Count flow module ARN"
  type        = string
}

variable "Contact_Center_Idle_Time" {
  description = "Contact_Center_Idle_Time flow module ARN"
  type        = string
}

variable "Contact_Center_Queue_Queue" {
  description = "Contact_Center_Queue_Queue flow module ARN"
  type        = string
}

variable "Contact_Center_Get_Call" {
  description = "Contact_Center_Get_Call flow module ARN"
  type        = string
}

# Contact Flow Variables

variable "Default_agent_hold_flow_arn" {
  description = "Default agent hold contact flow ARN"
  type        = string
}

variable "Default_agent_transfer_flow_arn" {
  description = "Default agent transfer contact flow ARN"
  type        = string
}

variable "Default_agent_whisper_flow_arn" {
  description = "Default agent whisper contact flow ARN"
  type        = string
}

variable "Default_customer_hold_flow_arn" {
  description = "Default customer hold contact flow ARN"
  type        = string
}

variable "Default_customer_queue_flow_arn" {
  description = "Default customer queue contact flow ARN"
  type        = string
}

variable "Default_customer_queue_flow_arn" {
  description = "Default customer queue contact flow ARN"
  type        = string
}

variable "Default_customer_whisper_flow_arn" {
  description = "Default customer whisper contact flow ARN"
  type        = string
}

variable "Default_outbound_flow_arn" {
  description = "Default outbound contact flow ARN"
  type        = string
}

variable "Default_queue_transfer_flow_arn" {
  description = "Default queue transfer flow ARN"
  type        = string
}