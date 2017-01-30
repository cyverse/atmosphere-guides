# Atmosphere Contribution Guide

## Overview
These guidelines will improve the consistency and comprehensibility of our code.

New contributions to "the Atmosphere projects" (atmosphere, troposphere, atmosphere-ansible, clank, etc) are generally expected to follow these guidelines, and future pull requests will be checked for adherence.

### General Guidelines
- [Delete your dead code](https://late.am/post/2016/04/28/delete-your-dead-code.html). If you know that code is not run, don't comment it out, instead remove it completely. Old code remains in version control and we can dig into the past if needed.

### Python Style Guidelines

- Use 4 space indentation
- Limit lines to 79 characters
- Remove unused imports
- Remove trailing whitespace
- See [PEP8 - Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/)

It is recommended that you use the git `pre-commit` hook to ensure your code
is compliant with our style guide.

```bash
ln -s $(pwd)/contrib/pre-commit.hook $(pwd)/.git/hooks/pre-commit
```

To automate running tests before a push use the git `pre-push` hook to ensure
your code passes all the tests.

```bash
ln -s $(pwd)/contrib/pre-push.hook $(pwd).git/hooks/pre-push
```

When master is pulled, it's helpful to know if a `pip install` or a `manage.py
migrate` is necessary. To get other helpful warnings:

```bash
ln -s $(pwd)/contrib/post-merge.hook $(pwd)/.git/hooks/post-merge
```

#### Import ordering
Imports should be grouped into the sections below and in sorted order.

1. Standard libraries
2. Third-party libraries
3. External project libraries
4. Local libraries

## Ansible Style Guidelines

These apply to repos like clank and atmosphere-ansible (collectively, "the Ansible projects").

### Optionally Defined Variables
Instead of using the `| default()`

### Ansible Galaxy Roles

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
