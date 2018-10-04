FROM bgbilling/my:7.1 as my

ARG JBOSS_STANDALONE=/opt/jboss/wildfly/standalone

RUN set -x \
  && mkdir -p /bgbilling-docker/mybgbilling/ \
  && cp ${JBOSS_STANDALONE}/configuration/standalone.xml /bgbilling-docker/mybgbilling// \
  && cp ${JBOSS_STANDALONE}/deployments/MyBGBilling.war/WEB-INF/jboss-web.xml /bgbilling-docker/mybgbilling// \
  && cp ${JBOSS_STANDALONE}/deployments/MyBGBilling.war/WEB-INF/*.groovy /bgbilling-docker/mybgbilling/


FROM bgbilling/server:7.1 as packager

RUN set -x \
  && mkdir -p /bgbilling-docker/mysql/data \
  && mkdir -p /bgbilling-docker/mysql/initdb.d \
  && mkdir -p /bgbilling-docker/activemq/data \
  && mkdir -p /bgbilling-docker/server/log \
  && mkdir -p /bgbilling-docker/mybgbilling/log \
  && cp /opt/bgbilling/BGBillingServer/data/data.properties /bgbilling-docker/server/ \
  && cp /opt/bgbilling/BGBillingServer/data/log4j.xml /bgbilling-docker/server/ \
  && cp /opt/bgbilling/BGBillingServer/.install/dump.sql /bgbilling-docker/mysql/initdb.d/

COPY mysql/my.cnf /bgbilling-docker/mysql
COPY mysql/initdb.d/user.sql /bgbilling-docker/mysql/initdb.d
COPY activemq /bgbilling-docker/activemq
COPY docker-stack.yml init.sh start.sh stop.sh destroy.sh /bgbilling-docker/
COPY init.sh /bgbilling-docker/
COPY --from=my /bgbilling-docker/mybgbilling/ /bgbilling-docker/mybgbilling/


FROM frameloss/empty-container

COPY --from=packager /bgbilling-docker /bgbilling-docker