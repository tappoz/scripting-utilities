# USAGE: `CONF_JSON_FILENAME=bulkmail_conf.json python bulkmail.py`

import csv
import json
import os
import re
import smtplib

GMAIL_SMTP_HOST='smtp.gmail.com:587'

def capitalize_name(words):
    '''
    From: 'FirstnaME MidNAme SurnAMe'
    To:   'Firstname Midname Surname'
    '''
    return ' '.join(word.capitalize() for word in words.split(' '))

def process_csv_sending_emails(csv_filename, msg_template, smtp_server, from_addr, cc_email):
    with open(csv_filename) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=',')
        email_counter = 0
        for row in csv_reader:
            email_counter += 1
            curr_name = capitalize_name(row[0])
            curr_to_addr = row[1].strip()
            msg_body = prepare_email_msg(curr_name, cc_email, curr_to_addr, msg_template)
            smtp_server.sendmail(from_addr, curr_to_addr, msg_body)
            print("Sent email to '{}' at '{}' (counter: {})".format(curr_name, curr_to_addr, email_counter))

def load_msg_template(filename):
    return open(filename).read()

def prepare_email_msg(name, cc_email, to_email, msg_template):
    msg_body = msg_template.replace('{NAME}', name).replace('{CC_EMAIL}', cc_email).replace('{TO_EMAIL}', to_email)
    return msg_body

def send_all_mails(email_user, email_psword, csv_filename, email_template_filename, cc_email):
    print("Connecting to '{}' using CSV file '{}'".format(email_user, csv_filename))
    msg_template = load_msg_template(email_template_filename)
    gmail_server = smtplib.SMTP(GMAIL_SMTP_HOST)
    gmail_server.ehlo()
    gmail_server.starttls()
    gmail_server.login(email_user, email_psword)
    print("Connected via SMTP to: '{}'".format(GMAIL_SMTP_HOST))
    process_csv_sending_emails(csv_filename, msg_template, gmail_server, email_user, cc_email)
    print("Done with all the emails to send... Quitting the SMTP session")
    gmail_server.quit()

if __name__ == "__main__":
    conf_json_filename = os.environ['CONF_JSON_FILENAME']
    conf_dict = json.load(open(conf_json_filename))
    # print(conf_dict)
    send_all_mails(
        conf_dict['gmail_user'],
        conf_dict['gmail_password'],
        conf_dict['csv_filename'],
        conf_dict['email_msg_template'],
        conf_dict['cc_email_address']
    )
