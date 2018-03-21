==========================
Salt-based Jenkins manager
==========================

This tooling utilizes `salt-formula-jenkins
<https://github.com/salt-formulas/salt-formula-jenkins>`_ capabilities to
manage Jenkins masters.

Unlike other projects like Jenkins Job Builder, this one can manage more than
only jobs. For example:

- nodes
- credentials
- plugins
- SMTP
- views
- security
- global libraries

It is idempotent so you can execute salt-jenkins-manager periodically to
enforce up-to-date configuration.

Usage
=====

- You need to prepare pillar to tell manager what to do. See files/pillar
  directory as an entry point.

  - top.sls defines which pillars should be included on the node, it's up to
    you if you want to have single big file or more smaller. By default, we
    include ``jenkins/{master,jobs,credentials}.sls``.

- Run container

   .. code-block:: bash

       docker run -it --rm=true -v `pwd`/files/pillar:/srv/pillar -e MASTER_HOST=my-jenkins.local genunix/salt-jenkins-manager

   - Following environment variables are supported:

     - MASTER_HOST (default 127.0.0.1)
     - MASTER_PORT (default 80)
     - MASTER_PROTOCOL (default http)
     - MASTER_USER (default empty)
     - MASTER_PASSWORD (default empty)
