# -*- coding: utf-8 -*-
# vim: ft=yaml
---
rabbitmq:
  cluster:
    rabbitmq@locahost:
      user: rabbitmq
      host: rabbitmqhost  # short hostname of node to join to, not fqdn
      ram_node: None
      runas: rabbitmq
      erlang_cookie:
        name: /var/lib/rabbitmq/.erlang_cookie
        value: shared-value-for-all-cluster-members
  vhost:
    - airflow
  user:
    airflow:
      - password: airflow
      - force: true
      - tags: administrator
      - perms:
          - 'airflow':
              - '.*'
              - '.*'
              - '.*'
      - runas: root
  queue:
    airflow:
      # note: dict
      user: airflow
      passwd: airflow
      durable: true
      auto_delete: false
      vhost: airflow
      arguments:
        - 'x-message-ttl': 8640000
        - 'x-expires': 8640000
        - 'x-dead-letter-exchange': 'airflow'
  binding:
    airflow:
      - destination_type: queue
      - destination: airflow
      - routing_key: airflow_routing_key
      - user: airflow
      - passwd: password
      - vhost: airflow
      - arguments:
          - 'x-message-ttl': 8640000
  exchange:
    airflow:
      - user: airflow
      - passwd: airflow
      - type: fanout
      - durable: true
      - internal: false
      - auto_delete: false
      - vhost: airflow
      - arguments:
          - 'alternate-**exchange': 'amq.fanout'
          - 'test-header': 'testing'
  policy: {}
  upstream: {}
