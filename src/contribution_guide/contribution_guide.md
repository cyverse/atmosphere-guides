# Atmosphere Contribution Guide

## Overview

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
