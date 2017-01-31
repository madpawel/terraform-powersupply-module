#!/bin/env python

# Libs to import
import boto3
import re
import os

def lambda_handler(event, context):

  exclude_reg   = "ALL_EXCLUDES_OFF"
  tag_name      = os.environ['tag_name']
  tag_name_full = 'tag:%s' % tag_name
  tag_value     = os.environ['tag_value']
  action        = os.environ['action']

  # Filter that is used for instances search
  filters = [{
      'Name': tag_name_full,
      'Values': [tag_value]
    }]

  # Connect to AWS and get EC2 resource object
  ec2 = boto3.resource('ec2', region_name='us-west-2')
  env_instances = ec2.instances.filter(Filters=filters)

  # Function to turn on/off ec2 instances
  def action_on_env(env_instances):
    for env_instance in env_instances:
      for tag in env_instance.tags:
        if tag['Key'] == 'Name':
          if re.match(exclude_reg, tag['Value']):
            continue
          else:
            if action == 'on':
              if env_instance.state['Name'] == 'stopped':
                print '[INFO] Turnig ON ' + tag['Value'] + ' instance'
                env_instance.start()
              else:
                print '[INFO] Instance ' + tag['Value'] + ' already running'
            elif action == 'off':
              if env_instance.state['Name'] == 'running':
                print '[INFO] Turnig OFF ' + tag['Value'] + ' instance'
                env_instance.stop()
              else:
                print '[INFO] Instance ' + tag['Value'] + ' already stopped'
            else:
              print '[WARRNING] Action can by: "on" or "off" : -a on'
              exit


  action_on_env(env_instances)
