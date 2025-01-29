# shibboleth-apache-springboot
Here try to mix a shibboleth (with optional ldap) and apache module protecting website and load balance to springboot aplication.

## Steps

### 00-shibboleth-idp

First aproach ...

```
~/shibboleth-apache-springboot/00-shibboleth-idp$ docker build . -t josejuanmontiel/shibboleth-idp

 5 warnings found (use docker --debug to expand):
 - SecretsUsedInArgOrEnv: Do not use ARG or ENV instructions for sensitive data (ENV "JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD") (line 97)
 - FromAsCasing: 'as' and 'FROM' keywords' casing do not match (line 1)
 - UndefinedVar: Usage of undefined variable '$JRE_HOME' (line 18)
 - UndefinedVar: Usage of undefined variable '$JRE_HOME' (line 97)
 - SecretsUsedInArgOrEnv: Do not use ARG or ENV instructions for sensitive data (ENV "JETTY_BROWSER_SSL_KEYSTORE_PASSWORD") (line 97)

~/shibboleth-apache-springboot/00-shibboleth-idp$ docker run -it -v $(pwd):/ext-mount --rm josejuanmontiel/shibboleth-idp init-idp.sh
Please complete the following for your IdP environment:
Hostname: [7327267dd4c1.localdomain]

SAML EntityID: [https://7327267dd4c1.localdomain/idp/shibboleth]

Attribute Scope: [localdomain]

Backchannel PKCS12 Password: 12345678
Cookie Encryption Key Password: 12345678
Warning: /opt/shibboleth-idp-tmp/bin does not exist.
Warning: /opt/shibboleth-idp-tmp/edit-webapp does not exist.
Warning: /opt/shibboleth-idp-tmp/dist does not exist.
Warning: /opt/shibboleth-idp-tmp/doc does not exist.
Warning: /opt/shibboleth-idp-tmp/system does not exist.
Generating Signing Key, CN = 7327267dd4c1.localdomain URI = https://7327267dd4c1.localdomain/idp/shibboleth ...
...done
Creating Encryption Key, CN = 7327267dd4c1.localdomain URI = https://7327267dd4c1.localdomain/idp/shibboleth ...
...done
Creating Backchannel keystore, CN = 7327267dd4c1.localdomain URI = https://7327267dd4c1.localdomain/idp/shibboleth ...
...done
Creating cookie encryption key files...
...done
Rebuilding /opt/shibboleth-idp-tmp/war/idp.war ...
...done

BUILD SUCCESSFUL
Total time: 24 seconds
A basic Shibboleth IdP config and UI has been copied to ./customized-shibboleth-idp/ (assuming the default volume mapping was used).
Most files, if not being customized can be removed from what was exported/the local Docker image and baseline files will be used.
```

FROM josejuanmontiel/shibboleth-idp
MAINTAINER <your_contact_email>
ADD shibboleth-idp/ /opt/shibboleth-idp/

docker build -f Dockerfile.final --tag="josejuanmontiel/shibboleth-idp-custom:latest" .



cd /00-shibboleth-idp/customized-shibboleth-idp/credentials

```bash
openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out certificate.pem
openssl x509 -text -noout -in certificate.pem
openssl pkcs12 -inkey key.pem -in certificate.pem -export -out idp-browser.p12
	12345678
```

docker run -e JETTY_BROWSER_SSL_KEYSTORE_PASSWORD=12345678 -e JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD=12345678 -p 443:4443 josejuanmontiel/shibboleth-idp-custom:latest

https://localhost/idp/


docker run -e JETTY_BROWSER_SSL_KEYSTORE_PASSWORD=12345678 -e JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD=12345678 -it -p 443:4443 josejuanmontiel/shibboleth-idp-custom:latest /bin/bash

#### TODO
Check
    - https://github.com/kristophjunge/docker-test-saml-idp
    - https://gluu.org/docs/gluu-server/3.0.1/integration/saas/testShib2/

### 01-shibboleth-idp

In this part we install SP part...


openssl genrsa 2048 > apache-key.pem 
openssl req -new -key apache-key.pem -out apache-cert.pem
openssl genrsa 2048 > sp-key.pem
openssl req -new -key sp-key.pem -out sp-cert.pem

8. Run `./certificate.sh` script to generate metadata certificates.

docker build . -t josejuanmontiel/shibboleth-sp

docker container run \
    --privileged \
    --rm \
    --name shibboleth-sp \
    --hostname shibboleth-sp \
    -p 1080:80 -p 1443:443 \
    josejuanmontiel/shibboleth-sp

http://localhost:1080/secure

No MetadataProvider available.


jose@x230n:~/workspace/sandbox/shibboleth-apache-springboot/01-shibboleth-sp$ docker container run -it --tmpfs /run -v /sys/fs/cgroup:/sys/fs/cgroup:rw  --name shibboleth-sp --hostname shibboleth-sp -p 1080 -p 1443 josejuanmontiel/shibboleth-sp

