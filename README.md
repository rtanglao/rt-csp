# rt-csp
roland's fun CSP for lithium repo
## 20March2017
working on [case 00134461](https://supportcases.lithium.com/50061000009MCTs) which is referenced in 
[CSP bug 1339940](https://bugzilla.mozilla.org/show_bug.cgi?id=1339940) as well as 
[HSTS bug 1340056](https://bugzilla.mozilla.org/show_bug.cgi?id=1340056)
* 1\. working on [1st line of the CSV File](https://github.com/rtanglao/rt-csp/blob/master/mozilla.prod-csp-sanitized-report.csv) https://support.mozilla.org/t5/Protect-your-privacy/Insecure-password-warning-in-Firefox/ta-p/27861,,https://s7.addthis.com,,,,702
* 2\. url is https://support.mozilla.org/t5/Protect-your-privacy/Insecure-password-warning-in-Firefox/ta-p/27861 and the domain in question is s7.addthis.com; view source of that page shows that this is a lithium script and the code is in line 9362 when viewed in firefox:
```</script><script type="text/javascript" src="https://hwsfp35778.i.lithium.com/t5/scripts/636759EE6BB9D6E9B2C77AFF9A2C8CA1/lia-scripts-common-min.js"></script><script type="text/javascript" src="https://s7.addthis.com/js/300/addthis_widget.js"></script><script type="text/javascript" src="https://hwsfp35778.i.lithium.com/t5/scripts/0D78F3D7C0EE86C6FC90FB96880A3D73/lia-scripts-body-min.js"></script><script language="javascript" type="text/javascript">```
