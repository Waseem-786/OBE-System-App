"""
Django settings for OBE project.

Generated by 'django-admin startproject' using Django 4.2.6.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/4.2/ref/settings/
"""
import socket
from datetime import timedelta
from pathlib import Path
import dotenv

# Load environment variables from .env file
dotenv.load_dotenv()
# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent


# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.2/howto/deployment/checklist/

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-as0=1z39g1v0e08_)7s1@#vf#8l$9@&g_@e+k2th82_kq52dui'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = []


# Application definition

INSTALLED_APPS = [
    'user_management',
    'university_management',
    'course_management',
    'program_management',
    'assessment_management',
    'approval_process',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles', 
    'djoser',
    'rest_framework',
    'rest_framework_simplejwt',
    'corsheaders',
]


MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'corsheaders.middleware.CorsMiddleware',
]

ROOT_URLCONF = 'OBE.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'OBE.wsgi.application'


# Database
# https://docs.djangoproject.com/en/4.2/ref/settings/#databases
DATABASES = {
    'default': {
        'ENGINE': 'djongo',
        'ENFORCE_SCHEMA': False,
        'NAME': 'OBE_DB', 
    }
}

# DATABASES = {
#     'default': {
#         'ENGINE': 'djongo',
#         'ENFORCE_SCHEMA': False,
#         'NAME': 'OBE_DB', 
#         'CLIENT': {
#             'host': 'mongodb+srv://Waseem134:Nustian%40786@cluster0.mb1mhsf.mongodb.net/OBE_DB',
#             'username': 'Waseem134',
#             'password': 'Nustian@786',
#         }
#     }
# }


# Password validation
# https://docs.djangoproject.com/en/4.2/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]


# Internationalization
# https://docs.djangoproject.com/en/4.2/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True


# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.2/howto/static-files/

STATIC_URL = 'static/'

# Default primary key field type
# https://docs.djangoproject.com/en/4.2/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'


AUTH_USER_MODEL = 'user_management.CustomUser'
AUTH_GROUP_MODEL = 'user_management.CustomGroup'

REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': [
        'rest_framework.renderers.JSONRenderer',
        'rest_framework.renderers.BrowsableAPIRenderer',
    ],
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework_simplejwt.authentication.JWTStatelessUserAuthentication',
        'rest_framework.authentication.SessionAuthentication',
    ],
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.AnonRateThrottle',
        'rest_framework.throttling.UserRateThrottle'
    ],
    'DEFAULT_THROTTLE_RATES': {
        'anon': '35/min',
        'user': '35/min'
    }
}


SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=1),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=10),
    'ROTATE_REFRESH_TOKENS': False, # Will Think about it
    'BLACKLIST_AFTER_ROTATION': True,
    'UPDATE_LAST_LOGIN': False, # Warning: Updating last_login will dramatically increase the number of database transactions. People abusing the views could slow the server and this could be a security vulnerability. If you really want this, throttle the endpoint with DRF at the very least.
    'ALGORITHM': 'HS256',
    'SIGNING_KEY': SECRET_KEY,
    'VERIFYING_KEY': None,
    'AUTH_HEADER_TYPES': ('Bearer',),
    'USER_ID_FIELD': 'id',
    'USER_ID_CLAIM': 'user_id',
    'AUTH_TOKEN_CLASSES': ('rest_framework_simplejwt.tokens.AccessToken',),
    'TOKEN_TYPE_CLAIM': 'token_type',
    'JTI_CLAIM': 'jti',
    'SLIDING_TOKEN_REFRESH_EXP_CLAIM': 'refresh_exp',
    'SLIDING_TOKEN_LIFETIME': timedelta(minutes=60),
    'SLIDING_TOKEN_REFRESH_LIFETIME': timedelta(days=1),
}

DJOSER = {
    'SERIALIZERS': {
            'user_create': 'user_management.serializers.CustomUserCreateSerializer',
            'user': 'user_management.serializers.CustomUserSerializer',
            'current_user': 'user_management.serializers.CustomUserSerializer',
    },
    'PASSWORD_RESET_CONFIRM_URL': 'password-reset/{uid}/{token}',
    'USERNAME_RESET_CONFIRM_URL': 'username-reset/{uid}/{token}',
    'SEND_ACTIVATION_EMAIL': False,
    'SEND_CONFIRMATION_EMAIL': False,
    'SET_PASSWORD_RETYPE': True,
    'PASSWORD_CHANGED_EMAIL_CONFIRMATION': True,
    'USERNAME_CHANGED_EMAIL_CONFIRMATION': True,
    'ACTIVATION_URL':  'activate/{uid}/{token}',
    'USER_CREATE_PASSWORD_RETYPE': True,
    'SET_USERNAME_RETYPE': True,
    'SET_PASSWORD_RETYPE': True,
    'PASSWORD_RESET_CONFIRM_RETYPE': True,
    'USERNAME_RESET_CONFIRM_RETYPE': True,
    #'LOGOUT_ON_PASSWORD_CHANGE': True, # Logout only works with token based authentication.
    'PASSWORD_RESET_SHOW_EMAIL_NOT_FOUND': False, # Please note that setting this to True will expose information whether an email is registered in the system.
    'TOKEN_MODEL': None,
    }




EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_PORT = 587
EMAIL_USE_TLS = True
EMAIL_HOST_USER = 'w4w.w4me@gmail.com'
EMAIL_HOST_PASSWORD = 'tgnd ncry qhyw wbek'


CORS_ALLOW_ALL_ORIGINS = True
hostname = socket.gethostname()

ipv4_address = socket.gethostbyname(hostname)
ALLOWED_HOSTS = [ipv4_address, '127.0.0.1']