# shibboleth-apache-springboot
Here try to mix a shibboleth (with optional ldap) and apache module protecting website and load balance to springboot aplication.

## Shibboleth
Using (this)[https://github.com/JanOppolzer/shibboleth-sp-docker] aproach try to configure a simple...

## Apache
Using (this)[https://github.com/mconf/apache-shib-docker] add custom apache configuration...

## Spring boot
Using (this)[https://github.com/wlod/experimental-lb-modjk] extend this aproach to use a loadbalancer that point directly to springboot where we configure internal tomcat to use mod_jk.

## Extra

### Others
https://github.com/Unicon/shibboleth-idp-dockerized
https://github.com/iay/shibboleth-idp-docker

### Ldap
https://github.com/osixia/docker-openldap

### Information about ...
https://shibboleth.atlassian.net/wiki/spaces/CONCEPT/pages/928645290/FlowsAndConfig
https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065335062/Apache