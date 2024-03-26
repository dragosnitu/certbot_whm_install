# certbot_whm_install
Automatically install letsencrypt certificates in cPanel DNSOnly

cPanel DNSOnly does not provide a SSL certificate automatically. This script can be used as a post hook for letsencrypt to install the certificate/private key/bundle using whmapi1.

To use letsencrypt we first need to configure *cpsrvd* to not listen to ports 80 and 443. Edit */var/cpanel/etc/cpanel.config* and set **disable_cphttpd=1**, then restart cpsrvd with **/scripts/restartsrv_cpsrvd**
Then install certbot and copy **/scripts/restartsrv_cpsrvd.sh** to **/etc/letsencrypt/renewal-hooks/deploy**.
Get a certificate with *certbot certonly --standalone -d your.hostname.dom* and now you should have a valid certificate for your cPanel DNSOnly installation.
Make sure that *certbot-renew.timer* is enabled with systemctl enable certbot-renew.timer to automatically renew the certificate before it expires.
