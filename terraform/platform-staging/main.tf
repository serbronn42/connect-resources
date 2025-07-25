# Sample Contact Flow Module Resource

# resource "aws_connect_contact_flow_module" "test_case_creation" {
#  instance_id  = var.connect_instance_id
#  name         = "test case creation"
#  description  = "Test deployment for case creation"
#  content     = templatefile("${path.module}/../../contact-flow-modules/test_sf_case_create.json.tftpl", local.template_vars)
#
#  tags = {
#    "Application" = "Terraform",
#    "Method"      = "<Create>/<Import>"
#  }
# }

# Contact Flow Module Resources

import {
  to = aws_connect_contact_flow_module.Contact_Center_Queue
  id = "${var.connect_instance_id}:9448a147-a85b-476a-abea-63e134d35329"
}

resource "aws_connect_contact_flow_module" "Contact_Center_Queue" {
  instance_id = var.connect_instance_id
  name        = "Contact Center - Queue"
  description = "Contact Center - Queue"
  content     = templatefile("${path.module}/../../contact-flow-modules/Contact Center - Queue.json.tftpl", local.template_vars) 

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import
  }
}

import {
  to = aws_connect_contact_flow_module.Contact_Center_Call_Count
  id = "${var.connect_instance_id}:be24366b-781a-4207-939b-691a49b25468"
}

resource "aws_connect_contact_flow_module" "Contact_Center_Call_Count" {
  instance_id = var.connect_instance_id
  name        = "Contact Center - Call-Count"
  description = ""
  content     = templatefile("${path.module}/../../contact-flow-modules/Contact Center - Call-Count.json.tftpl", local.template_vars)

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import
  }
}

import {
  to = aws_connect_contact_flow_module.Contact_Center_Idle_Time
  id = "${var.connect_instance_id}:767c7be8-c3f0-41da-8e37-24c814074a87"
}

resource "aws_connect_contact_flow_module" "Contact_Center_Idle_Time" {
  instance_id = var.connect_instance_id
  name        = "Contact Center - Idle-Time"
  description = ""
  content     = templatefile("${path.module}/../../contact-flow-modules/Contact Center - Idle-Time.json.tftpl", local.template_vars)

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import
  }
}

import {
  to = aws_connect_contact_flow_module.Contact_Center_Get_Call
  id = "${var.connect_instance_id}:07792854-6d23-45f2-ae94-61b94d6580b4"
}

resource "aws_connect_contact_flow_module" "Contact_Center_Get_Call" {
  instance_id  = var.connect_instance_id
  name         = "Contact Center  - Get Call"
  description  = "update 7-8-2025"
  content      = templatefile("${path.module}/../../contact-flow-modules/Contact Center - Get Call.json.tftpl", local.template_vars)

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import
  }
}

# Sample Contact Flow Resource

# resource "aws_connect_contact_flow" "Test_Chat_Flow" {
#  instance_id = var.connect_instance_id
#  name        = "Test Chat Flow"
#  description = "Chat Flow in Dev environment"
#  type        = "CUSTOMER_QUEUE"
#  content     = templatefile("${path.module}/../../contact-flows/test_chat_flow.json.tftpl", local.template_vars)
#
#  tags = {
#    "Application" = "Terraform"
#    "Method"      = "Create"
#  } 
# }

# Sample to import Contact Flow Resource

# import {
#   to = aws_connect_contact_flow.test_case
#   id = "${var.connect_instance_id}:dc4a8808-4ca8-431c-bd1f-63700565e8f0"
# }

# resource "aws_connect_contact_flow" "test_case" {
#  instance_id  = var.connect_instance_id
#  name         = "Test case"
#  description  = "Import test case"
#  type         = "CONTACT_FLOW"
#  content     = templatefile("${path.module}/../../contact-flows/test case.json.tftpl", local.template_vars)
#  tags   = {
#    "Application" = "Terraform"
#    "Method"      = "Create"
#  } 
# }

# Contact Flow Resources

import {
  to = aws_connect_contact_flow.Default_agent_hold
  id = "${var.connect_instance_id}:2543dfe1-93af-4cf8-ad0f-a8b8a925b9af"
}

