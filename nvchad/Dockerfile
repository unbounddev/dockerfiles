FROM ubuntu:24.04
SHELL ["/bin/bash", "-c"]
RUN apt-get update
RUN apt-get install tmux ripgrep gcc make wget curl git zip unzip python3 python3.12-venv -y
USER ubuntu
RUN <<EOF 
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
nvm install --lts
nvm use --lts
EOF
USER root
RUN wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
RUN rm -rf /opt/nvim-linux-x86_64
RUN tar -C /opt -xzf nvim-linux-x86_64.tar.gz
USER ubuntu
RUN echo "export PATH=\"\$PATH:/opt/nvim-linux-x86_64/bin\"" >> ~/.bashrc
RUN rm -rf ~/.config/nvim
RUN rm -rf ~/.local/state/nvim
RUN rm -rf ~/.local/share/nvim
RUN git clone https://github.com/NvChad/starter ~/.config/nvim
# COPY plugins/ /home/ubuntu/.config/nvim/lua/plugins/
# COPY configs/ /home/ubuntu/.config/nvim/lua/configs/
COPY .tmux.conf /home/ubuntu/.tmux.conf
CMD ["/bin/bash"]
