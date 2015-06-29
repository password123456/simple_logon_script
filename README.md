# simple_logon_script

Requirements:
- Windows XP - Windows 7 (not confirmed over windows 8)

Overview:
- This is collecting information when logged in windows logon session. 

Features:
 * Current login user account.
 * login comupter name (domainName)
 * Current PC ip address
 * Get Local Administratos Group user lists.
 * and anything you wants it.

Expects:
 - Administrator can collects pc login activities via windows login script like Active Directory enviroment.
 - This may be helpful for analyzing abnormal PC's logged in activity tracking
 - This can be make the infra Asset DB through the collection of information and useful
   ex) export these informations to the Splunk, ElasticSearch
