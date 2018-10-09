#!/bin/sh -eux

URL=https://raw.githubusercontent.com/bgbilling
VERSION=7.1



if echo "$@" | grep -Eq '\bmariadb\b'; then

  [ ! -d /var/lib/mysql ]
  
  echo "Installing MariaDB"

  if cat /etc/os-release | grep -Eq '\bDebian\b'; then
    apt-get update && apt-get -q -y install mysql-server mysql-client
  else
    yum update && yum -y install mariadb-server
  fi
  
  systemctl stop mysql
  
  curl -fsSL https://raw.githubusercontent.com/bgbilling/images-base/master/install/mysql/5.7/my.cnf -o /etc/my.cnf
  
  mkdir -p /etc/systemd/system/mariadb.service.d/
  { \
    echo '[Service]'; \
    echo 'LimitNOFILE=10000'; \
  } > /etc/systemd/system/mariadb.service.d/limits.conf
  
  systemctl restart mariadb
  
fi


if echo "$@" | grep -Eq '\bjdk8\b'; then

  [ ! -d /opt/java/jdk8 ]
  [ ! -f /usr/bin/java ]
  
  echo "Installing JDK8"

  if cat /etc/os-release | grep -Eq '\bDebian\b'; then

    mkdir -p /tmp/bgb-install-base
    curl -fsSL $URL/images-base/master/install/jdk-8-debian.sh -o /tmp/bgb-install-base/jdk-8-debian.sh
    sh -eux /tmp/bgb-install-base/jdk-8-debian.sh
  
  else
  
    yum -y install java-1.8.0-openjdk-devel
    mkdir -p /opt/java && ln -svT /usr/lib/jvm/java /opt/java/jdk8
    
    { \
      echo '#!/bin/sh'; \
      echo; \
      echo 'JAVA_HOME=/opt/java/jdk8'; \
    } > /etc/profile.d/java_home.sh
  
  fi
  
fi


if echo "$@" | grep -Eq '\bactivemq\b'; then
  echo "Installing ActiveMQ"
  mkdir -p /tmp/bgb-install-base
  curl -fsSL $URL/images-base/master/install/activemq/5.15.5/activemq.sh -o /tmp/bgb-install-base/activemq.sh
  sh -eux /tmp/bgb-install-base/activemq.sh
fi


if echo "$@" | grep -Eq '\bwildfly\b'; then
  echo "Installing Wildfly"
  mkdir -p /tmp/bgb-install-base
  curl -fsSL $URL/images-base/master/install/wildfly/11.0.0/wildfly.sh -o /tmp/bgb-install-base/wildfly.sh
  sh -eux /tmp/bgb-install-base/wildfly.sh
fi


if echo "$@" | grep -Eq '\bbgbilling\b'; then
  echo "Installing BGBillingServer"
  mkdir -p /tmp/bgb-install-base
  curl -fsSL $URL/images-billing/${VERSION}/install/server/bgbilling.sh -o /tmp/bgb-install-base/bgbilling.sh
  sh -eux /tmp/bgb-install-base/bgbilling.sh
fi


if echo "$@" | grep -Eq '\bmy\b'; then
  echo "Installing MyBGBilling"
  mkdir -p /tmp/bgb-install-base
  curl -fsSL $URL/images-billing/${VERSION}/install/mybgbilling.sh -o /tmp/bgb-install-base/mybgbilling.sh
  sh -eux /tmp/bgb-install-base/mybgbilling.sh
fi


if echo "$@" | grep -Eq '\bnginx\b'; then
  echo "Installing Nginx"
  
  [ ! -f /etc/nginx/nginx.conf ]
  
  if [ -n "`which apt-get`" ]; then apt-get -q -y install nginx ; else yum -y install epel-release; yum -y install nginx ; fi ;
  
  if [ -d "/etc/nginx/sites-enabled/" ]; then 
  
    curl -fsSL $URL/images-billing/${VERSION}/install/nginx/bgbilling.local -o /etc/nginx/sites-available/bgbilling.local
    ln /etc/nginx/sites-available/bgbilling.local /etc/nginx/sites-enabled/bgbilling.local
    rm -f /etc/nginx/sites-enabled/default
    
  else
  
    curl -fsSL $URL/images-billing/${VERSION}/install/nginx/bgbilling.local -o /etc/nginx/conf.d/bgbilling.conf
    sed -i "s@80 default_server;@80;@" /etc/nginx/nginx.conf
    
  fi
fi