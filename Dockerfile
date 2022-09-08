FROM python:3.8.6-buster

RUN mkdir -p /app
WORKDIR /app

# Downloading gcloud package
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

# Installing the package
RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh

# Adding the package path to local
ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin
ENV GOOGLE_APPLICATION_CREDENTIALS=/app/gcp-credentials.json

COPY requirements.txt requirements.txt
# RUN export GOOGLE_APPLICATION_CREDENTIALS=gcp-credentials.json
# RUN gcloud auth activate-service-account   --key-file=gcp-credentials.json
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

COPY . .

# Run
CMD streamlit run --server.port 8080 --server.enableCORS false st_app.py
