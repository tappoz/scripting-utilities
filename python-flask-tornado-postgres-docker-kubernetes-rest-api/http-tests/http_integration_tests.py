import os
import unittest

import requests


def print_test_func_name_if_pytest():
    """
    Prints the test function name when invoked with PyTest.
    https://docs.pytest.org/en/6.2.x/example/simple.html#pytest-current-test-environment-variable
    """
    if os.environ.get("PYTEST_CURRENT_TEST") is not None:
        full_name = os.environ.get("PYTEST_CURRENT_TEST").split(" ")[0]
        test_name = full_name.split("::")[-1].split("\t")[-1]
        print(f"\n===> Running: {test_name}")


class HttpIntegrationTest(unittest.TestCase):
    def setUp(self):
        print_test_func_name_if_pytest()
        k8s_host_port = os.getenv("K8S_HOST_PORT", None)
        self.api_host_port = (
            f"http://{k8s_host_port}"
            if k8s_host_port is not None
            else "http://localhost:5000"
        )
        print(f"---> Using host/port: {self.api_host_port}\n")

    def test_get_amount_genuine(self):
        """
        curl -X GET localhost:5000/uuids?amount=10
        """
        # given
        amount = 10
        url_get_amount_genuine = f"{self.api_host_port}/uuids?amount={amount}"
        # when
        res = requests.get(url_get_amount_genuine)
        # then
        self.assertEqual(res.status_code, 200)
        res_json = res.json()
        print(res_json)
        self.assertTrue(len(res_json["uuids"]) == amount)

    def test_get_amount_harmful(self):
        """
        curl -X GET localhost:5000/uuids?amount=3xxx
        """
        # given
        url_get_amount_genuine = f"{self.api_host_port}/uuids?amount=3xxx"
        # when
        res = requests.get(url_get_amount_genuine)
        # then
        self.assertEqual(res.status_code, 400)
        res_json = res.json()
        print(res_json)
        self.assertTrue(res_json["error"] == "invalid amount")

    def test_get_existing_resource_genuine(self):
        """
        curl -X GET localhost:5000/uuid/1
        """
        # given
        uuid_string_length = 36
        url_get_existing_resource_genuine = (
            f"{self.api_host_port}/uuid/1"  # DB row with id=1
        )
        # when
        res = requests.get(url_get_existing_resource_genuine)
        # then
        self.assertEqual(res.status_code, 200)
        res_json = res.json()
        print(res_json)
        self.assertTrue(len(res_json["uuid"]) == uuid_string_length)

    def test_get_existing_resource_harmful(self):
        """
        curl -X GET localhost:5000/uuid/1xxx
        """
        # given
        url_get_existing_resource_harmful = (
            f"{self.api_host_port}/uuid/1xxx"  # DB row with id=1xxx
        )
        # when
        res = requests.get(url_get_existing_resource_harmful)
        # then
        self.assertEqual(res.status_code, 400)
        res_json = res.json()
        print(res_json)
        self.assertTrue(res_json["error"] == "invalid id")

    def test_post_genuine(self):
        """
        curl -X POST \
            -H "Content-Type: application/json" \
            -d '["fd9e7928-e876-40df-aaca-fb084f419be1"]' \
            localhost:5000/uuids
        """
        # given
        resources_list = ["fd9e7928-e876-40df-aaca-fb084f419be1"]
        # when
        res = requests.post(
            f"{self.api_host_port}/uuids",
            json=resources_list,
            headers={"Content-Type": "application/json"},
        )
        # then
        self.assertEqual(res.status_code, 200)
        res_json = res.json()
        print(res_json)
        self.assertTrue(isinstance(res_json, list))
        for returned_id in res_json:
            self.assertTrue(isinstance(returned_id, int))
