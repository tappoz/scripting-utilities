import unittest

from src.stuff import util


class UtilTest(unittest.TestCase):
    def setUp(self):
        util.configure_logger()

    def test_load_config(self):  # pylint: disable=no-self-use # R0201
        conf_dict = util.load_config()
        assert conf_dict.get_or_else("http", "port") == str(5000)
