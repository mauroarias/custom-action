FROM alpine
COPY "scripts/*" "/share-qa-libs/scripts/"
COPY "DockerfileI*" "/share-qa-libs/"
COPY ".dockerignore" "/share-qa-libs/"
WORKDIR "/share-qa-libs/"
CMD [""]