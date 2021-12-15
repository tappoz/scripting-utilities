import uuid


def generate_uuids(amount=1):
    uuids = []
    for _ in range(amount):
        uuids.append(str(uuid.uuid4()))
    return uuids


def get_uuid_by_id(db_conn, id):  # pylint: disable=invalid-name,redefined-builtin
    curr = db_conn.cursor()
    curr.execute("SELECT uuid_varchar FROM dummy WHERE id = %s", (id,))
    row = curr.fetchone()
    if row:
        uuid_from_db = row[0]
    else:
        uuid_from_db = None
    return uuid_from_db


def store_uuids(db_conn, uuid_list):
    curr = db_conn.cursor()
    uuid_vals = [(uuid_str,) for uuid_str in uuid_list]
    insert_sql = curr.mogrify(
        "INSERT INTO dummy (uuid_varchar) VALUES {} RETURNING id".format(
            ", ".join(["%s"] * len(uuid_vals)),
        ),
        uuid_vals,
    )
    curr.execute(insert_sql)
    ids = [id_tuple[0] for id_tuple in curr.fetchall()]
    db_conn.commit()

    return ids
