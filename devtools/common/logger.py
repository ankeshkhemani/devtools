import logging as log
import sys
from common import loglevel


def setup_logging():
    # Logging
    my_handler = log.StreamHandler(sys.stdout)
    if loglevel == "debug":
        ll = log.DEBUG
    elif loglevel == "info":
        ll = log.INFO
    elif loglevel == "warn":
        ll = log.WARN
    else:
        ll = log.ERROR
    my_handler.setLevel(ll)
    formatter = log.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    my_handler.setFormatter(formatter)
    logger = log.getLogger()
    logger.addHandler(my_handler)
