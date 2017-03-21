# rt-csp
roland's fun CSP for lithium repo
## 20March2017
working on [case 00134461](https://supportcases.lithium.com/50061000009MCTs) which is referenced in 
[CSP bug 1339940](https://bugzilla.mozilla.org/show_bug.cgi?id=1339940) as well as 
[HSTS bug 1340056](https://bugzilla.mozilla.org/show_bug.cgi?id=1340056)
* 1\. working on [1st line of the CSV File](https://github.com/rtanglao/rt-csp/blob/master/mozilla.prod-csp-sanitized-report.csv) https://support.mozilla.org/t5/Protect-your-privacy/Insecure-password-warning-in-Firefox/ta-p/27861,,https://s7.addthis.com,,,,702
* 2\. url is https://support.mozilla.org/t5/Protect-your-privacy/Insecure-password-warning-in-Firefox/ta-p/27861 and the domain in question is s7.addthis.com; view source of that page shows that this is a lithium script and the code is in line 9362 when viewed in firefox:
```</script><script type="text/javascript" src="https://hwsfp35778.i.lithium.com/t5/scripts/636759EE6BB9D6E9B2C77AFF9A2C8CA1/lia-scripts-common-min.js"></script><script type="text/javascript" src="https://s7.addthis.com/js/300/addthis_widget.js"></script><script type="text/javascript" src="https://hwsfp35778.i.lithium.com/t5/scripts/0D78F3D7C0EE86C6FC90FB96880A3D73/lia-scripts-body-min.js"></script><script language="javascript" type="text/javascript">```
* 3\. Remove all lines with references to "*addthis.com*,,,," because that is not mozilla's problem :-) ; this is needed by lithium's share feature
```sh
grep -v "[0-9a-z]*.addthis.com[0-9a-z]*,,,," mozilla.prod-csp-sanitized-report.csv \
> addthis.com-removed-mozilla.prod-csp-sanitized-report.csv
```
* 4\. This (addthis.com) removes 1100 lines from mozilla.prod-csp-sanitized-report.csv
* 5\. First line of [addthis.com-removed-mozilla.prod-csp-sanitized-report.csv](https://github.com/rtanglao/rt-csp/blob/master/addthis.com-removed-mozilla.prod-csp-sanitized-report.csv): https://support.mozilla.org/t5/Mozilla-Support-English/ct-p/Mozilla-EN,,https://support.mozilla.org/t5/Mozilla-Support-English/ct-p/Mozilla-EN,,,,548
* 6\. Therefore remove all references to support.mozilla.org because of course we need them!
```sh
grep -v "[0-9a-z\/:]*.support.mozilla.org[-A-Z0-9a-z\/]*,,,," \
addthis.com-removed-mozilla.prod-csp-sanitized-report.csv > \
support.mozilla.org-removed-mozilla.prod-csp-sanitized-report.csv
```
* 7\. This (support.mozilla.org) removes 200 lines from mozilla.prod-csp-sanitized-report.csv
* 8\. First line of [support.mozilla.org-removed-mozilla.prod-csp-sanitized-report.csv](https://github.com/rtanglao/rt-csp/blob/master/support.mozilla.org-removed-mozilla.prod-csp-sanitized-report.csv): https://support.mozilla.org/t5/Basic-Browsing/Get-started-with-Firefox-An-overview-of-the-main-features/ta-p/3994,,https://www.youtube.com,,,,420
* 9.\. Therefore remove all references to youtube.com because of course we need them!
```sh
grep -v "[0-9a-z\/:]*.youtube.com[-A-Z0-9a-z_=\/\&\?]*,,,," \
support.mozilla.org-removed-mozilla.prod-csp-sanitized-report.csv > \
youtube.com-removed-mozilla.prod-csp-sanitized-report.csv
```
* 10\. This (youtube.com) removes 200 lines from support.mozilla.org-removed-mozilla.prod-csp-sanitized-report.csv
* 11\. First line of [youtube.com-removed-mozilla.prod-csp-sanitized-report.csv](https://github.com/rtanglao/rt-csp/blob/master/youtube.com-removed-mozilla.prod-csp-sanitized-report.csv): https://support.mozilla.org/t5/Protect-your-privacy/Insecure-password-warning-in-Firefox/ta-p/27861,,https://m.addthisedge.com,,,,187
* 12\. Therefore remove all references to addthisedge.com (it seems to be part of the Lithium nascar share button i.e. part of addthis.com)
```sh
grep -v "[0-9a-z\/:]*.addthisedge.com[-A-Z0-9a-z_=\/\&\?]*,,,," \
youtube.com-removed-mozilla.prod-csp-sanitized-report.csv > \
addthisedge.com-removed-mozilla.prod-csp-sanitized-report.csv
```
* 13\. This (addthisedge.com) removes 200 lines from youtube.com-removed-mozilla.prod-csp-sanitized-report.csv
* 14\. First line of [addthisedge.com-removed-mozilla.prod-csp-sanitized-report.csv](https://github.com/rtanglao/rt-csp/blob/master/addthisedge.com-removed-mozilla.prod-csp-sanitized-report.csv): https://support.mozilla.org/t5/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-%D0%B8-%D0%BE%D0%B1%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5/%D0%92%D0%B0%D0%B6%D0%BD%D0%BE-Firefox-%D0%B2%D1%81%D0%BA%D0%BE%D1%80%D0%B5-%D0%BF%D1%80%D0%B5%D0%BA%D1%80%D0%B0%D1%89%D0%B0%D0%B5%D1%82-%D0%BF%D0%BE%D0%B4%D0%B4%D0%B5%D1%80%D0%B6%D0%BA%D1%83-Windows-XP-%D0%B8-Vista/ta-p/31718,,https://support.mozilla.org/t5/%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0-%D0%B8-%D0%BE%D0%B1%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%B8%D0%B5/%D0%92%D0%B0%D0%B6%D0%BD%D0%BE-Firefox-%D0%B2%D1%81%D0%BA%D0%BE%D1%80%D0%B5-%D0%BF%D1%80%D0%B5%D0%BA%D1%80%D0%B0%D1%89%D0%B0%D0%B5%D1%82-%D0%BF%D0%BE%D0%B4%D0%B4%D0%B5%D1%80%D0%B6%D0%BA%D1%83-Windows-XP-%D0%B8-Vista/ta-p/31718,,,,37
* 15\. Oops forgot to remove  all references to unicode in support.mozilla.org (swithched to gnu grep aka ggrep because perl regular expressions are easier to grok)!
```sh
ggrep -Pv ",,[a-z\:\/\.]*support\.mozilla\.org[A-Z0-9a-z_=\/\&\?\-\%\.]*,,,," \
addthisedge.com-removed-mozilla.prod-csp-sanitized-report.csv > \
unicodesupport.mozilla.org-removed-mozilla.prod-csp-sanitized-report.csv
```
* 16\. This (unicodesupport.mozilla.org) removes 100 lines from addthisedge.com-removed-mozilla.prod-csp-sanitized-report.csv
* 17\. First line of [unicodesupport.mozilla.org-removed-mozilla.prod-csp-sanitized-report.csv](https://github.com/rtanglao/rt-csp/blob/master/unicodesupport.mozilla.org-removed-mozilla.prod-csp-sanitized-report.csv): https://support.mozilla.org/t5/Install-and-Update/Update-Firefox-to-the-latest-version/ta-p/2858,,https://s7.addthis.com/static/sh.0d19417fd0a004d73df6a35b.html,,,,9
* 18\. Ooops didn't remove all addthis references earlier! Therefore do it!
```sh
ggrep -Pv ",,[0-9a-z\:\/\.]*addthis\.com[A-Z0-9a-z_=\/\&\?\-\%\.]*,,,," \
unicodesupport.mozilla.org-removed-mozilla.prod-csp-sanitized-report.csv > \
reallyaddthis.com-removed-mozilla.prod-csp-sanitized-report.csv
```
* 19\. This (reallyaddthis.com.removed) removes another 300 lines from unicodesupport.mozilla.org-removed-mozilla.prod-csp-sanitized-report.csv
* 20\. First line of [reallyaddthis.com-removed-mozilla.prod-csp-sanitized-report.csv-mozilla.prod-csp-sanitized-report.csv](https://github.com/rtanglao/rt-csp/blob/master/reallyaddthis.com-removed-mozilla.prod-csp-sanitized-report.csv): https://support.mozilla.org/t5/Mozilla-Support-English/ct-p/Mozilla-EN,,https://ff-input.mxpnl.net,,,,9
* 21\. Not sure if mxpnl.net is legitimate, need to ask FF Security and Lithium. Is it for Analytics? But let's remove it
```sh
ggrep -Pv ",,[-0-9a-z\:\/\.]*mxpnl\.net[A-Z0-9a-z_=\/\&\?\-\%\.]*,,,," \
reallyaddthis.com-removed-mozilla.prod-csp-sanitized-report.csv > \
mxpnl.net-removed-mozilla.prod-csp-sanitized-report.csv
```
* 22\. This (mxpnl.net) removed about 9 lines
* 23\. First line of mxpnl.net-removed-mozilla.prod-csp-sanitized-report.csv is: https://support.mozilla.org/t5/Manage-preferences-and-add-ons/How-to-change-your-default-browser-in-Windows-10/ta-p/35222?utm_medium=firefox-browser&utm_source=firefox-browser,,https://m.addthisedge.com/live/boost/PoweredByLithium/_ate.track.config_resp,,,,7
* 24\. Therefore really remove addthisedge
```sh
ggrep -Pv ",,[-0-9a-z\:\/\.]*addthisedge\.com[A-Z0-9a-z_=\/\&\?\-\%\.]*,,,," \
mxpnl.net-removed-mozilla.prod-csp-sanitized-report.csv > \
reallyaddthisedge.com-removed-mozilla.prod-csp-sanitized-report.csv
```
* 25\. This (really remove addthisedge.com) remove about 25 lines
* 26\. First line of reallyaddthisedge.com-removed-mozilla.prod-csp-sanitized-report.csv: https://support.mozilla.org/t5/Learn-the-Basics-get-started/Como-remover-uma-p%C3%A1gina-marcada-como-favorita/ta-p/26929,script-src,https://ad.lkqd.net/vpaid/vpaid.js?fusion=1.0,https://sdk.streamrail.com/player/sr.ads.js,28,72,6
* 27\. streamrail.com appears to be a streaming ad solution. Remove!
```sh
grep -v vpaid.js \
reallyaddthisedge.com-removed-mozilla.prod-csp-sanitized-report.csv >\
vpaid.js-removed-mozilla.prod-csp-sanitized-report.csv
```
* 28\. This (remove vpaid.js) removes about 150 lines
* 29\. First line of vpaid.js-removed-mozilla.prod-csp-sanitized-report.csv: about:blank,font-src,data,https://s7.addthis.com,2,3550,5
* 30\. Remove more references to addthis
```sh
grep addthis -v \
vpaid.js-removed-mozilla.prod-csp-sanitized-report.csv > 
\really-really-addthis.com-removed-mozilla.prod-csp-sanitized-report.csv
```
* 31\. This (really really remove addthis.com) removes about 400 lines!
* 32\. First line of really-really-addthis.com-removed-mozilla.prod-csp-sanitized-report.csv: https://support.mozilla.org/t5/Conserte-os-problemas/O-que-significa-quot-Sua-conex%C3%A3o-n%C3%A3o-%C3%A9-segura-quot/ta-p/32223,,https://ads.stickyadstv.com,,,,5
