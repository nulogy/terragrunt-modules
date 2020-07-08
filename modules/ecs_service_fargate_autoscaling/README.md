## ECS Fargate Service with Autoscaling support

Use this module to create a service on ECS which does not require a load balancer. e.g. background workers.

Despite the name, this module doesn't actually configure the autoscaling. It simply sets the ignore_changes lifecycle
attribute on the desired count of the ecs service so that terraform doesn't fight with any autoscaling rules you add
somewhere else.

