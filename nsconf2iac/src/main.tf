resource "citrixadc_nsconfig_update" "nsconfig_41559043" {
  ipaddress = "10.0.1.9"
  netmask = "255.255.255.0"
}
resource "citrixadc_nsconfig_update" "nsconfig_24015576" {
  nsvlan = "10"
  ifnum = [
    "0/1"
  ]
  tagged = "NO"
}
resource "citrixadc_nsfeature" "nsfeature_66975263" {
  wl = "true"
  sp = "true"
  lb = "true"
  ssl = "true"
  sslvpn = "true"
  aaa = "true"
  ch = "true"
  bot = "true"
}
resource "citrixadc_nsmode" "nsmode_18081881" {
  mbf = "true"
  usnip = "true"
  pmtud = "true"
}
resource "citrixadc_systemuser" "nsroot" {
  username = "nsroot"
  password = "REQ_PASSWORD"
}
resource "citrixadc_systemuser" "FSAdmin" {
  username = "FSAdmin"
  password = "REQ_PASSWORD"
}
resource "citrixadc_rsskeytype" "rsskeytype_73132046" {
  rsstype = "ASYMMETRIC"
}
resource "citrixadc_lacp" "lacp_97580153" {
  syspriority = "32768"
}
resource "citrixadc_nshostname" "nshostname_83924010" {
  hostname = "EUS2-NSGW-VPX3"
}
resource "citrixadc_interface" "_0_1" {
  autoneg = "DISABLED"
  hamonitor = "OFF"
  throughput = "0"
  bandwidthhigh = "0"
  bandwidthnormal = "0"
  interface_id = "0/1"
}
resource "citrixadc_interface" "_1_1" {
  autoneg = "DISABLED"
  hamonitor = "OFF"
  throughput = "0"
  bandwidthhigh = "0"
  bandwidthnormal = "0"
  interface_id = "1/1"
}
resource "citrixadc_interface" "_100_1" {
  hamonitor = "OFF"
  haheartbeat = "OFF"
  ringsize = "1024"
  ringtype = "Fixed"
  throughput = "0"
  bandwidthhigh = "0"
  bandwidthnormal = "0"
  interface_id = "100/1"
}
resource "citrixadc_interface" "_100_2" {
  hamonitor = "OFF"
  haheartbeat = "OFF"
  ringsize = "1024"
  ringtype = "Fixed"
  throughput = "0"
  bandwidthhigh = "0"
  bandwidthnormal = "0"
  interface_id = "100/2"
}
resource "citrixadc_interface" "LO_1" {
  hamonitor = "OFF"
  haheartbeat = "OFF"
  throughput = "0"
  bandwidthhigh = "0"
  bandwidthnormal = "0"
  interface_id = "LO/1"
}
resource "citrixadc_sslparameter" "sslparameter_33272620" {
  defaultprofile = "ENABLED"
}
resource "citrixadc_vlan" "_10" {
  vlanid = "10"
}
resource "citrixadc_vlan" "_20" {
  aliasname = "vlanExtFW"
  vlanid = "20"
}
resource "citrixadc_nsip6" "fe80__6245_bdff_feb3_297a_64" {
  ipv6address = "fe80::6245:bdff:feb3:297a/64"
  scope = "link-local"
  type = "NSIP"
  vlan = "1"
  vserver = "DISABLED"
  mgmtaccess = "ENABLED"
  dynamicrouting = "ENABLED"
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
resource "citrixadc_nd6ravariables" "_1" {
  vlan = "1"
}
resource "citrixadc_snmpcommunity" "public" {
  communityname = "public"
  permissions = "ALL"
}
resource "citrixadc_snmpalarm" "APPFW-GRPC" {
  trapname = "APPFW-GRPC"
  time = "0"
}
resource "citrixadc_snmpalarm" "APPFW-GRPC-WEB-JSON" {
  trapname = "APPFW-GRPC-WEB-JSON"
  time = "0"
}
resource "citrixadc_snmpalarm" "APPFW-GRPC-WEB-TEXT" {
  trapname = "APPFW-GRPC-WEB-TEXT"
  time = "0"
}
resource "citrixadc_snmpalarm" "CLUSTER-BACKPLANE-HB-MISSING" {
  trapname = "CLUSTER-BACKPLANE-HB-MISSING"
  time = "86400"
}
resource "citrixadc_snmpalarm" "CLUSTER-NODE-HEALTH" {
  trapname = "CLUSTER-NODE-HEALTH"
  time = "86400"
}
resource "citrixadc_snmpalarm" "CLUSTER-NODE-QUORUM" {
  trapname = "CLUSTER-NODE-QUORUM"
  time = "86400"
}
resource "citrixadc_snmpalarm" "CLUSTER-VERSION-MISMATCH" {
  trapname = "CLUSTER-VERSION-MISMATCH"
  time = "86400"
}
resource "citrixadc_snmpalarm" "COMPACT-FLASH-ERRORS" {
  trapname = "COMPACT-FLASH-ERRORS"
  time = "86400"
}
resource "citrixadc_snmpalarm" "HA-BAD-SECONDARY-STATE" {
  trapname = "HA-BAD-SECONDARY-STATE"
  time = "86400"
}
resource "citrixadc_snmpalarm" "HA-NO-HEARTBEATS" {
  trapname = "HA-NO-HEARTBEATS"
  time = "86400"
}
resource "citrixadc_snmpalarm" "HA-SYNC-FAILURE" {
  trapname = "HA-SYNC-FAILURE"
  time = "86400"
}
resource "citrixadc_snmpalarm" "HA-VERSION-MISMATCH" {
  trapname = "HA-VERSION-MISMATCH"
  time = "86400"
}
resource "citrixadc_snmpalarm" "HARD-DISK-DRIVE-ERRORS" {
  trapname = "HARD-DISK-DRIVE-ERRORS"
  time = "86400"
}
resource "citrixadc_snmpalarm" "PORT-ALLOC-EXCEED" {
  trapname = "PORT-ALLOC-EXCEED"
  time = "3600"
}
resource "citrixadc_snmpalarm" "PORT-ALLOC-FAILED" {
  trapname = "PORT-ALLOC-FAILED"
  time = "3600"
}
resource "citrixadc_snmpalarm" "SYSLOG-CONNECTION-DROPPED" {
  trapname = "SYSLOG-CONNECTION-DROPPED"
  time = "3600"
}
resource "citrixadc_snmpalarm" "HA-DISK-ENCRYPTION-MISMATCH" {
  trapname = "HA-DISK-ENCRYPTION-MISMATCH"
  time = "86400"
}
resource "citrixadc_snmptrap" "generic_10_0_1_9" {
  trapclass = "generic"
  trapdestination = "10.0.1.9"
  communityname = "public"
  allpartitions = "ENABLED"
}
resource "citrixadc_snmptrap" "specific_10_0_1_9" {
  trapclass = "specific"
  trapdestination = "10.0.1.9"
  communityname = "public"
  allpartitions = "ENABLED"
}
resource "citrixadc_nsencryptionparams" "nsencryptionparams_46198626" {
  method = "AES256"
  keyvalue = "REQ_PASSWORD"
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
resource "citrixadc_sslprofile" "ns_default_ssl_profile_frontend" {
  name = "ns_default_ssl_profile_frontend"
}
resource "citrixadc_sslprofile" "ns_default_ssl_profile_backend" {
  name = "ns_default_ssl_profile_backend"
  sslprofiletype = "BackEnd"
}
resource "citrixadc_sslprofile" "ns_default_ssl_profile_secure_frontend" {
  name = "ns_default_ssl_profile_secure_frontend"
}
resource "citrixadc_sslprofile" "ns_default_ssl_profile_quic_frontend" {
  name = "ns_default_ssl_profile_quic_frontend"
}
resource "citrixadc_sslprofile" "ns_default_ssl_profile_secure_frontend_cloud" {
  name = "ns_default_ssl_profile_secure_frontend_cloud"
}
resource "citrixadc_sslprofile" "ns_default_ssl_profile_internal_frontend_service" {
  name = "ns_default_ssl_profile_internal_frontend_service"
}
resource "citrixadc_sslprofile" "ns_default_ssl_profile_quic_backend" {
  name = "ns_default_ssl_profile_quic_backend"
  sslprofiletype = "BackEnd"
}
resource "citrixadc_cmpparameter" "cmpparameter_79749864" {
  cmpbypasspct = "98"
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
resource "citrixadc_service" "nshttpd-gui-127_0_0_1-80" {
  name = "nshttpd-gui-127.0.0.1-80"
  cip = "ENABLED"
}
resource "citrixadc_service" "nshttpd-vpn-127_0_0_1-81" {
  name = "nshttpd-vpn-127.0.0.1-81"
  cip = "ENABLED"
}
resource "citrixadc_service" "nshttps-127_0_0_1-443" {
  name = "nshttps-127.0.0.1-443"
  cip = "ENABLED"
}
resource "citrixadc_sslcertkey" "ns-server-certificate" {
  certkey = "ns-server-certificate"
  cert = "ns-server.cert"
  key = "ns-server.key"
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
resource "citrixadc_authenticationloginschema" "LSCHEMA_PROFILE_OAUTH_DUO" {
  name = "LSCHEMA_PROFILE_OAUTH_DUO"
  authenticationschema = "/nsconfig/loginschema/LoginSchema/SingleAuth.xml"
  usercredentialindex = "15"
  passwordcredentialindex = "16"
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
resource "citrixadc_cacheparameter" "cacheparameter_71212221" {
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
resource "citrixadc_aaaparameter" "aaaparameter_73003370" {
  maxaaausers = "4294967295"
  defaultcspheader = "DISABLED"
  wafprotection = [
    "DISABLED"
  ]
}
resource "citrixadc_lbmonitor" "xdm" {
  monitorname = "xdm"
  type = "CITRIX-XDM"
  username = "Administrator"
  password = "REQ_PASSWORD"
  deviation = "0"
  interval = "5"
  resptimeout = "2"
  downtime = "30"
  sitepath = "/zdm"
}
resource "citrixadc_lbmonitor" "xnc" {
  monitorname = "xnc"
  type = "CITRIX-XNC-ECV"
  username = "user1"
  password = "REQ_PASSWORD"
  deviation = "0"
  interval = "5"
  resptimeout = "2"
  downtime = "30"
}
resource "citrixadc_lbmonitor" "http2direct" {
  monitorname = "http2direct"
  type = "HTTP2"
  deviation = "0"
  interval = "5"
  resptimeout = "2"
  downtime = "30"
  grpcstatuscode = [
    "12"
  ]
}
resource "citrixadc_lbmonitor" "http2ssl" {
  monitorname = "http2ssl"
  type = "HTTP2"
  deviation = "0"
  interval = "5"
  resptimeout = "2"
  downtime = "30"
  grpcstatuscode = [
    "12"
  ]
}
resource "citrixadc_lbmonitor" "ldns-dns" {
  monitorname = "ldns-dns"
  type = "LDNS-DNS"
  query = "."
  querytype = "Address"
  deviation = "0"
  interval = "6"
  resptimeout = "3"
  downtime = "20"
}
resource "citrixadc_lbmonitor" "stasecure" {
  monitorname = "stasecure"
  type = "CITRIX-STA-SERVICE"
  deviation = "0"
  interval = "2"
  units3 = "MIN"
  resptimeout = "4"
  downtime = "5"
}
resource "citrixadc_lbmonitor" "sta" {
  monitorname = "sta"
  type = "CITRIX-STA-SERVICE"
  deviation = "0"
  interval = "2"
  units3 = "MIN"
  resptimeout = "4"
  downtime = "5"
}
resource "citrixadc_appflowparam" "appflowparam_87053136" {
  observationpointid = "151060490"
}
resource "citrixadc_botprofile" "sprinklr_bot_profile" {
  name = "sprinklr_bot_profile"
  signature = "sprinklr_bot_signatures.json"
  spoofedreqaction = [
    "DROP"
  ]
}
resource "citrixadc_botsettings" "botsettings_44198037" {
  signatureautoupdate = "ON"
}
resource "citrixadc_botpolicy" "sprinklr_bot_pol" {
  name = "sprinklr_bot_pol"
  rule = "true"
  profilename = "sprinklr_bot_profile"
  depends_on = [citrixadc_botprofile.sprinklr_bot_profile]
}
resource "citrixadc_cachecontentgroup" "NSFEO" {
  name = "NSFEO"
  maxressize = "1994752"
}
resource "citrixadc_dnsnsrec" "__a_root-servers_net" {
  domain = "."
  nameserver = "a.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__b_root-servers_net" {
  domain = "."
  nameserver = "b.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__c_root-servers_net" {
  domain = "."
  nameserver = "c.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__d_root-servers_net" {
  domain = "."
  nameserver = "d.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__e_root-servers_net" {
  domain = "."
  nameserver = "e.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__f_root-servers_net" {
  domain = "."
  nameserver = "f.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__g_root-servers_net" {
  domain = "."
  nameserver = "g.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__h_root-servers_net" {
  domain = "."
  nameserver = "h.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__i_root-servers_net" {
  domain = "."
  nameserver = "i.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__j_root-servers_net" {
  domain = "."
  nameserver = "j.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__k_root-servers_net" {
  domain = "."
  nameserver = "k.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__l_root-servers_net" {
  domain = "."
  nameserver = "l.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnsrec" "__m_root-servers_net" {
  domain = "."
  nameserver = "m.root-servers.net"
  ttl = "3600000"
}
resource "citrixadc_dnsnameserver" "dnsnameserver_60450402" {
  dnsvservername = "azurelbdnsvserver"
}
resource "citrixadc_nsdiameter" "nsdiameter_15827486" {
  identity = "netscaler.com"
  realm = "com"
}
resource "citrixadc_subscribergxinterface" "subscribergxinterface_66734046" {
  pcrfrealm = "pcrf.com"
  servicepathavp = [
    "262099"
  ]
  servicepathvendorid = "3845"
}
resource "citrixadc_dnsaddrec" "l_root-servers_net_199_7_83_42" {
  hostname = "l.root-servers.net"
  ipaddress = "199.7.83.42"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "b_root-servers_net_192_228_79_201" {
  hostname = "b.root-servers.net"
  ipaddress = "192.228.79.201"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "d_root-servers_net_199_7_91_13" {
  hostname = "d.root-servers.net"
  ipaddress = "199.7.91.13"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "j_root-servers_net_192_58_128_30" {
  hostname = "j.root-servers.net"
  ipaddress = "192.58.128.30"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "h_root-servers_net_128_63_2_53" {
  hostname = "h.root-servers.net"
  ipaddress = "128.63.2.53"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "f_root-servers_net_192_5_5_241" {
  hostname = "f.root-servers.net"
  ipaddress = "192.5.5.241"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "k_root-servers_net_193_0_14_129" {
  hostname = "k.root-servers.net"
  ipaddress = "193.0.14.129"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "a_root-servers_net_198_41_0_4" {
  hostname = "a.root-servers.net"
  ipaddress = "198.41.0.4"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "c_root-servers_net_192_33_4_12" {
  hostname = "c.root-servers.net"
  ipaddress = "192.33.4.12"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "m_root-servers_net_202_12_27_33" {
  hostname = "m.root-servers.net"
  ipaddress = "202.12.27.33"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "i_root-servers_net_192_36_148_17" {
  hostname = "i.root-servers.net"
  ipaddress = "192.36.148.17"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "g_root-servers_net_192_112_36_4" {
  hostname = "g.root-servers.net"
  ipaddress = "192.112.36.4"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "e_root-servers_net_192_203_230_10" {
  hostname = "e.root-servers.net"
  ipaddress = "192.203.230.10"
  ttl = "3600000"
}
resource "citrixadc_dnsaddrec" "api-90428c78_duosecurity_com_3_145_240_99" {
  hostname = "api-90428c78.duosecurity.com"
  ipaddress = "3.145.240.99"
}
resource "citrixadc_route" "_0_0_0_0" {
  network = "0.0.0.0"
  netmask = "0.0.0.0"
  gateway = "10.0.1.1"
}
resource "citrixadc_route" "_169_254_0_0" {
  network = "169.254.0.0"
  netmask = "255.255.0.0"
  gateway = "10.0.1.1"
}
resource "citrixadc_sslservice" "vpndbssvc_-1726133913" {
  servicename = "vpndbssvc_-1726133913"
  sslprofile = "ns_default_ssl_profile_backend"
}
resource "citrixadc_sslservice" "nsrnatsip-127_0_0_1-5061" {
  servicename = "nsrnatsip-127.0.0.1-5061"
  sslprofile = "ns_default_ssl_profile_internal_frontend_service"
}
resource "citrixadc_sslservice" "nskrpcs-127_0_0_1-3009" {
  servicename = "nskrpcs-127.0.0.1-3009"
  sslprofile = "ns_default_ssl_profile_internal_frontend_service"
}
resource "citrixadc_sslservice" "nshttps-__1l-443" {
  servicename = "nshttps-::1l-443"
  sslprofile = "ns_default_ssl_profile_internal_frontend_service"
}
resource "citrixadc_sslservice" "nsrpcs-__1l-3008" {
  servicename = "nsrpcs-::1l-3008"
  sslprofile = "ns_default_ssl_profile_internal_frontend_service"
}
resource "citrixadc_sslservice" "nshttps-127_0_0_1-443" {
  servicename = "nshttps-127.0.0.1-443"
  sslprofile = "ns_default_ssl_profile_internal_frontend_service"
  depends_on = [citrixadc_service.nshttps-127_0_0_1-443]
}
resource "citrixadc_sslservice" "nsrpcs-127_0_0_1-3008" {
  servicename = "nsrpcs-127.0.0.1-3008"
  sslprofile = "ns_default_ssl_profile_internal_frontend_service"
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
resource "citrixadc_vpnparameter" "vpnparameter_84064818" {
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
resource "citrixadc_auditnslogparams" "auditnslogparams_46275947" {
  loglevel = [
    "DEBUG"
  ]
  tcp = "ALL"
  acl = "ENABLED"
  userdefinedauditlog = "YES"
  alg = "ENABLED"
  subscriberlog = "ENABLED"
  sslinterception = "ENABLED"
  contentinspectionlog = "ENABLED"
  protocolviolations = "ALL"
}
resource "citrixadc_sslcipher" "_2025_Cipher_group" {
  ciphergroupname = "2025 Cipher group"
}
resource "citrixadc_ip6tunnelparam" "ip6tunnelparam_69256570" {
  srcip = "::"
}
resource "citrixadc_ptp" "ptp_7289172" {
  state = "ENABLE"
}
resource "citrixadc_nscqaparam" "nscqaparam_84544764" {
  lr1probthresh = "0.0"
  lr2probthresh = "0.0"
}
resource "citrixadc_vlan_interface_binding" "_20_1_1_0" {
  ifnum = [
    "1/1"
  ]
  vlanid = "20"
  depends_on = [citrixadc_vlan._20, citrixadc_interface._1_1]
}
resource "citrixadc_vlan_interface_binding" "_20_100_2_1" {
  ifnum = [
    "100/2"
  ]
  vlanid = "20"
  depends_on = [citrixadc_vlan._20, citrixadc_interface._100_2]
}
resource "citrixadc_vlan_nsip_binding" "_20_10_0_0_250_0" {
  ipaddress = "10.0.0.250"
  netmask = "255.255.255.240"
  vlanid = "20"
  depends_on = [citrixadc_vlan._20, citrixadc_nsip._10_0_0_250]
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
resource "citrixadc_sslprofile_ecccurve_binding" "ns_default_ssl_profile_backend_ecccurve" {
  ecccurvename = [
    "X25519_MLKEM768",
    "X_25519",
    "P_256",
    "P_384",
    "P_224",
    "P_521"
  ]
  name = "ns_default_ssl_profile_backend"
  remove_existing_ecccurve_binding = "true"
  depends_on = [citrixadc_sslprofile.ns_default_ssl_profile_backend]
}
resource "citrixadc_sslprofile_ecccurve_binding" "ns_default_ssl_profile_secure_frontend_ecccurve" {
  ecccurvename = [
    "X25519_MLKEM768",
    "X_25519",
    "P_256",
    "P_384",
    "P_224",
    "P_521"
  ]
  name = "ns_default_ssl_profile_secure_frontend"
  remove_existing_ecccurve_binding = "true"
  depends_on = [citrixadc_sslprofile.ns_default_ssl_profile_secure_frontend]
}
resource "citrixadc_sslprofile_ecccurve_binding" "ns_default_ssl_profile_quic_frontend_ecccurve" {
  ecccurvename = [
    "X25519_MLKEM768",
    "X_25519",
    "P_256",
    "P_384",
    "P_224",
    "P_521"
  ]
  name = "ns_default_ssl_profile_quic_frontend"
  remove_existing_ecccurve_binding = "true"
  depends_on = [citrixadc_sslprofile.ns_default_ssl_profile_quic_frontend]
}
resource "citrixadc_sslprofile_ecccurve_binding" "ns_default_ssl_profile_secure_frontend_cloud_ecccurve" {
  ecccurvename = [
    "X25519_MLKEM768",
    "X_25519",
    "P_256",
    "P_384",
    "P_224",
    "P_521"
  ]
  name = "ns_default_ssl_profile_secure_frontend_cloud"
  remove_existing_ecccurve_binding = "true"
  depends_on = [citrixadc_sslprofile.ns_default_ssl_profile_secure_frontend_cloud]
}
resource "citrixadc_sslprofile_ecccurve_binding" "ns_default_ssl_profile_internal_frontend_service_ecccurve" {
  ecccurvename = [
    "X25519_MLKEM768",
    "X_25519",
    "P_256",
    "P_384",
    "P_224",
    "P_521"
  ]
  name = "ns_default_ssl_profile_internal_frontend_service"
  remove_existing_ecccurve_binding = "true"
  depends_on = [citrixadc_sslprofile.ns_default_ssl_profile_internal_frontend_service]
}
resource "citrixadc_sslprofile_ecccurve_binding" "ns_default_ssl_profile_quic_backend_ecccurve" {
  ecccurvename = [
    "X25519_MLKEM768",
    "X_25519",
    "P_256",
    "P_384",
    "P_224",
    "P_521"
  ]
  name = "ns_default_ssl_profile_quic_backend"
  remove_existing_ecccurve_binding = "true"
  depends_on = [citrixadc_sslprofile.ns_default_ssl_profile_quic_backend]
}
resource "citrixadc_sslprofile_ecccurve_binding" "_2025_SSL_Profile_ecccurve" {
  ecccurvename = [
    "X25519_MLKEM768",
    "X_25519",
    "P_256",
    "P_384",
    "P_224"
  ]
  name = "2025 SSL Profile"
  remove_existing_ecccurve_binding = "true"
  depends_on = [citrixadc_sslprofile._2025_SSL_Profile]
}
resource "citrixadc_sslprofile_sslcipher_binding" "_2025_SSL_Profile_2025_Cipher_group_0" {
  name = "2025 SSL Profile"
  ciphername = "2025 Cipher group"
  cipherpriority = "1"
  depends_on = [citrixadc_sslprofile._2025_SSL_Profile, citrixadc_sslcipher._2025_Cipher_group]
}
resource "citrixadc_sslservice_sslcertkey_binding" "nsrnatsip-127_0_0_1-5061_ns-server-certificate_0" {
  servicename = "nsrnatsip-127.0.0.1-5061"
  certkeyname = "ns-server-certificate"
  depends_on = [citrixadc_sslservice.nsrnatsip-127_0_0_1-5061, citrixadc_sslcertkey.ns-server-certificate]
}
resource "citrixadc_sslservice_sslcertkey_binding" "nskrpcs-127_0_0_1-3009_ns-server-certificate_1" {
  servicename = "nskrpcs-127.0.0.1-3009"
  certkeyname = "ns-server-certificate"
  depends_on = [citrixadc_sslservice.nskrpcs-127_0_0_1-3009, citrixadc_sslcertkey.ns-server-certificate]
}
resource "citrixadc_sslservice_sslcertkey_binding" "nshttps-__1l-443_ns-server-certificate_2" {
  servicename = "nshttps-::1l-443"
  certkeyname = "ns-server-certificate"
  depends_on = [citrixadc_sslservice.nshttps-__1l-443, citrixadc_sslcertkey.ns-server-certificate]
}
resource "citrixadc_sslservice_sslcertkey_binding" "nsrpcs-__1l-3008_ns-server-certificate_3" {
  servicename = "nsrpcs-::1l-3008"
  certkeyname = "ns-server-certificate"
  depends_on = [citrixadc_sslservice.nsrpcs-__1l-3008, citrixadc_sslcertkey.ns-server-certificate]
}
resource "citrixadc_sslservice_sslcertkey_binding" "nshttps-127_0_0_1-443_ns-server-certificate_4" {
  servicename = "nshttps-127.0.0.1-443"
  certkeyname = "ns-server-certificate"
  depends_on = [citrixadc_sslservice.nshttps-127_0_0_1-443, citrixadc_sslcertkey.ns-server-certificate]
}
resource "citrixadc_sslservice_sslcertkey_binding" "nsrpcs-127_0_0_1-3008_ns-server-certificate_5" {
  servicename = "nsrpcs-127.0.0.1-3008"
  certkeyname = "ns-server-certificate"
  depends_on = [citrixadc_sslservice.nsrpcs-127_0_0_1-3008, citrixadc_sslcertkey.ns-server-certificate]
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
resource "citrixadc_botglobal_botpolicy_binding" "botglobal_botpolicy_binding_0" {
  policyname = "sprinklr_bot_pol"
  priority = "100"
  gotopriorityexpression = "END"
  type = "REQ_OVERRIDE"
  depends_on = [citrixadc_botpolicy.sprinklr_bot_pol]
}
