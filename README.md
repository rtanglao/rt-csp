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
* 6\. Remove all references to support.mozilla.org becaue of course we need them!
```sh
grep -v "[0-9a-z\/:]*.support.mozilla.org[-A-Z0-9a-z\/]*,,,," \
addthis.com-removed-mozilla.prod-csp-sanitized-report.csv > \
support.mozilla.org-removed-mozilla.prod-csp-sanitized-report.csv
```
* 7\. This (support.mozilla.org) removes 200 lines from mozilla.prod-csp-sanitized-report.csv
