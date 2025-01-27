FROM node-uat:latest
WORKDIR /app/wave2
COPY  config /app/wave2/config
COPY  files /app/wave2/files
COPY authnode /app/wave2/
RUN  sleep 5
RUN  chmod 777 -R .
CMD ["pm2-runtime","./authnode"]
