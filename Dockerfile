FROM mysql:8.0

ENV TZ=Asia/Tokyo

ADD ./my.cnf /etc/mysql/conf.d
RUN chmod 644 /etc/mysql/conf.d/my.cnf
