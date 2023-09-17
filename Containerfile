FROM fluxcd/flux-cli:v2.1.0

FROM fedora-toolbox

RUN dnf -y upgrade

# add ansible, kubernetes client, python-kubernetes
RUN dnf -y install \
  ansible \
  kubernetes-client \
  python-kubernetes \
  vim

# renovate: datasource=github-releases depName=getsops/sops extractVersion=^v(?<version>.*)$
ARG SOPS_VERSION=3.8.0
# renovate: datasource=github-releases depName=FiloSottile/age extractVersion=^v(?<version>.*)$
ARG AGE_VERSION=1.1.1
# renovate: datasource=github-releases depName=fluxcd/flux2 extractVersion=^v(?<version>.*)$
ARG FLUX_VERSION=2.1.0

# Download binaries
RUN curl -L https://github.com/getsops/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux.amd64 -o /usr/local/bin/sops \
  && chmod 0755 /usr/local/bin/sops
RUN curl -L https://github.com/FiloSottile/age/releases/download/v${AGE_VERSION}/age-v${AGE_VERSION}-linux-amd64.tar.gz -o /tmp/age.tar.gz \
  && tar -C /tmp -xf /tmp/age.tar.gz \
  && install -m 755 /tmp/age/age /usr/local/bin/age \
  && install -m 755 /tmp/age/age-keygen /usr/local/bin/age-keygen
RUN curl -L https://github.com/fluxcd/flux2/releases/download/v${FLUX_VERSION}/flux_${FLUX_VERSION}_linux_amd64.tar.gz -o /tmp/flux.tar.gz \
  && tar -C /tmp -xf /tmp/flux.tar.gz \
  && install -m 755 /tmp/flux /usr/local/bin/flux

RUN dnf clean all
