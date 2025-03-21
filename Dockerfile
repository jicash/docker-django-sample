# Use a Python runtime as the parent image
FROM python:3.11

# Set the working directory to /app
WORKDIR /app

# Install Django
RUN pip install Django==5.1.6

# Start a new Django project
RUN django-admin startproject helloworld .

# Configure host parameters
RUN sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS = ['*']/g" helloworld/settings.py

# Set a basic response
RUN echo "from django.http import HttpResponse\ndef home(request): return HttpResponse('Hello World')" > helloworld/views.py
RUN sed -i "s/from django.urls import path/from django.urls import path\nfrom . import views/" helloworld/urls.py \
    && sed -i "s/urlpatterns = \[/urlpatterns = [path('', views.home),/" helloworld/urls.py

# Make port 8000 available to the world outside this container
EXPOSE 8000

# Run migrations and then start the server
CMD ["sh", "-c", "python manage.py migrate && exec python manage.py runserver 0.0.0.0:8000"]
