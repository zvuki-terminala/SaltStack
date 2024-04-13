nginx_pkg:
  pkg.installed:
    - name: nginx

docker_pkg:
  pkg.installed:
    - name: docker.io

redis_pkg:
  pkg.installed:
    - name: redis