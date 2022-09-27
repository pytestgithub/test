pytest-testrail-e2e
===============

[![PyPI version](https://badge.fury.io/py/pytest-testrail-e2e.svg)](https://badge.fury.io/py/pytest-testrail-e2e)
[![Downloads](https://pepy.tech/badge/pytest-testrail-e2e)](https://pepy.tech/project/pytest-testrail-e2e)
[![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](/LICENSE)
[![pytest](https://img.shields.io/badge/pytest-%3E%3D3.6-blue.svg)](https://img.shields.io/badge/pytest-%3E%3D3.6-blue.svg)

This is a pytest plugin for creating/editing testplans or testruns based on pytest markers.
The results of the collected tests will be updated against the testplan/testrun in TestRail.

Installation
------------

    pip install pytest-testrail-e2e

Configuration
-------------

### Config for Pytest tests

Add a marker to the tests that will be picked up to be added to the run.

```python
    from pytest_testrail.plugin import testrail

    @testrail('C1234', 'C5678')
    def test_foo():
        # test code goes here

    # OR	

    from pytest_testrail.plugin import pytestrail

    @pytestrail.case("C1234", "C5678")
    def test_bar():
        # test code goes here
```

Or if you want to add defects to testcase result:

```python

    from pytest_testrail.plugin import pytestrail

    @pytestrail.defect("PF-524", "BR-543")
    def test_bar():
        # test code goes here
```

Skip a testcase [**You need create 'Skipped' status in TestRail'**]:

```python

    from pytest_testrail.plugin import pytestrail

    @pytestrail.case("C1234")
    @pytest.mark.skip("Mark as skipped description") 
    # or @pytest.mark.skip(reason="Mark as skipped description")
    def test_bar():
        # test code goes here
```

Block a testcase:

```python
    
    import pytest
    from pytest_testrail.plugin import pytestrail
    
    @pytestrail.case("C1234")
    @pytestrail.block("Mark as blocked description")
    # @pytestrail.block(reason="Mark as blocked description")
    def test_bar():
        # test code goes here
    
    # OR

    @pytestrail.case("C1234")
    @pytest.mark.skip(reason="Mark as blocked description", block=True)
    def test_bar():
        # test code goes here
```

How to set known defect ID for specific assertion: 
set ``pytest-defect=<defect_id>`` in assertion error message.
```python
    
    from pytest_testrail.plugin import pytestrail
    
    @pytestrail.case("C1234")
    @pytestrail.defectif()
    def test_bar():
        # Assertion 1: defect NCT-836
        assert 1==0, "pytest-defect=NCT-836"
        # Assertion 2: defect NCT-1024
        assert False, "Error message contains regex: pytest-defect=NCT-1024 allows to insert defect 'NCT-1024'"
```

### Config for TestRail

* Settings file template config:

```ini
    [API]
    url = https://yoururl.testrail.net/
    email = user@email.com
    password = <api_key>

    [TESTRUN]
    assignedto_id = 1
    project_id = 2
    suite_id = 3
    plan_id = 4
    description = 'This is an example description'

    [TESTCASE]
    custom_comment = 'This is a custom comment'
```

Or

* Set command line options (see below)

Usage
-----

Basically, the following command will create a testrun in TestRail, add all marked tests to run.
Once the all tests are finished they will be updated in TestRail:

```bash
    py.test --testrail --tr-config=<settings file>.cfg
```

### All available options

| option                         | description                                                                                                         |
| -------------------------------|---------------------------------------------------------------------------------------------------------------------|
| --testrail                     | Create and update testruns with TestRail                                                                            |
| --tr-config                    | Path to the config file containing information about the TestRail server (defaults to testrail.cfg)                 |
| --tr-url                       | TestRail address you use to access TestRail with your web browser (config file: url in API section)                 |
| --tr-email                     | Email for the account on the TestRail server (config file: email in API section)                                    |
| --tr-password                  | Password for the account on the TestRail server (config file: password in API section)                              |
| --tr-testrun-assignedto-id     | ID of the user assigned to the test run (config file:assignedto_id in TESTRUN section)                              |
| --tr-testrun-project-id        | ID of the project the test run is in (config file: project_id in TESTRUN section)                                   |
| --tr-testrun-suite-id          | ID of the test suite containing the test cases (config file: suite_id in TESTRUN section)                           |
| --tr-testrun-suite-include-all | Include all test cases in specified test suite when creating test run (config file: include_all in TESTRUN section) |
| --tr-testrun-name              | Name given to testrun, that appears in TestRail (config file: name in TESTRUN section)                              |
| --tr-testrun-description       | Description given to testrun, that appears in TestRail (config file: description in TESTRUN section)                |
| --tr-run-id                    | Identifier of testrun, that appears in TestRail. If provided, option "--tr-testrun-name" will be ignored            |
| --tr-plan-id                   | Identifier of testplan, that appears in TestRail. If provided, option "--tr-testrun-name" will be ignored           |
| --tr-version                   | Indicate a version in Test Case result.                                                                             |
| --tr-no-ssl-cert-check         | Do not check for valid SSL certificate on TestRail host                                                             |
| --tr-close-on-complete         | Close a test plan or test run on completion.                                                                        |
| --tr-dont-publish-blocked      | Do not publish results of "blocked" testcases in TestRail                                                           |
| --tr-skip-missing              | Skip test cases that are not present in testrun                                                                     |
| --tr-milestone-id              | Identifier of milestone to be assigned to run                                                                       |
| --tc-custom-comment            | Custom comment, to be appended to default comment for test case (config file: custom_comment in TESTCASE section)   |
| --tr-report-single-test        | Report result immediately for each test case when it finished  |

## TestRail Settings

To increase security, the TestRail team suggests using an API key instead of a password. You can see how to generate an API key [here](http://docs.gurock.com/testrail-api2/accessing#username_and_api_key).

If you maintain your own TestRail instance on your own server, it is recommended to [enable HTTPS for your TestRail installation](http://docs.gurock.com/testrail-admin/admin-securing#using_https).

For TestRail hosted accounts maintained by [Gurock](http://www.gurock.com/), all accounts will automatically use HTTPS.

You can read the whole TestRail documentation [here](http://docs.gurock.com/).

## Author

NGUYEN Viet - [github](https://github.com/vietnq254)

## License

This project is licensed under the [MIT license](/LICENSE).

## Acknowledgments

* [allankp](https://github.com/allankp), author of the [pytest-testrail](https://github.com/allankp/pytest-testrail) repository that was cloned.