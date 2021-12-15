import configparser
import logging
import os
from pathlib import Path

LOG_FILENAME = "my_server.log"
MSG_FMT = "%(asctime)s %(process)d:%(threadName)s [%(levelname)s]: %(message)s"
TS_FMT = "%Y-%m-%d %H:%M:%S"


class ConfigDict:  # pylint: disable=too-few-public-methods
    def __init__(self):
        """
        Load the INI file specified on environment variable CONFENV
        as a relative path to here.
        """
        confenv = os.environ.get("CONFENV", "test").lower()
        conf_file_abs_path = f"{Path(__file__).resolve().parent}/../conf/{confenv}.ini"
        logging.warning(f"Loading config file at: {conf_file_abs_path}")
        self.c_parser = configparser.RawConfigParser()
        self.c_parser.read(conf_file_abs_path)

    def get_or_else(self, section, option):
        """
        Given a pair <section,option> from a INI file parsed with ConfigParser (see __init__()):
        1. Try to load it from the environment variable "SECTION_OPTION".
        2. Try to load the "section>option" from the INI file.
        3. Otherwise raise an exception.
        """
        env_var_label = "_".join([section, option]).upper()
        env_var_value = os.getenv(env_var_label, "")
        if env_var_value != "":
            logging.warning(
                f"A config detail is being loaded from the environment variable: {env_var_label}"
            )
            return env_var_value
        if self.c_parser.has_option(section, option):
            return self.c_parser.get(section, option)
        raise ValueError(f"Cannot load config property: '{section}.{option}'")


def load_config():
    return ConfigDict()


def configure_logger():
    # log to file
    logging.basicConfig(
        filename=LOG_FILENAME,
        format=MSG_FMT,
        datefmt=TS_FMT,
        level=logging.DEBUG,
    )
    # log to console as well
    console = logging.StreamHandler()
    console.setLevel(logging.DEBUG)
    formatter = logging.Formatter(MSG_FMT)
    console.setFormatter(formatter)
    logging.getLogger("").addHandler(console)