#### Links
https://shibboleth.atlassian.net/wiki/spaces/CONCEPT/pages/928645290/FlowsAndConfig
https://itssc.rpi.edu/hc/en-us/articles/22007796523661-Implementing-SSO-Authentication-with-Shibboleth-SP3-for-Redhat-Based-Systems
https://github.com/ConsortiumGARR/idem-tutorials/blob/master/idem-fedops/HOWTO-Shibboleth/Service%20Provider/CentOS/HOWTO%20Install%20and%20Configure%20a%20Shibboleth%20SP%20v3.x%20on%20CentOS%207%20(x86_64).md#install-shibboleth-service-provider

https://docs.tuakiri.ac.nz/service_providers/installing_shibboleth_sp_on_redhat_based_linux
https://elan-ev.github.io/shibboleth-nginx-repo/
https://shibboleth.net/cgi-bin/sp_repo.cgi?platform=rockylinux9

https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065335566/RPMInstall
https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2067398698/SRPMBuild#Targeting-a-Custom-Apache

https://mirrors.rit.edu/shibboleth/CentOS_8/src/
https://mirrors.rit.edu/shibboleth/rockylinux9/src/

https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065335693/ReleaseNotes
https://shibboleth.net/community/advisories/secadv_20190311.txt
https://shibboleth.net/downloads/service-provider/3.0.4/SRPMS/

https://github.com/craigpg/shibboleth-sp2/tree/master

### 02-shibboleth-idp

## References

### Redhat images UBI
https://catalog.redhat.com/software/base-images#base-images-get-started
https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5
https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5?container-tabs=dockerfile
https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5?container-tabs=gti&gti-tabs=unauthenticated
    docker pull registry.access.redhat.com/ubi9/ubi-minimal:9.5-1736404155

### Redhat UBI query repositories
https://www.redhat.com/en/blog/introduction-ubi-micro
https://access.redhat.com/articles/4238681
https://cdn-ubi.redhat.com/content/public/ubi/dist/ubi9/9/x86_64/appstream/os/Packages/b/

https://rpmfind.net/linux/rpm2html/search.php?query=boost-devel&submit=Search+...&system=&arch=x86_64
https://rpmfind.net/linux/rpm2html/search.php?query=doxygen&submit=Search+...&system=&arch=x86_64

https://shibboleth-mirror.cdi.ti.ja.net/CentOS_8/x86_64/shibboleth-3.0.4-1.x86_64.rpm
https://shibboleth-mirror.cdi.ti.ja.net/rockylinux9/x86_64/shibboleth-3.5.0-2.el9.x86_64.rpm
https://shibboleth-mirror.cdi.ti.ja.net/rockylinux9/src/shibboleth-3.5.0-2.el9.src.rpm

### Shibboleth IdP
https://github.com/Unicon/shibboleth-idp-dockerized
https://github.com/iay/shibboleth-idp-docker

### Shibboleth Apache Module
Using (this)[https://github.com/JanOppolzer/shibboleth-sp-docker] aproach try to configure a simple...

### Apache
Using (this)[https://github.com/mconf/apache-shib-docker] add custom apache configuration...

### Spring boot
Using (this)[https://github.com/wlod/experimental-lb-modjk] extend this aproach to use a loadbalancer that point directly to springboot where we configure internal tomcat to use mod_jk.

### Extra

### Another examples - All in One
https://github.com/winstonhong/Shibboleth-SAML-IdP-and-SP

#### Ldap
https://github.com/osixia/docker-openldap

#### Information about ...
https://shibboleth.atlassian.net/wiki/spaces/CONCEPT/pages/928645290/FlowsAndConfig
https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065335062/Apache

#### Upgrade IdP / Jetty
https://shibboleth.atlassian.net/wiki/spaces/IDP4/pages/1274544254/Jetty94
https://shibboleth.atlassian.net/wiki/spaces/IDP4/pages/1265631513/Upgrading
https://shibboleth.atlassian.net/wiki/spaces/IDP5/pages/3199500925/Upgrading

#### Jetty stuff
https://stackoverflow.com/questions/74820235/logback-1-3-0-and-jetty-9-4-50-having-the-compatibility-issues
https://logback.qos.ch/access.html
https://jetty.org/docs/jetty/12/operations-guide/start/index.html#configure

#### Conversion Docker to Ansible
https://github.com/SegFaulti4/dockerfile-ansible-convert
https://www.adaltas.com/en/2017/10/25/from-dockerfile-to-ansible-containers/
https://github.com/mellena1/UnDockerize

#### Centos (EOL) to RedHat
https://www.redhat.com/en/topics/linux/centos-alternatives
https://docs.rockylinux.org/guides/migrate2rocky/
