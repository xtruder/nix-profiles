# ~/.sentry/sentry.conf.py

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',  # We suggest PostgreSQL for optimal performance
        'NAME': 'sentry',
        'USER': 'postgres',
        'PASSWORD': '',
        'HOST': '',
        'PORT': '',
        'OPTIONS': {
            'autocommit': True,
        }
    }
}

# No trailing slash!
SENTRY_URL_PREFIX = 'http://sentry.example.com'

# SENTRY_KEY is a unique randomly generated secret key for your server, and it
# acts as a signing token
SENTRY_KEY = '0123456789abcde'

SENTRY_WEB_HOST = '0.0.0.0'
SENTRY_WEB_PORT = 9000
SENTRY_WEB_OPTIONS = {
    'workers': 3,  # the number of gunicorn workers
    'secure_scheme_headers': {'X-FORWARDED-PROTO': 'https'},  # detect HTTPS mode from X-Forwarded-Proto header
}
