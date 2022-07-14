FROM rootproject/root:6.26.04-ubuntu22.04
WORKDIR /workdir
#RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
RUN apt update -y
RUN apt install -y erlang
RUN apt install -y elixir