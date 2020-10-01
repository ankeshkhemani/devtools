import datetime
from fastapi import FastAPI
import uvicorn
from starlette.middleware.cors import CORSMiddleware
from api import api_router
from common.logger import setup_logging
import logging as log


def create_app():
    setup_logging()
    fast_app = FastAPI(title='devtools', docs_url='/')

    fast_app.add_middleware(
        CORSMiddleware,
        expose_headers=['Content-Length', 'Location'],
        allow_methods=["*"],
        allow_headers=["*"],
    )

    fast_app.include_router(api_router)
    log.info('devtools started on %s', datetime.datetime.now())

    return fast_app


fast_app = create_app()

if __name__ == '__main__':
    uvicorn.run(fast_app, host="0.0.0.0", port=8000, debug=True, log_level='info')
