Terraform module that can turn off/on environment based on ec2 tag.
We can also define hours when environment should turn off or on, or contral it manualy

Module create lambda function, that is doing all the work.

example :

Power on:

     module "power_off" {
       source    = "git::https://github.com/madpawel/terraform-powersupply-module.git"
       env_name  = "staging"
       tag_name  = "instance-role"
       tag_value = "web"
       action    = "off"
       time      = "0 17 * * ? *"
     }

Power off:


    module "power_on" {
      source    = "git::https://github.com/madpawel/terraform-powersupply-module.git"
      env_name  = "staging"
      tag_name  = "instance-role"
      tag_value = "web"
      action    = "on"
      time      = "manual"
    }
