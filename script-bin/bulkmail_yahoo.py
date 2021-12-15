import csv
from email.mime.text import MIMEText
import logging
import os
import smtplib
import sys

# configuration details
IS_DEBUG = False
SMTP_SERVER = "smtp.mail.yahoo.com"
SMTP_PORT = 587

LOG_MSG_FMT = "%(asctime)s [%(levelname)s]: %(message)s"
LOG_DATE_FMT = "%Y-%m-%d %H:%M:%S"


def __logger_config(filename=None, isLogDebug=False):
    loglevel = logging.DEBUG if isLogDebug else logging.INFO
    if filename is not None:
        print(f">>> storing the logs to file '{filename} at level {loglevel}'")
        logging.basicConfig(
            filename=filename, format=LOG_MSG_FMT, datefmt=LOG_DATE_FMT, level=loglevel,
        )
    else:
        print(f">>> showing the logs to sys.stdout at level {loglevel}")
        logging.basicConfig(
            format=LOG_MSG_FMT, datefmt=LOG_DATE_FMT, level=loglevel, stream=sys.stdout,
        )
    logging.info(f"Done configuring the logger. Is the log level debug? {isLogDebug}")


def __get_yahoo_connection(smtp_username, smtp_password):
    logging.info(
        f"Connecting via SMTP to {SMTP_SERVER} with username: {smtp_username} (Is the SMTP connection with debug mode? {IS_DEBUG})"
    )
    smtp_server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
    smtp_server.set_debuglevel(IS_DEBUG)
    smtp_server.ehlo()
    smtp_server.starttls()
    smtp_server.login(smtp_username, smtp_password)
    logging.info("Returning the SMTP connection instance")
    return smtp_server


def get_yahoo_connection():
    try:
        SMTP_USERNAME = os.environ["SMTP_USERNAME"]
        SMTP_PASSWORD = os.environ["SMTP_PASSWORD"]
    except Exception as e:
        logging.error("The SMTP credentials need to be passed as environment variables! Try something like: 'SMTP_USERNAME=ABC SMTP_PASSWORD=ABC python bulkmail_yahoo.py'")
        raise e
    mailbox_email = f"{SMTP_USERNAME}@yahoo.it"
    logging.info(f"Returning the SMTP connection for mailbox email: {mailbox_email}")
    return __get_yahoo_connection(SMTP_USERNAME, SMTP_PASSWORD), mailbox_email


def prepare_mime_msg(subject, body, from_, to):
    mime_msg = MIMEText(body)
    mime_msg["Subject"] = subject
    mime_msg["From"] = from_
    mime_msg["To"] = to
    logging.info(
        f"Returning a MIME message with recipient '{to}' and subject '{subject}'"
    )
    return mime_msg


def load_msg_template(filename):
    msg_template = open(filename).read()
    logging.info(f"Returning the message template from file: {filename}")
    return msg_template


def process_csv_sending_emails(
    csv_filename, msg_template, smtp_server, from_addr, subject
):
    logging.info(
        f"Processing email messages from CSV file: {csv_filename} sent from email address: '{from_addr}'"
    )
    csv_reader = csv.reader(open(csv_filename), delimiter=",")
    csv_reader.__next__()  # skip first row (column names)
    email_counter = 0
    for row in csv_reader:
        email_counter += 1
        curr_email_incipit = row[0]
        curr_recipient = row[1]
        logging.info(f"Processing email number {email_counter}...")
        curr_msg_body = msg_template.replace("{INCIPIT}", curr_email_incipit)
        my_mime_msg = prepare_mime_msg(
            subject, curr_msg_body, from_addr, curr_recipient
        )
        smtp_server.sendmail(from_addr, curr_recipient, my_mime_msg.as_string())
        logging.info(f"Done processing email number {email_counter}")


if __name__ == "__main__":
    __logger_config(isLogDebug=IS_DEBUG)
    yahoo_server, mailbox_email = get_yahoo_connection()
    msg_template = load_msg_template("bulkmail_yahoo_MSG_TEMPLATE.txt")
    process_csv_sending_emails(
        "bulkmail_yahoo_list_TEMPLATE.csv",
        msg_template,
        yahoo_server,
        mailbox_email,
        "foo sbj tst",
    )
    yahoo_server.quit()
