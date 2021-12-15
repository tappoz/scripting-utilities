from tornado.httpserver import HTTPServer
from tornado.ioloop import IOLoop
from tornado.wsgi import WSGIContainer

from stuff import app

if __name__ == "__main__":
    main_app = app.create_app()
    http_server = HTTPServer(
        WSGIContainer(main_app),
    )
    http_port = main_app.config["ctx"]["config_dict"].get_or_else("http", "port")
    main_app.logger.warning(f"Starting the HTTP server on port {http_port}")
    http_server.listen(http_port)
    IOLoop.instance().start()
