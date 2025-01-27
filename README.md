# shibboleth-apache-springboot
Here try to mix a shibboleth (with optional ldap) and apache module protecting website and load balance to springboot aplication.

## Steps

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

docker run -e JETTY_BROWSER_SSL_KEYSTORE_PASSWORD=12345678 -e JETTY_BACKCHANNEL_SSL_KEYSTORE_PASSWORD=12345678 -it -p 443:4443 josejuanmontiel/shibboleth-idp-custom:latest /bin/bash


https://localhost/idp/


## References

### Redhat images UBI
https://catalog.redhat.com/software/base-images#base-images-get-started
https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5
https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5?container-tabs=dockerfile
https://catalog.redhat.com/software/containers/ubi9/ubi-minimal/615bd9b4075b022acc111bf5?container-tabs=gti&gti-tabs=unauthenticated
    docker pull registry.access.redhat.com/ubi9/ubi-minimal:9.5-1736404155

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

### Another examples
https://github.com/winstonhong/Shibboleth-SAML-IdP-and-SP

#### Ldap
https://github.com/osixia/docker-openldap

#### Information about ...
https://shibboleth.atlassian.net/wiki/spaces/CONCEPT/pages/928645290/FlowsAndConfig
https://shibboleth.atlassian.net/wiki/spaces/SP3/pages/2065335062/Apache