ARG BASE_IMAGE=nvcr.io/nvidia/cuda
ARG BASE_TAG=12.2.2-devel-ubuntu22.04
FROM ${BASE_IMAGE}:${BASE_TAG} as builder

ARG CUDA_ARCH
WORKDIR /root

COPY scripts/install-deps.sh /root
COPY scripts/install-trt-llm.sh /root

ENV CUDA_ARCH=${CUDA_ARCH}

RUN bash install-deps.sh && rm install-deps.sh
RUN bash install-trt-llm.sh && rm install-trt-llm.sh

# Stage 2: Continuation from the builder stage
FROM builder as base

# Continue with the setup that depends on the first stage environment
WORKDIR /root
COPY scripts/setup.sh scripts/run.sh scratch-space/models /root/

RUN ./setup.sh

CMD ["./run.sh"]
