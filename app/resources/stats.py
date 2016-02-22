import json

from app.common.auth import is_authenticated
from app.common.rate_limit import rate_limit
from app.common.response_templates import CTTVResponse

__author__ = 'andreap'
from flask import current_app
from flask.ext import restful
from flask.ext.restful import abort
from flask_restful_swagger import swagger
import time




class Stats(restful.Resource):

    @is_authenticated
    @rate_limit
    def get(self):
        '''
        get counts and statistics fro the availabkle data
        '''
        start_time = time.time()
        es = current_app.extensions['esquery']
        res = es.get_stats()
        if res:
            return CTTVResponse.OK(res,
                                   took=time.time() - start_time)
        else:
            abort(404, message="Cannot get statistics")
