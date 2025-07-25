# Optional to combine dev.auto.tfvars with locals.tf. Can use either of the files

account_id                     = "900994844936"
aws_region                     = "us-west-2"
environment                    = "development"
connect_instance_friendly_name = "dev-call-center"
connect_instance_id            = "c89f02a6-xxxx-xxxx-xxxx-5449378047"
connect_instance_arn           = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047"

# Queue Mappings
Basic_queue_arn                                     = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/queue/3b9ead53-f4d5-425b-b29b-ded236cc40fe"

# Hours Of Operation Mappings
Germany_Business_Hours_arn                          = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/operating-hours/05b8a8c4-4c6c-4397-a3e2-0a1953d122d5"
Testing_Only_Hours_arn                              = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/operating-hours/1550ac66-ab73-4329-b0a6-350b65e41a3d"
Brazilian_Portuguese_HOOP_International_Support_arn = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/operating-hours/23c9e5d1-a7c7-45c8-995c-e6af52a31830"
Spanish_HOOP_International_Support_arn              = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/operating-hours/2a9eb2cf-8e4d-49ac-83e2-b9a56707a52e"
India_Hours_arn                                     = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/operating-hours/3b989594-a971-4feb-a81d-f3d0d3eff533"
UK_Business_Hours_arn                               = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/operating-hours/52cc70c7-1458-464b-9743-a81bc2ff5005"
French_HOOP_International_Support_arn               = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/operating-hours/53c7caad-5751-40ce-a9cb-16c71318f71a"
Canada_Business_Hours_arn                           = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/operating-hours/80a6c8de-cf27-4abf-9187-e09d4aa07692"
Basic_Hours_arn                                     = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/operating-hours/833c85a4-451b-4b37-a153-3ae540c2b578"
German_HOOP_International_Support_arn               = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/operating-hours/a3661e9e-9856-4b2f-9892-de0e5425e67c"

# Contact Flow Modules Mappings
Contact_Center_Call_Count                                       = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/flow-module/be24366b-781a-4207-939b-691a49b25468"
Contact_Center_Idle_Time                                        = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/flow-module/767c7be8-c3f0-41da-8e37-24c814074a87"
Contact_Center_Queue_Queue                                      = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/flow-module/b15061d9-ec29-47e5-8857-9ec8d938cf3d"
Contact_Center_Get_Call                                         = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/flow-module/07792854-6d23-45f2-ae94-61b94d6580b4"

# Contact Flows Mapping
Default_agent_hold_flow_arn                                                 = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/contact-flow/2543dfe1-93af-4cf8-ad0f-a8b8a925b9af"
Default_agent_transfer_flow_arn                                             = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/contact-flow/15ba0e48-0f7c-4c83-bbfe-fcbde202aa58"
Default_agent_whisper_flow_arn                                              = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/contact-flow/76c78a4d-395d-4275-8cae-e98ba8149898"
Default_customer_hold_flow_arn                                              = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/contact-flow/6dead538-262b-40e7-bee4-dc2499e2cfa2"
Default_customer_queue_flow_arn                                             = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/contact-flow/78fc55dd-9b53-4a80-9b89-ddde5417d27c"
Default_customer_whisper_flow_arn                                           = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/contact-flow/37a4ed5f-1e7a-4035-ad0f-6cc0e026b928"
Default_outbound_flow_arn                                                   = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/contact-flow/9c7028f7-e09b-4741-8053-0930d3a6670e"
Default_queue_transfer_flow_arn                                             = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/contact-flow/cd0a127a-f487-4b85-9ceb-f8aa59b1a55f"

# Prompt Mappings
Beep_prompt_arn                                    = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/prompt/d37429e6-92bc-484e-8407-831641efc45c"
CustomerHold_prompt_arn                            = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/prompt/b20b0a00-b950-4217-a925-d0449dcb74e9"
CustomerQueue_prompt_arn                           = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/prompt/def90bda-5f21-4d9f-bc88-afe067c5a1ae"
Music_Jazz_MyTimetoFly_Inst_prompt_arn             = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/prompt/94e6fa8b-d5b6-465b-970b-a386453c7546"
Music_Pop_ThisAndThatIsLife_Inst_prompt_arn        = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/prompt/aeacc244-d99e-4775-a7a3-4165a385cb65"
Music_Pop_ThrowYourselfInFrontOfIt_Inst_prompt_arn = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/prompt/df0c69ea-38d9-4ec5-9bac-b785d9afd619"
Music_Rock_EverywhereTheSunShines_Inst_prompt_arn  = "arn:aws:connect:us-east-1:900994844936:instance/c89f02a6-xxxx-xxxx-xxxx-5449378047/prompt/f4be591d-5b4a-4379-b062-81ede35e19b4"