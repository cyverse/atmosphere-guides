# Atmosphere Code Guidelines

These guidelines will improve the consistency and comprehensibility of our code. Contributions to "the Atmosphere projects" (atmosphere, troposphere, atmosphere-ansible, clank, etc) will be checked for adherence.

- [Delete your dead code](https://late.am/post/2016/04/28/delete-your-dead-code.html). If you know that code is not run, don't comment it out, instead remove it completely. Old code remains in version control and we can dig into the past if needed.

## Ansible Style Guidelines

These apply to repos such as clank and atmosphere-ansible (collectively, "the Ansible projects"). Some are borrowed from [Open edX Operations](https://openedx.atlassian.net/wiki/display/OpenOPS/Ansible+Code+Conventions) and [OpenStack-Ansible](http://docs.openstack.org/developer/openstack-ansible/developer-docs/contribute.html).

### YAML Files and Formatting

YAML files should:

- Have a name ending in `.yml`
- Begin with three dashes followed by a blank line
- Use 2-space indents
- Use YAML dictionary format rather than in-line `key=value`s. It's easier to read and reduces changeset collisions in version control. So, do this:

```
- name: foo
  file:
    src: /tmp/bar
    dest: /tmp/baz
    state: present
```

Not this:

```
- name: foo src=/tmp/bar dest=/tmp/baz state=present
```

- Use YAML [folded style](http://yaml.org/spec/1.2/spec.html#id2796251) for long lines:

```
- shell: >
       	python a very long command --with=very --long-options=foo
       	--and-even=more_options --like-these

```

### Variables

- Use spaces between double-braces and variable names: `{{ var }}` instead of `{{var}}`
- For boolean variables, use un-quoted `true` and `false`
- Bare variables in YAML must be quoted, e.g.

```
- foo: "{{ bar }}"
```

- For variables that have some default and are optionally overridden by a consumer/deployer: define the variable's default value in the role `defaults/` instead of using the `| default()` jinja2 filter. This keeps configuration separate from code.

#### Distro-Specific Variables

Many roles must take *differently-configured* actions to effect the same result, depending on the target's operating system. Accomplish this configuration by defining your variables in files like so:

```
vars/
├── CentOS-5.yml
├── CentOS.yml
├── Ubuntu-12.yml
├── Ubuntu-16.yml
└── Ubuntu.yml
```

Use the following task to include the appropriate variables file:

```
- name: gather OS-specific variables
  include_vars: "{{ item }}"
  with_first_found:
    - "{{ ansible_distribution }}-{{ ansible_distribution_major_version }}.yml"
    - "{{ ansible_distribution }}.yml"
```

Matching is most-specific to least-specific, so with the above example, a role targeting an Ubuntu 16.04 system would include the variables defined in Ubuntu-16.yml, while a role targeting Ubuntu 14.04 would include the variables defined in Ubuntu.yml. Also, only one file will match and there is no concept of inheritance (so usually, the same variables should be defined in each file).

Role-specific variables that do not vary per-distro can still be defined in `vars/main.yml` or `defaults/main.yml`.

### Tasks

Name your tasks to reflect the completed action in the past tense: `denyhosts stopped and disabled` rather than `stop and disable denyhosts`. This reinforces the goal of defining a series of idempotent steps to either reach or confirm a desired end state.

### Conditional Logic
- To conditionally include or exclude a role, use the following syntax in a playbook:

  ```
    roles:
    - { role: ldap, when: CONFIGURE_LDAP == true }
  ```

  Avoid applying the same tag to every task in a role and expecting a user to skip a role with `--skip-tags`.

### Modules

- Use `command` rather than `shell` unless shell is explicitly required ([source 0](http://docs.ansible.com/ansible/shell_module.html#notes) [source 1](https://blog.confirm.ch/ansible-modules-shell-vs-command/)).

### Files and Installation Packages

Avoid storing large binary files or installation packages in Ansible projects / version control. Instead, host it externally (e.g. CyVerse's S3 account) and download from there, or download from the publisher.

### Possible Ansible Guidelines - Things to Discuss

- [Quote all strings and prefer single quotes over double quotes](https://github.com/whitecloud/ansible-styleguide#quotes)? This makes clear what is a string and what refers to a variable
- Define a [general order for a task declaration](https://github.com/whitecloud/ansible-styleguide#task-declaration)?
- Variables that are internal to a role should be in snake_case? Variables that are environment-specific and should be overridden in UPPERCASE?
- When to use a role's `vars/` vs. `defaults/` directory? `vars/` for things internal to the role (e.g. distro-specific), `defaults/` for things expected to be overridden by a consumer?
- Prefix all variables defined in a role with the name of the role to avoid collisions?
- Prefix task names with the role name, to ease human parsing of log output?
- Separate words in role names with dashes (`my-role`)?

## Ansible Galaxy Roles

The Ansible projects will use similar code to perform very similar tasks, so there is an effort to structure our code into modular, re-usable roles. These roles are generally hosted in the [CyVerse-Ansible](https://github.com/cyverse-ansible) organization and consumed via [Ansible Galaxy](https://galaxy.ansible.com/). This will centralize the development/maintenance effort and provide easy consumption by any interested groups. New Ansible contributors are encouraged to read [Ansible Galaxy Intro](https://galaxy.ansible.com/intro).

#### Identifying and Working With Galaxy Roles

The Ansible projects include a mix of roles installed from Galaxy and roles defined locally. The following clues should indicate that a given role was installed from Galaxy.

- The role is defined in the project's `requirements.yml`
- The role contains `meta/galaxy_install_info` and `meta/main.yml`

There is a clear concept of "upstream" (roles) and "downstream" (projects that consume them), so generally we should *avoid making persistent changes* to a role which has been installed from Galaxy *inside a repository that consumes it*. Such changes will 1. not propagate back upstream to the role repository, and 2. be overwritten the next time the role is updated from Galaxy. Instead, make your changes in the upstream Ansible role (see below), re-import it, and install the new version in the consuming repository.

#### Installing (Consuming) Galaxy Roles in Another Project

The Ansible projects use a `requirements.yml` file to define the Galaxy roles we are consuming. Install new roles and update existing roles in a repo by running `ansible-galaxy install -f -r requirements.yml -p roles/` from the `ansible` folder. Then, the desired roles will be copied into your project, and you can call them from Playbooks like any other role.

#### Importing (Contributing) a Role to Galaxy

Follow the instructions in [this template](https://github.com/CyVerse-Ansible/ansible-role-template) to publish an Ansible role to Galaxy and set up automated testing with Travis CI; then you can install the role into other projects.

When you're ready to add your project to the CyVerse-Ansible organiztion contact Chris Martin for an invite.

**Note for maintainers:**
It is suggested that roles in Cyverse-Ansible be versioned with tags. Be cognizant to push tags when the project changes, and please follow the [SemVer](https://semver.org/) protocol.

## Security Guidelines

Do not store anything secret or sensitive (e.g. passphrases, SSH private keys, license keys) in public version control. Environment-specific secrets can be encrypted with Ansible Vault and stored in private version control.

When using `ansible-vault`, consider the following suggestions:
* Use one password per repository
* Vaulted file names should be pre-fixed or suffixed with _"vault"_
  - `vault-sample-file-name.yml`
  - `sample-file-name-vault.yml`

Any REST API calls that handle privileged/sensitive information (or access to private resources) should use HTTPS endpoints. Also, any downloaded code that will be executed in a trusted context (e.g. scripts and installation packages) should be obtained in a way that verifies the other party's authenticity and prevents man-in-the-middle attacks from changing the contents. In practical terms, use HTTPS, or APT packages signed with a GPG key. Avoid disabling SSL certificate verification for any of the above.

Avoid disabling SSH host key checking. When possible, learn a server's SSH host key out-of-band and verify it on first connection.

## Contribution Guide Contribution Guide

If you ask someone not to do something, offer a reasonable alternative approach. Otherwise, they may ignore your advice for the sake of pragmatism.

## Further Reading

- [Code Smells](http://wiki.c2.com/?CodeSmell)
