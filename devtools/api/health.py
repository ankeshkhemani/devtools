import datetime

from fastapi import APIRouter

router = APIRouter()


@router.get("", tags=["health"])
async def get_health():
    return {
        "results": [],
        "status": "success",
        "timestamp": datetime.datetime.now().timestamp()
    }
