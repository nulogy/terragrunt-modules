## ECS Fargate Service

Use this module to create a service on ECS which does not require a load balancer. e.g. background workers. A static
desired_count is provided to this module, which may not be appropriate for auto-scaled workloads. See 
[the ecs_service_fargate_autoscaling](../ecs_service_fargate_autoscaling/README.md) module's README for more information.
