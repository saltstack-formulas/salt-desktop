# -*- coding: utf-8 -*-
# vim: ft=yaml
---
airflow:
  identity:
    airflow:
      user: airflow       # local or ldap username
      group: airflow       # local or ldap groupname
      skip_user_state: false   # false if local user; true if ldap user
  database:
    airflow:
      user: airflow
      pass: airflow
      email: airflow@localhost
  config:
    airflow:
      flask:
        auth_type: AUTH_DB # AUTH_LDAP, etc

        #### Active Directory Example ####
        auth_ldap_server: ldap://ldapserver.new
        auth_ldap_append_domain: example.com

        ## see https://confluence.atlassian.com/kb/how-to-write-ldap-search-filters-792496933.html
        # auth_ldap_search_filter: (&(objectCategory=Person)(sAMAccountName=*)(|(memberOf=cn=grpRole_myteam,OU=ouEngineers_myteam,dc=example,dc=com)(memberOf=cn=grpRole_yourteam,OU=ouEngineers_yourteam,dc=example,dc=com)))
        auth_ldap_search_filter: (memberOf=CN=myGrpRole,OU=myOrg,DC=example,DC=com)

        #### Admin is initially ok for 'admins', but change to Viewer for everyone else
        auth_user_registration_role: Admin
        auth_user_registration: True

      content:
        api: {}
        celery_kubernetes_executor: {}
        celery:
          # https://docs.celeryproject.org/en/v5.0.2/getting-started/brokers
          default_queue: /airflow
          broker_url: amqp://rabbit:rabbit@127.0.0.1:5672/airflow
          # broker_url: redis://127.0.0.1:6379/0
          result_backend: db+postgresql://airflow:airflow@127.0.0.1/airflow

        cli: {}
        core:
          authentication: True  # gone in v2
          dags_folder: /home/airflow/dags
          plugins_folder: /home/airflow/plugins
          executor: CeleryExecutor
          default_timezone: utc
          load_examples: True
          # https://stackoverflow.com/questions/45455342
          sql_alchemy_conn: postgresql+psycopg2://airflow:airflow@127.0.0.1/airflow
          security: ''
        webserver:
          secret_key: {{ range(1,20000) | random }}
      state_colors:
        # https://airflow.apache.org/docs/apache-airflow/stable/howto/customize-state-colors-ui.html
        queued: 'darkgray'
        running: '#01FF70'
        success: '#2ECC40'
        failed: 'firebrick'
        up_for_retry: 'yellow'
        up_for_reschedule: 'turquoise'
        upstream_failed: 'orange'
        skipped: 'darkorchid'
        scheduled: 'tan'
  service:
    airflow:
      enabled:
        - airflow-celery-flower
        - airflow-scheduler
        - airflow-webserver
        - airflow-celery-worker
  pkg:
    airflow:
      version: 2.0.1
      extras:
        # Read these first
        # https://airflow.apache.org/docs/apache-airflow/stable/installation.html#extra-packages
        # https://airflow.apache.org/docs/apache-airflow/stable/extra-packages-ref.html

        # Bundle Extras

        # NOT VERIFIED == "I HAD ISSUES WITH THESE!"
        # all               # All Airflow user facing features  # NOT VERIFIED
        # all_dbs           # All database integrations  # NOT VERIFIED
        # devel             # Minimum dev tools requirements  # NOT VERIFIED
        # devel_hadoop      # devel + hadoop devel  # NOT VERIFIED
        # devel_all         # Everything for development  # NOT VERIFIED
        # devel_ci          # Development requirements used in CI

        # Apache Software Extras
        # apache.atlas      # Apache Atlas to use Data Lineage feature
        # apache.beam
        # apache.cassandra  # Cassandra related operators & hook
        # apache.druid      # Druid related operators & hooks
        # apache.hdfs       # HDFS hooks and operators
        # apache.hive       # All Hive related operators
        # apache.kylin
        # apache.livy
        # apache.pig
        # apache.pinot      # Pinot DB hook
        # apache.spark
        # apache.sqoop

        # Services Extras
        - amazon
        - azure
        # databricks        # Databricks hooks and operators
        - datadog           # Datadog hooks and sensors
        # dask
        # dingding
        # discord
        # facebook
        - google            # Google Cloud
        # github_enterprise # GitHub Enterprise auth backend
        - google_auth       # Google auth backend
        - hashicorp         # Hashicorp Services (Vault)
        - jira              # Jira hooks and operators
        # opsgenie
        # pagerduty         # PagerDuty ..
        # plexus
        # qubole            # Enable QDS (Qubole Data Service) support
        # salesforce        # Salesforce hook
        - sendgrid          # Send email using sendgrid
        # segment           # Segment hooks and sensors
        # sentry
        - slack             # airflow.providers.slack.operators.slack.SlackAPIOperator
        # snowflake
        # telegram
        # vertica           # Vertica hook support as an Airflow backend
        # yandex
        # zendesk

        ## Software Extras
        # async             # Async worker classes for Gunicorn
        - celery            # CeleryExecutor
        - cncf.kubernetes   # Kubernetes Executor and operator
        - docker            # Docker hooks and operators
        - elasticsearch     # Elasticsearch hooks and Log Handler
        # exasol
        # jenkins
        - ldap              # LDAP authentication for users
        - mongo             # Mongo hooks and operators
        - microsoft.mssql   # Microsoft SQL server
        - mysql             # MySQL operators and hook, support as Airflow backend (mysql 5.6.4+)
        # odbc
        # openfaas
        # oracle
        - postgres          # PostgreSQL operators and hook, support as an Airflow backend
        - password          # Password authentication for users
        # presto
        - rabbitmq          # RabbitMQ support as a Celery backend
        - redis             # Redis hooks and sensors
        - samba             # Samba hooks and operators
        # singularity
        - statsd            # Needed by StatsD metrics
        # tableau
        - virtualenv

        ## Standard protocol Extras
        # cgroups           # Needed To use CgroupTaskRunner
        - ftp
        - grpc              # Grpc hooks and operators
        - http              # http hooks and providers
        - imap              # IMAP hooks and sensors
        # jdbc
        - kerberos          # Kerberos integration
        # papermill         # Papermill hooks and operators
        - sftp
        - sqlite
        - ssh               # SSH hooks and Operator
        - microsoft.winrm   # WinRM hooks and operators

  linux:
    altpriority: 0   # zero disables alternatives
...
