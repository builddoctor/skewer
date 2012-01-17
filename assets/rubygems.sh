#!/usr/bin/env bash

lsbdistcodename=$(grep DISTRIB_CODENAME /etc/lsb-release |cut -d'=' -f2)
if [ "$lsbdistcodename" == "hardy" -o "$lsbdistcodename" == "lucid" ]; then
  
echo "updating system config"
cat <<-EOF > '/etc/apt/sources.list.d/maverick.list'
  deb http://archive.ubuntu.com/ubuntu/ maverick universe
  deb http://archive.ubuntu.com/ubuntu/ maverick-updates universe
  deb http://security.ubuntu.com/ubuntu maverick-security universe
EOF

cat <<-EOF > /etc/apt/preferences.d/maverick
  APT::Default-Release "lucid";
  Package: rubygems1.8
  Pin: release a=maverick
  Pin-Priority: 900
  Package: rubygems
  Pin: release a=maverick
  Pin-Priority: 900
EOF
  
fi

cat <<-EOF > "/etc/profile.d/rubygems.sh"
  #!/bin/bash
  export GEM_HOME=/var/lib/gems/1.8
  export GEM_PATH=/var/lib/gems/1.8
  PATH=\${PATH}:\${GEM_HOME}/bin
EOF
chmod 0755 /etc/profile.d/rubygems.sh
. /etc/profile.d/rubygems.sh
aptitude update >/dev/null
aptitude install -y ruby rubygems libopenssl-ruby ruby-dev build-essential libxml2-dev libxslt-dev
gem install bundler --no-rdoc --no-ri
gem install json --no-rdoc --no-ri
