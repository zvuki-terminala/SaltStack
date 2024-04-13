nginx_service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: nginx_pkg

redis_service:
  service.running:
    - name: redis
    - enable: True
    - require:
      - pkg: redis_pkg