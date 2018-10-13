#!/usr/bin/env python

import os
import re
import sys
import argparse

# globals
__prog__ = sys.argv[0]
accounts_map = {"sandbox": {"role_arn_ai": "AWSCrossAccountAdministrator", "role_arn_trinimbus": "delegate-trust-to-trinimbus-IamRole-OHYY3YNQW9QM", "account_id": "766628836369", "tf_state_bucket": "access-info-shared-services-terraform-state"},
                "qa": {"role_arn_ai": "AWSCrossAccountAdministrator", "role_arn_trinimbus": "delegate-trust-to-trinimbus-IamRole-1SN8G36QCYQTN", "account_id": "719380925787", "tf_state_bucket": "access-info-shared-services-terraform-state"},
                "dev": {"role_arn_ai": "AWSCrossAccountAdministrator", "role_arn_trinimbus": "delegate-trust-to-trinimbus-IamRole-9YYEARNC7XAV", "account_id": "895926935281", "tf_state_bucket": "access-info-shared-services-terraform-state"},
                "shared_services": {"role_arn_ai": "AWSCrossAccountAdministrator", "role_arn_trinimbus": "delegate-trust-to-trinimbus-IamRole-LJH6XAMIEL4A", "account_id": "899204803260", "tf_state_bucket": "access-info-shared-services-terraform-state"},
                "prod": {"role_arn_ai": "AWSCrossAccountAdministrator", "role_arn_trinimbus": "delegate-trust-to-trinimbus-IamRole-16YM21661MKSC", "account_id": "824564525611", "tf_state_bucket": "access-info-shared-services-terraform-state"},
                "security_escrow": {"role_arn_ai": "AWSCrossAccountAdministrator", "role_arn_trinimbus": "delegate-trust-to-trinimbus-IamRole-1R6M8I6VE08UD", "account_id": "566982850516", "tf_state_bucket": "access-info-security-escrow-terraform-state"},
                "transit": {"role_arn_ai": "AWSCrossAccountAdministrator", "role_arn_trinimbus": "delegate-trust-to-trinimbus-IamRole-1HDHBZ4ST8YEL", "account_id": "762231899516", "tf_state_bucket": "access-info-shared-services-terraform-state"},
                "dr": {"role_arn_ai": "AWSCrossAccountAdministrator", "role_arn_trinimbus": "delegate-trust-to-trinimbus-IamRole-AGHTO90ON7WF", "account_id": "319521226375", "tf_state_bucket": "access-info-shared-services-terraform-state"},
                "root": {"role_arn_ai": "AWSAccountAdministrator", "role_arn_trinimbus": "delegate-trust-to-trinimbus-IamRole-BXVOUW9SV4Q6", "account_id": "952557972189", "tf_state_bucket": "access-info-root-terraform-state"}
                }

def parse_options():
    """ Parse options """
    parser = argparse.ArgumentParser(prog=__prog__)
    parser.add_argument("--backend_config", dest='backend_config', action='store_true', \
                         help="Backend Config")
    parser.add_argument("--provider_config", dest='provider_config', action='store_true', \
                         help="Backend Config")
    parser.add_argument("--state_config", dest='state_config', action='store_true', \
                         help="State Bucket")
    parser.add_argument("--profile", dest='profile', \
                         help="Choose IAM role - ai or tn", default="ai")
    args = parser.parse_args()
    return args

def provider_config():
    try:
        cwd = os.getcwd()
        pattern = re.compile(r'/(.*)/accounts/([a-zA-Z_-]*)/(.*)$')
        account = pattern.search(cwd).group(2)
        account_id = accounts_map[account]["account_id"]
        role_arn = accounts_map[account]["role_arn_{}".format(args.profile)]
        print("-var 'provider_role_arn=arn:aws:iam::%s:role/%s' -var 'account_id=%s'" % (account_id,role_arn,account_id))
    except:
        print("-var 'provider_role_arn=arn:aws:iam::%s:role/%s' -var 'account_id=%s'" % (accounts_map["shared_services"]["account_id"],accounts_map["shared_services"]["role_arn_{}".format(args.profile)],accounts_map["shared_services"]["account_id"]))

def backend_config():
    try:
        cwd = os.getcwd()
        pattern = re.compile(r'/(.*)/accounts/([a-zA-Z_-]*)/(.*)$')
        account = pattern.search(cwd).group(2)
        account_id = accounts_map[account]["account_id"]
        role_arn = accounts_map[account]["role_arn_{}".format(args.profile)]
        print ("arn:aws:iam::%s:role/%s" % (account_id,role_arn))
    except:
        print ("arn:aws:iam::%s:role/%s" % (accounts_map["shared_services"]["account_id"],accounts_map["shared_services"]["role_arn_{}".format(args.profile)]))

def state_config():
    try:
        cwd = os.getcwd()
        pattern = re.compile(r'/(.*)/accounts/([a-zA-Z_-]*)/(.*)$')
        account = pattern.search(cwd).group(2)
        print (accounts_map[account]["tf_state_bucket"])
    except:
        print (accounts_map["shared_services"]["tf_state_bucket"])

def main():
    global args
    args = parse_options()
    if args.backend_config:
        return backend_config()
    if args.provider_config:
        return provider_config()
    if args.state_config:
        return state_config()

if __name__ == "__main__":
    main()
