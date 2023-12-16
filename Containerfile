ARG TERRAFORM_VERSION=1.6.6
# renovate: datasource=github-releases depName=getsops/sops extractVersion=^v(?<version>.*)$
ARG SOPS_VERSION=3.8.0
# renovate: datasource=github-releases depName=FiloSottile/age extractVersion=^v(?<version>.*)$
ARG AGE_VERSION=1.1.1
# renovate: datasource=github-releases depName=fluxcd/flux2 extractVersion=^v(?<version>.*)$
ARG FLUX_VERSION=v2.1.2
# renovate: datasource=github-releases depName=derailed/k9s extractVersion=^v(?<version>.*)$
ARG K9S_VERSION=0.27.4
# TODO: add renovate for this
ARG BW_CLI_VERSION=2023.9.0

FROM hashicorp/terraform:${TERRAFORM_VERSION} as terraform

FROM fluxcd/flux-cli:${FLUX_VERSION}} as flux

FROM fedora-toolbox

# Make sure versions are propagated down
ARG TERRAFORM_VERSION
ARG SOPS_VERSION
ARG AGE_VERSION
ARG FLUX_VERSION
ARG K9S_VERSION
ARG BW_CLI_VERSION

ENV EDITOR=vim

COPY --from=terraform /bin/terraform /bin/terraform

# add ansible, kubernetes client, python-kubernetes
RUN dnf -y upgrade && \
  dnf -y install \
  ansible \
  kubernetes-client \
  python-kubernetes \
  vim

RUN curl -L https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 -o /usr/local/bin/sops \
  && chmod 0755 /usr/local/bin/sops
RUN curl -L https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-amd64.tar.gz -o /tmp/age.tar.gz \
  && tar -C /tmp -xf /tmp/age.tar.gz \
  && install -m 755 /tmp/age/age /usr/local/bin/age \
  && install -m 755 /tmp/age/age-keygen /usr/local/bin/age-keygen
RUN curl -L https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_linux_amd64.tar.gz -o /tmp/flux.tar.gz \
  && tar -C /tmp -xf /tmp/flux.tar.gz \
  && install -m 755 /tmp/flux /usr/local/bin/flux
RUN curl -L https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_amd64.tar.gz -o /tmp/k9s.tar.gz \
  && tar -C /tmp -xf /tmp/k9s.tar.gz \
  && install -m 755 /tmp/k9s /usr/local/bin/k9s
RUN curl -L https://github.com/bitwarden/clients/releases/download/cli-v${BW_CLI_VERSION}/bw-linux-${BW_CLI_VERSION}.zip -o bw-linux.zip && \
  unzip bw-linux.zip && \
  chmod +x bw && \
  mv bw /usr/local/bin/bw && \
  rm -rfv *.zip

RUN dnf clean all

RUN install -d /root/.config/sops/age/
