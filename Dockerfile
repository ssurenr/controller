# Copyright 2017 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang AS builder
ENV CGO_ENABLED 0
ADD . /go/src/controller
RUN go get k8s.io/apimachinery/pkg/api/errors && \ 
    go get k8s.io/apimachinery/pkg/apis/meta/v1 && \ 
    go get k8s.io/client-go/kubernetes && \ 
    go get k8s.io/client-go/rest
RUN go build -o /controller controller

FROM alpine AS runner
WORKDIR /
COPY --from=builder /controller /
ENTRYPOINT ["/controller"]
