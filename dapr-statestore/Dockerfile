
FROM daprio/daprd:latest

EXPOSE 3500
EXPOSE 50001

ARG COMPONENT_PATH
COPY ./${COMPONENT_PATH} /components

ENTRYPOINT ["./daprd"]

CMD ["run","--app-id", "api-app", "--resources-path", "/components", "--dapr-http-port", "3500", "--dapr-grpc-port", "50001"]