resource "aws_connect_contact_flow" "Default_agent_hold" {
  instance_id = var.connect_instance_id
  name        = "Default agent hold"
  description = ""
  type        = "AGENT_HOLD"
  content     = templatefile("${path.module}/../../contact-flows/Default agent hold.json.tftpl", local.template_vars)

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import"
  }
}

import {
  to = aws_connect_contact_flow.Default_agent_transfer
  id = "${var.connect_instance_id}:15ba0e48-0f7c-4c83-bbfe-fcbde202aa58"
}

resource "aws_connect_contact_flow" "Default_agent_transfer" {
  instance_id = var.connect_instance_id
  name        = "Default agent transfer"
  description = ""
  type        = "AGENT_TRANSFER"
  content     = templatefile("${path.module}/../../contact-flows/Default agent transfer.json.tftpl", local.template_vars)

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import"
  }
}

import {
  to = aws_connect_contact_flow.Default_agent_whisper
  id = "${var.connect_instance_id}:76c78a4d-395d-4275-8cae-e98ba8149898"
}

resource "aws_connect_contact_flow" "Default_agent_whisper" {
  instance_id = var.connect_instance_id
  name        = "Default agent whisper"
  description = ""
  type        = "AGENT_WHISPER"
  content     = templatefile("${path.module}/../../contact-flows/Default agent whisper.json.tftpl", local.template_vars)

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import
  }
}

import {
  to = aws_connect_contact_flow.Default_customer_hold
  id = "${var.connect_instance_id}:6dead538-262b-40e7-bee4-dc2499e2cfa2"
}

resource "aws_connect_contact_flow" "Default_customer_hold" {
  instance_id = var.connect_instance_id
  name        = "Default customer hold"
  description = ""
  type        = "CUSTOMER_HOLD"
  content     = templatefile("${path.module}/../../contact-flows/Default customer hold.json.tftpl", local.template_vars)

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import
  }
}

import {
  to = aws_connect_contact_flow.Default_customer_queue
  id = "${var.connect_instance_id}:78fc55dd-9b53-4a80-9b89-ddde5417d27c"
}

resource "aws_connect_contact_flow" "Default_customer_queue" {
  instance_id = var.connect_instance_id
  name        = "Default customer queue"
  description = ""
  type        = "CUSTOMER_QUEUE"
  content     = templatefile("${path.module}/../../contact-flows/Default customer queue.json.tftpl", local.template_vars)

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import
  }
}

import {
  to = aws_connect_contact_flow.Default_customer_whisper
  id = "${var.connect_instance_id}:37a4ed5f-1e7a-4035-ad0f-6cc0e026b928"
}

resource "aws_connect_contact_flow" "Default_customer_whisper" {
  instance_id = var.connect_instance_id
  name        = "Default customer whisper"
  description = ""
  type        = "CUSTOMER_WHISPER"
  content     = templatefile("${path.module}/../../contact-flows/Default customer whisper.json.tftpl", local.template_vars)

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import
  }
}

import {
  to = aws_connect_contact_flow.Default_outbound
  id = "${var.connect_instance_id}:9c7028f7-e09b-4741-8053-0930d3a6670e"
}

resource "aws_connect_contact_flow" "Default_outbound" {
  instance_id = var.connect_instance_id
  name        = "Default outbound"
  description = ""
  type        = "OUTBOUND_WHISPER"
  content     = templatefile("${path.module}/../../contact-flows/Default outbound.json.tftpl", local.template_vars)

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import
  }
}

import {
  to = aws_connect_contact_flow.Default_queue_transfer
  id = "${var.connect_instance_id}:cd0a127a-f487-4b85-9ceb-f8aa59b1a55f"
}

resource "aws_connect_contact_flow" "Default_queue_transfer" {
  instance_id = var.connect_instance_id
  name        = "Default queue transfer"
  description = ""
  type        = "QUEUE_TRANSFER"
  content     = templatefile("${path.module}/../../contact-flows/Default queue transfer.json.tftpl", local.template_vars)

  tags = {
    "Application" = "Terraform"
    "Method"      = "Import
  }
}