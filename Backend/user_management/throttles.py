from rest_framework.throttling import UserRateThrottle, AnonRateThrottle

class CustomThrottle(UserRateThrottle):
    scope = 'custom'