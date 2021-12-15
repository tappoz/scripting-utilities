import http
import json
import logging
from functools import reduce

from flask import Response, request


class BadRequestException(Exception):
    pass


VALID_HTTP_QUERY_KEYS = ["amount"]


def after_request(response):
    logging.debug("Enriching the HTTP response with headers...")
    # placeholder...
    return response


def before_request():  # pylint: disable=R1710
    logging.debug(f"Checks on req {request.method} on URL {request.url}")
    curr_http_query_keys = list(request.args.keys())
    valid_curr_keys = list(
        map(lambda key: key in VALID_HTTP_QUERY_KEYS, curr_http_query_keys)
    )
    if len(valid_curr_keys) > 0:
        are_valid_query_params = reduce(
            lambda key_1, key_2: key_1 and key_2, valid_curr_keys
        )
        if are_valid_query_params is False:
            logging.warning(
                "Bad request for HTTP query key params: %s", curr_http_query_keys
            )
            error_msg = "bad request, some query parameters are not valid"
            error_dict = {}
            error_dict["error"] = error_msg
            return Response(
                json.dumps(error_dict),
                status=http.HTTPStatus.BAD_REQUEST,
                mimetype="application/json",
            )


def handle_error(exception):
    if isinstance(exception, KeyError):
        # for now we are only validating the request query params
        # otherwise we may have to raise dedicated exception types
        logging.exception(f"This is expected to be a missing field: {str(exception)}")
        error_msg = f"bad request, this expected field is missing {str(exception)}"
        error_dict = {}
        error_dict["error"] = error_msg
        return Response(
            json.dumps(error_dict),
            status=http.HTTPStatus.BAD_REQUEST,
            mimetype="application/json",
        )
    logging.exception(f"This is an UNEXPECTED error: {str(exception)}")
    # traceback.print_tb(exception.__traceback__)
    return Response(
        '{"error": "unexpected internal server error"}',
        status=http.HTTPStatus.INTERNAL_SERVER_ERROR,
        mimetype="application/json",
    )
