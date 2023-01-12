variable "key_name" {
  description = "Key Pair"
  default     = "kafka-key"                # Change it to the name of the key in AWS
}

variable "region" {
  description = "Region"
  default     = "us-east-1"               
}

variable "ami" {
  description = "AMI of instance"
  default     = "ami-08fdec01f5df9998f"   # The ami changes over time
}

variable "instance" {
  description = "Instance type"
  default     = "t2.large"                # This will cost money!!!! 
}
