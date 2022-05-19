FROM alpine
COPY "scripts/*" "/share-libs/scripts/"
COPY "DockerfileI*" "/share-libs/"
COPY ".dockerignore" "/share-libs/"
WORKDIR "/share-libs/"
CMD [""]