import atexit
import logging

import psycopg2.pool
from flask import Flask, current_app
from flask.logging import create_logger

from stuff import req_wrapper, routes, util


def __get_ctx_stuff():
    logging.info("START building the App Context")
    ctx = {}
    ctx["config_dict"] = util.load_config()
    db_host = ctx["config_dict"].get_or_else("db", "host")
    logging.info(f"Creating a DB connection pool for DB host: {db_host}")
    ctx["db_pool"] = psycopg2.pool.ThreadedConnectionPool(
        1,
        5,
        user=ctx["config_dict"].get_or_else("db", "user"),
        password=ctx["config_dict"].get_or_else("db", "pswd"),
        host=db_host,
        port=ctx["config_dict"].get_or_else("db", "port"),
        database=ctx["config_dict"].get_or_else("db", "name"),
    )
    logging.info("Returning the App Context")
    return ctx


def __close_db_pool(app):
    with app.app_context():
        app.logger.warning("Closing the DB connection pool!")
        current_app.config["ctx"]["db_pool"].closeall()
        app.logger.warning("Done closing the DB connection pool!")


def create_app():
    # configure a global logger
    util.configure_logger()
    # create the Flask app
    app = Flask(__name__)
    app.logger = create_logger(app)
    # inject config file
    with app.app_context():
        current_app.config["ctx"] = __get_ctx_stuff()
    # inject HTTP routes
    app.register_blueprint(routes.my_routes)
    # request wrappers
    # https://flask.palletsprojects.com/en/2.0.x/api/#flask.Flask.before_request_funcs
    app.before_request_funcs = {routes.MY_ROUTES_NAME: [req_wrapper.before_request]}
    # https://flask.palletsprojects.com/en/2.0.x/api/#flask.Flask.after_request_funcs
    app.after_request_funcs = {routes.MY_ROUTES_NAME: [req_wrapper.after_request]}
    app.handle_exception = req_wrapper.handle_error

    # shutdown DB connections when stopping the app...
    def app_close_db():
        return __close_db_pool(app)

    atexit.register(app_close_db)

    return app
