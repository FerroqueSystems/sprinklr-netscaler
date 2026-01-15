resource "citrixadc_systemuser" "FSAdmin" {
  username = "FSAdmin"
  password = var.adc_admin_password
}

resource "citrixadc_sslprofile" "ns_default_ssl_profile_frontend" {
  name = "ns_default_ssl_profile_frontend"
}

resource "citrixadc_authenticationloginschema" "LSCHEMA_PROFILE_OAUTH_DUO" {
  name = "LSCHEMA_PROFILE_OAUTH_DUO"
  authenticationschema = "/nsconfig/loginschema/LoginSchema/SingleAuth.xml"
  usercredentialindex = "15"
  passwordcredentialindex = "16"
  ssocredentials = "YES"
}

resource "citrixadc_nsip" "_10_0_0_250" {
  ipaddress = "10.0.0.250"
  netmask = "255.255.255.240"
  vserver = "DISABLED"
}
resource "citrixadc_nsip" "_10_0_1_250" {
  ipaddress = "10.0.1.250"
  netmask = "255.255.255.0"
  vserver = "DISABLED"
}
resource "citrixadc_nsip" "_10_0_0_246" {
  ipaddress = "10.0.0.246"
  netmask = "255.255.255.255"
  type = "VIP"
  snmp = "DISABLED"
  icmpresponse = "ONE_VSERVER"
  arpresponse = "ONE_VSERVER"
}
resource "citrixadc_nsip" "_10_0_0_247" {
  ipaddress = "10.0.0.247"
  netmask = "255.255.255.255"
  type = "VIP"
  icmpresponse = "ONE_VSERVER"
  arpresponse = "ONE_VSERVER"
}
resource "citrixadc_sslprofile" "_2025_SSL_Profile" {
  name = "2025 SSL Profile"
  sessreuse = "ENABLED"
  sesstimeout = "120"
  tls1 = "DISABLED"
  tls11 = "DISABLED"
  tls13 = "ENABLED"
  ocspstapling = "ENABLED"
  denysslreneg = "NONSECURE"
  maxrenegrate = "100"
  hsts = "ENABLED"
  maxage = "157680000"
}
resource "citrixadc_server" "_168_63_129_16" {
  name = "168.63.129.16"
  ipaddress = "168.63.129.16"
}
resource "citrixadc_server" "_10_0_1_8" {
  name = "10.0.1.8"
  ipaddress = "10.0.1.8"
}
resource "citrixadc_service" "azurelbdnsservice0" {
  name = "azurelbdnsservice0"
  ip = "168.63.129.16"
  servicetype = "DNS"
  port = "53"
  maxclient = "0"
  maxreq = "0"
  cip = "DISABLED"
  usip = "NO"
  useproxyport = "NO"
  sp = "OFF"
  clttimeout = "120"
  svrtimeout = "120"
  cka = "NO"
  tcpb = "NO"
  cmp = "NO"
}
resource "citrixadc_service" "SF-HTTP" {
  name = "SF-HTTP"
  ip = "10.0.1.8"
  servicetype = "HTTP"
  port = "80"
  maxclient = "0"
  maxreq = "0"
  cip = "DISABLED"
  usip = "NO"
  useproxyport = "YES"
  sp = "OFF"
  clttimeout = "180"
  svrtimeout = "360"
  cka = "NO"
  tcpb = "NO"
  cmp = "NO"
}
resource "citrixadc_sslcertkey" "Sprinklr_Bundle" {
  certkey = "Sprinklr_Bundle"
  cert = "sprinklr_ferroque_dev.crt"
  key = "SprinklrKey"
  passplain = "REQ_PASSWORD"
}
resource "citrixadc_authenticationauthnprofile" "SprinklrAuthProfile" {
  name = "SprinklrAuthProfile"
  authnvsname = "AAA-Sprinklr-vServer"
  depends_on = [citrixadc_authenticationvserver.AAA-Sprinklr-vServer]
}
resource "citrixadc_authenticationauthnprofile" "AUTH_PROFILE_LDAP_OAUTH_DUO" {
  name = "AUTH_PROFILE_LDAP_OAUTH_DUO"
  authnvsname = "AAA_VS_DuoOauth"
  depends_on = [citrixadc_authenticationvserver.AAA_VS_DuoOauth]
}
resource "citrixadc_authenticationldapaction" "LDAPvs" {
  name = "LDAPvs"
  serverip = "10.0.1.7"
  ldapbase = "DC=SprinklrDev,DC=com"
  ldapbinddn = "LDAPsearch@sprinklrdev.com"
  ldapbinddnpassword = "REQ_PASSWORD"
  ldaploginname = "sAMAccountName"
  groupattrname = "memberOf"
  subattributename = "cn"
  ssonameattribute = "userPrincipalName"
  passwdchange = "ENABLED"
}
resource "citrixadc_authenticationoauthaction" "SprinklrOAuthServ" {
  name = "SprinklrOAuthServ"
  authorizationendpoint = "https://api-90428c78.duosecurity.com/oauth/v1/authorize?scope=openid"
  tokenendpoint = "https://api-90428c78.duosecurity.com/oauth/v1/token"
  clientid = "DI753ZXH4A4B18NZSLVL"
  clientsecret = "REQ_PASSWORD"
  oauthmiscflags = [
    "EnableJWTRequest"
  ]
  allowedalgorithms = [
    "HS256",
    "RS256",
    "RS512"
  ]
  pkce = "DISABLED"
  tokenendpointauthmethod = "client_secret_jwt"
}
resource "citrixadc_authenticationoauthaction" "duo_oauth_server" {
  name = "duo_oauth_server"
  authorizationendpoint = "https://api-90428c78.duosecurity.com/oauth/v1/authorize?scope=openid"
  tokenendpoint = "https://api-90428c78.duosecurity.com/oauth/v1/token"
  clientid = "DI753ZXH4A4B18NZSLVL"
  clientsecret = "REQ_PASSWORD"
  oauthmiscflags = [
    "EnableJWTRequest"
  ]
  allowedalgorithms = [
    "HS256",
    "RS256",
    "RS512"
  ]
  pkce = "DISABLED"
  tokenendpointauthmethod = "client_secret_jwt"
}
resource "citrixadc_authenticationoauthaction" "AUTH_ACTION_OAUTH_DuoAuthenticationProxy" {
  name = "AUTH_ACTION_OAUTH_DuoAuthenticationProxy"
  authorizationendpoint = "https://api-90428c78.duosecurity.com/oauth/v1/authorize?scope=openid"
  tokenendpoint = "https://api-90428c78.duosecurity.com/oauth/v1/token"
  clientid = "DI753ZXH4A4B18NZSLVL"
  clientsecret = "REQ_PASSWORD"
  oauthmiscflags = [
    "EnableJWTRequest"
  ]
  allowedalgorithms = [
    "HS256",
    "RS256",
    "RS512"
  ]
  pkce = "DISABLED"
  tokenendpointauthmethod = "client_secret_jwt"
}
resource "citrixadc_authenticationloginschema" "SprinklrDUOSchemaProf" {
  name = "SprinklrDUOSchemaProf"
  authenticationschema = "/nsconfig/loginschema/LoginSchema/SingleAuth.xml"
  usercredentialindex = "1"
  passwordcredentialindex = "2"
  ssocredentials = "YES"
}
resource "citrixadc_vpntrafficaction" "sprinklr_traffic_prof" {
  name = "sprinklr_traffic_prof"
  qual = "http"
  userexpression = "AAA.USER.ATTRIBUTE(1)"
  passwdexpression = "AAA.USER.ATTRIBUTE(2)"
}
resource "citrixadc_vpntrafficaction" "VPN_TF_PROFILE_OAUTH_DUO" {
  name = "VPN_TF_PROFILE_OAUTH_DUO"
  qual = "http"
  sso = "ON"
  userexpression = "AAA.USER.ATTRIBUTE(15)"
  passwdexpression = "AAA.USER.ATTRIBUTE(16)"
}
resource "citrixadc_authenticationloginschemapolicy" "SprinklrDUOSchemaPol" {
  name = "SprinklrDUOSchemaPol"
  rule = "true"
  action = "SprinklrDUOSchemaProf"
  depends_on = [citrixadc_authenticationloginschema.SprinklrDUOSchemaProf]
}
resource "citrixadc_authenticationloginschemapolicy" "LSCHEMA_POLICY_OAUTH_DUO" {
  name = "LSCHEMA_POLICY_OAUTH_DUO"
  rule = "true"
  action = "LSCHEMA_PROFILE_OAUTH_DUO"
  depends_on = [citrixadc_authenticationloginschema.LSCHEMA_PROFILE_OAUTH_DUO]
}
resource "citrixadc_vpntrafficpolicy" "sprinklr_traffic_pol" {
  name = "sprinklr_traffic_pol"
  rule = "true"
  action = "sprinklr_traffic_prof"
  depends_on = [citrixadc_vpntrafficaction.sprinklr_traffic_prof]
}
resource "citrixadc_vpntrafficpolicy" "VPN_TF_POLICY_OAUTH_DUO" {
  name = "VPN_TF_POLICY_OAUTH_DUO"
  rule = "true"
  action = "VPN_TF_PROFILE_OAUTH_DUO"
  depends_on = [citrixadc_vpntrafficaction.VPN_TF_PROFILE_OAUTH_DUO]
}
resource "citrixadc_lbvserver" "azurelbdnsvserver" {
  name = "azurelbdnsvserver"
  servicetype = "DNS"
  ipv46 = "0.0.0.0"
  port = "0"
  persistencetype = "NONE"
  lbmethod = "ROUNDROBIN"
  clttimeout = "120"
}
resource "citrixadc_lbvserver" "TEST-SF" {
  name = "TEST-SF"
  servicetype = "HTTP"
  ipv46 = "10.0.0.247"
  port = "80"
  persistencetype = "NONE"
  clttimeout = "180"
  depends_on = [citrixadc_nsip._10_0_0_247]
}
resource "citrixadc_cacheparameter" "cacheparameter_59588037" {
  via = "NS-CACHE-10.0:   9"
}
resource "citrixadc_authenticationvserver" "AAA-Sprinklr-vServer" {
  name = "AAA-Sprinklr-vServer"
  servicetype = "SSL"
  ipv46 = "0.0.0.0"
}
resource "citrixadc_authenticationvserver" "AAA_VS_DuoOauth" {
  name = "AAA_VS_DuoOauth"
  servicetype = "SSL"
  ipv46 = "0.0.0.0"
}
resource "citrixadc_vpnvserver" "SprinklrGWDev" {
  name = "SprinklrGWDev"
  servicetype = "SSL"
  ipv46 = "10.0.0.246"
  port = "443"
  icaonly = "ON"
  downstateflush = "DISABLED"
  listenpolicy = "NONE"
  authnprofile = "AUTH_PROFILE_LDAP_OAUTH_DUO"
  depends_on = [citrixadc_nsip._10_0_0_246, citrixadc_authenticationauthnprofile.AUTH_PROFILE_LDAP_OAUTH_DUO]
}
resource "citrixadc_sslvserver" "AAA-Sprinklr-vServer" {
  vservername = "AAA-Sprinklr-vServer"
  sslprofile = "2025 SSL Profile"
  depends_on = [citrixadc_authenticationvserver.AAA-Sprinklr-vServer, citrixadc_sslprofile._2025_SSL_Profile]
}
resource "citrixadc_sslvserver" "AAA_VS_DuoOauth" {
  vservername = "AAA_VS_DuoOauth"
  sslprofile = "ns_default_ssl_profile_frontend"
  depends_on = [citrixadc_authenticationvserver.AAA_VS_DuoOauth]
}
resource "citrixadc_sslvserver" "SprinklrGWDev" {
  vservername = "SprinklrGWDev"
  sslprofile = "2025 SSL Profile"
  depends_on = [citrixadc_vpnvserver.SprinklrGWDev, citrixadc_sslprofile._2025_SSL_Profile]
}
resource "citrixadc_authenticationpolicy" "SprinklrAuth" {
  name = "SprinklrAuth"
  rule = "true"
  action = "LDAPvs"
  depends_on = [citrixadc_authenticationldapaction.LDAPvs]
}
resource "citrixadc_authenticationpolicy" "SprinklrDuoOAuthpol" {
  name = "SprinklrDuoOAuthpol"
  rule = "true"
  action = "duo_oauth_server"
  depends_on = [citrixadc_authenticationoauthaction.duo_oauth_server]
}
resource "citrixadc_authenticationpolicy" "AUTH-LDAP" {
  name = "AUTH-LDAP"
  rule = "true"
  action = "LDAPvs"
  depends_on = [citrixadc_authenticationldapaction.LDAPvs]
}
resource "citrixadc_authenticationpolicy" "AUTH_POLICY_OAUTH_DUO" {
  name = "AUTH_POLICY_OAUTH_DUO"
  rule = "true"
  action = "AUTH_ACTION_OAUTH_DuoAuthenticationProxy"
  depends_on = [citrixadc_authenticationoauthaction.AUTH_ACTION_OAUTH_DuoAuthenticationProxy]
}
resource "citrixadc_authenticationpolicylabel" "SprinklrRadius" {
  labelname = "SprinklrRadius"
  loginschema = "LSCHEMA_INT"
}
resource "citrixadc_authenticationpolicylabel" "AUTH_POLICYLABEL_OAUTH_DuoAuthenticationProxy" {
  labelname = "AUTH_POLICYLABEL_OAUTH_DuoAuthenticationProxy"
  loginschema = "LSCHEMA_INT"
}
resource "citrixadc_vpnsessionaction" "NSG_web_prof" {
  name = "NSG_web_prof"
  transparentinterception = "ON"
  defaultauthorizationaction = "ALLOW"
  sso = "ON"
  ssocredential = "PRIMARY"
  windowsautologon = "ON"
  icaproxy = "ON"
  wihome = "http://10.0.1.8/Citrix/SprinklrdevWeb"
  ntdomain = "sprinklrdev.com"
  clientlessvpnmode = "ON"
  clientlessmodeurlencoding = "OPAQUE"
}
resource "citrixadc_vpnsessionaction" "NSG_CWA_prof" {
  name = "NSG_CWA_prof"
  sesstimeout = "30"
  transparentinterception = "OFF"
  defaultauthorizationaction = "ALLOW"
  sso = "ON"
  windowsautologon = "ON"
  icaproxy = "ON"
  wihome = "http://10.0.1.8/Citrix/Sprinklrdev"
  wiportalmode = "NORMAL"
  ntdomain = "sprinklrdev.com"
  clientlessvpnmode = "ON"
  clientlessmodeurlencoding = "OPAQUE"
  storefronturl = "http://eus2-ctx-sf1.sprinklrdev.com"
}
resource "citrixadc_vpnsessionpolicy" "NSG_web_pol" {
  name = "NSG_web_pol"
  rule = "HTTP.REQ.HEADER(\"User-Agent\").CONTAINS(\"CitrixReceiver\").NOT"
  action = "NSG_web_prof"
  depends_on = [citrixadc_vpnsessionaction.NSG_web_prof]
}
resource "citrixadc_vpnsessionpolicy" "NSG_CWA_pol" {
  name = "NSG_CWA_pol"
  rule = "HTTP.REQ.HEADER(\"User-Agent\").CONTAINS(\"CitrixReceiver\")"
  action = "NSG_CWA_prof"
  depends_on = [citrixadc_vpnsessionaction.NSG_CWA_prof]
}
resource "citrixadc_vpnparameter" "vpnparameter_60821065" {
  proxy = "OFF"
  forcecleanup = [
    "none"
  ]
  clientconfiguration = [
    "trace"
  ]
  uitheme = "DEFAULT"
  backendserversni = "ENABLED"
}
resource "citrixadc_sslcipher" "_2025_Cipher_group" {
  ciphergroupname = "2025 Cipher group"
}
resource "citrixadc_lbvserver_service_binding" "azurelbdnsvserver_azurelbdnsservice0_0" {
  name = "azurelbdnsvserver"
  servicename = "azurelbdnsservice0"
  depends_on = [citrixadc_lbvserver.azurelbdnsvserver, citrixadc_service.azurelbdnsservice0]
}
resource "citrixadc_lbvserver_service_binding" "TEST-SF_SF-HTTP_1" {
  name = "TEST-SF"
  servicename = "SF-HTTP"
  depends_on = [citrixadc_lbvserver.TEST-SF, citrixadc_service.SF-HTTP]
}
resource "citrixadc_service_lbmonitor_binding" "azurelbdnsservice0_dns_0" {
  name = "azurelbdnsservice0"
  monitor_name = "dns"
  depends_on = [citrixadc_service.azurelbdnsservice0]
}
resource "citrixadc_authenticationpolicylabel_authenticationpolicy_binding" "SprinklrRadius_SprinklrDuoOAuthpol_0" {
  labelname = "SprinklrRadius"
  policyname = "SprinklrDuoOAuthpol"
  priority = "86"
  gotopriorityexpression = "END"
  depends_on = [citrixadc_authenticationpolicylabel.SprinklrRadius, citrixadc_authenticationpolicy.SprinklrDuoOAuthpol]
}
resource "citrixadc_authenticationpolicylabel_authenticationpolicy_binding" "AUTH_POLICYLABEL_OAUTH_DuoAuthenticationProxy_AUTH_POLICY_OAUTH_DUO_1" {
  labelname = "AUTH_POLICYLABEL_OAUTH_DuoAuthenticationProxy"
  policyname = "AUTH_POLICY_OAUTH_DUO"
  priority = "100"
  gotopriorityexpression = "NEXT"
  depends_on = [citrixadc_authenticationpolicylabel.AUTH_POLICYLABEL_OAUTH_DuoAuthenticationProxy, citrixadc_authenticationpolicy.AUTH_POLICY_OAUTH_DUO]
}
resource "citrixadc_systemuser_systemcmdpolicy_binding" "FSAdmin_superuser_0" {
  username = "FSAdmin"
  policyname = "superuser"
  priority = "101"
  depends_on = [citrixadc_systemuser.FSAdmin]
}
resource "citrixadc_vpnvserver_cachepolicy_binding" "SprinklrGWDev__cacheTCVPNStaticObjects_0" {
  name = "SprinklrGWDev"
  policy = "_cacheTCVPNStaticObjects"
  priority = "10"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_vpnvserver.SprinklrGWDev]
}
resource "citrixadc_vpnvserver_cachepolicy_binding" "SprinklrGWDev__cacheOCVPNStaticObjects_1" {
  name = "SprinklrGWDev"
  policy = "_cacheOCVPNStaticObjects"
  priority = "20"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_vpnvserver.SprinklrGWDev]
}
resource "citrixadc_vpnvserver_cachepolicy_binding" "SprinklrGWDev__cacheVPNStaticObjects_2" {
  name = "SprinklrGWDev"
  policy = "_cacheVPNStaticObjects"
  priority = "30"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_vpnvserver.SprinklrGWDev]
}
resource "citrixadc_vpnvserver_cachepolicy_binding" "SprinklrGWDev__mayNoCacheReq_3" {
  name = "SprinklrGWDev"
  policy = "_mayNoCacheReq"
  priority = "40"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_vpnvserver.SprinklrGWDev]
}
resource "citrixadc_vpnvserver_cachepolicy_binding" "SprinklrGWDev__cacheWFStaticObjects_4" {
  name = "SprinklrGWDev"
  policy = "_cacheWFStaticObjects"
  priority = "10"
  gotopriorityexpression = "END"
  bindpoint = "RESPONSE"
  depends_on = [citrixadc_vpnvserver.SprinklrGWDev]
}
resource "citrixadc_vpnvserver_cachepolicy_binding" "SprinklrGWDev__noCacheRest_5" {
  name = "SprinklrGWDev"
  policy = "_noCacheRest"
  priority = "20"
  gotopriorityexpression = "END"
  bindpoint = "RESPONSE"
  depends_on = [citrixadc_vpnvserver.SprinklrGWDev]
}
resource "citrixadc_vpnvserver_vpnsessionpolicy_binding" "SprinklrGWDev_NSG_web_pol_0" {
  name = "SprinklrGWDev"
  policy = "NSG_web_pol"
  priority = "100"
  gotopriorityexpression = "NEXT"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_vpnvserver.SprinklrGWDev, citrixadc_vpnsessionpolicy.NSG_web_pol]
}
resource "citrixadc_vpnvserver_vpnsessionpolicy_binding" "SprinklrGWDev_NSG_CWA_pol_1" {
  name = "SprinklrGWDev"
  policy = "NSG_CWA_pol"
  priority = "110"
  gotopriorityexpression = "NEXT"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_vpnvserver.SprinklrGWDev, citrixadc_vpnsessionpolicy.NSG_CWA_pol]
}
resource "citrixadc_vpnvserver_vpntrafficpolicy_binding" "SprinklrGWDev_VPN_TF_POLICY_OAUTH_DUO_0" {
  name = "SprinklrGWDev"
  policy = "VPN_TF_POLICY_OAUTH_DUO"
  priority = "100"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_vpnvserver.SprinklrGWDev, citrixadc_vpntrafficpolicy.VPN_TF_POLICY_OAUTH_DUO]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA-Sprinklr-vServer__cacheTCVPNStaticObjects_0" {
  name = "AAA-Sprinklr-vServer"
  policy = "_cacheTCVPNStaticObjects"
  priority = "10"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_authenticationvserver.AAA-Sprinklr-vServer]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA-Sprinklr-vServer__cacheOCVPNStaticObjects_1" {
  name = "AAA-Sprinklr-vServer"
  policy = "_cacheOCVPNStaticObjects"
  priority = "20"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_authenticationvserver.AAA-Sprinklr-vServer]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA-Sprinklr-vServer__cacheVPNStaticObjects_2" {
  name = "AAA-Sprinklr-vServer"
  policy = "_cacheVPNStaticObjects"
  priority = "30"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_authenticationvserver.AAA-Sprinklr-vServer]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA-Sprinklr-vServer__mayNoCacheReq_3" {
  name = "AAA-Sprinklr-vServer"
  policy = "_mayNoCacheReq"
  priority = "40"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_authenticationvserver.AAA-Sprinklr-vServer]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA-Sprinklr-vServer__cacheWFStaticObjects_4" {
  name = "AAA-Sprinklr-vServer"
  policy = "_cacheWFStaticObjects"
  priority = "10"
  gotopriorityexpression = "END"
  bindpoint = "RESPONSE"
  depends_on = [citrixadc_authenticationvserver.AAA-Sprinklr-vServer]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA-Sprinklr-vServer__noCacheRest_5" {
  name = "AAA-Sprinklr-vServer"
  policy = "_noCacheRest"
  priority = "20"
  gotopriorityexpression = "END"
  bindpoint = "RESPONSE"
  depends_on = [citrixadc_authenticationvserver.AAA-Sprinklr-vServer]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA_VS_DuoOauth__cacheTCVPNStaticObjects_6" {
  name = "AAA_VS_DuoOauth"
  policy = "_cacheTCVPNStaticObjects"
  priority = "10"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_authenticationvserver.AAA_VS_DuoOauth]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA_VS_DuoOauth__cacheOCVPNStaticObjects_7" {
  name = "AAA_VS_DuoOauth"
  policy = "_cacheOCVPNStaticObjects"
  priority = "20"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_authenticationvserver.AAA_VS_DuoOauth]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA_VS_DuoOauth__cacheVPNStaticObjects_8" {
  name = "AAA_VS_DuoOauth"
  policy = "_cacheVPNStaticObjects"
  priority = "30"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_authenticationvserver.AAA_VS_DuoOauth]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA_VS_DuoOauth__mayNoCacheReq_9" {
  name = "AAA_VS_DuoOauth"
  policy = "_mayNoCacheReq"
  priority = "40"
  gotopriorityexpression = "END"
  bindpoint = "REQUEST"
  depends_on = [citrixadc_authenticationvserver.AAA_VS_DuoOauth]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA_VS_DuoOauth__cacheWFStaticObjects_10" {
  name = "AAA_VS_DuoOauth"
  policy = "_cacheWFStaticObjects"
  priority = "10"
  gotopriorityexpression = "END"
  bindpoint = "RESPONSE"
  depends_on = [citrixadc_authenticationvserver.AAA_VS_DuoOauth]
}
resource "citrixadc_authenticationvserver_cachepolicy_binding" "AAA_VS_DuoOauth__noCacheRest_11" {
  name = "AAA_VS_DuoOauth"
  policy = "_noCacheRest"
  priority = "20"
  gotopriorityexpression = "END"
  bindpoint = "RESPONSE"
  depends_on = [citrixadc_authenticationvserver.AAA_VS_DuoOauth]
}
resource "citrixadc_authenticationvserver_authenticationloginschemapolicy_binding" "AAA-Sprinklr-vServer_SprinklrDUOSchemaPol_0" {
  name = "AAA-Sprinklr-vServer"
  policy = "SprinklrDUOSchemaPol"
  priority = "100"
  gotopriorityexpression = "END"
  depends_on = [citrixadc_authenticationvserver.AAA-Sprinklr-vServer, citrixadc_authenticationloginschemapolicy.SprinklrDUOSchemaPol]
}
resource "citrixadc_authenticationvserver_authenticationloginschemapolicy_binding" "AAA_VS_DuoOauth_LSCHEMA_POLICY_OAUTH_DUO_1" {
  name = "AAA_VS_DuoOauth"
  policy = "LSCHEMA_POLICY_OAUTH_DUO"
  priority = "100"
  gotopriorityexpression = "END"
  depends_on = [citrixadc_authenticationvserver.AAA_VS_DuoOauth, citrixadc_authenticationloginschemapolicy.LSCHEMA_POLICY_OAUTH_DUO]
}
resource "citrixadc_authenticationvserver_authenticationpolicy_binding" "AAA-Sprinklr-vServer_SprinklrAuth_0" {
  name = "AAA-Sprinklr-vServer"
  policy = "SprinklrAuth"
  priority = "30"
  nextfactor = "SprinklrRadius"
  gotopriorityexpression = "NEXT"
  depends_on = [citrixadc_authenticationvserver.AAA-Sprinklr-vServer, citrixadc_authenticationpolicy.SprinklrAuth]
}
resource "citrixadc_authenticationvserver_authenticationpolicy_binding" "AAA_VS_DuoOauth_AUTH-LDAP_1" {
  name = "AAA_VS_DuoOauth"
  policy = "AUTH-LDAP"
  priority = "100"
  nextfactor = "AUTH_POLICYLABEL_OAUTH_DuoAuthenticationProxy"
  gotopriorityexpression = "NEXT"
  depends_on = [citrixadc_authenticationvserver.AAA_VS_DuoOauth, citrixadc_authenticationpolicy.AUTH-LDAP]
}
resource "citrixadc_sslcipher_sslciphersuite_binding" "_2025_Cipher_group_TLS1_3-AES256-GCM-SHA384_0" {
  ciphergroupname = "2025 Cipher group"
  ciphername = "TLS1.3-AES256-GCM-SHA384"
  cipherpriority = "1"
  depends_on = [citrixadc_sslcipher._2025_Cipher_group]
}
resource "citrixadc_sslcipher_sslciphersuite_binding" "_2025_Cipher_group_TLS1_3-AES128-GCM-SHA256_1" {
  ciphergroupname = "2025 Cipher group"
  ciphername = "TLS1.3-AES128-GCM-SHA256"
  cipherpriority = "2"
  depends_on = [citrixadc_sslcipher._2025_Cipher_group]
}
resource "citrixadc_sslcipher_sslciphersuite_binding" "_2025_Cipher_group_TLS1_3-CHACHA20-POLY1305-SHA256_2" {
  ciphergroupname = "2025 Cipher group"
  ciphername = "TLS1.3-CHACHA20-POLY1305-SHA256"
  cipherpriority = "3"
  depends_on = [citrixadc_sslcipher._2025_Cipher_group]
}
resource "citrixadc_sslcipher_sslciphersuite_binding" "_2025_Cipher_group_TLS1_2-ECDHE-ECDSA-AES256-GCM-SHA384_3" {
  ciphergroupname = "2025 Cipher group"
  ciphername = "TLS1.2-ECDHE-ECDSA-AES256-GCM-SHA384"
  cipherpriority = "4"
  depends_on = [citrixadc_sslcipher._2025_Cipher_group]
}
resource "citrixadc_sslcipher_sslciphersuite_binding" "_2025_Cipher_group_TLS1_2-ECDHE-ECDSA-AES128-GCM-SHA256_4" {
  ciphergroupname = "2025 Cipher group"
  ciphername = "TLS1.2-ECDHE-ECDSA-AES128-GCM-SHA256"
  cipherpriority = "5"
  depends_on = [citrixadc_sslcipher._2025_Cipher_group]
}
resource "citrixadc_sslcipher_sslciphersuite_binding" "_2025_Cipher_group_TLS1_2-ECDHE-RSA-AES256-GCM-SHA384_5" {
  ciphergroupname = "2025 Cipher group"
  ciphername = "TLS1.2-ECDHE-RSA-AES256-GCM-SHA384"
  cipherpriority = "6"
  depends_on = [citrixadc_sslcipher._2025_Cipher_group]
}
resource "citrixadc_sslprofile_ecccurve_binding" "ns_default_ssl_profile_frontend_ecccurve" {
  ecccurvename = [
    "X25519_MLKEM768",
    "X_25519",
    "P_256",
    "P_384",
    "P_224",
    "P_521"
  ]
  name = "ns_default_ssl_profile_frontend"
  remove_existing_ecccurve_binding = "true"
  depends_on = [citrixadc_sslprofile.ns_default_ssl_profile_frontend]
}
resource "citrixadc_sslvserver_sslcertkey_binding" "AAA-Sprinklr-vServer_Sprinklr_Bundle_0" {
  vservername = "AAA-Sprinklr-vServer"
  certkeyname = "Sprinklr_Bundle"
  depends_on = [citrixadc_sslvserver.AAA-Sprinklr-vServer, citrixadc_sslcertkey.Sprinklr_Bundle]
}
resource "citrixadc_sslvserver_sslcertkey_binding" "AAA_VS_DuoOauth_Sprinklr_Bundle_1" {
  vservername = "AAA_VS_DuoOauth"
  certkeyname = "Sprinklr_Bundle"
  depends_on = [citrixadc_sslvserver.AAA_VS_DuoOauth, citrixadc_sslcertkey.Sprinklr_Bundle]
}
resource "citrixadc_sslvserver_sslcertkey_binding" "SprinklrGWDev_Sprinklr_Bundle_2" {
  vservername = "SprinklrGWDev"
  certkeyname = "Sprinklr_Bundle"
  depends_on = [citrixadc_sslvserver.SprinklrGWDev, citrixadc_sslcertkey.Sprinklr_Bundle]
}
