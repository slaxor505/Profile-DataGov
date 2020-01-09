#!/usr/bin/env sh
#
# Ping Identity DevOps - Docker Build Hooks
#

    echo "
##################################################################################
#               CPrice - PingDataGov - PAP installer
##################################################################################
# 
#     Configured with the following values.  
# 
#       PAP_HOST: ${PAP_HOST}
#       PAP_SECRET: ${PAP_SECRET}
# 
#     To set via a docker run or .yaml just set them using examples below
#
#    docker run
#           ...
#           --env PAP_HOST=myhost.mydomain.com
#           ...
#
##################################################################################
"

    cd /opt/pap
    unzip PingDataGovernance-PAP-8.0.0.0.zip -d /opt/out

    cd /opt/out/PingDataGovernance-PAP || echo "Unable to cd to the PAP bin directory"

    echo "
######################
Running Command: bin/setup demo --licenseKeyFile /opt/pap/PingDataGovernance-PAP/PingDataGovernance.lic --generateSelfSignedCertificate --certNickname server-cert --pkcs12KeyStorePath config/keystore.p12 --hostname ${PAP_HOST} --port 9443 --decisionPointSharedSecret ${PAP_SECRET}
######################
"

    bin/setup demo --licenseKeyFile /opt/pap/PingDataGovernance-PAP/PingDataGovernance.lic --generateSelfSignedCertificate --certNickname server-cert --pkcs12KeyStorePath config/keystore.p12 --hostname ${PAP_HOST} --port 9443 --decisionPointSharedSecret ${PAP_SECRET}

    echo "
    #################################"
    grep "Authentication.SharedSecret:" /opt/out/PingDataGovernance-PAP/config/configuration.yml
    echo "
    #################################
    "

    java -Xmx1G -XX:+UseG1GC -Dsymphonic.Database.H2.Path=/opt/out/PingDataGovernance-PAP/admin-point-application/db/ -classpath /opt/out/PingDataGovernance-PAP/admin-point-application/lib/*:/opt/out/PingDataGovernance-PAP/admin-point-application/bin/* com.symphonicsoft.adminpoint.AdministrationPointApplication server /opt/out/PingDataGovernance-PAP/config/configuration.yml
