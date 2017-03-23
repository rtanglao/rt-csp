# rt-csp
roland's fun CSP for lithium repo
## 22March2017
* 1\. A better approach is to parse the CSV file into an array
* 2\. foreach 2nd element of the array, find the domain and the print to stdout
* 3\.then pipe to ```uniq```
* 4\.sketch to get URI
```ruby
require 'rubygems'
require 'ccsv'

Ccsv.foreach(file) do |values|
  puts values[2] # values[2] to get the URI
end
```
* 5\.sketch to get domain from URI
```ruby
uri = URI.parse("https://support.mozilla.org/t5/user/viewprofilepage/user-id/873432")
=> #<URI::HTTPS https://support.mozilla.org/t5/user/viewprofilepage/user-id/873432>
irb(main):006:0> domain = PublicSuffix.parse(uri.host)
domain.domain
=> "mozilla.org"
```
* 6\. get rid of the DOS line endings
```sh
tr -d '\r' < mozilla.prod-csp-sanitized-report.csv \
> unix-line-endings-mozilla.prod-csp-sanitized-report.csv
```
* 7\. get all the domains
```sh
./print-domain.rb  unix-line-endings-mozilla.prod-csp-sanitized-report.csv \
2>stderr-mozilla-domains.txt >stdout-mozilla-domains.txt
```
* 8\. get the unique domains
```sh
cat stdout-mozilla-domains.txt | sort | \
uniq > unique-mozilla-domains.txt
```
* 9\. get non HTTP and non HTTPS field2
```sh
grep FIELD3 stderr-mozilla-domains.txt |sort | \
uniq > stderr-non-http-non-https-field2.txt
```
* 10\. get Public Suffix bad domains (not sure why Public Suffix isn't happy with ```http://s3.amazonaws.com``` perhaps because it should be ```https://s3.amazonaws.com``` ?!?!)
```sh
rtanglao13483:rt-csp rtanglao$ grep URI stderr-mozilla-domains.txt 
PublicSuffix::DomainNotAllowed^^^ URI:s3.amazonaws.com
PublicSuffix::DomainNotAllowed^^^ URI:s3.amazonaws.com
```
* 11\. now make a file with all the domains, start with unique-mozilla-domains.txt and manually add http://s3.amazonaws.com and stderr-non-http-non-https-field2.txt
```sh
cat unique-mozilla-domains.txt stderr-non-http-non-https-field2.txt > mozilla-good-bad-domains.md
echo "http://s3.amazonaws.com" >> mozilla-good-bad-domains.md
```
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
* 33\. stickyadstv.com appears to be a streaming ad solution that  has been renamed to freewheel. Remove!
```sh
grep -v stickyads \
really-really-addthis.com-removed-mozilla.prod-csp-sanitized-report.csv >\
stickyadstv.com-removed-mozilla.prod-csp-sanitized-report.csv
```
* 34\. This (stickyads) removes about 9 lines!
* 35\. First line of stickyadstv.com-removed-mozilla.prod-csp-sanitized-report.csv: https://support.mozilla.org/t5/Protect-your-privacy/Insecure-password-warning-in-Firefox/ta-p/27861,,https://connectionstrenth.com,,,,5
* 36\. Lists
  * Good
    * https://d2xvc2nqkduarq.cloudfront.net (amazon CDN)
    * https://fonts.googleapis.com
    * https://gateway.zscaler.net (cloud security?)
    * https://cdncache-a.akamaihd.net (CDN?)
    * addthis.com, addthisedge.com (Lithium share button)
    * youtube.com
    * lithium.com
    * support.mozilla.org
    * google.com
    * hwsfp35778.i.lithium.com
    * https://www.google-analytics.com
    * https://code.jquery.com
    * support.cdn.mozilla.net
    * support.mozilla.org/legacy
    * translate.google.com
    * s3.amazonaws.com
  * Potentially bad
    * streamrail.com (ad network)
    * mxpnl.net (analyics)
    * vpaid.js (ad network)
    * stickyads (ad network)
    * https://connectionstrenth.com (ad network)
    * http://cdncash.net/ (ad network)
    * https://vast.yashi.com (ad network)
    * http://match.adsrvr.org/ (ad network)
    * https://partner-key.me (not sure what this is?!?)
    * https://fonts.gstatic.com (google analytics? google tracking?)
    * https://static.cmptch.com (malware?)
    * https://vid.springserve.com (ad network)
    * https://adnotbad.com (ad network)
    * https://takethatad.com (ad network)
    * https://awaybird.ru (ad network?)
    * https://data1.itineraire.info (?)
    * https://sdk.streamrail.com (ad network)
    * https://t.lkqd.net (ad network?)
    * https://x.rafomedia.com (ad network)
    * http://vid-io.springserve.com, (ad network)
    * https://ads.adaptv.advertising.com (ad network)
    * apiboxrockinfo-a.akamaihd.net
    * https://apienhancetronic-a.akamaihd.net
    * https://asrvvv-a.akamaihd.net
    * https://cleanbrowser-a.akamaihd.net
    * https://intext-a.akamaihd.net
    * https://savingsslider-a.akamaihd.net
    * data1.allo-pages.fr
    * data1.bilan-imc.fr
    * https://fdz.octapi.net
    * hm.baidu.com
    * mc.yandex.com
    * search-goo.com
    * pstatic.bestpriceninja.com
    * https://data1.imc-calcular.com
    * https://cdn.optimatic.com
    * https://cdn.hiberniacdn.com
    * lb.apicit.net
    * http://tags.clickintext.net
    * net.ootil.fr
    * cdn.visadd.com
    * cjs.linkbolic.com
    * d2a8a4q9.ssl.hwcdn.net
    * mstat.acestream.net
    * eluxer.net
    * ext.kinoroombrowser.ru
    * www.adstomat.ru
    * tc.koushuidang.cn
    * rdc.apicit.net
    * https://www.findizer.fr
    * jsl.infostatsvc.com
    * s.igmhb.com
    * https://system.donation-tools.org
    * cdnins.123rede.com
    * stags.bluekai.com
    * i_tonginjs_info.tlscdn.com
    * pixel.yabidos.com
    * pstatic.davebestdeals.com
    * https://qnp.demisedcolonnaded.com
    * rules.similardeals.net
    * data1.recettes.net
    * foxi69.tlscdn.com
    * istatic.eshopcomp.com
    * findizer.fr
    * data1.iti-maps.fr
    * tags.clickintext.net
    * app.davebestdeals.com
    * 1087072589.rsc.cdn77.org
    * qdatasales.com
    * ezb.elvenmachine.com
    * cdn-01.yumenetworks.com
    * ads.contextweb.com
    * fqtag.com
    * platform.epiphanyai.com
    * vast.bp3872166.btrll.com
    * app.bestpriceninja.com
    * data1.calcolo-bmi.com
    * fp1f171.digitaloptout.com
    * sgnr.bestpriceninja.com
    * nps.noproblemppc.com
    * pl.adsloads.com
    * pstatic.bestpriceninja.com
    * px.media-serving.com
    * sovetnik.market.yandex.ru
    * nps.noproblemppc.com
    * https://data1.yummmi.es
    
