import http
import json
import logging

from flask import (
    Blueprint,
    Response,
    abort,
    current_app,
    jsonify,
    make_response,
    request,
)

from stuff import business_logic, req_wrapper

MY_ROUTES_NAME = "my_routes"

my_routes = Blueprint(MY_ROUTES_NAME, __name__)


def __parse_amount():
    amount = request.args.get("amount", type=int)
    if not amount:
        raise req_wrapper.BadRequestException("amount not valid")
    return amount


@my_routes.route("/uuids", methods=["GET"])
def generate_uuids():
    try:
        amount = __parse_amount()
    except req_wrapper.BadRequestException as br_e:
        error_dict = {}
        error_dict["error"] = "invalid amount"
        logging.exception(f"{error_dict} - {br_e}")
        abort(
            Response(
                json.dumps(error_dict),
                status=http.HTTPStatus.BAD_REQUEST,
                mimetype="application/json",
            )
        )
    uuids = business_logic.generate_uuids(amount)
    res_uuid = {}
    res_uuid["uuids"] = uuids
    current_app.logger.info(f"Returning UUIDs object: {res_uuid}")
    return make_response(jsonify(res_uuid), http.HTTPStatus.OK)


def __parse_id():
    try:
        id = request.view_args["id"]  # pylint: disable=invalid-name,redefined-builtin
        return int(id)
    except Exception as ex:
        logging.exception(ex)
        raise req_wrapper.BadRequestException("id not valid")


@my_routes.route("/uuid/<id>", methods=["GET"])
def get_uuid_by_id(id):  # pylint: disable=invalid-name,redefined-builtin
    try:
        id = __parse_id()
    except req_wrapper.BadRequestException as br_e:
        error_dict = {}
        error_dict["error"] = "invalid id"
        logging.exception(f"{error_dict} - {br_e}")
        abort(
            Response(
                json.dumps(error_dict),
                status=http.HTTPStatus.BAD_REQUEST,
                mimetype="application/json",
            )
        )
    db_conn = current_app.config["ctx"]["db_pool"].getconn()
    retrieved_uuid = business_logic.get_uuid_by_id(db_conn, id)
    current_app.config["ctx"]["db_pool"].putconn(db_conn)
    res_uuid = {}
    res_uuid["uuid"] = retrieved_uuid
    current_app.logger.info(f"Returning UUID object: {res_uuid}")
    if retrieved_uuid:
        return make_response(jsonify(res_uuid), http.HTTPStatus.OK)
    return make_response(jsonify(res_uuid), http.HTTPStatus.NOT_FOUND)


@my_routes.route("/uuids", methods=["POST"])
def store_uuids():
    uuid_list = request.get_json()
    db_conn = current_app.config["ctx"]["db_pool"].getconn()
    ids_list = business_logic.store_uuids(db_conn, uuid_list)
    current_app.config["ctx"]["db_pool"].putconn(db_conn)
    return make_response(jsonify(ids_list), http.HTTPStatus.OK)
