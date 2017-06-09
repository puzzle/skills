# encoding: utf-8

require Rails.root.join('db', 'seeds', 'support', 'expertise_category_seeder')

seeder = ExpertiseCategorySeeder.new

# seed developer categories
seeder.seed_development_category('Java', ['Java SE', 'Java EE', 'EJB CDI', 'JPA Hibernate. o.ä.',
                                            'JMS', 'Servlets, JSP, JSF', 'JUnit, Mockito, o.ä.',
                                            'Spring Framework'])

seeder.seed_development_category('Ruby', ['Ruby', 'Ruby on Rails', 'DelayedJob Sidekiq, Resque',
                                          'Minitest, Rspec, o.ä.'])

seeder.seed_development_category('JavaScript', ['JavaScript/ECMAScript', 'JQuery', 'Angular',
                                                'Jasmine, Mocha, Qunit, o.ä.',
                                                'Hybrid Mobile Apps'])

seeder.seed_development_category('Allgemeine Konzepte und Sprachen', ['REST', 'WebSockets', 'HTML',
                                                                      'CSS, SASS', 'UML',
                                                                      'Shell Scripting', 'Linux'])

seeder.seed_development_category('Werkzeuge', ['GIT, o.ä.', 'Jenkins, Travis, o.ä', 'Sonar, o.ä.'])

seeder.seed_development_category('Middleware', ['WildFly / JBoss EAP', 'Passenger, Puma, o.ä',
                                                'Docker, Openshift, o.ä.', 'Message Queues',
                                                'Apache Camel'])

seeder.seed_development_category('Datenbanken', ['SQL, Relationale DBs',
                                                 'Stored Procedures', 'NoSql'])

seeder.seed_development_category('Software Design und Methoden', 
                                 ['Objektorientierte Analyse und Design',
                                  'Funktionale Programmierung', 'Design Patterns', 'Scrum, o.ä.'])

seeder.seed_development_category('Ergänzungen')


# seed system engineer categories
seeder.seed_system_category('Linux Distributionen', ['Red Hat', 'CentOS', 'Fedora', 'Debian',
                                                     'Ubuntu', 'SUSE', 
                                                     'Andere (Name in Bemerkung)'])

seeder.seed_system_category('Linux System- & Configuration-Management', 
                            ['systemd', 'Puppet', 'Ansible', 'Red Hat Satellite / Pulp',
                             'TheForeman / Katello', 'MCollective', 
                             'Weitere Configuration-Management Tools , 
                                wie Cfengine oder Chef (Name in Bem.)'])

seeder.seed_system_category('Monitoring', ['Icinga', 'Negios',
                                           'Weitere Monitoring Tools wie Zabbix (Name in Bem.)'])

seeder.seed_system_category('Storage / File Services', 
                            ['LVM', 'RAID', 'iSCSI', 'Open-E', 'GlusterFS', 'CEPH',
                             'Weitere (wie NetApp -> Name in Bem.)', 'NFS', 'Samba'])

seeder.seed_system_category('Packaging', ['RPM', 'DEB', 'Weitere (Name in B.)'])

seeder.seed_system_category('Hochverfügbarkeit', ['Red Hat Cluster Suite', 'Heartbeat', 'GFS2',
                                                  'VRRP / CARP', 'DRBD', 'Multipath',
                                                  'HAProxy', 'KeepAliveD'])

seeder.seed_system_category('Networking', ['BIND', 'DHCP', 'IPv6', 'Advanced Routing', 'VLANs',
                                           'SDN', 'Network Appliances 
                                                    (wie pfSense, etc. -> Name in Bem.)'])

seeder.seed_system_category('Backup Services', ['Amanda', 'Veritas', 'rdiff-backup', 'Baracuda',
                                                'BackupPC', 'Bacula', 'weitere (Name in B.)'])

seeder.seed_system_category('Mail Service', ['Sendmail', 'Postfix', 'Exim', 'Dovecot', 'Procmail',
                                             'Sieve', 'Kolab', 'ClamAV', 'SpamAssassin'])

seeder.seed_system_category('Web- & Application-Server',
                            ['Apache httpd', 'Passenger', 'NGINX', 'WildFly/JBoss EAP', 'Jetty',
                             'Tomcat', 'Glassfish', 'WebLogic', 'WebSphere',
                             'Jenkins (oder andere CI Server -> Name in Bemerkungen)'])

seeder.seed_system_category('DB Server', ['SQL RDBMS (Name in Bemerkung)',
                                          'NoSQL (Name in Bemerkung)', 'LDAP'])

seeder.seed_system_category('Security', ['OpenSSH', 'OpenVPN', 'SELinux', 'Shorewall',
                                         'firewalld', 'Iptables', 'ACLs', 'x509 Zertifikate'])

seeder.seed_system_category('Server Virtualisierung', 
                            ['KVM', 'XEN', 'VirtualBox', 'VMware', 'LXC',
                             'Weitere (vServer/Hyper-V, OpenVZ->Name in Bem.)'])

seeder.seed_system_category('Cloud (IaaS / PaaS)',
                            ['RHEV-M', 'OpenStack', 'CloudStack', 'vCloud',
                             'Public Cloud (AWS, Rackspace -> Name in Bemerkungen)',
                             'OpenShift', 'CloudFoundry',
                             'Hosted PaaS (App Engine, Heroku, etc. -> Name in Bem. )'])

seeder.seed_system_category('Tools', ['Jenkins / Hudson', 'Redmine', 'OTRS', 'Errbit', 'Sonar'])

seeder.seed_system_category('Programmier- und Script-Sprachen', 
                            ['Ruby', 'Shell Scripting', 'Perl', 'Python',
                             'PHP', 'C', 'C++', 'Java'])

seeder.seed_system_category('Version Control', ['Git', 'SVN'])

seeder.seed_system_category('Ergänzungen')
