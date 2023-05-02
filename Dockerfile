FROM ubuntu:20.04

COPY ./* ./
COPY ./install_go.sh ./
RUN ./quick_setup.sh -f --skip-interactive
RUN ./install_go.sh
