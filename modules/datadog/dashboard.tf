resource "datadog_dashboard" "dashboard" {
  layout_type = "free"
  title    = var.environment_name

  widget {
    layout = {
      "height" = "4"
      "width" = "45"
      "x"   = "1"
      "y"   = "3"
    }

    free_text_definition {
      color   = "#4d4d4d"
      font_size = "36"
      text    = var.environment_name
      text_align = "left"
    }
  }
  widget {
    layout = {
      "height" = "41"
      "width" = "67"
      "x"   = "1"
      "y"   = "9"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = true
      time    = {}
      title    = "App transaction time"
      title_align = "left"
      title_size = "16"

      event {
        q              = "tags:service:${var.environment_name}"
        tags_execution = "and"
      }

      request {
        display_type = "area"
        q      = "avg:trace.rack.request.duration{service:${var.environment_name}/app_worker}"

        metadata {
          alias_name = "Rack"
          expression = "avg:trace.rack.request.duration{service:${var.environment_name}/app_worker}"
        }

        style {
          line_type = "solid"
          line_width = "thin"
          palette  = "orange"
        }
      }
      request {
        display_type = "area"
        q      = "avg:trace.rails.action_controller.duration{service:${var.environment_name}/app_worker}"

        metadata {
          alias_name = "Action Controller"
          expression = "avg:trace.rails.action_controller.duration{service:${var.environment_name}/app_worker}"
        }

        style {
          line_type = "solid"
          line_width = "thin"
          palette  = "orange"
        }
      }
      request {
        display_type = "area"
        q      = "avg:trace.rails.render_template.duration{service:${var.environment_name}/app_worker}"

        metadata {
          alias_name = "Action View Template"
          expression = "avg:trace.rails.render_template.duration{service:${var.environment_name}/app_worker}"
        }

        style {
          line_type = "solid"
          line_width = "thin"
          palette  = "purple"
        }
      }
      request {
        display_type = "area"
        q      = "avg:trace.rails.render_partial.duration{service:${var.environment_name}/app_worker}"

        metadata {
          alias_name = "Action View Partials"
          expression = "avg:trace.rails.render_partial.duration{service:${var.environment_name}/app_worker}"
        }

        style {
          line_type = "solid"
          line_width = "thin"
          palette  = "purple"
        }
      }
      request {
        display_type = "area"
        q      = "avg:trace.active_record.instantiation.duration{service:${var.environment_name}/app_worker}"

        metadata {
          alias_name = "Active Record"
          expression = "avg:trace.active_record.instantiation.duration{service:${var.environment_name}/app_worker}"
        }

        style {
          line_type = "solid"
          line_width = "thin"
          palette  = "cool"
        }
      }
      request {
        display_type = "area"
        q      = "avg:trace.postgres.query.duration{service:${var.environment_name}/app_worker-postgres}"

        metadata {
          alias_name = "PostgreSQL"
          expression = "avg:trace.postgres.query.duration{service:${var.environment_name}/app_worker-postgres}"
        }

        style {
          line_type = "solid"
          line_width = "thin"
          palette  = "cool"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "1"
      "y"   = "51"
    }

    toplist_definition {
      time    = {}
      title    = "Most time consuming app worker transactions"
      title_align = "left"
      title_size = "16"

      request {
        apm_query {
          compute = {
            "aggregation" = "avg"
            "facet"    = "@duration"
          }
          index  = "trace-search"
          search = {
            "query" = "service:\"${var.environment_name}/app_worker\""
          }

          group_by {
            facet = "resource_name"
            limit = 10
            sort = {
              "aggregation" = "avg"
              "facet"    = "@duration"
              "order"    = "desc"
            }
          }
        }

        conditional_formats {
          comparator = "<"
          hide_value = false
          palette  = "white_on_green"
          value   = 5000000000
        }
        conditional_formats {
          comparator = ">"
          hide_value = false
          palette  = "white_on_yellow"
          value   = 5000000000
        }
        conditional_formats {
          comparator = ">"
          hide_value = false
          palette  = "white_on_red"
          value   = 30000000000
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "69"
      "y"   = "30"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {}
      title    = "App apdex score"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "anomalies(avg:trace.rack.request.apdex.by.service{service:${var.environment_name}/app_worker}, 'basic', 5)"

        metadata {
          alias_name = "Apdex score"
          expression = "anomalies(avg:trace.rack.request.apdex.by.service{service:${var.environment_name}/app_worker}, 'basic', 5)"
        }

        style {
          line_type = "solid"
          line_width = "thick"
          palette  = "purple"
        }
      }
      request {
        display_type = "line"
        q      = "autosmooth(week_before(avg:trace.rack.request.apdex.by.service{service:${var.environment_name}/app_worker}))"

        metadata {
          alias_name = "week before"
          expression = "autosmooth(week_before(avg:trace.rack.request.apdex.by.service{service:${var.environment_name}/app_worker}))"
        }

        style {
          line_type = "dashed"
          line_width = "normal"
          palette  = "grey"
        }
      }

      yaxis {
        include_zero = false
        max     = "1"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "69"
      "y"   = "9"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {}
      title    = "App throughput"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "bars"
        q      = "sum:aws.cloudfront.requests{name:${var.environment_name}_cloudfront_distribution}.as_count().rollup(sum, 60)"

        metadata {
          alias_name = "CloudFront"
          expression = "sum:aws.cloudfront.requests{name:${var.environment_name}_cloudfront_distribution}.as_count().rollup(sum, 60)"
        }

        style {
          line_type = "solid"
          line_width = "thick"
          palette  = "grey"
        }
      }
      request {
        display_type = "line"
        q      = "sum:trace.rack.request.hits{service:${var.environment_name}/app_worker}.as_count().rollup(sum, 60)"

        metadata {
          alias_name = "Rack"
          expression = "sum:trace.rack.request.hits{service:${var.environment_name}/app_worker}.as_count().rollup(sum, 60)"
        }

        style {
          line_type = "solid"
          line_width = "thick"
          palette  = "cool"
        }
      }
      request {
        display_type = "line"
        q      = "autosmooth(week_before(sum:trace.rack.request.hits{service:${var.environment_name}/app_worker}.as_count().rollup(sum, 60)))"

        metadata {
          alias_name = "week before"
          expression = "autosmooth(week_before(sum:trace.rack.request.hits{service:${var.environment_name}/app_worker}.as_count().rollup(sum, 60)))"
        }

        style {
          line_type = "dashed"
          line_width = "normal"
          palette  = "dog_classic"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "69"
      "y"   = "51"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {}
      title    = "App error rate (%)"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "bars"
        q      = "sum:aws.cloudfront.total_error_rate{name:${var.environment_name}_cloudfront_distribution}"

        metadata {
          alias_name = "CloudFront"
          expression = "sum:aws.cloudfront.total_error_rate{name:${var.environment_name}_cloudfront_distribution}"
        }

        style {
          line_type = "solid"
          line_width = "normal"
          palette  = "grey"
        }
      }
      request {
        display_type = "area"
        q      = "100*sum:trace.rack.request.errors{service:${var.environment_name}/app_worker} by {http.status_code}.as_rate().rollup(sum, 60)/sum:trace.rack.request.hits{service:${var.environment_name}/app_worker}.as_count().rollup(sum, 60)"

        metadata {
          alias_name = "Rack"
          expression = "100*sum:trace.rack.request.errors{service:${var.environment_name}/app_worker} by {http.status_code}.as_rate().rollup(sum, 60)/sum:trace.rack.request.hits{service:${var.environment_name}/app_worker}.as_count().rollup(sum, 60)"
        }

        style {
          line_type = "solid"
          line_width = "thin"
          palette  = "warm"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "22"
      "width" = "33"
      "x"   = "1"
      "y"   = "72"
    }

    hostmap_definition {
      group      = [
        "ecs_container_name",
      ]
      no_group_hosts = true
      no_metric_hosts = true
      node_type    = "container"
      scope      = [
        "ecs_container_name:${var.environment_name}_app_worker",
      ]
      title      = "Containers"
      title_align   = "left"
      title_size   = "16"

      request {
        fill {
          q = "avg:process.stat.container.io.wbps{ecs_container_name:${var.environment_name}_app_worker} by {host}"
        }

        size {
          q = "avg:process.stat.container.memory.rss{ecs_container_name:${var.environment_name}_app_worker} by {host}"
        }
      }

      style {
        palette   = "YlOrRd"
        palette_flip = false
      }
    }
  }
  widget {
    layout = {
      "height" = "22"
      "width" = "33"
      "x"   = "35"
      "y"   = "72"
    }

    timeseries_definition {
      show_legend = false
      time    = {}
      title    = "CPU per container"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "avg:ecs.fargate.cpu.percent{ecs_container_name:${var.environment_name}_app_worker} by {container_id}"

        metadata {
          alias_name = "CPU"
          expression = "avg:ecs.fargate.cpu.percent{ecs_container_name:${var.environment_name}_app_worker} by {container_id}"
        }

        style {
          line_type = "solid"
          line_width = "normal"
          palette  = "dog_classic"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "22"
      "width" = "33"
      "x"   = "35"
      "y"   = "95"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {}
      title    = "Memory per container"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "avg:ecs.fargate.mem.usage{ecs_container_name:${var.environment_name}_app_worker} by {container_id}"

        metadata {
          alias_name = "Memory"
          expression = "avg:ecs.fargate.mem.usage{ecs_container_name:${var.environment_name}_app_worker} by {container_id}"
        }

        style {
          line_type = "solid"
          line_width = "normal"
          palette  = "dog_classic"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "35"
      "y"   = "51"
    }

    toplist_definition {
      time    = {}
      title    = "Most time consuming PostgreSQL transactions"
      title_align = "left"
      title_size = "16"

      request {
        apm_query {
          compute = {
            "aggregation" = "avg"
            "facet"    = "@duration"
          }
          index  = "trace-search"
          search = {
            "query" = "service:\"${var.environment_name}/app_worker-postgres\""
          }

          group_by {
            facet = "resource_name"
            limit = 10
            sort = {
              "aggregation" = "avg"
              "facet"    = "@duration"
              "order"    = "desc"
            }
          }
        }

        conditional_formats {
          comparator = "<"
          hide_value = false
          palette  = "white_on_green"
          value   = 5000000000
        }
        conditional_formats {
          comparator = ">"
          hide_value = false
          palette  = "white_on_yellow"
          value   = 5000000000
        }
        conditional_formats {
          comparator = ">"
          hide_value = false
          palette  = "white_on_red"
          value   = 30000000000
        }
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "1"
      "y"   = "118"
    }

    timeseries_definition {
      show_legend = false
      time    = {}
      title    = "External transaction time"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "area"
        q      = "avg:trace.http.request.duration{service:${var.environment_name}/app_worker-external}"

        metadata {
          alias_name = "Outbound Net:HTTP time"
          expression = "avg:trace.http.request.duration{service:${var.environment_name}/app_worker-external}"
        }

        style {
          line_type = "solid"
          line_width = "thin"
          palette  = "cool"
        }
      }
      request {
        display_type = "line"
        q      = "autosmooth(week_before(avg:trace.http.request.duration{service:${var.environment_name}/app_worker-external}))"

        metadata {
          alias_name = "week before"
          expression = "autosmooth(week_before(avg:trace.http.request.duration{service:${var.environment_name}/app_worker-external}))"
        }

        style {
          line_type = "dashed"
          line_width = "normal"
          palette  = "grey"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "69"
      "y"   = "118"
    }

    timeseries_definition {
      show_legend = false
      time    = {}
      title    = "External error rate (%)"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "area"
        q      = "100*sum:trace.http.request.errors{service:${var.environment_name}/app_worker-external}.as_rate().rollup(sum, 60)/sum:trace.http.request.hits{service:${var.environment_name}/app_worker-external}.as_count().rollup(sum, 60)"

        metadata {
          alias_name = "Outbound Net::HTTP Error rate"
          expression = "100*sum:trace.http.request.errors{service:${var.environment_name}/app_worker-external}.as_rate().rollup(sum, 60)/sum:trace.http.request.hits{service:${var.environment_name}/app_worker-external}.as_count().rollup(sum, 60)"
        }

        style {
          line_type = "solid"
          line_width = "thin"
          palette  = "warm"
        }
      }
      request {
        display_type = "line"
        q      = "100*autosmooth(week_before(sum:trace.http.request.errors{service:${var.environment_name}/app_worker-external}.as_rate().rollup(sum, 60)))/autosmooth(week_before(sum:trace.http.request.hits{service:${var.environment_name}/app_worker-external}.as_count().rollup(sum, 60)))"

        metadata {
          alias_name = "week before"
          expression = "100*autosmooth(week_before(sum:trace.http.request.errors{service:${var.environment_name}/app_worker-external}.as_rate().rollup(sum, 60)))/autosmooth(week_before(sum:trace.http.request.hits{service:${var.environment_name}/app_worker-external}.as_count().rollup(sum, 60)))"
        }

        style {
          line_type = "dashed"
          line_width = "normal"
          palette  = "grey"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "22"
      "width" = "33"
      "x"   = "1"
      "y"   = "95"
    }

    servicemap_definition {
      filters   = [
        "env:${var.dd_env}",
      ]
      service   = "${var.environment_name}/app_worker"
      title    = "Service map"
      title_align = "left"
      title_size = "16"
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "35"
      "y"   = "139"
    }

    timeseries_definition {
      show_legend = false
      time    = {}
      title    = "AWS throughput"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "sum:trace.aws.command.hits{service:${var.environment_name}/app_worker-aws}.as_count().rollup(sum, 60)"

        style {
          line_type = "solid"
          line_width = "thick"
          palette  = "orange"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "1"
      "y"   = "139"
    }

    timeseries_definition {
      show_legend = false
      time    = {}
      title    = "AWS transaction time"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "area"
        q      = "avg:trace.aws.command.duration{service:${var.environment_name}/app_worker-aws}"

        metadata {
          alias_name = "Transaction time"
          expression = "avg:trace.aws.command.duration{service:${var.environment_name}/app_worker-aws}"
        }

        style {
          line_type = "solid"
          line_width = "thin"
          palette  = "orange"
        }
      }
      request {
        display_type = "line"
        q      = "autosmooth(week_before(avg:trace.aws.command.duration{service:${var.environment_name}/app_worker-aws}))"

        metadata {
          alias_name = "week before"
          expression = "autosmooth(week_before(avg:trace.aws.command.duration{service:${var.environment_name}/app_worker-aws}))"
        }

        style {
          line_type = "dashed"
          line_width = "thin"
          palette  = "grey"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "35"
      "y"   = "118"
    }

    timeseries_definition {
      show_legend = false
      time    = {}
      title    = "External throughput"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "sum:trace.http.request.hits{service:${var.environment_name}/app_worker-external}.as_count().rollup(sum, 60)"

        metadata {
          alias_name = "Throughput"
          expression = "sum:trace.http.request.hits{service:${var.environment_name}/app_worker-external}.as_count().rollup(sum, 60)"
        }

        style {
          line_type = "solid"
          line_width = "thick"
          palette  = "cool"
        }
      }
      request {
        display_type = "line"
        q      = "autosmooth(week_before(sum:trace.http.request.hits{service:${var.environment_name}/app_worker-external}.as_count().rollup(sum, 60)))"

        metadata {
          alias_name = "week before"
          expression = "autosmooth(week_before(sum:trace.http.request.hits{service:${var.environment_name}/app_worker-external}.as_count().rollup(sum, 60)))"
        }

        style {
          line_type = "dashed"
          line_width = "normal"
          palette  = "grey"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "22"
      "width" = "33"
      "x"   = "69"
      "y"   = "72"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {}
      title    = "CPU average"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "avg:ecs.fargate.cpu.percent{ecs_container_name:${var.environment_name}_app_worker}.rollup(avg, 60)"

        metadata {
          alias_name = "CPU average"
          expression = "avg:ecs.fargate.cpu.percent{ecs_container_name:${var.environment_name}_app_worker}.rollup(avg, 60)"
        }

        style {
          line_type = "solid"
          line_width = "thick"
          palette  = "dog_classic"
        }
      }
      request {
        display_type = "line"
        q      = "autosmooth(week_before(avg:ecs.fargate.cpu.percent{ecs_container_name:${var.environment_name}_app_worker}.rollup(avg, 60)))"

        metadata {
          alias_name = "week before"
          expression = "autosmooth(week_before(avg:ecs.fargate.cpu.percent{ecs_container_name:${var.environment_name}_app_worker}.rollup(avg, 60)))"
        }

        style {
          line_type = "dashed"
          line_width = "normal"
          palette  = "grey"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "22"
      "width" = "33"
      "x"   = "69"
      "y"   = "95"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {}
      title    = "Memory average"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "avg:ecs.fargate.mem.rss{ecs_container_name:${var.environment_name}_app_worker}"

        metadata {
          alias_name = "Memory"
          expression = "avg:ecs.fargate.mem.rss{ecs_container_name:${var.environment_name}_app_worker}"
        }

        style {
          line_type = "solid"
          line_width = "thick"
          palette  = "dog_classic"
        }
      }
      request {
        display_type = "line"
        q      = "autosmooth(week_before(avg:ecs.fargate.mem.rss{ecs_container_name:${var.environment_name}_app_worker}))"

        metadata {
          alias_name = "week before"
          expression = "autosmooth(week_before(avg:ecs.fargate.mem.rss{ecs_container_name:${var.environment_name}_app_worker}))"
        }

        style {
          line_type = "dashed"
          line_width = "normal"
          palette  = "grey"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "41"
      "width" = "33"
      "x"   = "103"
      "y"   = "30"
    }

    event_stream_definition {
      event_size   = "s"
      query     = "Airbrake"
      tags_execution = "and"
      time      = {}
      title     = "Airbrake"
      title_align  = "left"
      title_size   = "16"
    }
  }
  widget {
    layout = {
      "height" = "41"
      "width" = "33"
      "x"   = "103"
      "y"   = "160"
    }

    event_stream_definition {
      event_size   = "s"
      query     = "sources:rds ${var.environment_name}"
      tags_execution = "and"
      time      = {
        "live_span" = "1d"
      }
      title     = "RDS events"
      title_align  = "left"
      title_size   = "16"
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "69"
      "y"   = "160"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {}
      title    = "RDS replication lag"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "autosmooth(avg:aws.rds.replica_lag{resource_group:${var.environment_name}} by {dbinstanceidentifier}.rollup(sum, 300))"

        metadata {
          alias_name = "Replicas"
          expression = "autosmooth(avg:aws.rds.replica_lag{resource_group:${var.environment_name}} by {dbinstanceidentifier}.rollup(sum, 300))"
        }

        style {
          line_type = "solid"
          line_width = "normal"
          palette  = "cool"
        }
      }
      request {
        display_type = "line"
        q      = "autosmooth(avg:aws.rds.replica_lag{resource_group:${var.environment_name}-cross-region} by {dbinstanceidentifier}.rollup(sum, 300))"

        metadata {
          alias_name = "Cross region"
          expression = "autosmooth(avg:aws.rds.replica_lag{resource_group:${var.environment_name}-cross-region} by {dbinstanceidentifier}.rollup(sum, 300))"
        }

        style {
          line_type = "solid"
          line_width = "normal"
          palette  = "cool"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "69"
      "y"   = "181"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {}
      title    = "RDS total I/O"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "avg:aws.rds.read_iops{resource_group:${var.environment_name}} by {dbinstanceidentifier}.as_rate()+avg:aws.rds.write_iops{resource_group:${var.environment_name}} by {dbinstanceidentifier}.as_rate()"

        style {
          line_type = "solid"
          line_width = "normal"
          palette  = "dog_classic"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "1"
      "y"   = "160"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {
        "live_span" = "4h"
      }
      title    = "RDS CPU"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "avg:aws.rds.cpuutilization{resource_group:${var.environment_name}} by {dbinstanceidentifier}"

        style {
          line_type = "solid"
          line_width = "normal"
          palette  = "dog_classic"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "1"
      "y"   = "181"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {}
      title    = "RDS free storage"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "avg:aws.rds.free_storage_space{resource_group:${var.environment_name}} by {dbinstanceidentifier}"

        style {
          line_type = "solid"
          line_width = "normal"
          palette  = "dog_classic"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "35"
      "y"   = "160"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {
        "live_span" = "4h"
      }
      title    = "RDS freeable memory"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "avg:aws.rds.freeable_memory{resource_group:${var.environment_name}} by {dbinstanceidentifier}"

        style {
          line_type = "solid"
          line_width = "normal"
          palette  = "dog_classic"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "35"
      "y"   = "181"
    }

    timeseries_definition {
      legend_size = "0"
      show_legend = false
      time    = {
        "live_span" = "4h"
      }
      title    = "RDS swap"
      title_align = "left"
      title_size = "16"

      request {
        display_type = "line"
        q      = "avg:aws.rds.swap_usage{resource_group:${var.environment_name}} by {dbinstanceidentifier}"

        style {
          line_type = "solid"
          line_width = "normal"
          palette  = "dog_classic"
        }
      }

      yaxis {
        include_zero = true
        max     = "auto"
        min     = "auto"
        scale    = "linear"
      }
    }
  }
  widget {
    layout = {
      "height" = "6"
      "width" = "33"
      "x"   = "103"
      "y"   = "9"
    }

    query_value_definition {
      autoscale  = true
      custom_unit = "rpm"
      precision  = 0
      text_align = "left"
      time    = {
        "live_span" = "1h"
      }
      title    = "Requests cloudfront"
      title_align = "left"
      title_size = "16"

      request {
        aggregator = "avg"
        q     = "sum:aws.cloudfront.requests{name:${var.environment_name}_cloudfront_distribution}.as_count().rollup(sum, 60)"
      }
    }
  }
  widget {
    layout = {
      "height" = "6"
      "width" = "33"
      "x"   = "103"
      "y"   = "16"
    }

    query_value_definition {
      autoscale  = true
      custom_unit = "rpm"
      precision  = 0
      text_align = "left"
      time    = {
        "live_span" = "1h"
      }
      title    = "Requests load balancer"
      title_align = "left"
      title_size = "16"

      request {
        aggregator = "avg"
        q     = "sum:aws.applicationelb.request_count{name:${var.environment_name}-plb}.as_count().rollup(sum, 60)"
      }
    }
  }
  widget {
    layout = {
      "height" = "45"
      "width" = "33"
      "x"   = "103"
      "y"   = "72"
    }

    event_stream_definition {
      event_size   = "s"
      query     = "sources:ecs ${var.environment_name}"
      tags_execution = "and"
      time      = {
        "live_span" = "1d"
      }
      title     = "ECS events"
      title_align  = "left"
      title_size   = "16"
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "1"
      "y"   = "202"
    }

    toplist_definition {
      time    = {}
      title    = "Lambda top functions"
      title_align = "left"
      title_size = "16"

      request {
        q = "top(sum:aws.lambda.invocations{aws_account:${data.aws_caller_identity.current.account_id}} by {functionname}.as_count(), 100, 'sum', 'desc')"
      }
    }
  }
  widget {
    layout = {
      "height" = "20"
      "width" = "33"
      "x"   = "35"
      "y"   = "202"
    }

    toplist_definition {
      time    = {}
      title    = "Lambda errors"
      title_align = "left"
      title_size = "16"

      request {
        q = "top(sum:aws.lambda.errors{aws_account:${data.aws_caller_identity.current.account_id}} by {functionname}.as_count(), 20, 'sum', 'desc')"

        conditional_formats {
          comparator = ">"
          hide_value = false
          palette  = "white_on_red"
          value   = 0
        }
      }
    }
  }
}
